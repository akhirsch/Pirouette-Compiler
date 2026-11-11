open OUnit2

let suite =
  "Full Test Suite"
  >::: [
         "Pretty Print Tests" >::: Testpretty.suite;
         "Parser Tests" >::: Testparser.suite;
         "Dot Tests" >::: Testdot.suite;
         "Ocaml Gen Tests" >::: Ocamlgen_test.suite;
       ]

let () = run_test_tt_main suite
