(** Parsed AST with position information for error reporting.
    
    This module provides AST types that include source code position information,
    used immediately after parsing. These types mirror the core AST structures
    from [Ast_core] but carry [Pos_info.t] metadata instead of unit [()] for
    tracking source locations.
    
    {1 Overview}
    
    Position information enables:
    - Accurate error messages showing line and column numbers
    - IDE features like jump-to-definition and hover information
    - Better debugging during type checking and compilation
    
    {1 Compilation Pipeline}
    
    {v
      Source text  →  Parser  →  Parsed_ast  →  Type Checker  →  Ast_core
      (with positions)           (with unit metadata)
                                 
      If errors occur, position info shows where in the source
    v}
    
    After type checking, position information is typically discarded and the
    AST is converted to {!ast_core} types with unit metadata. *)

(**{1 Position Information}*)

(** Position information for a node in the AST.*)
module Pos_info : sig
  (** Position information for a node in the AST.
      
      Tracks the source location of syntax elements for error reporting.
      
      {b Example:}
      {[
        (* For the code: "x := [Alice] 5" at line 3, columns 0-16 *)
        { fname = "source.pir"
        ; start = (3, 0)
        ; stop = (3, 16)
        }
      ]} *)
  type t =
    { fname : string (** Source File name *)
    ; start : int * int (** Start position: (line, column) *)
    ; stop : int * int (** Stop position: (line, column) *)
    }

  (** [string_of_pos] converts position information to a human-readable string.
      
      Used for displaying error messages with source locations.
      
      {b Example:}
      {[
        let pos = { fname = "source.pir"; start = (3, 0); stop = (3, 16) } in
        string_of_pos pos
        (* Returns: "source.pir:3:0-16" *)
      ]} *)
  val string_of_pos : t -> string
end

(**{1 Local AST Types with Position Info}*)

(** Local AST types with position information.
      
      These types are identical to [Ast_core.Local.M] but carry [Pos_info.t]
      metadata for tracking source locations. Used for local computations
      without choreographic constructs. *)
module Local : sig
  type nonrec value = Pos_info.t Ast_core.Local.M.value
  type nonrec loc_id = Pos_info.t Ast_core.Local.M.loc_id
  type nonrec var_id = Pos_info.t Ast_core.Local.M.var_id
  type nonrec typ_id = Pos_info.t Ast_core.Local.M.typ_id
  type nonrec sync_label = Pos_info.t Ast_core.Local.M.sync_label
  type nonrec un_op = Pos_info.t Ast_core.Local.M.un_op
  type nonrec bin_op = Pos_info.t Ast_core.Local.M.bin_op
  type nonrec typ = Pos_info.t Ast_core.Local.M.typ
  type nonrec pattern = Pos_info.t Ast_core.Local.M.pattern
  type nonrec expr = Pos_info.t Ast_core.Local.M.expr

  (** {2 Position Information Accessors} *)

  (** [get_info_value v] extracts position information from a value.
      
      {b Example:}
      {[
        let v = Local.M.Int(42, pos) in
        let pos_info = get_info_value v in
        (* pos_info contains the source location of "42" *)
      ]} *)
  val get_info_value : value -> Pos_info.t

  (** [get_info_locid] extracts position information from a location identifier [loc_id]. *)
  val get_info_locid : loc_id -> Pos_info.t

  (** [get_info_varid] extracts position information from a variable identifier [var_id]. *)
  val get_info_varid : var_id -> Pos_info.t

  (** [get_info_typid] extracts position information from a type identifier [type_id]. *)
  val get_info_typid : typ_id -> Pos_info.t

  (** [get_info_unop] extracts position information from a unary operator [un_op]. *)
  val get_info_unop : un_op -> Pos_info.t

  (** [get_info_binop] extracts position information from a binary operator [bin_op]. *)
  val get_info_binop : bin_op -> Pos_info.t

  (** [get_info_typ] extracts position information from a type.
      
      Useful for type error reporting to show where the problematic type appears. *)
  val get_info_typ : typ -> Pos_info.t

  (** [get_info_pattern p] extracts position information from a pattern. *)
  val get_info_pattern : pattern -> Pos_info.t

  (** [get_info_expr e] extracts position information from an expression. *)
  val get_info_expr : expr -> Pos_info.t

  (**{2 Position Information Setters}*)

  (** [set_info_value] updates the position information in a value. *)
  val set_info_value : Pos_info.t -> value -> value

  (** [set_info_locid] updates the position information in a location identifier. *)
  val set_info_locid : Pos_info.t -> loc_id -> loc_id

  (** [set_info_varid] updates the position information in a variable identifier. *)
  val set_info_varid : Pos_info.t -> var_id -> var_id

  (** [set_info_typid] updates the position information in a type identifier. *)
  val set_info_typid : Pos_info.t -> typ_id -> typ_id

  (** [set_info_unop] updates the position information in a unary operator. *)
  val set_info_unop : Pos_info.t -> un_op -> un_op

  (** [set_info_binop] updates the position information in a binary operator. *)
  val set_info_binop : Pos_info.t -> bin_op -> bin_op

  (** [set_info_typ] updates the position information in a type. *)
  val set_info_typ : Pos_info.t -> typ -> typ

  (** [set_info_pattern] updates the position information in a pattern. *)
  val set_info_pattern : Pos_info.t -> pattern -> pattern

  (** [set_info_expr] updates the position information in an expression. *)
  val set_info_expr : Pos_info.t -> expr -> expr
