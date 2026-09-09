open Ppxlib
open Ast_builder.Default

module Net  = Netir.Nometa

(* with this declared now i can write N.___ avoiding name conflicts *)

let loc = Location.none

(* <raw NetIR constructor pattern>  ->  <ppxlib [%…] quotation> *) 
(* type_gen returns a core_type because a NetIR type becomes an OCaml type node *)
let rec type_gen (t : Net.typ) : core_type =
  match t with
    | Net.VarTy (_, ((), x)) ->  ptyp_constr ~loc (Located.lident ~loc x) []
    (* type called x, not the type whose name is in the variable x *)
    | Net.UnitTy _ -> [%type: unit]
    | Net.IntTy _ -> [%type: int]
    | Net.FloatTy _ -> [%type: float]
    | Net.CharTy _ -> [%type: char]
    | Net.StringTy _ -> [%type: string]
    | Net.BoolTy _ -> [%type: bool]
   (* | Net.FunTy ((), t1, t2) -> ([%type: unit], [%type: t1], [%type: t2]) *)
    | Net.FunTy (_, t1, t2) -> [%type: [%t type_gen t1] -> [%t type_gen t2]]
    | Net.LocTy (_, _) ->  [%type: string]
    
(* return *)
let rec pattern_gen (p : Net.pattern) : pattern = 
  match p with 
    | Net.WildcardPat _ -> [%pat? _]
    | Net.VarPat (_, (_, x)) -> pvar ~loc x
    | Net.UnitLitPat _ -> [%pat? ()]
    | Net.IntLitPat (_, n) -> pint ~loc n
    | Net.FloatLitPat (_, f) -> pfloat ~loc (string_of_float f)
    | Net.CharLitPat (_, c) -> pchar ~loc c
    | Net.StringLitPat (_, s) -> pstring ~loc s
    | Net.TrueLitPat _ -> [%pat? true]
    | Net.FalseLitPat _ -> [%pat? false]
    | Net.LocLitPat (_, (_, l)) -> pstring ~loc l
    | Net.ConstructorPat (_, (_, n), ps) ->  ppat_any ~loc n 
    (*from prettyprinter
    let s =
          List.fold_left (fun s' p -> s' ^ " " ^ prettify_pattern p) "" ps
        in
        n ^ s*)
    | Net.LocNamePat (_, (_, s)) -> pvar ~loc s
    (*(_, (_, n)) -> "[[" ^ n ^ "]]"*)

  let unop_gen ( u : Net.unop) : string =
    match u with 
    | Net.Neg _ ->  "-"
    | Net.Not _ ->  "!"
    (* this can return a string *)

  let binop_gen ( b : Net.binop) : string =
   match b with 
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

  let label_gen (l : Net.lab) : string = (*(Label (_, n)) = "[" ^ n ^ "]"*)
    match l with 
    | Label _ -> pstring ~loc l 
(* *)
  
  let expr_gen (e : Net.expr) : expression = 
    match e with 
      | Var (_, (_, n)) -> [%expr n]
      | UnitLit _ -> [%expr ()]
      | IntLit (_, x) -> [%expr x]
      | FloatLit (_, f) -> efloat ~loc (string_of_float f)
  (*TODO: THIS IS WHERE YOU LEFT OFF 09/09 *)
      | CharLit (_, c) -> "'" ^ String.make 1 c ^ "'"
      | StringLit (_, s) -> "\"" ^ s ^ "\""
      | TrueLit _ -> "true"
      | FalseLit _ -> "false"
      | LocLit (_, (_, n)) -> n
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
      | AmI (_, e) -> "AmI " ^ prettify_int_expr true e
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


  