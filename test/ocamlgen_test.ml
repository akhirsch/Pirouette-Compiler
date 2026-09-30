open OUnit2
module A = Netir.Nometa
module G = Backend.Ocamlgen.MkOcamlGen (Netir.Ast.MkAST (Metainfo.Meta.TrivInfo))
open A

(* run a NetIR expr through the generator and print the resulting OCaml *)
let expr_str e = Ppxlib.Pprintast.string_of_expression (G.expr_gen e)

let test_expr expected e _ =
  assert_equal ~printer:(fun x -> x) expected (expr_str e)

let suite =
  [
    (* leaves *)
    "int" >:: test_expr "3" (intlit 3);
    "float" >:: test_expr "3.5" (floatlit 3.5);
    "char" >:: test_expr "'c'" (charlit 'c');
    "string" >:: test_expr {|"hello"|} (stringlit "hello");
    "true" >:: test_expr "true" truelit;
    "false" >:: test_expr "false" falselit;
    "var" >:: test_expr "x" (var "x");
    "unit" >:: test_expr "()" unitlit;
    "loclit" >:: test_expr {|"A"|} (loclit "A");
    (* operators *)
    "plus" >:: test_expr "3 + 4" (mkplus (intlit 3) (intlit 4));
    "neg" >:: test_expr "~- 3" (unop neg (intlit 3));
    "not" >:: test_expr "not true" (unop not truelit);
    (* application, annotation *)
    "funapp" >:: test_expr "f 4" (funapp (var "f") (intlit 4));
    "annot" >:: test_expr "(3 : int)" (typeconstr (intlit 3) intty);
    (* communication *)
    "send" >:: test_expr {|Dummybackend.send "A" 3|} (send (intlit 3) "A");
    "recv" >:: test_expr {|(Dummybackend.recv "A" : int)|} (recv intty "A");
    "choose"
    >:: test_expr {|Dummybackend.choose "A" "L"|} (choosefor "A" (mklab "L"));
    "ami" >:: test_expr {|"A" = me|} (ami (loclit "A"));
  ]

let () = run_test_tt_main ("ocamlgen" >::: suite)
