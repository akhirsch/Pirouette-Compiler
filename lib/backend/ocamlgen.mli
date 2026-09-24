open Ppxlib

module MkOcamlGen (Net : Netir.Ast.AST) : sig

  (** Convert a NetIR type into an OCaml core type. *)
  val type_gen : Net.typ -> core_type

  (** Convert a NetIR pattern into an OCaml pattern. *)
  val pattern_gen : Net.pattern -> pattern

  (** Convert a NetIR unary operator into its OCaml operator string. *)
  val unop_gen : Net.unop -> string

  (** Convert a NetIR binary operator into its OCaml operator string. *)
  val binop_gen : Net.binop -> string

  (** Extract the string representation of a NetIR label. *)
  val label_gen : Net.lab -> string

  (** Convert a NetIR expression into an OCaml expression. *)
  val expr_gen : Net.expr -> expression

end