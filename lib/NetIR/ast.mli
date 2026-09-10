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
    | LocTy of m * name list (* [LocTy l] is the type of locations named in l *)

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
    | LocLitPat of m * name
    | ConstructorPat of m * name * pattern list
    | LocNamePat of m * name

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

  type lab = Label of name

  type expr =
    | Var of m * name
    | UnitLit of m
    | IntLit of m * int
    | FloatLit of m * float
    | CharLit of m * char
    | StringLit of m * string
    | TrueLit of m
    | FalseLit of m
    | LocLit of m * name
    | Match of m * expr * (pattern * expr) list
    | RecAbs of m * name * name * expr
    | FunApp of m * expr * expr
    | TypeConstr of m * expr * typ
    | Unop of m * unop * expr
    | Binop of m * binop * expr * expr
    (* Communication Primitives *)
    | Send of m * expr * name (* Send e to n *)
    | Recv of m * typ * name (* Recv t from n *)
    | ChooseFor of m * name * lab
    | AllowChoice of m * name * (lab * expr) list
    (* Location-Checking Primitive *)
    | AmI of m * expr

  type decl =
    | EmulatedLocDecl of m * name
    | TypeDecl of
        m * name * typ (* Declares the type of a binding: `foo : int` *)
    | TypeAliasDecl of
        m * name * typ (* Declares a type alias: `student = string * float` *)
    | DefnDecl of m * name * pattern list * expr
    | ImportDecl of m * name
    | VariantDecl of m * name * (name * typ list * typ) list

  type program = decl list
end

module MkAST : functor (M : Metainfo.Meta.Metainfo) -> AST with type m = M.t

module PosInfo_AST : AST with type m = Metainfo.Meta.PosInfo.t
