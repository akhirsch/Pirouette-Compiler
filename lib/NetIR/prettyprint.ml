module MkPrettify (A : Ast.AST) = struct
  open A

  let prettify_location_names ns =
    let rec go = function [] -> "" | (_, n) :: ns -> ", " ^ n ^ go ns in
    match ns with [] -> "{}" | (_, n) :: ns -> "{" ^ n ^ go ns ^ "}"

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
    | LocTy (_, ns) -> Printf.sprintf "location %s" (prettify_location_names ns)

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
    | LocNamePat (_, (_, n)) -> "[[" ^ n ^ "]]"

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

  let prettify_lab (Label (_, n)) = "[" ^ n ^ "]"

  let prettify_expr e =
    let rec prettify_int_expr is_int e =
      let mkparens is_int s = if is_int then "(" ^ s ^ ")" else s in
      match e with
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
            "| " ^ prettify_pattern p ^ " := " ^ prettify_int_expr false e
          in
          let pe = prettify_int_expr false e in
          let parms =
            List.fold_left (fun s (p, e) -> s ^ "\n" ^ prettify_arm p e) "" pes
          in
          mkparens is_int ("match " ^ pe ^ " with" ^ parms ^ "\nend")
      | RecAbs (_, (_, f), (_, x), e) ->
          mkparens is_int
            ("fun " ^ f ^ " " ^ x ^ " := " ^ prettify_int_expr false e)
      | FunApp (_, f, a) ->
          prettify_int_expr true f ^ " " ^ prettify_int_expr true a
      | TypeConstr (_, e, t) ->
          mkparens is_int (prettify_int_expr false e ^ " : " ^ prettify_typ t)
      | Unop (_, u, e) ->
          mkparens is_int (prettify_unop u ^ prettify_int_expr false e)
      | Binop (_, b, e1, e2) ->
          let pe1 = prettify_int_expr false e1 in
          let pb = prettify_binop b in
          let pe2 = prettify_int_expr false e2 in
          mkparens is_int (pe1 ^ " " ^ pb ^ " " ^ pe2)
      | Send (_, e, (_, n)) ->
          let pe = prettify_int_expr false e in
          mkparens is_int ("send " ^ pe ^ " to " ^ n)
      | Recv (_, t, (_, n)) ->
          let pt = prettify_typ t in
          mkparens is_int ("recv " ^ pt ^ " from " ^ n)
      | ChooseFor (_, (_, n), l) ->
          let pl = prettify_lab l in
          mkparens is_int ("choose " ^ pl ^ " for " ^ n)
      | AllowChoice (_, (_, n), bs) ->
          let prettify_arm p e =
            "| " ^ prettify_lab p ^ " => " ^ prettify_int_expr false e
          in
          let parms =
            List.fold_left (fun s (p, e) -> s ^ "\n" ^ prettify_arm p e) "" bs
          in
          mkparens is_int ("allow " ^ n ^ " choice " ^ parms ^ "\nend")
    in
    prettify_int_expr false e

  let prettify_decl = function
    | EmulatedLocDecl (_, (_, l)) -> "emulated location " ^ l
    | TypeDecl (_, (_, n), t) -> n ^ " : " ^ prettify_typ t
    | TypeAliasDecl (_, (_, n), t) -> "type " ^ n ^ " := " ^ prettify_typ t
    | DefnDecl (_, (_, n), ps, e) ->
        let prettify_patterns ps =
          match ps with
          | [] -> " "
          | p :: ps ->
              " "
              ^ List.fold_left
                  (fun s p -> s ^ " " ^ prettify_pattern p)
                  (prettify_pattern p) ps
              ^ " "
        in
        n ^ prettify_patterns ps ^ ":= " ^ prettify_expr e
    | ImportDecl (_, (_, n)) -> "import " ^ n
    | VariantDecl (_, (_, n), cs) ->
        let prettify_cons (_, n) ts t =
          match ts with
          | [] -> "| " ^ n ^ " : " ^ prettify_typ t
          | t1 :: ts ->
              "| " ^ n ^ " : "
              ^ List.fold_left
                  (fun s t -> s ^ " -> " ^ prettify_typ t)
                  (prettify_typ t1) ts
              ^ " -> " ^ prettify_typ t
        in
        "data " ^ n ^ " :="
        ^ List.fold_left
            (fun s1 (n, ts, t) -> s1 ^ "\n" ^ prettify_cons n ts t)
            "" cs

  let prettify_prog = function
    | [] -> ""
    | d :: ds ->
        List.fold_left
          (fun s d -> s ^ "\n" ^ prettify_decl d)
          (prettify_decl d) ds
end
