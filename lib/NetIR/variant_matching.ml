module MkVariantMatching (A : Ast.AST) = struct
  let collect_variants prog =
    let arrange_data (vs, cs) decl =
      (* Below, we are gathering all constructors and formatting
        them in two ways; packaging them with their variant, and packaging
        them into a list on their own. We package them with the variant because
        that's what will be going into our constructor lookup table, and we
        package them on their own so we can attach the variant name and place that
        in the variant lookup table.*)
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

  let make_lookup_fun table =
   fun target ->
    let find_fun = fun (key, _) -> String.equal key target in
    (* List.find_opt returns an option of the first element in the list that satisfies 
    the given predicate, or None if nothing is found. *)
    match List.find_opt find_fun table with
    | Some (_, value) -> Some value
    | None -> None

  (* This is the entry point to variant matching. It returns a pair of functions.
    The first function is given the name of a variant, and returns a list of 
    that variant's constructors, or None if nothing is found. The second function
    is given the name of a constructor, and returns the name of its associated
    variant. *)
  let get_variant_tables prog =
    let variant_table, constructor_table = collect_variants prog in
    let variant_fun = make_lookup_fun variant_table in
    let constructor_fun = make_lookup_fun constructor_table in
    (variant_fun, constructor_fun)
end
