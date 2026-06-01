type 'a name = 'a * string

type 'a typ =
  | UnitTy of 'a
  | IntTy of 'a
  | FloatTy of 'a
  | CharTy of 'a
  | StringTy of 'a
  | BoolTy of 'a
  | FunTy of 'a * 'a typ * 'a typ
  | VariantTy of 'a * ('a name * 'a typ) list

type 'a pattern =
  | WildcardPat of 'a
  | VarPat of 'a * 'a name
  | UnitLitPat of 'a
  | IntLitPat of 'a * int
  | FloatLitPat of 'a * float
  | CharLitPat of 'a * char
  | StringLitPat of 'a * string
  | TrueLitPat of 'a
  | FalseLitPat of 'a
  | ConstructorPat of 'a * 'a name * 'a pattern list

type 'a expr =
  | Var of 'a * 'a name
  | UnitLit of 'a
  | IntLit of 'a * int
  | FloatList of 'a * float
  | CharLit of 'a * char
  | StringLit of 'a * string
  | TrueLit of 'a
  | FalseList of 'a
  | RecAbs of 'a * 'a name * ('a pattern * 'a expr) list
  | FunApp of 'a * 'a expr * 'a expr

type 'a decl =
  | TypeDecl of 'a * 'a name * 'a typ
  | DefnDecl of 'a * 'a name * 'a pattern * 'a expr
  | ImportDecl of 'a * 'a name
  | TypeAliasDecl of 'a * 'a name * 'a typ
  | VariantDecl of 'a * 'a name * ('a name * 'a typ) list
