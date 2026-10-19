module Meta = Metainfo.Meta.PosInfo
module AST = Netir.Ast.MkAST (Meta)
module DotAST = Netir.Dot_ast.MkDotAST (Meta)
open AST
open Meta

(*This test is meant to be ran using the command line.
Run: 
dune exec test/dottests/dotvisual.exe
dot ast.dot -Tsvg -o output.svg 
and open output.svg
to see the results. It should build with no errors and you should see a graph of the AST*)

let () =
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

  let code = DotAST.generate_dot_code Meta.string_of_mi prog in
  let oc = open_out "ast.dot" in
  output_string oc code;
  close_out oc
