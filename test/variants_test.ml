open OUnit2


let ast_equals (s:string) =
let program = Parsing.Parse.parse_with_error (Lexing.from_string s) in
assert_equal program []

;;




let suite =
  "Variant Tests"
  >::: [ "Examples"
         >::: [ ("testcase1" >:: fun _ -> ast_equals Variants_testcases.simple)
              ]
       ]
;;

let () = run_test_tt_main suite
