open OUnit2
module Meta = Metainfo.Meta.PosInfo
module AST = Netir.Ast.MkAST (Meta)
module DotAST = Netir.Dot_ast.MkDotAST (Meta)
open AST
open Meta

let test_eq_string s1 s2 _ = assert_equal ~printer:(fun x -> x) s1 s2

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
  ]
