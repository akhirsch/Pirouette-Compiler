module Local = Ast_core.Local.M
module Choreo = Ast_core.Choreo.M

let spf = Printf.sprintf
let node_counter = ref 0

(** [generate_node_name] generates a node name for the dot code

    - This function reads the current node counter, increments it, and concatentates it with the node_id to create a node name.
    - Returns: A string that represents a node name in the dot code. *)
let generate_node_name () =
  let node_id = !node_counter in
  node_counter := !node_counter + 1;
  "n" ^ string_of_int node_id
;;

(*=========================== Local ===========================*)

(** [dot_bin_op op] creates the dot code for the binary operator [op]

    - [op] is a binary operator that is either Plus, Minus, Times, Div, And, Or, Eq, Neq, Lt, Leq, Gt, or Geq.
    - Each label for the binary operator is a string representation of the operator.
    - Returns: A tuple of strings where the first element is the dot code for the binary operator [op] and the
      second element is the node name of the binary operator [op]. *)
let dot_bin_op (string_of_info : 'a -> string) (op : 'a Local.bin_op) : string * string =
  let node_name = generate_node_name () in
  match op with
  | Plus info -> spf "%s [label=\"+ %s\"];\n" node_name (string_of_info info), node_name
  | Minus info -> spf "%s [label=\"- %s\"];\n" node_name (string_of_info info), node_name
  | Times info -> spf "%s [label=\"* %s\"];\n" node_name (string_of_info info), node_name
  | Div info -> spf "%s [label=\"/ %s\"];\n" node_name (string_of_info info), node_name
  | And info -> spf "%s [label=\"&& %s\"];\n" node_name (string_of_info info), node_name
  | Or info -> spf "%s [label=\"|| %s\"];\n" node_name (string_of_info info), node_name
  | Eq info -> spf "%s [label=\"= %s\"];\n" node_name (string_of_info info), node_name
  | Neq info -> spf "%s [label=\"!= %s\"];\n" node_name (string_of_info info), node_name
  | Lt info -> spf "%s [label=\"< %s\"];\n" node_name (string_of_info info), node_name
  | Leq info -> spf "%s [label=\"<= %s\"];\n" node_name (string_of_info info), node_name
  | Gt info -> spf "%s [label=\"> %s\"];\n" node_name (string_of_info info), node_name
  | Geq info -> spf "%s [label=\">= %s\"];\n" node_name (string_of_info info), node_name
;;

let dot_un_op (string_of_info : 'a -> string) (op : 'a Local.un_op) : string * string =
  let node_name = generate_node_name () in
  match op with
  | Not info -> spf "%s [label=\"! %s\"];\n" node_name (string_of_info info), node_name
  | Neg info -> spf "%s [label=\"¬ %s\"];\n" node_name (string_of_info info), node_name
;;

(** [dot_local_type typ] creates the dot code for local types [typ]

    - [typ] is a local type.
    - Variants of local types include TUnit, TInt, TString, TBool, TProd, and TSum.
    - For variants [TProd] and [TSum], it calls helper function [dot_local_type] to generate the dot code for the local type.
    - Connects the local type node to it's children.
    - Returns: A tuple of strings where the first element is the dot code for the local type [typ] and the
      second element is the node name of the local type [typ]. *)
