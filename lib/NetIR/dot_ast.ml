module MkDotAST (M : sig
  include Metainfo.Meta.Metainfo

  val to_string : t -> string
end) =
struct
  module AST = Ast.MkAST (M)
  open AST

  let spf = Printf.sprintf
  let node_counter = ref 0

  let generate_node_name () =
    let node_id = !node_counter in
    node_counter := !node_counter + 1;
    "n" ^ string_of_int node_id

  let dot_name string_of_info name =
    let node_name = generate_node_name () in
    let info, str = name in
    ( spf "%s [label=\"Name %s %s\"];\n" node_name str (string_of_info info),
      node_name )

  let dot_int int =
    let node_name = generate_node_name () in
    ( spf "%s [label=\"Int %s\"];\n" node_name (string_of_int int),
      node_name )

  let dot_float float =
    let node_name = generate_node_name () in
    ( spf "%s [label=\"Float %s\"];\n" node_name (string_of_float float),
      node_name )

  let dot_char char =
    let node_name = generate_node_name () in
    ( spf "%s [label=\"Char %s\"];\n" node_name (String.make 1 char),
      node_name )

  let dot_string string =
    let node_name = generate_node_name () in
    ( spf "%s [label=\"String %s\"];\n" node_name string,
      node_name )

  let rec dot_pattern string_of_info pat =
    let node_name = generate_node_name () in
    match pat with
    | WildcardPat (m) ->
      (spf "%s [label=\"Wildcard Pat %s\"];\n" node_name (string_of_info m), node_name)
    | VarPat (m, name) ->
      let c, n = dot_name string_of_info name in
      let pat_node =
        spf "%s [label=\"Var Pat %s\"];\n" node_name (string_of_info m) in
      let edge = spf "%s -> %s;\n" node_name n in
      (pat_node ^ edge ^ c, node_name)
    | UnitLitPat (m) ->
      (spf "%s [label=\"Unit Lit Pat %s\"];\n" node_name (string_of_info m), node_name)
    | IntLitPat (m, int) ->
      let c, n = dot_int int in
      let pat_node =
        spf "%s [label=\"Int Lit Pat %s\"];\n" node_name (string_of_info m) in
      let edge = spf "%s -> %s;\n" node_name n in
      (pat_node ^ edge ^ c, node_name)
    | FloatLitPat (m, float) ->
      let c, n = dot_float float in
      let pat_node =
        spf "%s [label=\"Float Lit Pat %s\"];\n" node_name (string_of_info m) in
      let edge = spf "%s -> %s;\n" node_name n in
      (pat_node ^ edge ^ c, node_name)
    | CharLitPat (m, char) ->
      let c, n = dot_char char in
      let pat_node =
        spf "%s [label=\"Char Lit Pat %s\"];\n" node_name (string_of_info m) in
      let edge = spf "%s -> %s;\n" node_name n in
      (pat_node ^ edge ^ c, node_name)
    | StringLitPat (m, string) ->
      let c, n = dot_string string in
      let pat_node =
        spf "%s [label=\"String Lit Pat %s\"];\n" node_name (string_of_info m)
      in
      let edge = spf "%s -> %s;\n" node_name n in
      (pat_node ^ edge ^ c, node_name)
    | TrueLitPat (m) ->
      (spf "%s [label=\"True Lit Pat %s\"];\n" node_name (string_of_info m), node_name)
    | FalseLitPat (m) ->
      (spf "%s [label=\"False Lit Pat %s\"];\n" node_name (string_of_info m), node_name)
    | LocLitPat (m, name) ->
      let c, n = dot_name string_of_info name in
      let pat_node =
        spf "%s [label=\"Loc Lit Pat %s\"];\n" node_name (string_of_info m) in
      let edge = spf "%s -> %s;\n" node_name n in
      (pat_node ^ edge ^ c, node_name)
    | ConstructorPat (m, name, patterns) ->
      let c1, n1 = dot_name string_of_info name in
      let c2, n2 =
        let pat_codes, node_names =
          List.split (List.map (dot_pattern string_of_info) patterns)
        in
        (String.concat "" pat_codes, node_names)
      in
      let pat_node =
        spf "%s [label=\"Constructor Pat %s\"];\n" node_name (string_of_info m)
      in
      let edge1 = spf "%s -> %s;\n" node_name n1 in
      let edge2 = spf "%s -> %s;\n" node_name n2 in
      (pat_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name)
    | LocNamePat (m, name) ->
      let c, n = dot_name string_of_info name in
      let pat_node =
        spf "%s [label=\"Loc Name Pat %s\"];\n" node_name (string_of_info m) in
      let edge = spf "%s -> %s;\n" node_name n in
      (pat_node ^ edge ^ c, node_name)

  let dot_unop string_of_info unop =
    let node_name = generate_node_name () in
    match unop with
    | Neg (m) ->
      (spf "%s [label=\"Neg %s\"];\n" node_name (string_of_info m), node_name)
    | Not (m) ->
      (spf "%s [label=\"Not %s\"];\n" node_name (string_of_info m), node_name)

  let dot_binop string_of_info binop =
    let node_name = generate_node_name () in
    match binop with
    | Plus (m) ->
      (spf "%s [label=\"Plus %s\"];\n" node_name (string_of_info m), node_name)
    | Minus (m) ->
      (spf "%s [label=\"Minus %s\"];\n" node_name (string_of_info m), node_name)
    | Times (m) ->
      (spf "%s [label=\"Times %s\"];\n" node_name (string_of_info m), node_name)
    | Div (m) ->
      (spf "%s [label=\"Div %s\"];\n" node_name (string_of_info m), node_name)
    | And (m) ->
      (spf "%s [label=\"And %s\"];\n" node_name (string_of_info m), node_name)
    | Or (m) ->
      (spf "%s [label=\"Or %s\"];\n" node_name (string_of_info m), node_name)
    | Eq (m) ->
      (spf "%s [label=\"Eq %s\"];\n" node_name (string_of_info m), node_name)
    | Neq (m) ->
      (spf "%s [label=\"Neq %s\"];\n" node_name (string_of_info m), node_name)
    | Lt (m) ->
      (spf "%s [label=\"Lt %s\"];\n" node_name (string_of_info m), node_name)
    | Leq (m) ->
      (spf "%s [label=\"Leq %s\"];\n" node_name (string_of_info m), node_name)
    | Gt (m) ->
      (spf "%s [label=\"Gt %s\"];\n" node_name (string_of_info m), node_name)
    | Geq (m) ->
      (spf "%s [label=\"Geq %s\"];\n" node_name (string_of_info m), node_name)

  let rec dot_typ string_of_info typ =
    let node_name = generate_node_name () in
    match typ with
    | VarTy (m, name) ->
      let c, n = dot_name string_of_info name in
      let typ_node =
        spf "%s [label=\"Var Type %s\"];\n" node_name (string_of_info m) in
      let edge = spf "%s -> %s;\n" node_name n in
      (typ_node ^ edge ^ c, node_name)
    | UnitTy (m) ->
      (spf "%s [label=\"Unit Type %s\"];\n" node_name (string_of_info m), node_name)
    | IntTy (m) ->
      (spf "%s [label=\"Int Type %s\"];\n" node_name (string_of_info m), node_name)
    | FloatTy (m) ->
      (spf "%s [label=\"Float Type %s\"];\n" node_name (string_of_info m), node_name)
    | CharTy (m) ->
      (spf "%s [label=\"Char Type %s\"];\n" node_name (string_of_info m), node_name)
    | StringTy (m) ->
      (spf "%s [label=\"String Type %s\"];\n" node_name (string_of_info m), node_name)
    | BoolTy (m) ->
      (spf "%s [label=\"Bool Type %s\"];\n" node_name (string_of_info m), node_name)
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
      let typ_node =
        spf "%s [label=\"Loc Type %s\"];\n" node_name (string_of_info m)
      in
      let edge = spf "%s -> %s;\n" node_name names in
      (typ_node ^ edge, node_name)

  let dot_expr string_of_info expr = ()

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
          spf "%s [label=\"Emulated Loc Decl %s\"];\n" node_name
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
        let c2, n2 =
          let pat_codes, node_names =
            List.split (List.map (dot_pattern string_of_info) patterns)
          in
          (String.concat "" pat_codes, node_names)
        in
        let c3, n3 = dot_expr string_of_info expr in
        let decl_node =
          spf "%s [label=\"Defn Decl %s\"];\n" node_name (string_of_info m)
        in
        let edge1 = spf "%s -> %s;\n" node_name n1 in
        let edge2 = spf "%s -> %s;\n" node_name n2 in
        let edge3 = spf "%s -> %s;\n" node_name n3 in
        (decl_node ^ edge1 ^ edge2 ^ edge3 ^ c1 ^ c2 ^ c3, node_name)
    | ImportDecl (m, name) ->
        let c, n = dot_name string_of_info name in
        let decl_node =
          spf "%s [label=\"Import Decl %s\"];\n" node_name (string_of_info m)
        in
        let edge = spf "%s -> %s;\n" node_name n in
        (decl_node ^ edge ^ c, node_name)
    | VariantDecl (m, name, variants) ->
        () (*Variants are a little complicated*)

  let generate_dot_code string_of_info program =
    let code, _ = dot_decls string_of_info program in
    () (*Stubbed for now*)
end
