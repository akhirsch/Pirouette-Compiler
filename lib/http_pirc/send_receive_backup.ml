open Cohttp
open Cohttp_lwt_unix
open Lwt.Infix
open Lwt.Syntax (* For let+ and let* syntax *)
open Saturn

(* Global config reference *)
let config = ref None

(* Message queues for each location *)
(* let message_queues = Hashtbl.create 10 *)
let message_queues : (string, string) Htbl.t =
  Htbl.create ~hashed_type:(module String) ()

let message_condition = Lwt_condition.create ()

(* Helper to get location config *)
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

let get_body string_to_send =
  let body_to_send = Some (Body.of_string string_to_send) in
  body_to_send

let get_ip_address ~location =
  match get_location_config location with
  | Ok loc_config -> Uri.of_string loc_config.http_address
  | _ -> Uri.empty

let get_header ~location_name =
  let new_header = Http.Header.init () in
  let header_to_send = Http.Header.add new_header "Location" location_name in
  header_to_send

(* Function to marshal data *)
let marshal_data data =
  try
    let result = Marshal.to_string data [] in
    result
  with e -> raise e

(* Function to unmarshal data *)
let unmarshal_data data_str =
  try
    if String.length data_str = 0 then Error "Empty data string"
    else
      let result = Marshal.from_string data_str 0 in
      Ok result
  with e -> Error ("Unmarshal error: " ^ Printexc.to_string e)

(* Internal Mapping Functions *)
let map_send_location location = location
let map_receive_location location = location

(* This is the handler for incoming http requests *)
let handler _socket request body =
  let x : Cohttp_eio.Body.t = body in
  let sender_body = Eio.Buf_read.(parse_exn take_all) ~max_size:max_int x in
  let recv_headers = Http.Request.headers request in
  let sender_location = Http.Header.get recv_headers "Location" in
  match sender_location with
  | None -> Cohttp_eio.Server.respond_string ~status:`Not_found ~body:"" ()
  | Some unwrapped_sender_location -> (
      let indexed_queue =
        Hashtbl.find_opt message_queues unwrapped_sender_location
      in
      (match indexed_queue with
      | Some result_queue -> Eio.Stream.add result_queue sender_body
      | None ->
          Hashtbl.add message_queues unwrapped_sender_location
            (Eio.Stream.create 10);
          let indexed_queue =
            Hashtbl.find message_queues unwrapped_sender_location
          in
          Eio.Stream.add indexed_queue sender_body);
      (* (match header_string with *)
      (*  | Some x -> Printf.printf "This is the value of the string %s\n" x *)
      (*  | None -> print_endline "The header does not have a host location\n"); *)
      (match Http.Request.meth request with
      | `GET -> print_endline "The get method was called"
      | `POST -> (
          let cond = Http.Request.has_body request in
          match cond with
          | `No -> print_endline "There is no body"
          | `Unknown -> print_endline "Unknown"
          | `Yes -> print_endline "Yes ; there is a body good news")
      | _ -> print_endline "Something else was called");
      match Http.Request.resource request with
      | "/" -> Cohttp_eio.Server.respond_string ~status:`OK ~body:"" ()
      | "/html" ->
          (* Use a plain flow to test chunked encoding *)
          let body = Eio.Flow.string_source "" in
          Cohttp_eio.Server.respond () ~status:`OK
            ~headers:(Http.Header.of_list [ ("content-type", "text/html") ])
            ~body
      | "/post" ->
          print_endline "This is the post request from the client";
          Cohttp_eio.Server.respond_string ~status:`OK
            ~body:"This is the post method being invoked" ()
      | _ -> Cohttp_eio.Server.respond_string ~status:`Not_found ~body:"" ())

