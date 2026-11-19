
module MenhirBasics = struct
  
  exception Error
  
  let _eRR =
    fun _s ->
      raise Error
  
  type token = 
    | WITH
    | WILDCARD
    | WALRUS
    | UNITTY
    | UNITLIT
    | TYPEDECL
    | TRUELIT
    | TO
    | TIMES
    | STRINGTY
    | STRINGLIT of 
# 25 "lib/NetIR/parser.mly"
       (string)
# 25 "lib/NetIR/parser.ml"
  
    | SEND
    | SEMICOLON
    | RPAREN
    | RECV
    | RBRACK
    | RBRACE
    | PLUS
    | OR
    | NOT
    | NEQ
    | MINUS
    | MATCH
    | LT
    | LPAREN
    | LOCTY
    | LOCLIT of 
# 25 "lib/NetIR/parser.mly"
       (string)
# 45 "lib/NetIR/parser.ml"
  
    | LEQ
    | LBRACK
    | LBRACE
    | INTTY
    | INTLIT of 
# 21 "lib/NetIR/parser.mly"
       (int)
# 54 "lib/NetIR/parser.ml"
  
    | IMPORT
    | ID of 
# 24 "lib/NetIR/parser.mly"
       (string)
# 60 "lib/NetIR/parser.ml"
  
    | GT
    | GEQ
    | FUN
    | FROM
    | FOR
    | FLOATTY
    | FLOATLIT of 
# 22 "lib/NetIR/parser.mly"
       (float)
# 71 "lib/NetIR/parser.ml"
  
    | FALSELIT
    | EQ
    | EOF
    | END
    | EMULATEDLOCDECL
    | DOUBLEARROW
    | DIV
    | DATA
    | COMMA
    | COLON
    | CHOOSE
    | CHOICE
    | CHARTY
    | CHARLIT of 
# 23 "lib/NetIR/parser.mly"
       (char)
# 89 "lib/NetIR/parser.ml"
  
    | BOOLTY
    | BAR
    | ARROW
    | AND
    | AMI
    | ALLOW
  
end

include MenhirBasics

# 1 "lib/NetIR/parser.mly"
  
    open Ast.PosInfo_AST
    let mkpos (s : Lexing.position) (e : Lexing.position) : Metainfo.Meta.PosInfo.t =
        {
        filename = s.pos_fname;
        start = (s.pos_lnum, s.pos_cnum - s.pos_bol);
        stop = (e.pos_lnum, e.pos_cnum - e.pos_bol)
        }

# 112 "lib/NetIR/parser.ml"

