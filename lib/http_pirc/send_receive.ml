open Cohttp_eio

(** Global config reference, initialized by the compiler generated code. *)
let config = ref None

(* Message queues for each location *)
let loc_to_address = Hashtbl.create 10
let message_queues : (string, string Eio.Stream.t) Hashtbl.t = Hashtbl.create 10

(** Helper to get location config; [get_location_config location] is [Ok config]
    containing the HTTP address configuration for the [location] if [location]
    exists in the configuration, and [Error msg] if the configuration is not
    initialized or [location] is unknown.

    Requires: Configuration must be initialized before calling this function. *)
let get_location_config location =
  match !config with
  | None -> Error "Config not initialized. Call init() first"
  | Some cfg -> (
      match
        List.find_opt
          (fun loc -> loc.Config_parser.location = location)
          cfg.Config_parser.locations
      with
      | Some loc_config -> Ok loc_config
      | None -> Error ("Unknown location: " ^ location))

(* let print_locations = *)
(*   match !config with *)
(*   | None -> Error "Config not initialized. Call init() first" *)
(*   | Some cfg -> *)
(*     let () = *)
(*       List.iter *)
(*         (fun loc -> print_endline ("This is the value" ^ loc.Config_parser.location)) *)
(*         cfg.Config_parser.locations in Ok  *)

(* ;; *)

let get_body string_to_send participant_name_string =
  let list_to_send : string list = [] in
  let list_to_send = List.cons participant_name_string list_to_send in
  let list_to_send = List.cons string_to_send list_to_send in
  let final_string = String.concat ";" list_to_send in
  (* print_endline ("This is the string that we are sending:" ^ final_string); *)
  let body_to_send = Some (Body.of_string final_string) in
  body_to_send

let get_ip_address ~location =
  match get_location_config location with
  | Ok loc_config -> Uri.of_string loc_config.http_address
  | _ -> Uri.empty

let get_header =
  let new_header = Http.Header.init () in
  let header_to_send = Http.Header.add new_header "Connection" "close" in
  header_to_send

(* Function to marshal data *)
let marshal_data data =
  try
    let result = Marshal.to_string data [] in
    result
  with e -> raise e

(** [unmarshal_data data_str] is [Ok value] containing the unmarshaled OCaml
    value if [data_str] is a valid marshaled string, and [Error msg] if
    [data_str] is empty or unmarshaling fails.

    Requires: [data_str] must be a marshaled OCaml value. *)
let unmarshal_data data_str =
  try
    if String.length data_str = 0 then Error "Empty data string"
    else
      let result = Marshal.from_string data_str 0 in
      Ok result
  with e -> Error ("Unmarshal error: " ^ Printexc.to_string e)

