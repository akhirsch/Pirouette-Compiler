open OUnit2

let suite =
  "Full Test Suite"
  >::: [
         "Pretty Print Tests" >::: Testpretty.suite;
<<<<<<< HEAD
         "Dot Tests" >::: Testdot.suite;
=======
         "Parser Tests" >::: Testparser.suite;
>>>>>>> 76673e185874b7f6db9a7015824fd47051bd7f8a
       ]

let () = run_test_tt_main suite
