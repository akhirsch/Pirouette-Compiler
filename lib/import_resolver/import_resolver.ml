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
                Parsing.Parse.parse_with_error full_path lexbuf
              in
              close_in ic;
              (* how main parses a file:
            let lexbuf = Lexing.from_channel (open_in full_path) in
            let imported_stmts = Parsing.Parse.parse_with_error full_path lexbuf in 
            so we open a file from the fullpath , create the lexer buffer from that open file/channel 
            and then feed the fullpath and the lexer buffer to the same parser call as in main *)
              resolve_imports_helper (full_path :: seen_files)
                (Filename.dirname full_path)
                imported_stmts
            (* recursive call with updated seen_files *)
        | other -> [ other ]
        (* my catch all that  it just passes through anything else that isnt an ImportDecl untouched
       for anyting else it would just gets wrapped in a list and passed along as-is*))
      stmts
  in
  resolve_imports_helper [] base_dir stmts
