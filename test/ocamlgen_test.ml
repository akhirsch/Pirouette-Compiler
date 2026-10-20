open OUnit2
module A = Netir.Nometa
module G = Netir.Ocamlgen.MkOcamlGen (Netir.Ast.MkAST (Metainfo.Meta.TrivInfo))
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

(*  VARIANT HELPERS *)
let decl_structure d = Ppxlib.Pprintast.string_of_structure [ G.decl_gen d ]

(* G is my ocamlgen module *)
let test_decl expected d _ =
  assert_equal
    ~printer:(fun s -> "\n>>>\n" ^ s ^ "\n<<<\n")
      (* added this so that when it prints in the terminal it is more clear to 
      the white space errors i am having with variants *)
    expected (decl_structure d)

(*  PROGRAM GEN HELPERS *)
let prog_structure me p =
  Ppxlib.Pprintast.string_of_structure (G.program_gen me p)

let test_program expected me p _ =
  assert_equal
    ~printer:(fun s -> "\n>>>\n" ^ s ^ "\n<<<\n")
    expected (prog_structure me p)

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
    (*--------------------- Types --------------------------------*)
    "unitty" >:: test_expr "(() : unit)" (typeconstr unitlit unitty);
    "floatty" >:: test_expr "(3.5 : float)" (typeconstr (floatlit 3.5) floatty);
    "charty" >:: test_expr "('c' : char)" (typeconstr (charlit 'c') charty);
    "stringty"
    >:: test_expr {|("hi" : string)|} (typeconstr (stringlit "hi") stringty);
    "boolty" >:: test_expr "(true : bool)" (typeconstr truelit boolty);
    "funty"
    >:: test_expr "(f : int -> int)" (typeconstr (var "f") (funty intty intty));
    (*---------- Operators: unop/binop applied ----------------*)
    "plus" >:: test_expr "3 + 4" (mkplus (intlit 3) (intlit 4));
    "neg" >:: test_expr "~- 3" (unop neg (intlit 3));
    "not" >:: test_expr "not true" (unop not truelit);
    "minus" >:: test_expr "3 - 4" (mkminus (intlit 3) (intlit 4));
    "times" >:: test_expr "3 * 4" (mktimes (intlit 3) (intlit 4));
    "div" >:: test_expr "3 / 4" (mkdiv (intlit 3) (intlit 4));
    "and" >:: test_expr "true && false" (mkand truelit falselit);
    "or" >:: test_expr "true || false" (mkor truelit falselit);
    "eq" >:: test_expr "3 = 4" (mkeq (intlit 3) (intlit 4));
    "neq" >:: test_expr "3 <> 4" (mkneq (intlit 3) (intlit 4));
    "lt" >:: test_expr "3 < 4" (mklt (intlit 3) (intlit 4));
    "leq" >:: test_expr "3 <= 4" (mkleq (intlit 3) (intlit 4));
    "gt" >:: test_expr "3 > 4" (mkgt (intlit 3) (intlit 4));
    "geq" >:: test_expr "3 >= 4" (mkgeq (intlit 3) (intlit 4));
    "match_more_literals"
    >:: test_expr {|match x with | 3.5 -> 1 | 'c' -> 2 | "A" -> 3|}
          (mkmatch (var "x")
             [
               (floatlitpat 3.5, intlit 1);
               (charlitpat 'c', intlit 2);
               (loclitpat "A", intlit 3);
             ]);
    (*----------- Application and type annotation --------------*)
    "funapp" >:: test_expr "f 4" (funapp (var "f") (intlit 4));
    "annot" >:: test_expr "(3 : int)" (typeconstr (intlit 3) intty);
    (*--------- Communication: calls to Dummybackend -----------*)
    "send"
    >:: test_expr {|Printf.printf "%s: %s\n%!" pir_me "would have sent 3 to A"|}
          (send (intlit 3) "A");
    "recv"
    >:: test_expr
          ({|Printf.printf "%s: %s\n%!" pir_me "would have received int from A";|}
         ^ "\nRandom.int 999")
          (recv intty "A");
    "choose"
    >:: test_expr {|Backend.Dummybackend.choose "A" "L"|}
          (choosefor "A" (mklab "L"));
    (* mklab is in nometa.ml *)

    (* -------------- Location check: Iam check ----------------*)
    (* AmI compares the given location against me the file's own identity*)
    "ami" >:: test_expr {|String.equal "A" pir_me|} (ami (loclit "A"));
    (*---------------- AllowChoice ----------------------------*)
    (* one arm: should turn into a match on recv_label *)
    "allowchoice_one"
    >:: test_expr
          "match Backend.Dummybackend.recv_label \"A\" with\n\
           | \"L\" -> 1\n\
           | other -> failwith (Printf.sprintf \"unexpected label %s from %s\" \
           other \"A\")"
          (allowchoice "A" [ (mklab "L", intlit 1) ]);
    (* two arms so both branches show up in the match *)
    "allowchoice_two"
    >:: test_expr
          "match Backend.Dummybackend.recv_label \"A\" with\n\
           | \"L\" -> 1\n\
           | \"R\" -> 2\n\
           | other -> failwith (Printf.sprintf \"unexpected label %s from %s\" \
           other \"A\")"
          (allowchoice "A" [ (mklab "L", intlit 1); (mklab "R", intlit 2) ]);
    (*---------------- RecAbs ---------------------------------*)
    (* recursive function f with param x *)
    "recabs" >:: test_expr "let rec f x = x in f" (recabs "f" "x" (var "x"));
    (*----------------- Variant Test ----------------------------*)
    "empty_variant" >:: test_decl "type false = |" (variantdecl "false" []);
    "one_const_var"
    >:: test_decl
          (* NO white space after = and only two spaces for the constructor arms*)
          "type color =\n  | Pir_red "
          (variantdecl "color" [ ("red", [], varty "color") ]);
    "two_const_var"
    >:: test_decl "type color =\n  | Pir_red \n  | Pir_black "
          (variantdecl "color"
             [ ("red", [], varty "color"); ("black", [], varty "color") ]);
    (*---------------- Match Tests ---------------------------------*)
    (* basic patterns: int literal, variable, wildcard *)
    "match_basic"
    >:: test_expr "match x with | 1 -> 10 | y -> y | _ -> 0"
          (mkmatch (var "x")
             [
               (intlitpat 1, intlit 10);
               (varpat "y", var "y");
               (wildcardpat, intlit 0);
             ]);
    (* other literal patterns so more of pattern_gen gets hit *)
    "match_literals"
    >:: test_expr
          "match x with | true -> 1 | false -> 2 | \"hi\" -> 3 | () -> 4"
          (mkmatch (var "x")
             [
               (truelitpat, intlit 1);
               (falselitpat, intlit 2);
               (stringlitpat "hi", intlit 3);
               (unitlitpat, intlit 4);
             ]);
    (* constructor pattern w an argument
       lowercase on purpose bc ocamlgen capitalizes constructors *)
    "match_constructor"
    >:: test_expr "match x with | Pir_bar n -> n | _ -> 0"
          (mkmatch (var "x")
             [
               (constructorpat "bar" [ varpat "n" ], var "n");
               (wildcardpat, intlit 0);
             ]);
    (*---------------- Decl Gen ---------------------------------*)
    (* type decl *)
    "typedecl" >:: test_decl "type foo = int" (typedecl "foo" intty);
    (* import turns into include and the module name gets capitalized *)
    "importdecl" >:: test_decl "include Mylib" (importdecl "mylib");
    (* emulated location decl: just a no op binding at runtime *)
    "emlocdecl"
    >:: test_decl "let _ = let _emulated_location = \"alice\" in ()"
          (emlocdecl "alice");
    (* defn decl: f with one param x that returns x *)
    "defndecl"
    >:: test_decl "let f x = x" (defndecl "f" [ varpat "x" ] (var "x"));
    (*--------------------Program Gen Test --------------------------*)
    "empty_program" >:: test_program "let pir_me = \"alice\"" "alice" [];
    "one_decl_prog"
    >:: test_program "let pir_me = \"alice\"\ntype nonrec foo = 'bar" "alice"
          [ typealiasdecl "foo" (varty "bar") ];
    "two_decl_prog"
    >:: test_program
          "let pir_me = \"alice\"\ntype nonrec foo = 'bar\ntype color = |"
          "alice"
          [ typealiasdecl "foo" (varty "bar"); variantdecl "color" [] ];
  ]
