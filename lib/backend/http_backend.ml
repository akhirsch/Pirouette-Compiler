let ( let* ) = Result.bind
let ( let** ) = Lwt.bind
let ( let**? ) = Lwt_result.bind

(*---------------------------------------------------------------------------*)
(* State                                                                     *)
(*---------------------------------------------------------------------------*)

(* TODO: How can i namespace these types to avoid collisions (only expose `send`, `recv`, etc.)? *)
type participant = { name : string; hostname : Uri.t }
(** A participant in the system with their debug_name (NetIR name) and hostname
    (IP address + port). *)

type message_type = Send | Choose  (** An incoming message from a peer. *)

(** Convert HTTP path string to optional `message_type` *)
let message_type_from_string = function
  | "/send" -> Some Send
  | "/choose" -> Some Choose
  | _ -> None

(** Convert `message_type` to HTTP path string *)
let message_type_to_string = function Send -> "/send" | Choose -> "/choose"

type message = message_type * string

type message_completion = bool Lwt_condition.t
(** Indicates the message was received. If given `true`, the result processed
    successfully; else, we have a `/send` vs `/choose` mismatch *)

type peer = {
  hostname : Uri.t;
  message_channel : (message * message_completion) Lwt_mvar.t;
}
(** A peer has a debug name and a channel to receive messages on. *)

