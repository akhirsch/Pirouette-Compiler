open Lexing

let spf = Printf.sprintf

let string_of_pos pos =
  let l = string_of_int pos.pos_lnum
  and c = string_of_int (pos.pos_cnum - pos.pos_bol) in
  spf "[Ln %s, Col %s]" l c

let parse_with_error (input_filename : string) (lexbuf : Lexing.lexbuf) =
  try Parser.prog Lexer.read lexbuf with
  | Lexer.SyntaxError msg ->
      failwith
        (spf "Syntax error at [%s]: %s: %s" input_filename
           (string_of_pos lexbuf.lex_start_p)
           msg)
  | Parser.Error ->
      failwith
        (spf "Parse error at [%s]:  %s" input_filename
           (string_of_pos lexbuf.lex_start_p))

let parse_net_with_error lexbuf =
  try Net_parser.prog Net_lexer.read lexbuf with
  | Net_lexer.SyntaxError msg ->
      failwith
        (spf "Syntax error at %s: %s" (string_of_pos lexbuf.lex_start_p) msg)
  | Net_parser.Error ->
      let token = Lexing.lexeme lexbuf in
      let pos = lexbuf.lex_start_p in
      let pos_str = string_of_pos pos in
      let input_str = Bytes.to_string lexbuf.lex_buffer in
      let line_num = pos.pos_lnum in
      let col_num = pos.pos_cnum - pos.pos_bol in
      (* Split input into lines *)
      let lines = String.split_on_char '\n' input_str in
      let line =
        if line_num - 1 < List.length lines then List.nth lines (line_num - 1)
        else ""
      in
      let prev_line =
        if line_num - 2 >= 0 && line_num - 2 < List.length lines then
          List.nth lines (line_num - 2)
        else ""
      in
      let next_line =
        if line_num < List.length lines then List.nth lines line_num else ""
      in
      (* Build caret marker *)
      let caret = String.make col_num ' ' ^ "^" in
      let context =
        String.concat "\n"
          (List.filter
             (fun s -> s <> "")
             [
               (if prev_line <> "" then "Previous: " ^ prev_line else "");
               "Error:    " ^ line;
               "          " ^ caret;
               (if next_line <> "" then "Next:     " ^ next_line else "");
             ])
      in
      failwith
        (spf "Parse error at %s with token '%s'.\n%s\n" pos_str token context)
