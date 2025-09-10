val jsonify_un_op : 'a Ast_core.Local.M.un_op -> [> `String of string ]
val jsonify_bin_op : 'a Ast_core.Local.M.bin_op -> [> `String of string ]

val jsonify_local_type
  :  'a Ast_core.Local.M.typ
  -> ([> `Assoc of (string * [> `List of 'b list ]) list | `String of string ] as 'b)

val jsonify_local_pattern
  :  'a Ast_core.Local.M.pattern
  -> ([> `Assoc of (string * 'b) list
      | `Bool of bool
      | `Int of int
      | `Float of float
      | `List of 'b list
      | `String of string
      ]
      as
      'b)

val jsonify_local_expr
  :  'a Ast_core.Local.M.expr
  -> ([> `Assoc of (string * 'b) list
      | `Bool of bool
      | `Int of int
      | `Float of float
      | `List of 'b list
      | `String of string
      ]
      as
      'b)

val jsonify_choreo_type
  :  'a Ast_core.Choreo.M.typ
  -> ([> `Assoc of
           (string
           * [> `Assoc of
                  (string
                  * ([> `Assoc of (string * [> `List of 'c list ]) list
                     | `String of string
                     ]
                     as
                     'c))
                    list
             | `List of 'b list
             ])
             list
      | `String of string
      ]
      as
      'b)

val jsonify_choreo_pattern
  :  'a Ast_core.Choreo.M.pattern
  -> ([> `Assoc of (string * 'b) list
      | `Bool of bool
      | `Int of int
      | `Float of float
      | `List of 'b list
      | `String of string
      ]
      as
      'b)

val jsonify_choreo_stmt
  :  'a Ast_core.Choreo.M.stmt
  -> ([> `Assoc of (string * 'b) list
      | `Bool of bool
      | `Int of int
      | `Float of float
      | `List of 'b list
      | `String of string
      ]
      as
      'b)

val jsonify_choreo_expr
  :  'a Ast_core.Choreo.M.expr
  -> ([> `Assoc of (string * 'b) list
      | `Bool of bool
      | `Int of int
      | `Float of float
      | `List of 'b list
      | `String of string
      ]
      as
      'b)

val jsonify_choreo_stmt_block
  :  'a Ast_core.Choreo.M.stmt_block
  -> [> `List of
        ([> `Assoc of (string * 'b) list
         | `Bool of bool
         | `Int of int
         | `Float of float
         | `List of 'b list
         | `String of string
         ]
         as
         'b)
          list
     ]

val jsonify_net_type
  :  'a Ast_core.Net.M.typ
  -> ([> `Assoc of
         (string
         * ([> `Assoc of (string * [> `List of 'c list ]) list
            | `List of 'b list
            | `String of string
            ]
            as
            'c))
           list
      | `String of string
      ]
      as
      'b)

val jsonify_net_stmt
  :  'a Ast_core.Net.M.stmt
  -> ([> `Assoc of (string * 'b) list
      | `Bool of bool
      | `Int of int
      | `Float of float
      | `List of 'b list
      | `String of string
      ]
      as
      'b)

val jsonify_net_expr
  :  'a Ast_core.Net.M.expr
  -> ([> `Assoc of (string * 'b) list
      | `Bool of bool
      | `Int of int
      | `Float of float
      | `List of 'b list
      | `String of string
      ]
      as
      'b)

val jsonify_net_stmt_block
  :  'a Ast_core.Net.M.stmt_block
  -> [> `List of
        ([> `Assoc of (string * 'b) list
         | `Bool of bool
         | `Int of int
         | `Float of float
         | `List of 'b list
         | `String of string
         ]
         as
         'b)
          list
     ]

val jsonify_net_type : 'a Ast_core.Net.M.typ -> Yojson.Safe.t
val jsonify_net_stmt : 'a Ast_core.Net.M.stmt -> Yojson.Safe.t
val jsonify_net_expr : 'a Ast_core.Net.M.expr -> Yojson.Safe.t
val jsonify_net_stmt_block : 'a Ast_core.Net.M.stmt_block -> Yojson.Safe.t

