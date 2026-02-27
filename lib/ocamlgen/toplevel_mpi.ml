module Local = Ast_core.Local.M
module Net = Ast_core.Net.M
open Ppxlib

module Builder = Ast_builder.Make (struct
  let loc = { !Ast_helper.default_loc with loc_ghost = true }
end)

let loc = Builder.loc

module Msg_mpi_intf : Msg_intf.M = struct
  let emit_net_send ~src ~dst pexp =
    ignore src;
    [%expr
      Mpi.send [%e pexp] (loc_to_rank [%e Builder.estring dst]) 0 Mpi.comm_world]

  let emit_net_recv ~src ~dst =
    ignore dst;
    [%expr
      Mpi.receive
        (loc_to_rank [%e Builder.estring src])
        Mpi.any_tag Mpi.comm_world]
end

let emit_toplevel_mpi out_chan (loc_ids : string list)
    (net_stmtblocks : 'a Net.stmt_block list) =
  let emit_process loc_id net_stmtblock =
    (* convert a list of statements into a let-in chain *)
    let main_expr = ref Builder.eunit in
    let rec emit_net_toplevel loc_id stmts =
      match stmts with
      | [] -> !main_expr
      | stmt :: stmts -> (
          match
            Emit_core.emit_net_binding ~self_id:loc_id
              (module Msg_mpi_intf)
              stmt
          with
          | exception Emit_core.Main_expr e ->
              main_expr := e;
              emit_net_toplevel loc_id stmts
          | binding ->
              Builder.pexp_let Recursive [ binding ]
                (emit_net_toplevel loc_id stmts))
    in
    emit_net_toplevel loc_id net_stmtblock
  in
  let rank_cases =
    List.mapi
      (fun i (loc_id, net_stmtblock) ->
        Builder.case ~guard:None ~lhs:(Builder.pint i)
          ~rhs:(emit_process loc_id net_stmtblock))
      (List.combine loc_ids net_stmtblocks)
  in
  let mpi_main =
    Builder.pexp_match
      [%expr Mpi.comm_rank Mpi.comm_world]
      (rank_cases
      @ [
          Builder.case ~guard:None ~lhs:Builder.ppat_any
            ~rhs:[%expr failwith "Runtime Error: Unknown rank"];
        ])
  in
  let loc_cases =
    List.mapi
      (fun i loc_id ->
        Builder.case ~guard:None ~lhs:(Builder.pstring loc_id)
          ~rhs:(Builder.eint i))
      loc_ids
  in
  let loc_to_rank_fun =
    Builder.pexp_function
      (loc_cases
      @ [
          Builder.case ~guard:None ~lhs:Builder.ppat_any
            ~rhs:[%expr failwith "Runtime Error: Unknown location"];
        ])
  in
  let ppf = Format.formatter_of_out_channel out_chan in
  Pprintast.structure ppf
    [
      [%stri let loc_to_rank = [%e loc_to_rank_fun]];
      [%stri let _ = Mpi.barrier Mpi.comm_world];
      [%stri let _ = [%e mpi_main]];
    ];
  Format.pp_print_newline ppf ()
