open OUnit2

let peq (s : string) =
  let pprint_s_ref = ref "" in
  let json_ast_ref = ref "" in
  try
    let program = Parsing.Parse.parse_with_error (Lexing.from_string s) in
    let pprint_s = Ast_utils.stringify_pprint_choreo_ast program in
    pprint_s_ref := pprint_s;
    (* Store potentially problematic pretty-printed string *)
    let program' = Parsing.Parse.parse_with_error (Lexing.from_string pprint_s) in
    let json_ast = Ast_utils.stringify_jsonify_choreo_ast program in
    json_ast_ref := json_ast;
    (* Store original AST *)
    let json_ast' = Ast_utils.stringify_jsonify_choreo_ast program' in
    assert_equal json_ast json_ast'
  with
  | Failure msg ->
    print_endline "\nError in choreography pretty printing:";
    print_endline ("Original: " ^ s);
    print_endline ("Pretty printed: " ^ !pprint_s_ref);
    print_endline ("Original AST: " ^ !json_ast_ref);
    (* We might not have json_ast' if parsing pprint_s failed *)
    print_endline ("Failure message: " ^ msg);
    raise (Failure ("Pretty printing failed: " ^ msg))
;;

let net_peq (s : string) =
  let pprint_s_ref = ref "" in
  let json_ast_ref = ref "" in
  try
    let program = Parsing.Parse.parse_net_with_error (Lexing.from_string s) in
    let pprint_s = Ast_utils.stringify_pprint_net_ast program in
    pprint_s_ref := pprint_s;
    (* Store potentially problematic pretty-printed string *)
    let program' = Parsing.Parse.parse_net_with_error (Lexing.from_string pprint_s) in
    let json_ast = Ast_utils.stringify_jsonify_net_ast program in
    json_ast_ref := json_ast;
    (* Store original AST *)
    let json_ast' = Ast_utils.stringify_jsonify_net_ast program' in
    assert_equal json_ast json_ast'
  with
  | Failure msg ->
    print_endline "\nError in network pretty printing:";
    print_endline ("Original: " ^ s);
    print_endline ("Pretty printed: " ^ !pprint_s_ref);
    print_endline ("Original AST: " ^ !json_ast_ref);
    (* We might not have json_ast' if parsing pprint_s failed *)
    print_endline ("Failure message: " ^ msg);
    raise (Failure ("Pretty printing failed: " ^ msg))
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
         >::: [ ("simple_net" >:: fun _ -> net_peq Astutils_testcases.simple_net)
              ; ("ex3_netir" >:: fun _ -> net_peq Astutils_testcases.netir_ex3)
              ]
       ]
;;

let () = run_test_tt_main suite