end

(**{1 Choreo AST Types with Position Info}*)

(** Choreographic AST types with position information.
      
      These types are identical to [Ast_core.Choreo.M] but carry [Pos_info.t]
      metadata for tracking source locations. Used for choreographic programs
      before endpoint projection. *)
module Choreo : sig
  type nonrec typ = Pos_info.t Ast_core.Choreo.M.typ
  type nonrec pattern = Pos_info.t Ast_core.Choreo.M.pattern
  type nonrec expr = Pos_info.t Ast_core.Choreo.M.expr
  type nonrec stmt = Pos_info.t Ast_core.Choreo.M.stmt
  type nonrec stmt_block = stmt list

  (** {2 Position Information Accessors} *)

  (** [get_info_typ] extracts position information from a choreographic type. *)
  val get_info_typ : typ -> Pos_info.t

  (** [get_info_pattern] extracts position information from a choreographic pattern. *)
  val get_info_pattern : pattern -> Pos_info.t

  (** [get_info_expr] extracts position information from a choreographic expression.*)
  val get_info_expr : expr -> Pos_info.t

  (** [get_info_stmt] extracts position information from a choreographic statement. *)
  val get_info_stmt : stmt -> Pos_info.t

  (** {2 Position Information Setters} *)

  (** [set_info_typ] updates the position information in a choreographic type. *)
  val set_info_typ : Pos_info.t -> typ -> typ

  (** [set_info_pattern] updates the position information in a choreographic pattern. *)
  val set_info_pattern : Pos_info.t -> pattern -> pattern

  (** [set_info_expr] updates the position information in a choreographic expression. *)
  val set_info_expr : Pos_info.t -> expr -> expr

  (** [set_info_stmt] updates the position information in a choreographic statement. *)
  val set_info_stmt : Pos_info.t -> stmt -> stmt
end

(**{1 NetIR AST Types with Position Info}*)

(** Network IR AST types with position information.
      
      These types are identical to [Ast_core.Net.M] but carry [Pos_info.t]
      metadata for tracking source locations. Used for network IR after
      endpoint projection. *)
module Net : sig
  type nonrec typ = Pos_info.t Ast_core.Net.M.typ
  type nonrec expr = Pos_info.t Ast_core.Net.M.expr
  type nonrec stmt = Pos_info.t Ast_core.Net.M.stmt
  type nonrec stmt_block = stmt list

  (** {2 Position Information Accessors} *)

  (** [get_info_typ] extracts position information from a network type. *)
  val get_info_typ : typ -> Pos_info.t

  (** [get_info_expr] extracts position information from a network expression. *)
  val get_info_expr : expr -> Pos_info.t

  (** [get_info_stmt s] extracts position information from a network statement. *)
  val get_info_stmt : stmt -> Pos_info.t

  (** {2 Position Information Setters} *)

  (** [set_info_typ] updates the position information in a network type. *)
  val set_info_typ : Pos_info.t -> typ -> typ

  (** [set_info_expr] updates the position information in a network expression. *)
  val set_info_expr : Pos_info.t -> expr -> expr

  (** [set_info_stmt] updates the position information in a network statement. *)
  val set_info_stmt : Pos_info.t -> stmt -> stmt
end
