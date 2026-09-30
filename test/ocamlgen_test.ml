open OUnit2
module A = Netir.Nometa
module G = Backend.Ocamlgen.MkOcamlGen (Netir.Ast.MkAST (Metainfo.Meta.TrivInfo))
open A

(* run a NetIR expr through the generator and print the resulting OCaml *)

(* Two modules:
   - A is the NetIR AST with nometa data which is unit metadata, giving us the smart constructors
     to build test inputs
   - G is our code generator the real translator being tested *)
let expr_str e = Ppxlib.Pprintast.string_of_expression (G.expr_gen e)
(* Run a NetIR expression through the generator and print the resulting OCaml
   G.expr_gen: produces a ppxlib Parsetree node 
   Ppxlib.Pprintast turns it into source text *)

(* Note: generator is built on ppxlib: expr_gen returns Ppxlib.Parsetree.expression 
that is why i  print it with the printer that speaks ppxlib's AST — Ppxlib.Pprintast *)

let test_expr expected e _ =
  assert_equal ~printer:(fun x -> x) expected (expr_str e)

(* TODO: Match RecAbs AllowChoice *)

(* WHAT I AM DOING: building NetIR AST nodes with the smart constructors from the 
nometa.ml module feeding them to expr_gen THEN checking the OCaml that comes out *)
let suite =
  [
    (* ---- Literals and variables: direct translatoions ----- *)
    "int" >:: test_expr "3" (intlit 3);
    "float" >:: test_expr "3.5" (floatlit 3.5);
    "char" >:: test_expr "'c'" (charlit 'c');
    "string" >:: test_expr {|"hello"|} (stringlit "hello");
    "true" >:: test_expr "true" truelit;
    "false" >:: test_expr "false" falselit;
    "var" >:: test_expr "x" (var "x");
    "unit" >:: test_expr "()" unitlit;
    "loclit" >:: test_expr {|"A"|} (loclit "A");
    (*---------- Operators: unop/binop applied ----------------*)
    "plus" >:: test_expr "3 + 4" (mkplus (intlit 3) (intlit 4));
    "neg" >:: test_expr "~- 3" (unop neg (intlit 3));
    "not" >:: test_expr "not true" (unop not truelit);
    (*----------- Application and type annotation --------------*)
    "funapp" >:: test_expr "f 4" (funapp (var "f") (intlit 4));
    "annot" >:: test_expr "(3 : int)" (typeconstr (intlit 3) intty);
    (*--------- Communication: calls to Dummybackend -----------*)
    "send" >:: test_expr {|Dummybackend.send "A" 3|} (send (intlit 3) "A");
    "recv" >:: test_expr {|(Dummybackend.recv "A" : int)|} (recv intty "A");
    "choose"
    >:: test_expr {|Dummybackend.choose "A" "L"|} (choosefor "A" (mklab "L"));
    (* mklab is in nometa.ml *)

    (* -------------- Location check: Iam check ----------------*)
    (* AmI compares the given location against me the file's own identity*)
    "ami" >:: test_expr {|"A" = me|} (ami (loclit "A"));
  ]

let () = run_test_tt_main ("ocamlgen" >::: suite)
