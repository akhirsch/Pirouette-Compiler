open OUnit2
module Meta = Metainfo.Meta.PosInfo
module AST = Netir.Ast.MkAST (Meta)
module DotAST = Netir.Dot_ast.MkDotAST (Meta)
open AST
open Meta

let test_eq_string s1 s2 _ = assert_equal ~printer:(fun x -> x) s1 s2

(*Here we're testing the individual functions to see if they generate the expected dot code. At the bottom
  the entrypoint is tested*)

(* ----- Type Tests ----- *)

let expected_varty =
  "n0 [label=\"Var Type [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n1 [label=\"Name Variable [test.ml: 1:15--1:16]\"];\n"

let test_varty =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let typ = VarTy (pos, (pos, "Variable")) in
  let out, _ = DotAST.dot_typ Meta.string_of_mi typ in
  out

let expected_unitty = "n0 [label=\"Unit Type [test.ml: 1:15--1:16]\"];\n"

let test_unitty =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let typ = UnitTy pos in
  let out, _ = DotAST.dot_typ Meta.string_of_mi typ in
  out

let expected_intty = "n0 [label=\"Int Type [test.ml: 1:15--1:16]\"];\n"

let test_intty =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let typ = IntTy pos in
  let out, _ = DotAST.dot_typ Meta.string_of_mi typ in
  out

let expected_floatty = "n0 [label=\"Float Type [test.ml: 1:15--1:16]\"];\n"

let test_floatty =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let typ = FloatTy pos in
  let out, _ = DotAST.dot_typ Meta.string_of_mi typ in
  out

let expected_charty = "n0 [label=\"Char Type [test.ml: 1:15--1:16]\"];\n"

let test_charty =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let typ = CharTy pos in
  let out, _ = DotAST.dot_typ Meta.string_of_mi typ in
  out

let expected_stringty = "n0 [label=\"String Type [test.ml: 1:15--1:16]\"];\n"

let test_stringty =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let typ = StringTy pos in
  let out, _ = DotAST.dot_typ Meta.string_of_mi typ in
  out

let expected_boolty = "n0 [label=\"Bool Type [test.ml: 1:15--1:16]\"];\n"

let test_boolty =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let typ = BoolTy pos in
  let out, _ = DotAST.dot_typ Meta.string_of_mi typ in
  out

let expected_funty =
  "n0 [label=\"Fun Type [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n0 -> n2;\n\
   n1 [label=\"Int Type [test.ml: 1:15--1:16]\"];\n\
   n2 [label=\"Bool Type [test.ml: 1:15--1:16]\"];\n"

let test_funty =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let typ = FunTy (pos, IntTy pos, BoolTy pos) in
  let out, _ = DotAST.dot_typ Meta.string_of_mi typ in
  out

let expected_locty =
  "n0 [label=\"Loc Type [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n1 [label=\"Name x [test.ml: 1:15--1:16]\"];\n"

let test_locty =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let typ = LocTy (pos, [ (pos, "x") ]) in
  let out, _ = DotAST.dot_typ Meta.string_of_mi typ in
  out

(*Testing locty handles lists correctly*)
let expected_locty_mult =
  "n0 [label=\"Loc Type [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n0 -> n2;\n\
   n0 -> n3;\n\
   n1 [label=\"Name x [test.ml: 1:15--1:16]\"];\n\
   n2 [label=\"Name y [test.ml: 2:20--2:50]\"];\n\
   n3 [label=\"Name z [test.ml: 3:31--3:41]\"];\n"

let test_locty_mult =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pos2 = { filename = "test.ml"; start = (2, 20); stop = (2, 50) } in
  let pos3 = { filename = "test.ml"; start = (3, 31); stop = (3, 41) } in
  let typ = LocTy (pos, [ (pos, "x"); (pos2, "y"); (pos3, "z") ]) in
  let out, _ = DotAST.dot_typ Meta.string_of_mi typ in
  out

let type_suite =
  [
    "var type" >:: test_eq_string expected_varty test_varty;
    "unit type" >:: test_eq_string expected_unitty test_unitty;
    "int type" >:: test_eq_string expected_intty test_intty;
    "float type" >:: test_eq_string expected_floatty test_floatty;
    "char type" >:: test_eq_string expected_charty test_charty;
    "string type" >:: test_eq_string expected_stringty test_stringty;
    "bool type" >:: test_eq_string expected_boolty test_boolty;
    "fun type" >:: test_eq_string expected_funty test_funty;
    "loc type" >:: test_eq_string expected_locty test_locty;
    "loc type multiple" >:: test_eq_string expected_locty_mult test_locty_mult;
  ]

(* ----- Pattern Tests ----- *)

let expected_wildcard = "n0 [label=\"Wildcard Pat [test.ml: 1:15--1:16]\"];\n"

let test_wildcard =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pat = WildcardPat pos in
  let out, _ = DotAST.dot_pattern Meta.string_of_mi pat in
  out

