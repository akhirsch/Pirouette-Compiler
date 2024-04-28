open Local

let node_counter = ref 0

let generate_node_name () =
  let node_id = !node_counter in
  node_counter := !node_counter + 1;
  "n" ^ string_of_int node_id
(* node name format: n + node_counter *)


let rec dot_local_pattern (patn : local_pattern) : string * string =
  let node_name = generate_node_name () in
  match patn with
  | Default -> Printf.sprintf "%s [label=\"Default\"];\n" node_name, node_name
  | Val ((`Int _ | `String _ | `Bool _) as v) ->
      Printf.sprintf "%s [label=\"%s\"];\n" node_name (string_of_value v), node_name
  | Var (VarId id) -> Printf.sprintf "%s [label=\"%s\"];\n" node_name id, node_name
  | Pair (patn1, patn2) ->
      let (c1, n1) = dot_local_pattern patn1 in
      let (c2, n2) = dot_local_pattern patn2 in
      let pair_node = Printf.sprintf "%s [label=\"Pair\"];\n" node_name in
      let edge1 = Printf.sprintf "%s -> %s;\n" node_name n1 in
      let edge2 = Printf.sprintf "%s -> %s;\n" node_name n2 in
      (pair_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name)
  | Left patn ->
      let (c, n) = dot_local_pattern patn in
      let left_node = Printf.sprintf "%s [label=\"Left\"];\n" node_name in
      let edge = Printf.sprintf "%s -> %s;\n" node_name n in
      (left_node ^ edge ^ c, node_name)
  | Right patn ->
      let (c, n) = dot_local_pattern patn in
      let right_node = Printf.sprintf "%s [label=\"Right\"];\n" node_name in
      let edge = Printf.sprintf "%s -> %s;\n" node_name n in
      (right_node ^ edge ^ c, node_name)

and dot_local_type (typ : local_type) : string * string =
  let node_name = generate_node_name () in
  match typ with
  | TUnit -> Printf.sprintf "%s [label=\"()\"];\n" node_name, node_name
  | TInt -> Printf.sprintf "%s [label=\"Int\"];\n" node_name, node_name
  | TString -> Printf.sprintf "%s [label=\"String\"];\n" node_name, node_name
  | TBool -> Printf.sprintf "%s [label=\"Bool\"];\n" node_name, node_name
  | TProd (typ1, typ2) ->
      let (c1, n1) = dot_local_type typ1 in
      let (c2, n2) = dot_local_type typ2 in
      let prod_node = Printf.sprintf "%s [label=\"Product\"];\n" node_name in
      let edge1 = Printf.sprintf "%s -> %s;\n" node_name n1 in
      let edge2 = Printf.sprintf "%s -> %s;\n" node_name n2 in
      (prod_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name)
  | TSum (typ1, typ2) ->
      let (c1, n1) = dot_local_type typ1 in
      let (c2, n2) = dot_local_type typ2 in
      let sum_node = Printf.sprintf "%s [label=\"Sum\"];\n" node_name in
      let edge1 = Printf.sprintf "%s -> %s;\n" node_name n1 in
      let edge2 = Printf.sprintf "%s -> %s;\n" node_name n2 in
      (sum_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name)

and dot_local_expr (loc_expr : local_expr) : string * string =
  let node_name = generate_node_name () in
  match loc_expr with
  | Unit -> Printf.sprintf "%s [label=\"()\"];\n" node_name, node_name
  | Val ((`Int _ | `String _ | `Bool _) as v) ->
      Printf.sprintf "%s [label=\"%s\"];\n" node_name (string_of_value v), node_name
  | Var (VarId id) ->
      Printf.sprintf "%s [label=\"%s\"];\n" node_name id, node_name
  | BinOp (e1, op, e2) ->
      let (c1, n1) = dot_local_expr e1 in
      let (c2, n2) = dot_local_expr e2 in
      let bin_op_node = Printf.sprintf "%s [label=\"BinOp\"];\n" node_name in
      let (c3, n3) = dot_bin_op op in
      let edge1 = Printf.sprintf "%s -> %s;\n" node_name n1 in
      let edge2 = Printf.sprintf "%s -> %s;\n" node_name n2 in
      let edge3 = Printf.sprintf "%s -> %s;\n" node_name n3 in
      (bin_op_node ^ edge1 ^ edge2 ^ edge3 ^ c1 ^ c2 ^ c3, node_name)
  | Let (VarId id, e1, e2) ->
      let (c1, n1) = dot_local_expr e1 in
      let (c2, n2) = dot_local_expr e2 in
      let let_node = Printf.sprintf "%s [label=\"Let: %s\"];\n" node_name id in
      let edge1 = Printf.sprintf "%s -> %s;\n" node_name n1 in
      let edge2 = Printf.sprintf "%s -> %s;\n" node_name n2 in
      (let_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name)
  | Pair (e1, e2) ->
      let (c1, n1) = dot_local_expr e1 in
      let (c2, n2) = dot_local_expr e2 in
      let pair_node = Printf.sprintf "%s [label=\"Pair\"];\n" node_name in
      let edge1 = Printf.sprintf "%s -> %s;\n" node_name n1 in
      let edge2 = Printf.sprintf "%s -> %s;\n" node_name n2 in
      (pair_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name)
  | Fst e ->
      let (c, n) = dot_local_expr e in
      let fst_node = Printf.sprintf "%s [label=\"Fst\"];\n" node_name in
      let edge = Printf.sprintf "%s -> %s;\n" node_name n in
      (fst_node ^ edge ^ c, node_name)
  | Snd e ->
      let (c, n) = dot_local_expr e in
      let snd_node = Printf.sprintf "%s [label=\"Snd\"];\n" node_name in
      let edge = Printf.sprintf "%s -> %s;\n" node_name n in
      (snd_node ^ edge ^ c, node_name)
  | Left e ->
      let (c, n) = dot_local_expr e in
      let left_node = Printf.sprintf "%s [label=\"Left\"];\n" node_name in
      let edge = Printf.sprintf "%s -> %s;\n" node_name n in
      (left_node ^ edge ^ c, node_name)
  | Right e ->
      let (c, n) = dot_local_expr e in
      let right_node = Printf.sprintf "%s [label=\"Right\"];\n" node_name in
      let edge = Printf.sprintf "%s -> %s;\n" node_name n in
      (right_node ^ edge ^ c, node_name)
  | Match (e, cases) ->
      let (c1, n1) = dot_local_expr e in
      let match_node = Printf.sprintf "%s [label=\"Match\"];\n" node_name in
      let (c2, n2) = dot_local_cases cases in
      let edge1 = Printf.sprintf "%s -> %s;\n" node_name n1 in
      let edge2 = Printf.sprintf "%s -> %s;\n" node_name n2 in
      (match_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name)

