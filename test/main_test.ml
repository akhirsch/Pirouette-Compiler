open OUnit2

(*
*TO ADD A NEW TEST SUITE*

Create your test module, as one would expect
Create a comprehensive test suite in that test module.
Add that module's suite to the list below.
In the test/dune file;
  Add the module to the "main_test" stanza, in the "modules" section.
  Add any used libraries to the "libraries" section, if they're not already there.
*)

let main_suite =
  "Top Level test suite"
  >::: [
      Prettyprint_test.suite;
      Typcheck_test.all_suites;
      Parsing_test.suite;
      Marshal_test.suite;
      Dotast_test.suite;
      Net_parsing_test.suite;
      Emit_core_test.all_suites;
    ]
    
let () = run_test_tt_main main_suite