let expected_varpat =
  "n0 [label=\"Var Pat [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n1 [label=\"Name testvar [test.ml: 1:15--1:16]\"];\n"

let test_varpat =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pat = VarPat (pos, (pos, "testvar")) in
  let out, _ = DotAST.dot_pattern Meta.string_of_mi pat in
  out

let expected_unitlit_pat =
  "n0 [label=\"Unit Lit Pat [test.ml: 1:15--1:16]\"];\n"

let test_unitlit_pat =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pat = UnitLitPat pos in
  let out, _ = DotAST.dot_pattern Meta.string_of_mi pat in
  out

let expected_intlit_pat =
  "n0 [label=\"Int Lit Pat [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n1 [label=\"Int 5\"];\n"

let test_intlit_pat =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pat = IntLitPat (pos, 5) in
  let out, _ = DotAST.dot_pattern Meta.string_of_mi pat in
  out

let expected_floatlit_pat =
  "n0 [label=\"Float Lit Pat [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n1 [label=\"Float 8.\"];\n"

let test_floatlit_pat =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pat = FloatLitPat (pos, 8.0) in
  let out, _ = DotAST.dot_pattern Meta.string_of_mi pat in
  out

let expected_charlit_pat =
  "n0 [label=\"Char Lit Pat [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n1 [label=\"Char P\"];\n"

let test_charlit_pat =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pat = CharLitPat (pos, 'P') in
  let out, _ = DotAST.dot_pattern Meta.string_of_mi pat in
  out

let expected_stringlit_pat =
  "n0 [label=\"String Lit Pat [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n1 [label=\"String Test string\"];\n"

let test_stringlit_pat =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pat = StringLitPat (pos, "Test string") in
  let out, _ = DotAST.dot_pattern Meta.string_of_mi pat in
  out

let expected_truelit_pat =
  "n0 [label=\"True Lit Pat [test.ml: 1:15--1:16]\"];\n"

let test_truelit_pat =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pat = TrueLitPat pos in
  let out, _ = DotAST.dot_pattern Meta.string_of_mi pat in
  out

let expected_falselit_pat =
  "n0 [label=\"False Lit Pat [test.ml: 1:15--1:16]\"];\n"

let test_falselit_pat =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pat = FalseLitPat pos in
  let out, _ = DotAST.dot_pattern Meta.string_of_mi pat in
  out

let expected_loclit_pat =
  "n0 [label=\"Loc Lit Pat [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n1 [label=\"Name Alice [test.ml: 1:15--1:16]\"];\n"

let test_loclit_pat =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pat = LocLitPat (pos, (pos, "Alice")) in
  let out, _ = DotAST.dot_pattern Meta.string_of_mi pat in
  out

let expected_constr =
  "n0 [label=\"Constructor Pat [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n0 -> n2;\n\
   n1 [label=\"Name Bob [test.ml: 2:20--2:50]\"];\n\
   n2 [label=\"Var Pat [test.ml: 3:31--3:41]\"];\n\
   n2 -> n3;\n\
   n3 [label=\"Name testvar [test.ml: 3:31--3:41]\"];\n"

let test_constr =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pos2 = { filename = "test.ml"; start = (2, 20); stop = (2, 50) } in
  let pos3 = { filename = "test.ml"; start = (3, 31); stop = (3, 41) } in
  let pat =
    ConstructorPat (pos, (pos2, "Bob"), [ VarPat (pos3, (pos3, "testvar")) ])
  in
  let out, _ = DotAST.dot_pattern Meta.string_of_mi pat in
  out

(*Testing constructor handles lists correctly*)
let expected_constr_mult =
  "n0 [label=\"Constructor Pat [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n0 -> n2;\n\
   n0 -> n4;\n\
   n0 -> n5;\n\
   n1 [label=\"Name Bob [test.ml: 2:20--2:50]\"];\n\
   n2 [label=\"Var Pat [test.ml: 3:31--3:41]\"];\n\
   n2 -> n3;\n\
   n3 [label=\"Name testvar [test.ml: 3:31--3:41]\"];\n\
   n4 [label=\"Unit Lit Pat [test.ml: 5:0--5:100]\"];\n\
   n5 [label=\"Int Lit Pat [test.ml: 6:0--6:34]\"];\n\
   n5 -> n6;\n\
   n6 [label=\"Int 5\"];\n"

let test_constr_mult =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pos2 = { filename = "test.ml"; start = (2, 20); stop = (2, 50) } in
  let pos3 = { filename = "test.ml"; start = (3, 31); stop = (3, 41) } in
  let pos4 = { filename = "test.ml"; start = (5, 0); stop = (5, 100) } in
  let pos5 = { filename = "test.ml"; start = (6, 0); stop = (6, 34) } in

  let pat =
    ConstructorPat
      ( pos,
        (pos2, "Bob"),
        [
          VarPat (pos3, (pos3, "testvar")); UnitLitPat pos4; IntLitPat (pos5, 5);
        ] )
  in
  let out, _ = DotAST.dot_pattern Meta.string_of_mi pat in
  out

