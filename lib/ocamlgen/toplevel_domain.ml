module Local = Ast_core.Local.M
module Net = Ast_core.Net.M
open Ppxlib

module Builder = Ast_builder.Make (struct
    let loc = { !Ast_helper.default_loc with loc_ghost = true }
  end)

let loc = Builder.loc
let spf = Printf.sprintf

module Msg_chan_intf : Msg_intf.M = struct
  let emit_net_send ~src ~dst pexp =
    [%expr Domainslib.Chan.send [%e Builder.evar (spf "chan_%s_%s" src dst)] [%e pexp]]
  ;;

  let emit_net_recv ~src ~dst =
    [%expr Domainslib.Chan.recv [%e Builder.evar (spf "chan_%s_%s" src dst)]]
  ;;
end

let emit_toplevel_domain
      out_chan
      (loc_ids : string list)
      (net_stmtblocks : 'a Net.stmt_block list)
  =
  let emit_domain_bindings loc_ids net_stmtblocks : value_binding list =
    (* convert a list of statements into a let-in chain *)
    let main_expr = ref Builder.eunit in
    let rec emit_net_toplevel loc_id stmts : expression =
      match stmts with
      | [] -> !main_expr
      | stmt :: stmts ->
        (match Emit_core.emit_net_binding ~self_id:loc_id (module Msg_chan_intf) stmt with
         | exception Emit_core.Main_expr e ->
           main_expr := e;
           emit_net_toplevel loc_id stmts
         | binding ->
           Builder.pexp_let Recursive [ binding ] (emit_net_toplevel loc_id stmts))
    in
    List.map2
      (fun loc_id net_stmtblock ->
         Builder.value_binding
           ~pat:(Builder.pvar (spf "domain_%s" loc_id))
           ~expr:
             [%expr Domain.spawn (fun _ -> [%e emit_net_toplevel loc_id net_stmtblock])])
      loc_ids
      net_stmtblocks
  in
  let rec emit_domain_join_seq : string list -> expression = function
    | [] -> assert false
    | [ loc_id ] -> [%expr Domain.join [%e Builder.evar (spf "domain_%s" loc_id)]]
    | loc_id :: loc_ids ->
      Builder.pexp_sequence
        [%expr Domain.join [%e Builder.evar (spf "domain_%s" loc_id)]]
        (emit_domain_join_seq loc_ids)
  in
  let emit_chan_defs loc_ids : structure_item list =
    let loc_pairs =
      List.concat_map
        (fun a -> List.filter_map (fun b -> if a <> b then Some (a, b) else None) loc_ids)
        loc_ids
    in
    List.map
      (fun (a, b) ->
         [%stri
           let [%p Builder.pvar (spf "chan_%s_%s" a b)] : string Domainslib.Chan.t =
             Domainslib.Chan.make_bounded 0
           ;;])
      loc_pairs
  in
  let ppf = Format.formatter_of_out_channel out_chan in
  Pprintast.structure
    ppf
    (emit_chan_defs loc_ids
     @ [ Builder.pstr_eval
           (Builder.pexp_let
              Nonrecursive
              (emit_domain_bindings loc_ids net_stmtblocks)
              (emit_domain_join_seq loc_ids))
           []
       ]);
  Format.pp_print_newline ppf ()
;;
