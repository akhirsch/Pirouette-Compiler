

let spf = Printf.sprintf
let node_counter = ref 0

let generate_node_name () =
  let node_id = !node_counter in
  node_counter := !node_counter + 1;
  "n" ^ string_of_int node_id

let dot_name string_of_info name =
  let node_name = generate_node_name () in
  let info, str = name in
  (spf "%s [label=\"Name %s %s\"];\n" node_name str (string_of_info info), node_name)


let rec dot_decls string_of_info program =
  match program with
    | [] -> ("","")
    | decl :: rest ->
      let decl_dot_code, decl_node_name = dot_decl string_of_info decl in
      let rest_dot_code, rest_node_name = dot_decls string_of_info rest in
      ( (decl_dot_code
        ^ if rest <> [] then "\n" ^ rest_dot_code else rest_dot_code),
        decl_node_name ^ " " ^ rest_node_name )

and dot_decl string_of_info decl =
  let node_name = generate_node_name () in
  match decl with
    |EmulatedLocDecl (m1, (m2, name)) ->
      let code, name = dot_choreo_pattern string_of_info pat in
      let decl_node =
        spf "%s [label=\"Emulated Loc Decl %s\"];\n" node_name (string_of_info m1)
      in
      let edge1 = spf "%s -> %s;\n" node_name n1 in
      let edge2 = spf "%s -> %s;\n" node_name n2 in
      (decl_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name)
    |TypeDecl
    |TypeAliasDecl
    |DefnDecl
    |ImportDecl
    |VariantDecl


let generate_dot_code string_of_info program =
  let code, _ = dot_decls string_of_info program