let expected_locname =
  "n0 [label=\"Loc Name Pat [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n1 [label=\"Name Alice [test.ml: 1:15--1:16]\"];\n"

let test_locname =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pat = LocNamePat (pos, (pos, "Alice")) in
  let out, _ = DotAST.dot_pattern Meta.string_of_mi pat in
  out

let pattern_suite =
  [
    "wildcard pat" >:: test_eq_string expected_wildcard test_wildcard;
    "var pat" >:: test_eq_string expected_varpat test_varpat;
    "unitlit pat" >:: test_eq_string expected_unitlit_pat test_unitlit_pat;
    "intlit pat" >:: test_eq_string expected_intlit_pat test_intlit_pat;
    "floatlit pat" >:: test_eq_string expected_floatlit_pat test_floatlit_pat;
    "charlit pat" >:: test_eq_string expected_charlit_pat test_charlit_pat;
    "stringlit pat" >:: test_eq_string expected_stringlit_pat test_stringlit_pat;
    "truelit pat" >:: test_eq_string expected_truelit_pat test_truelit_pat;
    "falselit pat" >:: test_eq_string expected_falselit_pat test_falselit_pat;
    "loclit pat" >:: test_eq_string expected_loclit_pat test_loclit_pat;
    "constr pat" >:: test_eq_string expected_constr test_constr;
    "constr pat mult" >:: test_eq_string test_constr_mult expected_constr_mult;
    "locname pat" >:: test_eq_string expected_locname test_locname;
  ]

(* ----- Operation Tests ----- *)

let expected_neg = "n0 [label=\"Neg [test.ml: 1:15--1:16]\"];\n"

let test_neg =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let op = Neg pos in
  let out, _ = DotAST.dot_unop Meta.string_of_mi op in
  out

let expected_not = "n0 [label=\"Not [test.ml: 1:15--1:16]\"];\n"

let test_not =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let op = Not pos in
  let out, _ = DotAST.dot_unop Meta.string_of_mi op in
  out

let expected_plus = "n0 [label=\"Plus [test.ml: 1:15--1:16]\"];\n"

let test_plus =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let op = Plus pos in
  let out, _ = DotAST.dot_binop Meta.string_of_mi op in
  out

let expected_minus = "n0 [label=\"Minus [test.ml: 1:15--1:16]\"];\n"

let test_minus =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let op = Minus pos in
  let out, _ = DotAST.dot_binop Meta.string_of_mi op in
  out

let expected_times = "n0 [label=\"Times [test.ml: 1:15--1:16]\"];\n"

let test_times =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let op = Times pos in
  let out, _ = DotAST.dot_binop Meta.string_of_mi op in
  out

let expected_div = "n0 [label=\"Div [test.ml: 1:15--1:16]\"];\n"

let test_div =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let op = Div pos in
  let out, _ = DotAST.dot_binop Meta.string_of_mi op in
  out

let expected_and = "n0 [label=\"And [test.ml: 1:15--1:16]\"];\n"

let test_and =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let op = And pos in
  let out, _ = DotAST.dot_binop Meta.string_of_mi op in
  out

let expected_or = "n0 [label=\"Or [test.ml: 1:15--1:16]\"];\n"

let test_or =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let op = Or pos in
  let out, _ = DotAST.dot_binop Meta.string_of_mi op in
  out

let expected_eq = "n0 [label=\"Eq [test.ml: 1:15--1:16]\"];\n"

let test_eq =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let op = Eq pos in
  let out, _ = DotAST.dot_binop Meta.string_of_mi op in
  out

let expected_neq = "n0 [label=\"Neq [test.ml: 1:15--1:16]\"];\n"

let test_neq =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let op = Neq pos in
  let out, _ = DotAST.dot_binop Meta.string_of_mi op in
  out

let expected_lt = "n0 [label=\"Lt [test.ml: 1:15--1:16]\"];\n"

let test_lt =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let op = Lt pos in
  let out, _ = DotAST.dot_binop Meta.string_of_mi op in
  out

let expected_leq = "n0 [label=\"Leq [test.ml: 1:15--1:16]\"];\n"

let test_leq =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let op = Leq pos in
  let out, _ = DotAST.dot_binop Meta.string_of_mi op in
  out

let expected_gt = "n0 [label=\"Gt [test.ml: 1:15--1:16]\"];\n"

let test_gt =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let op = Gt pos in
  let out, _ = DotAST.dot_binop Meta.string_of_mi op in
  out

let expected_geq = "n0 [label=\"Geq [test.ml: 1:15--1:16]\"];\n"

