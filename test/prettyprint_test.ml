open OUnit2

let peq (s : string) =
  let program = Parsing.Parse.parse_with_error (Lexing.from_string s) in
  let pprint_s = Ast_utils.stringify_pprint_choreo_ast program in
  let _ = print_string ("\n" ^ pprint_s ^ "\n") in
  let program' = Parsing.Parse.parse_with_error (Lexing.from_string pprint_s) in
  let json_ast = Ast_utils.stringify_jsonify_choreo_ast program in
  let json_ast' = Ast_utils.stringify_jsonify_choreo_ast program' in
  assert_equal json_ast json_ast'
;;

let net_peq (net_s : string) = assert_equal net_s net_s (* TO DO *)

let suite =
  "Pretty print Tests"
  >::: [ "Examples"
         >::: [ ("testcase1" >:: fun _ -> peq Astutils_testcases.testcase_1)
              ; ("testcase2" >:: fun _ -> peq Astutils_testcases.testcase_2)
              ; ("testcase3" >:: fun _ -> peq Astutils_testcases.testcase_3)
              ; ("testcase4" >:: fun _ -> peq Astutils_testcases.testcase_4)
              ]
       ; "Type Decls"
         >::: [ ("choreo_typs" >:: fun _ -> peq Astutils_testcases.choreo_typs)
              ; ("local_typs" >:: fun _ -> peq Astutils_testcases.local_typs)
              ]
       ; "Functions"
         >::: [ ("define a function" >:: fun _ -> peq Astutils_testcases.choreo_fundef) ]
       ; "Pattern Matching"
         >::: [ ("choreo_pat_match" >:: fun _ -> peq Astutils_testcases.choreo_pat_match)
              ; ("local_pat_match" >:: fun _ -> peq Astutils_testcases.lcl_pat_match)
              ; ("local_pat_match_2" >:: fun _ -> peq Astutils_testcases.lcl_pat_match_2)
              ]
       ; "Foreign Declarations"
         >::: [ ("foreign_decl" >:: fun _ -> peq Astutils_testcases.foreign_decl) ]
       ; "Net IR"
         >::: [ ("test_net_peq" >:: fun _ -> net_peq Astutils_testcases.net_test_1) ]
         (* ADD more net_peq tests here *)
         (* ; "Constructors"
         >::: [ 
           ("no_constructor_list" >:: fun _ -> peq Astutils_testcases.no_constructor_list)
         ; ("one_constructor_one_arg" >:: fun _ -> peq Astutils_testcases.one_constructor_one_arg)
         ; ("one_constructor_multi_arg" >:: fun _ -> peq Astutils_testcases.one_constructor_multi_arg)
         ; ("two_constructors_one_arg" >:: fun _ -> peq Astutils_testcases.two_constructors_one_arg)
         ; ("two_constructors_multi_arg" >:: fun _ -> peq Astutils_testcases.two_constructors_multi_arg)
         ; ("ten_constructors_ten_args" >:: fun _ -> peq Astutils_testcases.ten_constructors_ten_args)
         ; ("negative_missing_colon" >:: fun _ -> assert_raises (Parsing.Parse.parse_with_error (Lexing.from_string (Astutils_testcases.negative_missing_colon))))
         ; ("negative_missing_pipe" >:: fun _ -> assert_raises (Parsing.Parse.parse_with_error (Lexing.from_string Astutils_testcases.negative_missing_pipe)))
         ] *)
       ]
;;

let () = run_test_tt_main suite
