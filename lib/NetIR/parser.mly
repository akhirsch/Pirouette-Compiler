%{
    open Ast.PosInfo_AST
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
%token <string> STRINGLIT LOCLIT
%token TRUELIT FALSELIT MATCH WITH END
%token SEND RECV CHOOSE CHOICE AMI TO FROM FOR
%token TYPEDECL COLON WALRUS IMPORT BAR
%token EMULATEDLOCDECL DOUBLEARROW
%token WILDCARD LPAREN RPAREN LBRACK RBRACK LBRACE RBRACE FUN ALLOW DATA COMMA
%token EOF

%start <Ast.PosInfo_AST.program> program
%%

    program:
    | l=list(decl) EOF {l}

    id:
    | s=ID  {(mkpos $startpos $endpos, s)}

    loclit:
    | s=LOCLIT {(mkpos $startpos $endpos, s)}

    lab:
    | LBRACK s=id RBRACK    { Label s }

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
    | s=id l=list(atomic_pattern)  {ConstructorPat (mkpos $startpos $endpos, s, l)}

    atomic_pattern:
    | WILDCARD              {WildcardPat (mkpos $startpos $endpos)}
    | s=id                  {VarPat (mkpos $startpos $endpos, s)}
    | LPAREN RPAREN         {UnitLitPat (mkpos $startpos $endpos)}
    | n=INTLIT              {IntLitPat (mkpos $startpos $endpos, n)}
    | f=FLOATLIT            {FloatLitPat (mkpos $startpos $endpos, f)}
    | c=CHARLIT             {CharLitPat (mkpos $startpos $endpos, c)}
    | s=STRINGLIT           {StringLitPat (mkpos $startpos $endpos, s)}
    | TRUELIT               {TrueLitPat (mkpos $startpos $endpos)}
    | FALSELIT              {FalseLitPat (mkpos $startpos $endpos)}
    | l=loclit              {LocLitPat (mkpos $startpos $endpos, l)}
    | LBRACK LBRACK s=id RBRACK RBRACK {LocNamePat (mkpos $startpos $endpos, s)}

    expr:
    | e=op_expr                         { e }
    | MATCH e=expr WITH l=separated_list(BAR, match_match) END {Match (mkpos $startpos $endpos, e, l)}
    | FUN f=id a=id WALRUS e=op_expr    {RecAbs (mkpos $startpos $endpos, f, a, e)}
    | e=op_expr COLON t=typ             {TypeConstr (mkpos $startpos $endpos, e, t)}
    | SEND e=op_expr TO s=id            {Send (mkpos $startpos $endpos, e, s)}
    | RECV t=typ FROM s=id              {Recv (mkpos $startpos $endpos, t, s)}
    | CHOOSE l=lab FOR s=id             {ChooseFor (mkpos $startpos $endpos, s, l)}
    | AMI e=expr                        {AmI (mkpos $startpos $endpos, e)}
    | ALLOW s=id CHOICE l=separated_list(BAR, allow_match) END {AllowChoice (mkpos $startpos $endpos, s, l)}

    match_match:
    | a=pattern WALRUS e=expr      {(a, e)}
    
    allow_match:
    | l=lab DOUBLEARROW e=expr            {(l, e)}
    
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
    | l=loclit                  {LocLit (mkpos $startpos $endpos, l)}
    | s=id                      {Var (mkpos $startpos $endpos, s)}

    decl:
    | EMULATEDLOCDECL s=id                          {EmulatedLocDecl (mkpos $startpos $endpos, s)}
    | s=id COLON t=typ                              {TypeDecl (mkpos $startpos $endpos, s, t)}
    | TYPEDECL s=id WALRUS t=typ                    {TypeAliasDecl (mkpos $startpos $endpos, s, t)}
    | s=id l=list(pattern) WALRUS e=expr            {DefnDecl (mkpos $startpos $endpos, s, l, e)}
    | IMPORT s=id                                   {ImportDecl (mkpos $startpos $endpos, s)}
    | DATA s=id WALRUS l=nonempty_list(var_decl)    {VariantDecl (mkpos $startpos $endpos, s, l)}

    var_decl:
    | BAR s=id t=typ    
        {
            let rec get_last_typ = function
                | (acc, FunTy (_, t1, t2)) -> get_last_typ ([t1] @ acc, t2)
                | (acc, t) -> (acc, t)
            in
            let arg_typs, ret_typs = get_last_typ ([], t) in
                (s, arg_typs, ret_typs)
        }
        (* The syntax for var_decls is "name t1 -> t2 ... -> tn -> ret_typ."
            The constructor requires the return type to be provided separately,
            but the entire type will be parsed as a single fucntion type. So
            we need this function to "unroll" the type, so we have access
            to the return type for our constructor.*)

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
