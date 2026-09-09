open OUnit2

let suite =
  "Full Test Suite" >::: [ 
    "Pretty Print Tests" >::: Testpretty.suite;
    "Parser Tests" >::: Testparser.suite
    ]

let () = run_test_tt_main suite
