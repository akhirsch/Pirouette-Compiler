open OUnit2


let ast_equals (s:string) =
let program = Parsing.Parse.parse_with_error (Lexing.from_string s) in
assert_equal program []

;;

(* dune exec pirc -- -ast-dump dot examples/exvariant1.pir *)
(* --profile release *)
(* dune exec pirc --profile release -- --ast-dump dot examples/variant_declaration.pir *)




let suite =
  "Variant Tests"
  >::: [ "Examples"
         >::: [ 
              ("testcase1" >:: fun _ -> ast_equals Variants_testcases.simple);
              (* ("testcase2" >:: fun _ -> ast_equals Variants_testcases.true_constructor);       
              ("testcase3" >:: fun _ -> ast_equals Variants_testcases.false_constructor);
              ("testcase4" >:: fun _ -> ast_equals Variants_testcases.nats);
              ("testcase5" >:: fun _ -> ast_equals Variants_testcases.lst);  *)
         ]
       ]
;;

let () = run_test_tt_main suite
