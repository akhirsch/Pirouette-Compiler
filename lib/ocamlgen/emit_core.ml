module Local = Ast_core.Local.M
module Net = Ast_core.Net.M

module type Msg_intf = Msg_intf.M

module Id = struct
  let i = ref 0

  let gen name =
    incr i;
    Printf.sprintf "%s%d" name !i
  ;;
end

open Ppxlib

module Builder = Ast_builder.Make (struct
    let loc = { !Ast_helper.default_loc with loc_ghost = true }
  end)

let loc = Builder.loc

exception Main_expr of expression

let rec emit_local_pexp (expr : 'a Local.expr) =
  match expr with
  | Unit _ -> Builder.eunit
  | Val (Int (i, _), _) -> Builder.eint i
  | Val (String (s, _), _) -> Builder.estring s
  | Val (Bool (b, _), _) -> Builder.ebool b
  | Var (VarId (v, _), _) -> Builder.evar v
  | UnOp (Not _, e, _) -> [%expr not [%e emit_local_pexp e]]
  | UnOp (Neg _, e, _) -> [%expr -[%e emit_local_pexp e]]
  | BinOp (e1, op, e2, _) ->
    let op =
      match op with
      | Plus _ -> "+"
      | Minus _ -> "-"
      | Times _ -> "*"
      | Div _ -> "/"
      | And _ -> "&&"
      | Or _ -> "||"
      | Eq _ -> "="
      | Neq _ -> "<>"
      | Lt _ -> "<"
      | Leq _ -> "<="
      | Gt _ -> ">"
      | Geq _ -> ">="
    in
    Builder.eapply (Builder.evar op) [ emit_local_pexp e1; emit_local_pexp e2 ]
  | Let (VarId (v, _), _, e1, e2, _) ->
    Builder.pexp_let
      Recursive
      [ Builder.value_binding ~pat:(Builder.pvar v) ~expr:(emit_local_pexp e1) ]
      (emit_local_pexp e2)
  | Pair (e1, e2, _) -> [%expr [%e emit_local_pexp e1], [%e emit_local_pexp e2]]
  | Fst (e, _) -> [%expr fst [%e emit_local_pexp e]]
  | Snd (e, _) -> [%expr snd [%e emit_local_pexp e]]
  | Left (e, _) -> [%expr Either.Left [%e emit_local_pexp e]]
  | Right (e, _) -> [%expr Either.Right [%e emit_local_pexp e]]
  | Match (e, cases, _) ->
    let cases =
      List.map
        (fun (p, e) ->
           Builder.case ~lhs:(emit_local_ppat p) ~guard:None ~rhs:(emit_local_pexp e))
        cases
    in
    Builder.pexp_match (emit_local_pexp e) cases

and emit_local_ppat (pat : 'a Local.pattern) =
  match pat with
  | Default _ -> Builder.ppat_any
  | Val (Int (i, _), _) -> Builder.pint i
  | Val (String (s, _), _) -> Builder.pstring s
  | Val (Bool (b, _), _) -> Builder.pbool b
  | Var (VarId (v, _), _) -> Builder.pvar v
  | Pair (p1, p2, _) -> [%pat? [%p emit_local_ppat p1], [%p emit_local_ppat p2]]
  | Left (p, _) -> [%pat? Either.Left [%p emit_local_ppat p]]
  | Right (p, _) -> [%pat? Either.Right [%p emit_local_ppat p]]
;;

let rec emit_net_fun_body
          ~(self_id : string)
          (module Msg : Msg_intf)
          (pats : 'a Local.pattern list)
          (exp : 'a Net.expr)
  =
  match pats with
  | [] -> emit_net_pexp ~self_id (module Msg : Msg_intf) exp
  | f :: ps ->
    Builder.pexp_fun
      Nolabel
      None
      (emit_local_ppat f)
      (emit_net_fun_body ~self_id (module Msg) ps exp)

and emit_net_binding ~(self_id : string) (module Msg : Msg_intf) (stmt : 'a Net.stmt) =
  match stmt with
  | Assign (ps, e, _) ->
    (match ps with
     | [] -> failwith "Error: Empty assignment"
     | Var (VarId ("main", _), _) :: _ ->
       raise (Main_expr (emit_net_pexp ~self_id (module Msg) e))
     | Default _ :: _ ->
       Builder.value_binding
         ~pat:(Builder.pvar (Id.gen "_unit_"))
         ~expr:(emit_net_pexp ~self_id (module Msg) e)
     | [ var ] ->
       Builder.value_binding
         ~pat:(emit_local_ppat var)
         ~expr:(emit_net_pexp ~self_id (module Msg) e)
     | f :: ps ->
       Builder.value_binding
         ~pat:(emit_local_ppat f)
         ~expr:(emit_net_fun_body ~self_id (module Msg) ps e))
  | ForeignDecl (VarId (id, _), typ, external_name, _) ->
    emit_foreign_decl id typ external_name
  | _ -> Builder.value_binding ~pat:[%pat? _unit] ~expr:Builder.eunit

and emit_foreign_decl id typ external_name=
  let open Ast_builder.Default in
  let package_name, function_name, _ =
    Ast_utils.parse_external_name external_name
  in
  let package_string =
    match package_name with
    | Some pack -> pack ^ "."
    | None -> ""
  in
  (* A function that takes in a Net type and pretty prints the type into Ocaml. Note, loc.types turn into just types*)
  let rec find_type_sig : 'a Net.typ -> label = function
    | TUnit _ -> "(unit)"
    | TLoc (_, local_type, _) -> let rec find_local_type_sig : 'a Local.typ -> label = function  
                                  | TUnit _ -> "(unit)"
                                  | TInt _ -> "(int)"
                                  | TString _ -> "(string)"
                                  | TBool _ -> "(bool)"
                                  | TVar (TypId (typ_id, _), _) -> "(" ^ typ_id ^ ")"
                                  | TProd (typ1, typ2, _) -> "(" ^ (find_local_type_sig typ1) ^ " * " ^ (find_local_type_sig typ2) ^ ")"
                                  | TSum (typ1, typ2, _) -> "(" ^ (find_local_type_sig typ1) ^ " + " ^ (find_local_type_sig typ2) ^ ")"
                                  | TForeign (TypId (typ_id, _), _) -> "(" ^ typ_id ^ ")"
                                in find_local_type_sig local_type
    | TMap (typ1, typ2, _) -> "(" ^ (find_type_sig typ1) ^ " -> " ^ (find_type_sig typ2) ^ ")"
    | TProd (typ1, typ2, _) -> "(" ^ (find_type_sig typ1) ^ " * " ^ (find_type_sig typ2) ^ ")"
    | TSum (typ1, typ2, _) -> "(" ^ (find_type_sig typ1) ^ " + " ^ (find_type_sig typ2) ^ ")" in

  (* The full type signature of a function. We apply this type signature to the identifier, then we set the value of the identifier to be equal to 'fun arg ->[ffi]]'. This works because of currying. *)
  let type_sig = find_type_sig typ in
  
  let fun_expr =
    pexp_fun
      ~loc
      Nolabel
      None
      (pvar ~loc (": " ^ type_sig))
      [%expr
        [%e evar ~loc "fun arg ->"]
        [%e evar ~loc (package_string ^ function_name)]
        [%e evar ~loc "arg"]]
  in
  value_binding ~loc ~pat:(pvar ~loc id) ~expr:fun_expr

and emit_net_pexp ~(self_id : string) (module Msg : Msg_intf) (exp : 'a Net.expr) =
  match exp with
  | Unit _ -> Builder.eunit
  | Var (VarId (v, _), _) -> Builder.evar v
  | Ret (e, _) -> emit_local_pexp e
  | If (e1, e2, e3, _) ->
    Builder.pexp_ifthenelse
      (emit_net_pexp ~self_id (module Msg) e1)
      (emit_net_pexp ~self_id (module Msg) e2)
      (Some (emit_net_pexp ~self_id (module Msg) e3))
  | Let (stmts, e, _) ->
    Builder.pexp_let
      Recursive (*FIXME: how to handle tuples?*)
      (* -From Audvy: We could create a function that taktes in stmts and outputs their Net Type, and then match on that, and only apply the Recursive flag on TMaps
      OR
      We create a function that takes in stmts and outputs the amount of identifiers on the left hand side. It anything more than 1 (exluding args), than it cannot be a func, so use the Nonrecursive flag*)
      (List.map (emit_net_binding ~self_id (module Msg)) stmts)
      (emit_net_pexp ~self_id (module Msg) e)
  | FunDef (ps, e, _) -> emit_net_fun_body ~self_id (module Msg) ps e
  | FunApp (e1, e2, _) ->
    [%expr
      [%e emit_net_pexp ~self_id (module Msg) e1]
        [%e emit_net_pexp ~self_id (module Msg) e2]]
  | Pair (e1, e2, _) ->
    [%expr
      [%e emit_net_pexp ~self_id (module Msg) e1]
    , [%e emit_net_pexp ~self_id (module Msg) e2]]
  | Fst (e, _) -> [%expr fst [%e emit_net_pexp ~self_id (module Msg) e]]
  | Snd (e, _) -> [%expr snd [%e emit_net_pexp ~self_id (module Msg) e]]
  | Left (e, _) -> [%expr Either.Left [%e emit_net_pexp ~self_id (module Msg) e]]
  | Right (e, _) -> [%expr Either.Right [%e emit_net_pexp ~self_id (module Msg) e]]
  | Match (e, cases, _) ->
    let cases =
      List.map
        (fun (p, e) ->
           Builder.case
             ~lhs:(emit_local_ppat p)
             ~guard:None
             ~rhs:(emit_net_pexp ~self_id (module Msg) e))
        cases
    in
    Builder.pexp_match (emit_net_pexp ~self_id (module Msg) e) cases
  | Send (e, LocId (dst, _), _) ->
    let val_id = Id.gen "val_" in
    [%expr
      let [%p Builder.pvar val_id] = [%e emit_net_pexp ~self_id (module Msg) e] in
      [%e
        Msg.emit_net_send
          ~src:self_id
          ~dst
          [%expr Marshal.to_string [%e Builder.evar val_id] []]]]
  | Recv (LocId (src, _), _) ->
    [%expr Marshal.from_string [%e Msg.emit_net_recv ~src ~dst:self_id] 0]
  | ChooseFor (LabelId (label, _), LocId (dst, _), e, _) ->
    Builder.esequence
      [ Msg.emit_net_send ~src:self_id ~dst (Builder.estring label)
      ; emit_net_pexp ~self_id (module Msg) e
      ]
  | AllowChoice (LocId (src, _), cases, _) ->
    let cases =
      List.map
        (fun (Local.LabelId (label, _), e) ->
           Builder.case
             ~lhs:(Builder.pstring label)
             ~guard:None
             ~rhs:(emit_net_pexp ~self_id (module Msg) e))
        cases
    and default_case =
      Builder.case
        ~lhs:Builder.ppat_any
        ~guard:None
        ~rhs:[%expr failwith "Runtime Error: Unmatched label"]
    in
    Builder.pexp_match (Msg.emit_net_recv ~src ~dst:self_id) (cases @ [ default_case ])
;;
