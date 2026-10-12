open OUnit2
module Meta = Metainfo.Meta.PosInfo
module AST = Netir.Ast.MkAST (Meta)
module DotAST = Netir.Dot_ast.MkDotAST (Meta)
open AST
open Meta

let test_eq_string s1 s2 _ = assert_equal ~printer:(fun x -> x) s1 s2

let expected_varty =
  "n0 [label=\"Var Type [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n1 [label=\"Name Variable [test.ml: 1:15--1:16]\"];\n"

let test_varty =
  let pos = { filename = "test.ml"; start = (1, 15); stop = (1, 16) } in
  let typ = VarTy (pos, (pos, "Variable")) in
  let out, _ = DotAST.dot_typ Meta.string_of_mi typ in
  out

let suite = [ "var type" >:: test_eq_string expected_varty test_varty ]
