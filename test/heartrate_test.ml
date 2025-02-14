open OUnit2
open Heartrate


let test1 = assert_equal 1 (Heartrate.heartrate 1 1)

let test2 = assert_equal 100 (Foo.unity 100)

(* Name the test cases and group them together *)
let suite =
"suite">:::
 ["test1">:: test1;
  "test2">:: test2]
;;

let () =
  run_test_tt_main suite
;;

(*https://ocaml.org/p/ounit2/2.2.3/doc/index.html*)