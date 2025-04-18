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

let net_peq (s : string) =
  let program = Parsing.Parse.parse_net_with_error (Lexing.from_string s) in
  let pprint_s = Ast_utils.stringify_pprint_net_ast program in
  let _ = print_string ("\n" ^ pprint_s ^ "\n") in
  let program' = Parsing.Parse.parse_net_with_error (Lexing.from_string pprint_s) in
  let json_ast = Ast_utils.stringify_jsonify_net_ast program in
  let json_ast' = Ast_utils.stringify_jsonify_net_ast program' in
  assert_equal json_ast json_ast'
;;

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
         >::: [ 
               ("ex3_netir" >:: fun _ -> net_peq Astutils_testcases.netir_ex3)
              ]
         (* ADD more net_peq tests here *)
       ]
;;

let () = run_test_tt_main suite
