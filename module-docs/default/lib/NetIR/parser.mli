
(* The type of tokens. *)

type token = 
  | WITH
  | WILDCARD
  | WALRUS
  | UNITTY
  | UNITLIT
  | TYPEDECL
  | TRUELIT
  | TO
  | TIMES
  | STRINGTY
  | STRINGLIT of (string)
  | SEND
  | SEMICOLON
  | RPAREN
  | RECV
  | RBRACK
  | RBRACE
  | PLUS
  | OR
  | NOT
  | NEQ
  | MINUS
  | MATCH
  | LT
  | LPAREN
  | LOCTY
  | LOCLIT of (string)
  | LEQ
  | LBRACK
  | LBRACE
  | INTTY
  | INTLIT of (int)
  | IMPORT
  | ID of (string)
  | GT
  | GEQ
  | FUN
  | FROM
  | FOR
  | FLOATTY
  | FLOATLIT of (float)
  | FALSELIT
  | EQ
  | EOF
  | END
  | EMULATEDLOCDECL
  | DOUBLEARROW
  | DIV
  | DATA
  | COMMA
  | COLON
  | CHOOSE
  | CHOICE
  | CHARTY
  | CHARLIT of (char)
  | BOOLTY
  | BAR
  | ARROW
  | AND
  | AMI
  | ALLOW

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val program: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.PosInfo_AST.program)
