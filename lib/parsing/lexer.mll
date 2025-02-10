{
  open Lexing
  open Parser

  exception SyntaxError of string

  (** [next_line lexbuf] advances the lexer to the next line in the input buffer.
    
    - This function increments the line number in the lexer buffer's current position
      and sets the beginning of line marker to the current position in the buffer.
    - It is typically called when a newline character is encountered in the input.
  *)
  let next_line lexbuf =
    let pos = lexbuf.lex_curr_p in
    lexbuf.lex_curr_p <- { pos with pos_lnum = pos.pos_lnum + 1; pos_bol = lexbuf.lex_curr_pos }
}

let digit = ['0'-'9']
let alpha = ['a'-'z' 'A'-'Z']
let white = [' ' '\t']+
let newline = '\r' | '\n' | "\r\n"

let integer = digit+
let float = (digit+ | '.' | digit+)
let identifier = (alpha | '_' ) (alpha | digit | '_')*

(** [read lexbuf] is the main lexer function that tokenizes the input based on the
    defined rules and patterns.
    
    - This function reads characters from the input buffer and matches them against
      predefined patterns to identify tokens such as identifiers, literals, operators,
      and keywords.
    - Returns: It returns a token each time it is called, until it reaches the end
      of the file, at which point it returns EOF.
    - Note: This function handles whitespace, comments, and newline characters
      internally, often recursively calling itself to skip over non-token characters.
*)
rule read = parse
  | white              { read lexbuf }
  | "--"               { read_single_line_comment lexbuf }
  | "{-"               { read_multi_line_comment lexbuf }
  | '('                { LPAREN }
  | ')'                { RPAREN }
  | '['                { LBRACKET }
  | ']'                { RBRACKET }
  | ','                { COMMA }
  | '.'                { DOT }
  | ':'                { COLON }
  | ';'                { SEMICOLON }
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
  | integer as s       { INT (int_of_string s) }
  | float as s         { FLOAT (float_of_string s)}
  | identifier as s    { ID (s) }
  | '"'                { read_string (Buffer.create 17) lexbuf }
  | newline            { next_line lexbuf; read lexbuf }
  | _                  { raise (SyntaxError ("Unexpected char: " ^ Lexing.lexeme lexbuf)) }
  | eof                { EOF }

(** [read_string buf] processes string literals recursively in the lexer.
    
    - This function reads characters from the input buffer and constructs a string
      literal token by concatenating the characters.
    - It handles escape sequences such as \n, \t, \r, \b, \f, and \\.
    - Raises a SyntaxError if an illegal escape sequence is encountered or if the
      string is not terminated.
*)
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

(** [read_single_line_comment] processes single-line comments in the lexer.
    
    - Continues to consume characters until a newline is encountered, then resumes normal lexing.
    - If EOF is reached during a comment, it returns an EOF token with metadata.
*)
and read_single_line_comment = parse
  | newline { next_line lexbuf; read lexbuf }
  | _       { read_single_line_comment lexbuf }
  | eof     { EOF }

(** [read_multi_line_comment] processes multi-line comments in the lexer.
    
    - Skips all characters within the comment boundaries until the closing delimiter is found.
    - Handles newlines within the comment to maintain accurate line tracking.
    - Raises a SyntaxError if EOF is reached without finding the closing delimiter.
*)
and read_multi_line_comment = parse
  | "-}"    { read lexbuf }
  | newline { next_line lexbuf; read_multi_line_comment lexbuf }
  | _       { read_multi_line_comment lexbuf }
  | eof     { raise (SyntaxError "Comment is not terminated") }
