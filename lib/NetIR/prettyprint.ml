module MkPrettify (A : Ast.AST) = struct
  open A

  let rec prettify_typ = function
    | VarTy (_, (_, n)) -> n
    | UnitTy _ -> "unit"
    | IntTy _ -> "int"
    | FloatTy _ -> "float"
    | CharTy _ -> "char"
    | StringTy _ -> "string"
    | BoolTy _ -> "bool"
    | FunTy (_, t1, t2) ->
      Printf.sprintf "%s -> %s" (prettify_typ t1) (prettify_typ t2)

  let prettify_pattern _ = failwith "implement me"
  let prettify_unop = function Neg _ -> "-" | Not _ -> "~"
  let prettify_binop _ = failwith "implement me"
  let prettify_expr _ = failwith "implement me"
  let prettify_decl _ = failwith "implement me"
  let prettify_prog _ = failwith "implement me"
end 
