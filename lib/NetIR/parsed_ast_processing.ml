module M = Ast.PosInfo_AST

(*
  The reason we are postprocessing is because there is no way to distinguish between
  constructorPat and VarPat. They are both just normal strings, since we don't require
  constructors to be capitalized. Thus, when parsing everything is parsed as a VarPat.

  However, every variant must be declared, so we know what names constructors will have.
  So we collect all of those with decl_collect, find every VarPat that shares that name,
  and replace them with ConstructorPat. Doing this allows us to leave constructor names
  unrestricted.
*)

let rec replace_pat_constructor names ast =
  let recurse = replace_pat_constructor names in
  match ast with
  | M.VarPat (m1, (m2, name)) -> 
    if List.mem name names then
      M.ConstructorPat (m1, (m2, name), [])
    else
      M.VarPat (m1, (m2, name))
  | M.ConstructorPat (m, name, ps) -> M.ConstructorPat (m, name, List.map recurse ps)
  | x -> x

let rec replace_expr_constructor names (ast : M.expr) : M.expr =
  let recurse = replace_expr_constructor names in
  match ast with
  | Match (m, e, ps_and_es) -> 
    Match (m, recurse e, (List.map (fun (p, e) -> ((replace_pat_constructor names p), recurse e)) ps_and_es))
  | RecAbs (m, id1, id2, e) -> RecAbs (m, id1, id2, recurse e)
  | FunApp (m, e1, e2) -> FunApp (m, recurse e1, recurse e2)
  | TypeConstr (m, e, t) -> TypeConstr (m, recurse e, t)
  | Unop (m, op, e) -> Unop (m, op, recurse e)
  | Binop (m, op, e1, e2) -> Binop (m, op, recurse e1, recurse e2)
  | Send (m, e, id) -> Send (m, recurse e, id)
  | AllowChoice (m, id, ls_and_es) -> AllowChoice (m, id, List.map (fun (l, e) -> (l, recurse e)) ls_and_es)
  | AmI (m, e) -> AmI (m, recurse e)
  | x -> x (* Any expression that doesn't itself contain an expression needs no processing.*)

let replace_decl_constructor names ast = match ast with
  | M.DefnDecl (m, name, ps, e) -> 
    M.DefnDecl (m, name, List.map (replace_pat_constructor names) ps, replace_expr_constructor names e)
  | x -> x

let decl_collect = function
  | M.VariantDecl (_, _, var_decls) -> 
    List.fold_left (fun acc ((_, name), _, _) -> name :: acc) [] var_decls
  | _ -> []

let process_parsed_ast (ast : M.decl list) =
  let constructor_names = List.fold_left (fun acc y -> (decl_collect y) @ acc) [] ast in
    List.map (replace_decl_constructor constructor_names) ast
