open OUnit2
module Meta = Metainfo.Meta.PosInfo
module AST = Netir.Ast.MkAST (Meta)
module DotAST = Netir.Dot_ast.MkDotAST (Meta)
open AST
open Meta

let test_eq_string s1 s2 _ = assert_equal ~printer:(fun x -> x) s1 s2

(*-----typ tests-------*)

(*VarTy*)
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

(*UnitTy*)
let expected_unitty = "n0 [label=\"Unit Type [test.ml: 1:15--1:16]\"];\n"

let test_unitty =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let typ = UnitTy pos in
  let out, _ = DotAST.dot_typ Meta.string_of_mi typ in
  out

(*IntTy*)
let expected_intty = "n0 [label=\"Int Type [test.ml: 1:15--1:16]\"];\n"

let test_intty =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let typ = IntTy pos in
  let out, _ = DotAST.dot_typ Meta.string_of_mi typ in
  out

(*FloatTy*)
let expected_floatty = "n0 [label=\"Float Type [test.ml: 1:15--1:16]\"];\n"

let test_floatty =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let typ = FloatTy pos in
  let out, _ = DotAST.dot_typ Meta.string_of_mi typ in
  out

(*CharTy*)
let expected_charty = "n0 [label=\"Char Type [test.ml: 1:15--1:16]\"];\n"

let test_charty =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let typ = CharTy pos in
  let out, _ = DotAST.dot_typ Meta.string_of_mi typ in
  out

(*StringTy*)
let expected_stringty = "n0 [label=\"String Type [test.ml: 1:15--1:16]\"];\n"

let test_stringty =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let typ = StringTy pos in
  let out, _ = DotAST.dot_typ Meta.string_of_mi typ in
  out

(*BoolTy*)
let expected_boolty = "n0 [label=\"Bool Type [test.ml: 1:15--1:16]\"];\n"

let test_boolty =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let typ = BoolTy pos in
  let out, _ = DotAST.dot_typ Meta.string_of_mi typ in
  out

(*FunTy*)
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

(* LocTy*)
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

(*-----pattern tests-------*)

(*Wildcard*)
let expected_wildcard = "n0 [label=\"Wildcard Pat [test.ml: 1:15--1:16]\"];\n"

let test_wildcard =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pat = WildcardPat pos in
  let out, _ = DotAST.dot_pattern Meta.string_of_mi pat in
  out

(*Var pat*)
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

(*Unit Lit*)
let expected_unitlit = "n0 [label=\"Unit Lit Pat [test.ml: 1:15--1:16]\"];\n"

let test_unitlit =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pat = UnitLitPat pos in
  let out, _ = DotAST.dot_pattern Meta.string_of_mi pat in
  out

(*Int Lit*)
let expected_intlit =
  "n0 [label=\"Int Lit Pat [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n1 [label=\"Int 5\"];\n"

let test_intlit =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pat = IntLitPat (pos, 5) in
  let out, _ = DotAST.dot_pattern Meta.string_of_mi pat in
  out

(*Float Lit*)
let expected_floatlit =
  "n0 [label=\"Float Lit Pat [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n1 [label=\"Float 8.\"];\n"

let test_floatlit =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pat = FloatLitPat (pos, 8.0) in
  let out, _ = DotAST.dot_pattern Meta.string_of_mi pat in
  out

(*Char Lit*)
let expected_charlit =
  "n0 [label=\"Char Lit Pat [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n1 [label=\"Char P\"];\n"

let test_charlit =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pat = CharLitPat (pos, 'P') in
  let out, _ = DotAST.dot_pattern Meta.string_of_mi pat in
  out

(*String lit*)
let expected_stringlit =
  "n0 [label=\"String Lit Pat [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n1 [label=\"String Test string\"];\n"

let test_stringlit =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pat = StringLitPat (pos, "Test string") in
  let out, _ = DotAST.dot_pattern Meta.string_of_mi pat in
  out

(*True lit*)
let expected_truelit = "n0 [label=\"True Lit Pat [test.ml: 1:15--1:16]\"];\n"

let test_truelit =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pat = TrueLitPat pos in
  let out, _ = DotAST.dot_pattern Meta.string_of_mi pat in
  out

(*False lit*)
let expected_falselit = "n0 [label=\"False Lit Pat [test.ml: 1:15--1:16]\"];\n"

let test_falselit =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pat = FalseLitPat pos in
  let out, _ = DotAST.dot_pattern Meta.string_of_mi pat in
  out

(*Loc Lit*)
let expected_loclit =
  "n0 [label=\"Loc Lit Pat [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n1 [label=\"Name Alice [test.ml: 1:15--1:16]\"];\n"

