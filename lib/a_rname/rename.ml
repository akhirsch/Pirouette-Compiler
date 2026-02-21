let suffix = "_PIROUETTE_ID"

let rec ast_local_pattern_alpha_rename :
    'a Ast_core.Local.M.pattern -> 'a Ast_core.Local.M.pattern = function
  | Default metadata -> Default metadata
  | Val (value, metadata) -> Val (value, metadata)
  | Var (VarId (var_name, var_metadata), metadata) ->
      Var (VarId (var_name ^ suffix, var_metadata), metadata)
  | Pair (pattern1, pattern2, metadata) ->
      Pair
        ( ast_local_pattern_alpha_rename pattern1,
          ast_local_pattern_alpha_rename pattern2,
          metadata )
  | Left (pattern, metadata) ->
      Left (ast_local_pattern_alpha_rename pattern, metadata)
  | Right (pattern, metadata) ->
      Right (ast_local_pattern_alpha_rename pattern, metadata)

let ast_local_loc_id : 'a Ast_core.Local.M.loc_id -> 'a Ast_core.Local.M.loc_id
    = function
  | LocId (local_id_name, local_id_metadata) ->
      LocId (local_id_name, local_id_metadata)

let rec ast_local_type_alpha_rename :
    'a Ast_core.Local.M.typ -> 'a Ast_core.Local.M.typ = function
  | TUnit metadata -> TUnit metadata
  | TInt metadata -> TInt metadata
  | TString metadata -> TString metadata
  | TBool metadata -> TBool metadata
  | TVar (TypId (typ_name, tpye_metadata), metadata) ->
      TVar (TypId (typ_name ^ suffix, tpye_metadata), metadata)
  | TProd (typ1, typ2, metadata) ->
      TProd
        ( ast_local_type_alpha_rename typ1,
          ast_local_type_alpha_rename typ2,
          metadata )
  | TSum (typ1, typ2, metadata) ->
      TSum
        ( ast_local_type_alpha_rename typ1,
          ast_local_type_alpha_rename typ2,
          metadata )

let rec alpha_rename_pattern_match :
    ('a Ast_core.Local.M.pattern * 'a Ast_core.Local.M.expr) list ->
    ('a Ast_core.Local.M.pattern * 'a Ast_core.Local.M.expr) list = function
  | [] -> []
  | (pattern, expr) :: d ->
      (ast_local_pattern_alpha_rename pattern, ast_local_expr_alpha_rename expr)
      :: alpha_rename_pattern_match d

and ast_local_expr_alpha_rename :
    'a Ast_core.Local.M.expr -> 'a Ast_core.Local.M.expr = function
  | Unit metadata -> Unit metadata
  | Val (value, metadata) -> Val (value, metadata)
  | Var (VarId (var_name, var_metadata), metadata) ->
      Var (VarId (var_name ^ suffix, var_metadata), metadata)
  | UnOp (un_op, expr, metadata) ->
      UnOp (un_op, ast_local_expr_alpha_rename expr, metadata)
  | BinOp (expr, bin_op, expr2, metadata) ->
      BinOp
        ( ast_local_expr_alpha_rename expr,
          bin_op,
          ast_local_expr_alpha_rename expr2,
          metadata )
  | Let (VarId (var_name, var_metadata), typ, expr1, expr2, metadata) ->
      Let
        ( VarId (var_name ^ suffix, var_metadata),
          ast_local_type_alpha_rename typ,
          ast_local_expr_alpha_rename expr1,
          ast_local_expr_alpha_rename expr2,
          metadata )
  | Pair (expr1, expr2, metadata) ->
      Pair
        ( ast_local_expr_alpha_rename expr1,
          ast_local_expr_alpha_rename expr2,
          metadata )
  | Fst (expr, metadata) -> Fst (ast_local_expr_alpha_rename expr, metadata)
  | Snd (expr, metadata) -> Snd (ast_local_expr_alpha_rename expr, metadata)
  | Left (expr, metadata) -> Left (ast_local_expr_alpha_rename expr, metadata)
  | Right (expr, metadata) -> Right (ast_local_expr_alpha_rename expr, metadata)
  | Match (expr, patterns, metadata) ->
      Match
        ( ast_local_expr_alpha_rename expr,
          alpha_rename_pattern_match patterns,
          metadata )

let rec ast_choreo_type_alpha_rename :
    'a Ast_core.Choreo.M.typ -> 'a Ast_core.Choreo.M.typ = function
  | TUnit metadata -> TUnit metadata
  | TLoc (loc_id, local_typ, metadata) ->
      TLoc
        ( ast_local_loc_id loc_id,
          ast_local_type_alpha_rename local_typ,
          metadata )
  | TVar (Typ_Id (type_name, type_metadata), metadata) ->
      TVar (Typ_Id (type_name ^ suffix, type_metadata), metadata)
  | TMap (typ1, typ2, metadata) ->
      TMap
        ( ast_choreo_type_alpha_rename typ1,
          ast_choreo_type_alpha_rename typ2,
          metadata )
  | TProd (typ1, typ2, metadata) ->
      TProd
        ( ast_choreo_type_alpha_rename typ1,
          ast_choreo_type_alpha_rename typ2,
          metadata )
  | TSum (typ1, typ2, metadata) ->
      TSum
        ( ast_choreo_type_alpha_rename typ1,
          ast_choreo_type_alpha_rename typ2,
          metadata )