let test_geq =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let op = Geq pos in
  let out, _ = DotAST.dot_binop Meta.string_of_mi op in
  out

let op_suite =
  [
    "plus" >:: test_eq_string expected_plus test_plus;
    "minus" >:: test_eq_string expected_minus test_minus;
    "times" >:: test_eq_string expected_times test_times;
    "div" >:: test_eq_string expected_div test_div;
    "and" >:: test_eq_string expected_and test_and;
    "or" >:: test_eq_string expected_or test_or;
    "eq" >:: test_eq_string expected_eq test_eq;
    "neq" >:: test_eq_string expected_neq test_neq;
    "lt" >:: test_eq_string expected_lt test_lt;
    "leq" >:: test_eq_string expected_leq test_leq;
    "gt" >:: test_eq_string expected_gt test_gt;
    "geq" >:: test_eq_string expected_geq test_geq;
  ]

(* ----- Expr Tests ----- *)

let expected_varexpr =
  "n0 [label=\"Expr [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n1 [label=\"Name Variable [test.ml: 1:15--1:16]\"];\n"

let test_varexpr =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let expr = Var (pos, (pos, "Variable")) in
  let out, _ = DotAST.dot_expr Meta.string_of_mi expr in
  out

let expected_unitlit = "n0 [label=\"UnitLit [test.ml: 1:15--1:16]\"];\n"

let test_unitlit =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let expr = UnitLit pos in
  let out, _ = DotAST.dot_expr Meta.string_of_mi expr in
  out

let expected_intlit =
  "n0 [label=\"IntLit [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n1 [label=\"Int 5\"];\n"

let test_intlit =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let expr = IntLit (pos, 5) in
  let out, _ = DotAST.dot_expr Meta.string_of_mi expr in
  out

let expected_floatlit =
  "n0 [label=\"FloatLit [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n1 [label=\"Float 8.\"];\n"

let test_floatlit =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let expr = FloatLit (pos, 8.) in
  let out, _ = DotAST.dot_expr Meta.string_of_mi expr in
  out

let expected_charlit =
  "n0 [label=\"CharLit [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n1 [label=\"Char P\"];\n"

let test_charlit =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let expr = CharLit (pos, 'P') in
  let out, _ = DotAST.dot_expr Meta.string_of_mi expr in
  out

let expected_stringlit =
  "n0 [label=\"StringLit [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n1 [label=\"String Test string\"];\n"

let test_stringlit =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let expr = StringLit (pos, "Test string") in
  let out, _ = DotAST.dot_expr Meta.string_of_mi expr in
  out

let expected_truelit = "n0 [label=\"TrueLit [test.ml: 1:15--1:16]\"];\n"

let test_truelit =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let expr = TrueLit pos in
  let out, _ = DotAST.dot_expr Meta.string_of_mi expr in
  out

let expected_falselit = "n0 [label=\"FalseLit [test.ml: 1:15--1:16]\"];\n"

let test_falselit =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let expr = FalseLit pos in
  let out, _ = DotAST.dot_expr Meta.string_of_mi expr in
  out

let expected_loclit =
  "n0 [label=\"LocLit [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n1 [label=\"Name Alice [test.ml: 1:15--1:16]\"];\n"

let test_loclit =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let expr = LocLit (pos, (pos, "Alice")) in
  let out, _ = DotAST.dot_expr Meta.string_of_mi expr in
  out

let expected_match =
  "n0 [label=\"Match [test.ml: 1:15--1:16]\"];\n\
   n0 -> n4;\n\
   n0 -> n1;\n\
   n4 [label=\"TrueLit [test.ml: 2:20--2:50]\"];\n\
   n1 [label=\"Case\"];\n\
   n1 -> n2;\n\
   n1 -> n3;\n\
   n2 [label=\"True Lit Pat [test.ml: 3:31--3:41]\"];\n\
   n3 [label=\"UnitLit [test.ml: 3:31--3:41]\"];\n"

let test_match =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pos2 = { filename = "test.ml"; start = (2, 20); stop = (2, 50) } in
  let pos3 = { filename = "test.ml"; start = (3, 31); stop = (3, 41) } in
  let expr = Match (pos, TrueLit pos2, [ (TrueLitPat pos3, UnitLit pos3) ]) in
  let out, _ = DotAST.dot_expr Meta.string_of_mi expr in
  out

let expected_recabs =
  "n0 [label=\"RecAbs [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n0 -> n2;\n\
   n0 -> n3;\n\
   n1 [label=\"Name f [test.ml: 2:20--2:50]\"];\n\
   n2 [label=\"Name x [test.ml: 3:31--3:41]\"];\n\
   n3 [label=\"TrueLit [test.ml: 4:10--4:20]\"];\n"