let test_loclit =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let pat = LocLitPat (pos, (pos, "Alice")) in
  let out, _ = DotAST.dot_pattern Meta.string_of_mi pat in
  out

(*Constructor*)
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

(*Loc Name*)
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

(*------Operation tests-----------*)

(*Neg*)
let expected_neg = "n0 [label=\"Neg [test.ml: 1:15--1:16]\"];\n"

let test_neg =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let op = Neg pos in
  let out, _ = DotAST.dot_unop Meta.string_of_mi op in
  out

(*Not*)
let expected_not = "n0 [label=\"Not [test.ml: 1:15--1:16]\"];\n"

let test_not =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let op = Not pos in
  let out, _ = DotAST.dot_unop Meta.string_of_mi op in
  out

(*Plus*)
let expected_plus = "n0 [label=\"Plus [test.ml: 1:15--1:16]\"];\n"

let test_plus =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let op = Plus pos in
  let out, _ = DotAST.dot_binop Meta.string_of_mi op in
  out

(*Minus*)
let expected_minus = "n0 [label=\"Minus [test.ml: 1:15--1:16]\"];\n"

let test_minus =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let op = Minus pos in
  let out, _ = DotAST.dot_binop Meta.string_of_mi op in
  out

(*Times*)
let expected_times = "n0 [label=\"Times [test.ml: 1:15--1:16]\"];\n"

let test_times =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let op = Times pos in
  let out, _ = DotAST.dot_binop Meta.string_of_mi op in
  out

(*Div*)
let expected_div = "n0 [label=\"Div [test.ml: 1:15--1:16]\"];\n"

let test_div =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let op = Div pos in
  let out, _ = DotAST.dot_binop Meta.string_of_mi op in
  out

(*And*)
let expected_and = "n0 [label=\"And [test.ml: 1:15--1:16]\"];\n"

let test_and =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let op = And pos in
  let out, _ = DotAST.dot_binop Meta.string_of_mi op in
  out

(*Or*)
let expected_or = "n0 [label=\"Or [test.ml: 1:15--1:16]\"];\n"

let test_or =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let op = Or pos in
  let out, _ = DotAST.dot_binop Meta.string_of_mi op in
  out

(*Eq*)
let expected_eq = "n0 [label=\"Eq [test.ml: 1:15--1:16]\"];\n"

let test_eq =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let op = Eq pos in
  let out, _ = DotAST.dot_binop Meta.string_of_mi op in
  out

(*Neq*)
let expected_neq = "n0 [label=\"Neq [test.ml: 1:15--1:16]\"];\n"

let test_neq =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let op = Neq pos in
  let out, _ = DotAST.dot_binop Meta.string_of_mi op in
  out

(*Lt*)
let expected_lt = "n0 [label=\"Lt [test.ml: 1:15--1:16]\"];\n"

let test_lt =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let op = Lt pos in
  let out, _ = DotAST.dot_binop Meta.string_of_mi op in
  out

(*Leq*)
let expected_leq = "n0 [label=\"Leq [test.ml: 1:15--1:16]\"];\n"

let test_leq =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let op = Leq pos in
  let out, _ = DotAST.dot_binop Meta.string_of_mi op in
  out

(*Gt*)
let expected_gt = "n0 [label=\"Gt [test.ml: 1:15--1:16]\"];\n"

let test_gt =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let op = Gt pos in
  let out, _ = DotAST.dot_binop Meta.string_of_mi op in
  out

(*Geq*)
let expected_geq = "n0 [label=\"Geq [test.ml: 1:15--1:16]\"];\n"

let test_geq =
  DotAST.node_counter := 0;
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let op = Geq pos in
  let out, _ = DotAST.dot_binop Meta.string_of_mi op in
  out

let suite =
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
    "wildcard pat" >:: test_eq_string expected_wildcard test_wildcard;
    "var pat" >:: test_eq_string expected_varpat test_varpat;
    "unitlit pat" >:: test_eq_string expected_unitlit test_unitlit;
    "intlit pat" >:: test_eq_string expected_intlit test_intlit;
    "floatlit pat" >:: test_eq_string expected_floatlit test_floatlit;
    "charlit pat" >:: test_eq_string expected_charlit test_charlit;
    "stringlit pat" >:: test_eq_string expected_stringlit test_stringlit;
    "truelit pat" >:: test_eq_string expected_truelit test_truelit;
    "falselit pat" >:: test_eq_string expected_falselit test_falselit;
    "loclit pat" >:: test_eq_string expected_loclit test_loclit;
    "constr pat" >:: test_eq_string expected_constr test_constr;
    "constr pat mult" >:: test_eq_string test_constr_mult expected_constr_mult;
    "locname pat" >:: test_eq_string expected_locname test_locname;
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