let rec dot_local_type (string_of_info : 'a -> string) (typ : 'a Local.typ)
  : string * string
  =
  let node_name = generate_node_name () in
  match typ with
  | TUnit info -> spf "%s [label=\"() %s\"];\n" node_name (string_of_info info), node_name
  | TInt info -> spf "%s [label=\"Int %s\"];\n" node_name (string_of_info info), node_name
  | TString info ->
    spf "%s [label=\"String %s\"];\n" node_name (string_of_info info), node_name
  | TBool info ->
    spf "%s [label=\"Bool %s\"];\n" node_name (string_of_info info), node_name
  | TVar (TypId (id, _), info) ->
    spf "%s [label=\"TVar %s %s\"];\n" node_name id (string_of_info info), node_name
  | TProd (typ1, typ2, info) ->
    let c1, n1 = dot_local_type string_of_info typ1 in
    let c2, n2 = dot_local_type string_of_info typ2 in
    let prod_node = spf "%s [label=\"Product %s\"];\n" node_name (string_of_info info) in
    let edge1 = spf "%s -> %s;\n" node_name n1 in
    let edge2 = spf "%s -> %s;\n" node_name n2 in
    prod_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name
  | TSum (typ1, typ2, info) ->
    let c1, n1 = dot_local_type string_of_info typ1 in
    let c2, n2 = dot_local_type string_of_info typ2 in
    let sum_node = spf "%s [label=\"Sum %s\"];\n" node_name (string_of_info info) in
    let edge1 = spf "%s -> %s;\n" node_name n1 in
    let edge2 = spf "%s -> %s;\n" node_name n2 in
    sum_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name
  | TVariant (constructors, info) ->
    let variant_node =
      spf "%s [label=\"Variant %s\"];\n" node_name (string_of_info info)
    in
    let constructor_nodes =
      List.map
        (fun { Local.name; args; info = cons_info } ->
          let cons_node_name = generate_node_name () in
          let cons_node =
            spf
              "%s [label=\"Constructor %s %s\"];\n"
              cons_node_name
              name
              (string_of_info cons_info)
          in
          let cons_edge = spf "%s -> %s;\n" node_name cons_node_name in
          let args_code, args_edges =
            List.fold_left
              (fun (code_acc, edges_acc) arg_type ->
                let arg_code, arg_node = dot_local_type string_of_info arg_type in
                let arg_edge = spf "%s -> %s;\n" cons_node_name arg_node in
                code_acc ^ arg_code, edges_acc ^ arg_edge)
              ("", "")
              args
          in
          cons_node ^ cons_edge ^ args_code, args_edges)
        constructors
    in
    let all_cons_code =
      List.fold_left (fun acc (code, edges) -> acc ^ code ^ edges) "" constructor_nodes
    in
    variant_node ^ all_cons_code, node_name
;;

(* node name format: n + node_counter *)

(** [dot_local_pattern pat] creates the dot code for local patterns [pat]

    - [pat] is a local pattern.
    - Variants of local patterns include Default, Val, Var, Pair, Left, and Right.
    - For variants [Pair], [Left], and [Right], it calls helper function [dot_local_pattern] to generate the dot code for the local pattern.
    - Connects the local pattern node to it's children.
    - Returns: A tuple of strings where the first element is the dot code for the local pattern [pat] and the
      second element is the node name of the local pattern [pat]. *)
let rec dot_local_pattern (string_of_info : 'a -> string) (pat : 'a Local.pattern)
  : string * string
  =
  let node_name = generate_node_name () in
  match pat with
  | Default info ->
    spf "%s [label=\"Default %s\"];\n" node_name (string_of_info info), node_name
  | Val (v, _) ->
    (match v with
     | Int (i, info) ->
       ( spf "%s [label=\"%s %s\"];\n" node_name (string_of_int i) (string_of_info info)
       , node_name )
     | String (s, info) ->
       spf "%s [label=\"%s %s\"];\n" node_name s (string_of_info info), node_name
     | Bool (b, info) ->
       ( spf "%s [label=\"%s %s\"];\n" node_name (string_of_bool b) (string_of_info info)
       , node_name ))
  | Var (VarId (id, _), info) ->
    spf "%s [label=\"%s %s\"];\n" node_name id (string_of_info info), node_name
  | Pair (pat1, pat2, info) ->
    let c1, n1 = dot_local_pattern string_of_info pat1 in
    let c2, n2 = dot_local_pattern string_of_info pat2 in
    let pair_node = spf "%s [label=\"Pair %s\"];\n" node_name (string_of_info info) in
    let edge1 = spf "%s -> %s;\n" node_name n1 in
    let edge2 = spf "%s -> %s;\n" node_name n2 in
    pair_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name
  | Left (pat, info) ->
    let c, n = dot_local_pattern string_of_info pat in
    let left_node = spf "%s [label=\"Left %s\"];\n" node_name (string_of_info info) in
    let edge = spf "%s -> %s;\n" node_name n in
    left_node ^ edge ^ c, node_name
  | Right (pat, info) ->
    let c, n = dot_local_pattern string_of_info pat in
    let right_node = spf "%s [label=\"Right %s\"];\n" node_name (string_of_info info) in
    let edge = spf "%s -> %s;\n" node_name n in
    right_node ^ edge ^ c, node_name
  | PConstruct (name, patterns, info) ->
    let pconstruct_node =
      spf "%s [label=\"Constructor %s %s\"];\n" node_name name (string_of_info info)
    in
    let pat_code =
      List.map
        (fun pat ->
          let c, n = dot_local_pattern string_of_info pat in
          let edge = spf "%s -> %s;\n" node_name n in
          edge ^ c)
        patterns
    in
    pconstruct_node ^ String.concat "" pat_code, node_name
;;