let test_recabs =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pos2 = { filename = "test.ml"; start = (2, 20); stop = (2, 50) } in
  let pos3 = { filename = "test.ml"; start = (3, 31); stop = (3, 41) } in
  let pos4 = { filename = "test.ml"; start = (4, 10); stop = (4, 20) } in
  let expr = RecAbs (pos, (pos2, "f"), (pos3, "x"), TrueLit pos4) in
  let out, _ = DotAST.dot_expr Meta.string_of_mi expr in
  out

let expected_funapp =
  "n0 [label=\"FunApp [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n0 -> n3;\n\
   n1 [label=\"Expr [test.ml: 2:20--2:50]\"];\n\
   n1 -> n2;\n\
   n2 [label=\"Name f [test.ml: 3:31--3:41]\"];\n\
   n3 [label=\"Expr [test.ml: 4:10--4:20]\"];\n\
   n3 -> n4;\n\
   n4 [label=\"Name x [test.ml: 5:1--5:17]\"];\n"

let test_funapp =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pos2 = { filename = "test.ml"; start = (2, 20); stop = (2, 50) } in
  let pos3 = { filename = "test.ml"; start = (3, 31); stop = (3, 41) } in
  let pos4 = { filename = "test.ml"; start = (4, 10); stop = (4, 20) } in
  let pos5 = { filename = "test.ml"; start = (5, 1); stop = (5, 17) } in
  let expr = FunApp (pos, Var (pos2, (pos3, "f")), Var (pos4, (pos5, "x"))) in
  let out, _ = DotAST.dot_expr Meta.string_of_mi expr in
  out

let expected_typeconstr =
  "n0 [label=\"TypeConstr [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n0 -> n3;\n\
   n1 [label=\"IntLit [test.ml: 2:20--2:50]\"];\n\
   n1 -> n2;\n\
   n2 [label=\"Int 1\"];\n\
   n3 [label=\"Int Type [test.ml: 3:31--3:41]\"];\n"

let test_typeconstr =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pos2 = { filename = "test.ml"; start = (2, 20); stop = (2, 50) } in
  let pos3 = { filename = "test.ml"; start = (3, 31); stop = (3, 41) } in
  let expr = TypeConstr (pos, IntLit (pos2, 1), IntTy pos3) in
  let out, _ = DotAST.dot_expr Meta.string_of_mi expr in
  out

let expected_unop =
  "n0 [label=\"Unop [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n0 -> n2;\n\
   n1 [label=\"Neg [test.ml: 2:20--2:50]\"];\n\
   n2 [label=\"IntLit [test.ml: 3:31--3:41]\"];\n\
   n2 -> n3;\n\
   n3 [label=\"Int 1\"];\n"

let test_unop =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pos2 = { filename = "test.ml"; start = (2, 20); stop = (2, 50) } in
  let pos3 = { filename = "test.ml"; start = (3, 31); stop = (3, 41) } in
  let expr = Unop (pos, Neg pos2, IntLit (pos3, 1)) in
  let out, _ = DotAST.dot_expr Meta.string_of_mi expr in
  out

let expected_binop =
  "n0 [label=\"Binop [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n0 -> n2;\n\
   n0 -> n4;\n\
   n1 [label=\"Plus [test.ml: 2:20--2:50]\"];\n\
   n2 [label=\"IntLit [test.ml: 3:31--3:41]\"];\n\
   n2 -> n3;\n\
   n3 [label=\"Int 1\"];\n\
   n4 [label=\"IntLit [test.ml: 4:10--4:20]\"];\n\
   n4 -> n5;\n\
   n5 [label=\"Int 3\"];\n"

let test_binop =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pos2 = { filename = "test.ml"; start = (2, 20); stop = (2, 50) } in
  let pos3 = { filename = "test.ml"; start = (3, 31); stop = (3, 41) } in
  let pos4 = { filename = "test.ml"; start = (4, 10); stop = (4, 20) } in
  let expr = Binop (pos, Plus pos2, IntLit (pos3, 1), IntLit (pos4, 3)) in
  let out, _ = DotAST.dot_expr Meta.string_of_mi expr in
  out

let expected_send =
  "n0 [label=\"Send [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n0 -> n2;\n\
   n1 [label=\"TrueLit [test.ml: 2:20--2:50]\"];\n\
   n2 [label=\"Name john [test.ml: 3:31--3:41]\"];\n"

let test_send =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pos2 = { filename = "test.ml"; start = (2, 20); stop = (2, 50) } in
  let pos3 = { filename = "test.ml"; start = (3, 31); stop = (3, 41) } in
  let expr = Send (pos, TrueLit pos2, (pos3, "john")) in
  let out, _ = DotAST.dot_expr Meta.string_of_mi expr in
  out

let expected_recv =
  "n0 [label=\"Recv [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n0 -> n2;\n\
   n1 [label=\"Int Type [test.ml: 2:20--2:50]\"];\n\
   n2 [label=\"Name susan [test.ml: 3:31--3:41]\"];\n"

