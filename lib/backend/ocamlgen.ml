open Ppxlib
open Ast_builder.Default

(* TODO: JACKIE ** TURN THIS INTO A FUNCTOR so that we can use any AST *)
(* steps: defining the input module type (signature), writing the functor
 structure, and instantiating (applying) the functor.*)
module MkOcamlGen (Net : Netir.Ast.AST) = struct
  

(* with this declared now i can write Net.___ avoiding name conflicts *)

let loc = Location.none
(* every node in ppxlib AST carries a location *)

(* type_gen returns a core_type because a NetIR type becomes an OCaml type node *)
let rec type_gen (t : Net.typ) : core_type =
  match t with
    | Net.VarTy (_, (_, x)) ->  ptyp_var ~loc x
    (* ptyp_var of string   a type variable such as 'a *)
    | Net.UnitTy _ -> [%type: unit]
    | Net.IntTy _ -> [%type: int]
    | Net.FloatTy _ -> [%type: float]
    | Net.CharTy _ -> [%type: char]
    | Net.StringTy _ -> [%type: string]
    | Net.BoolTy _ -> [%type: bool]
    | Net.FunTy (_, t1, t2) -> [%type: [%t type_gen t1] -> [%t type_gen t2]]
    | Net.LocTy (_, _) ->  [%type: string]
    

let rec pattern_gen p = 
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
      (* converting each netIR argument pattern to ocaml pattern node *)
      let args =
      match converted_ps with
      | [] -> None
      | [ p ] -> Some p
      | many -> Some (ppat_tuple ~loc many)
      (* ocaml constructors arguments stores arguements as a pattern 
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
      | Net.TrueLit _ -> [%expr true]
      | Net.FalseLit _ -> [%expr false]
      | Net.LocLit (_, (_, n)) -> estring ~loc n 
      | Net.Match (_, e, pes) -> 
      (* Turn each NetIR (pattern, body) pair into one OCaml match arm (a [case]).
       ~lhs is the pattern (left of ->), 
       ~rhs the body (right of ->),
       ~guard is the optional [when] clause — NetIR has none, so always None. *)
        let cases = 
          List.map 
          (fun (pat, body) -> case
          ~lhs:( pattern_gen pat) (* NetIR pattern -> OCaml pattern *)
          ~guard: None (* NetIR's Match has no place to store a guard. Its type is Match of m * expr * (pattern * expr) list — each arm is a pattern paired with a body only *)
          (* A guard is the when cond you can attach to an OCaml arm *)
          ~rhs:(expr_gen body)) (* NetIR body expr -> OCaml expr *)
          pes
        in
        pexp_match ~loc (expr_gen e) cases
        (* pexp_match takes a case list, and case
        case: ~lhs ~guard ~rhs builder just fills in those three fields. 
        So a match node is a subject expression "e" plus a case list 
        That's why in the Match arm you build a list of cases and hand it over where each element is one | p -> e*)
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
       (* Send e  to n, e is the payload and n is the name which holds a location *)
      | Net.Recv (_, t, (_, n)) -> [%expr (Dummybackend.recv [%e estring ~loc n] : [%t type_gen t])]
      (*of m * typ * name  Recv t from n *)
      | Net.ChooseFor (_, (_, n), l) -> [%expr Dummybackend.choose
        [%e estring ~loc n] [%e estring ~loc (label_gen l)]]
      (* a runtime call with a fixed text l is a Label of name *)
      (* works directly with AllowChoice *)
      | Net.AllowChoice (_, (_, n), bs) -> 
        (*  zola site - Lesson 3 Program *)
        (* receiving from ChooseFor: one side chooses a label, the other allows a set and branches on which arrived *)
        let cases =
          (* cases maps each (label, body) pair in bs into one match arm:
           the label becomes a string-literal pattern on the left, the body becomes the expression on the right*)
          List.map (fun (lab, body) -> case 
            ~lhs:(pstring ~loc (label_gen lab)) (* LHS: label being matched  *)
            ~guard:None 
            ~rhs:(expr_gen body)) (* RHS: expression body *)
            bs
          in
            let fallback = case 
            ~lhs:[%pat? _] 
            ~guard:None
            ~rhs:[%expr failwith "unexpected label"]
            in
        pexp_match ~loc
          [%expr Dummybackend.recv_label [%e estring ~loc n]]
          (cases @ [ fallback ])
      | Net.AmI (_, e) -> [%expr [%e expr_gen e] = me]
      (*of m * expr
      DO I NEED TO? fix this amI is dependent on the dummybackend *)
      (* AmI e asks "is the location e the one running this file?" 
      generated file already knows who it is from the let me = "Alice" binding that program_gen puts at the top*)
      
  
    (*let decl_gen d =
      match d with 
      | EmulatedLocDecl (_, (_, l)) -> failwith "TODO" (*[%p (pstring ~loc (label_gen l))]*)
      (*of m * name*)
      | TypeDecl (_, (_, n), t) -> failwith "TODO"
      (*of m * name * typ  Declares the type of a program binding *)
      | TypeAliasDecl (_, (_, n), t) -> failwith "TODO"
      (* of m * name * typ *)
      | DefnDecl (_, (_, n), ps, e) -> failwith "TODO"
      (* of m * name * pattern list * expr 
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
        n ^ prettify_patterns ps ^ ":= " ^ prettify_expr e*)
      | ImportDecl (_, (_, n)) -> failwith "TODO"
      (* of m * name *)
      | VariantDecl (_, (_, n), cs) -> failwith "TODO"
        (*let prettify_cons (_, n) ts t =
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
      of m * name * (name * typ list * typ) list *)

    type program = decl list*)

      end