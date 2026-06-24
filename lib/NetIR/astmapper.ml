open Ast

module ASTMapper (A1 : AST) (A2 : AST) = struct
  let name_map (f : A1.m -> A2.m) (n : A1.name) : A2.name =
    let m, s = n in
    (f m, s)

  let rec typ_map (f : A1.m -> A2.m) = function
    | A1.VarTy (m, n) -> A2.VarTy (f m, name_map f n)
    | A1.UnitTy m -> A2.UnitTy (f m)
    | A1.IntTy m -> A2.IntTy (f m)
    | A1.FloatTy m -> A2.FloatTy (f m)
    | A1.CharTy m -> A2.CharTy (f m)
    | A1.StringTy m -> A2.StringTy (f m)
    | A1.BoolTy m -> A2.BoolTy (f m)
    | A1.FunTy (m, t1, t2) -> A2.FunTy (f m, typ_map f t1, typ_map f t2)

  let rec pattern_map (f : A1.m -> A2.m) = function
    | A1.WildcardPat m -> A2.WildcardPat (f m)
    | A1.VarPat (m, n) -> A2.VarPat (f m, name_map f n)
    | A1.UnitLitPat m -> A2.UnitLitPat (f m)
    | A1.IntLitPat (m, i) -> A2.IntLitPat (f m, i)
    | A1.FloatLitPat (m, d) -> A2.FloatLitPat (f m, d)
    | A1.CharLitPat (m, c) -> A2.CharLitPat (f m, c)
    | A1.StringLitPat (m, s) -> A2.StringLitPat (f m, s)
    | A1.TrueLitPat m -> A2.TrueLitPat (f m)
    | A1.FalseLitPat m -> A2.FalseLitPat (f m)
    | A1.ConstructorPat (m, n, ps) ->
        A2.ConstructorPat (f m, name_map f n, List.map (pattern_map f) ps)

  let unop_map (f : A1.m -> A2.m) = function
    | A1.Neg m -> A2.Neg (f m)
    | A1.Not m -> A2.Not (f m)

  let binop_map (f : A1.m -> A2.m) = function
    | A1.Plus m -> A2.Plus (f m)
    | A1.Minus m -> A2.Minus (f m)
    | A1.Times m -> A2.Times (f m)
    | A1.Div m -> A2.Div (f m)
    | A1.And m -> A2.And (f m)
    | A1.Or m -> A2.Or (f m)
    | A1.Eq m -> A2.Eq (f m)
    | A1.Neq m -> A2.Neq (f m)
    | A1.Lt m -> A2.Lt (f m)
    | A1.Leq m -> A2.Leq (f m)
    | A1.Gt m -> A2.Gt (f m)
    | A1.Geq m -> A2.Geq (f m)

  let rec expr_map (f : A1.m -> A2.m) = function
    | A1.Var (m, n) -> A2.Var (f m, name_map f n)
    | A1.UnitLit m -> A2.UnitLit (f m)
    | A1.IntLit (m, i) -> A2.IntLit (f m, i)
    | A1.FloatLit (m, d) -> A2.FloatLit (f m, d)
    | A1.CharLit (m, c) -> A2.CharLit (f m, c)
    | A1.StringLit (m, s) -> A2.StringLit (f m, s)
    | A1.TrueLit m -> A2.TrueLit (f m)
    | A1.FalseLit m -> A2.FalseLit (f m)
    | A1.Match (m, e, pes) ->
        A2.Match
          ( f m,
            expr_map f e,
            List.map (fun (p, e) -> (pattern_map f p, expr_map f e)) pes )
    | A1.RecAbs (m, g, x, e) ->
        A2.RecAbs (f m, name_map f g, name_map f x, expr_map f e)
    | A1.FunApp (m, fn, arg) -> A2.FunApp (f m, expr_map f fn, expr_map f arg)
    | A1.TypeConstr (m, e, t) -> A2.TypeConstr (f m, expr_map f e, typ_map f t)
    | A1.Unop (m, o, e) -> A2.Unop (f m, unop_map f o, expr_map f e)
    | A1.Binop (m, o, e1, e2) ->
        A2.Binop (f m, binop_map f o, expr_map f e1, expr_map f e2)

  let decl_map (f : A1.m -> A2.m) = function
    | A1.TypeDecl (m, n, t) -> A2.TypeDecl (f m, name_map f n, typ_map f t)
    | A1.DefnDecl (m, n, p, e) ->
        A2.DefnDecl (f m, name_map f n, pattern_map f p, expr_map f e)
    | A1.ImportDecl (m, n) -> A2.ImportDecl (f m, name_map f n)
    | A1.TypeAliasDecl (m, n, t) ->
        A2.TypeAliasDecl (f m, name_map f n, typ_map f t)
    | A1.VariantDecl (m, n, cs) ->
        A2.VariantDecl
          ( f m,
            name_map f n,
            List.map (fun (n, t) -> (name_map f n, List.map (typ_map f) t)) cs
          )

  let program_map (f : A1.m -> A2.m) = List.map (decl_map f)
end
