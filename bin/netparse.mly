%token <int> INT 
%token <float> FLOAT
%token <string> ID
%token <string> STRING
%token TRUE
%token FALSE
%token LEFT_PAREN
%token RIGHT_PAREN
%token COLON
%token ARROW
%token EOF 

%start <NetIR.Ast.decl> prog

prog:
| EOF
| n = ID; COLON; t = type 
  { TypeDecl (n, t) }