module MkPrettify : functor (A : Ast.AST) -> sig
  val prettify_typ : A.typ -> string
  val prettify_pattern : A.pattern -> string
  val prettify_unop : A.unop -> string
  val prettify_binop : A.binop -> string
  val prettify_expr : A.expr -> string
  val prettify_decl : A.decl -> string
  val prettify_prog : A.program -> string
end
