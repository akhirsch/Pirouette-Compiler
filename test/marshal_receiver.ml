open OUnit2
open Lwt.Infix
open Http_pirc
open Types_test

let setup_logs () =
  Logs.set_reporter (Logs_fmt.reporter ());
  Logs.set_level (Some Logs.Debug);
  Lwt.return_unit
;;

let send_data location data =
  Send_receive.send_message ~location ~data
  >>= function
  | Ok () -> Lwt.return_unit
  | Error msg -> Lwt.return (assert_failure msg)
;;

let test_send_int _ =
  let data = 10 in
  Lwt_main.run (send_data "Bob" data)
;;

let test_send_float _ =
  let data = 3.14 in
  Lwt_main.run (send_data "Bob" data)
;;

let test_send_bool _ =
  let data = true in
  Lwt_main.run (send_data "Bob" data)
;;

let test_send_string _ =
  let data = "Hello, world!" in
  Lwt_main.run (send_data "Bob" data)
;;

let test_send_list _ =
  let data = [ 1; 2; 3; 4; 5 ] in
  Lwt_main.run (send_data "Bob" data)
;;

let test_send_color _ =
  let data = Red in
  Lwt_main.run (send_data "Bob" data)
;;

let test_send_person _ =
  let data = { name = "Ethan"; age = 20; favorite_colors = [ Green; Blue ] } in
  Lwt_main.run (send_data "Bob" data)
;;

let suite =
  "Marshal Sender Test Suite"
  >::: [ "test_send_int" >:: test_send_int
       ; "test_send_float" >:: test_send_float
       ; "test_send_bool" >:: test_send_bool
       ; "test_send_string" >:: test_send_string
       ; "test_send_list" >:: test_send_list
       ; "test_send_color" >:: test_send_color
       ; "test_send_person" >:: test_send_person
       ]
;;

let () =
  Lwt_main.run (setup_logs ());
  run_test_tt_main suite
;;