type state = {
  self : participant;  (** Information about this participant *)
  name_to_peer : (string, peer) Hashtbl.t;
      (** Each location name mapped to a peer *)
}
(** The app's shared global state. *)

(*---------------------------------------------------------------------------*)
(* Errors                                                                    *)
(*---------------------------------------------------------------------------*)

type participant_parse_error = NoDebugName | InvalidHostname

let participant_error_to_string = function
  | NoDebugName -> "debug name -- expected <debug name>=<hostname>"
  | InvalidHostname -> "hostname"

type init_error =
  | LessThanTwoArgs
  | InvalidParticipant of participant_parse_error * string

let init_error_to_string = function
  | LessThanTwoArgs ->
      "Expected at least 2 arguments: <self_name>=<self_hostname> \
       <participant1_name>=<participant1_hostname> ..."
  | InvalidParticipant (parse_error, raw_participant) ->
      Printf.sprintf "Invalid participant %s: '%s'"
        (participant_error_to_string parse_error)
        raw_participant

type client_error =
  | MethodNotPost  (** We only allow POST for send/choose *)
  | UnknownPath  (** We only allow `/send` and `/choose` *)
  | MissingOrigin  (** We need the `Origin` header to identify the peer *)
  | UnknownPeer  (** Peer must be registered *)
  | CannotMessageTwice  (** Cannot message twice *)

let client_result_to_http_status = function
  | Result.Ok true -> `OK
  | Result.Error MethodNotPost -> `Method_not_allowed
  | Result.Error UnknownPath -> `Not_found
  | Result.Error UnknownPeer -> `Unauthorized
  | Result.Ok false
  | Result.Error MissingOrigin
  | Result.Error CannotMessageTwice ->
      `Bad_request

type http_get_error = InvalidSourcePeer | WrongMessageType of message_type

let http_get_error_to_string = function
  | InvalidSourcePeer -> "invalid peer"
  | WrongMessageType received ->
      (* Calculate expected type *)
      let expected = match received with Send -> Choose | Choose -> Send in
      (* Format *)
      Printf.sprintf "expected %s but the peer sent %s"
        (message_type_to_string expected)
        (message_type_to_string received)

type http_post_error = InvalidDestPeer | BadStatus of Http.Status.t

let http_post_error_to_string = function
  | InvalidDestPeer -> "invalid peer"
  | BadStatus status ->
      "peer responded with unexpected status: " ^ Http.Status.to_string status

(*---------------------------------------------------------------------------*)
(* Initialization                                                            *)
(*---------------------------------------------------------------------------*)

(** Parse participants from command-line args *)
let create_state () : (state, init_error) result =
  (* Parse an individual participant string *)
  let parse_participant (str : string) : (participant, init_error) result =
    (* Get debug name and hostname *)
    let* name, raw_hostname =
      String.split_first ~sep:"=" str
      |> Option.to_result ~none:(InvalidParticipant (NoDebugName, str))
    in
    (* Parse and ensure host is given *)
    let full_hostname = Uri.of_string raw_hostname in
    let* host =
      Uri.host full_hostname
      |> Option.to_result ~none:(InvalidParticipant (InvalidHostname, str))
    in
    (* Strip hostname, keeping only the scheme, host and port (if given) *)
    let hostname =
      Uri.make ~scheme:"http" ~host ?port:(Uri.port full_hostname) ()
    in
    Result.Ok { name; hostname }
  in
  (* Parse each participant, or return failure *)
  let* participants : participant list =
    (* Drop program name (first arg), and then parse each participant. *)
    Sys.argv |> Array.to_list |> List.tl
    |> List.fold_left
         (fun acc (raw_participant : string) ->
           (* Parse new participant if previous ones succeeded *)
           let* prev_list = acc in
           let* participant = parse_participant raw_participant in
           Result.Ok (prev_list @ [ participant ]))
         (Result.Ok [])
  in
  (* Decompose participants into `self` and our peers *)
  let* self, peers =
    match participants with
    | [] | [ _ ] -> Result.Error LessThanTwoArgs
    | first :: rest -> Result.Ok (first, rest)
  in
  (* Create map from name -> peer *)
  let name_to_peer : (string, peer) Hashtbl.t =
    peers |> List.to_seq
    |> Seq.map (fun (p : participant) ->
        ( p.name,
          { hostname = p.hostname; message_channel = Lwt_mvar.create_empty () }
        ))
    |> Hashtbl.of_seq
  in
  (* We will add to messages with the server *)
  let state = { self; name_to_peer } in
  Result.Ok state

(** The global state containing our identity & peer information, and used to
    track HTTP requests *)
let _app_state =
  (* Get state, or trap *)
  match create_state () with
  | Ok state -> state
  | Error err ->
      failwith ("HTTP Backend init failed: " ^ init_error_to_string err)

(** Get the participant with the given destination name *)
let get_participant (destination : string) : participant =
  let peer =
    match Hashtbl.find_opt _app_state.name_to_peer destination with
    | Some peer -> peer
    | None -> failwith ("HTTP backend hasn't registered '" ^ destination ^ "'")
  in
  { name = destination; hostname = peer.hostname }

(*---------------------------------------------------------------------------*)
(* HTTP Get/Post                                                         *)
(*---------------------------------------------------------------------------*)

(** Retries if the connection fails (retries every 0.05 s, deadline is 10 s).

    FIXME: We only catch `ECONNREFUSED`, so a peer that dies *mid-request*
    escapes as `Cohttp_lwt__Connection.Retry` instead. Observed in a test run
    where one participant died of `EADDRINUSE`: its peer crashed with a bare
    `Fatal error: exception Cohttp_lwt__Connection.Retry`, naming a
    cohttp-internal module rather than one of our `http_post_error`s. *)
let with_connection_retry (task : unit -> 'a Lwt.t) : 'a Lwt.t =
  let deadline_seconds = 10.0 in
  let retry_seconds = 0.05 in
  (* Compute deadline *)
  let deadline = Unix.gettimeofday () +. deadline_seconds in
  (* Define actual computation body *)
  let rec recursive_body () =
    Lwt.catch task (function
      | Unix.Unix_error (Unix.ECONNREFUSED, _, _)
        when Unix.gettimeofday () < deadline ->
          let** () = Lwt_unix.sleep retry_seconds in
          recursive_body ()
      | e -> Lwt.reraise e)
  in
  (* Start trying *)
  recursive_body ()

(** Starts the HTTP server, returning an Lwt promise *)
let start_server () : unit Lwt.t =
  (* Processes the given request with the given string. Returns
     the message_completion indicating we've received the message. *)
  let process_request (req : Http.Request.t) (body : string) :
      (bool, client_error) result Lwt.t =
    (* Ensure it's a POST request. *)
    let**? () =
      if req.meth == `POST then Lwt.return_ok ()
      else Lwt.return_error MethodNotPost
    in
    (* Extract message kind (send/choose), or throw *)
    let request_uri : Uri.t = Cohttp.Request.uri req in
    let**? message_type : message_type =
      Uri.path request_uri |> message_type_from_string
      |> Option.to_result ~none:UnknownPath
      |> Lwt.return
    in
    (* Extract the name
       Note: We don't validate inputs because if they're invalid, they
       will simply not get a Hashtbl match. *)
    let**? raw_peer_name =
      Http.Header.get (Http.Request.headers req) "X-Pirouette-From"
      |> Option.to_result ~none:MissingOrigin
      |> Lwt.return
    in
    (* Check peer exists and hasn't double-messaged *)
    let**? channel =
      match Hashtbl.find_opt _app_state.name_to_peer raw_peer_name with
      (* Check `is_empty` doesn't cause race conditions because
         we're the only thread who can put new data in the channel. *)
      | Some { message_channel; _ } when Lwt_mvar.is_empty message_channel ->
          Lwt.return_ok message_channel
      (* Fail if channel isn't empty (client double-messaged) *)
      | Some _ -> Lwt.return_error CannotMessageTwice
      | None -> Lwt.return_error UnknownPeer
    in
    (* Send message via the channel *)
    let message_completion : message_completion = Lwt_condition.create () in
    let message = ((message_type, body), message_completion) in
    (* Should return instantly since we're the only thread adding messages,
       and we just checked there's no backlog. *)
    let** () = Lwt_mvar.put channel message in
    (* Return completion *)
    let** success = Lwt_condition.wait message_completion in
    Lwt.return_ok success
  in
  let callback _conn (req : Http.Request.t) (body : Cohttp_lwt.Body.t) =
    (* Get body string
       Note: We get the body at the start before any error path to ensure we
       always terminate the connection (and avoid leaking memory). *)
    let** body_str = Cohttp_lwt.Body.to_string body in
    (* Get result of sending messaging and wait for client to receive. *)
    let** process_result = process_request req body_str in
    (* Respond with status and an empty body *)
    let response_status = client_result_to_http_status process_result in
    Cohttp_lwt_unix.Server.respond ~status:response_status
      ~body:Cohttp_lwt.Body.empty ()
  in
  let server = Cohttp_lwt_unix.Server.make ~callback () in
  (* Get port (default is 8000) *)
  let port = Uri.port _app_state.self.hostname |> Option.value ~default:8000 in
  (* Start server *)
  Cohttp_lwt_unix.Server.create ~mode:(`TCP (`Port port)) server

(** Implements `get_message` by returning an `Lwt_result` *)
let _get_message_impl (type a) (message_type : message_type)
    (peer_name : string) : (a, http_get_error) Lwt_result.t =
  (* Get peer *)
  let**? peer =
    Hashtbl.find_opt _app_state.name_to_peer peer_name
    |> Option.to_result ~none:InvalidSourcePeer
    |> Lwt_result.lift
  in
  (* Wait for message to arrive *)
  let** (req_message_type, message_body), completion =
    Lwt_mvar.take peer.message_channel
  in
  (* Signal to peer whether we could take the message *)
  let is_correct_type = req_message_type = message_type in
  Lwt_condition.signal completion is_correct_type;
  (* Ensure we have a `/send` message (or throw) *)
  let**? () =
    if is_correct_type then Lwt.return_ok ()
    else Lwt.return_error (WrongMessageType req_message_type)
  in
  (* Decode only once the kind matches
      Note: A `/send` body holds an arbitrary value and a `/choose` body a
      label, so decoding at the wrong kind is undefined behavior. *)
  Lwt.return_ok (Marshal.from_string message_body 0 : a)

(** Gets and decodes a message of `message_type` (Send or Choose) from the given
    `peer_name`. Blocks until message arrives; traps on error. *)
let get_message (type a) (message_type : message_type) (peer_name : string) : a
    =
  (* Block until we get the message *)
  match Lwt_main.run (_get_message_impl message_type peer_name) with
  | Ok value -> value
  | Error err ->
      failwith
        ("HTTP Backend couldn't get message: " ^ http_get_error_to_string err)

(** Implements `post_message` by returning an `Lwt_result` *)
let _post_message_impl (message_type : message_type) (peer_name : string)
    (message : string) : (unit, http_post_error) Lwt_result.t =
  let body = Cohttp_lwt.Body.of_string message in
  let headers = Http.Header.init_with "X-Pirouette-From" _app_state.self.name in
  let**? peer =
    Hashtbl.find_opt _app_state.name_to_peer peer_name
    |> Option.to_result ~none:InvalidDestPeer
    |> Lwt_result.lift
  in
  let request_uri =
    Uri.with_path peer.hostname (message_type_to_string message_type)
  in
  (* Block until we post the message (allow for retries) *)
  let** resp, _ =
    with_connection_retry (fun () ->
        Cohttp_lwt_unix.Client.post ~headers ~body request_uri)
  in
  (* Throw if we get bad status *)
  let status = Http.Response.status resp in
  if status <> `OK then Lwt.return_error (BadStatus status)
  else Lwt.return_ok ()

(** Sends the encoded `message` of `message_type` (Send or Choose) to the given
    `peer_name`. Blocks until peer gets; traps on error. *)
let post_message (message_type : message_type) (peer_name : string)
    (message : string) : unit =
  (* Block until we post the message *)
  match Lwt_main.run (_post_message_impl message_type peer_name message) with
  | Ok () -> ()
  | Error err ->
      failwith
        ("HTTP Backend couldn't post message: " ^ http_post_error_to_string err)

(* Start the server

   Note: `Lwt.async` explicitly throws upon failure. For example, if the port is
   already taken, we immediately die. *)
let () =
  Lwt.async (fun () ->
      Lwt.catch start_server (fun exn ->
          failwith
            ("HTTP Backend unexpected protocol failure: "
           ^ Printexc.to_string exn)))

(*---------------------------------------------------------------------------*)
(* Runtime Implementations                                                         *)
(*---------------------------------------------------------------------------*)

(** Checks if this participant has label `e` *)
let am_i e = _app_state.self.name = e

(** Send [value] to [destination] and block until the peer calls `recv` on said
    value.

    Preconditions:
    - The given type must be encodable with `Marshal.to_string _ []` (closures
      are explicitly not supported). *)
let send (destination : string) (value : 'a) : unit =
  (* No Marshal.Closures flag because we closure pointers may be invalid
     in other participants processes. *)
  let message : string = Marshal.to_string value [] in
  post_message Send destination message

(** Blocks until we get the next value from [source].

    Preconditions:
    - The caller annotates the result type, and we trust [Marshal.from_string]
      to match it; a mismatch results in undefined behavior. *)
let recv (type a) (source : string) : a = get_message Send source

(** Choose label [label] for [destination] and block until the peer calls
    `recv_label`. *)
let choose (destination : string) (label : string) : unit =
  (* Note: A label is just a string, so we encode it like any other value. *)
  let message : string = Marshal.to_string label [] in
  post_message Choose destination message

(** Blocks until we get the next label from [source]. *)
let recv_label (source : string) : string = get_message Choose source
