(** Type inference for Pirouette choreographies.
    
    This module implements type inference using a Hindley-Milner style algorithm
    with support for choreographic types. It infers types for both local 
    computations and choreographic expressions, ensuring type safety across
    distributed endpoints.
    
    {2 Type Inference Overview}
    
    Type inference proceeds in two levels:
    - {b Local level}: Pure computations (arithmetic, variables, pattern matching)
    - {b Choreographic level}: Communication and coordination (send, sync, location-qualified expressions)
    
    The inference algorithm:
    1. Traverses the AST recursively
    2. Generates fresh type variables for unknowns
    3. Collects type constraints
    4. Unifies constraints to find most general types
    5. Returns inferred type and substitution
    
    {2 Key Concepts}
    
    {b Type variables:} Placeholders for unknown types (e.g., ['a], ['b])
    
    {b Substitution:} Mapping from type variables to concrete types
    
    {b Context:} Environment mapping variable names to their types
    
    {b Unification:} Process of solving type equations
    
    {2 Example}
    
    {[
      (* Input choreography: *)
      x := [Alice] 5;
      y := [Bob] x + 1;
      send Bob y -> Alice
      
      (* Type inference determines: *)
      x : Alice.int
      y : Bob.int
      (* And verifies the send operation is well-typed *)
    ]} *)

(** Alias for Local AST module. *)
module Local = Ast_core.Local.M

(** Alias for Choreographic AST module. *)
module Choreo = Ast_core.Choreo.M

(** {1 Type System Types} *)

(** Error messages for type inference failures.
    
  Used to track and report type errors with descriptive messages. *)
type errmsg = string

