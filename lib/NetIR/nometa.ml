open Ast
include MkAST (Metainfo.Meta.TrivInfo)

(* Type smart constructors *)
let varty (x : string) = VarTy ((), ((), x))
let unitty = UnitTy ()
let intty = IntTy ()
let floatty = FloatTy ()
let charty = CharTy ()
let stringty = StringTy ()
let boolty = BoolTy ()
let funty t1 t2 = FunTy ((), t1, t2)
let locty ls = LocTy ((), List.map (fun s -> ((), s)) ls)

(* Pattern smart constructor *)
let wildcardpat = WildcardPat ()
let varpat x = VarPat ((), ((), x))
let unitlitpat = UnitLitPat ()
let intlitpat n = IntLitPat ((), n)
let floatlitpat f = FloatLitPat ((), f)
let charlitpat c = CharLitPat ((), c)
let stringlitpat s = StringLitPat ((), s)
let truelitpat = TrueLitPat ()
let falselitpat = FalseLitPat ()
let constructorpat n ps = ConstructorPat ((), ((), n), ps)
let locnamepat s = LocNamePat ((), ((), s))

(* Unary operation smart constructors *)
let neg = Neg ()
let not = Not ()

(* Binary operation smart constructors *)
let plus = Plus ()
let minus = Minus ()
let times = Times ()
let div = Div ()
let andop = And ()
let orop = Or ()
let eq = Eq ()
let neq = Neq ()
let lt = Lt ()
let leq = Leq ()
let gt = Gt ()
let geq = Geq ()

(* Label smart constructor *)
let mklab n = Label ((), n)

(* Expression smart constructors *)
let var x = Var ((), ((), x))
let unitlit = UnitLit ()
let intlit n = IntLit ((), n)
let floatlit f = FloatLit ((), f)
let charlit c = CharLit ((), c)
let stringlit s = StringLit ((), s)
let truelit = TrueLit ()
let falselit = FalseLit ()
let mkmatch d arms = Match ((), d, arms)
let recabs f x e = RecAbs ((), ((), f), ((), x), e)
let funapp f a = FunApp ((), f, a)
let typeconstr e t = TypeConstr ((), e, t)
let unop u e = Unop ((), u, e)
let mkneg = unop neg
let mknot = unop not
let binop o e1 e2 = Binop ((), o, e1, e2)
let mkplus = binop plus
let mkminus = binop minus
let mktimes = binop times
let mkdiv = binop div
let mkand = binop andop
let mkor = binop orop
let mkeq = binop eq
let mkneq = binop neq
let mklt = binop lt
let mkleq = binop leq
let mkgt = binop gt
let mkgeq = binop geq
let send e p = Send ((), e, ((), p))
let recv t p = Recv ((), t, ((), p))
let choosefor n l = ChooseFor ((), ((), n), l)
let allowchoice n arms = AllowChoice ((), ((), n), arms)

(* Declaration smart constructors *)
let emlocdecl l = EmulatedLocDecl ((), ((), l))
let typedecl x t = TypeDecl ((), ((), x), t)
let typealiasdecl x t = TypeAliasDecl ((), ((), x), t)
let defndecl x p e = DefnDecl ((), ((), x), p, e)
let importdecl x = ImportDecl ((), ((), x))

let variantdecl x conses =
  VariantDecl ((), ((), x), List.map (fun (s, l, t) -> (((), s), l, t)) conses)
