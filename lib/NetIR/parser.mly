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
%token WILDCARD LPAREN RPAREN LBRACK RBRACK LBRACE RBRACE APO QUOTE FUN ALLOW TYPE DATA COMMA
%token EOF

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
    | LPAREN t=typ RPAREN   { t }
    | UNITTY                {UnitTy (mkpos $startpos $endpos)}
    | INTTY                 {IntTy (mkpos $startpos $endpos)}
    | FLOATTY               {FloatTy (mkpos $startpos $endpos)}
    | CHARTY                {CharTy (mkpos $startpos $endpos)}
    | STRINGTY              {StringTy (mkpos $startpos $endpos)}
    | BOOLTY                {BoolTy (mkpos $startpos $endpos)}
    | LOCTY LBRACE ids=separated_list(COMMA, id) RBRACE {LocTy (mkpos $startpos $endpos, ids)}
    | s=id                  {VarTy (mkpos $startpos $endpos, s)}

    pattern:
    | WILDCARD              {WildcardPat (mkpos $startpos $endpos)}

    expr:
    | e=op_expr             { e }

    op_expr:
    | e=app_expr                            { e }
    | e1=op_expr op=bin_op e2=atomic_expr   {Binop (mkpos $startpos $endpos, op, e1, e2)}

    app_expr:
    | e=atomic_expr             { e }
    | f=app_expr a=atomic_expr  { FunApp (mkpos $startpos $endpos, f, a)}
    | op=un_op e=atomic_expr    { Unop (mkpos $startpos $endpos, op, e)}

    atomic_expr:
    | LPAREN e=expr RPAREN      { e }
    | LPAREN RPAREN             {UnitLit (mkpos $startpos $endpos)}
    | n=INTLIT                  {IntLit (mkpos $startpos $endpos, n)}
    | f=FLOATLIT                {FloatLit (mkpos $startpos $endpos, f)}
    | c=CHARLIT                 {CharLit (mkpos $startpos $endpos, c)}
    | s=STRINGLIT               {StringLit (mkpos $startpos $endpos, s)}
    | TRUELIT                   {TrueLit (mkpos $startpos $endpos)}
    | FALSELIT                  {FalseLit (mkpos $startpos $endpos)}
    // | l=LOCLIT                  {LocLit (mkpos $startpos $endpos, l)}  TODO
    | s=id                      {Var (mkpos $startpos $endpos, s)}

    decl:
    | EMULATEDLOCDECL s=id                  {EmulatedLocDecl (mkpos $startpos $endpos, s)}
    | s=id COLON t=typ                      {TypeDecl (mkpos $startpos $endpos, s, t)}
    | TYPEDECL s=id WALRUS t=typ            {TypeAliasDecl (mkpos $startpos $endpos, s, t)}
    | s=id WALRUS l=list(pattern) e=expr    {DefnDecl (mkpos $startpos $endpos, s, l, e)}
    | IMPORT s=id                           {ImportDecl (mkpos $startpos $endpos, s)}
    | DATA s=id WALRUS l=list(var_decl)     {VariantDecl (mkpos $startpos $endpos, s, l)}

    var_decl:
    | BAR s=id l=list(typ) ARROW t=atomic_typ     {(s, l, t)}
 
    %inline un_op:
    | MINUS       { Neg   (mkpos $startpos $endpos) }
    | NOT         { Not   (mkpos $startpos $endpos) }

    %inline bin_op:
    | PLUS        { Plus  (mkpos $startpos $endpos) }
    | MINUS       { Minus (mkpos $startpos $endpos) }
    | TIMES       { Times (mkpos $startpos $endpos) }
    | DIV         { Div   (mkpos $startpos $endpos) }
    | AND         { And   (mkpos $startpos $endpos) }
    | OR          { Or    (mkpos $startpos $endpos) }
    | EQ          { Eq    (mkpos $startpos $endpos) }
    | NEQ         { Neq   (mkpos $startpos $endpos) }
    | LT          { Lt    (mkpos $startpos $endpos) }
    | LEQ         { Leq   (mkpos $startpos $endpos) }
    | GT          { Gt    (mkpos $startpos $endpos) }
    | GEQ         { Geq   (mkpos $startpos $endpos) }