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

module MkAST (M : Metainfo.Meta.Metainfo) = struct
  type m = M.t
  type name = M.t * string

  type typ =
    | VarTy of M.t * name
    | UnitTy of M.t
    | IntTy of M.t
    | FloatTy of M.t
    | CharTy of M.t
    | StringTy of M.t
    | BoolTy of M.t
    | FunTy of M.t * typ * typ

  type pattern =
    | WildcardPat of M.t
    | VarPat of M.t * name
    | UnitLitPat of M.t
    | IntLitPat of M.t * int
    | FloatLitPat of M.t * float
    | CharLitPat of M.t * char
    | StringLitPat of M.t * string
    | TrueLitPat of M.t
    | FalseLitPat of M.t
    | ConstructorPat of M.t * name * pattern list

  type unop = Neg of M.t | Not of M.t

  type binop =
    | Plus of M.t
    | Minus of M.t
    | Times of M.t
    | Div of M.t
    | And of M.t
    | Or of M.t
    | Eq of M.t
    | Neq of M.t
    | Lt of M.t
    | Leq of M.t
    | Gt of M.t
    | Geq of M.t

  type expr =
    | Var of M.t * name
    | UnitLit of M.t
    | IntLit of M.t * int
    | FloatLit of M.t * float
    | CharLit of M.t * char
    | StringLit of M.t * string
    | TrueLit of M.t
    | FalseLit of M.t
    | RecAbs of M.t * name * (pattern * expr) list
    | FunApp of M.t * expr * expr
    | TypeConstr of M.t * expr * typ
    | Unop of M.t * unop * expr
    | Binop of M.t * binop * expr * expr

  type decl =
    | TypeDecl of M.t * name * typ
    | DefnDecl of M.t * name * pattern * expr
    | ImportDecl of M.t * name
    | TypeAliasDecl of M.t * name * typ
    | VariantDecl of M.t * name * (name * typ) list

  type program = decl list

end