type ('s, 'r) _menhir_state = 
  | MenhirState000 : ('s, _menhir_box_program) _menhir_state
    (** State 000.
        Stack shape : <empty>.
        Start symbol: program. *)

  | MenhirState001 : (('s, _menhir_box_program) _menhir_cell1_TYPEDECL, _menhir_box_program) _menhir_state
    (** State 001.
        Stack shape : TYPEDECL.
        Start symbol: program. *)

  | MenhirState004 : ((('s, _menhir_box_program) _menhir_cell1_TYPEDECL, _menhir_box_program) _menhir_cell1_id, _menhir_box_program) _menhir_state
    (** State 004.
        Stack shape : TYPEDECL id.
        Start symbol: program. *)

  | MenhirState007 : (('s, _menhir_box_program) _menhir_cell1_LPAREN, _menhir_box_program) _menhir_state
    (** State 007.
        Stack shape : LPAREN.
        Start symbol: program. *)

  | MenhirState009 : (('s, _menhir_box_program) _menhir_cell1_LOCTY, _menhir_box_program) _menhir_state
    (** State 009.
        Stack shape : LOCTY.
        Start symbol: program. *)

  | MenhirState015 : (('s, _menhir_box_program) _menhir_cell1_loclit, _menhir_box_program) _menhir_state
    (** State 015.
        Stack shape : loclit.
        Start symbol: program. *)

  | MenhirState025 : (('s, _menhir_box_program) _menhir_cell1_atomic_typ, _menhir_box_program) _menhir_state
    (** State 025.
        Stack shape : atomic_typ.
        Start symbol: program. *)

  | MenhirState028 : (('s, _menhir_box_program) _menhir_cell1_IMPORT, _menhir_box_program) _menhir_state
    (** State 028.
        Stack shape : IMPORT.
        Start symbol: program. *)

  | MenhirState030 : (('s, _menhir_box_program) _menhir_cell1_EMULATEDLOCDECL, _menhir_box_program) _menhir_state
    (** State 030.
        Stack shape : EMULATEDLOCDECL.
        Start symbol: program. *)

  | MenhirState032 : (('s, _menhir_box_program) _menhir_cell1_DATA, _menhir_box_program) _menhir_state
    (** State 032.
        Stack shape : DATA.
        Start symbol: program. *)

  | MenhirState034 : ((('s, _menhir_box_program) _menhir_cell1_DATA, _menhir_box_program) _menhir_cell1_id, _menhir_box_program) _menhir_state
    (** State 034.
        Stack shape : DATA id.
        Start symbol: program. *)

  | MenhirState035 : (('s, _menhir_box_program) _menhir_cell1_BAR, _menhir_box_program) _menhir_state
    (** State 035.
        Stack shape : BAR.
        Start symbol: program. *)

  | MenhirState037 : ((('s, _menhir_box_program) _menhir_cell1_BAR, _menhir_box_program) _menhir_cell1_id, _menhir_box_program) _menhir_state
    (** State 037.
        Stack shape : BAR id.
        Start symbol: program. *)

  | MenhirState039 : (('s, _menhir_box_program) _menhir_cell1_var_decl, _menhir_box_program) _menhir_state
    (** State 039.
        Stack shape : var_decl.
        Start symbol: program. *)

  | MenhirState045 : (('s, _menhir_box_program) _menhir_cell1_id, _menhir_box_program) _menhir_state
    (** State 045.
        Stack shape : id.
        Start symbol: program. *)

  | MenhirState051 : (('s, _menhir_box_program) _menhir_cell1_LBRACK _menhir_cell0_LBRACK, _menhir_box_program) _menhir_state
    (** State 051.
        Stack shape : LBRACK LBRACK.
        Start symbol: program. *)

  | MenhirState058 : ((('s, _menhir_box_program) _menhir_cell1_id, _menhir_box_program) _menhir_cell1_COLON, _menhir_box_program) _menhir_state
    (** State 058.
        Stack shape : id COLON.
        Start symbol: program. *)

  | MenhirState061 : (('s, _menhir_box_program) _menhir_cell1_pattern, _menhir_box_program) _menhir_state
    (** State 061.
        Stack shape : pattern.
        Start symbol: program. *)

  | MenhirState065 : (('s, _menhir_box_program) _menhir_cell1_id _menhir_cell0_LPAREN, _menhir_box_program) _menhir_state
    (** State 065.
        Stack shape : id LPAREN.
        Start symbol: program. *)

  | MenhirState069 : (('s, _menhir_box_program) _menhir_cell1_atomic_pattern, _menhir_box_program) _menhir_state
    (** State 069.
        Stack shape : atomic_pattern.
        Start symbol: program. *)

  | MenhirState073 : ((('s, _menhir_box_program) _menhir_cell1_id, _menhir_box_program) _menhir_cell1_list_pattern_, _menhir_box_program) _menhir_state
    (** State 073.
        Stack shape : id list(pattern).
        Start symbol: program. *)

  | MenhirState077 : (('s, _menhir_box_program) _menhir_cell1_SEND, _menhir_box_program) _menhir_state
    (** State 077.
        Stack shape : SEND.
        Start symbol: program. *)

  | MenhirState078 : (('s, _menhir_box_program) _menhir_cell1_NOT, _menhir_box_program) _menhir_state
    (** State 078.
        Stack shape : NOT.
        Start symbol: program. *)

  | MenhirState079 : (('s, _menhir_box_program) _menhir_cell1_LPAREN, _menhir_box_program) _menhir_state
    (** State 079.
        Stack shape : LPAREN.
        Start symbol: program. *)

  | MenhirState080 : (('s, _menhir_box_program) _menhir_cell1_RECV, _menhir_box_program) _menhir_state
    (** State 080.
        Stack shape : RECV.
        Start symbol: program. *)

  | MenhirState082 : ((('s, _menhir_box_program) _menhir_cell1_RECV, _menhir_box_program) _menhir_cell1_typ, _menhir_box_program) _menhir_state
    (** State 082.
        Stack shape : RECV typ.
        Start symbol: program. *)

  | MenhirState084 : (('s, _menhir_box_program) _menhir_cell1_MINUS, _menhir_box_program) _menhir_state
    (** State 084.
        Stack shape : MINUS.
        Start symbol: program. *)

  | MenhirState092 : (('s, _menhir_box_program) _menhir_cell1_MATCH, _menhir_box_program) _menhir_state
    (** State 092.
        Stack shape : MATCH.
        Start symbol: program. *)

  | MenhirState093 : (('s, _menhir_box_program) _menhir_cell1_FUN, _menhir_box_program) _menhir_state
    (** State 093.
        Stack shape : FUN.
        Start symbol: program. *)

  | MenhirState094 : ((('s, _menhir_box_program) _menhir_cell1_FUN, _menhir_box_program) _menhir_cell1_id, _menhir_box_program) _menhir_state
    (** State 094.
        Stack shape : FUN id.
        Start symbol: program. *)

  | MenhirState096 : (((('s, _menhir_box_program) _menhir_cell1_FUN, _menhir_box_program) _menhir_cell1_id, _menhir_box_program) _menhir_cell1_id, _menhir_box_program) _menhir_state
    (** State 096.
        Stack shape : FUN id id.
        Start symbol: program. *)

  | MenhirState098 : (('s, _menhir_box_program) _menhir_cell1_op_expr _menhir_cell0_TIMES, _menhir_box_program) _menhir_state
    (** State 098.
        Stack shape : op_expr TIMES.
        Start symbol: program. *)

  | MenhirState100 : (('s, _menhir_box_program) _menhir_cell1_op_expr _menhir_cell0_PLUS, _menhir_box_program) _menhir_state
    (** State 100.
        Stack shape : op_expr PLUS.
        Start symbol: program. *)

  | MenhirState102 : (('s, _menhir_box_program) _menhir_cell1_op_expr _menhir_cell0_OR, _menhir_box_program) _menhir_state
    (** State 102.
        Stack shape : op_expr OR.
        Start symbol: program. *)

  | MenhirState104 : (('s, _menhir_box_program) _menhir_cell1_op_expr _menhir_cell0_NEQ, _menhir_box_program) _menhir_state
    (** State 104.
        Stack shape : op_expr NEQ.
        Start symbol: program. *)

  | MenhirState106 : (('s, _menhir_box_program) _menhir_cell1_op_expr _menhir_cell0_MINUS, _menhir_box_program) _menhir_state
    (** State 106.
        Stack shape : op_expr MINUS.
        Start symbol: program. *)

  | MenhirState108 : (('s, _menhir_box_program) _menhir_cell1_op_expr _menhir_cell0_LT, _menhir_box_program) _menhir_state
    (** State 108.
        Stack shape : op_expr LT.
        Start symbol: program. *)

  | MenhirState110 : (('s, _menhir_box_program) _menhir_cell1_op_expr _menhir_cell0_LEQ, _menhir_box_program) _menhir_state
    (** State 110.
        Stack shape : op_expr LEQ.
        Start symbol: program. *)

  | MenhirState112 : (('s, _menhir_box_program) _menhir_cell1_op_expr _menhir_cell0_GT, _menhir_box_program) _menhir_state
    (** State 112.
        Stack shape : op_expr GT.
        Start symbol: program. *)

  | MenhirState114 : (('s, _menhir_box_program) _menhir_cell1_op_expr _menhir_cell0_GEQ, _menhir_box_program) _menhir_state
    (** State 114.
        Stack shape : op_expr GEQ.
        Start symbol: program. *)

  | MenhirState116 : (('s, _menhir_box_program) _menhir_cell1_op_expr _menhir_cell0_EQ, _menhir_box_program) _menhir_state
    (** State 116.
        Stack shape : op_expr EQ.
        Start symbol: program. *)

  | MenhirState118 : (('s, _menhir_box_program) _menhir_cell1_op_expr _menhir_cell0_DIV, _menhir_box_program) _menhir_state
    (** State 118.
        Stack shape : op_expr DIV.
        Start symbol: program. *)

  | MenhirState120 : (('s, _menhir_box_program) _menhir_cell1_op_expr _menhir_cell0_AND, _menhir_box_program) _menhir_state
    (** State 120.
        Stack shape : op_expr AND.
        Start symbol: program. *)

  | MenhirState122 : (('s, _menhir_box_program) _menhir_cell1_atomic_expr, _menhir_box_program) _menhir_state
    (** State 122.
        Stack shape : atomic_expr.
        Start symbol: program. *)

  | MenhirState125 : (('s, _menhir_box_program) _menhir_cell1_CHOOSE, _menhir_box_program) _menhir_state
    (** State 125.
        Stack shape : CHOOSE.
        Start symbol: program. *)

  | MenhirState126 : (('s, _menhir_box_program) _menhir_cell1_LBRACK, _menhir_box_program) _menhir_state
    (** State 126.
        Stack shape : LBRACK.
        Start symbol: program. *)

  | MenhirState130 : ((('s, _menhir_box_program) _menhir_cell1_CHOOSE, _menhir_box_program) _menhir_cell1_lab, _menhir_box_program) _menhir_state
    (** State 130.
        Stack shape : CHOOSE lab.
        Start symbol: program. *)

  | MenhirState132 : (('s, _menhir_box_program) _menhir_cell1_AMI, _menhir_box_program) _menhir_state
    (** State 132.
        Stack shape : AMI.
        Start symbol: program. *)

  | MenhirState133 : (('s, _menhir_box_program) _menhir_cell1_ALLOW, _menhir_box_program) _menhir_state
    (** State 133.
        Stack shape : ALLOW.
        Start symbol: program. *)

  | MenhirState135 : ((('s, _menhir_box_program) _menhir_cell1_ALLOW, _menhir_box_program) _menhir_cell1_id, _menhir_box_program) _menhir_state
    (** State 135.
        Stack shape : ALLOW id.
        Start symbol: program. *)

  | MenhirState136 : (('s, _menhir_box_program) _menhir_cell1_BAR, _menhir_box_program) _menhir_state
    (** State 136.
        Stack shape : BAR.
        Start symbol: program. *)

  | MenhirState138 : ((('s, _menhir_box_program) _menhir_cell1_BAR, _menhir_box_program) _menhir_cell1_lab, _menhir_box_program) _menhir_state
    (** State 138.
        Stack shape : BAR lab.
        Start symbol: program. *)

  | MenhirState140 : (('s, _menhir_box_program) _menhir_cell1_op_expr, _menhir_box_program) _menhir_state
    (** State 140.
        Stack shape : op_expr.
        Start symbol: program. *)

  | MenhirState145 : (('s, _menhir_box_program) _menhir_cell1_allow_match, _menhir_box_program) _menhir_state
    (** State 145.
        Stack shape : allow_match.
        Start symbol: program. *)

  | MenhirState149 : ((('s, _menhir_box_program) _menhir_cell1_MATCH, _menhir_box_program) _menhir_cell1_expr, _menhir_box_program) _menhir_state
    (** State 149.
        Stack shape : MATCH expr.
        Start symbol: program. *)

  | MenhirState150 : (('s, _menhir_box_program) _menhir_cell1_BAR, _menhir_box_program) _menhir_state
    (** State 150.
        Stack shape : BAR.
        Start symbol: program. *)

  | MenhirState152 : ((('s, _menhir_box_program) _menhir_cell1_BAR, _menhir_box_program) _menhir_cell1_pattern, _menhir_box_program) _menhir_state
    (** State 152.
        Stack shape : BAR pattern.
        Start symbol: program. *)

  | MenhirState156 : (('s, _menhir_box_program) _menhir_cell1_match_match, _menhir_box_program) _menhir_state
    (** State 156.
        Stack shape : match_match.
        Start symbol: program. *)

  | MenhirState162 : ((('s, _menhir_box_program) _menhir_cell1_SEND, _menhir_box_program) _menhir_cell1_op_expr, _menhir_box_program) _menhir_state
    (** State 162.
        Stack shape : SEND op_expr.
        Start symbol: program. *)

  | MenhirState166 : (('s, _menhir_box_program) _menhir_cell1_decl, _menhir_box_program) _menhir_state
    (** State 166.
        Stack shape : decl.
        Start symbol: program. *)


and ('s, 'r) _menhir_cell1_allow_match = 
  | MenhirCell1_allow_match of 's * ('s, 'r) _menhir_state * (Ast.PosInfo_AST.lab * Ast.PosInfo_AST.expr)

and ('s, 'r) _menhir_cell1_atomic_expr = 
  | MenhirCell1_atomic_expr of 's * ('s, 'r) _menhir_state * (Ast.PosInfo_AST.expr) * Lexing.position * Lexing.position

and ('s, 'r) _menhir_cell1_atomic_pattern = 
  | MenhirCell1_atomic_pattern of 's * ('s, 'r) _menhir_state * (Ast.PosInfo_AST.pattern)

and ('s, 'r) _menhir_cell1_atomic_typ = 
  | MenhirCell1_atomic_typ of 's * ('s, 'r) _menhir_state * (Ast.PosInfo_AST.typ) * Lexing.position * Lexing.position

and ('s, 'r) _menhir_cell1_decl = 
  | MenhirCell1_decl of 's * ('s, 'r) _menhir_state * (Ast.PosInfo_AST.decl)

and ('s, 'r) _menhir_cell1_expr = 
  | MenhirCell1_expr of 's * ('s, 'r) _menhir_state * (Ast.PosInfo_AST.expr) * Lexing.position

and ('s, 'r) _menhir_cell1_id = 
  | MenhirCell1_id of 's * ('s, 'r) _menhir_state * (Ast.PosInfo_AST.name) * Lexing.position * Lexing.position

and ('s, 'r) _menhir_cell1_lab = 
  | MenhirCell1_lab of 's * ('s, 'r) _menhir_state * (Ast.PosInfo_AST.lab)

and ('s, 'r) _menhir_cell1_list_pattern_ = 
  | MenhirCell1_list_pattern_ of 's * ('s, 'r) _menhir_state * (Ast.PosInfo_AST.pattern list)

and ('s, 'r) _menhir_cell1_loclit = 
  | MenhirCell1_loclit of 's * ('s, 'r) _menhir_state * (Ast.PosInfo_AST.name) * Lexing.position * Lexing.position

and ('s, 'r) _menhir_cell1_match_match = 
  | MenhirCell1_match_match of 's * ('s, 'r) _menhir_state * (Ast.PosInfo_AST.pattern * Ast.PosInfo_AST.expr)

and ('s, 'r) _menhir_cell1_op_expr = 
  | MenhirCell1_op_expr of 's * ('s, 'r) _menhir_state * (Ast.PosInfo_AST.expr) * Lexing.position * Lexing.position

and ('s, 'r) _menhir_cell1_pattern = 
  | MenhirCell1_pattern of 's * ('s, 'r) _menhir_state * (Ast.PosInfo_AST.pattern)

and ('s, 'r) _menhir_cell1_typ = 
  | MenhirCell1_typ of 's * ('s, 'r) _menhir_state * (Ast.PosInfo_AST.typ) * Lexing.position

and ('s, 'r) _menhir_cell1_var_decl = 
  | MenhirCell1_var_decl of 's * ('s, 'r) _menhir_state * (Ast.PosInfo_AST.name * Ast.PosInfo_AST.typ list * Ast.PosInfo_AST.typ) * Lexing.position

and ('s, 'r) _menhir_cell1_ALLOW = 
  | MenhirCell1_ALLOW of 's * ('s, 'r) _menhir_state * Lexing.position

and ('s, 'r) _menhir_cell1_AMI = 
  | MenhirCell1_AMI of 's * ('s, 'r) _menhir_state * Lexing.position

and 's _menhir_cell0_AND = 
  | MenhirCell0_AND of 's * Lexing.position * Lexing.position

and ('s, 'r) _menhir_cell1_BAR = 
  | MenhirCell1_BAR of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_CHOOSE = 
  | MenhirCell1_CHOOSE of 's * ('s, 'r) _menhir_state * Lexing.position

and ('s, 'r) _menhir_cell1_COLON = 
  | MenhirCell1_COLON of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_DATA = 
  | MenhirCell1_DATA of 's * ('s, 'r) _menhir_state * Lexing.position

and 's _menhir_cell0_DIV = 
  | MenhirCell0_DIV of 's * Lexing.position * Lexing.position

and ('s, 'r) _menhir_cell1_EMULATEDLOCDECL = 
  | MenhirCell1_EMULATEDLOCDECL of 's * ('s, 'r) _menhir_state * Lexing.position

and 's _menhir_cell0_EQ = 
  | MenhirCell0_EQ of 's * Lexing.position * Lexing.position

and ('s, 'r) _menhir_cell1_FUN = 
  | MenhirCell1_FUN of 's * ('s, 'r) _menhir_state * Lexing.position

and 's _menhir_cell0_GEQ = 
  | MenhirCell0_GEQ of 's * Lexing.position * Lexing.position

and 's _menhir_cell0_GT = 
  | MenhirCell0_GT of 's * Lexing.position * Lexing.position

and ('s, 'r) _menhir_cell1_IMPORT = 
  | MenhirCell1_IMPORT of 's * ('s, 'r) _menhir_state * Lexing.position

and ('s, 'r) _menhir_cell1_LBRACK = 
  | MenhirCell1_LBRACK of 's * ('s, 'r) _menhir_state * Lexing.position

and 's _menhir_cell0_LBRACK = 
  | MenhirCell0_LBRACK of 's * Lexing.position

and 's _menhir_cell0_LEQ = 
  | MenhirCell0_LEQ of 's * Lexing.position * Lexing.position

and ('s, 'r) _menhir_cell1_LOCTY = 
  | MenhirCell1_LOCTY of 's * ('s, 'r) _menhir_state * Lexing.position

and ('s, 'r) _menhir_cell1_LPAREN = 
  | MenhirCell1_LPAREN of 's * ('s, 'r) _menhir_state * Lexing.position

and 's _menhir_cell0_LPAREN = 
  | MenhirCell0_LPAREN of 's * Lexing.position

and 's _menhir_cell0_LT = 
  | MenhirCell0_LT of 's * Lexing.position * Lexing.position

and ('s, 'r) _menhir_cell1_MATCH = 
  | MenhirCell1_MATCH of 's * ('s, 'r) _menhir_state * Lexing.position

and ('s, 'r) _menhir_cell1_MINUS = 
  | MenhirCell1_MINUS of 's * ('s, 'r) _menhir_state * Lexing.position * Lexing.position

and 's _menhir_cell0_MINUS = 
  | MenhirCell0_MINUS of 's * Lexing.position * Lexing.position

and 's _menhir_cell0_NEQ = 
  | MenhirCell0_NEQ of 's * Lexing.position * Lexing.position

and ('s, 'r) _menhir_cell1_NOT = 
  | MenhirCell1_NOT of 's * ('s, 'r) _menhir_state * Lexing.position * Lexing.position

and 's _menhir_cell0_OR = 
  | MenhirCell0_OR of 's * Lexing.position * Lexing.position

and 's _menhir_cell0_PLUS = 
  | MenhirCell0_PLUS of 's * Lexing.position * Lexing.position

and ('s, 'r) _menhir_cell1_RECV = 
  | MenhirCell1_RECV of 's * ('s, 'r) _menhir_state * Lexing.position

and ('s, 'r) _menhir_cell1_SEND = 
  | MenhirCell1_SEND of 's * ('s, 'r) _menhir_state * Lexing.position

and 's _menhir_cell0_TIMES = 
  | MenhirCell0_TIMES of 's * Lexing.position * Lexing.position

and ('s, 'r) _menhir_cell1_TYPEDECL = 
  | MenhirCell1_TYPEDECL of 's * ('s, 'r) _menhir_state * Lexing.position

and _menhir_box_program = 
  | MenhirBox_program of (Ast.PosInfo_AST.program) [@@unboxed]

let _menhir_action_01 =
  fun e l ->
    (
# 102 "lib/NetIR/parser.mly"
                                    ( (l, e) )
# 565 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.lab * Ast.PosInfo_AST.expr))

let _menhir_action_02 =
  fun e ->
    (
# 110 "lib/NetIR/parser.mly"
                                ( e )
# 573 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_03 =
  fun _endpos_a_ _startpos_f_ a f ->
    let _endpos = _endpos_a_ in
    let _startpos = _startpos_f_ in
    (
# 111 "lib/NetIR/parser.mly"
                                ( FunApp (mkpos _startpos _endpos, f, a))
# 583 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_04 =
  fun e ->
    (
# 114 "lib/NetIR/parser.mly"
                                ( e )
# 591 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_05 =
  fun _endpos__1_ _startpos__1_ ->
    let _endpos = _endpos__1_ in
    let _startpos = _startpos__1_ in
    (
# 115 "lib/NetIR/parser.mly"
                                (UnitLit (mkpos _startpos _endpos))
# 601 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_06 =
  fun _endpos_n_ _startpos_n_ n ->
    let _endpos = _endpos_n_ in
    let _startpos = _startpos_n_ in
    (
# 116 "lib/NetIR/parser.mly"
                                (IntLit (mkpos _startpos _endpos, n))
# 611 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_07 =
  fun _endpos_f_ _startpos_f_ f ->
    let _endpos = _endpos_f_ in
    let _startpos = _startpos_f_ in
    (
# 117 "lib/NetIR/parser.mly"
                                (FloatLit (mkpos _startpos _endpos, f))
# 621 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_08 =
  fun _endpos_c_ _startpos_c_ c ->
    let _endpos = _endpos_c_ in
    let _startpos = _startpos_c_ in
    (
# 118 "lib/NetIR/parser.mly"
                                (CharLit (mkpos _startpos _endpos, c))
# 631 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_09 =
  fun _endpos_s_ _startpos_s_ s ->
    let _endpos = _endpos_s_ in
    let _startpos = _startpos_s_ in
    (
# 119 "lib/NetIR/parser.mly"
                                (StringLit (mkpos _startpos _endpos, s))
# 641 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_10 =
  fun _endpos__1_ _startpos__1_ ->
    let _endpos = _endpos__1_ in
    let _startpos = _startpos__1_ in
    (
# 120 "lib/NetIR/parser.mly"
                                (TrueLit (mkpos _startpos _endpos))
# 651 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_11 =
  fun _endpos__1_ _startpos__1_ ->
    let _endpos = _endpos__1_ in
    let _startpos = _startpos__1_ in
    (
# 121 "lib/NetIR/parser.mly"
                                (FalseLit (mkpos _startpos _endpos))
# 661 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_12 =
  fun _endpos_l_ _startpos_l_ l ->
    let _endpos = _endpos_l_ in
    let _startpos = _startpos_l_ in
    (
# 122 "lib/NetIR/parser.mly"
                                (LocLit (mkpos _startpos _endpos, l))
# 671 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_13 =
  fun _endpos_s_ _startpos_s_ s ->
    let _endpos = _endpos_s_ in
    let _startpos = _startpos_s_ in
    (
# 123 "lib/NetIR/parser.mly"
                                (Var (mkpos _startpos _endpos, s))
# 681 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_14 =
  fun _endpos__1_ _startpos__1_ ->
    let _endpos = _endpos__1_ in
    let _startpos = _startpos__1_ in
    (
# 75 "lib/NetIR/parser.mly"
                            (WildcardPat (mkpos _startpos _endpos))
# 691 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.pattern))

let _menhir_action_15 =
  fun _endpos_s_ _startpos_s_ s ->
    let _endpos = _endpos_s_ in
    let _startpos = _startpos_s_ in
    (
# 76 "lib/NetIR/parser.mly"
                            (VarPat (mkpos _startpos _endpos, s))
# 701 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.pattern))

let _menhir_action_16 =
  fun _endpos__1_ _startpos__1_ ->
    let _endpos = _endpos__1_ in
    let _startpos = _startpos__1_ in
    (
# 77 "lib/NetIR/parser.mly"
                            (UnitLitPat (mkpos _startpos _endpos))
# 711 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.pattern))

let _menhir_action_17 =
  fun _endpos_n_ _startpos_n_ n ->
    let _endpos = _endpos_n_ in
    let _startpos = _startpos_n_ in
    (
# 78 "lib/NetIR/parser.mly"
                            (IntLitPat (mkpos _startpos _endpos, n))
# 721 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.pattern))

let _menhir_action_18 =
  fun _endpos_f_ _startpos_f_ f ->
    let _endpos = _endpos_f_ in
    let _startpos = _startpos_f_ in
    (
# 79 "lib/NetIR/parser.mly"
                            (FloatLitPat (mkpos _startpos _endpos, f))
# 731 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.pattern))

let _menhir_action_19 =
  fun _endpos_c_ _startpos_c_ c ->
    let _endpos = _endpos_c_ in
    let _startpos = _startpos_c_ in
    (
# 80 "lib/NetIR/parser.mly"
                            (CharLitPat (mkpos _startpos _endpos, c))
# 741 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.pattern))

let _menhir_action_20 =
  fun _endpos_s_ _startpos_s_ s ->
    let _endpos = _endpos_s_ in
    let _startpos = _startpos_s_ in
    (
# 81 "lib/NetIR/parser.mly"
                            (StringLitPat (mkpos _startpos _endpos, s))
# 751 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.pattern))

let _menhir_action_21 =
  fun _endpos__1_ _startpos__1_ ->
    let _endpos = _endpos__1_ in
    let _startpos = _startpos__1_ in
    (
# 82 "lib/NetIR/parser.mly"
                            (TrueLitPat (mkpos _startpos _endpos))
# 761 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.pattern))

let _menhir_action_22 =
  fun _endpos__1_ _startpos__1_ ->
    let _endpos = _endpos__1_ in
    let _startpos = _startpos__1_ in
    (
# 83 "lib/NetIR/parser.mly"
                            (FalseLitPat (mkpos _startpos _endpos))
# 771 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.pattern))

let _menhir_action_23 =
  fun _endpos_l_ _startpos_l_ l ->
    let _endpos = _endpos_l_ in
    let _startpos = _startpos_l_ in
    (
# 84 "lib/NetIR/parser.mly"
                            (LocLitPat (mkpos _startpos _endpos, l))
# 781 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.pattern))

let _menhir_action_24 =
  fun _endpos__5_ _startpos__1_ s ->
    let _endpos = _endpos__5_ in
    let _startpos = _startpos__1_ in
    (
# 85 "lib/NetIR/parser.mly"
                                       (LocNamePat (mkpos _startpos _endpos, s))
# 791 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.pattern))

let _menhir_action_25 =
  fun t ->
    (
# 54 "lib/NetIR/parser.mly"
                            ( t )
# 799 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.typ))

let _menhir_action_26 =
  fun _endpos__1_ _startpos__1_ ->
    let _endpos = _endpos__1_ in
    let _startpos = _startpos__1_ in
    (
# 55 "lib/NetIR/parser.mly"
                            (UnitTy (mkpos _startpos _endpos))
# 809 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.typ))

let _menhir_action_27 =
  fun _endpos__1_ _startpos__1_ ->
    let _endpos = _endpos__1_ in
    let _startpos = _startpos__1_ in
    (
# 56 "lib/NetIR/parser.mly"
                            (IntTy (mkpos _startpos _endpos))
# 819 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.typ))

let _menhir_action_28 =
  fun _endpos__1_ _startpos__1_ ->
    let _endpos = _endpos__1_ in
    let _startpos = _startpos__1_ in
    (
# 57 "lib/NetIR/parser.mly"
                            (FloatTy (mkpos _startpos _endpos))
# 829 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.typ))

let _menhir_action_29 =
  fun _endpos__1_ _startpos__1_ ->
    let _endpos = _endpos__1_ in
    let _startpos = _startpos__1_ in
    (
# 58 "lib/NetIR/parser.mly"
                            (CharTy (mkpos _startpos _endpos))
# 839 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.typ))

let _menhir_action_30 =
  fun _endpos__1_ _startpos__1_ ->
    let _endpos = _endpos__1_ in
    let _startpos = _startpos__1_ in
    (
# 59 "lib/NetIR/parser.mly"
                            (StringTy (mkpos _startpos _endpos))
# 849 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.typ))

let _menhir_action_31 =
  fun _endpos__1_ _startpos__1_ ->
    let _endpos = _endpos__1_ in
    let _startpos = _startpos__1_ in
    (
# 60 "lib/NetIR/parser.mly"
                            (BoolTy (mkpos _startpos _endpos))
# 859 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.typ))

let _menhir_action_32 =
  fun _endpos__4_ _startpos__1_ xs ->
    let ids = 
# 241 "<standard.mly>"
    ( xs )
# 867 "lib/NetIR/parser.ml"
     in
    let _endpos = _endpos__4_ in
    let _startpos = _startpos__1_ in
    (
# 61 "lib/NetIR/parser.mly"
                                                            (LocTy (mkpos _startpos _endpos, ids))
# 874 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.typ))

let _menhir_action_33 =
  fun _endpos_s_ _startpos_s_ s ->
    let _endpos = _endpos_s_ in
    let _startpos = _startpos_s_ in
    (
# 62 "lib/NetIR/parser.mly"
                            (VarTy (mkpos _startpos _endpos, s))
# 884 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.typ))

let _menhir_action_34 =
  fun _endpos_s_ _startpos__1_ s ->
    let _endpos = _endpos_s_ in
    let _startpos = _startpos__1_ in
    (
# 126 "lib/NetIR/parser.mly"
                                                    (EmulatedLocDecl (mkpos _startpos _endpos, s))
# 894 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.decl))

let _menhir_action_35 =
  fun _endpos_t_ _startpos_s_ s t ->
    let _endpos = _endpos_t_ in
    let _startpos = _startpos_s_ in
    (
# 127 "lib/NetIR/parser.mly"
                                                    (TypeDecl (mkpos _startpos _endpos, s, t))
# 904 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.decl))

let _menhir_action_36 =
  fun _endpos_t_ _startpos__1_ s t ->
    let _endpos = _endpos_t_ in
    let _startpos = _startpos__1_ in
    (
# 128 "lib/NetIR/parser.mly"
                                                    (TypeAliasDecl (mkpos _startpos _endpos, s, t))
# 914 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.decl))

let _menhir_action_37 =
  fun _endpos__5_ _startpos_s_ e l s ->
    let _endpos = _endpos__5_ in
    let _startpos = _startpos_s_ in
    (
# 129 "lib/NetIR/parser.mly"
                                                    (DefnDecl (mkpos _startpos _endpos, s, l, e))
# 924 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.decl))

let _menhir_action_38 =
  fun _endpos_s_ _startpos__1_ s ->
    let _endpos = _endpos_s_ in
    let _startpos = _startpos__1_ in
    (
# 130 "lib/NetIR/parser.mly"
                                                    (ImportDecl (mkpos _startpos _endpos, s))
# 934 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.decl))

let _menhir_action_39 =
  fun _endpos_l_ _startpos__1_ l s ->
    let _endpos = _endpos_l_ in
    let _startpos = _startpos__1_ in
    (
# 131 "lib/NetIR/parser.mly"
                                                    (VariantDecl (mkpos _startpos _endpos, s, l))
# 944 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.decl))

let _menhir_action_40 =
  fun e ->
    (
# 88 "lib/NetIR/parser.mly"
                                        ( e )
# 952 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_41 =
  fun _endpos__5_ _startpos__1_ e l ->
    let _endpos = _endpos__5_ in
    let _startpos = _startpos__1_ in
    (
# 89 "lib/NetIR/parser.mly"
                                                         (Match (mkpos _startpos _endpos, e, l))
# 962 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_42 =
  fun _endpos_e_ _startpos__1_ a e f ->
    let _endpos = _endpos_e_ in
    let _startpos = _startpos__1_ in
    (
# 90 "lib/NetIR/parser.mly"
                                        (RecAbs (mkpos _startpos _endpos, f, a, e))
# 972 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_43 =
  fun _endpos_t_ _startpos_e_ e t ->
    let _endpos = _endpos_t_ in
    let _startpos = _startpos_e_ in
    (
# 91 "lib/NetIR/parser.mly"
                                        (TypeConstr (mkpos _startpos _endpos, e, t))
# 982 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_44 =
  fun _endpos_s_ _startpos__1_ e s ->
    let _endpos = _endpos_s_ in
    let _startpos = _startpos__1_ in
    (
# 92 "lib/NetIR/parser.mly"
                                        (Send (mkpos _startpos _endpos, e, s))
# 992 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_45 =
  fun _endpos_s_ _startpos__1_ s t ->
    let _endpos = _endpos_s_ in
    let _startpos = _startpos__1_ in
    (
# 93 "lib/NetIR/parser.mly"
                                        (Recv (mkpos _startpos _endpos, t, s))
# 1002 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_46 =
  fun _endpos_s_ _startpos__1_ l s ->
    let _endpos = _endpos_s_ in
    let _startpos = _startpos__1_ in
    (
# 94 "lib/NetIR/parser.mly"
                                        (ChooseFor (mkpos _startpos _endpos, s, l))
# 1012 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_47 =
  fun _endpos_e_ _startpos__1_ e ->
    let _endpos = _endpos_e_ in
    let _startpos = _startpos__1_ in
    (
# 95 "lib/NetIR/parser.mly"
                                        (AmI (mkpos _startpos _endpos, e))
# 1022 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_48 =
  fun _endpos__5_ _startpos__1_ l s ->
    let _endpos = _endpos__5_ in
    let _startpos = _startpos__1_ in
    (
# 96 "lib/NetIR/parser.mly"
                                                         (AllowChoice (mkpos _startpos _endpos, s, l))
# 1032 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_49 =
  fun _endpos_s_ _startpos_s_ s ->
    let _endpos = _endpos_s_ in
    let _startpos = _startpos_s_ in
    (
# 41 "lib/NetIR/parser.mly"
            ((mkpos _startpos _endpos, s))
# 1042 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.name))

let _menhir_action_50 =
  fun s ->
    (
# 47 "lib/NetIR/parser.mly"
                                ( Label s )
# 1050 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.lab))

let _menhir_action_51 =
  fun () ->
    (
# 216 "<standard.mly>"
    ( [] )
# 1058 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.program))

let _menhir_action_52 =
  fun x xs ->
    (
# 219 "<standard.mly>"
    ( x :: xs )
# 1066 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.program))

let _menhir_action_53 =
  fun () ->
    (
# 216 "<standard.mly>"
    ( [] )
# 1074 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.pattern list))

let _menhir_action_54 =
  fun x xs ->
    (
# 219 "<standard.mly>"
    ( x :: xs )
# 1082 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.pattern list))

let _menhir_action_55 =
  fun _endpos_s_ _startpos_s_ s ->
    let _endpos = _endpos_s_ in
    let _startpos = _startpos_s_ in
    (
# 44 "lib/NetIR/parser.mly"
               ((mkpos _startpos _endpos, s))
# 1092 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.name))

let _menhir_action_56 =
  fun () ->
    (
# 145 "<standard.mly>"
    ( [] )
# 1100 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.name list))

let _menhir_action_57 =
  fun x ->
    (
# 148 "<standard.mly>"
    ( x )
# 1108 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.name list))

let _menhir_action_58 =
  fun a e ->
    (
# 99 "lib/NetIR/parser.mly"
                                    ( (a, e) )
# 1116 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.pattern * Ast.PosInfo_AST.expr))

let _menhir_action_59 =
  fun x ->
    (
# 228 "<standard.mly>"
    ( [ x ] )
# 1124 "lib/NetIR/parser.ml"
     : ((Ast.PosInfo_AST.lab * Ast.PosInfo_AST.expr) list))

let _menhir_action_60 =
  fun x xs ->
    (
# 231 "<standard.mly>"
    ( x :: xs )
# 1132 "lib/NetIR/parser.ml"
     : ((Ast.PosInfo_AST.lab * Ast.PosInfo_AST.expr) list))

let _menhir_action_61 =
  fun x ->
    (
# 228 "<standard.mly>"
    ( [ x ] )
# 1140 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.pattern list))

let _menhir_action_62 =
  fun x xs ->
    (
# 231 "<standard.mly>"
    ( x :: xs )
# 1148 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.pattern list))

let _menhir_action_63 =
  fun x ->
    (
# 228 "<standard.mly>"
    ( [ x ] )
# 1156 "lib/NetIR/parser.ml"
     : ((Ast.PosInfo_AST.pattern * Ast.PosInfo_AST.expr) list))

let _menhir_action_64 =
  fun x xs ->
    (
# 231 "<standard.mly>"
    ( x :: xs )
# 1164 "lib/NetIR/parser.ml"
     : ((Ast.PosInfo_AST.pattern * Ast.PosInfo_AST.expr) list))

let _menhir_action_65 =
  fun x ->
    (
# 228 "<standard.mly>"
    ( [ x ] )
# 1172 "lib/NetIR/parser.ml"
     : ((Ast.PosInfo_AST.name * Ast.PosInfo_AST.typ list * Ast.PosInfo_AST.typ)
  list))

let _menhir_action_66 =
  fun x xs ->
    (
# 231 "<standard.mly>"
    ( x :: xs )
# 1181 "lib/NetIR/parser.ml"
     : ((Ast.PosInfo_AST.name * Ast.PosInfo_AST.typ list * Ast.PosInfo_AST.typ)
  list))

let _menhir_action_67 =
  fun e ->
    (
# 105 "lib/NetIR/parser.mly"
                                            ( e )
# 1190 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_68 =
  fun _endpos__1_ _endpos_e2_ _startpos__1_ _startpos_e1_ e1 e2 ->
    let op =
      let _endpos = _endpos__1_ in
      let _startpos = _startpos__1_ in
      
# 155 "lib/NetIR/parser.mly"
                  ( Plus  (mkpos _startpos _endpos) )
# 1201 "lib/NetIR/parser.ml"
      
    in
    let _endpos = _endpos_e2_ in
    let _startpos = _startpos_e1_ in
    (
# 106 "lib/NetIR/parser.mly"
                                            (Binop (mkpos _startpos _endpos, op, e1, e2))
# 1209 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_69 =
  fun _endpos__1_ _endpos_e2_ _startpos__1_ _startpos_e1_ e1 e2 ->
    let op =
      let _endpos = _endpos__1_ in
      let _startpos = _startpos__1_ in
      
# 156 "lib/NetIR/parser.mly"
                  ( Minus (mkpos _startpos _endpos) )
# 1220 "lib/NetIR/parser.ml"
      
    in
    let _endpos = _endpos_e2_ in
    let _startpos = _startpos_e1_ in
    (
# 106 "lib/NetIR/parser.mly"
                                            (Binop (mkpos _startpos _endpos, op, e1, e2))
# 1228 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_70 =
  fun _endpos__1_ _endpos_e2_ _startpos__1_ _startpos_e1_ e1 e2 ->
    let op =
      let _endpos = _endpos__1_ in
      let _startpos = _startpos__1_ in
      
# 157 "lib/NetIR/parser.mly"
                  ( Times (mkpos _startpos _endpos) )
# 1239 "lib/NetIR/parser.ml"
      
    in
    let _endpos = _endpos_e2_ in
    let _startpos = _startpos_e1_ in
    (
# 106 "lib/NetIR/parser.mly"
                                            (Binop (mkpos _startpos _endpos, op, e1, e2))
# 1247 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_71 =
  fun _endpos__1_ _endpos_e2_ _startpos__1_ _startpos_e1_ e1 e2 ->
    let op =
      let _endpos = _endpos__1_ in
      let _startpos = _startpos__1_ in
      
# 158 "lib/NetIR/parser.mly"
                  ( Div   (mkpos _startpos _endpos) )
# 1258 "lib/NetIR/parser.ml"
      
    in
    let _endpos = _endpos_e2_ in
    let _startpos = _startpos_e1_ in
    (
# 106 "lib/NetIR/parser.mly"
                                            (Binop (mkpos _startpos _endpos, op, e1, e2))
# 1266 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_72 =
  fun _endpos__1_ _endpos_e2_ _startpos__1_ _startpos_e1_ e1 e2 ->
    let op =
      let _endpos = _endpos__1_ in
      let _startpos = _startpos__1_ in
      
# 159 "lib/NetIR/parser.mly"
                  ( And   (mkpos _startpos _endpos) )
# 1277 "lib/NetIR/parser.ml"
      
    in
    let _endpos = _endpos_e2_ in
    let _startpos = _startpos_e1_ in
    (
# 106 "lib/NetIR/parser.mly"
                                            (Binop (mkpos _startpos _endpos, op, e1, e2))
# 1285 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_73 =
  fun _endpos__1_ _endpos_e2_ _startpos__1_ _startpos_e1_ e1 e2 ->
    let op =
      let _endpos = _endpos__1_ in
      let _startpos = _startpos__1_ in
      
# 160 "lib/NetIR/parser.mly"
                  ( Or    (mkpos _startpos _endpos) )
# 1296 "lib/NetIR/parser.ml"
      
    in
    let _endpos = _endpos_e2_ in
    let _startpos = _startpos_e1_ in
    (
# 106 "lib/NetIR/parser.mly"
                                            (Binop (mkpos _startpos _endpos, op, e1, e2))
# 1304 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_74 =
  fun _endpos__1_ _endpos_e2_ _startpos__1_ _startpos_e1_ e1 e2 ->
    let op =
      let _endpos = _endpos__1_ in
      let _startpos = _startpos__1_ in
      
# 161 "lib/NetIR/parser.mly"
                  ( Eq    (mkpos _startpos _endpos) )
# 1315 "lib/NetIR/parser.ml"
      
    in
    let _endpos = _endpos_e2_ in
    let _startpos = _startpos_e1_ in
    (
# 106 "lib/NetIR/parser.mly"
                                            (Binop (mkpos _startpos _endpos, op, e1, e2))
# 1323 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_75 =
  fun _endpos__1_ _endpos_e2_ _startpos__1_ _startpos_e1_ e1 e2 ->
    let op =
      let _endpos = _endpos__1_ in
      let _startpos = _startpos__1_ in
      
# 162 "lib/NetIR/parser.mly"
                  ( Neq   (mkpos _startpos _endpos) )
# 1334 "lib/NetIR/parser.ml"
      
    in
    let _endpos = _endpos_e2_ in
    let _startpos = _startpos_e1_ in
    (
# 106 "lib/NetIR/parser.mly"
                                            (Binop (mkpos _startpos _endpos, op, e1, e2))
# 1342 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_76 =
  fun _endpos__1_ _endpos_e2_ _startpos__1_ _startpos_e1_ e1 e2 ->
    let op =
      let _endpos = _endpos__1_ in
      let _startpos = _startpos__1_ in
      
# 163 "lib/NetIR/parser.mly"
                  ( Lt    (mkpos _startpos _endpos) )
# 1353 "lib/NetIR/parser.ml"
      
    in
    let _endpos = _endpos_e2_ in
    let _startpos = _startpos_e1_ in
    (
# 106 "lib/NetIR/parser.mly"
                                            (Binop (mkpos _startpos _endpos, op, e1, e2))
# 1361 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_77 =
  fun _endpos__1_ _endpos_e2_ _startpos__1_ _startpos_e1_ e1 e2 ->
    let op =
      let _endpos = _endpos__1_ in
      let _startpos = _startpos__1_ in
      
# 164 "lib/NetIR/parser.mly"
                  ( Leq   (mkpos _startpos _endpos) )
# 1372 "lib/NetIR/parser.ml"
      
    in
    let _endpos = _endpos_e2_ in
    let _startpos = _startpos_e1_ in
    (
# 106 "lib/NetIR/parser.mly"
                                            (Binop (mkpos _startpos _endpos, op, e1, e2))
# 1380 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_78 =
  fun _endpos__1_ _endpos_e2_ _startpos__1_ _startpos_e1_ e1 e2 ->
    let op =
      let _endpos = _endpos__1_ in
      let _startpos = _startpos__1_ in
      
# 165 "lib/NetIR/parser.mly"
                  ( Gt    (mkpos _startpos _endpos) )
# 1391 "lib/NetIR/parser.ml"
      
    in
    let _endpos = _endpos_e2_ in
    let _startpos = _startpos_e1_ in
    (
# 106 "lib/NetIR/parser.mly"
                                            (Binop (mkpos _startpos _endpos, op, e1, e2))
# 1399 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_79 =
  fun _endpos__1_ _endpos_e2_ _startpos__1_ _startpos_e1_ e1 e2 ->
    let op =
      let _endpos = _endpos__1_ in
      let _startpos = _startpos__1_ in
      
# 166 "lib/NetIR/parser.mly"
                  ( Geq   (mkpos _startpos _endpos) )
# 1410 "lib/NetIR/parser.ml"
      
    in
    let _endpos = _endpos_e2_ in
    let _startpos = _startpos_e1_ in
    (
# 106 "lib/NetIR/parser.mly"
                                            (Binop (mkpos _startpos _endpos, op, e1, e2))
# 1418 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_80 =
  fun _endpos__1_ _endpos_e_ _startpos__1_ e ->
    let op =
      let _endpos = _endpos__1_ in
      let _startpos = _startpos__1_ in
      
# 151 "lib/NetIR/parser.mly"
                  ( Neg   (mkpos _startpos _endpos) )
# 1429 "lib/NetIR/parser.ml"
      
    in
    let _startpos_op_ = _startpos__1_ in
    let _endpos = _endpos_e_ in
    let _startpos = _startpos_op_ in
    (
# 107 "lib/NetIR/parser.mly"
                                ( Unop (mkpos _startpos _endpos, op, e))
# 1438 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_81 =
  fun _endpos__1_ _endpos_e_ _startpos__1_ e ->
    let op =
      let _endpos = _endpos__1_ in
      let _startpos = _startpos__1_ in
      
# 152 "lib/NetIR/parser.mly"
                  ( Not   (mkpos _startpos _endpos) )
# 1449 "lib/NetIR/parser.ml"
      
    in
    let _startpos_op_ = _startpos__1_ in
    let _endpos = _endpos_e_ in
    let _startpos = _startpos_op_ in
    (
# 107 "lib/NetIR/parser.mly"
                                ( Unop (mkpos _startpos _endpos, op, e))
# 1458 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.expr))

let _menhir_action_82 =
  fun _endpos__4_ _startpos_s_ l s ->
    let _endpos = _endpos__4_ in
    let _startpos = _startpos_s_ in
    (
# 71 "lib/NetIR/parser.mly"
                                                            (ConstructorPat (mkpos _startpos _endpos, s, l))
# 1468 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.pattern))

let _menhir_action_83 =
  fun p ->
    (
# 72 "lib/NetIR/parser.mly"
                                                            ( p )
# 1476 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.pattern))

let _menhir_action_84 =
  fun l ->
    (
# 38 "lib/NetIR/parser.mly"
                       (l)
# 1484 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.program))

let _menhir_action_85 =
  fun x ->
    (
# 250 "<standard.mly>"
    ( [ x ] )
# 1492 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.name list))

let _menhir_action_86 =
  fun x xs ->
    (
# 253 "<standard.mly>"
    ( x :: xs )
# 1500 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.name list))

let _menhir_action_87 =
  fun t ->
    (
# 50 "lib/NetIR/parser.mly"
                                    ( t )
# 1508 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.typ))

let _menhir_action_88 =
  fun _endpos_t2_ _startpos_t1_ t1 t2 ->
    let _endpos = _endpos_t2_ in
    let _startpos = _startpos_t1_ in
    (
# 51 "lib/NetIR/parser.mly"
                                    (FunTy ((mkpos _startpos _endpos), t1, t2))
# 1518 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.typ))

let _menhir_action_89 =
  fun s t ->
    (
# 135 "lib/NetIR/parser.mly"
        (
            let rec get_last_typ = function
                | (acc, FunTy (_, t1, t2)) -> get_last_typ (t1 :: acc, t2) 
                    (* This will build the type list backwards, so we have to reverse it when returning*)
                | (acc, t1) -> (List.rev acc, t1)
            in
            let arg_typs, ret_typ = get_last_typ ([], t) in
                (s, arg_typs, ret_typ)
        )
# 1534 "lib/NetIR/parser.ml"
     : (Ast.PosInfo_AST.name * Ast.PosInfo_AST.typ list * Ast.PosInfo_AST.typ))

let _menhir_print_token : token -> string =
  fun _tok ->
    match _tok with
    | WITH ->
        "WITH"
    | WILDCARD ->
        "WILDCARD"
    | WALRUS ->
        "WALRUS"
    | UNITTY ->
        "UNITTY"
    | UNITLIT ->
        "UNITLIT"
    | TYPEDECL ->
        "TYPEDECL"
    | TRUELIT ->
        "TRUELIT"
    | TO ->
        "TO"
    | TIMES ->
        "TIMES"
    | STRINGTY ->
        "STRINGTY"
    | STRINGLIT _ ->
        "STRINGLIT"
    | SEND ->
        "SEND"
    | SEMICOLON ->
        "SEMICOLON"
    | RPAREN ->
        "RPAREN"
    | RECV ->
        "RECV"
    | RBRACK ->
        "RBRACK"
    | RBRACE ->
        "RBRACE"
    | PLUS ->
        "PLUS"
    | OR ->
        "OR"
    | NOT ->
        "NOT"
    | NEQ ->
        "NEQ"
    | MINUS ->
        "MINUS"
    | MATCH ->
        "MATCH"
    | LT ->
        "LT"
    | LPAREN ->
        "LPAREN"
    | LOCTY ->
        "LOCTY"
    | LOCLIT _ ->
        "LOCLIT"
    | LEQ ->
        "LEQ"
    | LBRACK ->
        "LBRACK"
    | LBRACE ->
        "LBRACE"
    | INTTY ->
        "INTTY"
    | INTLIT _ ->
        "INTLIT"
    | IMPORT ->
        "IMPORT"
    | ID _ ->
        "ID"
    | GT ->
        "GT"
    | GEQ ->
        "GEQ"
    | FUN ->
        "FUN"
    | FROM ->
        "FROM"
    | FOR ->
        "FOR"
    | FLOATTY ->
        "FLOATTY"
    | FLOATLIT _ ->
        "FLOATLIT"
    | FALSELIT ->
        "FALSELIT"
    | EQ ->
        "EQ"
    | EOF ->
        "EOF"
    | END ->
        "END"
    | EMULATEDLOCDECL ->
        "EMULATEDLOCDECL"
    | DOUBLEARROW ->
        "DOUBLEARROW"
    | DIV ->
        "DIV"
    | DATA ->
        "DATA"
    | COMMA ->
        "COMMA"
    | COLON ->
        "COLON"
    | CHOOSE ->
        "CHOOSE"
    | CHOICE ->
        "CHOICE"
    | CHARTY ->
        "CHARTY"
    | CHARLIT _ ->
        "CHARLIT"
    | BOOLTY ->
        "BOOLTY"
    | BAR ->
        "BAR"
    | ARROW ->
        "ARROW"
    | AND ->
        "AND"
    | AMI ->
        "AMI"
    | ALLOW ->
        "ALLOW"

let _menhir_fail : unit -> 'a =
  fun () ->
    Printf.eprintf "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

include struct
  
  [@@@ocaml.warning "-4-37"]
  
  let _menhir_run_043 : type  ttv_stack. ttv_stack -> _ -> _menhir_box_program =
    fun _menhir_stack _v ->
      let l = _v in
      let _v = _menhir_action_84 l in
      MenhirBox_program _v
  
  let rec _menhir_run_167 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_decl -> _ -> _menhir_box_program =
    fun _menhir_stack _v ->
      let MenhirCell1_decl (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_52 x xs in
      _menhir_goto_list_decl_ _menhir_stack _v _menhir_s
  
  and _menhir_goto_list_decl_ : type  ttv_stack. ttv_stack -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _v _menhir_s ->
      match _menhir_s with
      | MenhirState000 ->
          _menhir_run_043 _menhir_stack _v
      | MenhirState166 ->
          _menhir_run_167 _menhir_stack _v
      | _ ->
          _menhir_fail ()
  
  let rec _menhir_run_001 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _menhir_stack = MenhirCell1_TYPEDECL (_menhir_stack, _menhir_s, _startpos) in
      let _menhir_s = MenhirState001 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | ID _v ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_002 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let (_endpos_s_, _startpos_s_, s) = (_endpos, _startpos, _v) in
      let _v = _menhir_action_49 _endpos_s_ _startpos_s_ s in
      _menhir_goto_id _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_s_ _startpos_s_ _v _menhir_s _tok
  
  and _menhir_goto_id : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState001 ->
          _menhir_run_003 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState004 ->
          _menhir_run_023 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState007 ->
          _menhir_run_023 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState025 ->
          _menhir_run_023 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState037 ->
          _menhir_run_023 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState058 ->
          _menhir_run_023 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState080 ->
          _menhir_run_023 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState140 ->
          _menhir_run_023 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState028 ->
          _menhir_run_029 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState030 ->
          _menhir_run_031 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState032 ->
          _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState035 ->
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState000 ->
          _menhir_run_045 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState166 ->
          _menhir_run_045 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState051 ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState045 ->
          _menhir_run_064 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState061 ->
          _menhir_run_064 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState150 ->
          _menhir_run_064 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState065 ->
          _menhir_run_068 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState069 ->
          _menhir_run_068 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState082 ->
          _menhir_run_083 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState073 ->
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState077 ->
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState078 ->
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState079 ->
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState084 ->
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState092 ->
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState096 ->
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState098 ->
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState100 ->
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState102 ->
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState104 ->
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState106 ->
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState108 ->
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState110 ->
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState112 ->
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState114 ->
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState116 ->
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState118 ->
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState120 ->
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState122 ->
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState132 ->
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState138 ->
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState152 ->
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState093 ->
          _menhir_run_094 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState094 ->
          _menhir_run_095 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState130 ->
          _menhir_run_131 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState133 ->
          _menhir_run_134 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState162 ->
          _menhir_run_163 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_003 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_TYPEDECL as 'stack) -> _ -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_id (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
      match (_tok : MenhirBasics.token) with
      | WALRUS ->
          let _menhir_s = MenhirState004 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | UNITTY ->
              _menhir_run_005 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | STRINGTY ->
              _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LPAREN ->
              _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LOCTY ->
              _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | INTTY ->
              _menhir_run_017 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | ID _v ->
              _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FLOATTY ->
              _menhir_run_018 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | CHARTY ->
              _menhir_run_019 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | BOOLTY ->
              _menhir_run_020 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_005 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let (_endpos__1_, _startpos__1_) = (_endpos, _startpos) in
      let _v = _menhir_action_26 _endpos__1_ _startpos__1_ in
      _menhir_goto_atomic_typ _menhir_stack _menhir_lexbuf _menhir_lexer _endpos__1_ _startpos__1_ _v _menhir_s _tok
  
  and _menhir_goto_atomic_typ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | ARROW ->
          let _menhir_stack = MenhirCell1_atomic_typ (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          let _menhir_s = MenhirState025 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | UNITTY ->
              _menhir_run_005 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | STRINGTY ->
              _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LPAREN ->
              _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LOCTY ->
              _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | INTTY ->
              _menhir_run_017 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | ID _v ->
              _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FLOATTY ->
              _menhir_run_018 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | CHARTY ->
              _menhir_run_019 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | BOOLTY ->
              _menhir_run_020 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | BAR | DATA | EMULATEDLOCDECL | END | EOF | FROM | ID _ | IMPORT | RPAREN | SEMICOLON | TYPEDECL | WITH ->
          let (_endpos_t_, t) = (_endpos, _v) in
          let _v = _menhir_action_87 t in
          _menhir_goto_typ _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_t_ _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_006 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let (_endpos__1_, _startpos__1_) = (_endpos, _startpos) in
      let _v = _menhir_action_30 _endpos__1_ _startpos__1_ in
      _menhir_goto_atomic_typ _menhir_stack _menhir_lexbuf _menhir_lexer _endpos__1_ _startpos__1_ _v _menhir_s _tok
  
  and _menhir_run_007 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _menhir_stack = MenhirCell1_LPAREN (_menhir_stack, _menhir_s, _startpos) in
      let _menhir_s = MenhirState007 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UNITTY ->
          _menhir_run_005 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | STRINGTY ->
          _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAREN ->
          _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LOCTY ->
          _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | INTTY ->
          _menhir_run_017 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | ID _v ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOATTY ->
          _menhir_run_018 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | CHARTY ->
          _menhir_run_019 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | BOOLTY ->
          _menhir_run_020 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_008 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _menhir_stack = MenhirCell1_LOCTY (_menhir_stack, _menhir_s, _startpos) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | LBRACE ->
          let _menhir_s = MenhirState009 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | LOCLIT _v ->
              _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | RBRACE ->
              let _v = _menhir_action_56 () in
              _menhir_goto_loption_separated_nonempty_list_COMMA_loclit__ _menhir_stack _menhir_lexbuf _menhir_lexer _v
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_010 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let (_endpos_s_, _startpos_s_, s) = (_endpos, _startpos, _v) in
      let _v = _menhir_action_55 _endpos_s_ _startpos_s_ s in
      _menhir_goto_loclit _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_s_ _startpos_s_ _v _menhir_s _tok
  
  and _menhir_goto_loclit : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState009 ->
          _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState015 ->
          _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState045 ->
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState061 ->
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState065 ->
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState069 ->
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState150 ->
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState073 ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState077 ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState078 ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState079 ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState084 ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState092 ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState096 ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState098 ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState100 ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState102 ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState104 ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState106 ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState108 ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState110 ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState112 ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState114 ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState116 ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState118 ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState120 ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState122 ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState132 ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState138 ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState152 ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState126 ->
          _menhir_run_127 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_014 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | COMMA ->
          let _menhir_stack = MenhirCell1_loclit (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          let _menhir_s = MenhirState015 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | LOCLIT _v ->
              _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | RBRACE ->
          let x = _v in
          let _v = _menhir_action_85 x in
          _menhir_goto_separated_nonempty_list_COMMA_loclit_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_goto_separated_nonempty_list_COMMA_loclit_ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState009 ->
          _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState015 ->
          _menhir_run_016 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_011 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_LOCTY -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let x = _v in
      let _v = _menhir_action_57 x in
      _menhir_goto_loption_separated_nonempty_list_COMMA_loclit__ _menhir_stack _menhir_lexbuf _menhir_lexer _v
  
  and _menhir_goto_loption_separated_nonempty_list_COMMA_loclit__ : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_LOCTY -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell1_LOCTY (_menhir_stack, _menhir_s, _startpos__1_) = _menhir_stack in
      let (xs, _endpos__4_) = (_v, _endpos) in
      let _v = _menhir_action_32 _endpos__4_ _startpos__1_ xs in
      _menhir_goto_atomic_typ _menhir_stack _menhir_lexbuf _menhir_lexer _endpos__4_ _startpos__1_ _v _menhir_s _tok
  
  and _menhir_run_016 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_loclit -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_loclit (_menhir_stack, _menhir_s, x, _, _) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_86 x xs in
      _menhir_goto_separated_nonempty_list_COMMA_loclit_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_run_062 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      let (_endpos_l_, _startpos_l_, l) = (_endpos, _startpos, _v) in
      let _v = _menhir_action_23 _endpos_l_ _startpos_l_ l in
      _menhir_goto_atomic_pattern _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_atomic_pattern : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState065 ->
          _menhir_run_069 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState069 ->
          _menhir_run_069 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState045 ->
          _menhir_run_071 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState061 ->
          _menhir_run_071 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState150 ->
          _menhir_run_071 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_069 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | WILDCARD ->
          let _menhir_stack = MenhirCell1_atomic_pattern (_menhir_stack, _menhir_s, _v) in
          _menhir_run_046 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState069
      | UNITLIT ->
          let _menhir_stack = MenhirCell1_atomic_pattern (_menhir_stack, _menhir_s, _v) in
          _menhir_run_047 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState069
      | TRUELIT ->
          let _menhir_stack = MenhirCell1_atomic_pattern (_menhir_stack, _menhir_s, _v) in
          _menhir_run_048 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState069
      | STRINGLIT _v_0 ->
          let _menhir_stack = MenhirCell1_atomic_pattern (_menhir_stack, _menhir_s, _v) in
          _menhir_run_049 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState069
      | LOCLIT _v_1 ->
          let _menhir_stack = MenhirCell1_atomic_pattern (_menhir_stack, _menhir_s, _v) in
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState069
      | LBRACK ->
          let _menhir_stack = MenhirCell1_atomic_pattern (_menhir_stack, _menhir_s, _v) in
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState069
      | INTLIT _v_2 ->
          let _menhir_stack = MenhirCell1_atomic_pattern (_menhir_stack, _menhir_s, _v) in
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _v_2 MenhirState069
      | ID _v_3 ->
          let _menhir_stack = MenhirCell1_atomic_pattern (_menhir_stack, _menhir_s, _v) in
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v_3 MenhirState069
      | FLOATLIT _v_4 ->
          let _menhir_stack = MenhirCell1_atomic_pattern (_menhir_stack, _menhir_s, _v) in
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v_4 MenhirState069
      | FALSELIT ->
          let _menhir_stack = MenhirCell1_atomic_pattern (_menhir_stack, _menhir_s, _v) in
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState069
      | CHARLIT _v_5 ->
          let _menhir_stack = MenhirCell1_atomic_pattern (_menhir_stack, _menhir_s, _v) in
          _menhir_run_060 _menhir_stack _menhir_lexbuf _menhir_lexer _v_5 MenhirState069
      | RPAREN ->
          let x = _v in
          let _v = _menhir_action_61 x in
          _menhir_goto_nonempty_list_atomic_pattern_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_046 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let (_endpos__1_, _startpos__1_) = (_endpos, _startpos) in
      let _v = _menhir_action_14 _endpos__1_ _startpos__1_ in
      _menhir_goto_atomic_pattern _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_047 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let (_endpos__1_, _startpos__1_) = (_endpos, _startpos) in
      let _v = _menhir_action_16 _endpos__1_ _startpos__1_ in
      _menhir_goto_atomic_pattern _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_048 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let (_endpos__1_, _startpos__1_) = (_endpos, _startpos) in
      let _v = _menhir_action_21 _endpos__1_ _startpos__1_ in
      _menhir_goto_atomic_pattern _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_049 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let (_endpos_s_, _startpos_s_, s) = (_endpos, _startpos, _v) in
      let _v = _menhir_action_20 _endpos_s_ _startpos_s_ s in
      _menhir_goto_atomic_pattern _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_050 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _menhir_stack = MenhirCell1_LBRACK (_menhir_stack, _menhir_s, _startpos) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | LBRACK ->
          let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
          let _menhir_stack = MenhirCell0_LBRACK (_menhir_stack, _startpos) in
          let _menhir_s = MenhirState051 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | ID _v ->
              _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_055 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let (_endpos_n_, _startpos_n_, n) = (_endpos, _startpos, _v) in
      let _v = _menhir_action_17 _endpos_n_ _startpos_n_ n in
      _menhir_goto_atomic_pattern _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_056 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let (_endpos_f_, _startpos_f_, f) = (_endpos, _startpos, _v) in
      let _v = _menhir_action_18 _endpos_f_ _startpos_f_ f in
      _menhir_goto_atomic_pattern _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_057 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let (_endpos__1_, _startpos__1_) = (_endpos, _startpos) in
      let _v = _menhir_action_22 _endpos__1_ _startpos__1_ in
      _menhir_goto_atomic_pattern _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_060 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let (_endpos_c_, _startpos_c_, c) = (_endpos, _startpos, _v) in
      let _v = _menhir_action_19 _endpos_c_ _startpos_c_ c in
      _menhir_goto_atomic_pattern _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_nonempty_list_atomic_pattern_ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState065 ->
          _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState069 ->
          _menhir_run_070 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_066 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_id _menhir_cell0_LPAREN -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell0_LPAREN (_menhir_stack, _) = _menhir_stack in
      let MenhirCell1_id (_menhir_stack, _menhir_s, s, _startpos_s_, _) = _menhir_stack in
      let (l, _endpos__4_) = (_v, _endpos) in
      let _v = _menhir_action_82 _endpos__4_ _startpos_s_ l s in
      _menhir_goto_pattern _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_pattern : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState045 ->
          _menhir_run_061 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState061 ->
          _menhir_run_061 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState150 ->
          _menhir_run_151 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_061 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_pattern (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | WILDCARD ->
          _menhir_run_046 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState061
      | UNITLIT ->
          _menhir_run_047 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState061
      | TRUELIT ->
          _menhir_run_048 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState061
      | STRINGLIT _v_0 ->
          _menhir_run_049 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState061
      | LOCLIT _v_1 ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState061
      | LBRACK ->
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState061
      | INTLIT _v_2 ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _v_2 MenhirState061
      | ID _v_3 ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v_3 MenhirState061
      | FLOATLIT _v_4 ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v_4 MenhirState061
      | FALSELIT ->
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState061
      | CHARLIT _v_5 ->
          _menhir_run_060 _menhir_stack _menhir_lexbuf _menhir_lexer _v_5 MenhirState061
      | WALRUS ->
          let _v_6 = _menhir_action_53 () in
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v_6
      | _ ->
          _eRR ()
  
  and _menhir_run_063 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_pattern -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_pattern (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_54 x xs in
      _menhir_goto_list_pattern_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_goto_list_pattern_ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState061 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState045 ->
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_072 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_id as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_list_pattern_ (_menhir_stack, _menhir_s, _v) in
      let _menhir_s = MenhirState073 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UNITLIT ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | TRUELIT ->
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | STRINGLIT _v ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | SEND ->
          _menhir_run_077 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | RECV ->
          _menhir_run_080 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NOT ->
          _menhir_run_078 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | MINUS ->
          _menhir_run_084 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | MATCH ->
          _menhir_run_092 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAREN ->
          _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LOCLIT _v ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | INTLIT _v ->
          _menhir_run_085 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | ID _v ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FUN ->
          _menhir_run_093 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | FLOATLIT _v ->
          _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FALSELIT ->
          _menhir_run_087 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | CHOOSE ->
          _menhir_run_125 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | CHARLIT _v ->
          _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | AMI ->
          _menhir_run_132 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | ALLOW ->
          _menhir_run_133 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_074 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let (_endpos__1_, _startpos__1_) = (_endpos, _startpos) in
      let _v = _menhir_action_05 _endpos__1_ _startpos__1_ in
      _menhir_goto_atomic_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos__1_ _startpos__1_ _v _menhir_s _tok
  
  and _menhir_goto_atomic_expr : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState084 ->
          _menhir_run_091 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState098 ->
          _menhir_run_099 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState100 ->
          _menhir_run_101 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState102 ->
          _menhir_run_103 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState104 ->
          _menhir_run_105 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState106 ->
          _menhir_run_107 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState108 ->
          _menhir_run_109 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState110 ->
          _menhir_run_111 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState112 ->
          _menhir_run_113 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState114 ->
          _menhir_run_115 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState116 ->
          _menhir_run_117 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState118 ->
          _menhir_run_119 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState120 ->
          _menhir_run_121 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState073 ->
          _menhir_run_122 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState077 ->
          _menhir_run_122 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState079 ->
          _menhir_run_122 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState092 ->
          _menhir_run_122 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState096 ->
          _menhir_run_122 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState122 ->
          _menhir_run_122 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState132 ->
          _menhir_run_122 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState138 ->
          _menhir_run_122 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState152 ->
          _menhir_run_122 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState078 ->
          _menhir_run_160 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_091 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_MINUS -> _ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell1_MINUS (_menhir_stack, _menhir_s, _startpos__1_, _endpos__1_) = _menhir_stack in
      let (_endpos_e_, e) = (_endpos, _v) in
      let _v = _menhir_action_80 _endpos__1_ _endpos_e_ _startpos__1_ e in
      _menhir_goto_op_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_e_ _startpos__1_ _v _menhir_s _tok
  
  and _menhir_goto_op_expr : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState096 ->
          _menhir_run_097 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState073 ->
          _menhir_run_139 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState079 ->
          _menhir_run_139 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState092 ->
          _menhir_run_139 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState132 ->
          _menhir_run_139 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState138 ->
          _menhir_run_139 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState152 ->
          _menhir_run_139 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState077 ->
          _menhir_run_161 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_097 : type  ttv_stack. ((((ttv_stack, _menhir_box_program) _menhir_cell1_FUN, _menhir_box_program) _menhir_cell1_id, _menhir_box_program) _menhir_cell1_id as 'stack) -> _ -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_op_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_098 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUS ->
          let _menhir_stack = MenhirCell1_op_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_100 _menhir_stack _menhir_lexbuf _menhir_lexer
      | OR ->
          let _menhir_stack = MenhirCell1_op_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_102 _menhir_stack _menhir_lexbuf _menhir_lexer
      | NEQ ->
          let _menhir_stack = MenhirCell1_op_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_104 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_op_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_106 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LT ->
          let _menhir_stack = MenhirCell1_op_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_108 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LEQ ->
          let _menhir_stack = MenhirCell1_op_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_110 _menhir_stack _menhir_lexbuf _menhir_lexer
      | GT ->
          let _menhir_stack = MenhirCell1_op_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_112 _menhir_stack _menhir_lexbuf _menhir_lexer
      | GEQ ->
          let _menhir_stack = MenhirCell1_op_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_114 _menhir_stack _menhir_lexbuf _menhir_lexer
      | EQ ->
          let _menhir_stack = MenhirCell1_op_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_116 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DIV ->
          let _menhir_stack = MenhirCell1_op_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_118 _menhir_stack _menhir_lexbuf _menhir_lexer
      | AND ->
          let _menhir_stack = MenhirCell1_op_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_120 _menhir_stack _menhir_lexbuf _menhir_lexer
      | BAR | END | RPAREN | SEMICOLON | WITH ->
          let MenhirCell1_id (_menhir_stack, _, a, _, _) = _menhir_stack in
          let MenhirCell1_id (_menhir_stack, _, f, _, _) = _menhir_stack in
          let MenhirCell1_FUN (_menhir_stack, _menhir_s, _startpos__1_) = _menhir_stack in
          let (_endpos_e_, e) = (_endpos, _v) in
          let _v = _menhir_action_42 _endpos_e_ _startpos__1_ a e f in
          _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_e_ _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_098 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_op_expr -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _menhir_stack = MenhirCell0_TIMES (_menhir_stack, _startpos, _endpos) in
      let _menhir_s = MenhirState098 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UNITLIT ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | TRUELIT ->
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | STRINGLIT _v ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | LPAREN ->
          _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LOCLIT _v ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | INTLIT _v ->
          _menhir_run_085 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | ID _v ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOATLIT _v ->
          _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FALSELIT ->
          _menhir_run_087 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | CHARLIT _v ->
          _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_075 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let (_endpos__1_, _startpos__1_) = (_endpos, _startpos) in
      let _v = _menhir_action_10 _endpos__1_ _startpos__1_ in
      _menhir_goto_atomic_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos__1_ _startpos__1_ _v _menhir_s _tok
  
  and _menhir_run_076 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let (_endpos_s_, _startpos_s_, s) = (_endpos, _startpos, _v) in
      let _v = _menhir_action_09 _endpos_s_ _startpos_s_ s in
      _menhir_goto_atomic_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_s_ _startpos_s_ _v _menhir_s _tok
  
  and _menhir_run_079 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _menhir_stack = MenhirCell1_LPAREN (_menhir_stack, _menhir_s, _startpos) in
      let _menhir_s = MenhirState079 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UNITLIT ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | TRUELIT ->
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | STRINGLIT _v ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | SEND ->
          _menhir_run_077 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | RECV ->
          _menhir_run_080 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NOT ->
          _menhir_run_078 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | MINUS ->
          _menhir_run_084 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | MATCH ->
          _menhir_run_092 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAREN ->
          _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LOCLIT _v ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | INTLIT _v ->
          _menhir_run_085 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | ID _v ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FUN ->
          _menhir_run_093 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | FLOATLIT _v ->
          _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FALSELIT ->
          _menhir_run_087 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | CHOOSE ->
          _menhir_run_125 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | CHARLIT _v ->
          _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | AMI ->
          _menhir_run_132 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | ALLOW ->
          _menhir_run_133 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_077 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _menhir_stack = MenhirCell1_SEND (_menhir_stack, _menhir_s, _startpos) in
      let _menhir_s = MenhirState077 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UNITLIT ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | TRUELIT ->
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | STRINGLIT _v ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | NOT ->
          _menhir_run_078 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | MINUS ->
          _menhir_run_084 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAREN ->
          _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LOCLIT _v ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | INTLIT _v ->
          _menhir_run_085 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | ID _v ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOATLIT _v ->
          _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FALSELIT ->
          _menhir_run_087 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | CHARLIT _v ->
          _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_078 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _menhir_stack = MenhirCell1_NOT (_menhir_stack, _menhir_s, _startpos, _endpos) in
      let _menhir_s = MenhirState078 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UNITLIT ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | TRUELIT ->
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | STRINGLIT _v ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | LPAREN ->
          _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LOCLIT _v ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | INTLIT _v ->
          _menhir_run_085 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | ID _v ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOATLIT _v ->
          _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FALSELIT ->
          _menhir_run_087 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | CHARLIT _v ->
          _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_085 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let (_endpos_n_, _startpos_n_, n) = (_endpos, _startpos, _v) in
      let _v = _menhir_action_06 _endpos_n_ _startpos_n_ n in
      _menhir_goto_atomic_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_n_ _startpos_n_ _v _menhir_s _tok
  
  and _menhir_run_086 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let (_endpos_f_, _startpos_f_, f) = (_endpos, _startpos, _v) in
      let _v = _menhir_action_07 _endpos_f_ _startpos_f_ f in
      _menhir_goto_atomic_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_f_ _startpos_f_ _v _menhir_s _tok
  
  and _menhir_run_087 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let (_endpos__1_, _startpos__1_) = (_endpos, _startpos) in
      let _v = _menhir_action_11 _endpos__1_ _startpos__1_ in
      _menhir_goto_atomic_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos__1_ _startpos__1_ _v _menhir_s _tok
  
  and _menhir_run_088 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let (_endpos_c_, _startpos_c_, c) = (_endpos, _startpos, _v) in
      let _v = _menhir_action_08 _endpos_c_ _startpos_c_ c in
      _menhir_goto_atomic_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_c_ _startpos_c_ _v _menhir_s _tok
  
  and _menhir_run_084 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _menhir_stack = MenhirCell1_MINUS (_menhir_stack, _menhir_s, _startpos, _endpos) in
      let _menhir_s = MenhirState084 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UNITLIT ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | TRUELIT ->
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | STRINGLIT _v ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | LPAREN ->
          _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LOCLIT _v ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | INTLIT _v ->
          _menhir_run_085 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | ID _v ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOATLIT _v ->
          _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FALSELIT ->
          _menhir_run_087 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | CHARLIT _v ->
          _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_080 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _menhir_stack = MenhirCell1_RECV (_menhir_stack, _menhir_s, _startpos) in
      let _menhir_s = MenhirState080 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UNITTY ->
          _menhir_run_005 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | STRINGTY ->
          _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAREN ->
          _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LOCTY ->
          _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | INTTY ->
          _menhir_run_017 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | ID _v ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOATTY ->
          _menhir_run_018 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | CHARTY ->
          _menhir_run_019 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | BOOLTY ->
          _menhir_run_020 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_017 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let (_endpos__1_, _startpos__1_) = (_endpos, _startpos) in
      let _v = _menhir_action_27 _endpos__1_ _startpos__1_ in
      _menhir_goto_atomic_typ _menhir_stack _menhir_lexbuf _menhir_lexer _endpos__1_ _startpos__1_ _v _menhir_s _tok
  
  and _menhir_run_018 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let (_endpos__1_, _startpos__1_) = (_endpos, _startpos) in
      let _v = _menhir_action_28 _endpos__1_ _startpos__1_ in
      _menhir_goto_atomic_typ _menhir_stack _menhir_lexbuf _menhir_lexer _endpos__1_ _startpos__1_ _v _menhir_s _tok
  
  and _menhir_run_019 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let (_endpos__1_, _startpos__1_) = (_endpos, _startpos) in
      let _v = _menhir_action_29 _endpos__1_ _startpos__1_ in
      _menhir_goto_atomic_typ _menhir_stack _menhir_lexbuf _menhir_lexer _endpos__1_ _startpos__1_ _v _menhir_s _tok
  
  and _menhir_run_020 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let (_endpos__1_, _startpos__1_) = (_endpos, _startpos) in
      let _v = _menhir_action_31 _endpos__1_ _startpos__1_ in
      _menhir_goto_atomic_typ _menhir_stack _menhir_lexbuf _menhir_lexer _endpos__1_ _startpos__1_ _v _menhir_s _tok
  
  and _menhir_run_092 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _menhir_stack = MenhirCell1_MATCH (_menhir_stack, _menhir_s, _startpos) in
      let _menhir_s = MenhirState092 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UNITLIT ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | TRUELIT ->
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | STRINGLIT _v ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | SEND ->
          _menhir_run_077 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | RECV ->
          _menhir_run_080 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NOT ->
          _menhir_run_078 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | MINUS ->
          _menhir_run_084 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | MATCH ->
          _menhir_run_092 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAREN ->
          _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LOCLIT _v ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | INTLIT _v ->
          _menhir_run_085 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | ID _v ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FUN ->
          _menhir_run_093 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | FLOATLIT _v ->
          _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FALSELIT ->
          _menhir_run_087 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | CHOOSE ->
          _menhir_run_125 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | CHARLIT _v ->
          _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | AMI ->
          _menhir_run_132 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | ALLOW ->
          _menhir_run_133 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_093 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _menhir_stack = MenhirCell1_FUN (_menhir_stack, _menhir_s, _startpos) in
      let _menhir_s = MenhirState093 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | ID _v ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_125 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _menhir_stack = MenhirCell1_CHOOSE (_menhir_stack, _menhir_s, _startpos) in
      let _menhir_s = MenhirState125 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | LBRACK ->
          _menhir_run_126 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_126 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _menhir_stack = MenhirCell1_LBRACK (_menhir_stack, _menhir_s, _startpos) in
      let _menhir_s = MenhirState126 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | LOCLIT _v ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_132 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _menhir_stack = MenhirCell1_AMI (_menhir_stack, _menhir_s, _startpos) in
      let _menhir_s = MenhirState132 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UNITLIT ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | TRUELIT ->
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | STRINGLIT _v ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | SEND ->
          _menhir_run_077 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | RECV ->
          _menhir_run_080 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NOT ->
          _menhir_run_078 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | MINUS ->
          _menhir_run_084 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | MATCH ->
          _menhir_run_092 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAREN ->
          _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LOCLIT _v ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | INTLIT _v ->
          _menhir_run_085 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | ID _v ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FUN ->
          _menhir_run_093 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | FLOATLIT _v ->
          _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FALSELIT ->
          _menhir_run_087 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | CHOOSE ->
          _menhir_run_125 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | CHARLIT _v ->
          _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | AMI ->
          _menhir_run_132 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | ALLOW ->
          _menhir_run_133 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_133 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _menhir_stack = MenhirCell1_ALLOW (_menhir_stack, _menhir_s, _startpos) in
      let _menhir_s = MenhirState133 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | ID _v ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_100 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_op_expr -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _menhir_stack = MenhirCell0_PLUS (_menhir_stack, _startpos, _endpos) in
      let _menhir_s = MenhirState100 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UNITLIT ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | TRUELIT ->
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | STRINGLIT _v ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | LPAREN ->
          _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LOCLIT _v ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | INTLIT _v ->
          _menhir_run_085 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | ID _v ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOATLIT _v ->
          _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FALSELIT ->
          _menhir_run_087 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | CHARLIT _v ->
          _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_102 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_op_expr -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _menhir_stack = MenhirCell0_OR (_menhir_stack, _startpos, _endpos) in
      let _menhir_s = MenhirState102 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UNITLIT ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | TRUELIT ->
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | STRINGLIT _v ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | LPAREN ->
          _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LOCLIT _v ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | INTLIT _v ->
          _menhir_run_085 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | ID _v ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOATLIT _v ->
          _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FALSELIT ->
          _menhir_run_087 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | CHARLIT _v ->
          _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_104 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_op_expr -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _menhir_stack = MenhirCell0_NEQ (_menhir_stack, _startpos, _endpos) in
      let _menhir_s = MenhirState104 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UNITLIT ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | TRUELIT ->
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | STRINGLIT _v ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | LPAREN ->
          _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LOCLIT _v ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | INTLIT _v ->
          _menhir_run_085 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | ID _v ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOATLIT _v ->
          _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FALSELIT ->
          _menhir_run_087 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | CHARLIT _v ->
          _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_106 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_op_expr -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _menhir_stack = MenhirCell0_MINUS (_menhir_stack, _startpos, _endpos) in
      let _menhir_s = MenhirState106 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UNITLIT ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | TRUELIT ->
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | STRINGLIT _v ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | LPAREN ->
          _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LOCLIT _v ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | INTLIT _v ->
          _menhir_run_085 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | ID _v ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOATLIT _v ->
          _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FALSELIT ->
          _menhir_run_087 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | CHARLIT _v ->
          _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_108 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_op_expr -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _menhir_stack = MenhirCell0_LT (_menhir_stack, _startpos, _endpos) in
      let _menhir_s = MenhirState108 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UNITLIT ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | TRUELIT ->
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | STRINGLIT _v ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | LPAREN ->
          _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LOCLIT _v ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | INTLIT _v ->
          _menhir_run_085 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | ID _v ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOATLIT _v ->
          _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FALSELIT ->
          _menhir_run_087 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | CHARLIT _v ->
          _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_110 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_op_expr -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _menhir_stack = MenhirCell0_LEQ (_menhir_stack, _startpos, _endpos) in
      let _menhir_s = MenhirState110 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UNITLIT ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | TRUELIT ->
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | STRINGLIT _v ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | LPAREN ->
          _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LOCLIT _v ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | INTLIT _v ->
          _menhir_run_085 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | ID _v ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOATLIT _v ->
          _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FALSELIT ->
          _menhir_run_087 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | CHARLIT _v ->
          _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_112 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_op_expr -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _menhir_stack = MenhirCell0_GT (_menhir_stack, _startpos, _endpos) in
      let _menhir_s = MenhirState112 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UNITLIT ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | TRUELIT ->
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | STRINGLIT _v ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | LPAREN ->
          _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LOCLIT _v ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | INTLIT _v ->
          _menhir_run_085 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | ID _v ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOATLIT _v ->
          _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FALSELIT ->
          _menhir_run_087 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | CHARLIT _v ->
          _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_114 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_op_expr -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _menhir_stack = MenhirCell0_GEQ (_menhir_stack, _startpos, _endpos) in
      let _menhir_s = MenhirState114 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UNITLIT ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | TRUELIT ->
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | STRINGLIT _v ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | LPAREN ->
          _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LOCLIT _v ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | INTLIT _v ->
          _menhir_run_085 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | ID _v ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOATLIT _v ->
          _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FALSELIT ->
          _menhir_run_087 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | CHARLIT _v ->
          _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_116 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_op_expr -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _menhir_stack = MenhirCell0_EQ (_menhir_stack, _startpos, _endpos) in
      let _menhir_s = MenhirState116 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UNITLIT ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | TRUELIT ->
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | STRINGLIT _v ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | LPAREN ->
          _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LOCLIT _v ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | INTLIT _v ->
          _menhir_run_085 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | ID _v ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOATLIT _v ->
          _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FALSELIT ->
          _menhir_run_087 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | CHARLIT _v ->
          _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_118 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_op_expr -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _menhir_stack = MenhirCell0_DIV (_menhir_stack, _startpos, _endpos) in
      let _menhir_s = MenhirState118 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UNITLIT ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | TRUELIT ->
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | STRINGLIT _v ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | LPAREN ->
          _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LOCLIT _v ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | INTLIT _v ->
          _menhir_run_085 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | ID _v ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOATLIT _v ->
          _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FALSELIT ->
          _menhir_run_087 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | CHARLIT _v ->
          _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_120 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_op_expr -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _menhir_stack = MenhirCell0_AND (_menhir_stack, _startpos, _endpos) in
      let _menhir_s = MenhirState120 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UNITLIT ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | TRUELIT ->
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | STRINGLIT _v ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | LPAREN ->
          _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LOCLIT _v ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | INTLIT _v ->
          _menhir_run_085 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | ID _v ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOATLIT _v ->
          _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FALSELIT ->
          _menhir_run_087 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | CHARLIT _v ->
          _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_goto_expr : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState138 ->
          _menhir_run_142 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState132 ->
          _menhir_run_147 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState092 ->
          _menhir_run_148 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState152 ->
          _menhir_run_153 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState079 ->
          _menhir_run_158 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState073 ->
          _menhir_run_164 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_142 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_BAR, _menhir_box_program) _menhir_cell1_lab -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_lab (_menhir_stack, _, l) = _menhir_stack in
      let MenhirCell1_BAR (_menhir_stack, _menhir_s) = _menhir_stack in
      let e = _v in
      let _v = _menhir_action_01 e l in
      match (_tok : MenhirBasics.token) with
      | BAR ->
          let _menhir_stack = MenhirCell1_allow_match (_menhir_stack, _menhir_s, _v) in
          _menhir_run_136 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState145
      | END ->
          let x = _v in
          let _v = _menhir_action_59 x in
          _menhir_goto_nonempty_list_allow_match_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_136 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_BAR (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState136 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | LBRACK ->
          _menhir_run_126 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_goto_nonempty_list_allow_match_ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState135 ->
          _menhir_run_143 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState145 ->
          _menhir_run_146 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_143 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_ALLOW, _menhir_box_program) _menhir_cell1_id -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell1_id (_menhir_stack, _, s, _, _) = _menhir_stack in
      let MenhirCell1_ALLOW (_menhir_stack, _menhir_s, _startpos__1_) = _menhir_stack in
      let (l, _endpos__5_) = (_v, _endpos) in
      let _v = _menhir_action_48 _endpos__5_ _startpos__1_ l s in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos__5_ _v _menhir_s _tok
  
  and _menhir_run_146 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_allow_match -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_allow_match (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_60 x xs in
      _menhir_goto_nonempty_list_allow_match_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_run_147 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_AMI -> _ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell1_AMI (_menhir_stack, _menhir_s, _startpos__1_) = _menhir_stack in
      let (_endpos_e_, e) = (_endpos, _v) in
      let _v = _menhir_action_47 _endpos_e_ _startpos__1_ e in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_e_ _v _menhir_s _tok
  
  and _menhir_run_148 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_MATCH as 'stack) -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v, _endpos) in
      match (_tok : MenhirBasics.token) with
      | WITH ->
          let _menhir_s = MenhirState149 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | BAR ->
              _menhir_run_150 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_150 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_BAR (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState150 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | WILDCARD ->
          _menhir_run_046 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | UNITLIT ->
          _menhir_run_047 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | TRUELIT ->
          _menhir_run_048 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | STRINGLIT _v ->
          _menhir_run_049 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | LOCLIT _v ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | LBRACK ->
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | INTLIT _v ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | ID _v ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOATLIT _v ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FALSELIT ->
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | CHARLIT _v ->
          _menhir_run_060 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_153 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_BAR, _menhir_box_program) _menhir_cell1_pattern -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_pattern (_menhir_stack, _, a) = _menhir_stack in
      let MenhirCell1_BAR (_menhir_stack, _menhir_s) = _menhir_stack in
      let e = _v in
      let _v = _menhir_action_58 a e in
      match (_tok : MenhirBasics.token) with
      | BAR ->
          let _menhir_stack = MenhirCell1_match_match (_menhir_stack, _menhir_s, _v) in
          _menhir_run_150 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState156
      | END ->
          let x = _v in
          let _v = _menhir_action_63 x in
          _menhir_goto_nonempty_list_match_match_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_goto_nonempty_list_match_match_ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState149 ->
          _menhir_run_154 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState156 ->
          _menhir_run_157 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_154 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_MATCH, _menhir_box_program) _menhir_cell1_expr -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell1_expr (_menhir_stack, _, e, _) = _menhir_stack in
      let MenhirCell1_MATCH (_menhir_stack, _menhir_s, _startpos__1_) = _menhir_stack in
      let (l, _endpos__5_) = (_v, _endpos) in
      let _v = _menhir_action_41 _endpos__5_ _startpos__1_ e l in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos__5_ _v _menhir_s _tok
  
  and _menhir_run_157 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_match_match -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_match_match (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_64 x xs in
      _menhir_goto_nonempty_list_match_match_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_run_158 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_LPAREN -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      match (_tok : MenhirBasics.token) with
      | RPAREN ->
          let _endpos_0 = _menhir_lexbuf.Lexing.lex_curr_p in
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_LPAREN (_menhir_stack, _menhir_s, _startpos__1_) = _menhir_stack in
          let (e, _endpos__3_) = (_v, _endpos_0) in
          let _v = _menhir_action_04 e in
          _menhir_goto_atomic_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos__3_ _startpos__1_ _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_164 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_id, _menhir_box_program) _menhir_cell1_list_pattern_ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      match (_tok : MenhirBasics.token) with
      | SEMICOLON ->
          let _endpos_0 = _menhir_lexbuf.Lexing.lex_curr_p in
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_list_pattern_ (_menhir_stack, _, l) = _menhir_stack in
          let MenhirCell1_id (_menhir_stack, _menhir_s, s, _startpos_s_, _) = _menhir_stack in
          let (e, _endpos__5_) = (_v, _endpos_0) in
          let _v = _menhir_action_37 _endpos__5_ _startpos_s_ e l s in
          _menhir_goto_decl _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_goto_decl : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_decl (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | TYPEDECL ->
          _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState166
      | IMPORT ->
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState166
      | ID _v_0 ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState166
      | EMULATEDLOCDECL ->
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState166
      | DATA ->
          _menhir_run_032 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState166
      | EOF ->
          let _v_1 = _menhir_action_51 () in
          _menhir_run_167 _menhir_stack _v_1
      | _ ->
          _eRR ()
  
  and _menhir_run_028 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _menhir_stack = MenhirCell1_IMPORT (_menhir_stack, _menhir_s, _startpos) in
      let _menhir_s = MenhirState028 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | ID _v ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_030 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _menhir_stack = MenhirCell1_EMULATEDLOCDECL (_menhir_stack, _menhir_s, _startpos) in
      let _menhir_s = MenhirState030 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | ID _v ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_032 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _menhir_stack = MenhirCell1_DATA (_menhir_stack, _menhir_s, _startpos) in
      let _menhir_s = MenhirState032 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | ID _v ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_139 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_op_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_098 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUS ->
          let _menhir_stack = MenhirCell1_op_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_100 _menhir_stack _menhir_lexbuf _menhir_lexer
      | OR ->
          let _menhir_stack = MenhirCell1_op_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_102 _menhir_stack _menhir_lexbuf _menhir_lexer
      | NEQ ->
          let _menhir_stack = MenhirCell1_op_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_104 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_op_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_106 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LT ->
          let _menhir_stack = MenhirCell1_op_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_108 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LEQ ->
          let _menhir_stack = MenhirCell1_op_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_110 _menhir_stack _menhir_lexbuf _menhir_lexer
      | GT ->
          let _menhir_stack = MenhirCell1_op_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_112 _menhir_stack _menhir_lexbuf _menhir_lexer
      | GEQ ->
          let _menhir_stack = MenhirCell1_op_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_114 _menhir_stack _menhir_lexbuf _menhir_lexer
      | EQ ->
          let _menhir_stack = MenhirCell1_op_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_116 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DIV ->
          let _menhir_stack = MenhirCell1_op_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_118 _menhir_stack _menhir_lexbuf _menhir_lexer
      | COLON ->
          let _menhir_stack = MenhirCell1_op_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          let _menhir_s = MenhirState140 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | UNITTY ->
              _menhir_run_005 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | STRINGTY ->
              _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LPAREN ->
              _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LOCTY ->
              _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | INTTY ->
              _menhir_run_017 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | ID _v ->
              _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FLOATTY ->
              _menhir_run_018 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | CHARTY ->
              _menhir_run_019 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | BOOLTY ->
              _menhir_run_020 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | AND ->
          let _menhir_stack = MenhirCell1_op_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_120 _menhir_stack _menhir_lexbuf _menhir_lexer
      | BAR | END | RPAREN | SEMICOLON | WITH ->
          let (_endpos_e_, e) = (_endpos, _v) in
          let _v = _menhir_action_40 e in
          _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_e_ _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_161 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_SEND as 'stack) -> _ -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_op_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
      match (_tok : MenhirBasics.token) with
      | TO ->
          let _menhir_s = MenhirState162 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | ID _v ->
              _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | TIMES ->
          _menhir_run_098 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUS ->
          _menhir_run_100 _menhir_stack _menhir_lexbuf _menhir_lexer
      | OR ->
          _menhir_run_102 _menhir_stack _menhir_lexbuf _menhir_lexer
      | NEQ ->
          _menhir_run_104 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          _menhir_run_106 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LT ->
          _menhir_run_108 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LEQ ->
          _menhir_run_110 _menhir_stack _menhir_lexbuf _menhir_lexer
      | GT ->
          _menhir_run_112 _menhir_stack _menhir_lexbuf _menhir_lexer
      | GEQ ->
          _menhir_run_114 _menhir_stack _menhir_lexbuf _menhir_lexer
      | EQ ->
          _menhir_run_116 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DIV ->
          _menhir_run_118 _menhir_stack _menhir_lexbuf _menhir_lexer
      | AND ->
          _menhir_run_120 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_099 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_op_expr _menhir_cell0_TIMES -> _ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell0_TIMES (_menhir_stack, _startpos__1_, _endpos__1_) = _menhir_stack in
      let MenhirCell1_op_expr (_menhir_stack, _menhir_s, e1, _startpos_e1_, _) = _menhir_stack in
      let (_endpos_e2_, e2) = (_endpos, _v) in
      let _v = _menhir_action_70 _endpos__1_ _endpos_e2_ _startpos__1_ _startpos_e1_ e1 e2 in
      _menhir_goto_op_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_e2_ _startpos_e1_ _v _menhir_s _tok
  
  and _menhir_run_101 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_op_expr _menhir_cell0_PLUS -> _ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell0_PLUS (_menhir_stack, _startpos__1_, _endpos__1_) = _menhir_stack in
      let MenhirCell1_op_expr (_menhir_stack, _menhir_s, e1, _startpos_e1_, _) = _menhir_stack in
      let (_endpos_e2_, e2) = (_endpos, _v) in
      let _v = _menhir_action_68 _endpos__1_ _endpos_e2_ _startpos__1_ _startpos_e1_ e1 e2 in
      _menhir_goto_op_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_e2_ _startpos_e1_ _v _menhir_s _tok
  
  and _menhir_run_103 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_op_expr _menhir_cell0_OR -> _ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell0_OR (_menhir_stack, _startpos__1_, _endpos__1_) = _menhir_stack in
      let MenhirCell1_op_expr (_menhir_stack, _menhir_s, e1, _startpos_e1_, _) = _menhir_stack in
      let (_endpos_e2_, e2) = (_endpos, _v) in
      let _v = _menhir_action_73 _endpos__1_ _endpos_e2_ _startpos__1_ _startpos_e1_ e1 e2 in
      _menhir_goto_op_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_e2_ _startpos_e1_ _v _menhir_s _tok
  
  and _menhir_run_105 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_op_expr _menhir_cell0_NEQ -> _ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell0_NEQ (_menhir_stack, _startpos__1_, _endpos__1_) = _menhir_stack in
      let MenhirCell1_op_expr (_menhir_stack, _menhir_s, e1, _startpos_e1_, _) = _menhir_stack in
      let (_endpos_e2_, e2) = (_endpos, _v) in
      let _v = _menhir_action_75 _endpos__1_ _endpos_e2_ _startpos__1_ _startpos_e1_ e1 e2 in
      _menhir_goto_op_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_e2_ _startpos_e1_ _v _menhir_s _tok
  
  and _menhir_run_107 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_op_expr _menhir_cell0_MINUS -> _ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell0_MINUS (_menhir_stack, _startpos__1_, _endpos__1_) = _menhir_stack in
      let MenhirCell1_op_expr (_menhir_stack, _menhir_s, e1, _startpos_e1_, _) = _menhir_stack in
      let (_endpos_e2_, e2) = (_endpos, _v) in
      let _v = _menhir_action_69 _endpos__1_ _endpos_e2_ _startpos__1_ _startpos_e1_ e1 e2 in
      _menhir_goto_op_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_e2_ _startpos_e1_ _v _menhir_s _tok
  
  and _menhir_run_109 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_op_expr _menhir_cell0_LT -> _ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell0_LT (_menhir_stack, _startpos__1_, _endpos__1_) = _menhir_stack in
      let MenhirCell1_op_expr (_menhir_stack, _menhir_s, e1, _startpos_e1_, _) = _menhir_stack in
      let (_endpos_e2_, e2) = (_endpos, _v) in
      let _v = _menhir_action_76 _endpos__1_ _endpos_e2_ _startpos__1_ _startpos_e1_ e1 e2 in
      _menhir_goto_op_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_e2_ _startpos_e1_ _v _menhir_s _tok
  
  and _menhir_run_111 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_op_expr _menhir_cell0_LEQ -> _ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell0_LEQ (_menhir_stack, _startpos__1_, _endpos__1_) = _menhir_stack in
      let MenhirCell1_op_expr (_menhir_stack, _menhir_s, e1, _startpos_e1_, _) = _menhir_stack in
      let (_endpos_e2_, e2) = (_endpos, _v) in
      let _v = _menhir_action_77 _endpos__1_ _endpos_e2_ _startpos__1_ _startpos_e1_ e1 e2 in
      _menhir_goto_op_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_e2_ _startpos_e1_ _v _menhir_s _tok
  
  and _menhir_run_113 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_op_expr _menhir_cell0_GT -> _ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell0_GT (_menhir_stack, _startpos__1_, _endpos__1_) = _menhir_stack in
      let MenhirCell1_op_expr (_menhir_stack, _menhir_s, e1, _startpos_e1_, _) = _menhir_stack in
      let (_endpos_e2_, e2) = (_endpos, _v) in
      let _v = _menhir_action_78 _endpos__1_ _endpos_e2_ _startpos__1_ _startpos_e1_ e1 e2 in
      _menhir_goto_op_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_e2_ _startpos_e1_ _v _menhir_s _tok
  
  and _menhir_run_115 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_op_expr _menhir_cell0_GEQ -> _ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell0_GEQ (_menhir_stack, _startpos__1_, _endpos__1_) = _menhir_stack in
      let MenhirCell1_op_expr (_menhir_stack, _menhir_s, e1, _startpos_e1_, _) = _menhir_stack in
      let (_endpos_e2_, e2) = (_endpos, _v) in
      let _v = _menhir_action_79 _endpos__1_ _endpos_e2_ _startpos__1_ _startpos_e1_ e1 e2 in
      _menhir_goto_op_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_e2_ _startpos_e1_ _v _menhir_s _tok
  
  and _menhir_run_117 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_op_expr _menhir_cell0_EQ -> _ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell0_EQ (_menhir_stack, _startpos__1_, _endpos__1_) = _menhir_stack in
      let MenhirCell1_op_expr (_menhir_stack, _menhir_s, e1, _startpos_e1_, _) = _menhir_stack in
      let (_endpos_e2_, e2) = (_endpos, _v) in
      let _v = _menhir_action_74 _endpos__1_ _endpos_e2_ _startpos__1_ _startpos_e1_ e1 e2 in
      _menhir_goto_op_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_e2_ _startpos_e1_ _v _menhir_s _tok
  
  and _menhir_run_119 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_op_expr _menhir_cell0_DIV -> _ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell0_DIV (_menhir_stack, _startpos__1_, _endpos__1_) = _menhir_stack in
      let MenhirCell1_op_expr (_menhir_stack, _menhir_s, e1, _startpos_e1_, _) = _menhir_stack in
      let (_endpos_e2_, e2) = (_endpos, _v) in
      let _v = _menhir_action_71 _endpos__1_ _endpos_e2_ _startpos__1_ _startpos_e1_ e1 e2 in
      _menhir_goto_op_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_e2_ _startpos_e1_ _v _menhir_s _tok
  
  and _menhir_run_121 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_op_expr _menhir_cell0_AND -> _ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell0_AND (_menhir_stack, _startpos__1_, _endpos__1_) = _menhir_stack in
      let MenhirCell1_op_expr (_menhir_stack, _menhir_s, e1, _startpos_e1_, _) = _menhir_stack in
      let (_endpos_e2_, e2) = (_endpos, _v) in
      let _v = _menhir_action_72 _endpos__1_ _endpos_e2_ _startpos__1_ _startpos_e1_ e1 e2 in
      _menhir_goto_op_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_e2_ _startpos_e1_ _v _menhir_s _tok
  
  and _menhir_run_122 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | UNITLIT ->
          let _menhir_stack = MenhirCell1_atomic_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState122
      | TRUELIT ->
          let _menhir_stack = MenhirCell1_atomic_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState122
      | STRINGLIT _v_0 ->
          let _menhir_stack = MenhirCell1_atomic_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState122
      | LPAREN ->
          let _menhir_stack = MenhirCell1_atomic_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState122
      | LOCLIT _v_1 ->
          let _menhir_stack = MenhirCell1_atomic_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState122
      | INTLIT _v_2 ->
          let _menhir_stack = MenhirCell1_atomic_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_085 _menhir_stack _menhir_lexbuf _menhir_lexer _v_2 MenhirState122
      | ID _v_3 ->
          let _menhir_stack = MenhirCell1_atomic_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v_3 MenhirState122
      | FLOATLIT _v_4 ->
          let _menhir_stack = MenhirCell1_atomic_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _v_4 MenhirState122
      | FALSELIT ->
          let _menhir_stack = MenhirCell1_atomic_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_087 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState122
      | CHARLIT _v_5 ->
          let _menhir_stack = MenhirCell1_atomic_expr (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer _v_5 MenhirState122
      | AND | BAR | COLON | DIV | END | EQ | GEQ | GT | LEQ | LT | MINUS | NEQ | OR | PLUS | RPAREN | SEMICOLON | TIMES | TO | WITH ->
          let (_endpos_e_, _startpos_e_, e) = (_endpos, _startpos, _v) in
          let _v = _menhir_action_02 e in
          _menhir_goto_app_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_e_ _startpos_e_ _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_goto_app_expr : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState122 ->
          _menhir_run_123 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState073 ->
          _menhir_run_124 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState077 ->
          _menhir_run_124 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState079 ->
          _menhir_run_124 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState092 ->
          _menhir_run_124 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState096 ->
          _menhir_run_124 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState132 ->
          _menhir_run_124 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState138 ->
          _menhir_run_124 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState152 ->
          _menhir_run_124 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_123 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_atomic_expr -> _ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell1_atomic_expr (_menhir_stack, _menhir_s, f, _startpos_f_, _) = _menhir_stack in
      let (_endpos_a_, a) = (_endpos, _v) in
      let _v = _menhir_action_03 _endpos_a_ _startpos_f_ a f in
      _menhir_goto_app_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_a_ _startpos_f_ _v _menhir_s _tok
  
  and _menhir_run_124 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      let (_endpos_e_, _startpos_e_, e) = (_endpos, _startpos, _v) in
      let _v = _menhir_action_67 e in
      _menhir_goto_op_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_e_ _startpos_e_ _v _menhir_s _tok
  
  and _menhir_run_160 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_NOT -> _ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell1_NOT (_menhir_stack, _menhir_s, _startpos__1_, _endpos__1_) = _menhir_stack in
      let (_endpos_e_, e) = (_endpos, _v) in
      let _v = _menhir_action_81 _endpos__1_ _endpos_e_ _startpos__1_ e in
      _menhir_goto_op_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_e_ _startpos__1_ _v _menhir_s _tok
  
  and _menhir_run_151 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_BAR as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_pattern (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | WALRUS ->
          let _menhir_s = MenhirState152 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | UNITLIT ->
              _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | TRUELIT ->
              _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | STRINGLIT _v ->
              _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | SEND ->
              _menhir_run_077 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | RECV ->
              _menhir_run_080 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | NOT ->
              _menhir_run_078 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | MINUS ->
              _menhir_run_084 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | MATCH ->
              _menhir_run_092 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LPAREN ->
              _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LOCLIT _v ->
              _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | INTLIT _v ->
              _menhir_run_085 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | ID _v ->
              _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FUN ->
              _menhir_run_093 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | FLOATLIT _v ->
              _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FALSELIT ->
              _menhir_run_087 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | CHOOSE ->
              _menhir_run_125 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | CHARLIT _v ->
              _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | AMI ->
              _menhir_run_132 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | ALLOW ->
              _menhir_run_133 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_070 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_atomic_pattern -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_atomic_pattern (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_62 x xs in
      _menhir_goto_nonempty_list_atomic_pattern_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_run_071 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let p = _v in
      let _v = _menhir_action_83 p in
      _menhir_goto_pattern _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_089 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      let (_endpos_l_, _startpos_l_, l) = (_endpos, _startpos, _v) in
      let _v = _menhir_action_12 _endpos_l_ _startpos_l_ l in
      _menhir_goto_atomic_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_l_ _startpos_l_ _v _menhir_s _tok
  
  and _menhir_run_127 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_LBRACK -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      match (_tok : MenhirBasics.token) with
      | RBRACK ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_LBRACK (_menhir_stack, _menhir_s, _) = _menhir_stack in
          let s = _v in
          let _v = _menhir_action_50 s in
          _menhir_goto_lab _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_goto_lab : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState125 ->
          _menhir_run_129 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState136 ->
          _menhir_run_137 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_129 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_CHOOSE as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_lab (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | FOR ->
          let _menhir_s = MenhirState130 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | ID _v ->
              _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_137 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_BAR as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_lab (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | DOUBLEARROW ->
          let _menhir_s = MenhirState138 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | UNITLIT ->
              _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | TRUELIT ->
              _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | STRINGLIT _v ->
              _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | SEND ->
              _menhir_run_077 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | RECV ->
              _menhir_run_080 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | NOT ->
              _menhir_run_078 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | MINUS ->
              _menhir_run_084 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | MATCH ->
              _menhir_run_092 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LPAREN ->
              _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LOCLIT _v ->
              _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | INTLIT _v ->
              _menhir_run_085 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | ID _v ->
              _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FUN ->
              _menhir_run_093 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | FLOATLIT _v ->
              _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FALSELIT ->
              _menhir_run_087 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | CHOOSE ->
              _menhir_run_125 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | CHARLIT _v ->
              _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | AMI ->
              _menhir_run_132 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | ALLOW ->
              _menhir_run_133 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_goto_typ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState007 ->
          _menhir_run_021 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState025 ->
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState004 ->
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState037 ->
          _menhir_run_038 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState058 ->
          _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState080 ->
          _menhir_run_081 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState140 ->
          _menhir_run_141 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_021 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_LPAREN -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      match (_tok : MenhirBasics.token) with
      | RPAREN ->
          let _endpos_0 = _menhir_lexbuf.Lexing.lex_curr_p in
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_LPAREN (_menhir_stack, _menhir_s, _startpos__1_) = _menhir_stack in
          let (t, _endpos__3_) = (_v, _endpos_0) in
          let _v = _menhir_action_25 t in
          _menhir_goto_atomic_typ _menhir_stack _menhir_lexbuf _menhir_lexer _endpos__3_ _startpos__1_ _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_026 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_atomic_typ -> _ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell1_atomic_typ (_menhir_stack, _menhir_s, t1, _startpos_t1_, _) = _menhir_stack in
      let (_endpos_t2_, t2) = (_endpos, _v) in
      let _v = _menhir_action_88 _endpos_t2_ _startpos_t1_ t1 t2 in
      _menhir_goto_typ _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_t2_ _v _menhir_s _tok
  
  and _menhir_run_027 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_TYPEDECL, _menhir_box_program) _menhir_cell1_id -> _ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell1_id (_menhir_stack, _, s, _, _) = _menhir_stack in
      let MenhirCell1_TYPEDECL (_menhir_stack, _menhir_s, _startpos__1_) = _menhir_stack in
      let (_endpos_t_, t) = (_endpos, _v) in
      let _v = _menhir_action_36 _endpos_t_ _startpos__1_ s t in
      _menhir_goto_decl _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_038 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_BAR, _menhir_box_program) _menhir_cell1_id -> _ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell1_id (_menhir_stack, _, s, _, _) = _menhir_stack in
      let MenhirCell1_BAR (_menhir_stack, _menhir_s) = _menhir_stack in
      let (_endpos_t_, t) = (_endpos, _v) in
      let _v = _menhir_action_89 s t in
      let _endpos = _endpos_t_ in
      match (_tok : MenhirBasics.token) with
      | BAR ->
          let _menhir_stack = MenhirCell1_var_decl (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_035 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState039
      | DATA | EMULATEDLOCDECL | EOF | ID _ | IMPORT | TYPEDECL ->
          let (_endpos_x_, x) = (_endpos, _v) in
          let _v = _menhir_action_65 x in
          _menhir_goto_nonempty_list_var_decl_ _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_x_ _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_035 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_BAR (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState035 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | ID _v ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_goto_nonempty_list_var_decl_ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState039 ->
          _menhir_run_040 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState034 ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_040 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_var_decl -> _ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell1_var_decl (_menhir_stack, _menhir_s, x, _) = _menhir_stack in
      let (_endpos_xs_, xs) = (_endpos, _v) in
      let _v = _menhir_action_66 x xs in
      _menhir_goto_nonempty_list_var_decl_ _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_xs_ _v _menhir_s _tok
  
  and _menhir_run_041 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_DATA, _menhir_box_program) _menhir_cell1_id -> _ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell1_id (_menhir_stack, _, s, _, _) = _menhir_stack in
      let MenhirCell1_DATA (_menhir_stack, _menhir_s, _startpos__1_) = _menhir_stack in
      let (_endpos_l_, l) = (_endpos, _v) in
      let _v = _menhir_action_39 _endpos_l_ _startpos__1_ l s in
      _menhir_goto_decl _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_059 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_id, _menhir_box_program) _menhir_cell1_COLON -> _ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell1_COLON (_menhir_stack, _) = _menhir_stack in
      let MenhirCell1_id (_menhir_stack, _menhir_s, s, _startpos_s_, _) = _menhir_stack in
      let (_endpos_t_, t) = (_endpos, _v) in
      let _v = _menhir_action_35 _endpos_t_ _startpos_s_ s t in
      _menhir_goto_decl _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_081 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_RECV as 'stack) -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_typ (_menhir_stack, _menhir_s, _v, _endpos) in
      match (_tok : MenhirBasics.token) with
      | FROM ->
          let _menhir_s = MenhirState082 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | ID _v ->
              _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_141 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_op_expr -> _ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell1_op_expr (_menhir_stack, _menhir_s, e, _startpos_e_, _) = _menhir_stack in
      let (_endpos_t_, t) = (_endpos, _v) in
      let _v = _menhir_action_43 _endpos_t_ _startpos_e_ e t in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_t_ _v _menhir_s _tok
  
  and _menhir_run_023 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      let (_endpos_s_, _startpos_s_, s) = (_endpos, _startpos, _v) in
      let _v = _menhir_action_33 _endpos_s_ _startpos_s_ s in
      _menhir_goto_atomic_typ _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_s_ _startpos_s_ _v _menhir_s _tok
  
  and _menhir_run_029 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_IMPORT -> _ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell1_IMPORT (_menhir_stack, _menhir_s, _startpos__1_) = _menhir_stack in
      let (_endpos_s_, s) = (_endpos, _v) in
      let _v = _menhir_action_38 _endpos_s_ _startpos__1_ s in
      _menhir_goto_decl _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_031 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_EMULATEDLOCDECL -> _ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell1_EMULATEDLOCDECL (_menhir_stack, _menhir_s, _startpos__1_) = _menhir_stack in
      let (_endpos_s_, s) = (_endpos, _v) in
      let _v = _menhir_action_34 _endpos_s_ _startpos__1_ s in
      _menhir_goto_decl _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_033 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_DATA as 'stack) -> _ -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_id (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
      match (_tok : MenhirBasics.token) with
      | WALRUS ->
          let _menhir_s = MenhirState034 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | BAR ->
              _menhir_run_035 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_036 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_BAR as 'stack) -> _ -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_id (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
      match (_tok : MenhirBasics.token) with
      | COLON ->
          let _menhir_s = MenhirState037 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | UNITTY ->
              _menhir_run_005 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | STRINGTY ->
              _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LPAREN ->
              _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LOCTY ->
              _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | INTTY ->
              _menhir_run_017 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | ID _v ->
              _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FLOATTY ->
              _menhir_run_018 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | CHARTY ->
              _menhir_run_019 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | BOOLTY ->
              _menhir_run_020 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_045 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_id (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
      match (_tok : MenhirBasics.token) with
      | WILDCARD ->
          _menhir_run_046 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState045
      | UNITLIT ->
          _menhir_run_047 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState045
      | TRUELIT ->
          _menhir_run_048 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState045
      | STRINGLIT _v_0 ->
          _menhir_run_049 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState045
      | LOCLIT _v_1 ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState045
      | LBRACK ->
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState045
      | INTLIT _v_2 ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _v_2 MenhirState045
      | ID _v_3 ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v_3 MenhirState045
      | FLOATLIT _v_4 ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v_4 MenhirState045
      | FALSELIT ->
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState045
      | COLON ->
          let _menhir_stack = MenhirCell1_COLON (_menhir_stack, MenhirState045) in
          let _menhir_s = MenhirState058 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | UNITTY ->
              _menhir_run_005 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | STRINGTY ->
              _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LPAREN ->
              _menhir_run_007 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LOCTY ->
              _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | INTTY ->
              _menhir_run_017 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | ID _v ->
              _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FLOATTY ->
              _menhir_run_018 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | CHARTY ->
              _menhir_run_019 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | BOOLTY ->
              _menhir_run_020 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | CHARLIT _v_6 ->
          _menhir_run_060 _menhir_stack _menhir_lexbuf _menhir_lexer _v_6 MenhirState045
      | WALRUS ->
          let _v_7 = _menhir_action_53 () in
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer _v_7 MenhirState045
      | _ ->
          _eRR ()
  
  and _menhir_run_052 : type  ttv_stack. (ttv_stack, _menhir_box_program) _menhir_cell1_LBRACK _menhir_cell0_LBRACK -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      match (_tok : MenhirBasics.token) with
      | RBRACK ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | RBRACK ->
              let _endpos_1 = _menhir_lexbuf.Lexing.lex_curr_p in
              let _tok = _menhir_lexer _menhir_lexbuf in
              let MenhirCell0_LBRACK (_menhir_stack, _) = _menhir_stack in
              let MenhirCell1_LBRACK (_menhir_stack, _menhir_s, _startpos__1_) = _menhir_stack in
              let (s, _endpos__5_) = (_v, _endpos_1) in
              let _v = _menhir_action_24 _endpos__5_ _startpos__1_ s in
              _menhir_goto_atomic_pattern _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_064 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | LPAREN ->
          let _menhir_stack = MenhirCell1_id (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
          let _menhir_stack = MenhirCell0_LPAREN (_menhir_stack, _startpos) in
          let _menhir_s = MenhirState065 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | WILDCARD ->
              _menhir_run_046 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | UNITLIT ->
              _menhir_run_047 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | TRUELIT ->
              _menhir_run_048 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | STRINGLIT _v ->
              _menhir_run_049 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | LOCLIT _v ->
              _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | LBRACK ->
              _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | INTLIT _v ->
              _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | ID _v ->
              _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FLOATLIT _v ->
              _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FALSELIT ->
              _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | CHARLIT _v ->
              _menhir_run_060 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | CHARLIT _ | FALSELIT | FLOATLIT _ | ID _ | INTLIT _ | LBRACK | LOCLIT _ | STRINGLIT _ | TRUELIT | UNITLIT | WALRUS | WILDCARD ->
          let (_endpos_s_, _startpos_s_, s) = (_endpos, _startpos, _v) in
          let _v = _menhir_action_15 _endpos_s_ _startpos_s_ s in
          _menhir_goto_atomic_pattern _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_068 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      let (_endpos_s_, _startpos_s_, s) = (_endpos, _startpos, _v) in
      let _v = _menhir_action_15 _endpos_s_ _startpos_s_ s in
      _menhir_goto_atomic_pattern _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_083 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_RECV, _menhir_box_program) _menhir_cell1_typ -> _ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell1_typ (_menhir_stack, _, t, _) = _menhir_stack in
      let MenhirCell1_RECV (_menhir_stack, _menhir_s, _startpos__1_) = _menhir_stack in
      let (_endpos_s_, s) = (_endpos, _v) in
      let _v = _menhir_action_45 _endpos_s_ _startpos__1_ s t in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_s_ _v _menhir_s _tok
  
  and _menhir_run_090 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      let (_endpos_s_, _startpos_s_, s) = (_endpos, _startpos, _v) in
      let _v = _menhir_action_13 _endpos_s_ _startpos_s_ s in
      _menhir_goto_atomic_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_s_ _startpos_s_ _v _menhir_s _tok
  
  and _menhir_run_094 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_FUN as 'stack) -> _ -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_id (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
      match (_tok : MenhirBasics.token) with
      | ID _v_0 ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState094
      | _ ->
          _eRR ()
  
  and _menhir_run_095 : type  ttv_stack. (((ttv_stack, _menhir_box_program) _menhir_cell1_FUN, _menhir_box_program) _menhir_cell1_id as 'stack) -> _ -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_id (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
      match (_tok : MenhirBasics.token) with
      | WALRUS ->
          let _menhir_s = MenhirState096 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | UNITLIT ->
              _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | TRUELIT ->
              _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | STRINGLIT _v ->
              _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | NOT ->
              _menhir_run_078 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | MINUS ->
              _menhir_run_084 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LPAREN ->
              _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LOCLIT _v ->
              _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | INTLIT _v ->
              _menhir_run_085 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | ID _v ->
              _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FLOATLIT _v ->
              _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FALSELIT ->
              _menhir_run_087 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | CHARLIT _v ->
              _menhir_run_088 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_131 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_CHOOSE, _menhir_box_program) _menhir_cell1_lab -> _ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell1_lab (_menhir_stack, _, l) = _menhir_stack in
      let MenhirCell1_CHOOSE (_menhir_stack, _menhir_s, _startpos__1_) = _menhir_stack in
      let (_endpos_s_, s) = (_endpos, _v) in
      let _v = _menhir_action_46 _endpos_s_ _startpos__1_ l s in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_s_ _v _menhir_s _tok
  
  and _menhir_run_134 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_ALLOW as 'stack) -> _ -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_program) _menhir_state -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_id (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
      match (_tok : MenhirBasics.token) with
      | CHOICE ->
          let _menhir_s = MenhirState135 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | BAR ->
              _menhir_run_136 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_163 : type  ttv_stack. ((ttv_stack, _menhir_box_program) _menhir_cell1_SEND, _menhir_box_program) _menhir_cell1_op_expr -> _ -> _ -> _ -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell1_op_expr (_menhir_stack, _, e, _, _) = _menhir_stack in
      let MenhirCell1_SEND (_menhir_stack, _menhir_s, _startpos__1_) = _menhir_stack in
      let (_endpos_s_, s) = (_endpos, _v) in
      let _v = _menhir_action_44 _endpos_s_ _startpos__1_ e s in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_s_ _v _menhir_s _tok
  
  let _menhir_run_000 : type  ttv_stack. ttv_stack -> _ -> _ -> _menhir_box_program =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | TYPEDECL ->
          _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState000
      | IMPORT ->
          _menhir_run_028 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState000
      | ID _v ->
          _menhir_run_002 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState000
      | EMULATEDLOCDECL ->
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState000
      | DATA ->
          _menhir_run_032 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState000
      | EOF ->
          let _v = _menhir_action_51 () in
          _menhir_run_043 _menhir_stack _v
      | _ ->
          _eRR ()
  
end

let program =
  fun _menhir_lexer _menhir_lexbuf ->
    let _menhir_stack = () in
    let MenhirBox_program v = _menhir_run_000 _menhir_stack _menhir_lexbuf _menhir_lexer in
    v
