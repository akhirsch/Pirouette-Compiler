open Cohttp
open Cohttp_lwt_unix
open Lwt.Infix

let sent_data = ref []
let initialized = ref false

let server =
  let callback _conn req body =
    let uri = req |> Request.uri |> Uri.path in
    match uri with
    | "/init" ->
      initialized := true;
      let response = Response.make ~status:`OK () in
      Lwt.return (response, Cohttp_lwt.Body.empty)
    | "/send" when !initialized ->
      body
      |> Cohttp_lwt.Body.to_string
      >|= fun body_str ->
      sent_data := !sent_data @ [ body_str ];
      Printf.printf "Server received data of length: %d\n" (String.length body_str);
      let headers = Header.init_with "Content-Type" "application/octet-stream" in
      let response = Response.make ~status:`OK ~headers () in
      response, Cohttp_lwt.Body.of_string "Data received"
    | "/receive" when !initialized ->
      let data = Marshal.to_string "L" [] in
      let headers = Header.init_with "Content-Type" "application/octet-stream" in
      let response = Response.make ~status:`OK ~headers () in
      Printf.printf "Server sending marshaled 'L' of length: %d\n" (String.length data);
      Lwt.return (response, Cohttp_lwt.Body.of_string data)
    | _ ->
      let response = Response.make ~status:`Not_found () in
      Lwt.return (response, Cohttp_lwt.Body.empty)
  in
  Server.create ~mode:(`TCP (`Port 8080)) (Server.make ~callback ())
;;

let () =
  Printf.printf "Starting server on port 8080...\n";
  flush stdout;
  Lwt_main.run server
;;
