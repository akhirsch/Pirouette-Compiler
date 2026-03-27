open OUnit2

(*
*TO ADD A NEW TEST SUITE*

Create your test module, as one would expect
Create a comprehensive test suite in that test module.
*DO NOT* call "run_test_tt_main" in that file; if that test fails, no more tests will be run.
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
         Parsing_test.suite;
         Ffi_test.main_suite;
       ]

let () =
  (*There doesn't seem to be a built-in way to get a testcase count, so we do it manually.*)
  let rec get_test_count test_list =
    match test_list with
    | OUnitTest.TestList tests :: xs -> get_test_count tests + get_test_count xs
    | OUnitTest.TestCase _ :: xs -> 1 + get_test_count xs
    | OUnitTest.TestLabel (_, test) :: xs -> get_test_count [ test ] + get_test_count xs
    | [] -> 0
  in

  print_string
    ("Running " ^ string_of_int (get_test_count [ main_suite ]) ^ " tests...");
  run_test_tt_main main_suite
