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

  let dot_pattern string_of_info pat = ()
  let dot_unop string_of_info unop = ()
  let dot_binop string_of_info binop = ()
  let dot_typ string_of_info typ = ()
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
