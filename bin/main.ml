open Http

let usage_msg = "USAGE: pirc <file> [-ast-dump <pprint|json>] [-backend <shm|http>]"
let ast_dump_format = ref "pprint"
let backend = ref "shm"
let file_ic = ref None
let basename = ref ""

let anon_fun filename =
  basename := Filename.remove_extension filename;
  file_ic := Some (open_in filename)
;;

let speclist =
  [ "-", Arg.Unit (fun () -> file_ic := Some stdin), "Read source from stdin"
  ; ( "-ast-dump"
    , Arg.Symbol ([ "pprint"; "json" ], fun s -> ast_dump_format := s)
    , "Dump the AST in the specified format (pprint, json)" )
  ; ( "-backend"
    , Arg.Symbol ([ "shm"; "http" ], fun s -> backend := s)
    , "Choose communication backend (shm: shared memory, http: HTTP)" )
  ]
;;

let () =
  Arg.parse speclist anon_fun usage_msg;
  if !file_ic = None
  then (
    prerr_endline (Sys.argv.(0) ^ ": No input file");
    exit 1);
  let lexbuf = Lexing.from_channel (Option.get !file_ic) in
  let program = Parsing.Parse.parse_with_error lexbuf in
  (match !ast_dump_format with
   | "json" -> Ast_utils.jsonify_choreo_ast (open_out (!basename ^ ".json")) program
   | "pprint" -> Ast_utils.pprint_choreo_ast (open_out (!basename ^ ".ast")) program
   | _ -> invalid_arg "Invalid ast-dump format");
  let locs = Ast_utils.extract_locs program in
  let netir_l = List.map (fun loc -> Netgen.epp_choreo_to_net program loc) locs in
  List.iter2
    (fun loc ir ->
      match !ast_dump_format with
      | "json" ->
        Ast_utils.jsonify_net_ast (open_out (!basename ^ "." ^ loc ^ ".json")) ir
      | "pprint" ->
        Ast_utils.pprint_net_ast (open_out (!basename ^ "." ^ loc ^ ".ast")) ir
      | _ -> invalid_arg "Invalid ast-dump format")
    locs
    netir_l;
  match !backend with
  | "shm" ->
    let msg_module = (module Codegen.Msg_intf.Msg_chan_intf : Codegen.Msg_intf.M) in
    Codegen.Toplevel_shm.emit_toplevel_shm
      (open_out (!basename ^ ".ml"))
      msg_module
      locs
      netir_l
  | "http" ->
    let msg_module = (module Codegen.Msg_intf.Msg_http_intf : Codegen.Msg_intf.M) in
    let () = 
      match Lwt_main.run (Send_receive.init ()) with
      | Ok () -> ()
      | Error msg -> failwith ("Failed to initialize HTTP config: " ^ msg)
    in
    let dune_oc = open_out (Filename.dirname !basename ^ "/dune") in
    output_string dune_oc "(executables\n";
    output_string dune_oc (Printf.sprintf " (names %s)\n" 
      (String.concat " " (List.map (fun loc -> 
        Filename.basename (!basename ^ "_" ^ loc)) locs)));
    output_string dune_oc " (libraries http unix))\n";
    close_out dune_oc;
    List.iter2
      (fun loc ir ->
        let out_file = open_out (!basename ^ "_" ^ loc ^ ".ml") in
        output_string out_file "open Http\n\n";
        Codegen.Toplevel_shm.emit_toplevel_shm
          out_file
          msg_module
          [loc]
          [ir])
      locs
      netir_l
  | _ -> invalid_arg "Invalid backend"
;;