let test_recv =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pos2 = { filename = "test.ml"; start = (2, 20); stop = (2, 50) } in
  let pos3 = { filename = "test.ml"; start = (3, 31); stop = (3, 41) } in
  let expr = Recv (pos, IntTy pos2, (pos3, "susan")) in
  let out, _ = DotAST.dot_expr Meta.string_of_mi expr in
  out

let expected_choose =
  "n0 [label=\"ChooseFor [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n0 -> n2;\n\
   n1 [label=\"Name alice [test.ml: 2:20--2:50]\"];\n\
   n2 [label=\"Label\"];\n\
   n2 -> n3;\n\
   n3 [label=\"Name L [test.ml: 3:31--3:41]\"];\n"

let test_choose =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pos2 = { filename = "test.ml"; start = (2, 20); stop = (2, 50) } in
  let pos3 = { filename = "test.ml"; start = (3, 31); stop = (3, 41) } in
  let expr = ChooseFor (pos, (pos2, "alice"), Label (pos3, "L")) in
  let out, _ = DotAST.dot_expr Meta.string_of_mi expr in
  out

let expected_allow =
  "n0 [label=\"AllowChoice [test.ml: 1:15--1:16]\"];\n\
   n0 -> n5;\n\
   n0 -> n1;\n\
   n5 [label=\"Name Alice [test.ml: 2:20--2:50]\"];\n\
   n1 [label=\"Choice\"];\n\
   n1 -> n2;\n\
   n1 -> n4;\n\
   n2 [label=\"Label\"];\n\
   n2 -> n3;\n\
   n3 [label=\"Name L [test.ml: 3:31--3:41]\"];\n\
   n4 [label=\"TrueLit [test.ml: 4:10--4:20]\"];\n"

let test_allow =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pos2 = { filename = "test.ml"; start = (2, 20); stop = (2, 50) } in
  let pos3 = { filename = "test.ml"; start = (3, 31); stop = (3, 41) } in
  let pos4 = { filename = "test.ml"; start = (4, 10); stop = (4, 20) } in
  let expr =
    AllowChoice (pos, (pos2, "Alice"), [ (Label (pos3, "L"), TrueLit pos4) ])
  in
  let out, _ = DotAST.dot_expr Meta.string_of_mi expr in
  out

let expected_ami =
  "n0 [label=\"AmI [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n1 [label=\"TrueLit [test.ml: 2:20--2:50]\"];\n"

let test_ami =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pos2 = { filename = "test.ml"; start = (2, 20); stop = (2, 50) } in
  let expr = AmI (pos, TrueLit pos2) in
  let out, _ = DotAST.dot_expr Meta.string_of_mi expr in
  out

let expr_suite =
  [
    "varexpr" >:: test_eq_string expected_varexpr test_varexpr;
    "unitlit" >:: test_eq_string expected_unitlit test_unitlit;
    "intlit" >:: test_eq_string expected_intlit test_intlit;
    "floatlit" >:: test_eq_string expected_floatlit test_floatlit;
    "charlit" >:: test_eq_string expected_charlit test_charlit;
    "stringlit" >:: test_eq_string expected_stringlit test_stringlit;
    "truelit" >:: test_eq_string expected_truelit test_truelit;
    "falselit" >:: test_eq_string expected_falselit test_falselit;
    "loclit" >:: test_eq_string expected_loclit test_loclit;
    "match" >:: test_eq_string expected_match test_match;
    "recabs" >:: test_eq_string expected_recabs test_recabs;
    "funapp" >:: test_eq_string expected_funapp test_funapp;
    "typeconstr" >:: test_eq_string expected_typeconstr test_typeconstr;
    "unop" >:: test_eq_string expected_unop test_unop;
    "send" >:: test_eq_string expected_send test_send;
    "recv" >:: test_eq_string expected_recv test_recv;
    "choose" >:: test_eq_string expected_choose test_choose;
    "allow" >:: test_eq_string expected_allow test_allow;
    "ami" >:: test_eq_string expected_ami test_ami;
  ]

(* ----- Decl Tests ----- *)

let expected_locdecl =
  "n0 [label=\"EmulatedLocDecl [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n1 [label=\"Name test [test.ml: 2:20--2:50]\"];\n"

let test_locdecl =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pos2 = { filename = "test.ml"; start = (2, 20); stop = (2, 50) } in
  let expr = EmulatedLocDecl (pos, (pos2, "test")) in
  let out, _ = DotAST.dot_decl Meta.string_of_mi expr in
  out

let expected_decl =
  "n0 [label=\"Type Decl [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n0 -> n2;\n\
   n1 [label=\"Name test [test.ml: 2:20--2:50]\"];\n\
   n2 [label=\"Int Type [test.ml: 3:31--3:41]\"];\n"

