open OUnit2
open Codegen.Toplevel_shm
open Codegen.Msg_intf
module Net = Ast_core.Net.M
module Local = Ast_core.Local.M

module type Msg_intf = Codegen.Msg_intf.M

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

(*need to get an output from emit_toplevel_http, tried to use buffers, but function
  requires it to be out_chan. so make temporary file, then extract it, then remove it*)
let get_toplevel_http_output (module Msg : Msg_intf) loc_ids stmts =
  let temp_file = Filename.temp_file "test_http" ".ml" in
  let out_channel = open_out temp_file in
  emit_toplevel_http out_channel (module Msg) loc_ids stmts;
  flush out_channel;
  (*need to flush to get all the output properly*)
  close_out out_channel;
  let in_channel = open_in temp_file in
  let content = really_input_string in_channel (in_channel_length in_channel) in
  close_in in_channel;
  Sys.remove temp_file;
  content
;;

let get_toplevel_shm_output (module Msg : Msg_intf) loc_ids stmts =
  let temp_file = Filename.temp_file "test_shm" ".ml" in
  let out_channel = open_out temp_file in
  emit_toplevel_shm out_channel (module Msg) loc_ids stmts;
  flush out_channel;
  close_out out_channel;
  let in_channel = open_in temp_file in
  let content = really_input_string in_channel (in_channel_length in_channel) in
  close_in in_channel;
  Sys.remove temp_file;
  content
;;

