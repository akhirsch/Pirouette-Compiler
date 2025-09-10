open OUnit2
open Ppxlib
open Codegen.Msg_intf

let expr_to_string expr = Pprintast.string_of_expression expr
let struct_to_string str = Pprintast.string_of_structure str
let loc = { !Ast_helper.default_loc with loc_ghost = true }

let contains_substring string substring =
  let s_length = String.length string in
  let sub_length = String.length substring in
  if sub_length = 0
  then true
  else if sub_length > s_length
  then false
  else (
    let rec check_subs i =
      if i > s_length - sub_length
      then false
      else if String.sub string i sub_length = substring
      then true
      else check_subs (i + 1)
    in
    check_subs 0)
;;

(*---------------------- Channel testcases ------------------------- *)
let test_chan_empty _ =
  let result = Msg_chan_intf.emit_toplevel_init [] in
  assert_equal [] result
;;

let test_chan_single _ =
  (*shouldn't create any channels*)
  let result = Msg_chan_intf.emit_toplevel_init [ "Alice" ] in
  assert_equal [] result
;;

let test_chan_pair _ =
  let result = Msg_chan_intf.emit_toplevel_init [ "Alice"; "Bob" ] in
  (*should have created 2 channels, alice to bob, bob to alice*)
  assert_equal 2 (List.length result);
  let result_str = struct_to_string result in
  (*check that the generated AST correctly contains these*)
  assert_equal true (contains_substring result_str "Domainslib.Chan.make_bounded");
  assert_equal true (contains_substring result_str "chan_Alice_Bob");
  assert_equal true (contains_substring result_str "chan_Bob_Alice")
;;

let test_chan_send _ =
  let send_expr =
    Msg_chan_intf.emit_net_send ~src:"Alice" ~dst:"Bob" (Ast_builder.Default.eint ~loc 5)
  in
  let result = expr_to_string send_expr in
  assert_equal true (contains_substring result "Domainslib.Chan.send");
  assert_equal true (contains_substring result "chan_Alice_Bob");
  assert_equal true (contains_substring result "5")
;;

let test_chan_recv _ =
  let recv_expr = Msg_chan_intf.emit_net_recv ~src:"Alice" ~dst:"Bob" in
  let result = expr_to_string recv_expr in
  assert_equal true (contains_substring result "Domainslib.Chan.recv");
  assert_equal true (contains_substring result "chan_Alice_Bob")
;;

(*---------------------- http testcases ------------------------- *)
let test_http_init _ =
  let result = Msg_http_intf.emit_toplevel_init [ "Alice"; "Bob" ] in
  assert_equal [] result
;;

let test_http_send _ =
  let send_expr =
    Msg_http_intf.emit_net_send ~src:"Alice" ~dst:"Bob" (Ast_builder.Default.eint ~loc 5)
  in
  let result = expr_to_string send_expr in
  assert_equal true (contains_substring result "Lwt_main.run");
  assert_equal true (contains_substring result "Send_receive.send_message");
  assert_equal true (contains_substring result "location");
  assert_equal true (contains_substring result "Bob");
  assert_equal true (contains_substring result "data");
  assert_equal true (contains_substring result "5");
  assert_equal true (contains_substring result "Error");
  assert_equal true (contains_substring result "Ok")
;;

let test_http_recv _ =
  let recv_expr = Msg_http_intf.emit_net_recv ~src:"Alice" ~dst:"Bob" in
  let result = expr_to_string recv_expr in
  assert_equal true (contains_substring result "Lwt_main.run");
  assert_equal true (contains_substring result "Send_receive.receive_message");
  assert_equal true (contains_substring result "location");
  assert_equal true (contains_substring result "Bob");
  assert_equal true (contains_substring result "Error");
  assert_equal true (contains_substring result "Ok")
;;

let suite =
  "Msg_intf Tests"
  >::: [ "Channel Interface Tests"
         >::: [ "empty init" >:: test_chan_empty
              ; "single process init" >:: test_chan_single
              ; "pair process init" >:: test_chan_pair
              ; "channel send" >:: test_chan_send
              ; "channel receive" >:: test_chan_recv
              ]
       ; "HTTP Interface Tests"
         >::: [ "http init" >:: test_http_init
              ; "http send" >:: test_http_send
              ; "http receive" >:: test_http_recv
              ]
       ]
;;

let () = run_test_tt_main suite