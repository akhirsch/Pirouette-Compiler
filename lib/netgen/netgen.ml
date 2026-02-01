module Local = Ast_core.Local.M
module Choreo = Ast_core.Choreo.M
module Net = Ast_core.Net.M

let _m = Obj.magic () (* dummy metainfo to make the types work *)

(* Use this list to create a whitelist of locations/agents/domains that will NOT have type information for their variables erased when compiling for other locations/agents/domains*)
let whitelisted_locs = [ "PIRSTDLIBLOC" ]

(* TODO: change Hashtbl to List *)
let rec merge_net_stmt (stmt : 'a Net.stmt) (stmt' : 'a Net.stmt) : 'a Net.stmt option =
  match stmt, stmt' with
  | Decl (p, t, _), Decl (p', t', _) when p = p' && t = t' -> Some (Decl (p, t, _m))
  | TypeDecl (id, t, _), TypeDecl (id', t', _) when id = id' && t = t' ->
    Some (TypeDecl (id, t, _m))
  | Assign (p, e, _), Assign (p', e', _) when p = p' ->
    (match merge_net_expr e e' with
     | Some e -> Some (Assign (p, e, _m))
     | None -> None)
  | _ -> None

and merge_net_expr (expr : 'a Net.expr) (expr' : 'a Net.expr) : 'a Net.expr option =
  match expr, expr' with
  | Unit _, Unit _ -> Some (Unit _m)
  | Var (id1, _), Var (id2, _) when id1 = id2 -> Some (Var (id1, _m))
  | Ret (e, _), Ret (e', _) when e = e' -> Some (Ret (e, _m))
  | Pair (e1, e2, _), Pair (e1', e2', _) ->
    (match merge_net_expr e1 e1', merge_net_expr e2 e2' with
     | Some e1, Some e2 -> Some (Pair (e1, e2, _m))
     | _ -> None)
  | Fst (e, _), Fst (e', _) ->
    (match merge_net_expr e e' with
     | Some e -> Some (Fst (e, _m))
     | None -> None)
  | Snd (e, _), Snd (e', _) ->
    (match merge_net_expr e e' with
     | Some e -> Some (Snd (e, _m))
     | None -> None)
  | Left (e, _), Left (e', _) ->
    (match merge_net_expr e e' with
     | Some e -> Some (Left (e, _m))
     | None -> None)
  | Right (e, _), Right (e', _) ->
    (match merge_net_expr e e' with
     | Some e -> Some (Right (e, _m))
     | None -> None)
  | Send (e1, LocId (loc, _), _), Send (e2, LocId (loc', _), _) when loc = loc' ->
    (match merge_net_expr e1 e2 with
     | Some e -> Some (Send (e, LocId (loc, _m), _m))
     | None -> None)
  | Recv (LocId (loc, _), _), Recv (LocId (loc', _), _) when loc = loc' ->
    Some (Recv (LocId (loc, _m), _m))
  | FunDef (p, e, _), FunDef (p', e', _) when p = p' && e = e' -> Some (FunDef (p, e, _m))
  | FunApp (e1, e2, _), FunApp (e1', e2', _) ->
    (match merge_net_expr e1 e1', merge_net_expr e2 e2' with
     | Some e1, Some e2 -> Some (FunApp (e1, e2, _m))
     | _ -> None)
  | If (e1, e2, e3, _), If (e1', e2', e3', _) when e1 = e1' ->
    (match merge_net_expr e2 e2', merge_net_expr e3 e3' with
     | Some e2, Some e3 -> Some (If (e1, e2, e3, _m))
     | _ -> None)
  | Let (stmts, e, _), Let (stmts', e', _) ->
    if List.length stmts <> List.length stmts'
    then None
    else (
      let merged_stmts =
        let exception Not_matched in
        try
          List.fold_left2
            (fun acc s1 s2 ->
               match acc with
               | Some acc ->
                 (match merge_net_stmt s1 s2 with
                  | Some s -> Some (s :: acc)
                  | None -> raise Not_matched)
               | None -> raise Not_matched)
            (Some [])
            stmts
            stmts'
        with
        | Not_matched -> None
      in
      match merged_stmts with
      | Some stmts ->
        (match merge_net_expr e e' with
         | Some e -> Some (Let (List.rev stmts, e, _m))
         | None -> None)
      | None -> None)
  | Match (e, cases, _), Match (e', cases', _) when e = e' ->
    let cases1_tbl = Hashtbl.create (List.length cases) in
    List.iter (fun (p, e) -> Hashtbl.add cases1_tbl p e) cases;
    let exception Not_matched in
    (try
       List.iter
         (fun (p, e) ->
            match Hashtbl.find_opt cases1_tbl p with
            | Some e' ->
              (match merge_net_expr e e' with
               | Some e -> Hashtbl.replace cases1_tbl p e
               | None -> raise Not_matched)
            | None -> raise Not_matched)
         cases';
       Some (Match (e, Hashtbl.fold (fun p e acc -> (p, e) :: acc) cases1_tbl [], _m))
     with
     | Not_matched -> None)
  | ChooseFor (l, LocId (loc, _), e, _), ChooseFor (l', LocId (loc', _), e', _)
    when l = l' && loc = loc' ->
    (match merge_net_expr e e' with
     | Some e -> Some (ChooseFor (l, LocId (loc, _m), e, _m))
     | None -> None)
  | AllowChoice (LocId (loc, _), choices, _), AllowChoice (LocId (loc', _), choices', _)
    when loc = loc' ->
    let merge_choice_into tbl (label, expr) =
      match Hashtbl.find_opt tbl label with
      | Some expr' ->
        (match merge_net_expr expr expr' with
         | Some e -> Hashtbl.replace tbl label e
         | None -> Hashtbl.add tbl label expr)
      | None -> Hashtbl.add tbl label expr
    in
    Some
      (AllowChoice
         ( LocId (loc, _m)
         , (let tbl = Hashtbl.create 2 in
            List.iter (merge_choice_into tbl) choices;
            List.iter (merge_choice_into tbl) choices';
            Hashtbl.fold (fun l e acc -> (l, e) :: acc) tbl [])
         , _m ))
    (* use list *)
  | _ -> None
;;

let rec epp_choreo_type (typ : 'a Choreo.typ) (loc : string) : 'a Net.typ =
  match typ with
  | TLoc ((LocId (loc1, _) as locid), t1, _) ->
    (* If the location of the type is the location of the domain, or the location of the type is whitelisted e.g. in the case of the stdlib providing functions where type info should be shown to all other domains, keep type info*)
    if List.mem loc1 whitelisted_locs || loc1 = loc
    then TLoc (locid, t1, _m)
    else TUnit _m
  | TMap (t1, t2, _) -> TMap (epp_choreo_type t1 loc, epp_choreo_type t2 loc, _m)
  | TProd (t1, t2, _) -> TProd (epp_choreo_type t1 loc, epp_choreo_type t2 loc, _m)
  | TSum (t1, t2, _) -> TSum (epp_choreo_type t1 loc, epp_choreo_type t2 loc, _m)
  | _ -> TUnit _m
;;

let rec epp_choreo_pattern (pat : 'a Choreo.pattern) (loc : string) : 'a Local.pattern =
  match pat with
  | Default _ -> Default _m
  | Var (id, _) -> Var (id, _m)
  | Pair (p1, p2, _) -> Pair (epp_choreo_pattern p1 loc, epp_choreo_pattern p2 loc, _m)
  | LocPat (LocId (id, _), p, _) -> if id = loc then p else Default _m
  | Left (p, _) -> Left (epp_choreo_pattern p loc, _m)
  | Right (p, _) -> Right (epp_choreo_pattern p loc, _m)
;;

let rec epp_choreo_stmt (stmt : 'a Choreo.stmt) (loc : string) : 'a Net.stmt =
  match stmt with
  | Decl (p, t, _) -> Decl (epp_choreo_pattern p loc, epp_choreo_type t loc, _m)
  | Assign (ps, e, _) ->
    let epp_ps = List.map (fun p -> epp_choreo_pattern p loc) ps in
    (match epp_ps with
     | Default _m :: _ -> Assign ([ Default _m ], epp_choreo_expr e loc, _m)
     | _ -> Assign (epp_ps, epp_choreo_expr e loc, _m))
  | TypeDecl (id, t, _) -> TypeDecl (id, epp_choreo_type t loc, _m)
  | ForeignDecl (id, t, s, _) -> ForeignDecl (id, epp_choreo_type t loc, s, _m)

and epp_choreo_expr (expr : 'a Choreo.expr) (loc : string) : 'a Net.expr =
  match expr with
  | Var (id, _) -> Var (id, _m)
  | LocExpr (LocId (loc1, _), e, _) when loc1 = loc -> Ret (e, _m)
  | FunDef (ps, e, _) ->
    let epp_ps = List.map (fun p -> epp_choreo_pattern p loc) ps in
    (match epp_ps with
     | Default _m :: _ -> FunDef ([ Default _m ], epp_choreo_expr e loc, _m)
     | _ -> FunDef (epp_ps, epp_choreo_expr e loc, _m))
  | FunApp (e1, e2, _) ->
    (* let e1' = epp_choreo_expr e1 loc in *)
    (* let e2' = epp_choreo_expr e2 loc in *)
    (* (match e1', e2' with *)
    (*  | Unit _, _ | _, Unit _ -> Unit _m *)
    (*  | _ -> FunApp (e1', e2', _m)) *)
    let epp_e1 = epp_choreo_expr e1 loc in
    (match epp_e1 with
     | Unit _m -> Unit _m
     | _ -> FunApp (epp_e1, epp_choreo_expr e2 loc, _m))
  | Pair (e1, e2, _) -> Pair (epp_choreo_expr e1 loc, epp_choreo_expr e2 loc, _m)
  | Fst (e, _) -> Fst (epp_choreo_expr e loc, _m)
  | Snd (e, _) -> Snd (epp_choreo_expr e loc, _m)
  | Left (e, _) -> Left (epp_choreo_expr e loc, _m)
  | Right (e, _) -> Right (epp_choreo_expr e loc, _m)
  | Let (stmts, e, _) ->
    let effective_stmts =
      List.map (fun stmt -> epp_choreo_stmt stmt loc) stmts
      |> List.filter (function
        | Net.Decl (Default _, TUnit _, _) -> false
        | Net.Assign ([ Default _ ], Unit _, _) -> false
        | _ -> true)
    in
    if effective_stmts = []
    then epp_choreo_expr e loc
    else Let (effective_stmts, epp_choreo_expr e loc, _m)
  | Send (LocId (loc1, _), e, LocId (loc2, _), _) ->
    if loc1 = loc2
    then epp_choreo_expr e loc
    else if loc1 = loc
    then Send (epp_choreo_expr e loc, LocId (loc2, _m), _m)
    else if loc2 = loc
    then Recv (LocId (loc1, _m), _m)
    else epp_choreo_expr e loc
  | Sync (LocId (id1, _), l, LocId (id2, _), e, _) ->
    if id1 = loc && id2 <> loc
    then ChooseFor (l, LocId (id2, _m), epp_choreo_expr e loc, _m)
    else if id2 = loc && id1 <> loc
    then AllowChoice (LocId (id1, _m), [ l, epp_choreo_expr e loc ], _m)
    else if id1 <> id2
    then epp_choreo_expr e loc
    else Unit _m
  | If (e1, e2, e3, _m) ->
    (match merge_net_expr (epp_choreo_expr e2 loc) (epp_choreo_expr e3 loc) with
     | Some e -> e
     | None ->
       If (epp_choreo_expr e1 loc, epp_choreo_expr e2 loc, epp_choreo_expr e3 loc, _m))
  | Match (match_e, cases, _) ->
    let merged_cases =
      match cases with
      | [] -> None
      | (_, case_e) :: rest ->
        List.fold_left
          (fun acc (_, e) ->
             match acc with
             | Some e' -> merge_net_expr e' (epp_choreo_expr e loc)
             | None -> None)
          (Some (epp_choreo_expr case_e loc))
          rest
    in
    (match merged_cases with
     | Some e -> e
     | None ->
       Match
         ( epp_choreo_expr match_e loc
         , List.map (fun (p, e) -> epp_choreo_pattern p loc, epp_choreo_expr e loc) cases
         , _m ))
  | _ -> Unit _m
;;

let epp_choreo_to_net stmt_block loc =
  List.map (fun stmt -> epp_choreo_stmt stmt loc) stmt_block
;;
