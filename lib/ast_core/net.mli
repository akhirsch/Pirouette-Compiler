module M : sig
  type 'a typ =
    | TUnit of 'a
    | TLoc of 'a Local.M.loc_id * 'a Local.M.typ * 'a
    | TMap of 'a typ * 'a typ * 'a
    | TProd of 'a typ * 'a typ * 'a
    | TSum of 'a typ * 'a typ * 'a
    | TVariant of 'a constructor list * 'a

    and 'a constructor =
      { name : string
      ; args : 'a typ list
      ; info : 'a
      }

  type 'a expr =
    | Unit of 'a
    | Var of 'a Local.M.var_id * 'a
    | Ret of 'a Local.M.expr * 'a
    | If of 'a expr * 'a expr * 'a expr * 'a
    | Let of 'a stmt list * 'a expr * 'a
    | Send of 'a expr * 'a Local.M.loc_id * 'a
    | Recv of 'a Local.M.loc_id * 'a
    | ChooseFor of 'a Local.M.sync_label * 'a Local.M.loc_id * 'a expr * 'a
    | AllowChoice of 'a Local.M.loc_id * ('a Local.M.sync_label * 'a expr) list * 'a
    | FunDef of 'a Local.M.pattern list * 'a expr * 'a
    | FunApp of 'a expr * 'a expr * 'a
    | Pair of 'a expr * 'a expr * 'a
    | Fst of 'a expr * 'a
    | Snd of 'a expr * 'a
    | Left of 'a expr * 'a
    | Right of 'a expr * 'a
    | Match of 'a expr * ('a Local.M.pattern * 'a expr) list * 'a
    | Construct of string * 'a expr list * 'a

  and 'a stmt =
    | Decl of 'a Local.M.pattern * 'a typ * 'a
    | Assign of 'a Local.M.pattern list * 'a expr * 'a
    | TypeDecl of 'a Local.M.typ_id * 'a typ * 'a
    | ForeignDecl of 'a Local.M.var_id * 'a typ * string * 'a

  and 'a stmt_block = 'a stmt list
end

module With : functor
    (Info : sig
       type t
     end)
    -> sig
  type nonrec typ = Info.t M.typ
  type nonrec expr = Info.t M.expr
  type nonrec stmt = Info.t M.stmt
  type nonrec stmt_block = Info.t M.stmt_block

  val get_info_typ : typ -> Info.t
  val get_info_expr : expr -> Info.t
  val get_info_stmt : stmt -> Info.t
  val set_info_typ : Info.t -> typ -> typ
  val set_info_expr : Info.t -> expr -> expr
  val set_info_stmt : Info.t -> stmt -> stmt
end
