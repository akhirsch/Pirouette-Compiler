open OUnit2
open Typing.Typ_infer


(* Pretty Print ---------------------------------------------------------------------- *)
let peq (s : string) =
  let program = Parsing.Parse.parse_with_error (Lexing.from_string s) in
  let pprint_s = Ast_utils.stringify_pprint_choreo_ast program in
  let _ = print_string ("\n" ^ pprint_s ^ "\n") in
  let program' = Parsing.Parse.parse_with_error (Lexing.from_string pprint_s) in
  let json_ast = Ast_utils.stringify_jsonify_choreo_ast program in
  let json_ast' = Ast_utils.stringify_jsonify_choreo_ast program' in
  assert_equal json_ast json_ast'
;;

let net_peq (net_s : string) = assert_equal net_s net_s (* TO DO *)

(* DOT TESTS ---------------------------------------------------------------------- *)

let break_on_whitespace string =
  let trimmed = String.trim string in
  let break_space = String.split_on_char ' ' trimmed in
  let flatten = List.fold_right (fun x xs -> x ^ xs) break_space "" in
  let break_newline = String.split_on_char '\n' flatten in
  List.fold_right (fun x xs -> x ^ xs) break_newline ""


  let deq (pir) (dot_expected) =
    let program = Parsing.Parse.parse_with_error (Lexing.from_string pir) in
    let dot_actual = Ast_utils.stringify_dot_choreo_ast Parsing.Parsed_ast.Pos_info.string_of_pos program in
    let words_actual = break_on_whitespace dot_actual in
    let words_expected = break_on_whitespace dot_expected in
    (* try *)
    assert_equal words_expected words_actual ~printer: (fun str -> str)
    (* with _ ->
      Printf.printf "failed\n"; *)
    ;;


    (* Type test *)


let m : ftv = Ok "dummy info"
let assert_true = assert_equal true

(*--------------------Local type inference testcases--------------------*)

(*Const type inference testcases*)
let correct_unit_e = Local.Unit m
let correct_binop_bool_e = Local.BinOp (Val (Int (1, m), m), Eq m, Val (Int (1, m), m), m)
let correct_binop_float_e = Local.BinOp (Val (Float (1.0, m), m), FPlus m, Val (Float (1.0, m), m), m)

let correct_binop_int_e = Local.BinOp (Val (Int (1, m), m), Plus m, Val (Int (1, m), m), m)
let correct_unop_bool_e = Local.UnOp (Not m, correct_binop_bool_e, m)
let correct_and_bool_e = Local.BinOp (correct_binop_bool_e, And m, correct_unop_bool_e, m)
let correct_unop_float_e = Local.UnOp (Neg m, correct_binop_float_e, m)

let correct_unop_int_e = Local.UnOp (Neg m, correct_binop_int_e, m)
let correct_pair_e = Local.Pair (correct_binop_float_e, Val (String ("hello", m), m), m)
let correct_fst = Local.Fst (correct_pair_e, m)
let correct_snd = Local.Snd (correct_pair_e, m)
let correct_left = Local.Left (correct_binop_float_e, m)
let correct_right = Local.Right (correct_binop_float_e, m)

(*Binding local type variables*)
let float_var = Local.BinOp (correct_binop_float_e, FPlus m, Var (VarId ("foo", m), m), m)

let int_var = Local.BinOp (correct_binop_int_e, Plus m, Var (VarId ("foo", m), m), m)
let bool_var = Local.BinOp (Var (VarId ("foo", m), m), Or m, Val (Bool (false, m), m), m)
let string_var = Local.Pair (correct_binop_float_e, Var (VarId ("foo", m), m), m)

let correct_let_int_e =
  Local.Let (VarId ("foo", m), TInt m, Val (Int (1, m), m), int_var, m)
;;

let correct_let_bool_e =
  Local.Let (VarId ("foo", m), TBool m, Val (Bool (true, m), m), bool_var, m)
;;

let correct_let_str_e =
  Local.Let (VarId ("foo", m), TString m, Val (String ("hello", m), m), string_var, m)
;;

let correct_nested_binding =
  (*foo will be bound to String 'hello' in this case*)
  Local.Let (VarId ("foo", m), TInt m, Val (Int (1, m), m), correct_let_str_e, m)
;;

(*Detect local type errors*)
let incorrect_binop_bool_e =
  Local.BinOp (correct_binop_int_e, Eq m, correct_binop_bool_e, m)
;;

let incorrect_binop_int_e =
  Local.BinOp (correct_binop_int_e, Plus m, correct_binop_bool_e, m)
;;

let incorrect_unop_bool_e = Local.UnOp (Not m, correct_binop_int_e, m)

let incorrect_and_bool_e =
  Local.BinOp (correct_binop_bool_e, And m, correct_binop_int_e, m)
;;