(** [dot_local_expr loc_expr] creates the dot code for local expressions [loc_expr]

    - [loc_expr] is a local expression.
    - Variants of local expressions include Unit, Val, Var, BinOp, Let, Pair, Fst, Snd, Left, Right, and Match.
    - Calls helper functions [dot_bin_op], [dot_local_cases], [dot_local_case], [dot_local_pattern], and [dot_local_expr]
      to generate the dot code for the local expression.
    - Connects the local expression node to it's children.
    - Returns: A tuple of strings where the first element is the dot code for the local expression [loc_expr] and the
      second element is the node name of the local expression [loc_expr]. *)
let rec dot_local_expr (string_of_info : 'a -> string) (loc_expr : 'a Local.expr)
  : string * string
  =
  let node_name = generate_node_name () in
  match loc_expr with
  | Unit info -> spf "%s [label=\"() %s\"];\n" node_name (string_of_info info), node_name
  | Val (v, _) ->
    (match v with
     | Int (i, info) ->
       ( spf "%s [label=\"%s %s\"];\n" node_name (string_of_int i) (string_of_info info)
       , node_name )
     | String (s, info) ->
       spf "%s [label=\"%s %s\"];\n" node_name s (string_of_info info), node_name
     | Bool (b, info) ->
       ( spf "%s [label=\"%s %s\"];\n" node_name (string_of_bool b) (string_of_info info)
       , node_name ))
  | Var (VarId (id, _), info) ->
    spf "%s [label=\"%s %s\"];\n" node_name id (string_of_info info), node_name
  | UnOp (op, e, info) ->
    let c1, n1 = dot_local_expr string_of_info e in
    let un_op_node = spf "%s [label=\"UnOp %s\"];\n" node_name (string_of_info info) in
    let c2, n2 = dot_un_op string_of_info op in
    let edge1 = spf "%s -> %s;\n" node_name n1 in
    let edge2 = spf "%s -> %s;\n" node_name n2 in
    un_op_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name
  | BinOp (e1, op, e2, info) ->
    let c1, n1 = dot_local_expr string_of_info e1 in
    let c2, n2 = dot_local_expr string_of_info e2 in
    let bin_op_node = spf "%s [label=\"BinOp %s\"];\n" node_name (string_of_info info) in
    let c3, n3 = dot_bin_op string_of_info op in
    let edge1 = spf "%s -> %s;\n" node_name n1 in
    let edge2 = spf "%s -> %s;\n" node_name n2 in
    let edge3 = spf "%s -> %s;\n" node_name n3 in
    bin_op_node ^ edge1 ^ edge2 ^ edge3 ^ c1 ^ c2 ^ c3, node_name
  | Let (VarId (id, _), _, e1, e2, info) ->
    let c1, n1 = dot_local_expr string_of_info e1 in
    let c2, n2 = dot_local_expr string_of_info e2 in
    let let_node =
      spf "%s [label=\"Let: %s %s\"];\n" node_name id (string_of_info info)
    in
    let edge1 = spf "%s -> %s;\n" node_name n1 in
    let edge2 = spf "%s -> %s;\n" node_name n2 in
    let_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name
  | Pair (e1, e2, info) ->
    let c1, n1 = dot_local_expr string_of_info e1 in
    let c2, n2 = dot_local_expr string_of_info e2 in
    let pair_node = spf "%s [label=\"Pair %s\"];\n" node_name (string_of_info info) in
    let edge1 = spf "%s -> %s;\n" node_name n1 in
    let edge2 = spf "%s -> %s;\n" node_name n2 in
    pair_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name
  | Fst (e, info) ->
    let c, n = dot_local_expr string_of_info e in
    let fst_node = spf "%s [label=\"Fst %s\"];\n" node_name (string_of_info info) in
    let edge = spf "%s -> %s;\n" node_name n in
    fst_node ^ edge ^ c, node_name
  | Snd (e, info) ->
    let c, n = dot_local_expr string_of_info e in
    let snd_node = spf "%s [label=\"Snd %s\"];\n" node_name (string_of_info info) in
    let edge = spf "%s -> %s;\n" node_name n in
    snd_node ^ edge ^ c, node_name
  | Left (e, info) ->
    let c, n = dot_local_expr string_of_info e in
    let left_node = spf "%s [label=\"Left %s\"];\n" node_name (string_of_info info) in
    let edge = spf "%s -> %s;\n" node_name n in
    left_node ^ edge ^ c, node_name
  | Right (e, info) ->
    let c, n = dot_local_expr string_of_info e in
    let right_node = spf "%s [label=\"Right %s\"];\n" node_name (string_of_info info) in
    let edge = spf "%s -> %s;\n" node_name n in
    right_node ^ edge ^ c, node_name
  | Match (e, cases, info) ->
    (* [dot_local_case (pat, expr)] creates the dot code for a local case [(pat, expr)]

       - [(pat, expr)] is a tuple of a local pattern and a local expression.
       - Calls [dot_local_pattern] on the local pattern and [dot_local_expr] on the local expression.
       - Connects the [dot_local_case] node to it's children, the local pattern and local expression nodes.
       - Returns: A tuple of strings where the first element is the dot code for the local case [(pat, expr)]
         and the second element is the node name of the local case [(pat, expr)]. *)
    let[@inline] dot_local_case string_of_info (pat, expr) =
      let node_name = generate_node_name () in
      let c1, pat_name = dot_local_pattern string_of_info pat in
      let c2, expr_name = dot_local_expr string_of_info expr in
      let case_node = spf "%s [label=\"Case\"];\n" node_name in
      let edge1 = spf "%s -> %s;\n" node_name pat_name in
      let edge2 = spf "%s -> %s;\n" node_name expr_name in
      case_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name
    in
    (* [dot_local_cases cases] calls [dot_local_case] on each local case in [cases] and creates a tuple.

       - [cases] is a list of local cases.
       - Returns: Tuples of strings where the first element is the dot code for the local cases in [cases] and the second element is the
         node name of the local cases in [cases]. *)
    let[@inline] dot_local_cases cases =
      let case_nodes, case_node_names =
        List.split (List.map (dot_local_case string_of_info) cases)
      in
      let case_edges =
        List.map (fun name -> spf "%s -> %s;\n" node_name name) case_node_names
      in
      String.concat "" case_nodes, String.concat "" case_edges
    in
    let c1, n1 = dot_local_expr string_of_info e in
    let match_node = spf "%s [label=\"Match %s\"];\n" node_name (string_of_info info) in
    let c2, case_edges = dot_local_cases cases in
    let edge1 = spf "%s -> %s;\n" node_name n1 in
    match_node ^ edge1 ^ case_edges ^ c1 ^ c2, node_name
  | Construct (name, exprs, info) ->
    let construct_node =
      spf "%s [label=\"Construct %s %s\"];\n" node_name name (string_of_info info)
    in
    let exprs_code =
      List.map
        (fun expr ->
          let c, n = dot_local_expr string_of_info expr in
          let edge = spf "%s -> %s;\n" node_name n in
          edge ^ c)
        exprs
    in
    construct_node ^ String.concat "" exprs_code, node_name
