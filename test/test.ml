open OUnit2

let suite =
  "Full Test Suite"
  >::: [
         "Pretty Print Tests" >::: Testpretty.suite;
         "Ocaml Gen Tests" >::: Ocamlgen_test.suite;
         "Parser Tests" >::: Testparser.suite;
       ]

let () = run_test_tt_main suite
