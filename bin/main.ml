open Lexing
module Prettyprint = Netir.Prettyprint.MkPrettify(Netir.Ast.MkAST(Metainfo.Meta.PosInfo)) (* Todo: ensure this is the correct module structure *)
module Ocamlgen = struct end (* PLACEHOLDER: Once the ocamlgen has been implemented, this will be filled in *)

let _PLACEHOLDER = (fun a -> a)

let usage_msg = "pirouette [<file> | -input <input_string>] [-o <output>] [--pretty]"
let verbose = ref false
let pretty = ref false
let input_filename = ref None
let input_string = ref ""
let output_file = ref ""
let output = ref ""


let get_file filename = (*we only want to allow for one file*)
  match !input_filename with
  | None -> 
    input_filename := Some filename;
  | Some _ -> raise (Arg.Bad "only one input file allowed")


let speclist =
  [ ("-v",        Arg.Set verbose, "Output debug information");
    ("--verbose", Arg.Set verbose, "Output debug information");
    ("-i",        Arg.Set_string input_string, "Input string of code");
    ("--input",   Arg.Set_string input_string, "Input string of code");
    ("-o",        Arg.Set_string output_file, "Set output file name");
    ("--output",  Arg.Set_string output_file, "Set output file name");
    ("-p",        Arg.Set pretty, "Pretty-print output");
    ("--pretty",  Arg.Set pretty, "Pretty-print output") ]

let run_compiler ast = 
  (*if the --pretty flag was given, pretty print code to console.
    otherwise, print result to output file *)
  output := 
    if !pretty then
      _PLACEHOLDER ast (*PLACEHOLDER: the function should be something like Prettyprint.pp_program *)
    else begin
      let ocaml_ast = _PLACEHOLDER ast in (*PLACEHOLDER: replace with something like Ocamlgen.generate_ocaml *)
      Format.asprintf "PLACEHOLDER" (*  "%a@." Ppxlib.Pprintast.structure ocaml_ast     <----- Insert this once ocamlgen is implemented *) 

    end;

  match !output_file with (*change output_file to an output stream, stdout for default*)
  | "" -> print_string !output
  | f -> 
    let output_in_folder = f in
    let oc = open_out output_in_folder in
    output_string oc !output;
    close_out oc    


let run_compiler_with_error_messaging lexbuf = 
  (match _PLACEHOLDER (* Netir.Parser.prog Netir.Lexer.read *) lexbuf with
    | ast -> run_compiler ast
    | exception placeholder (*Netir.Parser.Error*) ->
      (**)
      let position = lexbuf.Lexing.lex_curr_p in
      Printf.eprintf "Syntax error in %s at line %d, column %d: %s\n"
          position.Lexing.pos_fname
          position.Lexing.pos_lnum
          (position.Lexing.pos_cnum - position.Lexing.pos_bol)
          (Lexing.lexeme lexbuf);
        exit 1
    | exception placeholder (*Netir.Lexer.SyntaxError msg*) ->
      let position = lexbuf.Lexing.lex_curr_p in
      Printf.eprintf "Lexer error at %s:%d:%d: %s\n"
          position.Lexing.pos_fname
          position.Lexing.pos_lnum
          (position.Lexing.pos_cnum - position.Lexing.pos_bol)
          msg;)

let () =
  Arg.parse speclist get_file usage_msg;
  (* Main functionality here *)
  match !input_filename with
  | None -> 
    (match !input_string with
    | "" -> failwith "missing input file"
    | input -> (*the flag "-input" allows the user to run the compiler on an input string of code*)
      let lexbuf = Lexing.from_string input in
      run_compiler_with_error_messaging lexbuf)
  | Some infile -> 
    (match !input_string with
    | "" -> 
      let file_ic = open_in infile in
      let lexbuf = Lexing.from_channel file_ic in
      (*lex and parse the code to generate an ast*)
      run_compiler_with_error_messaging lexbuf;
      close_in file_ic;
    | _ -> failwith "can't take an input file and an input string at the same time")
    
    
    
      

  
    