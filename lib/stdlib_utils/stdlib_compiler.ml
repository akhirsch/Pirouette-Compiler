let ast_local_value_stringify : 'a Ast_core.Local.M.value -> string = function
  | Int (i, _) -> "(Int (" ^ string_of_int i ^ ", ()))"
  | String (str, _) -> "(String (\"" ^ str ^ "\", ()))"
  | Bool (b, _) -> "(Bool (" ^ string_of_bool b ^ ", ()))"
;;

let rec ast_local_pattern_stringify : 'a Ast_core.Local.M.pattern -> string = function
  | Default _ -> "(Default ())"
  | Val (value, _) -> "(Val (" ^ ast_local_value_stringify value ^ ", ()))"
  | Var (VarId (var_name, _), _) -> "(Var (VarId (\"" ^ var_name ^ "\",  ^ ()), ()))"
  | Pair (pattern1, pattern2, _) -> "(Pair (" ^ ast_local_pattern_stringify pattern1 ^ ", " ^ ast_local_pattern_stringify pattern2 ^ ", ()))"
  | Left (pattern, _) -> "Left (" ^ ast_local_pattern_stringify pattern ^ ", ())"
  | Right (pattern, _) -> "(Right (" ^ ast_local_pattern_stringify pattern ^ ", ()))"
;;

let ast_local_loc_id : 'a Ast_core.Local.M.loc_id -> string = function
  | LocId (local_id_name, _) -> "(LocId (\"" ^ local_id_name ^ "\", ()))"

let rec ast_local_type_stringify : 'a Ast_core.Local.M.typ -> string = function
  | TUnit _ -> "(TUnit ())"
  | TInt _ -> "(TInt ())"
  | TString _ -> "(TString ())"
  | TBool _ -> "(TBool ())"
  | TVar (TypId (typ_name, _), _) -> "(TVar (TypId (\"" ^ typ_name ^ "\", ()), ()))"
  | TProd (typ1, typ2, _) -> "(TProd (" ^ ast_local_type_stringify typ1 ^ ", " ^ ast_local_type_stringify typ2 ^ ", ()))"
  | TSum  (typ1, typ2, _) -> "(TSum (" ^ ast_local_type_stringify typ1 ^ ", " ^ ast_local_type_stringify typ2 ^ ", ()))"
  | TForeign (TypId (typ_name, _), _) -> "(TForeign (TypId (\"" ^ typ_name ^ "\", ()), ()))"
;;

let ast_local_bin_op_stringify : 'a Ast_core.Local.M.bin_op -> string = function
  | Plus _ -> "(Plus ())"
  | Minus _ -> "(Minus ())"
  | Times _ -> "(Times ())"
  | Div _ -> "(Div ())"
  | And _ -> "(And ())"
  | Or _ -> "(Or ())"
  | Eq _ -> "(Eq ())"
  | Neq _ -> "(Neq ())"
  | Lt _ -> "(Lt ())"
  | Leq _ -> "(Leq ())"
  | Gt _ -> "(Gt ())"
  | Geq _ -> "(Geq ())"
;;

let ast_local_un_op_stringify : 'a Ast_core.Local.M.un_op -> string = function
  | Not _ -> "(Not ())"
  | Neg _-> "(Neg ())"
;;

let rec stringify_pattern_match : ('a Ast_core.Local.M.pattern * 'a Ast_core.Local.M.expr) list -> string = function 
  | [] -> "[]"
  | (pattern, expr) :: d -> "((" ^ ast_local_pattern_stringify pattern ^ ", " ^ ast_local_expr_stringify expr ^ ") :: (" ^ stringify_pattern_match d ^ "))"

and ast_local_expr_stringify : 'a Ast_core.Local.M.expr -> string = function
  | Unit _ -> "(Unit ())"
  | Val (value, _) -> "(Val (" ^ ast_local_value_stringify value ^ ", ()))"
  | Var (VarId (var_name, _), _) -> "(Var (VarId (\"" ^ var_name ^ "\", ()), ()))"
  | UnOp (un_op, expr, _) -> "(UnOp (" ^ ast_local_un_op_stringify un_op ^ ", " ^ ast_local_expr_stringify expr ^ ", ()))"
  | BinOp (expr, bin_op,expr2, _) -> "(BinOp (" ^ ast_local_expr_stringify expr ^ ", " ^ ast_local_bin_op_stringify bin_op ^ ", " ^ ast_local_expr_stringify expr2 ^ ", ()))"
  | Let (VarId (var_name, _), typ, expr1, expr2, _) -> "(Let (VarId (\"" ^ var_name ^ "\", ()), " ^ ast_local_type_stringify typ ^ ", " ^ ast_local_expr_stringify expr1 ^ ", " ^ ast_local_expr_stringify expr2 ^ ", ()))"
  | Pair (expr1, expr2, _) -> "(Pair (" ^ ast_local_expr_stringify expr1 ^ ", " ^ ast_local_expr_stringify expr2 ^ ", ()))"
  | Fst (expr, _) -> "(Fst (" ^ ast_local_expr_stringify expr ^ ", ()))"
  | Snd (expr, _) -> "(Snd (" ^ ast_local_expr_stringify expr ^ ", ()))"
  | Left (expr, _) -> "(Left (" ^ ast_local_expr_stringify expr ^ ", ()))"
  | Right (expr, _) -> "(Right (" ^ ast_local_expr_stringify expr ^ ", ()))"
  | Match (expr,patterns, _) -> "(Match (" ^ ast_local_expr_stringify expr ^ ", " ^ stringify_pattern_match patterns ^ ", ()))"