(* DO NOT DELETE THIS IS A BACKUP *)
(* This is the handler for incoming http requests *)
let handler _socket _request body =
  let x : Cohttp_eio.Body.t = body in
  let sender_body = Eio.Buf_read.(parse_exn take_all) ~max_size:max_int x in
  let sep = ';' in
  let recv_list = String.split_on_char sep sender_body in
  let sender_location = List.nth_opt recv_list 0 in
  let sender_body = List.nth recv_list 1 in
  (* let sender_location_print = List.nth recv_list 0 in *)
  (* let sender_body_print = List.nth recv_list 1 in *)
  (* print_endline ("This is the value of sender location : " ^ sender_location_print); *)
  (* print_endline ("This is the value of sender body : " ^ sender_body_print); *)
  (* let recv_headers = Http.Request.headers request in *)
  (* let sender_location = Http.Header.get recv_headers "Participant_Name" in *)
  match sender_location with
  | None ->
      (* print_endline "Error message sender location not found"; *)
      (* Eio.traceln "Error message sender location not found"; *)
      Cohttp_eio.Server.respond_string ~status:`Precondition_failed
        ~body:"Error message - Sender location not found" ()
  | Some unwrapped_sender_location -> (
      let indexed_queue =
        Hashtbl.find_opt message_queues unwrapped_sender_location
      in
      (* print_endline "The key already exists"; *)
      match indexed_queue with
      | Some result_queue ->
          (* let get_sender_body input_string = *)
          (*   match sender_body with *)
          (*   | "L" -> *)
          (*     print_endline "The L branch was taken"; *)
          (*     let string_to_print = input_string in *)
          (*     string_to_print *)
          (*   | "R" -> *)
          (*     print_endline "The R branch was taken"; *)
          (*     let string_to_print = input_string in *)
          (*     string_to_print *)
          (*   | _ -> *)
          (*     print_endline "Looks like we have something that had been marshalled"; *)
          (*     let string_to_print = Marshal.from_string input_string 0 in *)
          (*     string_to_print *)
          (* in *)
          (* let _string_to_print = get_sender_body sender_body in *)
          (* Eio.traceln "%s" string_to_print; *)
          (* Eio.traceln "%s" unwrapped_sender_location; *)
          Eio.Stream.add result_queue sender_body;
          Cohttp_eio.Server.respond_string ~status:`OK
            ~body:"Added to Htbl ; existing key" ()
      | None ->
          (* Hashtbl.add message_queues unwrapped_sender_location (Eio.Stream.create 100); *)
          (* let indexed_queue = Hashtbl.find message_queues unwrapped_sender_location in *)
          (* print_endline *)
          (*   ("This value was put inside the queue : " *)
          (*    ^ sender_body *)
          (*    ^ " " *)
          (*    ^ unwrapped_sender_location); *)
          (* print_endline "The key has to be made"; *)
          (* let get_sender_body input_string = *)
          (*   match sender_body with *)
          (*   | "L" -> *)
          (*     print_endline "The L branch was taken"; *)
          (*     let string_to_print = input_string in *)
          (*     string_to_print *)
          (*   | "R" -> *)
          (*     print_endline "The R branch was taken"; *)
          (*     let string_to_print = input_string in *)
          (*     string_to_print *)
          (*   | _ -> *)
          (*     print_endline "Looks like we have something that had been marshalled"; *)
          (*     let string_to_print = Marshal.from_string input_string 0 in *)
          (*     string_to_print *)
          (* in *)
          (* let string_to_print = get_sender_body sender_body in *)
          (* Eio.traceln "%s" string_to_print; *)
          (* Eio.traceln "%s" unwrapped_sender_location; *)
          (* let sender_body = Marshal.from_string string_to_print 0 in *)
          (* Eio.Stream.add indexed_queue sender_body; *)
          Cohttp_eio.Server.respond_string ~status:`Precondition_failed
            ~body:"This should not happen" ())

(* This is the handler for incoming http requests *)
(* let handler _socket _request body = *)
(*   let x : Cohttp_eio.Body.t = body in *)
(*   let sender_body = Eio.Buf_read.(parse_exn take_all) ~max_size:max_int x in *)
(*   let sep = ';' in *)
(*   let recv_list = String.split_on_char sep sender_body in *)
(*   let sender_location = List.nth_opt recv_list 0 in *)
(*   let _sender_body = List.nth recv_list 1 in *)
(*   match sender_location with *)
(*   | None -> *)
(*     Cohttp_eio.Server.respond_string *)
(*       ~status:`Precondition_failed *)
(*       ~body:"Error message - Sender location not found" *)
(*       () *)
(*   | Some _ -> *)
(*     (\* let indexed_queue = Hashtbl.find_opt message_queues unwrapped_sender_location in *\) *)
(*     (\* (\\* print_endline "The key already exists"; *\\) *\) *)
(*     (\* (match indexed_queue with *\) *)
(*     (\*  | Some result_queue -> *\) *)
(*     (\*    Eio.Stream.add result_queue sender_body; *\) *)
(*     Cohttp_eio.Server.respond_string ~status:`OK ~body:"Everything is ok" () *)
(* ;; *)

(* | None -> *)
(*   (\* Hashtbl.add message_queues unwrapped_sender_location (Eio.Stream.create max_int); *\) *)
(*   (\* let indexed_queue = Hashtbl.find message_queues unwrapped_sender_location in *\) *)
(*   (\* Eio.Stream.add indexed_queue sender_body; *\) *)
(*   Cohttp_eio.Server.respond_string *)
(*     ~status:`OK *)
(*     ~body:"Added to Htbl ; new key - sender body" *)
(*     ()) *)

(* This is to setup config ; ie update the reference and pull the values from that into a hashtable *)
let setup_config_file () =
  (* First collect all original addresses *)
  match !config with
  | None -> ()
  | Some cfg ->
      List.iter
        (fun loc_cfg ->
          Hashtbl.add loc_to_address loc_cfg.Config_parser.location
            loc_cfg.Config_parser.http_address)
        cfg.Config_parser.locations;
      List.iter
        (fun loc_cfg ->
          Hashtbl.add message_queues loc_cfg.Config_parser.location
            (Eio.Stream.create 100))
        cfg.Config_parser.locations;
      let new_locations =
        List.map
          (fun loc_cfg ->
            {
              loc_cfg with
              Config_parser.http_address =
                Hashtbl.find loc_to_address loc_cfg.Config_parser.location;
            })
          cfg.Config_parser.locations
      in
      (* Update the config reference *)
      config := Some { Config_parser.locations = new_locations }

