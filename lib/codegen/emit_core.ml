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

exception Main_expr of expression

let loc = { !Ast_helper.default_loc with loc_ghost = true }

let rec emit_local_pexp (expr : 'a Local.expr) =
  match expr with
  | Unit _ -> Ast_builder.Default.eunit ~loc
  | Val (Int (i, _), _) -> Ast_builder.Default.eint ~loc i
  | Val (String (s, _), _) -> Ast_builder.Default.estring ~loc s
  | Val (Bool (b, _), _) -> Ast_builder.Default.ebool ~loc b
  | Var (VarId (v, _), _) -> Ast_builder.Default.evar ~loc v
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
    Ast_builder.Default.eapply
      ~loc
      (Ast_builder.Default.evar ~loc op)
      [ emit_local_pexp e1; emit_local_pexp e2 ]
  | Let (VarId (v, _), _, e1, e2, _) ->
    Ast_builder.Default.pexp_let
      ~loc
      Recursive
      [ Ast_builder.Default.value_binding
          ~loc
          ~pat:(Ast_builder.Default.pvar ~loc v)
          ~expr:(emit_local_pexp e1)
      ]
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
          Ast_builder.Default.case
            ~lhs:(emit_local_ppat p)
            ~guard:None
            ~rhs:(emit_local_pexp e))
        cases
    in
    Ast_builder.Default.pexp_match ~loc (emit_local_pexp e) cases
  | _ ->
    failwith "Not implemented ---------------------------------------------------------"

and emit_local_ppat (pat : 'a Local.pattern) =
  match pat with
  | Default _ -> Ast_builder.Default.ppat_any ~loc
  | Val (Int (i, _), _) -> Ast_builder.Default.pint ~loc i
  | Val (String (s, _), _) -> Ast_builder.Default.pstring ~loc s
  | Val (Bool (b, _), _) -> Ast_builder.Default.pbool ~loc b
  | Var (VarId (v, _), _) -> Ast_builder.Default.pvar ~loc v
  | Pair (p1, p2, _) -> [%pat? [%p emit_local_ppat p1], [%p emit_local_ppat p2]]
  | Left (p, _) -> [%pat? Either.Left [%p emit_local_ppat p]]
  | Right (p, _) -> [%pat? Either.Right [%p emit_local_ppat p]]
  | _ ->
    failwith "Not implemented ---------------------------------------------------------"
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
    Ast_builder.Default.pexp_fun
      ~loc
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
       Ast_builder.Default.value_binding
         ~loc
         ~pat:(Ast_builder.Default.pvar ~loc (Id.gen "_unit_"))
         ~expr:(emit_net_pexp ~self_id (module Msg) e)
     | [ var ] ->
       Ast_builder.Default.value_binding
         ~loc
         ~pat:(emit_local_ppat var)
         ~expr:(emit_net_pexp ~self_id (module Msg) e)
     | f :: ps ->
       Ast_builder.Default.value_binding
         ~loc
         ~pat:(emit_local_ppat f)
         ~expr:(emit_net_fun_body ~self_id (module Msg) ps e))
  | ForeignDecl (VarId (id, _), typ, external_name, _) ->
    emit_foreign_decl id typ external_name
  | _ ->
    Ast_builder.Default.value_binding
      ~loc
      ~pat:[%pat? _unit]
      ~expr:(Ast_builder.Default.eunit ~loc)

and emit_foreign_decl id _typ external_name =
  let open Ast_builder.Default in
  let module_path, function_name =
    if String.starts_with ~prefix:"@" external_name
    then (
      match
        String.split_on_char
          ':'
          (String.sub external_name 1 (String.length external_name - 1))
      with
      | [ file; func ] when file <> "" && func <> "" -> file, func
      | _ -> failwith "Invalid external function format. Expected @file:function")
    else external_name, external_name
  in
  let module_name =
    String.capitalize_ascii (Filename.basename (Filename.remove_extension module_path))
  in
  let fun_expr =
    pexp_fun
      ~loc
      Nolabel
      None
      (pvar ~loc "arg")
      [%expr [%e evar ~loc (module_name ^ "." ^ function_name)] [%e evar ~loc "arg"]]
  in
  value_binding ~loc ~pat:(pvar ~loc id) ~expr:fun_expr

and emit_net_pexp ~(self_id : string) (module Msg : Msg_intf) (exp : 'a Net.expr) =
  match exp with
  | Unit _ -> Ast_builder.Default.eunit ~loc
  | Var (VarId (v, _), _) -> Ast_builder.Default.evar ~loc v
  | Ret (e, _) -> emit_local_pexp e
  | If (e1, e2, e3, _) ->
    Ast_builder.Default.pexp_ifthenelse
      ~loc
      (emit_net_pexp ~self_id (module Msg) e1)
      (emit_net_pexp ~self_id (module Msg) e2)
      (Some (emit_net_pexp ~self_id (module Msg) e3))
  | Let (stmts, e, _) ->
    Ast_builder.Default.pexp_let
      ~loc
      Recursive
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
          Ast_builder.Default.case
            ~lhs:(emit_local_ppat p)
            ~guard:None
            ~rhs:(emit_net_pexp ~self_id (module Msg) e))
        cases
    in
    Ast_builder.Default.pexp_match ~loc (emit_net_pexp ~self_id (module Msg) e) cases
  | Send (e, LocId (dst, _), _) ->
    let val_id = Id.gen "val_" in
    [%expr
      let [%p Ast_builder.Default.pvar ~loc val_id] =
        [%e emit_net_pexp ~self_id (module Msg) e]
      in
      [%e
        Msg.emit_net_send
          ~src:self_id
          ~dst
          [%expr Ok [%e Ast_builder.Default.evar ~loc val_id]]]]
  | Recv (LocId (src, _), _) ->
    [%expr
      match [%e Msg.emit_net_recv ~src ~dst:self_id] with
      | Ok msg -> msg
      | Error msg -> failwith ("Receive error: " ^ msg)]
  | ChooseFor (LabelId (label, _), LocId (dst, _), e, _) ->
    Ast_builder.Default.esequence
      ~loc
      [ Msg.emit_net_send ~src:self_id ~dst (Ast_builder.Default.estring ~loc label)
      ; emit_net_pexp ~self_id (module Msg) e
      ]
  | AllowChoice (LocId (src, _), cases, _) ->
    let cases =
      List.map
        (fun (Local.LabelId (label, _), e) ->
          Ast_builder.Default.case
            ~lhs:(Ast_builder.Default.pstring ~loc label)
            ~guard:None
            ~rhs:(emit_net_pexp ~self_id (module Msg) e))
        cases
    and default_case =
      Ast_builder.Default.case
        ~lhs:(Ast_builder.Default.ppat_any ~loc)
        ~guard:None
        ~rhs:[%expr failwith "Error: Unmatched label"]
    in
    Ast_builder.Default.pexp_match
      ~loc
      (Msg.emit_net_recv ~src ~dst:self_id)
      (cases @ [ default_case ])
;;