;;

(*=========================== Choreo ===========================*)

(** [dot_choreo_type typ] creates the dot code for choreo types [typ]

    - [typ] is a choreo type.
    - Variants of choreo types include TUnit, TLoc, TSend, TProd, and TSum.
    - For Variant [TLoc], it calls helper function [dot_local_type] to generate the dot code for the local type.
    - For variants [TSend], [TProd], and [TSum], it calls helper function [dot_choreo_type] to generate the dot code for the choreo type.
    - Connects the choreo type node to it's children.
    - Returns: A tuple of strings where the first element is the dot code for the choreo type [typ] and the
      second element is the node name of the choreo type [typ]. *)
let rec dot_choreo_type (string_of_info : 'a -> string) (typ : 'a Choreo.typ)
  : string * string
  =
  let node_name = generate_node_name () in
  match typ with
  | TUnit info -> spf "%s [label=\"() %s\"];\n" node_name (string_of_info info), node_name
  | TLoc (LocId (id, _), typ, info) ->
    let locid_node = spf "%s [label=\"%s %s\"];\n" node_name id (string_of_info info) in
    let c, n = dot_local_type string_of_info typ in
    let edge = spf "%s -> %s;\n" node_name n in
    locid_node ^ edge ^ c, node_name
  | TVar (Typ_Id (id, _), info) ->
    spf "%s [label=\"TVar %s %s\"];\n" node_name id (string_of_info info), node_name
  | TMap (typ1, typ2, info) ->
    let c1, n1 = dot_choreo_type string_of_info typ1 in
    let c2, n2 = dot_choreo_type string_of_info typ2 in
    let send_node = spf "%s [label=\"Send %s\"];\n" node_name (string_of_info info) in
    let edge1 = spf "%s -> %s;\n" node_name n1 in
    let edge2 = spf "%s -> %s;\n" node_name n2 in
    send_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name
  | TProd (typ1, typ2, info) ->
    let c1, n1 = dot_choreo_type string_of_info typ1 in
    let c2, n2 = dot_choreo_type string_of_info typ2 in
    let prod_node = spf "%s [label=\"Product %s\"];\n" node_name (string_of_info info) in
    let edge1 = spf "%s -> %s;\n" node_name n1 in
    let edge2 = spf "%s -> %s;\n" node_name n2 in
    prod_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name
  | TSum (typ1, typ2, info) ->
    let c1, n1 = dot_choreo_type string_of_info typ1 in
    let c2, n2 = dot_choreo_type string_of_info typ2 in
    let sum_node = spf "%s [label=\"Sum %s\"];\n" node_name (string_of_info info) in
    let edge1 = spf "%s -> %s;\n" node_name n1 in
    let edge2 = spf "%s -> %s;\n" node_name n2 in
    sum_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name
  | TVariant (constructors, info) ->
    let variant_node =
      spf "%s [label=\"Variant %s\"];\n" node_name (string_of_info info)
    in
    let constructor_nodes =
      List.map
        (fun { Choreo.name; args; info = cons_info } ->
          let cons_node_name = generate_node_name () in
          let cons_node =
            spf
              "%s [label=\"Constructor %s %s\"];\n"
              cons_node_name
              name
              (string_of_info cons_info)
          in
          let cons_edge = spf "%s -> %s;\n" node_name cons_node_name in
          let args_code, args_edges =
            List.fold_left
              (fun (code_acc, edges_acc) arg_type ->
                let arg_code, arg_node = dot_choreo_type string_of_info arg_type in
                let arg_edge = spf "%s -> %s;\n" cons_node_name arg_node in
                code_acc ^ arg_code, edges_acc ^ arg_edge)
              ("", "")
              args
          in
          cons_node ^ cons_edge ^ args_code, args_edges)
        constructors
    in
    let all_cons_code =
      List.fold_left (fun acc (code, edges) -> acc ^ code ^ edges) "" constructor_nodes
    in
    variant_node ^ all_cons_code, node_name