;;

let rec ast_choreo_type_stringify : 'a Ast_core.Choreo.M.typ -> string = function
  | TUnit _ ->  "(TUnit ())"
  | TLoc (loc_id, local_typ, _) ->  "(TLoc (" ^ ast_local_loc_id loc_id ^ ", " ^ ast_local_type_stringify local_typ ^ ", ()))"
  | TVar (Typ_Id (type_name, _), _) ->  "(TVar (Typ_Id (\"" ^ type_name ^ "\", ()), ()))"
  | TMap (typ1, typ2, _) ->  "(TMap (" ^ ast_choreo_type_stringify typ1 ^ ", " ^ ast_choreo_type_stringify typ2 ^ ", ()))"
  | TProd (typ1, typ2, _) ->  "(TProd (" ^ ast_choreo_type_stringify typ1 ^", " ^ ast_choreo_type_stringify typ2 ^" , ()))"
  | TSum (typ1, typ2, _) -> "(TSum (" ^ ast_choreo_type_stringify typ1 ^ ", " ^ ast_choreo_type_stringify typ2 ^ ", ()))"
  | TForeign (Typ_Id (typ_name, _), _) -> "(TForeign (Typ_Id (\"" ^ typ_name ^ "\", ()), ()))"
;;

let rec ast_choreo_pattern_stringify : 'a Ast_core.Choreo.M.pattern -> string = function
  | Default _ -> "(Default ())"
  | Var (VarId (name, _), _) -> "(Var (VarId (\"" ^ name ^ "\", ()), ()))"
  | Pair (pattern1, pattern2, _) -> "(Pair (" ^ ast_choreo_pattern_stringify pattern1 ^", " ^ ast_choreo_pattern_stringify pattern2 ^ ", ()))"
  | LocPat (loc_id, local_pattern, _) -> "(LocPat (" ^ ast_local_loc_id loc_id ^ ", " ^ ast_local_pattern_stringify local_pattern ^", ()))"
  | Left (choreo_pattern, _)-> "(Left (" ^ ast_choreo_pattern_stringify choreo_pattern ^ ", ()))"
  | Right (choreo_pattern,_) -> "(Right (" ^ast_choreo_pattern_stringify choreo_pattern ^ ", ()))"
;;

let rec ast_choreo_pattern_list_stringify : 'a Ast_core.Choreo.M.pattern list -> string = function
  | [] -> "[]"
  | h::d -> "((" ^ ast_choreo_pattern_stringify h ^ ") :: (" ^ ast_choreo_pattern_list_stringify d ^ "))"
;;

let rec stringify_pattern_match : ('a Ast_core.Choreo.M.pattern * 'a Ast_core.Choreo.M.expr) list -> string = function 
  | [] -> "[]"
  | (pattern, expr) ::d -> "((" ^ ast_choreo_pattern_stringify pattern ^ ", " ^ ast_choreo_expr_stringify expr ^") :: (" ^ stringify_pattern_match d ^ "))"

