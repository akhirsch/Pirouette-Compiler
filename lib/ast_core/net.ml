module Local = Local.M

module M = struct
  type 'a typ =
    | TUnit of 'a
    | TLoc of 'a Local.loc_id * 'a Local.typ * 'a
    | TMap of 'a typ * 'a typ * 'a
    | TProd of 'a typ * 'a typ * 'a
    | TSum of 'a typ * 'a typ * 'a

  type 'a expr =
    | Unit of 'a
    | Var of 'a Local.var_id * 'a
    | Ret of 'a Local.expr * 'a
    | If of 'a expr * 'a expr * 'a expr * 'a
    | Let of 'a stmt list * 'a expr * 'a
    | Send of 'a expr * 'a Local.loc_id * 'a
    | Recv of 'a Local.loc_id * 'a
    | ChooseFor of 'a Local.sync_label * 'a Local.loc_id * 'a expr * 'a
    | AllowChoice of 'a Local.loc_id * ('a Local.sync_label * 'a expr) list * 'a
    | FunDef of 'a Local.pattern list * 'a expr * 'a
    | FunApp of 'a expr * 'a expr * 'a
    | Pair of 'a expr * 'a expr * 'a
    | Fst of 'a expr * 'a
    | Snd of 'a expr * 'a
    | Left of 'a expr * 'a
    | Right of 'a expr * 'a
    | Match of 'a expr * ('a Local.pattern * 'a expr) list * 'a

  and 'a stmt =
    | Decl of 'a Local.pattern * 'a typ * 'a
    | Assign of 'a Local.pattern list * 'a expr * 'a
    | TypeDecl of 'a Local.typ_id * 'a typ * 'a
    | ForeignDecl of 'a Local.var_id * 'a typ * string * 'a
    | ForeignTypeDecl of 'a Local.typ_id * 'a

  and 'a stmt_block = 'a stmt list
end

module With (Info : sig
    type t
  end) =
struct
  type nonrec typ = Info.t M.typ
  type nonrec expr = Info.t M.expr
  type nonrec stmt = Info.t M.stmt
  type nonrec stmt_block = Info.t M.stmt_block

  let get_info_typ : typ -> Info.t = function
    | TUnit i -> i
    | TLoc (_, _, i) -> i
    | TMap (_, _, i) -> i
    | TProd (_, _, i) -> i
    | TSum (_, _, i) -> i
  ;;

  let get_info_expr : expr -> Info.t = function
    | Unit i -> i
    | Var (_, i) -> i
    | Ret (_, i) -> i
    | If (_, _, _, i) -> i
    | Let (_, _, i) -> i
    | Send (_, _, i) -> i
    | Recv (_, i) -> i
    | ChooseFor (_, _, _, i) -> i
    | AllowChoice (_, _, i) -> i
    | FunDef (_, _, i) -> i
    | FunApp (_, _, i) -> i
    | Pair (_, _, i) -> i
    | Fst (_, i) -> i
    | Snd (_, i) -> i
    | Left (_, i) -> i
    | Right (_, i) -> i
    | Match (_, _, i) -> i
  ;;

  let get_info_stmt : stmt -> Info.t = function
    | Decl (_, _, i) -> i
    | Assign (_, _, i) -> i
    | TypeDecl (_, _, i) -> i
    | ForeignDecl (_, _, _, i) -> i
    | ForeignTypeDecl (_, i) -> i 
  ;;

  let set_info_typ : Info.t -> typ -> typ =
    fun i -> function
    | TUnit _ -> TUnit i
    | TLoc (loc, t, _) -> TLoc (loc, t, i)
    | TMap (t1, t2, _) -> TMap (t1, t2, i)
    | TProd (t1, t2, _) -> TProd (t1, t2, i)
    | TSum (t1, t2, _) -> TSum (t1, t2, i)
  ;;

  let set_info_expr : Info.t -> expr -> expr =
    fun i -> function
    | Unit _ -> Unit i
    | Var (v, _) -> Var (v, i)
    | Ret (e, _) -> Ret (e, i)
    | If (e1, e2, e3, _) -> If (e1, e2, e3, i)
    | Let (stmts, e, _) -> Let (stmts, e, i)
    | Send (e1, e2, _) -> Send (e1, e2, i)
    | Recv (loc, _) -> Recv (loc, i)
    | ChooseFor (label, loc, e, _) -> ChooseFor (label, loc, e, i)
    | AllowChoice (loc, choices, _) -> AllowChoice (loc, choices, i)
    | FunDef (pats, e, _) -> FunDef (pats, e, i)
    | FunApp (e1, e2, _) -> FunApp (e1, e2, i)
    | Pair (e1, e2, _) -> Pair (e1, e2, i)
    | Fst (e, _) -> Fst (e, i)
    | Snd (e, _) -> Snd (e, i)
    | Left (e, _) -> Left (e, i)
    | Right (e, _) -> Right (e, i)
    | Match (e, cases, _) -> Match (e, cases, i)
  ;;

  let set_info_stmt : Info.t -> stmt -> stmt =
    fun i -> function
    | Decl (p, t, _) -> Decl (p, t, i)
    | Assign (ps, e, _) -> Assign (ps, e, i)
    | TypeDecl (id, t, _) -> TypeDecl (id, t, i)
    | ForeignDecl (id, t, s, _) -> ForeignDecl (id, t, s, i)
    | ForeignTypeDecl (id, _) -> ForeignTypeDecl (id, i)
  ;;
end