(** Type variables for polymorphism.
    
  Represents unknown types during inference, typically named ['a], ['b], etc.
    
  {b Example:}
  {[
    (* Before inference: *)
    fun x -> x + 1
    (* Type: 'a -> 'a  (type variable 'a) *)
      
    (* After inference: *)
    (* Type: int -> int  (type variable resolved to int) *)
  ]} *)
type typvar = string

(** Free type variables with error tracking.
    
  Either [Ok] for a valid type variable or [Error] for a type error.
    
  The ['a] in [ftv] allows associating error information with type variables
  during inference. *)
type ftv = (typvar, errmsg) result

(** Substitution for local types.
    
  Maps type variables to local types. Represents solutions to type equations
  discovered during unification.
    
  {b Example:}
  {[
    (* Substitution: ['a → int, 'b → bool] *)
    [("'a", TInt); ("'b", TBool)]
      
    (* Applying this substitution to 'a -> 'b gives: int -> bool *)
  ]} *)
type local_subst = (typvar * ftv Local.typ) list

(** Substitution for choreographic types.
    
  Maps type variables to choreographic types, including location-qualified types.
    
  {b Example:}
  {[
    (* Substitution: ['a → Alice.int] *)
    [("'a", TLoc(LocId("Alice"), TInt))]
  ]} *)
type choreo_subst = (typvar * ftv Choreo.typ) list

(** Type context for local variables.
    
  Maps variable names to their inferred local types. Used during type inference
  to look up variable types.
    
  {b Example:}
  {[
    (* Context: {x: int, y: bool} *)
    [("x", TInt); ("y", TBool)]
  ]} *)
type local_ctx = (string * ftv Local.typ) list

(** Type context for choreographic variables.
    
  Maps variable names to their choreographic types (which may include
  location information).
    
  {b Example:}
  {[
    (* Context: {x: Alice.int, y: Bob.string} *)
    [("x", TLoc(LocId("Alice"), TInt)); 
      ("y", TLoc(LocId("Bob"), TString))]
  ]} *)
type choreo_ctx = (string * ftv Choreo.typ) list

(** Global context for location-qualified variables.
    
  Maps pairs of (location, variable) to local types. Used to track variables
  owned by specific locations.
    
  {b Structure:} [(location_name, variable_name, local_type)]
    
  {b Example:}
  {[
    (* Context: {Alice.x: int, Bob.y: string} *)
    [("Alice", "x", TInt); 
      ("Bob", "y", TString)]
  ]} *)
type global_ctx = (string * string * ftv Local.typ) list

(** {1 Type Inference Functions} *)

(** [infer_local_expr ctx expr] infers the type of a local expression.
    
    Performs type inference on pure local computations without communication.
    Returns a substitution and the inferred type.
    
    {b Parameters:}
    - [ctx]: Type context mapping variables to their types
    - [expr]: Local expression to type check
    
    {b Returns:}
    - Substitution discovered during inference
    - Inferred type for the expression 
    
    {b Raises:} Type error if expression is ill-typed*)
val infer_local_expr
  :  local_ctx
  -> ftv Ast_core.Local.M.expr
  -> local_subst * ftv Ast_core.Local.M.typ

(** [infer_local_pattern ctx pat] infers the type of a local pattern and
    extends the context with pattern variables.
    
    Analyzes pattern structure (variables, pairs, sum types) and returns:
    - Substitution from unification
    - Pattern's type
    - Extended context with pattern variables 
    
    {b Uses:} let-bindings and match expressions to bind pattern variables. *)
val infer_local_pattern
  :  local_ctx
  -> ftv Ast_core.Local.M.pattern
  -> local_subst * ftv Ast_core.Local.M.typ * local_ctx

(** [infer_choreo_expr ctx gctx expr] infers the type of a choreographic expression.
    
    Handles choreographic constructs including:
    - Location-qualified expressions ([[Alice] expr])
    - Communication (send, sync)
    - Control flow (if/then/else, match)
    - Functions and applications
    
    {b Parameters:}
    - [ctx]: Choreographic context
    - [gctx]: Global context for location-qualified variables
    - [expr]: Choreographic expression to type check
    
    {b Returns:}
    - Substitution from unification
    - Inferred choreographic type
    
    {b Raises:} Type error if choreography is ill-typed.*)
val infer_choreo_expr
  :  choreo_ctx
  -> global_ctx
  -> ftv Ast_core.Choreo.M.expr
  -> choreo_subst * ftv Ast_core.Choreo.M.typ

(** [infer_choreo_pattern ctx gctx pat] infers the type of a choreographic pattern.
    
    Handles patterns including:
    - Simple variables
    - Location-qualified patterns ([Alice.x])
    - Pairs and sum types
    
    {b Returns} extended choreographic context with pattern variables. *)
val infer_choreo_pattern
  :  choreo_ctx
  -> global_ctx
  -> ftv Ast_core.Choreo.M.pattern
  -> choreo_subst * ftv Ast_core.Choreo.M.typ * choreo_ctx

(** [infer_choreo_stmt ctx gctx stmt] infers the type of a choreographic statement.
    
    Handles:
    - Declarations ([x : Alice.int])
    - Assignments ([x := [Alice] 5])
    - Type definitions
    - Foreign declarations
    
    {b Returns} updated context with new bindings. *)
val infer_choreo_stmt
  :  choreo_ctx
  -> global_ctx
  -> ftv Ast_core.Choreo.M.stmt
  -> choreo_subst * ftv Ast_core.Choreo.M.typ * choreo_ctx

(** [infer_choreo_stmt_block ctx gctx stmts] infers types for a statement block.
    
    This is the main entry point for type checking a complete choreography.
    Processes statements sequentially, threading context through.
    
    {b Parameters:}
    - [ctx]: Initial choreographic context
    - [gctx]: Initial global context
    - [stmts]: List of choreographic statements
    
    {b Returns:}
    - Final substitution
    - Type of the last expression (typically unit)
    - Final context with all bindings 
    
    {b Raises:} Type error with descriptive message if choreography is ill-typed. *)
val infer_choreo_stmt_block
  :  choreo_ctx
  -> global_ctx
  -> ftv Ast_core.Choreo.M.stmt_block
  -> choreo_subst * ftv Ast_core.Choreo.M.typ * choreo_ctx

(*Functions below are included here to allow testings of these functions*)

(** {1 Utility Functions}
    
    The following functions are exposed for testing purposes. They implement
    core type inference operations used internally. *)

(** [unify_local] unifies two local types.
    
    Finds a substitution that makes [t1] and [t2] equal. Core of the type
    inference algorithm.
    
    {b Raises:} Type error if types cannot be unified. *)
val unify_local : ftv Local.typ -> ftv Local.typ -> local_subst

(** [unify_choreo] unifies two choreographic types.
    
    Like [unify_local] but handles location-qualified types. *)
val unify_choreo : ftv Choreo.typ -> ftv Choreo.typ -> choreo_subst

(** [apply_subst_typ_local] applies substitution to a local type.
    
    Replaces type variables with their bindings from substitution. *)
val apply_subst_typ_local : local_subst -> ftv Local.typ -> ftv Local.typ

(** [apply_subst_typ_choreo] applies substitution to a choreographic type.
    
    Like [apply_subst_typ_local] but for choreographic types. *)
val apply_subst_typ_choreo : choreo_subst -> ftv Choreo.typ -> ftv Choreo.typ

(** [extract_local_ctx] extracts local context for a specific location.
    
    Filters global context to variables belonging to [loc].
    
   {b Uses:} during endpoint projection to get relevant variables for each endpoint. *)
val extract_local_ctx : global_ctx -> string -> local_ctx

(** [get_choreo_subst] converts local substitution to 
    choreographic substitution for a location.
    
    Lifts local type bindings to location-qualified types. *)
val get_choreo_subst : local_subst -> ftv Local.loc_id -> choreo_subst

(** [get_choreo_ctx] converts local context to choreographic
    context for a location.
    
    Qualifies all types with the given location. *)
val get_choreo_ctx : local_ctx -> ftv Local.loc_id -> choreo_ctx

(** [get_local_subst] extracts local substitution for a
    specific location from choreographic substitution.
    
    Inverse of [get_choreo_subst]. *)
val get_local_subst : choreo_subst -> ftv Local.loc_id -> local_subst
