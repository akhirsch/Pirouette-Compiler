(*This file exists because the parser need an external module
  for the sake of resolving types. Since this is the result of
  a fucntor, trying to create this inside of the .mly file
  creates a mismatch in the generated .ml and .mli file.

  TODO: Look into a cleaner solution
*)
module M = Ast.MkAST(Metainfo.Meta.PosInfo)