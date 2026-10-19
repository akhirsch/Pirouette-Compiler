module MkDotAST (M : sig
  include Metainfo.Meta.Metainfo
end) =
struct
  module AST = Ast.MkAST (M)
  open AST

  let spf = Printf.sprintf

  (*Tracks the number of nodes we've made to generate unique node names*)
  let node_counter = ref 0

  (*Reads the current node counter, increments it, and concatentates it with the node_id to create a node name.*)
  let generate_node_name () =
    let node_id = !node_counter in
    node_counter := !node_counter + 1;
    "n" ^ string_of_int node_id

  let dot_name string_of_info name =
    let node_name = generate_node_name () in
    let info, str = name in
    ( spf "%s [label=\"Name %s %s\"];\n" node_name (String.escaped str)
        (string_of_info info),
      node_name )

  let dot_lab string_of_info (label : lab) =
    let node_name = generate_node_name () in
    match label with
    | Label name ->
        let c, n = dot_name string_of_info name in
        let lab_node = spf "%s [label=\"Label\"];\n" node_name in
        let edge = spf "%s -> %s;\n" node_name n in
        (lab_node ^ edge ^ c, node_name)

  let dot_int int =
    let node_name = generate_node_name () in
    (spf "%s [label=\"Int %s\"];\n" node_name (string_of_int int), node_name)

  let dot_float float =
    let node_name = generate_node_name () in
    ( spf "%s [label=\"Float %s\"];\n" node_name (string_of_float float),
      node_name )

  let dot_char char =
    let node_name = generate_node_name () in
    ( spf "%s [label=\"Char %s\"];\n" node_name
        (String.escaped (String.make 1 char)),
      node_name )

  let dot_string string =
    let node_name = generate_node_name () in
    ( spf "%s [label=\"String %s\"];\n" node_name (String.escaped string),
      node_name )

  let rec dot_pattern string_of_info pat =
    let node_name = generate_node_name () in
    match pat with
    | WildcardPat m ->
        ( spf "%s [label=\"Wildcard Pat %s\"];\n" node_name (string_of_info m),
          node_name )
    | VarPat (m, name) ->
        let c, n = dot_name string_of_info name in
        let pat_node =
          spf "%s [label=\"Var Pat %s\"];\n" node_name (string_of_info m)
        in
        let edge = spf "%s -> %s;\n" node_name n in
        (pat_node ^ edge ^ c, node_name)
    | UnitLitPat m ->
        ( spf "%s [label=\"Unit Lit Pat %s\"];\n" node_name (string_of_info m),
          node_name )
    | IntLitPat (m, int) ->
        let c, n = dot_int int in
        let pat_node =
          spf "%s [label=\"Int Lit Pat %s\"];\n" node_name (string_of_info m)
        in
        let edge = spf "%s -> %s;\n" node_name n in
        (pat_node ^ edge ^ c, node_name)
    | FloatLitPat (m, float) ->
        let c, n = dot_float float in
        let pat_node =
          spf "%s [label=\"Float Lit Pat %s\"];\n" node_name (string_of_info m)
        in
        let edge = spf "%s -> %s;\n" node_name n in
        (pat_node ^ edge ^ c, node_name)
    | CharLitPat (m, char) ->
        let c, n = dot_char char in
        let pat_node =
          spf "%s [label=\"Char Lit Pat %s\"];\n" node_name (string_of_info m)
        in
        let edge = spf "%s -> %s;\n" node_name n in
        (pat_node ^ edge ^ c, node_name)
    | StringLitPat (m, string) ->
        let c, n = dot_string string in
        let pat_node =
          spf "%s [label=\"String Lit Pat %s\"];\n" node_name (string_of_info m)
        in
        let edge = spf "%s -> %s;\n" node_name n in
        (pat_node ^ edge ^ c, node_name)
    | TrueLitPat m ->
        ( spf "%s [label=\"True Lit Pat %s\"];\n" node_name (string_of_info m),
          node_name )
    | FalseLitPat m ->
        ( spf "%s [label=\"False Lit Pat %s\"];\n" node_name (string_of_info m),
          node_name )
    | LocLitPat (m, name) ->
        let c, n = dot_name string_of_info name in
        let pat_node =
          spf "%s [label=\"Loc Lit Pat %s\"];\n" node_name (string_of_info m)
        in
        let edge = spf "%s -> %s;\n" node_name n in
        (pat_node ^ edge ^ c, node_name)
    | ConstructorPat (m, name, patterns) ->
        let c1, n1 = dot_name string_of_info name in
        let pat_codes, node_names =
          List.split (List.map (dot_pattern string_of_info) patterns)
        in
        let pat_node =
          spf "%s [label=\"Constructor Pat %s\"];\n" node_name
            (string_of_info m)
        in
        let edge1 = spf "%s -> %s;\n" node_name n1 in
        let edges =
          String.concat ""
            (List.map (fun name -> spf "%s -> %s;\n" node_name name) node_names)
        in
        let codes = String.concat "" pat_codes in
        (pat_node ^ edge1 ^ edges ^ c1 ^ codes, node_name)
    | LocNamePat (m, name) ->
        let c, n = dot_name string_of_info name in
        let pat_node =
          spf "%s [label=\"Loc Name Pat %s\"];\n" node_name (string_of_info m)
        in
        let edge = spf "%s -> %s;\n" node_name n in
        (pat_node ^ edge ^ c, node_name)

  let dot_unop string_of_info unop =
    let node_name = generate_node_name () in
    match unop with
    | Neg m ->
        (spf "%s [label=\"Neg %s\"];\n" node_name (string_of_info m), node_name)
    | Not m ->
        (spf "%s [label=\"Not %s\"];\n" node_name (string_of_info m), node_name)

  let dot_binop string_of_info binop =
    let node_name = generate_node_name () in
    match binop with
    | Plus m ->
        (spf "%s [label=\"Plus %s\"];\n" node_name (string_of_info m), node_name)
    | Minus m ->
        ( spf "%s [label=\"Minus %s\"];\n" node_name (string_of_info m),
          node_name )
    | Times m ->
        ( spf "%s [label=\"Times %s\"];\n" node_name (string_of_info m),
          node_name )
    | Div m ->
        (spf "%s [label=\"Div %s\"];\n" node_name (string_of_info m), node_name)
    | And m ->
        (spf "%s [label=\"And %s\"];\n" node_name (string_of_info m), node_name)
    | Or m ->
        (spf "%s [label=\"Or %s\"];\n" node_name (string_of_info m), node_name)
    | Eq m ->
        (spf "%s [label=\"Eq %s\"];\n" node_name (string_of_info m), node_name)
    | Neq m ->
        (spf "%s [label=\"Neq %s\"];\n" node_name (string_of_info m), node_name)
    | Lt m ->
        (spf "%s [label=\"Lt %s\"];\n" node_name (string_of_info m), node_name)
    | Leq m ->
        (spf "%s [label=\"Leq %s\"];\n" node_name (string_of_info m), node_name)
    | Gt m ->
        (spf "%s [label=\"Gt %s\"];\n" node_name (string_of_info m), node_name)
    | Geq m ->
        (spf "%s [label=\"Geq %s\"];\n" node_name (string_of_info m), node_name)

  let rec dot_typ string_of_info typ =
    let node_name = generate_node_name () in
    match typ with
    | VarTy (m, name) ->
        let c, n = dot_name string_of_info name in
        let typ_node =
          spf "%s [label=\"Var Type %s\"];\n" node_name (string_of_info m)
        in
        let edge = spf "%s -> %s;\n" node_name n in
        (typ_node ^ edge ^ c, node_name)
    | UnitTy m ->
        ( spf "%s [label=\"Unit Type %s\"];\n" node_name (string_of_info m),
          node_name )
    | IntTy m ->
        ( spf "%s [label=\"Int Type %s\"];\n" node_name (string_of_info m),
          node_name )
    | FloatTy m ->
        ( spf "%s [label=\"Float Type %s\"];\n" node_name (string_of_info m),
          node_name )
    | CharTy m ->
        ( spf "%s [label=\"Char Type %s\"];\n" node_name (string_of_info m),
          node_name )
    | StringTy m ->
        ( spf "%s [label=\"String Type %s\"];\n" node_name (string_of_info m),
          node_name )
    | BoolTy m ->
        ( spf "%s [label=\"Bool Type %s\"];\n" node_name (string_of_info m),
          node_name )
    | FunTy (m, typ1, typ2) ->
        let c1, n1 = dot_typ string_of_info typ1 in
        let c2, n2 = dot_typ string_of_info typ2 in
        let typ_node =
          spf "%s [label=\"Fun Type %s\"];\n" node_name (string_of_info m)
        in
        let edge1 = spf "%s -> %s;\n" node_name n1 in
        let edge2 = spf "%s -> %s;\n" node_name n2 in
        (typ_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name)
    | LocTy (m, names) ->
        let name_codes, node_names =
          List.split (List.map (dot_name string_of_info) names)
        in
        let typ_node =
          spf "%s [label=\"Loc Type %s\"];\n" node_name (string_of_info m)
        in
        let edges =
          String.concat ""
            (List.map (fun name -> spf "%s -> %s;\n" node_name name) node_names)
        in
        let codes = String.concat "" name_codes in
        (typ_node ^ edges ^ codes, node_name)

  let rec dot_expr string_of_info expr =
    let node_name = generate_node_name () in
    match expr with
    | Var (m, name) ->
        let c, n = dot_name string_of_info name in
        let expr_node =
          spf "%s [label=\"Expr %s\"];\n" node_name (string_of_info m)
        in
        let edge = spf "%s -> %s;\n" node_name n in
        (expr_node ^ edge ^ c, node_name)
    | UnitLit m ->
        let expr_node =
          spf "%s [label=\"UnitLit %s\"];\n" node_name (string_of_info m)
        in
        (expr_node, node_name)
    | IntLit (m, int) ->
        let c, n = dot_int int in
        let expr_node =
          spf "%s [label=\"IntLit %s\"];\n" node_name (string_of_info m)
        in
        let edge = spf "%s -> %s;\n" node_name n in
        (expr_node ^ edge ^ c, node_name)
    | FloatLit (m, float) ->
        let c, n = dot_float float in
        let expr_node =
          spf "%s [label=\"FloatLit %s\"];\n" node_name (string_of_info m)
        in
        let edge = spf "%s -> %s;\n" node_name n in
        (expr_node ^ edge ^ c, node_name)
    | CharLit (m, char) ->
        let c, n = dot_char char in
        let expr_node =
          spf "%s [label=\"CharLit %s\"];\n" node_name (string_of_info m)
        in
        let edge = spf "%s -> %s;\n" node_name n in
        (expr_node ^ edge ^ c, node_name)
    | StringLit (m, string) ->
        let c, n = dot_string string in
        let expr_node =
          spf "%s [label=\"StringLit %s\"];\n" node_name (string_of_info m)
        in
        let edge = spf "%s -> %s;\n" node_name n in
        (expr_node ^ edge ^ c, node_name)
    | TrueLit m ->
        let expr_node =
          spf "%s [label=\"TrueLit %s\"];\n" node_name (string_of_info m)
        in
        (expr_node, node_name)
    | FalseLit m ->
        let expr_node =
          spf "%s [label=\"FalseLit %s\"];\n" node_name (string_of_info m)
        in
        (expr_node, node_name)
    | ConstructorLit (m, name, exprs) ->
        let expr_codes, node_names =
          List.split (List.map (dot_expr string_of_info) exprs)
        in
        let c1, n1 = dot_name string_of_info name in
        let match_node =
          spf "%s [label=\"ConstructorLit %s\"];\n" node_name (string_of_info m)
        in
        let edges =
          String.concat ""
            (List.map (fun name -> spf "%s -> %s;\n" node_name name) node_names)
        in
        let codes = String.concat "" expr_codes in
        let edge1 = spf "%s -> %s;\n" node_name n1 in
        (match_node ^ edge1 ^ edges ^ c1 ^ codes, node_name)
    | LocLit (m, name) ->
        let c, n = dot_name string_of_info name in
        let expr_node =
          spf "%s [label=\"LocLit %s\"];\n" node_name (string_of_info m)
        in
        let edge = spf "%s -> %s;\n" node_name n in
        (expr_node ^ edge ^ c, node_name)
    | Match (m, e, cases) ->
        let dot_case string_of_info (pat, expr) =
          let node_name = generate_node_name () in
          let c1, pat_name = dot_pattern string_of_info pat in
          let c2, expr_name = dot_expr string_of_info expr in
          let case_node = spf "%s [label=\"Case\"];\n" node_name in
          let edge1 = spf "%s -> %s;\n" node_name pat_name in
          let edge2 = spf "%s -> %s;\n" node_name expr_name in
          (case_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name)
        in
        let case_codes, case_node_names =
          List.split (List.map (dot_case string_of_info) cases)
        in
        let c1, n1 = dot_expr string_of_info e in
        let match_node =
          spf "%s [label=\"Match %s\"];\n" node_name (string_of_info m)
        in
        let edges =
          String.concat ""
            (List.map
               (fun name -> spf "%s -> %s;\n" node_name name)
               case_node_names)
        in
        let codes = String.concat "" case_codes in
        let edge1 = spf "%s -> %s;\n" node_name n1 in
        (match_node ^ edge1 ^ edges ^ c1 ^ codes, node_name)
    | RecAbs (m, f, x, expr) ->
        let c1, n1 = dot_name string_of_info f in
        let c2, n2 = dot_name string_of_info x in
        let c3, n3 = dot_expr string_of_info expr in
        let decl_node =
          spf "%s [label=\"RecAbs %s\"];\n" node_name (string_of_info m)
        in
        let edge1 = spf "%s -> %s;\n" node_name n1 in
        let edge2 = spf "%s -> %s;\n" node_name n2 in
        let edge3 = spf "%s -> %s;\n" node_name n3 in
        (decl_node ^ edge1 ^ edge2 ^ edge3 ^ c1 ^ c2 ^ c3, node_name)
    | FunApp (m, expr1, expr2) ->
        let c1, n1 = dot_expr string_of_info expr1 in
        let c2, n2 = dot_expr string_of_info expr2 in
        let decl_node =
          spf "%s [label=\"FunApp %s\"];\n" node_name (string_of_info m)
        in
        let edge1 = spf "%s -> %s;\n" node_name n1 in
        let edge2 = spf "%s -> %s;\n" node_name n2 in
        (decl_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name)
    | TypeConstr (m, expr, typ) ->
        let c1, n1 = dot_expr string_of_info expr in
        let c2, n2 = dot_typ string_of_info typ in
        let decl_node =
          spf "%s [label=\"TypeConstr %s\"];\n" node_name (string_of_info m)
        in
        let edge1 = spf "%s -> %s;\n" node_name n1 in
        let edge2 = spf "%s -> %s;\n" node_name n2 in
        (decl_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name)
    | Unop (m, unop, expr) ->
        let c1, n1 = dot_unop string_of_info unop in
        let c2, n2 = dot_expr string_of_info expr in
        let decl_node =
          spf "%s [label=\"Unop %s\"];\n" node_name (string_of_info m)
        in
        let edge1 = spf "%s -> %s;\n" node_name n1 in
        let edge2 = spf "%s -> %s;\n" node_name n2 in
        (decl_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name)
    | Binop (m, binop, expr1, expr2) ->
        let c1, n1 = dot_binop string_of_info binop in
        let c2, n2 = dot_expr string_of_info expr1 in
        let c3, n3 = dot_expr string_of_info expr2 in
        let decl_node =
          spf "%s [label=\"Binop %s\"];\n" node_name (string_of_info m)
        in
        let edge1 = spf "%s -> %s;\n" node_name n1 in
        let edge2 = spf "%s -> %s;\n" node_name n2 in
        let edge3 = spf "%s -> %s;\n" node_name n3 in
        (decl_node ^ edge1 ^ edge2 ^ edge3 ^ c1 ^ c2 ^ c3, node_name)
    | Send (m, expr, name) ->
        let c1, n1 = dot_expr string_of_info expr in
        let c2, n2 = dot_name string_of_info name in
        let decl_node =
          spf "%s [label=\"Send %s\"];\n" node_name (string_of_info m)
        in
        let edge1 = spf "%s -> %s;\n" node_name n1 in
        let edge2 = spf "%s -> %s;\n" node_name n2 in
        (decl_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name)
    | Recv (m, typ, name) ->
        let c1, n1 = dot_typ string_of_info typ in
        let c2, n2 = dot_name string_of_info name in
        let decl_node =
          spf "%s [label=\"Recv %s\"];\n" node_name (string_of_info m)
        in
        let edge1 = spf "%s -> %s;\n" node_name n1 in
        let edge2 = spf "%s -> %s;\n" node_name n2 in
        (decl_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name)
    | ChooseFor (m, name, lab) ->
        let c1, n1 = dot_name string_of_info name in
        let c2, n2 = dot_lab string_of_info lab in
        let decl_node =
          spf "%s [label=\"ChooseFor %s\"];\n" node_name (string_of_info m)
        in
        let edge1 = spf "%s -> %s;\n" node_name n1 in
        let edge2 = spf "%s -> %s;\n" node_name n2 in
        (decl_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name)
    | AllowChoice (m, name, choices) ->
        let dot_choice string_of_info (lab, expr) =
          let node_name = generate_node_name () in
          let c1, pat_name = dot_lab string_of_info lab in
          let c2, expr_name = dot_expr string_of_info expr in
          let case_node = spf "%s [label=\"Choice\"];\n" node_name in
          let edge1 = spf "%s -> %s;\n" node_name pat_name in
          let edge2 = spf "%s -> %s;\n" node_name expr_name in
          (case_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name)
        in
        let choice_codes, choice_node_names =
          List.split (List.map (dot_choice string_of_info) choices)
        in
        let c1, n1 = dot_name string_of_info name in
        let expr_node =
          spf "%s [label=\"AllowChoice %s\"];\n" node_name (string_of_info m)
        in
        let edges =
          String.concat ""
            (List.map
               (fun n -> spf "%s -> %s;\n" node_name n)
               choice_node_names)
        in
        let codes = String.concat "" choice_codes in
        let edge1 = spf "%s -> %s;\n" node_name n1 in
        (expr_node ^ edge1 ^ edges ^ c1 ^ codes, node_name)
    | AmI (m, expr) ->
        let c, n = dot_expr string_of_info expr in
        let expr_node =
          spf "%s [label=\"AmI %s\"];\n" node_name (string_of_info m)
        in
        let edge = spf "%s -> %s;\n" node_name n in
        (expr_node ^ edge ^ c, node_name)

  let rec dot_decls string_of_info program =
    match program with
    | [] -> ("", "")
    | decl :: rest ->
        let decl_dot_code, decl_node_name = dot_decl string_of_info decl in
        let rest_dot_code, rest_node_name = dot_decls string_of_info rest in
        ( (decl_dot_code
          ^ if rest <> [] then "\n" ^ rest_dot_code else rest_dot_code),
          decl_node_name ^ " " ^ rest_node_name )

  and dot_decl string_of_info decl =
    let node_name = generate_node_name () in
    match decl with
    | EmulatedLocDecl (m, name) ->
        let c, n = dot_name string_of_info name in
        let decl_node =
          spf "%s [label=\"EmulatedLocDecl %s\"];\n" node_name
            (string_of_info m)
        in
        let edge = spf "%s -> %s;\n" node_name n in
        (decl_node ^ edge ^ c, node_name)
    | TypeDecl (m, name, typ) ->
        let c1, n1 = dot_name string_of_info name in
        let c2, n2 = dot_typ string_of_info typ in
        let decl_node =
          spf "%s [label=\"Type Decl %s\"];\n" node_name (string_of_info m)
        in
        let edge1 = spf "%s -> %s;\n" node_name n1 in
        let edge2 = spf "%s -> %s;\n" node_name n2 in
        (decl_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name)
    | TypeAliasDecl (m, name, typ) ->
        let c1, n1 = dot_name string_of_info name in
        let c2, n2 = dot_typ string_of_info typ in
        let decl_node =
          spf "%s [label=\"Type Alias Decl %s\"];\n" node_name
            (string_of_info m)
        in
        let edge1 = spf "%s -> %s;\n" node_name n1 in
        let edge2 = spf "%s -> %s;\n" node_name n2 in
        (decl_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name)
    | DefnDecl (m, name, patterns, expr) ->
        let c1, n1 = dot_name string_of_info name in
        let pat_codes, pat_node_names =
          List.split (List.map (dot_pattern string_of_info) patterns)
        in
        let c3, n3 = dot_expr string_of_info expr in
        let decl_node =
          spf "%s [label=\"Defn Decl %s\"];\n" node_name (string_of_info m)
        in
        let edge1 = spf "%s -> %s;\n" node_name n1 in
        let edges =
          String.concat ""
            (List.map
               (fun pat_name -> spf "%s -> %s;\n" node_name pat_name)
               pat_node_names)
        in
        let edge3 = spf "%s -> %s;\n" node_name n3 in
        let codes = String.concat "" pat_codes in
        (decl_node ^ edge1 ^ edges ^ edge3 ^ c1 ^ codes ^ c3, node_name)
    | ImportDecl (m, name) ->
        let c, n = dot_name string_of_info name in
        let decl_node =
          spf "%s [label=\"Import Decl %s\"];\n" node_name (string_of_info m)
        in
        let edge = spf "%s -> %s;\n" node_name n in
        (decl_node ^ edge ^ c, node_name)
    | VariantDecl (m, name, constructors) ->
        let c1, n1 = dot_name string_of_info name in
        let dot_constructor (cname, typs, typ) =
          let node_name = generate_node_name () in
          let cc1, ncname = dot_name string_of_info cname in
          let typ_codes, typ_names =
            List.split (List.map (dot_typ string_of_info) typs)
          in
          let cc3, ntyp = dot_typ string_of_info typ in
          let constr_node =
            spf "%s [label=\"Variant Constructor\"];\n" node_name
          in
          let edge1 = spf "%s -> %s;\n" node_name ncname in
          let edges =
            String.concat ""
              (List.map
                 (fun name -> spf "%s -> %s;\n" node_name name)
                 typ_names)
          in
          let codes = String.concat "" typ_codes in
          let edge3 = spf "%s -> %s;\n" node_name ntyp in
          (constr_node ^ edge1 ^ edges ^ edge3 ^ cc1 ^ codes ^ cc3, node_name)
        in
        let constr_codes, node_names =
          List.split (List.map dot_constructor constructors)
        in
        let decl_node =
          spf "%s [label=\"Variant Decl %s\"];\n" node_name (string_of_info m)
        in
        let edge1 = spf "%s -> %s;\n" node_name n1 in
        let edges =
          String.concat ""
            (List.map (fun name -> spf "%s -> %s;\n" node_name name) node_names)
        in
        let codes = String.concat "" constr_codes in
        (decl_node ^ edge1 ^ edges ^ c1 ^ codes, node_name)

  let generate_dot_code string_of_info program =
    let string_of_info m = String.escaped (string_of_info m) in
    let code, _ = dot_decls string_of_info program in
    (*Set node counter to 0 so that the next call to generate_dot_code starts at 0*)
    node_counter := 0;
    (* print_endline "DEBUG: WRITING FILE";
    let full_code = spf "digraph G {\n%s\n}\n" code in
    let oc = open_out "../../../test_dot.dot" in
    output_string oc full_code;
    close_out oc;
    print_endline "DEBUG: WROTE FILE"; *)
    spf "digraph G {\n%s\n}\n" code
end
