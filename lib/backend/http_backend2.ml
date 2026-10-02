open Lwt.Infix

(*---------------------------------------------------------------------------*)
(* Initialization                                                            *)
(*---------------------------------------------------------------------------*)

let ( let* ) = Result.bind

(* TODO: Should avoid name collisions *)
type participant = { debug_name : string; hostname : Uri.t }
(** A participant in the system with their debug_name (NetIR name) and hostname
    (IP address + port). *)

type message_type = Send | Choose  (** An incoming message from a peer. *)

(** Convert HTTP path string to optional `message_type` *)
let message_type_from_string = function
  | "send" -> Some Send
  | "choose" -> Some Choose
  | _ -> None

(** Convert `message_type` to HTTP path string *)
let message_type_to_string = function Send -> "send" | Choose -> "choose"

type message = message_type * string

type message_completion = bool Lwt_condition.t
(** Indicates the message was received. If given `true`, the result processed
    successfully; else, we have a `/send` vs `/choose` mismatch *)

type peer = {
  debug_name : string;
  message_channel : (message * message_completion) Lwt_mvar.t;
}

(* TODO: `self, peers` should be immutable. *)
type state = {
  self : participant;  (** Information about this participant *)
  (* peers : participant list;  (** Information about our peers *) *)
  peers2 : (Uri.t, peer) Hashtbl.t;
      (** Each Uri (with scheme+host+port) has a `participant` (debug name +
          uri) and a channel that holds up to one message.

          Choreographies guarantee that senders wait for us to receive messages,
          so we only need to store one message at a time. *)
      (* messages : unit list;  (** Queued-up messages our peers sent us *) *)
      (* lock : Lwt_mutex.t; *)
      (* condition : Lwt_condition.t; *)
}
(** The app's shared global state. *)

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

(** Parse participants from command-line args *)
let create_state () : (state, init_error) result =
  (* Parse an individual participant string *)
  let parse_participant (str : string) : (participant, init_error) result =
    (* Get debug name and hostname *)
    let* debug_name, raw_hostname =
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
    Result.Ok { debug_name; hostname }
  in
  (* Parse each participant, or return failure *)
  let* participants : participant list =
    Sys.argv
    |> Array.fold_left
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
  (* Create map from hostname -> participant & message *)
  let peers2 : (Uri.t, _) Hashtbl.t =
    peers |> List.to_seq
    |> Seq.map (fun (p : participant) ->
        let peer : peer =
          {
            debug_name = p.debug_name;
            message_channel = Lwt_mvar.create_empty ();
          }
        in
        (p.hostname, peer))
    |> Hashtbl.of_seq
  in
  (* We will add to messages with the server *)
  let state =
    {
      self;
      (* peers; *)
      peers2;
      (* messages = [] *)
    }
  in
  Result.Ok state

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
  let app_state : state = failwith "" in
  (* Processes the given request with the given string. Returns
     the message_completion indicating we've received the message. *)
  let process_request (req : Http.Request.t) (body : string) :
      (message_completion, client_error) result =
    (* Ensure it's a POST request. *)
    let* () =
      if req.meth == `POST then Result.Ok () else Result.Error MethodNotPost
    in
    (* Extract message kind (send/choose), or throw *)
    let request_uri : Uri.t = Cohttp.Request.uri req in
    let* message_type : message_type =
      Uri.path request_uri |> message_type_from_string
      |> Option.to_result ~none:UnknownPath
    in
    (* Extract the origin (should be scheme+host+port)
       Note: We don't validate inputs because if they're invalid, they
       will simply not get a Hashtbl match. *)
    let* raw_peer_hostname =
      Http.Header.get (Http.Request.headers req) "Origin"
      |> Option.to_result ~none:MissingOrigin
    in
    let peer_hostname : Uri.t = Uri.of_string raw_peer_hostname in
    (* Check peer exists and hasn't double-messaged *)
    let* channel =
      match Hashtbl.find_opt app_state.peers2 peer_hostname with
      (* Check `is_empty` doesn't cause race conditions because
         we're the only thread who can put new data in the channel. *)
      | Some { message_channel; _ } when Lwt_mvar.is_empty message_channel ->
          Result.Ok message_channel
      (* Fail if channel isn't empty (client double-messaged) *)
      | Some _ -> Result.Error CannotMessageTwice
      | None -> Result.Error UnknownPeer
    in
    (* Send message via the channel *)
    let message_completion : message_completion = Lwt_condition.create () in
    let message = ((message_type, body), message_completion) in
    (* Should return instantly since we're the only thread adding messages,
       and we just checked there's no backlog. *)
    Lwt_main.run (Lwt_mvar.put channel message);
    (* Return completion *)
    Result.Ok message_completion
  in
  let callback _conn (req : Http.Request.t) (body : Cohttp_lwt.Body.t) =
    (* Get body string
       Note: We get the body at the start before any error path to ensure we
       always terminate the connection (and avoid leaking memory). *)
    Cohttp_lwt.Body.to_string body >>= fun (body_str : string) ->
    (* Get result *)
    let uncompleted_res = Lwt_result.lift (process_request req body_str) in
    (* Unwrap result and wait for completion *)
    Lwt_result.bind_lwt uncompleted_res Lwt_condition.wait >>= fun res ->
    (* Respond with status and an empty body *)
    let response_status = client_result_to_http_status res in
    Cohttp_lwt_unix.Server.respond ~status:response_status
      ~body:Cohttp_lwt.Body.empty ()
  in
  let server = Cohttp_lwt_unix.Server.make ~callback () in
  (* Get port (default is 8000) *)
  let port = Uri.port app_state.self.hostname |> Option.value ~default:8000 in
  (* Start server *)
  Cohttp_lwt_unix.Server.create ~mode:(`TCP (`Port port)) server

type get_message_error = InvalidPeer | Invalid

let get_message (message_type : message_type) (peer : participant) : 'a =
  let app_state : state = failwith "" in
  (* Get peer *)
  let* peer =
    Hashtbl.find_opt app_state.peers2 peer.hostname
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

let post_message (message_type : message_type) (message : string)
    (peer : participant) =
  let app_state : state = failwith "" in
  let body = Cohttp_lwt.Body.of_string message in
  let headers =
    Http.Header.init_with "Origin" (Uri.to_string app_state.self.hostname)
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
(* TODO: Make sure to retry. *)
