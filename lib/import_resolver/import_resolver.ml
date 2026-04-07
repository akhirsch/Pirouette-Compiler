exception Import_error of string

let resolve_imports base_dir stmts =
  let rec resolve_imports_helper seen_files base_dir stmts =
    List.concat_map
      (fun stmt ->
        match stmt with
        | Ast_core.Choreo.M.ImportDecl (filename, _) ->
            let full_path = Filename.concat base_dir filename in
            (* build in func to build the full path of a file name filename.concat *)
            if List.mem full_path seen_files then
              raise
                (Import_error
                   ("Transitive cycle detected: "
                   ^ String.concat " -> " (seen_files @ [ full_path ])))
              (* check for cycles using List.mem which takes the fullpath we just got and checks the list of imported files
          if it exists then an error is thrown telling us a cycle was decteced and gives the fullpath of that cycle *)
            else if not (Sys.file_exists full_path) then
              (* Sys usage is from the systems module Sys.file_exists test if a file with the given name exists
              will return True if it exists and False other wise *)
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
              resolve_imports_helper (full_path :: seen_files)
                (Filename.dirname full_path)
                imported_stmts
        | other -> [ other ])
      stmts
  in
  resolve_imports_helper [] base_dir stmts
