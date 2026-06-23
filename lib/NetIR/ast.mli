module type AST = sig
  type m
  type name = m * string

  type typ =
    | VarTy of m * name
    | UnitTy of m
    | IntTy of m
    | FloatTy of m
    | CharTy of m
    | StringTy of m
    | BoolTy of m
    | FunTy of m * typ * typ

  type pattern =
    | WildcardPat of m
    | VarPat of m * name
    | UnitLitPat of m
    | IntLitPat of m * int
    | FloatLitPat of m * float
    | CharLitPat of m * char
    | StringLitPat of m * string
    | TrueLitPat of m
    | FalseLitPat of m
    | ConstructorPat of m * name * pattern list

  type unop = Neg of m | Not of m

  type binop =
    | Plus of m
    | Minus of m
    | Times of m
    | Div of m
    | And of m
    | Or of m
    | Eq of m
    | Neq of m
    | Lt of m
    | Leq of m
    | Gt of m
    | Geq of m

  type expr =
    | Var of m * name
    | UnitLit of m
    | IntLit of m * int
    | FloatLit of m * float
    | CharLit of m * char
    | StringLit of m * string
    | TrueLit of m
    | FalseLit of m
    | RecAbs of m * name * (pattern * expr) list
    | FunApp of m * expr * expr
    | TypeConstr of m * expr * typ
    | Unop of m * unop * expr
    | Binop of m * binop * expr * expr

  type decl =
    | TypeDecl of m * name * typ
    | DefnDecl of m * name * pattern * expr
    | ImportDecl of m * name
    | TypeAliasDecl of m * name * typ
    | VariantDecl of m * name * (name * typ) list

  type program = decl list

  val prettify_typ : typ -> string
  val prettify_pattern : pattern -> string
  val prettify_unop : unop -> string
  val prettify_binop : binop -> string
  val prettify_expr : expr -> string
  val prettify_decl : decl -> string
  val prettify_prog : program -> string
end

module MkAST : functor (M : Metainfo.Meta.Metainfo) -> AST with type m = M.t
