(* Parse the standard library file pointed to by the path specified in PIR_STDLIB environment variable on the user's system *)
let get_stdlib_ast ?(recompile = false) () : 'a Ast_core.Choreo.M.stmt_block =
  if recompile then (
    Stdlib_compiler.compile_stdlib ();
    Stdlib_ast.ast)
  else Stdlib_ast.ast
