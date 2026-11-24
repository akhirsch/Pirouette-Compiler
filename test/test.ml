open OUnit2

let suite =
  "Full Test Suite"
  >::: [
         "Pretty Print Tests" >::: Testpretty.suite;
         "Parser Tests" >::: Testparser.suite;
         "Dot Tests" >::: Testdot.suite;
         "Eio Communication Generation Tests" >::: Testeio.suite;
       ]

let () = run_test_tt_main suite
