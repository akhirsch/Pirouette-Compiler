open OUnit2

let test_simple_dot _ = assert_equal true true (* put the dot ast test here *)
let suite = "Dot Tests" >::: [ "test_simple_dot" >:: test_simple_dot ]
let () = run_test_tt_main suite