;;

(** [dot_pattern pat] creates the dot code for patterns [pat]

    - [pat] is a pattern.
    - Variants of patterns include Default, Var, Pair, LocPat, Left, and Right.
    - For variant [LocPat], it calls helper function [dot_local_pattern] to generate the dot code for the local pattern.
    - For variants [Pair], [Left], and [Right], it calls helper function [dot_pattern] to generate the dot code for the pattern.
    - Connects the pattern node to it's children.
    - Returns: A tuple of strings where the first element is the dot code for the pattern [pat] and the
      second element is the node name of the pattern [pat]. *)
let rec dot_choreo_pattern (string_of_info : 'a -> string) (pat : 'a Choreo.pattern)
  : string * string
  =
  let node_name = generate_node_name () in
  match pat with
  | Default info ->
    spf "%s [label=\"Default %s\"];\n" node_name (string_of_info info), node_name
  | Var (VarId (id, _), info) ->
    spf "%s [label=\"%s %s\"];\n" node_name id (string_of_info info), node_name
  | Pair (pat1, pat2, info) ->
    let c1, n1 = dot_choreo_pattern string_of_info pat1 in
    let c2, n2 = dot_choreo_pattern string_of_info pat2 in
    let pair_node = spf "%s [label=\"Pair %s\"];\n" node_name (string_of_info info) in
    let edge1 = spf "%s -> %s;\n" node_name n1 in
    let edge2 = spf "%s -> %s;\n" node_name n2 in
    pair_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name
  | LocPat (LocId (loc, _), lp, info) ->
    let locid_node = spf "%s [label=\"%s %s\"];\n" node_name loc (string_of_info info) in
    let c, n = dot_local_pattern string_of_info lp in
    let edge = spf "%s -> %s;\n" node_name n in
    locid_node ^ edge ^ c, node_name
  | Left (pat, info) ->
    let c, n = dot_choreo_pattern string_of_info pat in
    let left_node = spf "%s [label=\"Left %s\"];\n" node_name (string_of_info info) in
    let edge = spf "%s -> %s;\n" node_name n in
    left_node ^ edge ^ c, node_name
  | Right (pat, info) ->
    let c, n = dot_choreo_pattern string_of_info pat in
    let right_node = spf "%s [label=\"Right %s\"];\n" node_name (string_of_info info) in
    let edge = spf "%s -> %s;\n" node_name n in
    right_node ^ edge ^ c, node_name
  | PConstruct (name, patterns, info) ->
    let pconstruct_node =
      spf "%s [label=\"Constructor %s %s\"];\n" node_name name (string_of_info info)
    in
    let pat_code =
      List.map
        (fun pat ->
          let c, n = dot_choreo_pattern string_of_info pat in
          let edge = spf "%s -> %s;\n" node_name n in
          edge ^ c)
        patterns
    in
    pconstruct_node ^ String.concat "" pat_code, node_name