(* This is to setup config ; ie update the reference and pull the values from that into a hashtable *)
let setup_config_file () =
  (* First collect all original addresses *)
  match !config with
  | None -> ()
  | Some cfg ->
      let loc_to_address = Hashtbl.create 10 in
      List.iter
        (fun loc_cfg ->
          Hashtbl.add loc_to_address loc_cfg.Config_parser.location
            loc_cfg.Config_parser.http_address)
        cfg.Config_parser.locations;
      (* Now create a new config with the updated addresses *)
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
  let () = setup_config_file () in
  Printf.printf "Starting an HTTP server for this specific node: %s\n"
    current_location;
  (* The following statement sets up logs for debugging *)
  let () = Logs.set_reporter (Logs_fmt.reporter ())
  and () = Logs.Src.set_level Cohttp_eio.src (Some Debug) in
  let log_warning ex = Logs.warn (fun f -> f "%a" Eio.Exn.pp ex) in
  (* This runs the Eio event loop for the server *)
  let _ =
    let port = ref 8080 in
    Arg.parse
      [ ("-p", Arg.Set_int port, " Listening port number(8080 by default)") ]
      ignore "An HTTP/1.1 server";
    Eio_main.run @@ fun env ->
    Eio.Switch.run @@ fun sw ->
    let socket =
      Eio.Net.listen env#net ~sw ~backlog:128 ~reuse_addr:true
        (`Tcp (Eio.Net.Ipaddr.V4.loopback, !port))
    in
    let server = Cohttp_eio.Server.make ~callback:handler () in
    Cohttp_eio.Server.run socket server ~on_error:log_warning
  in
  ()

(* Function to receive a message *)
let rec receive_message ~location =
  let actual_location = map_receive_location location in
  (* First check if we have a local message *)
  let local_message = Htbl.find_opt message_queues actual_location in
  match local_message with
  | Some data when String.length data > 0 -> (
      (* Message found in queue, remove it *)
      let _ = Htbl.try_remove message_queues actual_location in
      (* Try to unmarshal the data *)
      try
        let unmarshaled_data = Marshal.from_string data 0 in
        (* Print the actual unmarshaled data in readable format *)
        Printf.printf "DATA RECEIVED FROM QUEUE: %s\n"
          (match unmarshaled_data with
          | _ when Obj.is_int (Obj.repr unmarshaled_data) ->
              "INT: " ^ string_of_int (Obj.magic unmarshaled_data)
          | _ when Obj.tag (Obj.repr unmarshaled_data) = Obj.string_tag ->
              "STRING: " ^ Obj.magic unmarshaled_data
          | _ -> (
              try
                if
                  Obj.is_block (Obj.repr unmarshaled_data)
                  && Obj.tag (Obj.repr unmarshaled_data) = 0
                then
                  match Obj.magic unmarshaled_data with
                  | Ok v ->
                      if Obj.is_int (Obj.repr v) then
                        "Ok(" ^ string_of_int (Obj.magic v) ^ ")"
                      else if Obj.tag (Obj.repr v) = Obj.string_tag then
                        "Ok(\"" ^ Obj.magic v ^ "\")"
                      else "Ok(<value>)"
                  | Error msg -> "Error(\"" ^ msg ^ "\")"
                else "<complex data>"
              with _ -> "<unprintable data>"));
        flush stdout;
        Lwt.return_ok unmarshaled_data
      with e -> Lwt.return_error ("Unmarshal error: " ^ Printexc.to_string e))
  | _ -> (
      (* No local message, poll the remote server *)
      match get_location_config actual_location with
      | Error msg -> Lwt.return_error msg
      | Ok loc_config ->
          Printf.printf "Polling remote server for location %s at %s\n"
            actual_location loc_config.http_address;
          flush stdout;
          Lwt.catch
            (fun () ->
              (* Make HTTP request to poll for messages *)
              let headers =
                Header.init_with "Content-Type" "application/octet-stream"
              in
              let body = Cohttp_lwt.Body.of_string "" in
              (* Empty body indicates polling *)
              Client.post ~headers ~body (Uri.of_string loc_config.http_address)
              >>= fun (resp, body) ->
              let status = resp |> Response.status |> Code.code_of_status in
              if status <> 200 then
                Cohttp_lwt.Body.drain_body body >>= fun () ->
                Lwt.return_error
                  ("Failed to poll for message, status code: "
                 ^ string_of_int status)
              else
                Cohttp_lwt.Body.to_string body >>= fun body_str ->
                if String.length body_str = 0 then
                  (* No message available, wait a bit and try again *)
                  let* () = Lwt_unix.sleep 0.5 in
                  receive_message ~location
                else
                  (* Try to unmarshal the received data *)
                  match unmarshal_data body_str with
                  | Ok unmarshaled_data ->
                      Printf.printf "DATA RECEIVED FROM HTTP: %s\n"
                        (match unmarshaled_data with
                        | _ when Obj.is_int (Obj.repr unmarshaled_data) ->
                            "INT: " ^ string_of_int (Obj.magic unmarshaled_data)
                        | _
                          when Obj.tag (Obj.repr unmarshaled_data)
                               = Obj.string_tag ->
                            "STRING: " ^ Obj.magic unmarshaled_data
                        | _ -> "<complex data>");
                      flush stdout;
                      Lwt.return_ok unmarshaled_data
                  | Error err -> Lwt.return_error err)
            (fun e ->
              Printf.printf "Error polling for message: %s\n"
                (Printexc.to_string e);
              flush stdout;
              (* Wait a bit and try again *)
              let* () = Lwt_unix.sleep 1.0 in
              receive_message ~location))
