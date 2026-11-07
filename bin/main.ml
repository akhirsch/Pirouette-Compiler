open Lexing
module Prettyprint = Netir.Prettyprint.MkPrettify (Netir.Ast.PosInfo_AST)
module Meta = Metainfo.Meta.PosInfo
module DotAST = Netir.Dot_ast.MkDotAST (Netir.Ast.PosInfo_AST)
module Ocamlgen = struct end
(* PLACEHOLDER: Once the ocamlgen has been implemented, this will be filled in *)

let _PLACEHOLDER = fun a -> a

let usage_msg =
  "pirouette [<file> | -input <input_string>] [-o <output>] [--pretty]"

let verbose = ref false
let pretty = ref false
let dot = ref false
let input_filename = ref None
let input_string = ref ""
let output_file = ref ""

let get_file filename =
  (*we only want to allow for one file*)
  match !input_filename with
  | None -> input_filename := Some filename
  | Some _ -> raise (Arg.Bad "only one input file allowed")

let speclist =
  [
    ("-v", Arg.Set verbose, "Output debug information");
    ("--verbose", Arg.Set verbose, "Output debug information");
    ("-i", Arg.Set_string input_string, "Input string of code");
    ("--input", Arg.Set_string input_string, "Input string of code");
    ("-o", Arg.Set_string output_file, "Set output file name");
    ("--output", Arg.Set_string output_file, "Set output file name");
    ("-p", Arg.Set pretty, "Pretty-print output");
    ("--pretty", Arg.Set pretty, "Pretty-print output");
    ("-d", Arg.Set dot, "Output DOT code");
    ("--dot", Arg.Set dot, "Output DOT code");
  ]

let get_decls lexbuf =
  let returned = Netir.Parser.program Netir.Lexer.read lexbuf in
  Netir.Parsed_ast_processing.process_parsed_ast returned

let prettify lexbuf = Prettyprint.prettify_prog (get_decls lexbuf)

let get_dot lexbuf =
  DotAST.generate_dot_code Meta.string_of_mi (get_decls lexbuf)

let compiler_output (ast : lexbuf) =
  if !pretty then prettify ast
  else if !dot then get_dot ast
  else
    let _ocaml_ast = _PLACEHOLDER ast in
    (*PLACEHOLDER: replace with something like Ocamlgen.generate_ocaml *)
    Format.asprintf "Ocamlgen Placeholder"
(*  "%a@." Ppxlib.Pprintast.structure ocaml_ast     <----- Insert this once ocamlgen is implemented *)

let run_compiler (ast : lexbuf) =
  (*If the --pretty flag was given, output the pretty printed code instead of the generated ocaml.*)
  let output = compiler_output ast in
  match !output_file with
  (*change output_file to an output stream, stdout for default*)
  | "" -> print_string output
  | f ->
      let output_in_folder = f in
      let oc = open_out output_in_folder in
      output_string oc output;
      close_out oc

let _run_compiler_with_error_messaging (lexbuf : lexbuf) =
  match Netir.Parser.program Netir.Lexer.read lexbuf with
  | exception Netir.Parser.Error ->
      let position = lexbuf.Lexing.lex_curr_p in
      Printf.eprintf "Syntax error in %s at line %d, column %d: %s\n"
        position.Lexing.pos_fname position.Lexing.pos_lnum
        (position.Lexing.pos_cnum - position.Lexing.pos_bol)
        (Lexing.lexeme lexbuf);
      exit 1
  | _ -> run_compiler lexbuf
  | exception Netir.Lexer.SyntaxError msg ->
      let position = lexbuf.Lexing.lex_curr_p in
      Printf.eprintf "Lexer error at %s:%d:%d: %s\n" position.Lexing.pos_fname
        position.Lexing.pos_lnum
        (position.Lexing.pos_cnum - position.Lexing.pos_bol)
        msg

let () =
  Arg.parse speclist get_file usage_msg;
  (* Main functionality here *)
  match !input_filename with
  | None -> (
      match !input_string with
      | "" -> failwith "missing input file"
      | _input -> (
          match !verbose with
          | true ->
              _run_compiler_with_error_messaging (Lexing.from_string _input)
          | false -> run_compiler (Lexing.from_string _input)))
  | Some _infile -> (
      match !input_string with
      | "" -> (
          let content =
            In_channel.with_open_text _infile In_channel.input_all
          in
          match !verbose with
          | true ->
              _run_compiler_with_error_messaging (Lexing.from_string content)
          | false -> run_compiler (Lexing.from_string content))
      | _ ->
          failwith
            "can't take an input file and an input string at the same time")
