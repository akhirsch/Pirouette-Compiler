open Lwt.Infix

let ( let* ) = Result.bind
let ( let** ) = Lwt.bind
let ( let**? ) = Lwt_result.bind
(* let ( let%lwt ) = Lwt.bind *)

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
  (* name : string; *)
  hostname : Uri.t;
  message_channel : (message * message_completion) Lwt_mvar.t;
}
(** A peer has a debug name and a channel to receive messages on. *)

(* TODO: `self, peers` should be immutable. *)
type state = {
  self : participant;  (** Information about this participant *)
  name_to_peer : (string, peer) Hashtbl.t;
  name_to_hostname : (string, Uri.t) Hashtbl.t;
      (** Each location name mapped to the peer's Uri (scheme+host+port) *)
      (* TODO: Remove *)
      (* (* hostname_to_peer : (Uri.t, peer) Hashtbl.t; *) *)
      (*     (** Each hostname URI (with scheme+host+port) has a `peer` (debug name + *)
  (*         uri) and a channel that holds up to one message. *)
  (**)
  (*         Choreographies guarantee that senders wait for us to receive messages, *)
  (*         so we only need to store one message at a time. *) *)
}
(** The app's shared global state.

    Invariant: For any peer `p` with hostname `h` and name `n`, we have
    `name_to_hostname[n] = h` and `hostname_to_peer[h] = p` *)

type participant_parse_error = NoDebugName | InvalidHostname

let describe_participant_error = function
  | NoDebugName -> "debug name -- expected <debug name>=<hostname>"
  | InvalidHostname -> "hostname"

type init_error =
  | LessThanTwoArgs
  | InvalidParticipant of participant_parse_error * string

let describe_init_error = function
  | LessThanTwoArgs ->
      "Expected at least 2 arguments: <self_name>=<self_hostname> \
       <participant1_name>=<participant1_hostname> ..."
  | InvalidParticipant (parse_error, raw_participant) ->
      Printf.sprintf "Invalid participant %s: '%s'"
        (describe_participant_error parse_error)
        raw_participant

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

  (* (* Create map from hostname -> participant & message *) *)
  (* let hostname_to_peer : (Uri.t, _) Hashtbl.t = *)
  (*   peers |> List.to_seq *)
  (*   |> Seq.map (fun (p : participant) -> *)
  (*       let peer : peer = *)
  (*         { name = p.debug_name; message_channel = Lwt_mvar.create_empty () } *)
  (*       in *)
  (*       (p.hostname, peer)) *)
  (*   |> Hashtbl.of_seq *)
  (* in *)

  (* Create map from name -> hostname *)
  let name_to_hostname =
    peers |> List.to_seq
    |> Seq.map (fun (p : participant) -> (p.name, p.hostname))
    |> Hashtbl.of_seq
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
  let state =
    {
      self;
      (* peers; *)
      name_to_hostname;
      name_to_peer;
      (* messages = [] *)
    }
  in
  Result.Ok state

(** The global state containing our identity & peer information, and used to
    track HTTP requests *)
let _app_state =
  (* Get state, or trap *)
  match create_state () with
  | Ok state -> state
  | Error err ->
      failwith ("HTTP Backend init failed: " ^ describe_init_error err)

(** Get the participant with the given destination name *)
let get_participant (destination : string) : participant =
  let hostname : Uri.t =
    match Hashtbl.find_opt _app_state.name_to_hostname destination with
    | Some hostname -> hostname
    | None -> failwith ("HTTP backend hasn't registered '" ^ destination ^ "'")
  in
  { name = destination; hostname }

(*---------------------------------------------------------------------------*)
(* HTTP Send/Receive                                                         *)
(*---------------------------------------------------------------------------*)

type client_error =
  | MethodNotPost  (** We only allow POST for send/choose *)
  | UnknownPath  (** We only allow `/send` and `/choose` *)
  | MissingOrigin  (** We need the `Origin` header to identify the peer *)
  | UnknownPeer  (** Peer must be registered *)
  | CannotMessageTwice  (** Cannot message twice *)
(* TODO: Remove *)
(* | WrongOperation  (** Expected `/send` but got `/choose` or vice versa. *) *)

let client_result_to_http_status = function
  | Result.Ok true -> `OK
  | Result.Error MethodNotPost -> `Method_not_allowed
  | Result.Error UnknownPath -> `Not_found
  | Result.Error UnknownPeer -> `Unauthorized
  | Result.Ok false
  | Result.Error MissingOrigin
  | Result.Error CannotMessageTwice ->
      `Bad_request

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
    (* Extract the origin (should be scheme+host+port)
       Note: We don't validate inputs because if they're invalid, they
       will simply not get a Hashtbl match. *)
    let**? raw_peer_hostname =
      Http.Header.get (Http.Request.headers req) "Origin"
      |> Option.to_result ~none:MissingOrigin
      |> Lwt.return
    in
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
      | Some { hostname; message_channel }
        when Uri.to_string hostname = raw_peer_hostname
             && Lwt_mvar.is_empty message_channel ->
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

type get_message_error = InvalidPeer

let get_error_to_str = function InvalidPeer -> "invalid peer"

let _get_message_impl (message_type : message_type) (peer : participant) : 'a =
  (* Get peer *)
  let* peer =
    Hashtbl.find_opt _app_state.name_to_peer peer.name
    |> Option.to_result ~none:InvalidPeer
  in
  (* Block until message arrives *)
  let (req_message_type, message_body), completion =
    Lwt_main.run (Lwt_mvar.take peer.message_channel)
  in
  let decoded : 'a = Marshal.from_string message_body 0 in
  (* Signal to peer that we got the message *)
  let is_correct_type = req_message_type = message_type in
  Lwt_condition.signal completion is_correct_type;
  (* Return decoded data *)
  decoded

let get_message (message_type : message_type) (peer : participant) : 'a =
  match _get_message_impl message_type peer with
  | Ok value -> value
  | Error err ->
      failwith "HTTP Backend couldn't get message: " ^ get_error_to_str err

let post_message (message_type : message_type) (peer : participant)
    (message : string) =
  let body = Cohttp_lwt.Body.of_string message in
  let headers =
    Http.Header.add
      (Http.Header.init_with "Origin" (Uri.to_string _app_state.self.hostname))
      "X-Pirouette-From" _app_state.self.name
  in
  let request_uri =
    Uri.with_path peer.hostname (message_type_to_string message_type)
  in
  let resp, _ =
    Lwt_main.run (Cohttp_lwt_unix.Client.post ~headers ~body request_uri)
  in
  (* Crash if we get bad status *)
  let status = Http.Response.status resp in
  if status <> `OK then
    failwith
      ("HTTP backend encountered unexpected error when sending message "
      ^ Http.Status.to_string status)
  else ()

let _ = start_server ()
(* TODO: Make sure to retry. *)

(*---------------------------------------------------------------------------*)
(* Runtime Implementations                                                         *)
(*---------------------------------------------------------------------------*)

(* Send [value] to [destination] by POSTing it to their mailbox. Returns once
   the peer consumes the value from the mailbox (not when they receive it). *)
let send (destination : string) (value : 'a) : unit =
  let participant = get_participant destination in
  (* No Marshal.Closures flag because participants are separate binaries
     (a closure marshalled here would be a code pointer into the
     wrong program) *)
  let message : string = Marshal.to_string value [] in
  post_message Send participant message

(* Get the next value [source] sent us, blocking until it arrives. The caller
   annotates the result type, and we trust [Marshal.from_string] to match
   it; a mismatch results in undefined behavior. *)
let recv (source : string) : 'a =
  let participant = get_participant source in
  get_message Send participant
