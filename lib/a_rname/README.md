# Notes on our alpha renaming

Alpha renaming is a process in functional programming which renames variables in a function without changing the function's semantics.

For example: [let x = y] is semantically equivalent to [let z = y]

For a compiler, we do this to standardize variable names for easier processing. For Pirouette specifically, we do this to ensure IDs are non-conflicting with OCaml


Our alpha renaming function [ast_list_alpha_rename], located within [rename.ml], works by walking the abstract 
syntax tree passed into it by [main.ml], and appending to all user-defined identifiers a suffix of "_PIROUETTE_USR_ID". 

Every identifier, excluding domains, is renamed

For example:

{[
	ast_local_pattern_alpha_rename Var(VarId("x", ()), ())
]}
returns:
{[
	Var(VarId("x_PIROUETTE_ID", ()), ())

]}