and ast_choreo_expr_stringify : 'a Ast_core.Choreo.M.expr -> string = function
  | Unit _ -> "(Unit ())"
  | Var (VarId (name, _), _) -> "(Var (VarId (\"" ^ name ^"\", ()), ()))"
  | LocExpr (loc_id, local_expr, _) -> "(LocExpr (" ^ ast_local_loc_id loc_id ^ ", " ^ ast_local_expr_stringify local_expr ^ ", ()))"
  | Send (loc_id, expr, loc_id2, _) -> "(Send (" ^ ast_local_loc_id loc_id ^ ", " ^ ast_choreo_expr_stringify expr ^ ", " ^ ast_local_loc_id loc_id2 ^ ", ()))"
  | Sync (loc_id, LabelId (sync_label_name, _), loc_id2, expr, _) -> "(Sync (" ^ ast_local_loc_id loc_id ^ ", LabelId (\"" ^ sync_label_name ^ "\", ()), " ^ ast_local_loc_id loc_id2 ^ ", " ^ ast_choreo_expr_stringify expr ^", ()))"
  | If (expr1, expr2, expr3, _) -> "(If (" ^ ast_choreo_expr_stringify expr1 ^ ", " ^ ast_choreo_expr_stringify expr2 ^ ", " ^ ast_choreo_expr_stringify expr3 ^ ", ()))"
  | Let (stmt_block, expr, _) -> "(Let (" ^ ast_list_stringify stmt_block ^ ", " ^ ast_choreo_expr_stringify expr ^ ", ()))"
  | FunDef (pattern_list, expr, _) -> "(FunDef (" ^ ast_choreo_pattern_list_stringify pattern_list ^ ", " ^ ast_choreo_expr_stringify expr ^ ", ()))"
  | FunApp (expr1, expr2, _) -> "(FunApp (" ^ ast_choreo_expr_stringify expr1 ^ ", " ^ ast_choreo_expr_stringify expr2 ^ ", ()))"
  | Pair (expr1, expr2, _) -> "(Pair (" ^ ast_choreo_expr_stringify expr1 ^ ", " ^ ast_choreo_expr_stringify expr2 ^ ", ()))"
  | Fst (expr, _) -> "(Fst (" ^ ast_choreo_expr_stringify expr ^ ", ()))"
  | Snd (expr, _) -> "(Snd (" ^ ast_choreo_expr_stringify expr ^ ", ()))"
  | Left (expr, _) -> "(Left (" ^ ast_choreo_expr_stringify expr ^ ", ()))"
  | Right (expr, _) -> "(Right (" ^ ast_choreo_expr_stringify expr ^ ", ()))"
  | Match (expr, patterns, _) -> "(Match (" ^ ast_choreo_expr_stringify expr ^ ", " ^ stringify_pattern_match patterns ^ ", ()))"

and ast_stringify : 'a Ast_core.Choreo.M.stmt -> string = function  
  | Decl (stm_pattern, stmt_type, _) -> "(Decl (" ^ ast_choreo_pattern_stringify stm_pattern ^ ", " ^ ast_choreo_type_stringify stmt_type ^ ", ()))"
  | Assign (stmt_pattern_list, stmt_expr, _) -> "(Assign (" ^ ast_choreo_pattern_list_stringify stmt_pattern_list ^ ", " ^ ast_choreo_expr_stringify stmt_expr ^ ", ()))"
  | TypeDecl ((TypId (type_name, _)), stmt_type, _) -> "(TypeDecl (TypId (\"" ^ type_name ^ "\" , ()), " ^ ast_choreo_type_stringify stmt_type ^ ", ()))"
  | ForeignDecl (VarId (name, _), stmt_type, stmt_foreign_str, _) -> "(ForeignDecl (VarId ( \"" ^ name ^"\" , ()), " ^ ast_choreo_type_stringify stmt_type ^ ", \"" ^ stmt_foreign_str ^ "\", ()))"
  | ForeignTypeDecl (TypId (type_name, _), _) -> "(ForeignTypeDecl (TypId (\"" ^ type_name ^ "\", ()), ()))"

and ast_list_stringify : 'a Ast_core.Choreo.M.stmt_block -> string = function
  | [] -> "[]"
  | h::d -> "(" ^ (ast_stringify h) ^ " :: " ^ (ast_list_stringify d) ^ ")"
;;

(* Check if there exists a PIR_STDLIB environment variable on the user's system. If not, print on stderr and exit *)
let compile_stdlib () : unit =
  let (path_to_stdlib:string) = match Sys.getenv_opt "PIR_STDLIB" with
    | Some p ->
        p
    | None ->
        prerr_endline ("Path to Pirouette standard library not set in enviroment variables as \"PIR_STDLIB\"=[ABSOLUTE_PATH_TO_YOUR_STDLIB]\n"); exit 1
  in

  (* Create an OCaml file representation -via opening the file for reading as an in channel- of the path to the standard library file *)
  let file_ic_stlid = open_in path_to_stdlib in

  (* Lex the file *)
  let lexbuf_stdlib = Lexing.from_channel file_ic_stlid in

  (* Return the AST created from the parsed lex *)
  let stdlib_ast = A_rname.Rename.ast_list_alpha_rename (Parsing.Parse.parse_with_error (path_to_stdlib) (lexbuf_stdlib)) in


  (* There must be a stdlib_ast.ml file in the same directory as your stdlib.pir pointed to by your PIR_STDLIB env var*)
  let stdlib_ast_str = ast_list_stringify stdlib_ast in
  let stdlib_ast_file_oc = open_out ((Filename.dirname path_to_stdlib)^Filename.dir_sep^"stdlib_ast.ml") in

  (* We save the Marshalled AST of the stdlib to stdlib_ast.ml, but wrapped within OCaml code that allows us to reference that value *)
  output_string stdlib_ast_file_oc ("open Ast_core.Choreo.M\nopen Ast_core.Local.M\n\nlet ast : 'a Ast_core.Choreo.M.stmt_block = "^ stdlib_ast_str ^ "\n\n;;"); close_out stdlib_ast_file_oc;
;;