(* Initialize HTTP server for this location *)
let init_http_server current_location () =
  (* print_endline "Right before setup_config_file"; *)
  let () = setup_config_file () in
  (* print_endline "After setup_config_file"; *)
  match get_location_config current_location with
  | Error msg ->
      failwith
        ("location config" ^ current_location
       ^ "not found inside init_http_location" ^ msg)
  | Ok loc_config ->
      (* print_endline "We got a config debug statement"; *)
      let uri = Uri.of_string loc_config.Config_parser.http_address in
      let uri_host =
        match Uri.host uri with
        | Some string_value -> string_value
        | None -> failwith "No value for uri host"
      in
      let unix_inet_addr = Unix.inet_addr_of_string uri_host in
      let address_to_run_server = Eio_unix.Net.Ipaddr.of_unix unix_inet_addr in
      (* let _path = Uri.path uri in *)
      (* (\* Extract port from URI or use a default *\) *)
      (* print_endline "Got the URI"; *)
      let port_to_use : int =
        match Uri.port uri with
        | Some p -> p (* Use original port *)
        | None -> 8080
        (* Default port *)
      in
      (* print_endline ("Starting an HTTP server for this specific node" ^ current_location); *)
      (* The following statement sets up logs for debugging *)
      let () = Logs.set_reporter (Logs_fmt.reporter ())
      and () =
        (* if String.compare "A" current_location = 0 *)
        (* then Logs.Src.set_level Cohttp_eio.src (Some Debug) *)
        (* else Logs.Src.set_level Cohttp_eio.src None *)
        Logs.Src.set_level Cohttp_eio.src None
      in
      let log_warning ex = Logs.warn (fun f -> f "%a" Eio.Exn.pp ex) in
      (* This runs the Eio event loop for the server *)
      let () =
        (* print_endline "Just before the EIO main loop"; *)
        let port = ref port_to_use in
        (* print_endline ("This is the port that is being used " ^ string_of_int port_to_use); *)
        Arg.parse
          [
            ("-p", Arg.Set_int port, " Listening port number(8080 by default)");
          ]
          ignore "An HTTP/1.1 server";
        Eio_main.run @@ fun env ->
        (* print_endline "Inside the EIO main loop"; *)
        Eio.Switch.run @@ fun sw ->
        (* print_endline "Inside the EIO switch run"; *)
        let socket =
          Eio.Net.listen env#net ~sw ~backlog:30000 ~reuse_port:true
            ~reuse_addr:true
            (`Tcp (address_to_run_server, !port))
          (* (`Tcp (Eio.Net.Ipaddr.V4.loopback, !port)) *)
        in
        let server = Cohttp_eio.Server.make ~callback:handler () in
        let dom_mgr = Eio.Stdenv.domain_mgr env in
        (* print_endline "After the and server part"; *)
        Cohttp_eio.Server.run socket server
          ?additional_domains:
            (Some (dom_mgr, Domain.recommended_domain_count ()))
          ?max_connections:(Some 30000) ~on_error:log_warning
      in
      (* print_endline "Finished"; *)
      ()

(* let receive_message ~location = *)
(*   ignore location; *)
(*   let ret_val = Queue.pop mutable_queues in *)
(*   ret_val *)
(* ;; *)

(* ######################### THIS FUNCTION IS A BACKUP DO NOT DELETE ######################### *)
let rec receive_message ~location =
  (* Eio.traceln "Waiting for a message to appear"; *)
  let key_for_table = location in
  let stream_handle_option = Hashtbl.find_opt message_queues key_for_table in
  (* let received_message = Eio.Stream.take stream_for_message in received_message *)
  match stream_handle_option with
  | Some stream_associated_key -> (
      (* Eio.traceln "Found the correct key\n"; *)
      let value_from_stream_handle =
        Eio.Stream.take_nonblocking stream_associated_key
      in
      match value_from_stream_handle with
      | Some value_from_stream ->
          (* Eio.traceln "Found the right value from the queue\n"; *)
          (* let get_sender_body input_string = *)
          (*   match input_string with *)
          (*   | "L" -> *)
          (*     print_endline "The L body was in the queue"; *)
          (*     let string_to_print = input_string in *)
          (*     string_to_print *)
          (*   | "R" -> *)
          (*     print_endline "The R body was in the queue"; *)
          (*     let string_to_print = input_string in *)
          (*     string_to_print *)
          (*   | _ -> *)
          (*     print_endline "Looks like we have something that had been marshalled"; *)
          (*     let string_to_print = Marshal.from_string input_string 0 in *)
          (*     string_to_print *)
          (* in *)
          (* Eio.traceln "Recv was successful"; *)
          (* print_endline "Recv worked out"; *)
          (* let _val_print = get_sender_body value_from_stream in *)
          (* print_endline ("This is the value of the string : " ^ val_print); *)
          (* Eio.traceln "This is the value of the string %s\n" val_print; *)
          value_from_stream
      | None ->
          (* Eio.traceln "Did not grab any value from queue\n"; *)
          (* print_endline "The queue is empty for this particular key"; *)
          (* Eio.traceln "The queue is empty for this particular key"; *)
          receive_message ~location)
  | None ->
      (* Eio.traceln "Did not find the correct key\n"; *)
      receive_message ~location