;;

(** [dot_stmts stmts] creates the dot code for a list of statements [stmts]

    - [stmts] is a list of statements.
    - Calls helper function [dot_stmt] on each statement in [stmts] and concatenates the dot code for each statement.
    - Recursively calls [dot_stmts] on the rest of the list of statements [stmts].
    - Returns: A tuple of strings where the first element is the dot code for the list of statements [stmts] and the
      second element is the node name of the list of statements [stmts]. *)
let rec dot_stmts (string_of_info : 'a -> string) (stmts : 'a Choreo.stmt_block)
  : string * string
  =
  match stmts with
  | [] -> "", ""
  | stmt :: rest ->
    let stmt_dot_code, stmt_node_name = dot_stmt string_of_info stmt in
    let rest_dot_code, rest_node_name = dot_stmts string_of_info rest in
    ( (stmt_dot_code ^ if rest <> [] then "\n" ^ rest_dot_code else rest_dot_code)
    , stmt_node_name ^ " " ^ rest_node_name )

(** [dot_stmt statement] creates the dot code for statements [statement]

    - [statement] is a statement.
    - Variants of statements include Decl, Assign, TypeDecl.
    - Calls helper functions [dot_pattern], [dot_choreo_type], and [dot_local_pattern] to generate the dot code for the statement.
    - Connects the statement node to it's children.
    - Returns: A tuple of strings where the first element is the dot code for the statement [statement] and the
      second element is the node name of the statement [statement]. *)
and dot_stmt (string_of_info : 'a -> string) (stmt : 'a Choreo.stmt) : string * string =
  let node_name = generate_node_name () in
  match stmt with
  | Decl (pat, typ, info) ->
    let c1, n1 = dot_choreo_pattern string_of_info pat in
    let c2, n2 = dot_choreo_type string_of_info typ in
    let decl_node = spf "%s [label=\"Decl %s\"];\n" node_name (string_of_info info) in
    let edge1 = spf "%s -> %s;\n" node_name n1 in
    let edge2 = spf "%s -> %s;\n" node_name n2 in
    decl_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name
  | Assign (pat_list, expr, info) ->
    let rec pattern_loop string_of_info patterns =
      match patterns with
      | [] -> "", ""
      | pat :: rest ->
        let pat_c, pat_n = dot_choreo_pattern string_of_info pat in
        let edge = spf "%s -> %s;\n" node_name pat_n in
        let rest_c, rest_e = pattern_loop string_of_info rest in
        pat_c ^ rest_c, edge ^ rest_e
    in
    let pattern_code, pattern_edge = pattern_loop string_of_info pat_list in
    let c1, n1 = dot_choreo_expr string_of_info expr in
    let assign_node = spf "%s [label=\"Assign %s\"];\n" node_name (string_of_info info) in
    let edge1 = spf "%s -> %s;\n" node_name n1 in
    assign_node ^ pattern_edge ^ edge1 ^ pattern_code ^ c1, node_name
  | TypeDecl (TypId (id, _), typ, info) ->
    let var_node = spf "%s [label=\"%s %s\"];\n" node_name id (string_of_info info) in
    let c, n = dot_choreo_type string_of_info typ in
    let edge = spf "%s -> %s;\n" node_name n in
    var_node ^ edge ^ c, node_name
  | ForeignDecl (VarId (id, _), typ, s, info) ->
    let node_name = generate_node_name () in
    let decl_node =
      spf
        "%s [label=\"ForeignDecl: %s -> %s %s\"];\n"
        node_name
        id
        s
        (string_of_info info)
    in
    let c, n = dot_choreo_type string_of_info typ in
    let edge = spf "%s -> %s;\n" node_name n in
    decl_node ^ edge ^ c, node_name

(** [dot_choreo_expr chor_expr] creates the dot code for choreo expressions [chor_expr]

    - [chor_expr] is a choreo expression.
    - Variants of choreo expressions include Unit, Var, LocExpr, Send, Sync, If, Let, FunDef, FunApp, Pair, Fst, Snd, Left, Right, and Match.
    - Calls helper functions [dot_local_expr], [dot_choreo_expr], [dot_stmts], [dot_choreo_cases], [dot_choreo_case], [dot_pattern], and [dot_choreo_expr]
      to generate the dot code for the choreo expression.
    - Connects the choreo expression node to it's children.
    - Returns: A tuple of strings where the first element is the dot code for the choreo expression [chor_expr] and the
      second element is the node name of the choreo expression [chor_expr]. *)
