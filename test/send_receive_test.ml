open OUnit2
open Http_pirc

let setup_test () =
  match Lwt_main.run (Send_receive.init ()) with
  | Ok () -> ()
  | Error msg ->
    Printf.printf "Failed to initialize config: %s\n" msg;
    assert_failure msg
;;

let test_send_receive _ =
  setup_test ();
  let test_data = "test message" in
  let result = Lwt_main.run (Send_receive.send_message ~location:"Bob" ~data:test_data) in
  match result with
  | Ok () -> ()
  | Error msg -> assert_failure msg
;;

let () =
  run_test_tt_main
    ("send_receive_tests" >::: [ "send_message_test" >:: test_send_receive ])
;;
