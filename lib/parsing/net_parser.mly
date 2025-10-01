%token <string> ID
%token <int> INT
%token <string> STRING
%token TRUE FALSE
%token UNIT_T INT_T STRING_T BOOL_T
%token FUN TYPE
%token UNDERSCORE
%token COLONEQ
%token PLUS MINUS TIMES DIV
%token NOT
%token AND OR
%token EQ NEQ LT LEQ GT GEQ
%token LPAREN RPAREN 
%token COMMA DOT COLON SEMICOLON
%token ARROW TILDE_ARROW
%token BAR
%token LET IN
%token IF THEN ELSE
%token FST SND LEFT RIGHT
%token MATCH WITH
%token EOF
%token FOREIGN
%token SEND RECV
%token CHOOSE FOR
%token ALLOW CHOICE
%token RET
%token FROM

%nonassoc IN
%right ARROW
%nonassoc BAR
%nonassoc FST SND LEFT RIGHT
%right OR
%right AND
%left EQ NEQ LT LEQ GT GEQ
%left PLUS MINUS
%left TIMES DIV
%nonassoc UNARY
%left DOT

%{
  open Ast_core.Local.M
  open Ast_core.Net.M
  open Parsed_ast

  let gen_pos startpos endpos =
    let open Lexing in
    { Pos_info.fname = startpos.pos_fname
    ; start = startpos.pos_lnum, startpos.pos_cnum - startpos.pos_bol
    ; stop = endpos.pos_lnum, endpos.pos_cnum - endpos.pos_bol
    }
%}

%type <Parsed_ast.Net.stmt_block> prog
%type <Parsed_ast.Net.stmt_block> stmt_block
%type <Parsed_ast.Net.stmt> stmt
%type <Parsed_ast.Net.expr> net_expr
%type <Parsed_ast.Net.typ> net_type
%type <Parsed_ast.Local.expr> local_expr
%type <Parsed_ast.Local.pattern> local_pattern
%type <Parsed_ast.Local.typ> local_type
%type <Parsed_ast.Local.bin_op> bin_op
%type <Parsed_ast.Local.value> value
%type <Parsed_ast.Local.loc_id> loc_id
%type <Parsed_ast.Local.var_id> var_id
%type <Parsed_ast.Local.typ_id> typ_id
%type <Parsed_ast.Local.sync_label> sync_label
%type <Parsed_ast.Net.stmt> foreign_decl
%type <Parsed_ast.Net.stmt list> list(stmt)
%type <(Parsed_ast.Local.pattern * Parsed_ast.Local.expr) list> nonempty_list(local_case)
%type <Parsed_ast.Local.pattern list> nonempty_list(local_pattern)
%type <(Parsed_ast.Local.pattern * Parsed_ast.Net.expr) list> nonempty_list(net_case)
%type <(Parsed_ast.Local.sync_label * Parsed_ast.Net.expr) list> nonempty_list(sync_choice_case)
%type <unit option> option(SEMICOLON)

%start prog

%%

prog:
  | stmt_block EOF { $1 }

stmt_block:
  | list(stmt) { $1 }

stmt:
  | p=local_pattern COLON t=net_type SEMICOLON { Decl (p, t, gen_pos $startpos $endpos) }
  | ps=nonempty_list(local_pattern) COLONEQ e=net_expr SEMICOLON { Assign (ps, e, gen_pos $startpos $endpos) }
  | TYPE id=typ_id COLONEQ t=net_type SEMICOLON? { TypeDecl (id, t, gen_pos $startpos $endpos) }
  | f=foreign_decl { f }


net_expr:
  | net_expr1 { $1 }
  | UNIT_T { Unit (gen_pos $startpos $endpos) }
  // | id=var_id { Var (id, gen_pos $startpos $endpos) }
  | RET e=local_expr { Ret (e, gen_pos $startpos $endpos) }
  | IF e1=net_expr THEN e2=net_expr ELSE e3=net_expr { If (e1, e2, e3, gen_pos $startpos $endpos) }
  | LET stmts=stmt_block IN e=net_expr { Let (stmts, e, gen_pos $startpos $endpos) }
  | SEND e=net_expr TILDE_ARROW id=loc_id { Send (e, id, gen_pos $startpos $endpos) }
  | RECV FROM id=loc_id { Recv (id, gen_pos $startpos $endpos) }
  | CHOOSE sync=sync_label FOR id=loc_id IN e=net_expr { ChooseFor (sync, id, e, gen_pos $startpos $endpos) }
  | ALLOW CHOICE FROM id=loc_id WITH cases=nonempty_list(sync_choice_case) { AllowChoice (id, cases, gen_pos $startpos $endpos) }
  | FUN ps=nonempty_list(local_pattern) ARROW e=net_expr { FunDef (ps, e, gen_pos $startpos $endpos) }
  | LPAREN e1=net_expr COMMA e2=net_expr RPAREN { Pair (e1, e2, gen_pos $startpos $endpos) }
  | FST e=net_expr { Fst (e, gen_pos $startpos $endpos) }
  | SND e=net_expr { Snd (e, gen_pos $startpos $endpos) }
  | LEFT e=net_expr { Left (e, gen_pos $startpos $endpos) }
  | RIGHT e=net_expr { Right (e, gen_pos $startpos $endpos) }
  | MATCH e=net_expr WITH cases=nonempty_list(net_case) { Match (e, cases, gen_pos $startpos $endpos) }
  | LPAREN e=net_expr RPAREN { Net.set_info_expr (gen_pos $startpos $endpos) e }

net_expr1:
  | e1=net_expr1 e2=net_expr2 { FunApp (e1, e2, gen_pos $startpos $endpos) }
  | net_expr2 { $1 }

