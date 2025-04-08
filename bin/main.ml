open Http_pirc

let usage_msg = "USAGE: pirc <file> [-ast-dump <pprint|json|dot>] [-backend <shm|http>]"
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
    , Arg.Symbol ([ "pprint"; "json"; "dot" ], fun s -> ast_dump_format := s)
    , "Dump the AST in the specified format (pprint, json, dot)" )
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
   | "dot" -> 
      let string_of_info = Parsing.Parsed_ast.Pos_info.string_of_pos in
      Ast_utils.dot_choreo_ast (open_out (!basename ^ ".dot")) string_of_info program
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
      | "dot" ->
        (* Skip dot generation for network IR since it's not implemented yet *)
        ()
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
    List.iter2
      (fun loc ir ->
        let out_file = open_out (!basename ^ "_" ^ loc ^ ".ml") in
        output_string out_file "open Send_receive\n\n";
        Codegen.Toplevel_shm.emit_toplevel_shm out_file msg_module [ loc ] [ ir ])
      locs
      netir_l
  | _ -> invalid_arg "Invalid backend"
;;