and dot_choreo_expr (string_of_info : 'a -> string) (expr : 'a Choreo.expr)
  : string * string
  =
  let node_name = generate_node_name () in
  match expr with
  | Unit info -> spf "%s [label=\"() %s\"];\n" node_name (string_of_info info), node_name
  | Var (VarId (id, _), info) ->
    spf "%s [label=\"%s %s\"];\n" node_name id (string_of_info info), node_name
  | LocExpr (LocId (id, _), le, info) ->
    let locid_node = spf "%s [label=\"%s %s\"];\n" node_name id (string_of_info info) in
    let c, n = dot_local_expr string_of_info le in
    let edge = spf "%s -> %s;\n" node_name n in
    locid_node ^ edge ^ c, node_name
  | Send (LocId (id1, _), expr, LocId (id2, _), info) ->
    let send_node1 =
      spf "%s [label=\"Send from: %s %s\"];\n" node_name id1 (string_of_info info)
    in
    let c, n = dot_choreo_expr string_of_info expr in
    let send_node2 =
      spf "%s [label=\"Send to: %s %s\"];\n" node_name id2 (string_of_info info)
    in
    let edge = spf "%s -> %s;\n" node_name n in
    send_node1 ^ send_node2 ^ edge ^ c, node_name
  | Sync (LocId (loc_id1, _), LabelId (label, _), LocId (loc_id2, _), expr, info) ->
    let c, n = dot_choreo_expr string_of_info expr in
    let sync_node =
      spf
        "%s [label=\"Sync: %s[%s] -> %s %s\"];\n"
        node_name
        loc_id1
        label
        loc_id2
        (string_of_info info)
    in
    let edge = spf "%s -> %s;\n" node_name n in
    sync_node ^ edge ^ c, node_name
  | If (cond, then_expr, else_expr, info) ->
    let c1, n1 = dot_choreo_expr string_of_info cond in
    let c2, n2 = dot_choreo_expr string_of_info then_expr in
    let c3, n3 = dot_choreo_expr string_of_info else_expr in
    let if_node = spf "%s [label=\"If %s\"];\n" node_name (string_of_info info) in
    let edge1 = spf "%s -> %s;\n" node_name n1 in
    let edge2 = spf "%s -> %s;\n" node_name n2 in
    let edge3 = spf "%s -> %s;\n" node_name n3 in
    if_node ^ edge1 ^ edge2 ^ edge3 ^ c1 ^ c2 ^ c3, node_name
  | Let (decl_block, expr, info) ->
    let c1, n1 = dot_stmts string_of_info decl_block in
    let c2, n2 = dot_choreo_expr string_of_info expr in
    let let_node = spf "%s [label=\"Let %s\"];\n" node_name (string_of_info info) in
    let edge1 = spf "%s -> %s;\n" node_name n1 in
    let edge2 = spf "%s -> %s;\n" node_name n2 in
    let_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name
  | FunDef (pat_list, expr, info) ->
    let rec pattern_loop patterns =
      match patterns with
      | [] -> "", ""
      | pat :: rest ->
        let pat_c, pat_n = dot_choreo_pattern string_of_info pat in
        let edge = spf "%s -> %s;\n" node_name pat_n in
        let rest_c, rest_e = pattern_loop rest in
        pat_c ^ rest_c, edge ^ rest_e
    in
    let pattern_code, pattern_edge = pattern_loop pat_list in
    let c1, n1 = dot_choreo_expr string_of_info expr in
    let fundef_node = spf "%s [label=\"FunDef %s\"];\n" node_name (string_of_info info) in
    let edge1 = spf "%s -> %s;\n" node_name n1 in
    fundef_node ^ pattern_edge ^ edge1 ^ pattern_code ^ c1, node_name
  | FunApp (f, arg, info) ->
    let c1, n1 = dot_choreo_expr string_of_info f in
    let c2, n2 = dot_choreo_expr string_of_info arg in
    let funapp_node = spf "%s [label=\"FunApp %s\"];\n" node_name (string_of_info info) in
    let edge1 = spf "%s -> %s;\n" node_name n1 in
    let edge2 = spf "%s -> %s;\n" node_name n2 in
    funapp_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name
  | Pair (e1, e2, info) ->
    let c1, n1 = dot_choreo_expr string_of_info e1 in
    let c2, n2 = dot_choreo_expr string_of_info e2 in
    let pair_node = spf "%s [label=\"Pair %s\"];\n" node_name (string_of_info info) in
    let edge1 = spf "%s -> %s;\n" node_name n1 in
    let edge2 = spf "%s -> %s;\n" node_name n2 in
    pair_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name
  | Fst (e, info) ->
    let c, n = dot_choreo_expr string_of_info e in
    let fst_node = spf "%s [label=\"Fst %s\"];\n" node_name (string_of_info info) in
    let edge = spf "%s -> %s;\n" node_name n in
    fst_node ^ edge ^ c, node_name
  | Snd (e, info) ->
    let c, n = dot_choreo_expr string_of_info e in
    let snd_node = spf "%s [label=\"Snd %s\"];\n" node_name (string_of_info info) in
    let edge = spf "%s -> %s;\n" node_name n in
    snd_node ^ edge ^ c, node_name
  | Left (e, info) ->
    let c, n = dot_choreo_expr string_of_info e in
    let left_node = spf "%s [label=\"Left %s\"];\n" node_name (string_of_info info) in
    let edge = spf "%s -> %s;\n" node_name n in
    left_node ^ edge ^ c, node_name
  | Right (e, info) ->
    let c, n = dot_choreo_expr string_of_info e in
    let right_node = spf "%s [label=\"Right %s\"];\n" node_name (string_of_info info) in
    let edge = spf "%s -> %s;\n" node_name n in
    right_node ^ edge ^ c, node_name
  | Match (e, cases, info) ->
    (* [dot_choreo_case (pat, expr)] creates the dot code for a choreo case [(pat, expr)]

       - [(pat, expr)] is a tuple of a choreo pattern and a choreo expression.
       - Calls [dot_pattern] on the choreo pattern and [dot_choreo_expr] on the choreo expression.
       - Connects the [dot_choreo_case] node to it's children, the choreo pattern and choreo expression nodes.
       - Returns: A tuple of strings where the first element is the dot code for the choreo case [(pat, expr)]
         and the second element is the node name of the choreo case [(pat, expr)]. *)
    let[@inline] dot_choreo_case (pat, expr) =
      let node_name = generate_node_name () in
      let c1, pat_name = dot_choreo_pattern string_of_info pat in
      let c2, expr_name = dot_choreo_expr string_of_info expr in
      let case_node = spf "%s [label=\"Case\"];\n" node_name in
      let edge1 = spf "%s -> %s;\n" node_name pat_name in
      let edge2 = spf "%s -> %s;\n" node_name expr_name in
      case_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name
    in
    (* [dot_choreo_cases cases] calls [dot_choreo_case] on each choreo case in [cases] and creates a tuple.

       - [cases] is a list of choreo cases.
       - Returns: Tuples of strings where the first element is the dot code for the choreo cases in [cases] and the second element is the
         node name of the choreo cases in [cases]. *)
    let[@inline] dot_choreo_cases cases =
      let case_nodes, case_node_names = List.split (List.map dot_choreo_case cases) in
      let case_edges =
        List.map (fun name -> spf "%s -> %s;\n" node_name name) case_node_names
      in
      String.concat "" case_nodes, String.concat "" case_edges
    in
    let c1, n1 = dot_choreo_expr string_of_info e in
    let match_node = spf "%s [label=\"Match %s\"];\n" node_name (string_of_info info) in
    let c2, case_edges = dot_choreo_cases cases in
    let edge1 = spf "%s -> %s;\n" node_name n1 in
    match_node ^ edge1 ^ case_edges ^ c1 ^ c2, node_name
  | Construct (name, exprs, info) ->
    let construct_node =
      spf "%s [label=\"Construct %s %s\"];\n" node_name name (string_of_info info)
    in
    let exprs_code =
      List.map
        (fun expr ->
          let c, n = dot_choreo_expr string_of_info expr in
          let edge = spf "%s -> %s;\n" node_name n in
          edge ^ c)
        exprs
    in
    construct_node ^ String.concat "" exprs_code, node_name
;;

(** [generate_dot_code program] generates the dot code for a choreo program [program]

    - [program] is a choreo program.
    - Calls helper function [dot_stmts] to generate the dot code for the list of statements in the program.
    - Resets the node counter to 0 so that the next call to [generate_node_name] will start from 0.
    - Returns: A string that represents the dot code for the choreo program [program]. *)
let generate_dot_code (string_of_info : 'a -> string) (stmt_block : 'a Choreo.stmt_block) =
  let code, _ = dot_stmts string_of_info stmt_block in
  node_counter := 0;
  spf "digraph G {\n%s\n}\n" code
;;