and dot_local_cases cases =
  let case_nodes, case_node_names = List.split (List.map (dot_local_case) cases) in
  (String.concat "" case_nodes, String.concat " " case_node_names)
(* Because of type matching error / List.iter is a type unit
List.append also seems to be wrong *)

and dot_local_case (patn, expr) =
  let node_name = generate_node_name () in
  let (c1, patn_name) = dot_local_pattern patn in
  let (c2, expr_name) = dot_local_expr expr in
  let case_node = Printf.sprintf "%s [label=\"Case\"];\n" node_name in
  let edge1 = Printf.sprintf "%s -> %s;\n" node_name patn_name in
  let edge2 = Printf.sprintf "%s -> %s;\n" node_name expr_name in
  (case_node ^ edge1 ^ edge2 ^ c1 ^ c2, node_name)

and dot_bin_op (op : bin_op) : string * string =
  let node_name = generate_node_name () in
  match op with
  | Plus -> Printf.sprintf "%s [label=\"+\"];\n" node_name, node_name
  | Minus -> Printf.sprintf "%s [label=\"-\"];\n" node_name, node_name
  | Times -> Printf.sprintf "%s [label=\"*\"];\n" node_name, node_name
  | Div -> Printf.sprintf "%s [label=\"/\"];\n" node_name, node_name
  | And -> Printf.sprintf "%s [label=\"&&\"];\n" node_name, node_name
  | Or -> Printf.sprintf "%s [label=\"||\"];\n" node_name, node_name
  | Eq -> Printf.sprintf "%s [label=\"=\"];\n" node_name, node_name
  | Neq -> Printf.sprintf "%s [label=\"!=\"];\n" node_name, node_name
  | Lt -> Printf.sprintf "%s [label=\"<\"];\n" node_name, node_name
  | Leq -> Printf.sprintf "%s [label=\"<=\"];\n" node_name, node_name
  | Gt -> Printf.sprintf "%s [label=\">\"];\n" node_name, node_name
  | Geq -> Printf.sprintf "%s [label=\">=\"];\n" node_name, node_name

and string_of_value v =
  match v with
  | `Int i -> string_of_int i
  | `String s -> s
  | `Bool b -> string_of_bool b