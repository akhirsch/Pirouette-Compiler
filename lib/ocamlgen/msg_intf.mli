module type M = sig
  val emit_net_send : src:string -> dst:string -> Ppxlib.expression -> Ppxlib.expression
  val emit_net_recv : src:string -> dst:string -> Ppxlib.expression
end

