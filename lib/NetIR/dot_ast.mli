module MkDotAST (M : sig
  include Metainfo.Meta.Metainfo
end) : sig
  module AST : module type of Ast.MkAST (M)

  (**This module allows you to visualize an AST via DOT, a language that describes graphs. [generate_dot_code] will
  output a string of DOT code, which then can be written to a file or copied and visualized via the command line

  For a file: dot -Tsvg ast.dot > output.svg
  For a string: echo -e "digraph G { n0 [label=\"Emulated Loc Decl [test.ml: 1:15--1:16]\"];\nn0 -> n1;\nn1 [label=\"Name example [test.ml: 2:20--2:50]\"];\n }" | dot -Tsvg > output.svg
  

  Each function takes [string_of_info], this is the [Meta.string_of_mi] function.
  *)

  val node_counter : int ref
  (** Keeps track of the node number for generating node labels*)

  val generate_dot_code : (AST.m -> string) -> AST.program -> string
  (** [generate_dot_code string_of_info program] Entrypoint for the DOT
      generator. Generates DOT code for an AST

      - [program] is a list of decls.
      - Calls helper function [dot_decls] to generate the dot code for the list
        of decls in the program.
      - Resets the node counter to 0 so that the next call to
        [generate_node_name] will start from 0.
      - Returns: A string that represents the dot code for the decl list
        [program].*)

  val dot_decls : (AST.m -> string) -> AST.program -> string * string
  (** [dot_decls string_of_info program] generates DOT code for a list of
      declarations

      - [program] is a list of decls.
      - Calls helper function [dot_decl] to generate the dot code for the
        individual decls.
      - Returns: A tuple of strings where the first element is the dot code for
        the list of decls [decls] and the second element is the node name of the
        list of decls [decls]. [program].*)

  val dot_decl : (AST.m -> string) -> AST.decl -> string * string
  (** [dot_decl string_of_info decl] generates DOT code a single declaration.

      - [decl] is a decl.
      - Connects the decl node to its children.
      - Returns: A tuple of strings where the first element is the dot code for
        the decl [decl] and the second element is the node name of the decl
        [decl]. *)

  val dot_expr : (AST.m -> string) -> AST.expr -> string * string
  (** [dot_expr string_of_info expr] generates DOT code for an expression.

      - [expr] is an expr.
      - Connects the expr node to its children.
      - Returns: A tuple of strings where the first element is the dot code for
        the expr [expr] and the second element is the node name of the expr
        [expr]. *)

  val dot_pattern : (AST.m -> string) -> AST.pattern -> string * string
  (** [dot_pattern string_of_info pat] generates DOT code for a pattern.

      - [pat] is a pattern.
      - Connects the pat node to its children.
      - Returns: A tuple of strings where the first element is the dot code for
        the decl [decl] and the second element is the node name of the decl
        [decl].*)

  val dot_name : (AST.m -> string) -> AST.m * string -> string * string
  (** [dot_name string_of_info name] generates DOT code for a name tuple.

      - [name] is a tuple of info and string.
      - Returns: A tuple of strings where the first element is the dot code for
        the name and the second element is the node name of the name. *)

  val dot_lab : (AST.m -> string) -> AST.lab -> string * string
  (** [dot_lab string_of_info label] generates DOT code for a label.

      - [label] is a label.
      - Returns: A tuple of strings where the first element is the dot code for
        the label and the second element is the node name of the label. *)

  val dot_int : int -> string * string
  (** [dot_int int] generates DOT code for an integer literal.

      - Returns: A tuple of strings where the first element is the dot code for
        the integer node and the second element is its node name. *)

  val dot_float : float -> string * string
  (** [dot_float float] generates DOT code for a float literal.

      - Returns: A tuple of strings where the first element is the dot code for
        the float node and the second element is its node name. *)

  val dot_char : char -> string * string
  (** [dot_char char] generates DOT code for a character literal.

      - Returns: A tuple of strings where the first element is the dot code for
        the character node and the second element is its node name. *)

  val dot_string : string -> string * string
  (** [dot_string string] generates DOT code for a string literal.

      - Returns: A tuple of strings where the first element is the dot code for
        the string node and the second element is its node name. *)

  val dot_unop : (AST.m -> string) -> AST.unop -> string * string
  (** [dot_unop string_of_info unop] generates DOT code for a unary operator.

      - [unop] is a unary operator.
      - Returns: A tuple of strings where the first element is the dot code for
        the unop node and the second element is its node name. *)

  val dot_binop : (AST.m -> string) -> AST.binop -> string * string
  (** [dot_binop string_of_info binop] generates DOT code for a binary operator.

      - [binop] is a binary operator.
      - Returns: A tuple of strings where the first element is the dot code for
        the binop node and the second element is its node name. *)

  val dot_typ : (AST.m -> string) -> AST.typ -> string * string
  (** [dot_typ string_of_info typ] generates DOT code for a type expression.

      - [typ] is a type.
      - Returns: A tuple of strings where the first element is the dot code for
        the type node and the second element is its node name. *)
end
