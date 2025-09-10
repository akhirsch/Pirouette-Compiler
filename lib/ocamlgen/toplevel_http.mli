module Msg_http_intf : Msg_intf.M

val emit_toplevel_http
  :  out_channel
  -> string list
  -> 'a Ast_core.Net.M.stmt_block list
  -> string
  -> unit
