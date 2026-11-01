module Meta = Metainfo.Meta.PosInfo
module AST = Netir.Ast.MkAST (Meta)
module DotAST = Netir.Dot_ast.MkDotAST (Meta)
open AST
open Meta

(*This test is meant to be ran using the command line.
Run: 
dune exec test/dottests/dotspecialchar.exe
dot ast.dot -Tsvg -o output.svg 
and open output.svg
to see the results. It should build with no errors and you should see a graph of the AST.
This shows that special characters compile correctly*)

let () =
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
  let code = DotAST.generate_dot_code Meta.string_of_mi prog in
  let oc = open_out "ast.dot" in
  output_string oc code;
  close_out oc
