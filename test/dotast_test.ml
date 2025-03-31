open OUnit2

let deq (pir) (dot_expected) =
  let program = Parsing.Parse.parse_with_error (Lexing.from_string pir) in
  let dot_actual = Ast_utils.stringify_dot_choreo_ast Parsing.Parsed_ast.Pos_info.string_of_pos program in
  print_string ("Expected:" ^ dot_expected ^ "\nActual:" ^ dot_actual ^ "\n");
  assert_equal dot_actual dot_expected
;;
let test_1_dot _ = deq Dotgen_testcases.pir_1 Dotgen_testcases.dot_1
;;(* put the dot ast test here *)

let test_2_dot _ = deq Dotgen_testcases.pir_2 Dotgen_testcases.dot_2
;;

let test_3_dot _ = deq Dotgen_testcases.pir_3 Dotgen_testcases.dot_3
;;

let test_4_dot _ = deq Dotgen_testcases.pir_4 Dotgen_testcases.dot_4
;;
let suite =
  "Dot Tests"
  >::: [ "Examples"
         >::: [ ("testcase1" >:: test_1_dot )
              ; ("testcase2" >:: test_2_dot)
              ; ("testcase3" >:: test_3_dot)
              ; ("testcase4" >:: test_4_dot)
              ]
       ]
;;
let () = run_test_tt_main suite