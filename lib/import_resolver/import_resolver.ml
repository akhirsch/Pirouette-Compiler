exception Import_error of string

let get_stdlib_stmts () =
  let lexbuf = Lexing.from_string Stdlib_utils.Stdlib_src.src in
  try Parsing.Parse.parse_with_error "stdlib" lexbuf
  with Failure msg -> raise (Import_error ("Failed to parse stdlib: " ^ msg))

let resolve_imports base_dir stmts =
  let stdlib_stmts = get_stdlib_stmts () in
  let resolved_files = ref [] in
  let rec resolve_imports_helper in_progress base_dir stmts =
    List.concat_map
      (fun stmt ->
        match stmt with
        | Ast_core.Choreo.M.ImportDecl (filename, _) ->
            let full_path = Filename.concat base_dir filename in
            if List.mem full_path in_progress then
              raise
                (Import_error
                   ("Transitive cycle detected: "
                   ^ String.concat " -> " (in_progress @ [ full_path ])))
            else if List.mem full_path !resolved_files then []
              (* already resolved, skip *)
            else if not (Sys.file_exists full_path) then
              raise (Import_error ("File not found: " ^ full_path))
            else
              let ic = open_in full_path in
              let lexbuf = Lexing.from_channel ic in
              let imported_stmts =
                try Parsing.Parse.parse_with_error full_path lexbuf
                with Failure msg ->
                  raise
                    (Import_error
                       ("Failed to parse imported file: " ^ full_path ^ "\n"
                      ^ msg))
              in
              close_in ic;
              resolved_files := full_path :: !resolved_files;
              resolve_imports_helper (full_path :: in_progress)
                (Filename.dirname full_path)
                imported_stmts
        | other -> [ other ])
      stmts
  in
  resolve_imports_helper [] base_dir (stdlib_stmts @ stmts)
