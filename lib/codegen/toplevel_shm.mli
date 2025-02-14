val emit_toplevel_shm
  :  out_channel
  -> (module Msg_intf.M)
  -> string list
  -> 'a Ast_core.Net.M.stmt_block list
  -> unit

val emit_toplevel_http
  :  out_channel
  -> (module Msg_intf.M)
  -> string list
  -> 'a Ast_core.Net.M.stmt_block list
  -> unit
