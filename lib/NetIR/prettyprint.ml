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

  let rec prettify_pattern = function
    | WildcardPat _ -> "_"
    | VarPat (_, (_, n)) -> n
    | UnitLitPat _ -> "()"
    | IntLitPat (_, x) -> string_of_int x
    | FloatLitPat (_, x) -> string_of_float x
    | CharLitPat (_, c) -> "'" ^ String.make 1 c ^ "'"
    | StringLitPat (_, s) -> "\"" ^ s ^ "\""
    | TrueLitPat _ -> "true"
    | FalseLitPat _ -> "false"
    | ConstructorPat (_, (_, n), ps) ->
        let s =
          List.fold_left (fun s' p -> s' ^ " " ^ prettify_pattern p) "" ps
        in
        n ^ s

  let prettify_unop = function Neg _ -> "-" | Not _ -> "!"

  let prettify_binop = function
    | Plus _ -> "+"
    | Minus _ -> "-"
    | Times _ -> "*"
    | Div _ -> "/"
    | And _ -> "&&"
    | Or _ -> "||"
    | Eq _ -> "=="
    | Neq _ -> "!="
    | Lt _ -> "<"
    | Leq _ -> "<="
    | Gt _ -> ">"
    | Geq _ -> ">="

  let rec prettify_int_expr = function
    | Var (_, (_, n)) -> n
    | UnitLit _ -> "()"
    | IntLit (_, x) -> string_of_int x
    | FloatLit (_, f) -> string_of_float f
    | CharLit (_, c) -> "'" ^ String.make 1 c ^ "'"
    | StringLit (_, s) -> "\"" ^ s ^ "\""
    | TrueLit _ -> "true"
    | FalseLit _ -> "false"
    | Match (_, e, pes) ->
        let prettify_arm p e =
          "| " ^ prettify_pattern p ^ " := " ^ prettify_expr e
        in
        let pe = prettify_expr e in
        let parms =
          List.fold_left (fun s (p, e) -> s ^ "\n" ^ prettify_arm p e) "" pes
        in
        "(match " ^ pe ^ " with" ^ parms ^ "\nend)"
    | RecAbs (_, (_, f), (_, x), e) ->
        "(fun " ^ f ^ " " ^ x ^ " := " ^ prettify_expr e ^ ")"
    | FunApp (_, f, a) -> prettify_int_expr f ^ " " ^ prettify_int_expr a
    | TypeConstr (_, e, t) ->
        "(" ^ prettify_expr e ^ " : " ^ prettify_typ t ^ ")"
    | Unop (_, u, e) -> "(" ^ prettify_unop u ^ prettify_int_expr e ^ ")"
    | Binop (_, b, e1, e2) ->
        let pe1 = prettify_int_expr e1 in
        let pb = prettify_binop b in
        let pe2 = prettify_int_expr e2 in
        "(" ^ pe1 ^ " " ^ pb ^ " " ^ pe2 ^ ")"

  and prettify_expr = function
    | Var (_, (_, n)) -> n
    | UnitLit _ -> "()"
    | IntLit (_, x) -> string_of_int x
    | FloatLit (_, f) -> string_of_float f
    | CharLit (_, c) -> "'" ^ String.make 1 c ^ "'"
    | StringLit (_, s) -> "\"" ^ s ^ "\""
    | TrueLit _ -> "true"
    | FalseLit _ -> "false"
    | Match (_, e, pes) ->
        let prettify_arm p e =
          "| " ^ prettify_pattern p ^ " := " ^ prettify_expr e
        in
        let pe = prettify_expr e in
        let parms =
          List.fold_left (fun s (p, e) -> s ^ "\n" ^ prettify_arm p e) "" pes
        in
        "match " ^ pe ^ " with" ^ parms ^ "\nend"
    | RecAbs (_, (_, f), (_, x), e) ->
        "fun " ^ f ^ " " ^ x ^ " := " ^ prettify_expr e
    | FunApp (_, f, a) -> prettify_int_expr f ^ " " ^ prettify_int_expr a
    | TypeConstr (_, e, t) ->
        "(" ^ prettify_expr e ^ " : " ^ prettify_typ t ^ ")"
    | Unop (_, u, e) -> prettify_unop u ^ prettify_int_expr e
    | Binop (_, b, e1, e2) ->
        let pe1 = prettify_int_expr e1 in
        let pb = prettify_binop b in
        let pe2 = prettify_int_expr e2 in
        pe1 ^ " " ^ pb ^ " " ^ pe2

  let prettify_decl _ = failwith "implement me"
  let prettify_prog _ = failwith "implement me"
end
