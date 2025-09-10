module Msg_mpi_intf : Msg_intf.M

val emit_toplevel_mpi
  :  out_channel
  -> string list
  -> 'a Ast_core.Net.M.stmt_block list
  -> unit