(* ----------------------- emit_toplevel_shm tests ----------------------- *)
let shm_empty_loc _ =
  let result = get_toplevel_shm_output (module Msg_http_intf) [] [] in
  Printf.printf "Empty loc SHM output:\n'%s'\n\n" result;
  (*shouldn't have any initialisation when location list is empty*)
  assert_equal false (contains_substring result "domain_");
  assert_equal false (contains_substring result "Domain.spawn")
;;

let shm_single_loc _ =
  let loc_ids = [ "Alice" ] in
  let stmts = [ [] ] in
  let result = get_toplevel_shm_output (module Msg_http_intf) loc_ids stmts in
  Printf.printf "Single loc SHM output:\n'%s'\n\n" result;
  assert_equal true (contains_substring result "domain_Alice");
  assert_equal true (contains_substring result "Domain.spawn");
  assert_equal true (contains_substring result "fun _ -> ()")
;;

let shm_multiple_locations _ =
  let loc_ids = [ "Alice"; "Bob"; "Charlie" ] in
  let stmts = [ []; []; [] ] in
  let result = get_toplevel_shm_output (module Msg_http_intf) loc_ids stmts in
  Printf.printf "Multiple loc SHM output:\n'%s'\n\n" result;
  assert_equal true (contains_substring result "domain_Alice");
  assert_equal true (contains_substring result "domain_Bob");
  assert_equal true (contains_substring result "Domain.spawn")
;;

let shm_with_statement _ =
  let loc_ids = [ "Bob" ] in
  let stmt =
    Net.Assign
      ( [ Local.Var (VarId ("x", ()), ()) ]
      , Net.Ret (Local.Val (Local.Int (123, ()), ()), ())
      , () )
  in
  let stmts = [ [ stmt ] ] in
  let result = get_toplevel_shm_output (module Msg_http_intf) loc_ids stmts in
  Printf.printf "With statement SHM output:\n'%s'\n\n" result;
  assert_equal true (contains_substring result "domain_Bob");
  assert_equal true (contains_substring result "Domain.spawn");
  assert_equal true (contains_substring result "let rec x =");
  assert_equal true (contains_substring result "123");
  assert_equal true (contains_substring result "in ()")
;;

let shm_main_expr _ =
  let loc_ids = [ "Charlie" ] in
  let stmt =
    Net.Assign
      ( [ Local.Var (VarId ("main", ()), ()) ]
      , Net.Ret (Local.Val (Local.Int (321, ()), ()), ())
      , () )
  in
  let stmts = [ [ stmt ] ] in
  let result = get_toplevel_shm_output (module Msg_http_intf) loc_ids stmts in
  Printf.printf "Main expr SHM output:\n'%s'\n\n" result;
  assert_equal true (contains_substring result "domain_Charlie");
  assert_equal true (contains_substring result "Domain.spawn");
  assert_equal true (contains_substring result "321")
;;

(* ----------------------- emit_toplevel_http tests ----------------------- *)

let http_empty_loc _ =
  let result = get_toplevel_http_output (module Msg_http_intf) [] [] in
  assert_equal false (contains_substring result "process_")
;;

let http_single_loc _ =
  let loc_ids = [ "Alice" ] in
  let stmts = [ [] ] in
  let result = get_toplevel_http_output (module Msg_http_intf) loc_ids stmts in
  assert_equal true (contains_substring result "Starting initialization");
  assert_equal true (contains_substring result "Lwt_main.run");
  assert_equal true (contains_substring result "Send_receive.init");
  assert_equal true (contains_substring result "process_Alice");
  assert_equal true (contains_substring result "ignore process_Alice")
;;

let http_multiple_loc _ =
  let loc_ids = [ "Alice"; "Bob"; "Charlie" ] in
  let stmts = [ []; []; [] ] in
  let result = get_toplevel_http_output (module Msg_http_intf) loc_ids stmts in
  assert_equal true (contains_substring result "process_Alice");
  assert_equal true (contains_substring result "process_Bob");
  assert_equal true (contains_substring result "process_Charlie");
  assert_equal true (contains_substring result "Starting initialization")
;;

let http_stmts _ =
  let loc_ids = [ "Bob" ] in
  let stmt =
    Net.Assign
      ( [ Local.Var (VarId ("x", ()), ()) ]
      , Net.Ret (Local.Val (Local.Int (999, ()), ()), ())
      , () )
  in
  let stmts = [ [ stmt ] ] in
  let result = get_toplevel_http_output (module Msg_http_intf) loc_ids stmts in
  assert_equal true (contains_substring result "process_Bob");
  assert_equal true (contains_substring result "let x =");
  assert_equal true (contains_substring result "999")
;;

let http_main_expr _ =
  let loc_ids = [ "Charlie" ] in
  let stmt =
    Net.Assign
      ( [ Local.Var (VarId ("main", ()), ()) ]
      , Net.Ret (Local.Val (Local.Int (111, ()), ()), ())
      , () )
  in
  let stmts = [ [ stmt ] ] in
  let result = get_toplevel_http_output (module Msg_http_intf) loc_ids stmts in
  assert_equal true (contains_substring result "Starting initialization");
  assert_equal true (contains_substring result "Lwt_main.run");
  assert_equal true (contains_substring result "process_Charlie");
  assert_equal true (contains_substring result "111")
;;

let http_errors _ =
  let loc_ids = [ "Alice" ] in
  let stmts = [ [] ] in
  let result = get_toplevel_http_output (module Msg_http_intf) loc_ids stmts in
  assert_equal true (contains_substring result "match Lwt_main.run");
  assert_equal true (contains_substring result "| Error msg ->");
  assert_equal true (contains_substring result "failwith");
  assert_equal true (contains_substring result "Init error:")
;;

(* ----------------------- Test suites ----------------------- *)

let toplevel_shm_suite =
  "Toplevel SHM tests"
  >::: [ "Empty location" >:: shm_empty_loc
       ; "Single location" >:: shm_single_loc
       ; "Multiple locations" >:: shm_multiple_locations
       ; "With statements" >:: shm_with_statement
       ; "Main expression" >:: shm_main_expr
       ]
;;

let toplevel_http_suite =
  "Toplevel HTTP tests"
  >::: [ "Empty location" >:: http_empty_loc
       ; "Single location" >:: http_single_loc
       ; "Multiple locations" >:: http_multiple_loc
       ; "With statements" >:: http_stmts
       ; "Main expression" >:: http_main_expr
       ; "Errors" >:: http_errors
       ]
;;

let all_suites = "Toplevel Codegen Tests" >::: [ toplevel_shm_suite; toplevel_http_suite ]
let () = run_test_tt_main all_suites
