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
let message_type_to_string = function
  | Send -> "send"
  | Choose -> "choose"

type message = message_type * string

let empty_message : message option = None

(* TODO: `self, peers` should be immutable. *)
type state = {
  self : participant;  (** Information about this participant *)
  peers : participant list;  (** Information about our peers *)
  peers2 : (Uri.t, participant * message option) Hashtbl.t;
  messages : unit list;  (** Queued-up messages our peers sent us *)
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
    |> Seq.map (fun p -> (p.hostname, (p, empty_message)))
    |> Hashtbl.of_seq
  in
  (* We will add to messages with the server *)
  Result.Ok { self; peers; peers2; messages = [] }

(*---------------------------------------------------------------------------*)
(* HTTP Send/Receive                                                         *)
(*---------------------------------------------------------------------------*)

type client_error =
  | MethodNotPost  (** We only allow POST for send/choose *)
  | UnknownPath  (** We only allow `/send` and `/choose` *)
  | MissingOrigin (** We need the `Origin` header to identify the peer *)
  | UnknownPeer  (** Peer must be registered *)
  | CannotMessageTwice of message  (** Cannot message twice *)

let client_result_to_http_status = function
  | Result.Ok _ -> `OK
  | Result.Error MethodNotPost -> `Method_not_allowed
  | Result.Error UnknownPath -> `Not_found
  | Result.Error UnknownPeer -> `Unauthorized
  | Result.Error MissingOrigin | Result.Error (CannotMessageTwice _) -> `Bad_request

let start_server () : unit Lwt.t =
  let app_state : state = failwith "" in
  let process_request (req : Http.Request.t) (body : string) :
      (unit, client_error) result =
    (* Ensure it's a POST request. *)
    let* () =
      if req.meth == `POST then Result.Ok () else Result.Error MethodNotPost
    in
    (* Extract message kind (send/choose), or throw *)
    let request_uri : Uri.t = Cohttp.Request.uri req in
    let* message_type : message_type =
      Uri.path request_uri |> message_type_from_string
      |> Option.to_result ~none:UnknownPath in
    (* Extract the origin (should be scheme+host+port)
       Note: We don't validate inputs because if they're invalid, they
       will simply not get a Hashtbl match. *)
    let* raw_peer_hostname = Http.Header.get (Http.Request.headers req) "Origin" |> Option.to_result ~none:MissingOrigin in
    let peer_hostname: Uri.t = Uri.of_string raw_peer_hostname in
    (* Check peer exists and hasn't double-messaged *)
    let* participant =
      match Hashtbl.find_opt app_state.peers2 peer_hostname with
      | Some (participant, None) -> Result.Ok participant
      | Some (_, Some prev_message) ->
          Result.Error (CannotMessageTwice prev_message)
      | None -> Result.Error UnknownPeer
    in
    (* Save message *)
    let message = (message_type, body) in
    Hashtbl.replace app_state.peers2 peer_hostname (participant, Some message);
    Result.Ok ()
  in
  let callback _conn (req : Http.Request.t) (body : Cohttp_lwt.Body.t) =
    (* Get body string
       Note: We get the body at the start before any error path to ensure we
       always terminate the connection (and avoid leaking memory). *)
    Cohttp_lwt.Body.to_string body >>= fun (body_str : string) ->
    let res = process_request req body_str in
    let response_status = client_result_to_http_status res in
    (* Respond with status with an empty body *)
    Cohttp_lwt_unix.Server.respond ~status:response_status
      ~body:Cohttp_lwt.Body.empty ()
  in
  let server = Cohttp_lwt_unix.Server.make ~callback () in
  Cohttp_lwt_unix.Server.create ~mode:(`TCP (`Port 8000)) server

let get_message (message_type : message_type) (peer : participant) =
  (* Set up condition to set up server message;
     once received, set thing to NULL;
     use lock/condvar for messages *)
(* https://ocaml.org/manual/5.5/parallelism.html#s%3Apar_sync *)
  failwith ""
;;

let post_message (message_type : message_type) (message : string)
    (peer : participant) =
    let app_state: state = failwith "" in
  let body = Cohttp_lwt.Body.of_string message in
  let headers = Http.Header.init_with "Origin" (Uri.to_string app_state.self.hostname) in
  let request_uri = Uri.with_path peer.hostname (message_type_to_string message_type) in
  let (resp, body) = Lwt_main.run (Cohttp_lwt_unix.Client.post ~headers ~body request_uri) in
  (* TODO: Crash if not okay status; make sure to retry. *)
  failwith ""