let test_decl =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pos2 = { filename = "test.ml"; start = (2, 20); stop = (2, 50) } in
  let pos3 = { filename = "test.ml"; start = (3, 31); stop = (3, 41) } in
  let expr = TypeDecl (pos, (pos2, "test"), IntTy pos3) in
  let out, _ = DotAST.dot_decl Meta.string_of_mi expr in
  out

let expected_aliasdecl =
  "n0 [label=\"Type Alias Decl [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n0 -> n2;\n\
   n1 [label=\"Name test [test.ml: 2:20--2:50]\"];\n\
   n2 [label=\"Int Type [test.ml: 3:31--3:41]\"];\n"

let test_aliasdecl =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pos2 = { filename = "test.ml"; start = (2, 20); stop = (2, 50) } in
  let pos3 = { filename = "test.ml"; start = (3, 31); stop = (3, 41) } in
  let expr = TypeAliasDecl (pos, (pos2, "test"), IntTy pos3) in
  let out, _ = DotAST.dot_decl Meta.string_of_mi expr in
  out

let expected_defndecl =
  "n0 [label=\"Defn Decl [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n0 -> n2;\n\
   n0 -> n4;\n\
   n1 [label=\"Name test [test.ml: 2:20--2:50]\"];\n\
   n2 [label=\"Var Pat [test.ml: 3:31--3:41]\"];\n\
   n2 -> n3;\n\
   n3 [label=\"Name x [test.ml: 4:10--4:20]\"];\n\
   n4 [label=\"UnitLit [test.ml: 5:1--5:17]\"];\n"

let test_defndecl =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pos2 = { filename = "test.ml"; start = (2, 20); stop = (2, 50) } in
  let pos3 = { filename = "test.ml"; start = (3, 31); stop = (3, 41) } in
  let pos4 = { filename = "test.ml"; start = (4, 10); stop = (4, 20) } in
  let pos5 = { filename = "test.ml"; start = (5, 1); stop = (5, 17) } in
  let expr =
    DefnDecl (pos, (pos2, "test"), [ VarPat (pos3, (pos4, "x")) ], UnitLit pos5)
  in
  let out, _ = DotAST.dot_decl Meta.string_of_mi expr in
  out

let expected_importdecl =
  "n0 [label=\"Import Decl [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n1 [label=\"Name test [test.ml: 2:20--2:50]\"];\n"

let test_importdecl =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pos2 = { filename = "test.ml"; start = (2, 20); stop = (2, 50) } in
  let expr = ImportDecl (pos, (pos2, "test")) in
  let out, _ = DotAST.dot_decl Meta.string_of_mi expr in
  out

let expected_variantdecl =
  "n0 [label=\"Variant Decl [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n0 -> n2;\n\
   n1 [label=\"Name test [test.ml: 2:20--2:50]\"];\n\
   n2 [label=\"Variant Constructor\"];\n\
   n2 -> n3;\n\
   n2 -> n4;\n\
   n3 [label=\"Name typ1 [test.ml: 3:31--3:41]\"];\n\
   n4 [label=\"Var Type [test.ml: 4:10--4:20]\"];\n\
   n4 -> n5;\n\
   n5 [label=\"Name test [test.ml: 5:1--5:17]\"];\n"

let test_variantdecl =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pos2 = { filename = "test.ml"; start = (2, 20); stop = (2, 50) } in
  let pos3 = { filename = "test.ml"; start = (3, 31); stop = (3, 41) } in
  let pos4 = { filename = "test.ml"; start = (4, 10); stop = (4, 20) } in
  let pos5 = { filename = "test.ml"; start = (5, 1); stop = (5, 17) } in
  let expr =
    VariantDecl
      ( pos,
        (pos2, "test"),
        [ ((pos3, "typ1"), [], VarTy (pos4, (pos5, "test"))) ] )
  in
  let out, _ = DotAST.dot_decl Meta.string_of_mi expr in
  out

let decl_suite =
  [
    "locdecl" >:: test_eq_string expected_locdecl test_locdecl;
    "decl" >:: test_eq_string expected_decl test_decl;
    "aliasdecl" >:: test_eq_string expected_aliasdecl test_aliasdecl;
    "defndecl" >:: test_eq_string expected_defndecl test_defndecl;
    "importdecl" >:: test_eq_string expected_importdecl test_importdecl;
  ]

