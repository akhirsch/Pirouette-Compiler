exception Main_expr of Ppxlib.expression

val emit_local_pexp : 'a Ast_core.Local.M.expr -> Ppxlib.expression
val emit_local_ppat : 'a Ast_core.Local.M.pattern -> Ppxlib.pattern

val emit_net_fun_body
  :  self_id:string
  -> (module Msg_intf.M)
  -> 'a Ast_core.Local.M.pattern list
  -> 'a Ast_core.Net.M.expr
  -> Ppxlib.expression

val emit_net_binding
  :  self_id:string
  -> (module Msg_intf.M)
  -> 'a Ast_core.Net.M.stmt
  -> Ppxlib.value_binding

val emit_net_pexp
  :  self_id:string
  -> (module Msg_intf.M)
  -> 'a Ast_core.Net.M.expr
  -> Ppxlib.expression

val emit_foreign_decl :
  string -> 'a Ast_core.Net.M.typ -> string -> Ppxlib.value_binding
