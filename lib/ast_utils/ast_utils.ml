module Choreo = Ast_core.Choreo.M
module Net = Ast_core.Net.M

let extract_locs (stmt_block : 'a Choreo.stmt_block) =
  Ast_locs.extract_stmt_block stmt_block |> Ast_locs.LocSet.elements
;;

let stringify_jsonify_choreo_ast (stmt_block : 'a Choreo.stmt_block) =
  Jsonify_ast.jsonify_choreo_stmt_block stmt_block |> Yojson.Basic.pretty_to_string
;;

let stringify_jsonify_net_ast (stmt_block : 'a Net.stmt_block) =
  Jsonify_ast.jsonify_net_stmt_block stmt_block |> Yojson.Safe.pretty_to_string
;;

let jsonify_choreo_ast out_chan (stmt_block : 'a Choreo.stmt_block) =
  Jsonify_ast.jsonify_choreo_stmt_block stmt_block
  |> Yojson.Basic.pretty_to_channel out_chan
;;

let jsonify_net_ast out_chan (stmt_block : 'a Net.stmt_block) =
  Jsonify_ast.jsonify_net_stmt_block stmt_block |> Yojson.Safe.pretty_to_channel out_chan
;;

let stringify_pprint_choreo_ast (stmt_block : 'a Choreo.stmt_block) =
  Pprint_ast.pprint_choreo_stmt_block Format.str_formatter stmt_block;
  Format.flush_str_formatter ()
;;

let stringify_pprint_net_ast (stmt_block : 'a Net.stmt_block) =
  Pprint_ast.pprint_net_stmt_block Format.str_formatter stmt_block;
  Format.flush_str_formatter ()
;;

let pprint_choreo_ast out_chan (stmt_block : 'a Choreo.stmt_block) =
  let ppf = Format.formatter_of_out_channel out_chan in
  Pprint_ast.pprint_choreo_stmt_block ppf stmt_block;
  Format.pp_print_newline ppf ()
;;

let pprint_net_ast out_chan (stmt_block : 'a Net.stmt_block) =
  let ppf = Format.formatter_of_out_channel out_chan in
  Pprint_ast.pprint_net_stmt_block ppf stmt_block;
  Format.pp_print_newline ppf ()
;;

let stringify_dot_choreo_ast (string_of_info : 'a -> string) program =
  Dot_ast.generate_dot_code string_of_info program
;;

let dot_choreo_ast
      out_chan
      (string_of_info : 'a -> string)
      (stmt_block : 'a Choreo.stmt_block)
  =
  let dot_code = stringify_dot_choreo_ast string_of_info stmt_block in
  output_string out_chan dot_code;
  flush out_chan
;;

(* FFI (Foreign Function Interface) utilities *)

(* Extract the package name, submodule(s)/function name, and search path from a foreign
   declaration string *)
let parse_external_name name =
  let rest, search_path =
    match String.split_on_char '@' name with
    | [ rest; search_path  ] -> rest, Some search_path
    | [ rest ] -> rest, None
    | _ -> failwith "Impossible Failure"
  in
  let package_name, function_name =
    match String.split_on_char ':' rest with
    | [pack; submods_func] when pack <> "" && submods_func <> ""
      -> Some pack, submods_func
    | [submods_func] when submods_func <> ""
      -> None, submods_func
    | _ -> failwith "Invalid external function format. Expected [Package:][Submodule.]function[@searchpath]"
  in
  (package_name, function_name, search_path)

(* Extract all unique FFI information from a list of statements *)
let collect_ffi_info stmts =
  let rec collect acc = function
    | [] -> acc
    | Choreo.ForeignDecl (_, _, external_name, _) :: rest ->
      let acc' = (parse_external_name external_name) :: acc in
      collect acc' rest
    | _ :: rest -> collect acc rest
  in
  List.sort_uniq (fun (a, b, c) (a', b', c') ->
      match (a, a') with
      | Some a, Some a' -> begin
          match String.compare a a' with
          | 0 -> begin
              match String.compare b b' with
              | 0 -> begin
                  match c, c' with
                  | Some c, Some c' -> String.compare c c'
                  | Some _, None -> 1
                  | None, Some _ -> -1
                  | None, None -> 0
                end
              | n -> n
            end
          |n -> n
        end
      | Some _, None -> 1
      | None, Some _ -> -1
      | None, None -> 0)
    (collect [] stmts)
;;