(**)
let expected_program =
  "digraph G {\n\
   n0 [label=\"Variant Decl [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n0 -> n2;\n\
   n1 [label=\"Name test [test.ml: 2:20--2:50]\"];\n\
   n2 [label=\"Variant Constructor\"];\n\
   n2 -> n3;\n\
   n2 -> n4;\n\
   n3 [label=\"Name typ1 [test.ml: 3:31--3:41]\"];\n\
   n4 [label=\"Var Type [test.ml: 4:10--4:20]\"];\n\
   n4 -> n5;\n\
   n5 [label=\"Name test [test.ml: 5:1--5:17]\"];\n\n\
   n6 [label=\"Import Decl [test.ml: 6:15--6:16]\"];\n\
   n6 -> n7;\n\
   n7 [label=\"Name test [test.ml: 7:20--7:50]\"];\n\n\
   n8 [label=\"Defn Decl [test.ml: 8:15--8:16]\"];\n\
   n8 -> n9;\n\
   n8 -> n10;\n\
   n8 -> n12;\n\
   n9 [label=\"Name test [test.ml: 9:20--9:50]\"];\n\
   n10 [label=\"Var Pat [test.ml: 10:31--10:41]\"];\n\
   n10 -> n11;\n\
   n11 [label=\"Name x [test.ml: 11:10--11:20]\"];\n\
   n12 [label=\"UnitLit [test.ml: 12:1--12:17]\"];\n\n\
   n13 [label=\"Type Alias Decl [test.ml: 13:15--13:16]\"];\n\
   n13 -> n14;\n\
   n13 -> n15;\n\
   n14 [label=\"Name test [test.ml: 14:20--14:50]\"];\n\
   n15 [label=\"Int Type [test.ml: 15:31--15:41]\"];\n\n\
   }\n"

(* ----- Entrypoint Tests ----- *)
let test_program =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pos2 = { filename = "test.ml"; start = (2, 20); stop = (2, 50) } in
  let pos3 = { filename = "test.ml"; start = (3, 31); stop = (3, 41) } in
  let pos4 = { filename = "test.ml"; start = (4, 10); stop = (4, 20) } in
  let pos5 = { filename = "test.ml"; start = (5, 1); stop = (5, 17) } in
  let pos6 = { filename = "test.ml"; start = (6, 15); stop = (6, 16) } in
  let pos7 = { filename = "test.ml"; start = (7, 20); stop = (7, 50) } in
  let pos8 = { filename = "test.ml"; start = (8, 15); stop = (8, 16) } in
  let pos9 = { filename = "test.ml"; start = (9, 20); stop = (9, 50) } in
  let pos10 = { filename = "test.ml"; start = (10, 31); stop = (10, 41) } in
  let pos11 = { filename = "test.ml"; start = (11, 10); stop = (11, 20) } in
  let pos12 = { filename = "test.ml"; start = (12, 1); stop = (12, 17) } in
  let pos13 = { filename = "test.ml"; start = (13, 15); stop = (13, 16) } in
  let pos14 = { filename = "test.ml"; start = (14, 20); stop = (14, 50) } in
  let pos15 = { filename = "test.ml"; start = (15, 31); stop = (15, 41) } in
  let variant =
    VariantDecl
      ( pos,
        (pos2, "test"),
        [ ((pos3, "typ1"), [], VarTy (pos4, (pos5, "test"))) ] )
  in
  let import = ImportDecl (pos6, (pos7, "test")) in
  let defn =
    DefnDecl
      (pos8, (pos9, "test"), [ VarPat (pos10, (pos11, "x")) ], UnitLit pos12)
  in
  let alias = TypeAliasDecl (pos13, (pos14, "test"), IntTy pos15) in
  let prog = [ variant; import; defn; alias ] in
  DotAST.generate_dot_code Meta.string_of_mi prog

(*Testing that special characters are escaped correctly*)
let expected_special_characters =
  "digraph G {\n\
   n0 [label=\"Variant Decl [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n0 -> n2;\n\
   n1 [label=\"Name Newline \\n Backslash_n\\\\n [test.ml: 1:15--1:16]\"];\n\
   n2 [label=\"Variant Constructor\"];\n\
   n2 -> n3;\n\
   n2 -> n4;\n\
   n3 [label=\"Name \\\"Quotation Marks\\\"  [test.ml: 1:15--1:16]\"];\n\
   n4 [label=\"Var Type [test.ml: 1:15--1:16]\"];\n\
   n4 -> n5;\n\
   n5 [label=\"Name Backslashes \\\\ [test.ml: 1:15--1:16]\"];\n\n\
   }\n"

let test_special_characters =
  DotAST.node_counter := 0;

  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let variant =
    VariantDecl
      ( pos,
        (pos, "Newline \n Backslash_n\\n"),
        [
          ( (pos, "\"Quotation Marks\" "),
            [],
            VarTy (pos, (pos, "Backslashes \\")) );
        ] )
  in
  let prog = [ variant ] in
  DotAST.generate_dot_code Meta.string_of_mi prog

let prog_suite =
  [
    "program" >:: test_eq_string expected_program test_program;
    "special characters"
    >:: test_eq_string expected_special_characters test_special_characters;
  ]

let suite =
  [
    "Type Tests" >::: type_suite;
    "Pattern Tests" >::: pattern_suite;
    "Operation Tests" >::: op_suite;
    "Expr Tests" >::: expr_suite;
    "Decl Tests" >::: decl_suite;
    "Program Tests" >::: prog_suite;
  ]
