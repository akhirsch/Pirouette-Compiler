module Pos_info : sig
  type t =
    { fname : string
    ; start : int * int
    ; stop : int * int
    }

  val string_of_pos : t -> string
end

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

  val get_info_value : value -> Pos_info.t
  val get_info_locid : loc_id -> Pos_info.t
  val get_info_varid : var_id -> Pos_info.t
  val get_info_typid : typ_id -> Pos_info.t
  val get_info_unop : un_op -> Pos_info.t
  val get_info_binop : bin_op -> Pos_info.t
  val get_info_typ : typ -> Pos_info.t
  val get_info_pattern : pattern -> Pos_info.t
  val get_info_expr : expr -> Pos_info.t
  val set_info_value : Pos_info.t -> value -> value
  val set_info_locid : Pos_info.t -> loc_id -> loc_id
  val set_info_varid : Pos_info.t -> var_id -> var_id
  val set_info_typid : Pos_info.t -> typ_id -> typ_id
  val set_info_unop : Pos_info.t -> un_op -> un_op
  val set_info_binop : Pos_info.t -> bin_op -> bin_op
  val set_info_typ : Pos_info.t -> typ -> typ
  val set_info_pattern : Pos_info.t -> pattern -> pattern
  val set_info_expr : Pos_info.t -> expr -> expr
end

module Choreo : sig
  type nonrec typ = Pos_info.t Ast_core.Choreo.M.typ
  type nonrec pattern = Pos_info.t Ast_core.Choreo.M.pattern
  type nonrec expr = Pos_info.t Ast_core.Choreo.M.expr
  type nonrec stmt = Pos_info.t Ast_core.Choreo.M.stmt
  type nonrec stmt_block = stmt list

  val get_info_typ : typ -> Pos_info.t
  val get_info_pattern : pattern -> Pos_info.t
  val get_info_expr : expr -> Pos_info.t
  val get_info_stmt : stmt -> Pos_info.t
  val set_info_typ : Pos_info.t -> typ -> typ
  val set_info_pattern : Pos_info.t -> pattern -> pattern
  val set_info_expr : Pos_info.t -> expr -> expr
  val set_info_stmt : Pos_info.t -> stmt -> stmt
end

module Net : sig
  type nonrec typ = Pos_info.t Ast_core.Net.M.typ
  type nonrec expr = Pos_info.t Ast_core.Net.M.expr
  type nonrec stmt = Pos_info.t Ast_core.Net.M.stmt
  type nonrec stmt_block = stmt list

  val get_info_typ : typ -> Pos_info.t
  val get_info_expr : expr -> Pos_info.t
  val get_info_stmt : stmt -> Pos_info.t
  val set_info_typ : Pos_info.t -> typ -> typ
  val set_info_expr : Pos_info.t -> expr -> expr
  val set_info_stmt : Pos_info.t -> stmt -> stmt
end
