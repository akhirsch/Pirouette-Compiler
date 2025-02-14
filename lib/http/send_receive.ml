open Cohttp
open Cohttp_lwt_unix
open Lwt.Infix

(* Global config reference *)
let config = ref None

(* Initialize config from file *)
let init () =
  let config_filename = "test/example.yaml" in
  Printf.printf "Loading config from: %s\n" config_filename;
  Printf.printf "Current working directory: %s\n" (Sys.getcwd());
  Config_parser.load_config config_filename >>= function
  | Some cfg -> 
      config := Some cfg;
      Printf.printf "Config loaded successfully with %d locations\n" 
        (List.length cfg.Config_parser.locations);
      List.iter (fun loc -> 
        Printf.printf "Location: %s, Address: %s\n" 
          loc.Config_parser.location 
          loc.Config_parser.http_address) cfg.Config_parser.locations;
      (* Try to initialize the server connection *)
      (match List.find_opt (fun loc -> loc.Config_parser.location = "init") cfg.Config_parser.locations with
       | Some init_config ->
           Client.get (Uri.of_string init_config.http_address)
           >>= fun (resp, body) ->
           let status = resp |> Response.status |> Code.code_of_status in
           Cohttp_lwt.Body.drain_body body >>= fun () ->
           if status = 200
           then (Printf.printf "Server initialized successfully\n"; Lwt.return_ok ())
           else Lwt.return_error ("Failed to initialize server, status: " ^ string_of_int status)
       | None -> 
           Printf.printf "No init endpoint found in config\n";
           Lwt.return_ok ())
  | None -> 
      Printf.printf "Failed to load config file\n";
      Lwt.return_error ("Failed to load config from " ^ config_filename)

(* Helper to get location config *)
let get_location_config location =
  match !config with
  | None -> 
      Printf.printf "Config not initialized for location: %s\n" location;
      Error "Config not initialized. Call init() first"
  | Some cfg ->
    match List.find_opt (fun loc -> loc.Config_parser.location = location) cfg.Config_parser.locations with
    | Some loc_config -> 
        Printf.printf "Found config for location %s: %s\n" location loc_config.http_address;
        Ok loc_config
    | None -> 
        Printf.printf "Unknown location requested: %s\n" location;
        Error ("Unknown location: " ^ location)

(* Function to marshal data *)
let marshal_data data = 
  try
    Printf.printf "Marshaling data of type: %s\n" (Obj.tag (Obj.repr data) |> string_of_int);
    let result = Marshal.to_string data [] in
    Printf.printf "Successfully marshaled data to length: %d\n" (String.length result);
    result
  with e ->
    Printf.printf "Error during marshaling: %s\n" (Printexc.to_string e);
    raise e

(* Function to unmarshal data *)
let unmarshal_data data_str =
  try 
    Printf.printf "Attempting to unmarshal data of length: %d\n" (String.length data_str);
    if String.length data_str = 0 then
      Error "Empty data string"
    else
      let result = Marshal.from_string data_str 0 in
      Printf.printf "Successfully unmarshaled data\n";
      Ok result
  with e -> 
    Printf.printf "Unmarshal error: %s\n" (Printexc.to_string e);
    Error ("Unmarshal error: " ^ Printexc.to_string e)

(* Internal Mapping Functions *)
let map_send_location location = 
  match location with
  | "R" -> "S"  (* Map "R" to "S" for sending *)
  | other -> other

let map_receive_location location =
  match location with
  | "S" -> "R"  (* Map "S" to "R" for receiving *)
  | other -> other

(* Function to send a message *)
let send_message ~location ~data =
  let actual_location = map_send_location location in
  Printf.printf "Attempting to send message to location: %s (mapped to: %s)\n" location actual_location;
  match get_location_config actual_location with
  | Error msg -> 
      Printf.printf "Error getting location config: %s\n" msg;
      Lwt.return_error msg
  | Ok loc_config ->
    try
      let marshaled_data = marshal_data data in
      let headers = Header.init_with "Content-Type" "application/octet-stream" in
      let body = Cohttp_lwt.Body.of_string marshaled_data in
      Printf.printf "Sending request to: %s with data length: %d\n" 
        loc_config.http_address (String.length marshaled_data);
      Client.post ~headers ~body (Uri.of_string loc_config.http_address)
      >>= fun (resp, body) ->
      let status = resp |> Response.status |> Code.code_of_status in
      Printf.printf "Received response with status: %d\n" status;
      Cohttp_lwt.Body.drain_body body
      >>= fun () ->
      if status = 200
      then Lwt.return_ok ()
      else Lwt.return_error ("Failed to send message, status code: " ^ string_of_int status)
    with e ->
      Printf.printf "Error during send_message: %s\n" (Printexc.to_string e);
      Lwt.return_error ("Send error: " ^ Printexc.to_string e)

(* Function to receive a message *)
let receive_message ~location =
  let actual_location = map_receive_location location in
  Printf.printf "Attempting to receive message from location: %s (mapped to: %s)\n" location actual_location;
  match get_location_config actual_location with
  | Error msg -> 
      Printf.printf "Error getting location config: %s\n" msg;
      Lwt.return_error msg
  | Ok loc_config ->
      let headers = Header.init_with "Content-Type" "application/octet-stream" in
      let empty_body = Cohttp_lwt.Body.of_string "" in
      Client.post ~headers ~body:empty_body (Uri.of_string loc_config.http_address)
      >>= fun (resp, body) ->
      let status = resp |> Response.status |> Code.code_of_status in
      Cohttp_lwt.Body.to_string body >>= fun body_str ->
      Printf.printf "Received body of length: %d\n" (String.length body_str);
      if status = 200 && String.length body_str > 0 then
        try
          let unmarshaled_data = Marshal.from_string body_str 0 in
          Printf.printf "Successfully unmarshaled data.\n";
          Lwt.return_ok unmarshaled_data
        with e -> 
          Printf.printf "Unmarshal error: %s\n" (Printexc.to_string e);
          Lwt.return_error ("Failed to unmarshal data: " ^ Printexc.to_string e)
      else if status = 200 then
        Lwt.return_error "Received empty response"
      else 
        Lwt.return_error ("Received error status: " ^ string_of_int status)
