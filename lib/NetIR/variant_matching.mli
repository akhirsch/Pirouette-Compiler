module MkVariantMatching : functor (A : Ast.AST) -> sig
    val get_variant_tables : A.program -> (string -> string list option) * (string -> string option)
end