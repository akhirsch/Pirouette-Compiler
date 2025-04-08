module Local = Ast_core.Local.M
module Net = Ast_core.Net.M
open Ppxlib

let spf = Printf.sprintf
let loc = { !Ast_helper.default_loc with loc_ghost = true }

let emit_toplevel_shm
  out_chan
  (module Msg : Msg_intf.M)
  (loc_ids : string list)
  (net_stmtblock_l : 'a Net.stmt_block list)
  =
  let emit_domain_stri (loc_id : string) (net_stmts : 'a Net.stmt_block) =
    let main_expr = ref (Ast_builder.Default.eunit ~loc) in
    let rec emit_net_toplevel = function
      | [] -> !main_expr
      | stmt :: stmts ->
        (match Emit_core.emit_net_binding ~self_id:loc_id (module Msg) stmt with
         | exception Emit_core.Main_expr e ->
           main_expr := e;
           emit_net_toplevel stmts
         | binding ->
           Ast_builder.Default.pexp_let
             ~loc
             Recursive
             [ binding ]
             (emit_net_toplevel stmts))
    in
    [%stri
      let [%p Ast_builder.Default.pvar ~loc (spf "domain_%s" loc_id)] =
        Domain.spawn (fun _ -> [%e emit_net_toplevel net_stmts])
      ;;]
  in
  (*FIXED BUG: single loc cases or small cases wouldn't return anything.
    So to flush the formatter's buffer, create the formatter explicitly*)
  let formatter = Format.formatter_of_out_channel out_chan in
  let process_bindings = List.map2 emit_domain_stri loc_ids net_stmtblock_l in
  Pprintast.structure formatter (Msg.emit_toplevel_init loc_ids @ process_bindings);
  (*this line fixed the bug, just needed to flush to make sure all output was written out properly*)
  Format.pp_print_flush formatter ()
;;

let emit_toplevel_http
  out_chan
  (module Msg : Msg_intf.M)
  (loc_ids : string list)
  (net_stmtblock_l : 'a Net.stmt_block list)
  =
  let emit_domain_stri (loc_id : string) (net_stmts : 'a Net.stmt_block) =
    let main_expr = ref (Ast_builder.Default.eunit ~loc) in
    let rec emit_net_toplevel = function
      | [] -> !main_expr
      | stmt :: stmts ->
        (match Emit_core.emit_net_binding ~self_id:loc_id (module Msg) stmt with
         | exception Emit_core.Main_expr e ->
           main_expr := e;
           emit_net_toplevel stmts
         | binding ->
           Ast_builder.Default.pexp_let
             ~loc
             Nonrecursive
             [ binding ]
             (emit_net_toplevel stmts))
    in
    [%stri
      let () =
        Printf.printf "Starting initialization...\n";
        match Lwt_main.run (Send_receive.init ()) with
        | Ok () ->
          Printf.printf
            "Initialization successful, starting process_%s...\n"
            [%e Ast_builder.Default.estring ~loc loc_id];
          let [%p Ast_builder.Default.pvar ~loc (spf "process_%s" loc_id)] =
            [%e emit_net_toplevel net_stmts]
          in
          ignore [%e Ast_builder.Default.evar ~loc (spf "process_%s" loc_id)]
        | Error msg ->
          Printf.printf "Initialization failed: %%s\n" msg;
          failwith ("Init error: " ^ msg)
      ;;]
  in
  let process_bindings = List.map2 emit_domain_stri loc_ids net_stmtblock_l in
  Pprintast.structure
    (Format.formatter_of_out_channel out_chan)
    (Msg.emit_toplevel_init loc_ids @ process_bindings)
;;