net_expr2:
  | LPAREN RPAREN { Unit (gen_pos $startpos $endpos) }
  | id=var_id { Var (id, gen_pos $startpos $endpos) }
  | LPAREN e=net_expr RPAREN { Net.set_info_expr (gen_pos $startpos $endpos) e }

local_expr:
  | LPAREN RPAREN { Unit (gen_pos $startpos $endpos) }
  | v=value { Val (v, gen_pos $startpos $endpos) }
  | id=var_id { Var (id, gen_pos $startpos $endpos) }
  | op=un_op e=local_expr %prec UNARY { UnOp (op, e, gen_pos $startpos $endpos) }
  | e1=local_expr op=bin_op e2=local_expr { BinOp (e1, op, e2, gen_pos $startpos $endpos) }
  | LET id=var_id COLON t=local_type COLONEQ e1=local_expr IN e2=local_expr { Let (id, t, e1, e2, gen_pos $startpos $endpos) }
  | LPAREN e1=local_expr COMMA e2=local_expr RPAREN { Pair (e1, e2, gen_pos $startpos $endpos) }
  | FST e=local_expr { Fst (e, gen_pos $startpos $endpos) }
  | SND e=local_expr { Snd (e, gen_pos $startpos $endpos) }
  | LEFT e=local_expr { Left (e, gen_pos $startpos $endpos) }
  | RIGHT e=local_expr { Right (e, gen_pos $startpos $endpos) }
  | MATCH e=local_expr WITH cases=nonempty_list(local_case) { Match (e, cases, gen_pos $startpos $endpos) }
  | LPAREN e=local_expr RPAREN { Local.set_info_expr (gen_pos $startpos $endpos) e }

local_pattern:
  | UNDERSCORE { Default (gen_pos $startpos $endpos) }
  | v=value { Val (v, gen_pos $startpos $endpos) }
  | x=var_id { Var (x, gen_pos $startpos $endpos) }
  | LPAREN p1=local_pattern COMMA p2=local_pattern RPAREN { Pair (p1, p2, gen_pos $startpos $endpos) }
  | LEFT p=local_pattern { Left (p, gen_pos $startpos $endpos) }
  | RIGHT p=local_pattern { Right (p, gen_pos $startpos $endpos) }
  | LPAREN p=local_pattern RPAREN { Local.set_info_pattern (gen_pos $startpos $endpos) p }

net_type:
  | UNIT_T { TUnit (gen_pos $startpos $endpos) }
  | id=loc_id DOT t=local_type { TLoc (id, t, gen_pos $startpos $endpos) }
  | t1=net_type ARROW t2=net_type { TMap (t1, t2, gen_pos $startpos $endpos) }
  | t1=net_type TIMES t2=net_type { TProd (t1, t2, gen_pos $startpos $endpos) }
  | t1=net_type PLUS t2=net_type { TSum (t1, t2, gen_pos $startpos $endpos) }
  | LPAREN t=net_type RPAREN { Net.set_info_typ (gen_pos $startpos $endpos) t }

local_type:
  | UNIT_T { TUnit (gen_pos $startpos $endpos) }
  | INT_T { TInt (gen_pos $startpos $endpos) }
  | STRING_T { TString (gen_pos $startpos $endpos) }
  | BOOL_T { TBool (gen_pos $startpos $endpos) }
  | t1=local_type TIMES t2=local_type { TProd (t1, t2, gen_pos $startpos $endpos) }
  | t1=local_type PLUS t2=local_type { TSum (t1, t2, gen_pos $startpos $endpos) }
  | LPAREN t=local_type RPAREN { Local.set_info_typ (gen_pos $startpos $endpos) t }
  
loc_id:
  | id=ID { LocId (id, gen_pos $startpos $endpos) }

var_id:
  | id=ID { VarId (id, gen_pos $startpos $endpos) }

typ_id:
  | id=ID { TypId (id, gen_pos $startpos $endpos) }

sync_label:
  | id=ID { LabelId (id, gen_pos $startpos $endpos) }

value:
  | i=INT { Int (i, gen_pos $startpos $endpos) }
  | s=STRING { String (s, gen_pos $startpos $endpos) }
  | TRUE { Bool (true, gen_pos $startpos $endpos) }
  | FALSE { Bool (false, gen_pos $startpos $endpos) }

%inline local_case:
  | BAR p=local_pattern ARROW e=local_expr { p, e }

%inline net_case:
  | BAR p=local_pattern ARROW e=net_expr { p, e }

%inline sync_choice_case:
  | BAR sync=sync_label ARROW e=net_expr { sync, e }

%inline un_op:
  | MINUS { Neg (gen_pos $startpos $endpos) }
  | NOT { Not (gen_pos $startpos $endpos) }

%inline bin_op:
  | PLUS { Plus (gen_pos $startpos $endpos) }
  | MINUS { Minus (gen_pos $startpos $endpos) }
  | TIMES { Times (gen_pos $startpos $endpos) }
  | DIV { Div (gen_pos $startpos $endpos) }
  | AND { And (gen_pos $startpos $endpos) }
  | OR { Or (gen_pos $startpos $endpos) }
  | EQ { Eq (gen_pos $startpos $endpos) }
  | NEQ { Neq (gen_pos $startpos $endpos) }
  | LT { Lt (gen_pos $startpos $endpos) }
  | LEQ { Leq (gen_pos $startpos $endpos) }
  | GT { Gt (gen_pos $startpos $endpos) }
  | GEQ { Geq (gen_pos $startpos $endpos) }

foreign_decl:
  | FOREIGN id=var_id COLON t=net_type COLONEQ s=STRING SEMICOLON 
    { ForeignDecl (id, t, s, gen_pos $startpos $endpos) }