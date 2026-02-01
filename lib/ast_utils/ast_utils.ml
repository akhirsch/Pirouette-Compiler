module Choreo = Ast_core.Choreo.M
module Net = Ast_core.Net.M

let extract_locs (stmt_block : 'a Choreo.stmt_block) =
  Ast_locs.extract_stmt_block stmt_block |> Ast_locs.LocSet.elements
;;

let stringify_jsonify_choreo_ast (stmt_block : 'a Choreo.stmt_block) =
  Jsonify_ast.jsonify_choreo_stmt_block stmt_block |> Yojson.Basic.pretty_to_string
;;

let stringify_jsonify_net_ast (stmt_block : 'a Net.stmt_block) =
  Jsonify_ast.jsonify_net_stmt_block stmt_block |> Yojson.Safe.pretty_to_string
;;

let jsonify_choreo_ast out_chan (stmt_block : 'a Choreo.stmt_block) =
  Jsonify_ast.jsonify_choreo_stmt_block stmt_block
  |> Yojson.Basic.pretty_to_channel out_chan
;;

let jsonify_net_ast out_chan (stmt_block : 'a Net.stmt_block) =
  Jsonify_ast.jsonify_net_stmt_block stmt_block |> Yojson.Safe.pretty_to_channel out_chan
;;

let stringify_pprint_choreo_ast (stmt_block : 'a Choreo.stmt_block) =
  Pprint_ast.pprint_choreo_stmt_block Format.str_formatter stmt_block;
  Format.flush_str_formatter ()
;;

let stringify_pprint_net_ast (stmt_block : 'a Net.stmt_block) =
  Pprint_ast.pprint_net_stmt_block Format.str_formatter stmt_block;
  Format.flush_str_formatter ()
;;

let pprint_choreo_ast out_chan (stmt_block : 'a Choreo.stmt_block) =
  let ppf = Format.formatter_of_out_channel out_chan in
  Pprint_ast.pprint_choreo_stmt_block ppf stmt_block;
  Format.pp_print_newline ppf ()
;;

let pprint_net_ast out_chan (stmt_block : 'a Net.stmt_block) =
  let ppf = Format.formatter_of_out_channel out_chan in
  Pprint_ast.pprint_net_stmt_block ppf stmt_block;
  Format.pp_print_newline ppf ()
;;

let stringify_dot_choreo_ast (string_of_info : 'a -> string) program =
  Dot_ast.generate_dot_code string_of_info program
;;

let dot_choreo_ast
      out_chan
      (string_of_info : 'a -> string)
      (stmt_block : 'a Choreo.stmt_block)
  =
  let dot_code = stringify_dot_choreo_ast string_of_info stmt_block in
  output_string out_chan dot_code;
  flush out_chan
;;

(* FFI (Foreign Function Interface) utilities *)

(* Extract the package name, submodule(s)/function name, and search path from a foreign
   declaration string *)
let parse_external_name name =
  let rest, search_path =
    match String.split_on_char '@' name with
    | [ rest; search_path ] -> rest, Some search_path
    | [ rest ] -> rest, None
    | _ -> failwith "Impossible Failure"
  in
  let package_name, function_name =
    match String.split_on_char ':' rest with
    | [ pack; submods_func ] when pack <> "" && submods_func <> "" ->
      Some pack, submods_func
    | [ submods_func ] when submods_func <> "" -> None, submods_func
    | _ ->
      failwith
        "Invalid external function format. Expected \
         [Package:][Submodule.]function[@searchpath]"
  in
  package_name, function_name, search_path
;;

(* Extract all unique FFI information from a list of statements *)
let collect_ffi_info stmts =
  let rec collect acc = function
    | [] -> acc
    | Choreo.ForeignDecl (_, _, external_name, _) :: rest ->
      let acc' = parse_external_name external_name :: acc in
      collect acc' rest
    | _ :: rest -> collect acc rest
  in
  List.sort_uniq
    (fun (a, b, c) (a', b', c') ->
       match a, a' with
       | Some a, Some a' ->
         (match String.compare a a' with
          | 0 ->
            (match String.compare b b' with
             | 0 ->
               (match c, c' with
                | Some c, Some c' -> String.compare c c'
                | Some _, None -> 1
                | None, Some _ -> -1
                | None, None -> 0)
             | n -> n)
          | n -> n)
       | Some _, None -> 1
       | None, Some _ -> -1
       | None, None -> 0)
    (collect [] stmts)
;;

let ast_local_value_info_map
  : ('a -> 'b) -> 'a Ast_core.Local.M.value -> 'b Ast_core.Local.M.value
  =
  fun map -> function
  | Int (i, metadata) -> Int (i, map metadata)
  | String (str, metadata) -> String (str, map metadata)
  | Bool (b, metadata) -> Bool (b, map metadata)
;;

let ast_local_unop_info_map
  : ('a -> 'b) -> 'a Ast_core.Local.M.un_op -> 'b Ast_core.Local.M.un_op
  =
  fun map -> function
  | Not metadata -> Not (map metadata)
  | Neg metadata -> Neg (map metadata)
;;

let ast_local_binop_info_map
  : ('a -> 'b) -> 'a Ast_core.Local.M.bin_op -> 'b Ast_core.Local.M.bin_op
  =
  fun map -> function
  | Plus metadata -> Plus (map metadata)
  | Minus metadata -> Minus (map metadata)
  | Times metadata -> Times (map metadata)
  | Div metadata -> Div (map metadata)
  | And metadata -> And (map metadata)
  | Or metadata -> Or (map metadata)
  | Eq metadata -> Eq (map metadata)
  | Neq metadata -> Neq (map metadata)
  | Lt metadata -> Lt (map metadata)
  | Leq metadata -> Leq (map metadata)
  | Gt metadata -> Gt (map metadata)
  | Geq metadata -> Geq (map metadata)
;;

let rec ast_local_pattern_info_map
  : ('a -> 'b) -> 'a Ast_core.Local.M.pattern -> 'b Ast_core.Local.M.pattern
  =
  fun map -> function
  | Default metadata -> Default (map metadata)
  | Val (value, metadata) -> Val (ast_local_value_info_map map value, map metadata)
  | Var (VarId (var_name, var_metadata), metadata) ->
    Var (VarId (var_name, map var_metadata), map metadata)
  | Pair (pattern1, pattern2, metadata) ->
    Pair
      ( ast_local_pattern_info_map map pattern1
      , ast_local_pattern_info_map map pattern2
      , map metadata )
  | Left (pattern, metadata) -> Left (ast_local_pattern_info_map map pattern, map metadata)
  | Right (pattern, metadata) ->
    Right (ast_local_pattern_info_map map pattern, map metadata)
;;

let ast_local_loc_id
  : ('a -> 'b) -> 'a Ast_core.Local.M.loc_id -> 'b Ast_core.Local.M.loc_id
  =
  fun map -> function
  | LocId (local_id_name, local_id_metadata) ->
    LocId (local_id_name, map local_id_metadata)
;;

let rec ast_local_type_info_map
  : ('a -> 'b) -> 'a Ast_core.Local.M.typ -> 'b Ast_core.Local.M.typ
  =
  fun map -> function
  | TUnit metadata -> TUnit (map metadata)
  | TInt metadata -> TInt (map metadata)
  | TString metadata -> TString (map metadata)
  | TBool metadata -> TBool (map metadata)
  | TVar (TypId (typ_name, type_metadata), metadata) ->
    TVar (TypId (typ_name, map type_metadata), map metadata)
  | TProd (typ1, typ2, metadata) ->
    TProd
      (ast_local_type_info_map map typ1, ast_local_type_info_map map typ2, map metadata)
  | TSum (typ1, typ2, metadata) ->
    TSum (ast_local_type_info_map map typ1, ast_local_type_info_map map typ2, map metadata)
;;

let rec info_map_pattern_match
  :  ('a -> 'b)
  -> ('a Ast_core.Local.M.pattern * 'a Ast_core.Local.M.expr) list
  -> ('b Ast_core.Local.M.pattern * 'b Ast_core.Local.M.expr) list
  =
  fun map -> function
  | [] -> []
  | (pattern, expr) :: d ->
    (ast_local_pattern_info_map map pattern, ast_local_expr_info_map map expr)
    :: info_map_pattern_match map d

and ast_local_expr_info_map
  : ('a -> 'b) -> 'a Ast_core.Local.M.expr -> 'b Ast_core.Local.M.expr
  =
  fun map -> function
  | Unit metadata -> Unit (map metadata)
  | Val (value, metadata) -> Val (ast_local_value_info_map map value, map metadata)
  | Var (VarId (var_name, var_metadata), metadata) ->
    Var (VarId (var_name, map var_metadata), map metadata)
  | UnOp (un_op, expr, metadata) ->
    UnOp
      (ast_local_unop_info_map map un_op, ast_local_expr_info_map map expr, map metadata)
  | BinOp (expr, bin_op, expr2, metadata) ->
    BinOp
      ( ast_local_expr_info_map map expr
      , ast_local_binop_info_map map bin_op
      , ast_local_expr_info_map map expr2
      , map metadata )
  | Let (VarId (var_name, var_metadata), typ, expr1, expr2, metadata) ->
    Let
      ( VarId (var_name, map var_metadata)
      , ast_local_type_info_map map typ
      , ast_local_expr_info_map map expr1
      , ast_local_expr_info_map map expr2
      , map metadata )
  | Pair (expr1, expr2, metadata) ->
    Pair
      (ast_local_expr_info_map map expr1, ast_local_expr_info_map map expr2, map metadata)
  | Fst (expr, metadata) -> Fst (ast_local_expr_info_map map expr, map metadata)
  | Snd (expr, metadata) -> Snd (ast_local_expr_info_map map expr, map metadata)
  | Left (expr, metadata) -> Left (ast_local_expr_info_map map expr, map metadata)
  | Right (expr, metadata) -> Right (ast_local_expr_info_map map expr, map metadata)
  | Match (expr, patterns, metadata) ->
    Match
      (ast_local_expr_info_map map expr, info_map_pattern_match map patterns, map metadata)
;;

let rec ast_choreo_type_info_map
  : ('a -> 'b) -> 'a Ast_core.Choreo.M.typ -> 'b Ast_core.Choreo.M.typ
  =
  fun map -> function
  | TUnit metadata -> TUnit (map metadata)
  | TLoc (loc_id, local_typ, metadata) ->
    TLoc (ast_local_loc_id map loc_id, ast_local_type_info_map map local_typ, map metadata)
  | TVar (Typ_Id (type_name, type_metadata), metadata) ->
    TVar (Typ_Id (type_name, map type_metadata), map metadata)
  | TMap (typ1, typ2, metadata) ->
    TMap
      (ast_choreo_type_info_map map typ1, ast_choreo_type_info_map map typ2, map metadata)
  | TProd (typ1, typ2, metadata) ->
    TProd
      (ast_choreo_type_info_map map typ1, ast_choreo_type_info_map map typ2, map metadata)
  | TSum (typ1, typ2, metadata) ->
    TSum
      (ast_choreo_type_info_map map typ1, ast_choreo_type_info_map map typ2, map metadata)
;;

let rec ast_choreo_pattern_info_map
  : ('a -> 'b) -> 'a Ast_core.Choreo.M.pattern -> 'b Ast_core.Choreo.M.pattern
  =
  fun map -> function
  | Default metadata -> Default (map metadata)
  | Var (VarId (name, var_metadata), metadata) ->
    Var (VarId (name, map var_metadata), map metadata)
  | Pair (pattern1, pattern2, metadata) ->
    Pair
      ( ast_choreo_pattern_info_map map pattern1
      , ast_choreo_pattern_info_map map pattern2
      , map metadata )
  | LocPat (loc_id, local_pattern, metadata) ->
    LocPat
      ( ast_local_loc_id map loc_id
      , ast_local_pattern_info_map map local_pattern
      , map metadata )
  | Left (choreo_pattern, metadata) ->
    Left (ast_choreo_pattern_info_map map choreo_pattern, map metadata)
  | Right (choreo_pattern, metadata) ->
    Right (ast_choreo_pattern_info_map map choreo_pattern, map metadata)
;;

let rec ast_choreo_pattern_list_info_map
  : ('a -> 'b) -> 'a Ast_core.Choreo.M.pattern list -> 'b Ast_core.Choreo.M.pattern list
  =
  fun map -> function
  | [] -> []
  | h :: d -> ast_choreo_pattern_info_map map h :: ast_choreo_pattern_list_info_map map d
;;

let rec info_map_pattern_match
  :  ('a -> 'b)
  -> ('a Ast_core.Choreo.M.pattern * 'a Ast_core.Choreo.M.expr) list
  -> ('b Ast_core.Choreo.M.pattern * 'b Ast_core.Choreo.M.expr) list
  =
  fun map -> function
  | [] -> []
  | (pattern, expr) :: d ->
    (ast_choreo_pattern_info_map map pattern, ast_choreo_expr_info_map map expr)
    :: info_map_pattern_match map d

and ast_choreo_expr_info_map
  : ('a -> 'b) -> 'a Ast_core.Choreo.M.expr -> 'b Ast_core.Choreo.M.expr
  =
  fun (map : 'a -> 'b) -> function
  | Unit metadata -> Unit (map metadata)
  | Var (VarId (name, var_metadata), metadata) ->
    Var (VarId (name, map var_metadata), map metadata)
  | LocExpr (loc_id, local_expr, metadata) ->
    LocExpr
      (ast_local_loc_id map loc_id, ast_local_expr_info_map map local_expr, map metadata)
  | Send (loc_id, expr, loc_id2, metadata) ->
    Send
      ( ast_local_loc_id map loc_id
      , ast_choreo_expr_info_map map expr
      , ast_local_loc_id map loc_id2
      , map metadata )
  | Sync (loc_id, LabelId (sync_label_name, sync_metadata), loc_id2, expr, metadata) ->
    Sync
      ( ast_local_loc_id map loc_id
      , LabelId (sync_label_name, map sync_metadata)
      , ast_local_loc_id map loc_id2
      , ast_choreo_expr_info_map map expr
      , map metadata )
  | If (expr1, expr2, expr3, metadata) ->
    If
      ( ast_choreo_expr_info_map map expr1
      , ast_choreo_expr_info_map map expr2
      , ast_choreo_expr_info_map map expr3
      , map metadata )
  | Let (stmt_block, expr, metadata) ->
    Let (ast_list_info_map map stmt_block, ast_choreo_expr_info_map map expr, map metadata)
  | FunDef (pattern_list, expr, metadata) ->
    FunDef
      ( ast_choreo_pattern_list_info_map map pattern_list
      , ast_choreo_expr_info_map map expr
      , map metadata )
  | FunApp (expr1, expr2, metadata) ->
    FunApp
      ( ast_choreo_expr_info_map map expr1
      , ast_choreo_expr_info_map map expr2
      , map metadata )
  | Pair (expr1, expr2, metadata) ->
    Pair
      ( ast_choreo_expr_info_map map expr1
      , ast_choreo_expr_info_map map expr2
      , map metadata )
  | Fst (expr, metadata) -> Fst (ast_choreo_expr_info_map map expr, map metadata)
  | Snd (expr, metadata) -> Snd (ast_choreo_expr_info_map map expr, map metadata)
  | Left (expr, metadata) -> Left (ast_choreo_expr_info_map map expr, map metadata)
  | Right (expr, metadata) -> Right (ast_choreo_expr_info_map map expr, map metadata)
  | Match (expr, patterns, metadata) ->
    Match
      ( ast_choreo_expr_info_map map expr
      , info_map_pattern_match map patterns
      , map metadata )

and ast_info_map : ('a -> 'b) -> 'a Ast_core.Choreo.M.stmt -> 'b Ast_core.Choreo.M.stmt =
  fun map -> function
  | Decl (stm_pattern, stmt_type, metadata) ->
    Decl
      ( ast_choreo_pattern_info_map map stm_pattern
      , ast_choreo_type_info_map map stmt_type
      , map metadata )
  | Assign (stmt_pattern_list, stmt_expr, metadata) ->
    Assign
      ( ast_choreo_pattern_list_info_map map stmt_pattern_list
      , ast_choreo_expr_info_map map stmt_expr
      , map metadata )
  | TypeDecl (TypId (type_name, type_metadata), stmt_type, metadata) ->
    TypeDecl
      ( TypId (type_name, map type_metadata)
      , ast_choreo_type_info_map map stmt_type
      , map metadata )
  | ForeignDecl (VarId (name, meta), stmt_type, stmt_foreign_str, metadata) ->
    ForeignDecl
      ( VarId (name, map meta)
      , ast_choreo_type_info_map map stmt_type
      , stmt_foreign_str
      , map metadata )

and ast_list_info_map
  : ('a -> 'b) -> 'a Ast_core.Choreo.M.stmt_block -> 'b Ast_core.Choreo.M.stmt_block
  =
  fun map -> function
  | [] -> []
  | h :: d -> ast_info_map map h :: ast_list_info_map map d
;;
