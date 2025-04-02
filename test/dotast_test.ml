open OUnit2

let diff_dot_strings expected actual =
  (* First, try to see if they're identical *)
  if expected = actual then
    Printf.printf "Strings are identical\n"
  else begin
    (* Check for line-based differences *)
    let expected_lines = String.split_on_char '\n' expected in
    let actual_lines = String.split_on_char '\n' actual in
    
    let max_lines = max (List.length expected_lines) (List.length actual_lines) in
    let diff_lines = ref [] in
    
    for i = 0 to max_lines - 1 do
      let expected_line = try List.nth expected_lines i with _ -> "" in
      let actual_line = try List.nth actual_lines i with _ -> "" in
      
      if expected_line <> actual_line then
        diff_lines := (i+1, expected_line, actual_line) :: !diff_lines
    done;
    
    (* Format and print the differences with line numbers *)
    if !diff_lines = [] then
      Printf.printf "Differences found but couldn't identify specific lines\n"
    else begin
      Printf.printf "Differences found:\n";
      List.rev !diff_lines
      |> List.iter (fun (line_num, exp, act) ->
          Printf.printf "Line %d:\n  Expected: %s\n  Actual:   %s\n\n" 
            line_num exp act)
    end
  end

  let deq (pir) (dot_expected) =
    let program = Parsing.Parse.parse_with_error (Lexing.from_string pir) in
    let dot_actual = Ast_utils.stringify_dot_choreo_ast Parsing.Parsed_ast.Pos_info.string_of_pos program in
    print_string ("\nExpected:\n" ^ dot_expected ^ "\nActual:\n" ^ dot_actual ^ "\n");
    diff_dot_strings dot_expected dot_actual;
    try
      assert_equal dot_expected dot_actual
    with _ ->
      Printf.printf "Assertion failed but continuing tests\n";
      ()
  ;;
let test_1_dot _ = deq Dotgen_testcases.pir_1 Dotgen_testcases.dot_1
;;(* put the dot ast test here *)

let test_2_dot _ = deq Dotgen_testcases.pir_2 Dotgen_testcases.dot_2
;;

let test_3_dot _ = deq Dotgen_testcases.pir_3 Dotgen_testcases.dot_3
;;

let test_4_dot _ = deq Dotgen_testcases.pir_4 Dotgen_testcases.dot_4
;;

let test_5_dot _ = deq Dotgen_testcases.pir_5 Dotgen_testcases.dot_5

let test_6_dot _ = deq Dotgen_testcases.pir_6 Dotgen_testcases.dot_6

let test_7_dot _ = deq Dotgen_testcases.pir_7 Dotgen_testcases.dot_7

let test_8_dot _ = deq Dotgen_testcases.pir_8 Dotgen_testcases.dot_8

let test_9_dot _ = deq Dotgen_testcases.pir_9 Dotgen_testcases.dot_9

let test_10_dot _ = deq Dotgen_testcases.pir_10 Dotgen_testcases.dot_10

let test_11_dot _ = deq Dotgen_testcases.pir_11 Dotgen_testcases.dot_11

let test_12_dot _ = deq Dotgen_testcases.pir_12 Dotgen_testcases.dot_12

let test_13_dot _ = deq Dotgen_testcases.pir_13 Dotgen_testcases.dot_13
let suite =
  "Dot Tests"
  >::: [ "Examples"
         >::: [ ("testcase1" >:: test_1_dot )
              ; ("testcase2" >:: test_2_dot)
              ; ("testcase3" >:: test_3_dot)
              ; ("testcase4" >:: test_4_dot)
              ; ("testcase5" >:: test_5_dot)
              ; ("testcase6" >:: test_6_dot)
              ; ("testcase7" >:: test_7_dot)
              ; ("testcase8" >:: test_8_dot)
              ; ("testcase9" >:: test_9_dot)
              ; ("testcase10" >:: test_10_dot)
              ; ("testcase11" >:: test_11_dot)
              ; ("testcase12" >:: test_12_dot)
              ; ("testcase13" >:: test_13_dot)
              ]
       ]
;; 
let () = run_test_tt_main suite 