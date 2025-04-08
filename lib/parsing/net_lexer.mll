{
  open Lexing
  open Net_parser

  exception SyntaxError of string

  (** [next_line lexbuf] advances the lexer to the next line in the input buffer. *)
  let next_line lexbuf =
    let pos = lexbuf.lex_curr_p in
    lexbuf.lex_curr_p <- { pos with pos_lnum = pos.pos_lnum + 1; pos_bol = lexbuf.lex_curr_pos }
}

let digit = ['0'-'9']
let alpha = ['a'-'z' 'A'-'Z']
let white = [' ' '\t']+
let newline = '\r' | '\n' | "\r\n"

let integer = digit+
let identifier = (alpha | '_' ) (alpha | digit | '_')*

(** [read lexbuf] is the main lexer function that tokenizes the input. *)
rule read = parse
  | white              { read lexbuf }
  | "--"               { read_single_line_comment lexbuf }
  | "{-"               { read_multi_line_comment lexbuf }
  | '('                { LPAREN }
  | ')'                { RPAREN }
  | ','                { COMMA }
  | '.'                { DOT }
  | ':'                { COLON }
  | ';'                { SEMICOLON }
  | "+."               { FPLUS }
  | "-."               { FMINUS }
  | "*."               { FTIMES }
  | "/."               { FDIV }
  | '+'                { PLUS }
  | '-'                { MINUS }
  | '*'                { TIMES }
  | '/'                { DIV }
  | "&&"               { AND }
  | "||"               { OR }
  | "="                { EQ }
  | "!="               { NEQ }
  | "<"                { LT }
  | "<="               { LEQ }
  | ">"                { GT }
  | ">="               { GEQ }
  | '|'                { BAR }
  | '_'                { UNDERSCORE }
  | ":="               { COLONEQ }
  | "->"               { ARROW }
  | "~>"               { TILDE_ARROW }
  | "unit"             { UNIT_T }
  | "int"              { INT_T }
  | "string"           { STRING_T }
  | "bool"             { BOOL_T }
  | "not"              { NOT }
  | "fun"              { FUN }
  | "type"             { TYPE }
  | "true"             { TRUE }
  | "false"            { FALSE }
  | "foreign"          { FOREIGN }
  | "if"               { IF }
  | "then"             { THEN }
  | "else"             { ELSE }
  | "match"            { MATCH }
  | "with"             { WITH }
  | "let"              { LET }
  | "in"               { IN }
  | "fst"              { FST }
  | "snd"              { SND }
  | "left"             { LEFT }
  | "right"            { RIGHT }
  | "send"             { SEND }
  | "recv"             { RECV }
  | "from"             { FROM }
  | "choose"           { CHOOSE }
  | "for"              { FOR }
  | "allow"            { ALLOW }
  | "choice"           { CHOICE }
  | "ret"              { RET }
  | integer as s       { INT (int_of_string s) }
  | identifier as s    { ID (s) }
  | '"'                { read_string (Buffer.create 17) lexbuf }
  | newline            { next_line lexbuf; read lexbuf }
  | _                  { raise (SyntaxError ("Unexpected char: " ^ Lexing.lexeme lexbuf)) }
  | eof                { EOF }

(** [read_string buf] processes string literals recursively in the lexer. *)
and read_string buf = parse
  | '"'       { STRING (Buffer.contents buf) }
  | '\\' ('/' | '\\' | 'b' | 'f' | 'n' | 'r' | 't' as esc)
    { let c = match esc with
        | '/'  -> '/'
        | '\\' -> '\\'
        | 'b'  -> '\b'
        | 'f'  -> '\012'
        | 'n'  -> '\n'
        | 'r'  -> '\r'
        | 't'  -> '\t'
        | _    -> assert false
      in Buffer.add_char buf c;
      read_string buf lexbuf
    }
  | [^ '"' '\\']+
    { Buffer.add_string buf (Lexing.lexeme lexbuf);
      read_string buf lexbuf
    }
  | _   { raise (SyntaxError ("Illegal string character: " ^ Lexing.lexeme lexbuf)) }
  | eof { raise (SyntaxError "String is not terminated") }

(** [read_single_line_comment] processes single-line comments in the lexer. *)
and read_single_line_comment = parse
  | newline { next_line lexbuf; read lexbuf }
  | _       { read_single_line_comment lexbuf }
  | eof     { EOF }

(** [read_multi_line_comment] processes multi-line comments in the lexer. *)
and read_multi_line_comment = parse
  | "-}"    { read lexbuf }
  | newline { next_line lexbuf; read_multi_line_comment lexbuf }
  | _       { read_multi_line_comment lexbuf }
  | eof     { raise (SyntaxError "Comment is not terminated") }