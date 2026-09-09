{
open Parser
}

let white = [' ' '\t']+
let digit = ['0'-'9']
let int = '-'? digit+
let alpha = ['a'-'z' 'A'-'Z']

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
  | ")" { RPAREN }
  | "]" { RBRACK}
  | "|" { BAR }
  | "'" { APO }
  | "\"" { QUOTE }
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
  | "emulated location" { EMULATEDLOC }
  | "type" { TYPEDECL }
  | "import" { IMPORT }
  | "data" { DATA }
  | int { INTLIT (int_of_string (Lexing.lexeme lexbuf)) }
  | identifier as s {ID s}
  | eof { EOF }
