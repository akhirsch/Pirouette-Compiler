open OUnit2

let deq (pir :string) (dot_expected) =
  let dot_from_program = Dot_ast.generate_dot_code pir in
  let dot_actual = (Ast_utils.stringify_dot_choreo_ast dot_from_program) in
  try 
    assert_equal dot_actual dot_expected
  with OUnit2.Assert_failure _ ->
    Printf.printf "\n\nExpected DOT:\n%s\n\n" dot_expected;
    Printf.printf "Actual DOT:\n%s\n\n" dot_actual;
    (* Re-raise the exception after printing to still fail the test *)
    raise (OUnit2.Assert_failure ("DOT strings are not equal", 0, 0))
;;

let test_1_dot _ = deq Dotgen_testcases.pir_1 Dotgen_testcases.dot_1
;;(* put the dot ast test here *)

let test_2_dot _ = deq Dotgen_testcases.pir_2 Dotgen_testcases.dot_2
;;
let suite = "Dot Tests" >::: [ "test_simple_dot" >:: test_1_dot ]
let () = run_test_tt_main suite