let rec ast_choreo_pattern_alpha_rename :
    'a Ast_core.Choreo.M.pattern -> 'a Ast_core.Choreo.M.pattern = function
  | Default metadata -> Default metadata
  | Var (VarId (name, var_metadata), metadata) ->
      Var (VarId (name ^ suffix, var_metadata), metadata)
  | Pair (pattern1, pattern2, metadata) ->
      Pair
        ( ast_choreo_pattern_alpha_rename pattern1,
          ast_choreo_pattern_alpha_rename pattern2,
          metadata )
  | LocPat (loc_id, local_pattern, metadata) ->
      LocPat
        ( ast_local_loc_id loc_id,
          ast_local_pattern_alpha_rename local_pattern,
          metadata )
  | Left (choreo_pattern, metadata) ->
      Left (ast_choreo_pattern_alpha_rename choreo_pattern, metadata)
  | Right (choreo_pattern, metadata) ->
      Right (ast_choreo_pattern_alpha_rename choreo_pattern, metadata)

let rec ast_choreo_pattern_list_alpha_rename :
    'a Ast_core.Choreo.M.pattern list -> 'a Ast_core.Choreo.M.pattern list =
  function
  | [] -> []
  | h :: d ->
      ast_choreo_pattern_alpha_rename h
      :: ast_choreo_pattern_list_alpha_rename d

let rec alpha_rename_pattern_match :
    ('a Ast_core.Choreo.M.pattern * 'a Ast_core.Choreo.M.expr) list ->
    ('a Ast_core.Choreo.M.pattern * 'a Ast_core.Choreo.M.expr) list = function
  | [] -> []
  | (pattern, expr) :: d ->
      ( ast_choreo_pattern_alpha_rename pattern,
        ast_choreo_expr_alpha_rename expr )
      :: alpha_rename_pattern_match d

and ast_choreo_expr_alpha_rename :
    'a Ast_core.Choreo.M.expr -> 'a Ast_core.Choreo.M.expr = function
  | Unit metadata -> Unit metadata
  | Var (VarId (name, var_metadata), metadata) ->
      Var (VarId (name ^ suffix, var_metadata), metadata)
  | LocExpr (loc_id, local_expr, metadata) ->
      LocExpr
        ( ast_local_loc_id loc_id,
          ast_local_expr_alpha_rename local_expr,
          metadata )
  | Send (loc_id, expr, loc_id2, metadata) ->
      Send
        ( ast_local_loc_id loc_id,
          ast_choreo_expr_alpha_rename expr,
          ast_local_loc_id loc_id2,
          metadata )
  | Sync
      (loc_id, LabelId (sync_label_name, sync_metadata), loc_id2, expr, metadata)
    ->
      Sync
        ( ast_local_loc_id loc_id,
          LabelId (sync_label_name ^ suffix, sync_metadata),
          ast_local_loc_id loc_id2,
          ast_choreo_expr_alpha_rename expr,
          metadata )
  | If (expr1, expr2, expr3, metadata) ->
      If
        ( ast_choreo_expr_alpha_rename expr1,
          ast_choreo_expr_alpha_rename expr2,
          ast_choreo_expr_alpha_rename expr3,
          metadata )
  | Let (stmt_block, expr, metadata) ->
      Let
        ( ast_list_alpha_rename stmt_block,
          ast_choreo_expr_alpha_rename expr,
          metadata )
  | FunDef (pattern_list, expr, metadata) ->
      FunDef
        ( ast_choreo_pattern_list_alpha_rename pattern_list,
          ast_choreo_expr_alpha_rename expr,
          metadata )
  | FunApp (expr1, expr2, metadata) ->
      FunApp
        ( ast_choreo_expr_alpha_rename expr1,
          ast_choreo_expr_alpha_rename expr2,
          metadata )
  | Pair (expr1, expr2, metadata) ->
      Pair
        ( ast_choreo_expr_alpha_rename expr1,
          ast_choreo_expr_alpha_rename expr2,
          metadata )
  | Fst (expr, metadata) -> Fst (ast_choreo_expr_alpha_rename expr, metadata)
  | Snd (expr, metadata) -> Snd (ast_choreo_expr_alpha_rename expr, metadata)
  | Left (expr, metadata) -> Left (ast_choreo_expr_alpha_rename expr, metadata)
  | Right (expr, metadata) -> Right (ast_choreo_expr_alpha_rename expr, metadata)
  | Match (expr, patterns, metadata) ->
      Match
        ( ast_choreo_expr_alpha_rename expr,
          alpha_rename_pattern_match patterns,
          metadata )

and ast_alpha_rename : 'a Ast_core.Choreo.M.stmt -> 'a Ast_core.Choreo.M.stmt =
  function
  | Decl (stm_pattern, stmt_type, metadata) ->
      Decl
        ( ast_choreo_pattern_alpha_rename stm_pattern,
          ast_choreo_type_alpha_rename stmt_type,
          metadata )
  | Assign (stmt_pattern_list, stmt_expr, metadata) ->
      Assign
        ( ast_choreo_pattern_list_alpha_rename stmt_pattern_list,
          ast_choreo_expr_alpha_rename stmt_expr,
          metadata )
  | TypeDecl (TypId (type_name, type_metadata), stmt_type, metadata) ->
      TypeDecl
        ( TypId (type_name ^ suffix, type_metadata),
          ast_choreo_type_alpha_rename stmt_type,
          metadata )
  | ForeignDecl (VarId (name, meta), stmt_type, stmt_foreign_str, metadata) ->
      ForeignDecl
        ( VarId (name ^ suffix, meta),
          ast_choreo_type_alpha_rename stmt_type,
          stmt_foreign_str,
          metadata )

and ast_list_alpha_rename :
    'a Ast_core.Choreo.M.stmt_block -> 'a Ast_core.Choreo.M.stmt_block =
  function
  | [] -> []
  | h :: d -> ast_alpha_rename h :: ast_list_alpha_rename d
