{
open Parser
}

let white = [' ' '\t']+
let digit = ['0'-'9']
let int = '-'? digit+

rule read =
  parse
  | white { read lexbuf }
  (* Types *)
  | "unit" { UNIT }
  | "int" { INT }
  | "float" { FLOAT }
  | "char" { CHAR }
  | "string" { STRING }
  | "bool" { BOOL }
  | "location" { LOCATION }
  (* Unops *)
  | "-" { NEG }
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
  | "true" { TRUE }
  | "false" { FALSE }
  | "->" { } (* TODO *)
  | "=>" { } (* TODO *)
  | "_" { WILDCARD }
  | "(" { LPAREN }
  | "[" { LBRACK }
  | ")" { RPAREN }
  | "]" { RBRACK}
  | "|" { BAR }
  | "'" { APO }
  | "\"" { QUOTE }
  | ":=" { } (* TODO *)
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
  | "type" { TYPE }
  | "import" { IMPORT }
  | "data" { DATA }
  | int { INT (int_of_string (Lexing.lexeme lexbuf)) }
  | eof { EOF }
