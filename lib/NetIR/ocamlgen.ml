module type NetAST = Ast.AST

open Ppxlib
open Ast_builder.Default

module MkOcamlGen (Net : NetAST) = struct

  (* with this declared now i can write Net.___ avoiding name conflicts *)
  let loc = Location.none
  (* every node in ppxlib AST carries a location *)

  (*------------------- TYPE GENRATION ---------------------------*)
  (* type_gen returns a core_type because a NetIR type becomes an OCaml type node *)
  let rec type_gen (t : Net.typ) : core_type =
    match t with
    | Net.VarTy (_, (_, x)) -> ptyp_var ~loc x
    (* ptyp_var of string is a type variable such as 'a *)
    | Net.UnitTy _ -> [%type: unit]
    | Net.IntTy _ -> [%type: int]
    | Net.FloatTy _ -> [%type: float]
    | Net.CharTy _ -> [%type: char]
    | Net.StringTy _ -> [%type: string]
    | Net.BoolTy _ -> [%type: bool]
    | Net.FunTy (_, t1, t2) -> [%type: [%t type_gen t1] -> [%t type_gen t2]]
    | Net.LocTy (_, _) -> [%type: Dummybackend.location]

  (*------------------- PATTERN GENRATION ---------------------------*)
  (* Convert a NetIR pattern into an OCaml pattern *)
  let rec pattern_gen (p : Net.pattern) : pattern =
    match p with
    | Net.WildcardPat _ -> [%pat? _]
    | Net.VarPat (_, (_, x)) -> pvar ~loc x
    | Net.UnitLitPat _ -> [%pat? ()]
    | Net.IntLitPat (_, n) -> pint ~loc n
    | Net.FloatLitPat (_, f) -> pfloat ~loc (string_of_float f)
    (* ast builder wont take a float it will only take a string so you have to convert
    to get the float pattern *)
    | Net.CharLitPat (_, c) -> pchar ~loc c
    | Net.StringLitPat (_, s) -> pstring ~loc s
    | Net.TrueLitPat _ -> [%pat? true]
    | Net.FalseLitPat _ -> [%pat? false]
    | Net.LocLitPat (_, (_, l)) -> pstring ~loc l
    | Net.ConstructorPat (_, (_, n), ps) ->
        (* n = string
      ps = net.pattern list 
      Ocaml constructors must bc capatlized *)
        (*TODO: net_ because a constructor could possibly be names left and then that would change to left
      and then it would cause a problem here *)
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

  (*------------------- UNOP GENRATION ---------------------------*)
  (* Converts a NetIR unary operator into its OCaml expression *)
  let unop_gen (u : Net.unop) (e : expression) : expression =
    match u with Neg _ -> [%expr ~-[%e e]] | Not _ -> [%expr not [%e e]]

  (*------------------- BINOP GENRATION ---------------------------*)
  (* Convert a NetIR binary operator into its OCaml expression *)
  let binop_gen (b : Net.binop) (e1 : expression) (e2 : expression) : expression
      =
    match b with
    | Net.Plus _ -> [%expr [%e e1] + [%e e2]]
    | Net.Minus _ -> [%expr [%e e1] - [%e e2]]
    | Net.Times _ -> [%expr [%e e1] * [%e e2]]
    | Net.Div _ -> [%expr [%e e1] / [%e e2]]
    | Net.And _ -> [%expr [%e e1] && [%e e2]]
    | Net.Or _ -> [%expr [%e e1] || [%e e2]]
    | Net.Eq _ -> [%expr [%e e1] = [%e e2]]
    | Net.Neq _ -> [%expr [%e e1] <> [%e e2]]
    | Net.Lt _ -> [%expr [%e e1] < [%e e2]]
    | Net.Leq _ -> [%expr [%e e1] <= [%e e2]]
    | Net.Gt _ -> [%expr [%e e1] > [%e e2]]
    | Net.Geq _ -> [%expr [%e e1] >= [%e e2]]

  (*------------------- LABEL GENRATION ---------------------------*)
  (* label_gen extracts the raw string the call sites decide what node to make from it*)
  let label_gen (l : Net.lab) : string =
    (*type lab = Label of name 
    labels are their own type rather than bare strings,*)
    match l with
    | Net.Label (_, n) -> n

  (*------------------- EXPRESSION GENRATION ---------------------------*)
  (* Converts a NetIR expression into an OCaml expression *)
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
            (fun (pat, body) -> 
              case
                ~lhs:(pattern_gen pat) (* NetIR pattern -> OCaml pattern *)
                ~guard:None
                  (* NetIR's Match has no place to store a guard 
          type is Match of m * expr * (pattern * expr) list, each branch is a pattern paired with a body only *)
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
        [%expr
          let rec [%p pvar ~loc f] = fun [%p pvar ~loc x] -> [%e expr_gen e] in
          [%e evar ~loc f]]
    (*NetIR writes fun f x := e: an anonymous function that takes argument x, 
      has body e, and can call itself as f inside the body. 
      "Rec" for recursive, "Abs" for abstraction*)
    (* OCaml's grammar treats "the name being defined" as a pattern->f and
      "the name being used" as an expression-> e *)
    | Net.FunApp (_, f, a) -> [%expr [%e expr_gen f] [%e expr_gen a]]
    | Net.TypeConstr (_, e, t) -> [%expr ([%e expr_gen e] : [%t type_gen t])]
    | Net.Unop (_, u, e) -> unop_gen u (expr_gen e)
    | Net.Binop (_, b, e1, e2) -> binop_gen b (expr_gen e1) (expr_gen e2)
    (* Communication Primitives *)
    | Net.Send (_, e, (_, n)) ->
        [%expr Dummybackend.send [%e estring ~loc n] [%e expr_gen e]]
    (* Send e  to n, e is the payload and n is the name which holds a location *)
    | Net.Recv (_, t, (_, n)) ->
        [%expr (Dummybackend.recv [%e estring ~loc n] : [%t type_gen t])]
    (*of m * typ * name  Recv t from n *)
    | Net.ChooseFor (_, (_, n), l) ->
        [%expr
          Dummybackend.choose [%e estring ~loc n]
            [%e estring ~loc (label_gen l)]]
    (* a runtime call with a fixed text l is a Label of name *)
    (* works directly with AllowChoice *)
    | Net.AllowChoice (_, (_, n), bs) ->
        (*  refrence: zola site - Lesson 3 Program *)
        (* receiving from ChooseFor: one side chooses a label, the other allows a set and branches on which arrived *)
        let cases =
          (* cases maps each (label, body) pair in bs into one match branch:
           the label becomes a string-literal pattern on the left, the body becomes the expression on the right*)
          List.map
            (fun (lab, body) ->
              case
                ~lhs:(pstring ~loc (label_gen lab))
                  (* LHS: label being matched  *)
                ~guard:None ~rhs:(expr_gen body)) (* RHS: expression body *)
            bs
        in
        let fallback =
          case
          (*case: ~lhs ~guard ~rhs builder needed to build the ppxlib node through ast_builder *)
            ~lhs:[%pat? _]
            ~guard:None
            ~rhs:[%expr failwith "unexpected label"]
          (* the fail with case catch all _ for anything else *)
        in
        pexp_match ~loc
          (* pexp_match takes a case list, and case
        case: ~lhs ~guard ~rhs *)
          [%expr Dummybackend.recv_label [%e estring ~loc n]]
          (cases @ [ fallback ])
    | Net.AmI (_, e) -> [%expr [%e expr_gen e] = me]

  (*------------------- DECL GENRATION ---------------------------*)
  let decl_gen (d : Net.decl) : structure_item =
    match d with
    | Net.EmulatedLocDecl (_, (_, _l)) -> [%stri let a = ()] (*TODO*)
    (* JACKIE you have _l here so the warnings are supressed UNDO once prog_gen written *)
    (* Ocaml: emulated location Alice 
        This is not an ast node, this is the declaration that introduces a participant *)
    | Net.TypeDecl (_, (_, _n), _t) -> [%stri let a = ()] (*TODO*)
    (* JACKIE you have the n and t _ here so that the warnings are supressed 
          UNDO that change once you write program gen *)
    (* n: Name
         t: type  
      OCaml type declaration doesn't exist as a standalone item either disappears or fuses into the let 
      NetIR ex: three_to_alice : unit -> unit
       OCaml's .ml (structure) grammar has NO top-level form for a bare value signature
       and ppxlib has no Pstr_* constructor for it - can only exists in .mli files as Psig_value
       this decl has nothing to build into on its own.
       [] used here because the generated code still typechecks via inference *)
    | Net.TypeAliasDecl (_, (_, n), t) ->
        (* n: Name
         t: type  
      To declare an alias, use the type keyword followed by the new name, an equals sign, and the existing type expression)
      ex:
      type user_id = int *)
        let td =
          type_declaration ~loc (* type helper provided by ppx *)
            ~name:(Located.mk ~loc n)
              (* the string n bundled with the source location *)
              (* located.mk: location.make takes the string and does that bundling *)
            ~params:[] (* parameters also none here *)
            ~cstrs:[] (* this is for constraints, which there are none *)
            ~kind:Ptype_abstract
              (* kind is a type_kind which matches either  ptype_abstract ptype_variant or ptype_record 
        ~kind — does this type introduce new structure of its own, NO because its an alias not new
        Ptype_abstract (no, nothing new)
        Ptype_variant [...] (yes, these constructors — A | B of int)
        Ptype_record [...] (yes, these fields — { x : int }). *)
            ~private_:Public
              (* can either be private or public, i chose public *)
            ~manifest:(Some (type_gen t))
          (* manifest: is this equal to some other existing tyoe: YES thats an alias *)
          (* manifest actually gives that = sign *)
        in
          pstr_type ~loc Nonrecursive [ td ]
        (* pstr_type is how we build a a top level type
        the type will not refrence itself type apple = apple is pointless so this is non recursive *)
    | Net.DefnDecl (_, (_, id), ps, e) ->
        let body = List.fold_right
          (fun p mkfun -> [%expr fun [%p pattern_gen p] -> [%e mkfun]])
          ps (expr_gen e)
        in 
          [%stri let [%p Ast_builder.Default.pvar ~loc id] = [%e body]]
    | Net.ImportDecl (_, (_, n)) -> 
      let module_id = Ppxlib.Ast_builder.Default.pmod_ident ~loc 
        (Located.lident ~loc (String.capitalize_ascii n))
        (* include Mymodule 
        where the module or file that we are importing needs to be capitalized *)
      in
        [%stri include [%m module_id]]
    (* of m * name 
      let name = Located.lident ~loc (String.capitalize_ascii n) in 
      (* ocaml Module name must be capatlized *)
        Pstr_include ~loc (Pmod_ident name) 
       Ocaml include N *)
    | Net.VariantDecl (_, (_, n), cs) -> 
      (* val constructor_declaration :
      loc:location -> 
      name:string loc -> using Located.mk ~loc n (binding the location to the name)
      args:constructor_arguments -> res:core_type option -> constructor_declaration*)
      let constructor_gen ((_, cname),ts, _result) = 
        constructor_declaration 
        ~loc
        ~name: (Located.mk ~loc (String.capitalize_ascii cname)) (* constructor names bounded to the location and capatalized *)
        ~args: (Pcstr_tuple (List.map type_gen ts)) 
        (* will be a tuple the smart constructor looks like this 
        variantDecl "color"[("red", [], varty "color")] *)
        ~res: None
      in 
      let td = 
      (* val type_declaration :
    loc:location ->
    name:string loc ->
    params:(core_type * (variance * injectivity)) list ->
    cstrs:(core_type * core_type * location) list ->
    kind:type_kind ->
    private_:private_flag -> manifest:core_type option -> type_declaration*)
      type_declaration ~loc
      ~name: (Located.mk ~loc n)
      ~params: []
      ~cstrs: []
      ~kind: (Ptype_variant (List.map constructor_gen cs))
      ~private_: Public
      ~manifest: None
    in
    pstr_type ~loc Recursive [td]


  (*let program_gen (me : string) (prog : Net.program) : structure = [] *)
  (*List.concat_map decl_gen prog*)
  (*decl list*)
  (*TODO: preserve the type annotation by merging it into the matching DefnDecl's let,
       i.e. emit  let n : t = ...  should be done here i think , 
       which sees both decls by name.... i think*)
end
