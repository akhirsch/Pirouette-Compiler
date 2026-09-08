{
open Parser
}

let white = [' ' '\t']+

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