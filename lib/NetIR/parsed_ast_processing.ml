module M = Ast.PosInfo_AST

(*
  The reason we are postprocessing is because there is no way to distinguish between
  constructors and variables. Since we don't require constructors to be capitalized,
  both appread to the lexer as normal strings. Thus, when parsing everything is parsed 
  as a VarPat, or Var. Notably, this issue is present with ConstructorLit, and 
  ConstructorPat, so we have to handle both here.

  However, every variant must be declared, so we know what names constructors will have.
  So we collect all of those with decl_collect, find every VarPat and that shares that name,
  and replace them with ConstructorPat. We pull the same truck for ConstructorLits that take no
  arguments. ConstructorLits that do take arguments have to be handled slighty differently. 
  
  To the lexer, ConstructorLits with arguments appear to be FunApps, so we have to match on those
  nodes, check the name, and then collect all the proceeding arguemnts by "unrolling" the FunApp
  chain. We put them all in a list, and then our AST is finally in the form we want.
  
  Doing all of this allows us to keep constructor names unrestricted.
*)

let rec replace_pat_constructor constructor_names ast =
  let recurse = replace_pat_constructor constructor_names in
  match ast with
  | M.VarPat (m1, (m2, name)) ->
      if List.mem name constructor_names then
        M.ConstructorPat (m1, (m2, name), [])
      else M.VarPat (m1, (m2, name))
  | M.ConstructorPat (m, name, ps) ->
      M.ConstructorPat (m, name, List.map recurse ps)
  | x -> x

(* Here we only need to unroll the second argument, because our functions have
  left precedence. *)
let rec unroll_function = function
  | M.FunApp (_, e1, e2) -> e1 :: unroll_function e2
  | x -> [ x ]

let rec replace_expr_constructor constructor_names (ast : M.expr) : M.expr =
  let recurse = replace_expr_constructor constructor_names in
  match ast with
  | Match (m, e, ps_and_es) ->
      Match
        ( m,
          recurse e,
          List.map
            (fun (p, e) ->
              (replace_pat_constructor constructor_names p, recurse e))
            ps_and_es )
      (* Match is the only expression that contains a pattern, so we only need to process Match nodes. *)
  | RecAbs (m, id1, id2, e) -> RecAbs (m, id1, id2, recurse e)
  | FunApp (m1, Var (m2, (m3, id)), e2) ->
      if List.mem id constructor_names then
        ConstructorLit (m1, (m3, id), unroll_function e2)
      else FunApp (m1, recurse (Var (m2, (m3, id))), recurse e2)
  | FunApp (m, e1, e2) ->
      FunApp (m, recurse e1, recurse e2)
      (* While all FunApps should have their first argument be a Var or RecAbs node, this
      is not the right place to handle that, so we have this "catch-all" clause to pass
      them through. *)
  | TypeConstr (m, e, t) -> TypeConstr (m, recurse e, t)
  | Unop (m, op, e) -> Unop (m, op, recurse e)
  | Binop (m, op, e1, e2) -> Binop (m, op, recurse e1, recurse e2)
  | Send (m, e, id) -> Send (m, recurse e, id)
  | AllowChoice (m, id, ls_and_es) ->
      AllowChoice (m, id, List.map (fun (l, e) -> (l, recurse e)) ls_and_es)
  | AmI (m, e) -> AmI (m, recurse e)
  | Var (m1, (m2, id)) ->
      if List.mem id constructor_names then ConstructorLit (m1, (m2, id), [])
      else Var (m1, (m2, id))
  | x -> x
(* Any expression that doesn't itself contain an expression needs no processing.*)

let replace_decl_constructor constructor_names ast =
  match ast with
  | M.DefnDecl (m, name, ps, e) ->
      M.DefnDecl
        ( m,
          name,
          List.map (replace_pat_constructor constructor_names) ps,
          replace_expr_constructor constructor_names e )
  | x -> x
(* DefnDecls are the only decl nodes that contain patterns and expressions. We are only modifying patterns and expression
      (as expressions can contain patterns), so we return all other nodes unchanged. *)

let decl_collect = function
  | M.VariantDecl (_, _, var_decls) ->
      List.fold_left (fun acc ((_, name), _, _) -> name :: acc) [] var_decls
  | _ -> []

let process_parsed_ast (ast : M.decl list) =
  let constructor_names =
    List.fold_left (fun acc y -> decl_collect y @ acc) [] ast
  in
  List.map (replace_decl_constructor constructor_names) ast
