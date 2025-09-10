open Ppxlib

module type M = sig
  val emit_net_send : src:string -> dst:string -> expression -> expression
  val emit_net_recv : src:string -> dst:string -> expression
end
