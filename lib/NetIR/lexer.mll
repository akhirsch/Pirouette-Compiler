{
open Parser

exception SyntaxError of string
}

let white = [' ' '\t']+
let digit = ['0'-'9']
let int = '-'? digit+
let caps = ['A'-'Z']
let alpha = ['a'-'z' 'A'-'Z']
let location = (caps) (caps | digit)* 
(* We disallow underscores in location literals because otherwise we could not distinguish '_1' as being a
  typical variable, or a location. This distinction is also why locations are forced to be all capitals. *)
let identifier = (alpha | '_') (alpha | digit | '_')*

rule read =
  parse
  | white { read lexbuf }
  (* Types *)
  | "unit" { UNITTY }
  | "int" { INTTY }
  | "float" { FLOATTY }
  | "char" { CHARTY }
  | "string" { STRINGTY }
  | "bool" { BOOLTY }
  | "location" { LOCTY }
  (* Unops *)
  | "!" { NOT }
  (* Binops *)
  | "+" { PLUS }
  | "-" { MINUS }
  | "*" { TIMES }
  | "/" { DIV }
  | "&&" { AND }
  | "||" { OR }
  | "==" { EQ }
  | "!=" { NEQ }
  | "<" { LT }
  | "<=" { LEQ }
  | ">" { GT }
  | ">=" { GEQ }
  (* Patterns and Expressions *)
  | "true" { TRUELIT }
  | "false" { FALSELIT }
  | "->" { ARROW }
  | "=>" { DOUBLEARROW } (* TODO Discuss/approve token name*)
  | "_" { WILDCARD }
  | "(" { LPAREN }
  | "[" { LBRACK }
  | "{" { LBRACE }
  | ")" { RPAREN }
  | "]" { RBRACK}
  | "}"  {RBRACE }
  | "|" { BAR }
  | "'" { read_char lexbuf }
  | '"' { read_string (Buffer.create 16) lexbuf }
  | ":=" { WALRUS } (* TODO Discuss/approve token name*)
  | ":" { COLON }
  | "match" { MATCH }
  | "with" { WITH }
  | "end" { END }
  | "fun" { FUN }
  | "send" { SEND }
  | "to" { TO }
  | "recv" { RECV }
  | "from" { FROM }
  | "choose" { CHOOSE }
  | "for" { FOR }
  | "allow" { ALLOW }
  | "choice" { CHOICE }
  | "AmI" { AMI }
  (* Declarations *)
  | "emulated location" { EMULATEDLOCDECL }
  | "type" { TYPEDECL }
  | "import" { IMPORT }
  | "data" { DATA }
  | int { INTLIT (int_of_string (Lexing.lexeme lexbuf)) }
  | identifier as s { ID s }
  | location as s { LOCLIT s }
  | eof { EOF }
  | _  { raise (SyntaxError ("Unexpected token: " ^ (Lexing.lexeme lexbuf))) }

and read_char = parse
  | "\\n'"              { CHARLIT ('\n') }
  | "\\t'"              { CHARLIT ('\t') }
  | "\\''"              { CHARLIT ('\'') }
  | "\\\\'"             { CHARLIT ('\\') }
  | eof                 { raise (SyntaxError "Character literal is not terminated") }
  | '\\' _              { raise (SyntaxError ("Unknown escape sequence: " ^ (Lexing.lexeme lexbuf)))}
  | ([^ '\''] as c) "'" { CHARLIT (c) }
  | _                   { raise (SyntaxError ("Invalid character literal: " ^ (Lexing.lexeme lexbuf)))}
  (* TODO Verify that the catch-all case has an appropriate error message.
    EX. 'fo' does not produce the error message "Invalid character literal: f" *)

and read_string strbuf = parse 
  | "\""            { STRINGLIT (Buffer.contents strbuf) }
  | "\\n"           { Buffer.add_char strbuf '\n'; read_string strbuf lexbuf }
  | "\\t"           { Buffer.add_char strbuf '\t'; read_string strbuf lexbuf }
  | "\\\\"          { Buffer.add_char strbuf '\\'; read_string strbuf lexbuf }
  | "\\\""          { Buffer.add_char strbuf '"';  read_string strbuf lexbuf }
  | "\\" _          { raise (SyntaxError ("Unknown escape sequence: " ^ (Lexing.lexeme lexbuf)))} 
  | [^ '"' '\\']+   { Buffer.add_string strbuf (Lexing.lexeme lexbuf); 
                        read_string strbuf lexbuf }
  | eof             { raise (SyntaxError "String is not terminated") }
