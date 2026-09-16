open Ppxlib
open Ast_builder.Default

module Net  = Netir.Nometa

(* with this declared now i can write Net.___ avoiding name conflicts *)

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
    | Net.ConstructorPat (_, (_, n), ps) -> 
      (* n = string
      ps = net.pattern list 
      Ocaml constructors must bc capatlized *)
      let name = Located.lident ~loc (String.capitalize_ascii n) in
      (* Located.lident wraps the string as the identifier that ppat_construct is expecting
      Ppat_construct of Longident.t Asttypes.loc * (string Asttypes.loc list * pattern) option *)
      let converted_ps = List.map pattern_gen ps in
      (* converting each netIR arguement pattern to ocaml pattern node *)
      let args =
      match converted_ps with
      | [] -> None
      | [ p ] -> Some p
      | many -> Some (ppat_tuple ~loc many)
      (* ocaml constructors arguements stores arguements as a pattern 
      none, one and tuple *)
        in
        ppat_construct ~loc name args
    
    | Net.LocNamePat (_, (_, s)) -> pvar ~loc s
    

  let unop_gen ( u : Net.unop) : string =
    match u with 
    | Net.Neg _ ->  "-"
    | Net.Not _ ->  "!"
    (* this can return a string *)

  let binop_gen ( b : Net.binop) : string =
    (* binop doesnt need ppxlib at all because it only exists as part of an 
    expression similar use in the prettyprinter note how prettify_binop
    reutrns a string and prettify_expr is what puts it between the operands*)
   match b with 
    | Net.Plus _ -> "+"
    | Net.Minus _ -> "-"
    | Net.Times _ -> "*"
    | Net.Div _ -> "/"
    | Net.And _ -> "&&"
    | Net.Or _ -> "||"
    | Net.Eq _ -> "="
    | Net.Neq _ -> "<>"
    | Net.Lt _ -> "<"
    | Net.Leq _ -> "<="
    | Net.Gt _ -> ">"
    | Net.Geq _ -> ">="

  let label_gen (l : Net.lab) : string = (*(Label (_, n)) = "[" ^ n ^ "]"*)
    match l with 
    | Net.Label (_,n) -> n

  
  let rec expr_gen (e : Net.expr) : expression = 
    match e with 
      | Net.Var (_, (_, n)) -> evar ~loc n
      | Net.UnitLit _ -> [%expr ()]
      | Net.IntLit (_, x) -> eint ~loc x
      | Net.FloatLit (_, f) -> efloat ~loc (string_of_float f)
      | Net.CharLit (_, c) -> echar ~loc c 
      | Net.StringLit (_, s) -> estring ~loc s 
      | Net.TrueLit _ -> estring ~loc "true"
      | Net.FalseLit _ -> estring ~loc "false"
      | Net.LocLit (_, (_, n)) -> estring ~loc n 
      | Net.Match (_, e, pes) -> 
                  (*  LHS, RHS *)
        let cases = 
          List.map 
          (fun (pat, body) -> case
          ~lhs:( pattern_gen pat)
          ~guard: None
          ~rhs:(expr_gen body))
          pes
        in
        pexp_match ~loc (expr_gen e) cases
      | Net.RecAbs (_, (_, f), (_, x), e) -> 
        [%expr let rec [%p pvar ~loc f] = fun [%p pvar ~loc x] -> 
          [%e expr_gen e] in 
          [%e evar ~loc f]] 
      (*NetIR writes fun f x := e: an anonymous function that takes argument x, 
      has body e, and can call itself as f inside the body. 
      "Rec" for recursive, "Abs" for abstraction*)
      (* OCaml's grammar treats "the name being defined" as a pattern->f and
      "the name being used" as an expression-> e *)
      | Net.FunApp (_, f, a) -> [%expr [%e expr_gen f] [%e expr_gen a]]
      | Net.TypeConstr (_, e, t) -> [%expr ([%e expr_gen e] : [%t type_gen t])]
      | Net.Unop (_, u, e) -> [%expr [%e evar ~loc(unop_gen u)] [%e expr_gen e]]
      (*of M.t * unop * expr*)
      | Net.Binop (_, b, e1, e2) ->
        [%expr [%e evar ~loc (binop_gen b)] [%e expr_gen e1] [%e expr_gen e2]]
      (*of M.t * binop * expr * expr*)
    (* Communication Primitives *)
      | Net.Send (_, e, (_, n)) -> [%expr Dummybackend.send [%e estring ~loc n] [%e expr_gen e]]
       (* Send e  to n 
       e is the payload and n is the name which holds a location *)
      | Net.Recv (_, t, (_, n)) -> [%expr (Dummybackend.recv [%e estring ~loc n] : [%t type_gen t])]
      (*of m * typ * name  Recv t from n *)
      | Net.ChooseFor (_, (_, n), l) -> [%expr Dummybackend.choose
        [%e estring ~loc n] [%e estring ~loc (label_gen l)]]
      (* a runtime call with a fixed text 
      l is the lab which is a Label of name *)
      | Net.AllowChoice (_, (_, n), bs) -> 
        (*  LHS, RHS *)
        let parms = 
          List.map 
          (fun (lab, body) -> case
          ~lhs:(pstring ~loc (label_gen lab))
          ~guard: None
          ~rhs:(expr_gen body))
          bs
        in
        pexp_match ~loc (pattern_gen parms)
      [%expr Dummybackend.recv_label [%e estring ~loc n]]
        pexp_match ~loc (expr_gen e)
        (* this is not a runtime call this is a match 
        | _ -> failwith "unexpected label" makes the match exhaustive.*)
      | Net.AmI (_, e) -> [%expr expr_gen ~loc e]
      (*of m * expr*)


  