let incorrect_unop_int_e = Local.UnOp (Neg m, correct_binop_bool_e, m)

let incorrect_typ_anno =
  Local.Let (VarId ("foo", m), TBool m, Val (Int (1, m), m), int_var, m)
;;

let incorrect_typ_binding =
  Local.Let (VarId ("foo", m), TBool m, Val (Bool (true, m), m), int_var, m)
;;

(*local patterns*)
let int_p : ftv Local.pattern = Val (Int (1, m), m)
let def_p : ftv Local.pattern = Default m
let var_p : ftv Local.pattern = Var (VarId ("foo", m), m)
let string_p : ftv Local.pattern = Val (String ("hello", m), m)
let pair_p : ftv Local.pattern = Pair (var_p, string_p, m)
let left_int_p : ftv Local.pattern = Left (int_p, m)
let right_def_p : ftv Local.pattern = Right (def_p, m)

(*pattern match of local expr*)
let int_pattn_match =
  Local.Match
    ( Var (VarId ("foo", m), m)
    , [ left_int_p, correct_binop_int_e; right_def_p, correct_unop_int_e ]
    , m )
;;

let local_right_left_match =
  Local.Match
    ( Local.Var (Local.VarId ("x", m), m)
    , [ right_def_p, Local.Val (Local.Int (42, m), m)
      ; left_int_p, Local.Val (Local.Int (43, m), m)
      ]
    , m )
;;

let mismatched_return_match =
  Local.Match
    ( Var (VarId ("foo", m), m)
    , [ left_int_p, correct_binop_int_e; right_def_p, correct_and_bool_e ]
    , m )
;;

let mismatched_pattn_match =
  Local.Match
    ( Var (VarId ("foo", m), m)
    , [ left_int_p, correct_binop_int_e; int_p, correct_unop_int_e ]
    , m )
;;

let rec local_typ_eq t expected_t =
  match t, expected_t with
  | Local.TUnit _, Local.TUnit _
  | Local.TVar _, Local.TVar _
  | Local.TInt _, Local.TInt _
  | Local.TBool _, Local.TBool _
  | Local.TFloat _, Local.TFloat _
  | Local.TString _, Local.TString _ -> true
  | Local.TProd (t1, t2, _), Local.TProd (t1', t2', _)
  | Local.TSum (t1, t2, _), Local.TSum (t1', t2', _) ->
    local_typ_eq t1 t1' && local_typ_eq t2 t2'
  | _ -> false
;;

let local_ctx_eq ctx expected_ctx =
  try
    List.for_all2
      (fun (var_name, typ) (expected_var_name, expected_typ) ->
        var_name = expected_var_name && local_typ_eq typ expected_typ)
      ctx
      expected_ctx
  with
  | Invalid_argument _ -> false
;;

(*Substitution and context are the same type*)
let local_subst_eq = local_ctx_eq

let local_expr_typ_eq e expected_t =
  let subst, t = infer_local_expr [] e in
  (local_typ_eq t expected_t && local_subst_eq subst []) |> assert_true
;;

let local_expr_typ_failures e failure =
  assert_raises failure (fun _ -> local_expr_typ_eq e (TUnit m))
;;

let local_pattn_typ_eq p expected_ctx expected_t =
  let subst, t, ctx = infer_local_pattern [] p in
  (local_typ_eq t expected_t && local_ctx_eq ctx expected_ctx && local_subst_eq subst [])
  |> assert_true
;;

let suite =
  "Float Tests"
  >::: [ "Pretty Print"
         >::: [ ("testcase1 pretty print" >:: fun _ -> peq Floats_testcases.exf0)
              ; ("testcase2 pretty print" >:: fun _ -> peq Floats_testcases.exf1)
              ; ("testcase3 pretty print" >:: fun _ -> peq Floats_testcases.exf2)
              ; ("testcase4 pretty print" >:: fun _ -> peq Floats_testcases.exf3)
              ]
       ; "Dot"
         >::: [ ("testcase1 dot" >:: fun _ -> deq Floats_testcases.exf0 Floats_testcases.dot0)
              ; ("testcase2 dot" >:: fun _ -> deq Floats_testcases.exf1 Floats_testcases.dot1)
              ; ("testcase3 dot" >:: fun _ -> deq Floats_testcases.exf2 Floats_testcases.dot2)
              ; ("testcase4 dot" >:: fun _ -> deq Floats_testcases.exf3 Floats_testcases.dot3)
         ]
       ; "Type Checking"
         >::: [ ("testcase1 type" >:: fun _ -> peq Floats_testcases.exf0)
              ; ("testcase2 type" >:: fun _ -> peq Floats_testcases.exf1)
              ; ("testcase3 type" >:: fun _ -> peq Floats_testcases.exf2)
              ; ("testcase4 type" >:: fun _ -> peq Floats_testcases.exf3)
          ]
       ]
;;

let () = run_test_tt_main suite
