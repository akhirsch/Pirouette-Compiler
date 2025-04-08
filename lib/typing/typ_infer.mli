module Local = Ast_core.Local.M
module Choreo = Ast_core.Choreo.M

type errmsg = string
type typvar = string
type ftv = (typvar, errmsg) result
type local_subst = (typvar * ftv Local.typ) list
type choreo_subst = (typvar * ftv Choreo.typ) list
type local_ctx = (string * ftv Local.typ) list
type choreo_ctx = (string * ftv Choreo.typ) list
type global_ctx = (string * string * ftv Local.typ) list

val infer_local_expr
  :  local_ctx
  -> ftv Ast_core.Local.M.expr
  -> local_subst * ftv Ast_core.Local.M.typ

val infer_local_pattern
  :  local_ctx
  -> ftv Ast_core.Local.M.pattern
  -> local_subst * ftv Ast_core.Local.M.typ * local_ctx

val infer_choreo_expr
  :  choreo_ctx
  -> global_ctx
  -> ftv Ast_core.Choreo.M.expr
  -> choreo_subst * ftv Ast_core.Choreo.M.typ

val infer_choreo_pattern
  :  choreo_ctx
  -> global_ctx
  -> ftv Ast_core.Choreo.M.pattern
  -> choreo_subst * ftv Ast_core.Choreo.M.typ * choreo_ctx

val infer_choreo_stmt
  :  choreo_ctx
  -> global_ctx
  -> ftv Ast_core.Choreo.M.stmt
  -> choreo_subst * ftv Ast_core.Choreo.M.typ * choreo_ctx

val infer_choreo_stmt_block
  :  choreo_ctx
  -> global_ctx
  -> ftv Ast_core.Choreo.M.stmt_block
  -> choreo_subst * ftv Ast_core.Choreo.M.typ * choreo_ctx

(*Functions below are included here to allow testings of these functions*)
val unify_local : ftv Local.typ -> ftv Local.typ -> local_subst
val unify_choreo : ftv Choreo.typ -> ftv Choreo.typ -> choreo_subst
val apply_subst_typ_local : local_subst -> ftv Local.typ -> ftv Local.typ
val apply_subst_typ_choreo : choreo_subst -> ftv Choreo.typ -> ftv Choreo.typ
val extract_local_ctx : global_ctx -> string -> local_ctx
val get_choreo_subst : local_subst -> ftv Local.loc_id -> choreo_subst
val get_choreo_ctx : local_ctx -> ftv Local.loc_id -> choreo_ctx
val get_local_subst : choreo_subst -> ftv Local.loc_id -> local_subst
