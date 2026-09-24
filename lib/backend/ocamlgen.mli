open Ppxlib

(** OCaml code generation

    This module defines the interface for translating NetIR constructs into
    OCaml AST nodes using Ppxlib. The generator is implemented as a functor so
    that it can operate over any module satisfying the NetIR AST interface.

    The corresponding [.ml] file contains the implementation of these
    translations, while this [.mli] file exposes the functions available to
    other modules. *)
module MkOcamlGen (Net : Netir.Ast.AST) : sig
  val type_gen : Net.typ -> core_type
  (** Convert a NetIR type into an OCaml core type *)

  val pattern_gen : Net.pattern -> pattern
  (** Convert a NetIR pattern into an OCaml pattern *)

  val unop_gen : Net.unop -> expression -> expression
  (** Convert a NetIR unary operator into its OCaml operator string *)

  val binop_gen : Net.binop -> expression -> expression -> expression
  (** Convert a NetIR binary operator into its OCaml operator string *)

  val label_gen : Net.lab -> string
  (** Extract the string representation of a NetIR label *)

  val expr_gen : Net.expr -> expression
  (** Convert a NetIR expression into an OCaml expression *)

  (* TODO: decl_gen/ prog_gen *)
end
