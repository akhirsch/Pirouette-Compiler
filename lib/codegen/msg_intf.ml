open Ppxlib

let spf = Printf.sprintf
let loc = { !Ast_helper.default_loc with loc_ghost = true }

module type M = sig
  val emit_toplevel_init : string list -> structure
  val emit_net_send : src:string -> dst:string -> expression -> expression
  val emit_net_recv : src:string -> dst:string -> expression
end

module Msg_chan_intf : M = struct
  let emit_toplevel_init loc_ids =
    let loc_pairs =
      List.concat_map
        (fun a -> List.filter_map (fun b -> if a <> b then Some (a, b) else None) loc_ids)
        loc_ids
    in
    List.map
      (fun (a, b) ->
        [%stri
          let [%p Ast_builder.Default.pvar ~loc (spf "chan_%s_%s" a b)] =
            Domainslib.Chan.make_bounded 0
          ;;])
      loc_pairs
  ;;

  let emit_net_send ~src ~dst pexp =
    ignore dst;
    [%expr
      Domainslib.Chan.send
        [%e Ast_builder.Default.evar ~loc (spf "chan_%s_%s" src dst)]
        [%e pexp]]
  ;;

  let emit_net_recv ~src ~dst =
    [%expr
      Domainslib.Chan.recv [%e Ast_builder.Default.evar ~loc (spf "chan_%s_%s" src dst)]]
  ;;
end

module Msg_http_intf : M = struct
  let emit_toplevel_init _loc_ids =
    []

  let emit_net_send ~src ~dst pexp =
    ignore src;
    [%expr 
      match Lwt_main.run (Send_receive.send_message ~location:[%e Ast_builder.Default.estring ~loc dst] ~data:[%e pexp]) with
      | Ok () -> ()
      | Error msg -> failwith ("Send error: " ^ msg)]

  let emit_net_recv ~src ~dst =
    ignore src;
    [%expr 
      match Lwt_main.run (Send_receive.receive_message ~location:[%e Ast_builder.Default.estring ~loc dst]) with
      | Ok msg -> msg
      | Error msg -> failwith ("Receive error: " ^ msg)]
end