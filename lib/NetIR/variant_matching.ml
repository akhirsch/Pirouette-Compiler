module MkVariantMatching (A : Ast.AST) = struct
  let collect_variants prog =
    let arrange_data (vs, cs) decl =
      match decl with
      | A.VariantDecl (_, (_, v_name), decl_cs) ->
          let split_decl =
           fun ((_, c_name), _, _) -> ((c_name, v_name), c_name)
          in
          let new_cs, c_names = List.split (List.map split_decl decl_cs) in
          let new_v = (v_name, c_names) in
          (new_v :: vs, new_cs @ cs)
      | _ -> (vs, cs)
    in
    List.fold_left arrange_data ([], []) prog

  let gen_lookup_fun table =
   fun target ->
    match List.find_opt (fun (key, _) -> String.equal key target) table with
    | Some (_, value) -> Some value
    | None -> None

  let get_variant_tables prog =
    let variant_table, constructor_table = collect_variants prog in
    let variant_fun = gen_lookup_fun variant_table in
    let constructor_fun = gen_lookup_fun constructor_table in
    (variant_fun, constructor_fun)
end
