%{
    open Posinfo_ast.M
    let mkpos (s : Lexing.position) (e : Lexing.position) : Metainfo.Meta.PosInfo.t =
        {
        filename = s.pos_fname;
        start = (s.pos_lnum, s.pos_cnum - s.pos_bol);
        stop = (e.pos_lnum, e.pos_cnum - e.pos_bol)
        }
%}

(* Type literals *)
%token UNITTY INTTY FLOATTY CHARTY STRINGTY BOOLTY ARROW LOCTY

(*Unop*)
%token MINUS NOT

(*Binop*)
%token PLUS TIMES DIV AND OR EQ NEQ LT LEQ GT GEQ

(*Expr*)
%token <int> INTLIT
%token <float> FLOATLIT
%token <char> CHARLIT
%token <string> ID
%token <string> STRINGLIT
%token UNITLIT TRUELIT FALSELIT LOCLIT MATCH WITH END
%token SEND RECV CHOOSE CHOICE ALLOWCHOICE AMI TO FROM FOR
%token TYPEDECL COLON WALRUS IMPORT BAR
%token EMULATEDLOCDECL EMULATEDLOC DOUBLEARROW
%token WILDCARD LPAREN RPAREN LBRACK RBRACK APO QUOTE FUN ALLOW TYPE DATA
%token EOF

// %parameter <A : Ast.AST>
%start <Posinfo_ast.M.program> program
%%

    program:
    | l=list(decl) EOF {l}

    id:
    | s=ID  {(mkpos $startpos $endpos, s)}

    typ:   
    | t=atomic_typ                  { t }
    | t1=atomic_typ ARROW t2=typ    {FunTy ((mkpos $startpos $endpos), t1, t2)}

    atomic_typ:
    | TYPEDECL COLON s=id   {VarTy (mkpos $startpos $endpos, s)}
    | UNITTY                {UnitTy (mkpos $startpos $endpos)}
    | INTTY                 {IntTy (mkpos $startpos $endpos)}
    | FLOATTY               {FloatTy (mkpos $startpos $endpos)}
    | CHARTY                {CharTy (mkpos $startpos $endpos)}
    | STRINGTY              {StringTy (mkpos $startpos $endpos)}
    | BOOLTY                {BoolTy (mkpos $startpos $endpos)}
    | LOCTY ids=list(id)    {LocTy (mkpos $startpos $endpos, ids)}

    pattern:
    | WILDCARD              {WildcardPat (mkpos $startpos $endpos)}

    expr:
    | UNITLIT               {UnitLit (mkpos $startpos $endpos)}

    decl:
    | EMULATEDLOCDECL s=id                  {EmulatedLocDecl (mkpos $startpos $endpos,  s)}
    | s=id COLON t=typ                      {TypeDecl (mkpos $startpos $endpos, s, t)}
    | TYPEDECL s=id WALRUS t=typ            {TypeAliasDecl (mkpos $startpos $endpos, s, t)}
    | s=id WALRUS l=list(pattern) e=expr    {DefnDecl (mkpos $startpos $endpos, s, l, e)}
    | IMPORT s=id                           {ImportDecl (mkpos $startpos $endpos, s)}
    | DATA s=id WALRUS l=list(var_decl)     {VariantDecl (mkpos $startpos $endpos, s, l)}

    var_decl:
    | s=ID l=list(typ) t=typ                {((mkpos $startpos $endpos, s), l, t)}
 