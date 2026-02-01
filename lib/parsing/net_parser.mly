(** Parser specification for Pirouette Network IR (Intermediate Representation).
    
    This file defines the grammar rules for parsing Pirouette Network IR into
    Abstract Syntax Trees. It is processed by Menhir/ocamlyacc to generate the
    actual parser implementation for network-level code.
    
    {2 Parser Overview}
    
    This parser works with the Network IR lexer to parse the intermediate
    representation produced after endpoint projection:
    
    {v
      Network IR text  →  Net_lexer  →  Tokens  →  Net_parser  →  Parsed_ast.Net
      "x := Recv(Alice)"    read        tokens                    stmt_block
    v}
    
    {2 Differences from Choreographic Parser}
    
    This parser handles Network IR, not choreographies:
    
    {b Network IR has:}
    - [Send]/[Recv]: Explicit send/receive operations
    - [ChooseFor]/[AllowChoice]: Choice coordination primitives
    - [Ret]: Wrapping local expressions for network context
    - No location-qualified expressions (no [[Alice] expr])
    - No choreographic [send] or [select] constructs
    
    {b Choreographic parser has:}
    - [[Alice] expr]: Location-qualified expressions
    - [send Alice x -> Bob]: Choreographic communication
    - [Alice[Ready] ~> Bob]: Choreographic choice
    - Global view of the protocol
    
    {2 Compilation Pipeline Position}
    
    {v
      Choreography  →  Type Check  →  Endpoint Projection  →  Network IR  →  OCaml Code
      (Parser.mly)                                            (This parser)
    v}
    
    {b Typical workflow:}
    1. Users write choreographies (parsed by main parser)
    2. Type checker validates the choreography
    3. Endpoint projection generates Network IR programmatically
    4. OCaml code generator compiles Network IR to executables
    
    {b This parser is used for:}
    - Testing endpoint projection output
    - Debugging projected code
    - Manual Network IR programming (advanced users)
    - Compiler testing and development
    
    {2 Network IR Syntax Examples}
    
    {b Receiving and computing:}
    {[
      x : int;
      x := Recv(Alice);
      y : int;
      y := Ret(x + 1);
    ]}
    
    {b Sending data:}
    {[
      val : int;
      val := Ret(42);
      send Ret(val) ~> Bob;
    ]}
    
    {b Choice coordination (chooser side):}
    {[
      choose Ready for Bob in
        send Ret(data) ~> Bob
    ]}
    
    {b Choice coordination (follower side):}
    {[
      allow choice from Alice with
      | Ready -> handle_ready
      | NotReady -> handle_not_ready
    ]}
    
    {b Functions and control flow:}
    {[
      f : int -> int;
      f := fun x -> Ret(x + 1);
      
      result : int;
      result := if Ret(x > 0) then
                  Ret(x)
                else
                  Ret(0);
    ]}
    
    {2 Grammar Structure}
    
    {b Top-level:}
    - [prog]: Entry point (statement block + EOF)
    - [stmt_block]: List of statements
    - [stmt]: Variable declarations, assignments, type definitions, foreign declarations
    
    {b Network expressions ([net_expr]):}
    - [Ret(local_expr)]: Wrap local computation
    - [Send(expr, loc)]: Send data to location
    - [Recv(loc)]: Receive data from location
    - [ChooseFor(label, loc, expr)]: Send choice to location
    - [AllowChoice(loc, cases)]: Wait for choice from location
    - Control flow: if/then/else, let/in, match, functions
    
    {b Local expressions ([local_expr]):}
    - Pure computation: arithmetic, variables, pattern matching
    - No communication primitives
    - Shared with choreographic parser
    
    {b Types ([net_type]):}
    - Basic types: unit, int, string, bool
    - Compound types: products (×), sums (+), functions (→)
    - Located types: [Alice.int] (for type annotations)
    
    {2 Key Features}
    
    {b Position Tracking:} All AST nodes include [Pos_info.t] for error reporting.
    The [gen_pos] function extracts position data from Menhir's markers.
    
    {b Operator Precedence:} Inherits precedence rules from choreographic parser
    for consistency in expression evaluation.
    
    {b Explicit Communication:} Unlike choreographies, all communication is
    explicit via [Send]/[Recv]/[ChooseFor]/[AllowChoice] constructs.
    
    {2 Example: Projected Code}
    
    {b Original choreography:}
    {[
      x : Alice.int;
      x := [Alice] 5;
      send Alice x -> Bob;
      y : Bob.int;
      y := [Bob] x + 1;
    ]}
    
    {b After projection to Bob (Network IR):}
    {[
      x : int;
      x := Recv(Alice);
      y : int;
      y := Ret(x + 1);
    ]}
    
    This Network IR code is what this parser can parse.
    
    {2 Output}
    
    The parser produces [Parsed_ast.Net.stmt_block], which contains:
    - Network IR AST nodes with [Pos_info.t] metadata
    - Explicit communication operations
    - Ready for OCaml code generation via [emit_core]
    
    {2 Error Handling}
    
    Parse errors include position information automatically via Menhir's error
    reporting. The [gen_pos] function ensures all AST nodes track their source
    locations for detailed error messages during compilation.
    
    {2 Notes}
    
    - Semicolons are required after statements (consistent with main parser)
    - Shares operator precedence with choreographic parser
    - Entry point is [%start prog] which returns [Parsed_ast.Net.stmt_block]
    - This parser is primarily for compiler internals and testing *)

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
  | UNIT_T { Unit (gen_pos $startpos $endpos) }
  | id=var_id { Var (id, gen_pos $startpos $endpos) }
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