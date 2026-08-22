open OUnit2
module A = Netir.Nometa

module P = Netir.Prettyprint.MkPrettify (Netir.Ast.MkAST (Metainfo.Meta.TrivInfo))

open A
open P

let three = intlit 3
let four = intlit 4
let three_and_a_half = floatlit 3.5
let char_c = charlit 'c'
let string_hello = stringlit "hello"
let three_plus_four = mkplus three four
let inlpat = constructorpat "inl" [ unitlitpat ]
let inrpat = constructorpat "inr" [ unitlitpat ]
let inl = funapp (var "inl")
let inr = funapp (var "inr")
let m = mkmatch (var "x") [ (inlpat, inr unitlit); (inrpat, inl unitlit) ]
let f = recabs "f" "x" (mkplus (var "x") three)
let f_four = funapp f four
let test_eq_string s1 s2 _ = assert_equal ~printer:(fun x -> x) s1 s2

let suite =
  "Pretty Print Tests"
  >::: [
         (* Type Tests *)
         "var type" >:: test_eq_string "a" (prettify_typ (varty "a"));
         "unit type" >:: test_eq_string "unit" (prettify_typ unitty);
         "int type" >:: test_eq_string "int" (prettify_typ intty);
         "float type" >:: test_eq_string "float" (prettify_typ floatty);
         "char type" >:: test_eq_string "char" (prettify_typ charty);
         "string type" >:: test_eq_string "string" (prettify_typ stringty);
         "bool type" >:: test_eq_string "bool" (prettify_typ boolty);
         "function type"
         >:: test_eq_string "int -> bool" (prettify_typ (funty intty boolty));
         "empty location type"
         >:: test_eq_string "location {}" (prettify_typ (locty []));
         "singleton location type"
         >:: test_eq_string "location {A}" (prettify_typ (locty [ "A" ]));
         "two locations type"
         >:: test_eq_string "location {A, B}"
               (prettify_typ (locty [ "A"; "B" ]));
         (* Pattern Tests *)
         "wildcard pattern"
         >:: test_eq_string "_" (prettify_pattern wildcardpat);
         "variable pattern"
         >:: test_eq_string "x" (prettify_pattern (varpat "x"));
         "unit literal pattern"
         >:: test_eq_string "()" (prettify_pattern unitlitpat);
         "int literal pattern"
         >:: test_eq_string "4" (prettify_pattern (intlitpat 4));
         "float literal pattern"
         >:: test_eq_string "7.8" (prettify_pattern (floatlitpat 7.8));
         "character literal pattern"
         >:: test_eq_string "'h'" (prettify_pattern (charlitpat 'h'));
         "string literal pattern"
         >:: test_eq_string "\"goodbye\""
               (prettify_pattern (stringlitpat "goodbye"));
         "true literal pattern"
         >:: test_eq_string "true" (prettify_pattern truelitpat);
         "false literal pattern"
         >:: test_eq_string "false" (prettify_pattern falselitpat);
         "inlpat" >:: test_eq_string "inl ()" (prettify_pattern inlpat);
         "inrpat" >:: test_eq_string "inr ()" (prettify_pattern inrpat);
         "location name pattern"
         >:: test_eq_string "[[A]]" (prettify_pattern (locnamepat "A"));
         (* Unary Operation Tests *)
         "Negation" >:: test_eq_string "-" (prettify_unop neg);
         "Not" >:: test_eq_string "!" (prettify_unop not);
         (* Binary Operation Tests *)
         "Plus" >:: test_eq_string "+" (prettify_binop plus);
         "Minus" >:: test_eq_string "-" (prettify_binop minus);
         "Times" >:: test_eq_string "*" (prettify_binop times);
         "Divide" >:: test_eq_string "/" (prettify_binop div);
         "And" >:: test_eq_string "&&" (prettify_binop andop);
         "Or" >:: test_eq_string "||" (prettify_binop orop);
         "Eq" >:: test_eq_string "==" (prettify_binop eq);
         "Neq" >:: test_eq_string "!=" (prettify_binop neq);
         "Lt" >:: test_eq_string "<" (prettify_binop lt);
         "Leq" >:: test_eq_string "<=" (prettify_binop leq);
         "Gt" >:: test_eq_string ">" (prettify_binop gt);
         "Geq" >:: test_eq_string ">=" (prettify_binop geq);
         (* Expression Tests *)
         "unit" >:: test_eq_string "()" (prettify_expr unitlit);
         "three" >:: test_eq_string "3" (prettify_expr three);
         "four" >:: test_eq_string "4" (prettify_expr four);
         "three and a half"
         >:: test_eq_string "3.5" (prettify_expr three_and_a_half);
         "char c" >:: test_eq_string "'c'" (prettify_expr char_c);
         "string hello"
         >:: test_eq_string "\"hello\"" (prettify_expr string_hello);
         "three_plus_four"
         >:: test_eq_string "3 + 4" (prettify_expr three_plus_four);
         "true literal" >:: test_eq_string "true" (prettify_expr truelit);
         "false literal" >:: test_eq_string "false" (prettify_expr falselit);
         "Negation"
         >:: test_eq_string "-3" (prettify_expr (unop neg (intlit 3)));
         "Not" >:: test_eq_string "!true" (prettify_expr (unop not truelit));
         "type constraint"
         >:: test_eq_string "3 : int"
               (prettify_expr (typeconstr (intlit 3) intty));
         "incorrect type constraint"
         >:: test_eq_string "3.5 : int"
               (prettify_expr (typeconstr (floatlit 3.5) intty));
         "match"
         >:: test_eq_string
               "match x with\n| inl () := inr ()\n| inr () := inl ()\nend"
               (prettify_expr m);
         "function" >:: test_eq_string "fun f x := x + 3" (prettify_expr f);
         "funcall"
         >:: test_eq_string "(fun f x := x + 3) 4" (prettify_expr f_four);
         "send"
         >:: test_eq_string "send 3 to A" (prettify_expr (send (intlit 3) "A"));
         "recv"
         >:: test_eq_string "recv int from A" (prettify_expr (recv intty "A"));
         "choosefor"
         >:: test_eq_string "choose [L] for A"
               (prettify_expr (choosefor "A" (mklab "L")));
         "allowchoice"
         >:: test_eq_string "allow A choice \n| [L] => 3\n| [R] => 4\nend"
               (prettify_expr
                  (allowchoice "A"
                     [ (mklab "L", intlit 3); (mklab "R", intlit 4) ]));
         (* Declaration Tests *)
         "emulated location"
         >:: test_eq_string "emulated location A"
               (prettify_decl (emlocdecl "A"));
         "type decl"
         >:: test_eq_string "foo : int" (prettify_decl (typedecl "foo" intty));
         "type alias decl"
         >:: test_eq_string "type foo := int"
               (prettify_decl (typealiasdecl "foo" intty));
         "definition"
         >:: test_eq_string "foo := 3"
               (prettify_decl (defndecl "foo" [] (intlit 3)));
         "one-param definition"
         >:: test_eq_string "foo () := 3"
               (prettify_decl (defndecl "foo" [ unitlitpat ] (intlit 3)));
         "two-param definition"
         >:: test_eq_string "foo () x := 3 + x"
               (prettify_decl
                  (defndecl "foo"
                     [ unitlitpat; varpat "x" ]
                     (binop plus (intlit 3) (var "x"))));
         "three-param definition"
         >:: test_eq_string "foo () x true := 3 + x"
               (prettify_decl
                  (defndecl "foo"
                     [ unitlitpat; varpat "x"; truelitpat ]
                     (binop plus (intlit 3) (var "x"))));
         "import"
         >:: test_eq_string "import Foo" (prettify_decl (importdecl "Foo"));
         "empty variant"
         >:: test_eq_string "data false :="
               (prettify_decl (variantdecl "false" []));
         "one-constr variant"
         >:: test_eq_string "data true :=\n| tt : true"
               (prettify_decl (variantdecl "true" [ ("tt", [], varty "true") ]));
         "two-constr variant"
         >:: test_eq_string
               "data either_int_int :=\n\
                | left : int -> either_int_int\n\
                | right : int -> either_int_int"
               (prettify_decl
                  (variantdecl "either_int_int"
                     [
                       ("left", [ intty ], varty "either_int_int");
                       ("right", [ intty ], varty "either_int_int");
                     ]));
         "badly-formatted variant"
         >:: test_eq_string
               "data either_int_float :=\n| left : int\n| right : float"
               (prettify_decl
                  (variantdecl "either_int_float"
                     [ ("left", [], intty); ("right", [], floatty) ]));
         "two-argument constructor"
         >:: test_eq_string "data foo :=\n| bar : int -> float -> foo"
               (prettify_decl
                  (variantdecl "foo"
                     [ ("bar", [ intty; floatty ], varty "foo") ]));
         (* Program Tests *)
         "empty program" >:: test_eq_string "" (prettify_prog []);
         "one-decl program"
         >:: test_eq_string "type foo := bar"
               (prettify_prog [ typealiasdecl "foo" (varty "bar") ]);
         "two-decl program"
         >:: test_eq_string "type foo := bar\ndata false :="
               (prettify_prog
                  [ typealiasdecl "foo" (varty "bar"); variantdecl "false" [] ]);
       ]

let () = run_test_tt_main suite
