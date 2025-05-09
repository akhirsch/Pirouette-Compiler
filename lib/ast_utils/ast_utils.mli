val extract_locs : 'a Ast_core.Choreo.M.stmt_block -> string list
val stringify_jsonify_choreo_ast : 'a Ast_core.Choreo.M.stmt_block -> string
val stringify_jsonify_net_ast : 'a Ast_core.Net.M.stmt_block -> string
val jsonify_choreo_ast : out_channel -> 'a Ast_core.Choreo.M.stmt_block -> unit
val jsonify_net_ast : out_channel -> 'a Ast_core.Net.M.stmt_block -> unit
val stringify_pprint_choreo_ast : 'a Ast_core.Choreo.M.stmt_block -> string
val stringify_pprint_net_ast : 'a Ast_core.Net.M.stmt_block -> string
val pprint_choreo_ast : out_channel -> 'a Ast_core.Choreo.M.stmt_block -> unit
val pprint_net_ast : out_channel -> 'a Ast_core.Net.M.stmt_block -> unit
val stringify_dot_choreo_ast : ('a -> string) -> 'a Ast_core.Choreo.M.stmt_block -> string

val dot_choreo_ast
  :  out_channel
  -> ('a -> string)
  -> 'a Ast_core.Choreo.M.stmt_block
  -> unit

(* FFI extraction utilities *)
val extract_ffi_file : string -> string option
val collect_ffi_files : 'a Ast_core.Net.M.stmt list -> string list
val generate_ffi_libraries : 'a Ast_core.Net.M.stmt list -> string
