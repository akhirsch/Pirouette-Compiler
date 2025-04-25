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

(* let net_peq (net_s : string) = assert_equal net_s net_s TO DO *)

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


    (* -------------------------------------Type test -------------------------------------------- *)


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

let correct_let_float_e =
  Local.Let (VarId ("foo", m), TFloat m, Val (Float (1.0, m), m), float_var, m)
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

let incorrect_binop_float_e =
  Local.BinOp (correct_binop_float_e, FPlus m, correct_binop_int_e, m)
;;

let incorrect_unop_bool_e = Local.UnOp (Not m, correct_binop_int_e, m)

let incorrect_and_bool_e =
  Local.BinOp (correct_binop_bool_e, And m, correct_binop_int_e, m)
;;

let incorrect_unop_int_e = Local.UnOp (Neg m, correct_binop_bool_e, m)

let incorrect_unop_float_e = Local.UnOp (Neg m, correct_binop_bool_e, m)

let incorrect_typ_anno =
  Local.Let (VarId ("foo", m), TBool m, Val (Int (1, m), m), int_var, m)
;;

let incorrect_typ_binding =
  Local.Let (VarId ("foo", m), TBool m, Val (Bool (true, m), m), int_var, m)
;;

(*local patterns*)
let int_p : ftv Local.pattern = Val (Int (1, m), m)
let float_p : ftv Local.pattern = Val (Float (1.0, m), m)
let def_p : ftv Local.pattern = Default m
let var_p : ftv Local.pattern = Var (VarId ("foo", m), m)
let string_p : ftv Local.pattern = Val (String ("hello", m), m)
let pair_p : ftv Local.pattern = Pair (var_p, string_p, m)
let left_int_p : ftv Local.pattern = Left (int_p, m)
let left_float_p : ftv Local.pattern = Left (float_p, m)
let right_def_p : ftv Local.pattern = Right (def_p, m)

(*pattern match of local expr*)
let int_pattn_match =
  Local.Match
    ( Var (VarId ("foo", m), m)
    , [ left_int_p, correct_binop_int_e; right_def_p, correct_unop_int_e ]
    , m )
;;

let float_pattn_match =
  Local.Match
    ( Var (VarId ("foo", m), m)
    , [ left_float_p, correct_binop_float_e; right_def_p, correct_unop_float_e ]
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

let const_suite =
  "Const type inference tests"
  >::: [ ("Correct infer local unit"
          >:: fun _ -> TUnit m |> local_expr_typ_eq correct_unit_e)
       ; ("Correct infer local bool"
          >:: fun _ -> TBool m |> local_expr_typ_eq correct_binop_bool_e)
       ; ("Correct infer local int"
          >:: fun _ -> TInt m |> local_expr_typ_eq correct_binop_int_e)
       ; ("Correct infer local flaot"
      >:: fun _ -> TFloat m |> local_expr_typ_eq correct_binop_float_e)
       ; ("Correct infer local not bool"
          >:: fun _ -> TBool m |> local_expr_typ_eq correct_unop_bool_e)
       ; ("Correct infer local and bool"
          >:: fun _ -> TBool m |> local_expr_typ_eq correct_and_bool_e)
       ; ("Correct infer local neg int"
          >:: fun _ -> TInt m |> local_expr_typ_eq correct_unop_int_e)
       ; ("Correct infer local neg float"
      >:: fun _ -> TFloat m |> local_expr_typ_eq correct_unop_float_e)
       ; ("Correct infer local pair"
          >:: fun _ -> TProd (TInt m, TString m, m) |> local_expr_typ_eq correct_pair_e)
       ; ("Correct infer local fst pair"
          >:: fun _ -> TInt m |> local_expr_typ_eq correct_fst)
       ; ("Correct infer local snd pair"
          >:: fun _ -> TString m |> local_expr_typ_eq correct_snd)
       ; ("Correct infer local left sum"
          >:: fun _ ->
          TSum (TInt m, TVar (TypId ("T0", m), m), m) |> local_expr_typ_eq correct_left)
       ; ("Correct infer local right sum"
          >:: fun _ ->
          TSum (TVar (TypId ("T0", m), m), TInt m, m) |> local_expr_typ_eq correct_right)
       ]
;;

let local_binding_suite =
  "Local binding type inference tests"
  >::: [ ("Correct infer local int binding"
          >:: fun _ -> TInt m |> local_expr_typ_eq correct_let_int_e)
        ;("Correct infer local float binding"
        >:: fun _ -> TFloat m |> local_expr_typ_eq correct_let_float_e)
       ; ("Correct infer local bool binding"
          >:: fun _ -> TBool m |> local_expr_typ_eq correct_let_bool_e)
       ; ("Correct infer local string binding"
          >:: fun _ -> TProd (TInt m, TString m, m) |> local_expr_typ_eq correct_let_str_e
         )
       ; ("Correct nested binding"
          >:: fun _ ->
          TProd (TInt m, TString m, m) |> local_expr_typ_eq correct_nested_binding)
       ]
;;

let correct_pattn_suite =
  "Local pattern type inference tests"
  >::: [ ("Correct infer local int pattern"
          >:: fun _ -> TInt m |> local_pattn_typ_eq int_p [])
       ; ("Correct infer local float pattern"
          >:: fun _ -> TFloat m |> local_pattn_typ_eq float_p [])
       ; ("Correct infer local default pattern"
          >:: fun _ -> TUnit m |> local_pattn_typ_eq def_p [])
       ; ("Correct infer local string pattern"
          >:: fun _ -> TString m |> local_pattn_typ_eq string_p [])
       ; ("Correct infer local pair pattern"
          >:: fun _ ->
          TProd (TVar (TypId ("T0", m), m), TString m, m)
          |> local_pattn_typ_eq pair_p [ "foo", TVar (TypId ("T0", m), m) ])
       ; ("Correct infer local left pattern"
          >:: fun _ ->
          TSum (TInt m, TVar (TypId ("T0", m), m), m) |> local_pattn_typ_eq left_int_p []
         )
       ; ("Correct infer local right pattern"
          >:: fun _ ->
          TSum (TVar (TypId ("T0", m), m), TUnit m, m)
          |> local_pattn_typ_eq right_def_p [])
       ; ("Correct int pattern match" >:: fun _ -> TInt m |> local_expr_typ_eq int_pattn_match)
       ; ("Correct float pattern match" >:: fun _ -> TFloat m |> local_expr_typ_eq float_pattn_match)
       ; ("Correct local match with right-left order"
          >:: fun _ -> TInt m |> local_expr_typ_eq local_right_left_match)
       ]
;;

let incorrect_local_type_suite =
  "Detect local type errors"
  >::: [ ("type error in local binop bool"
          >:: fun _ ->
          Failure "Unification failed" |> local_expr_typ_failures incorrect_binop_bool_e)
       ; ("type error in local binop int"
          >:: fun _ ->
          Failure "Unification failed" |> local_expr_typ_failures incorrect_binop_int_e)
       ; ("type error in local binop float"
          >:: fun _ ->
          Failure "Unification failed" |> local_expr_typ_failures incorrect_binop_float_e)
       ; ("type error in local unop bool"
          >:: fun _ ->
          Failure "Unification failed" |> local_expr_typ_failures incorrect_unop_bool_e)
       ; ("type error in local binop bool 2"
          >:: fun _ ->
          Failure "Unification failed" |> local_expr_typ_failures incorrect_and_bool_e)
       ; ("type error in local unop int"
          >:: fun _ ->
          Failure "Unification failed" |> local_expr_typ_failures incorrect_unop_int_e)
       ; ("type error in local unop float"
          >:: fun _ ->
          Failure "Unification failed" |> local_expr_typ_failures incorrect_unop_float_e)
       ; ("Incorrect type binding"
          >:: fun _ ->
          Failure "Unification failed" |> local_expr_typ_failures incorrect_typ_binding)
       ; ("Incorrect type annotation"
          >:: fun _ ->
          Failure "Type annotation and actual type mismatch"
          |> local_expr_typ_failures incorrect_typ_anno)
       ; ("Unbound variable in local expression"
          >:: fun _ ->
          Failure "Variable not found when inferring expression"
          |> local_expr_typ_failures int_var)
       ; ("Incorrect pattern match - return type mismatch"
          >:: fun _ ->
          Failure "Unification failed" |> local_expr_typ_failures mismatched_return_match
         )
       ; ("Incorrect pattern match - pattern type mismatch"
          >:: fun _ ->
          Failure "Type of patterns are not sum types"
          |> local_expr_typ_failures mismatched_pattn_match)
       ; ("Incorrect fst on non-product type"
          >:: fun _ ->
          let bad_fst = Local.Fst (Local.Val (Local.Int (1, m), m), m) in
          Failure "Fst Type error" |> local_expr_typ_failures bad_fst)
       ; ("Incorrect snd on non-product type"
          >:: fun _ ->
          let bad_snd = Local.Snd (Local.Val (Local.Bool (true, m), m), m) in
          Failure "Snd Type error" |> local_expr_typ_failures bad_snd)
       ]
;;
let rec chreo_typ_eq t expected_t =
  match t, expected_t with
  | Choreo.TUnit _, Choreo.TUnit _ | Choreo.TVar _, Choreo.TVar _ -> true
  | Choreo.TLoc (Local.LocId (l1, _), t1, _), Choreo.TLoc (Local.LocId (l2, _), t2, _) ->
    l1 = l2 && local_typ_eq t1 t2
  | Choreo.TMap (t1, t2, _), Choreo.TMap (t1', t2', _)
  | Choreo.TProd (t1, t2, _), Choreo.TProd (t1', t2', _)
  | Choreo.TSum (t1, t2, _), Choreo.TSum (t1', t2', _) ->
    chreo_typ_eq t1 t1' && chreo_typ_eq t2 t2'
  | _ -> false
;;

let choreo_ctx_eq ctx expected_ctx =
  try
    List.for_all2
      (fun (var_name, typ) (expected_var_name, expected_typ) ->
        var_name = expected_var_name && chreo_typ_eq typ expected_typ)
      ctx
      expected_ctx
  with
  | Invalid_argument _ -> false
;;

let choreo_subst_eq = choreo_ctx_eq

let choreo_expr_typ_eq e expected_t =
  let subst, t = infer_choreo_expr [] [] e in
  (chreo_typ_eq t expected_t && choreo_subst_eq subst []) |> assert_true
;;

let choreo_expr_typ_failures e failure =
  assert_raises failure (fun _ -> choreo_expr_typ_eq e (Choreo.TUnit m))
;;

let choreo_pattern_typ_eq p expected_ctx expected_t =
  let subst, t, ctx = infer_choreo_pattern [] [] p in
  (chreo_typ_eq t expected_t && choreo_ctx_eq ctx expected_ctx && choreo_subst_eq subst [])
  |> assert_true
;;

let unify_local_success t1 t2 expected_subst =
  let result = unify_local t1 t2 in
  assert_equal expected_subst result
;;

let unify_local_failure t1 t2 expected_msg =
  try
    let _ = unify_local t1 t2 in
    assert_failure "Expected failure but got success"
  with
  | Failure msg -> assert_equal expected_msg msg
;;

let unify_choreo_success t1 t2 expected_subst =
  let result = unify_choreo t1 t2 in
  assert_equal expected_subst result
;;

let unify_choreo_failure t1 t2 expected_msg =
  try
    let _ = unify_choreo t1 t2 in
    assert_failure "Expected failure but got success"
  with
  | Failure msg -> assert_equal expected_msg msg
;;

(*--------------------Choreo const type inference testcases--------------------*)
let correct_choreo_unit_e = Choreo.Unit m

let correct_choreo_loc_expr =
  Choreo.LocExpr (Local.LocId ("Alice", m), Local.Val (Local.Int (1, m), m), m)
;;

let correct_choreo_send =
  Choreo.Send
    (Local.LocId ("Alice", m), correct_choreo_loc_expr, Local.LocId ("Bob", m), m)
;;

let correct_choreo_if =
  Choreo.If
    ( Choreo.LocExpr (Local.LocId ("Alice", m), Local.Val (Local.Bool (true, m), m), m)
    , Choreo.LocExpr (Local.LocId ("Alice", m), Local.Val (Local.Int (1, m), m), m)
    , Choreo.LocExpr (Local.LocId ("Alice", m), Local.Val (Local.Int (2, m), m), m)
    , m )
;;

let correct_choreo_fundef =
  Choreo.FunDef ([ Choreo.Var (Local.VarId ("foo", m), m) ], correct_choreo_loc_expr, m)
;;

let correct_choreo_funapp =
  Choreo.FunApp
    ( Choreo.FunDef
        ( [ Choreo.Var (Local.VarId ("x", m), m) ]
        , Choreo.LocExpr (Local.LocId ("Alice", m), Local.Val (Local.Int (1, m), m), m)
        , m )
    , Choreo.LocExpr (Local.LocId ("Alice", m), Local.Val (Local.Int (0, m), m), m)
    , m )
;;

let unit_funapp =
  Choreo.FunApp
    ( Choreo.FunDef ([ Choreo.Var (Local.VarId ("x", m), m) ], Choreo.Unit m, m)
    , Choreo.LocExpr (Local.LocId ("Alice", m), Local.Val (Local.Int (0, m), m), m)
    , m )
;;

let correct_choreo_pair = Choreo.Pair (correct_choreo_loc_expr, correct_choreo_send, m)
let correct_fst = Choreo.Fst (correct_choreo_pair, m)
let correct_snd = Choreo.Snd (correct_choreo_pair, m)

let correct_left =
  Choreo.Left
    (Choreo.LocExpr (Local.LocId ("Alice", m), Local.Val (Local.Int (5, m), m), m), m)
;;

let correct_right =
  Choreo.Right
    (Choreo.LocExpr (Local.LocId ("Alice", m), Local.Val (Local.Int (5, m), m), m), m)
;;

(*--------------------Binding choreo type variables--------------------*)
let correct_choreo_let_int_e =
  Choreo.Let
    ( [ Choreo.Decl
          ( Choreo.Var (Local.VarId ("x", m), m)
          , Choreo.TLoc (Local.LocId ("Alice", m), Local.TInt m, m)
          , m )
      ]
    , Choreo.LocExpr (Local.LocId ("Alice", m), Local.Val (Local.Int (5, m), m), m)
    , m )
;;

let correct_choreo_let_float_e =
  Choreo.Let
    ( [ Choreo.Decl
          ( Choreo.Var (Local.VarId ("x", m), m)
          , Choreo.TLoc (Local.LocId ("Alice", m), Local.TFloat m, m)
          , m )
      ]
    , Choreo.LocExpr (Local.LocId ("Alice", m), Local.Val (Local.Float (5.0, m), m), m)
    , m )
;;

let correct_choreo_let_bool_e =
  Choreo.Let
    ( [ Choreo.Decl
          ( Choreo.Var (Local.VarId ("y", m), m)
          , Choreo.TLoc (Local.LocId ("Bob", m), Local.TBool m, m)
          , m )
      ]
    , Choreo.LocExpr (Local.LocId ("Bob", m), Local.Val (Local.Bool (true, m), m), m)
    , m )
;;

let correct_choreo_let_str_e =
  Choreo.Let
    ( [ Choreo.Decl
          ( Choreo.Var (Local.VarId ("z", m), m)
          , Choreo.TLoc (Local.LocId ("Charlie", m), Local.TString m, m)
          , m )
      ]
    , Choreo.Pair
        ( Choreo.LocExpr (Local.LocId ("Charlie", m), Local.Val (Local.Int (1, m), m), m)
        , Choreo.LocExpr
            (Local.LocId ("Charlie", m), Local.Val (Local.String ("hello", m), m), m)
        , m )
    , m )
;;

let correct_choreo_nested_binding =
  Choreo.Let
    ( [ Choreo.Decl
          ( Choreo.Var (Local.VarId ("x", m), m)
          , Choreo.TLoc (Local.LocId ("Bob", m), Local.TInt m, m)
          , m )
      ]
    , Choreo.Let
        ( [ Choreo.Decl
              ( Choreo.Var (Local.VarId ("y", m), m)
              , Choreo.TLoc (Local.LocId ("Bob", m), Local.TBool m, m)
              , m )
          ]
        , Choreo.LocExpr (Local.LocId ("Bob", m), Local.Val (Local.Bool (true, m), m), m)
        , m )
    , m )
;;

(* Choreo *)

let incorrect_choreo_if_condition =
  Choreo.If
    ( Choreo.LocExpr (Local.LocId ("Alice", m), Local.Val (Local.Int (1, m), m), m)
      (*condition is int instead of bool*)
    , correct_choreo_loc_expr
    , correct_choreo_send
    , m )
;;

let incorrect_choreo_send =
  Choreo.Send
    ( Local.LocId ("Bob", m)
    , (*different/wrong source*)
      correct_choreo_loc_expr
    , Local.LocId ("Charlie", m)
    , m )
;;

(*the first expr should be a function*)
let incorrect_choreo_funapp =
  Choreo.FunApp (correct_choreo_loc_expr, correct_choreo_loc_expr, m)
;;

let incorrect_choreo_let_type =
  Choreo.Let
    ( [ Choreo.Decl
          ( Choreo.Var (Local.VarId ("x", m), m)
          , Choreo.TLoc (Local.LocId ("Alice", m), Local.TInt m, m)
          , m )
      ]
    , Choreo.LocExpr
        ( Local.LocId ("Alice", m)
        , Local.Val (Local.Bool (true, m), m) (* Bool where Int expected *)
        , m )
    , m )
;;

let incorrect_choreo_let_binding =
  Choreo.Let
    ( [ Choreo.Decl
          ( Choreo.Var (Local.VarId ("x", m), m)
          , Choreo.TLoc (Local.LocId ("Alice", m), Local.TBool m, m)
          , m )
      ]
    , Choreo.Var (Local.VarId ("y", m), m)
    , (*unbound variable*)
      m )
;;

let incorrect_choreo_location =
  Choreo.Let
    ( [ Choreo.Decl
          ( Choreo.Var (Local.VarId ("x", m), m)
          , Choreo.TLoc (Local.LocId ("Alice", m), Local.TInt m, m)
          , m )
      ]
    , Choreo.Send
        ( Local.LocId ("Bob", m)
        , Choreo.Var (Local.VarId ("x", m), m)
        , (*using Alice's var at Bob*)
          Local.LocId ("Charlie", m)
        , m )
    , m )
;;

(*--------------------Choreo patterns--------------------*)
let choreo_def_p : ftv Choreo.pattern = Choreo.Default m
let choreo_var_p : ftv Choreo.pattern = Choreo.Var (Local.VarId ("foo", m), m)

let choreo_loc_int_p : ftv Choreo.pattern =
  Choreo.LocPat (Local.LocId ("Alice", m), Local.Val (Local.Int (1, m), m), m)
;;

let choreo_loc_float_p : ftv Choreo.pattern =
  Choreo.LocPat (Local.LocId ("Alice", m), Local.Val (Local.Float (1.0, m), m), m)
;;

let choreo_pair_p : ftv Choreo.pattern = Choreo.Pair (choreo_var_p, choreo_loc_int_p, m)
let choreo_left_loc_p : ftv Choreo.pattern = Choreo.Left (choreo_loc_int_p, m)
let choreo_right_def_p : ftv Choreo.pattern = Choreo.Right (choreo_def_p, m)
let choreo_left_def_p : ftv Choreo.pattern = Choreo.Left (choreo_def_p, m)
let choreo_right_loc_p : ftv Choreo.pattern = Choreo.Right (choreo_loc_int_p, m)

let choreo_correct_pattn_match =
  Choreo.Match
    ( Choreo.Var (Local.VarId ("foo", m), m)
    , [ choreo_left_loc_p, correct_choreo_loc_expr
      ; choreo_right_def_p, correct_choreo_loc_expr
      ]
    , m )
;;

let choreo_right_left_match =
  Choreo.Match
    ( Choreo.Var (Local.VarId ("x", m), m)
    , [ choreo_right_loc_p, correct_choreo_loc_expr
      ; choreo_left_loc_p, correct_choreo_loc_expr
      ]
    , m )
;;

let choreo_mismatched_return_match =
  Choreo.Match
    ( Choreo.Var (Local.VarId ("foo", m), m)
    , [ choreo_left_loc_p, correct_choreo_loc_expr; choreo_right_def_p, Choreo.Unit m ]
    , m )
;;

let choreo_mismatched_pattn_match =
  Choreo.Match
    ( Choreo.Var (Local.VarId ("foo", m), m)
    , [ choreo_left_loc_p, correct_choreo_loc_expr
      ; choreo_loc_int_p, correct_choreo_send
      ]
    , m )
;;

let choreo_const_suite =
  "Choreo const type inference tests"
  >::: [ ("Correct infer choreo unit"
          >:: fun _ -> Choreo.TUnit m |> choreo_expr_typ_eq correct_choreo_unit_e)
       ; ("Correct infer location expression"
          >:: fun _ ->
          Choreo.TLoc (Local.LocId ("Alice", m), Local.TInt m, m)
          |> choreo_expr_typ_eq correct_choreo_loc_expr)
       ; ("Correct infer send"
          >:: fun _ ->
          Choreo.TLoc (Local.LocId ("Bob", m), Local.TInt m, m)
          |> choreo_expr_typ_eq correct_choreo_send)
       ; ("Correct infer if"
          >:: fun _ ->
          Choreo.TLoc (Local.LocId ("Alice", m), Local.TInt m, m)
          |> choreo_expr_typ_eq correct_choreo_if)
       ; ("Correct infer function definition"
          >:: fun _ ->
          Choreo.TMap
            ( Choreo.TVar (Choreo.Typ_Id ("T0", m), m)
            , Choreo.TLoc (Local.LocId ("Alice", m), Local.TInt m, m)
            , m )
          |> choreo_expr_typ_eq correct_choreo_fundef)
       ; ("Correct infer function application"
          >:: fun _ ->
          Choreo.TLoc (Local.LocId ("Alice", m), Local.TInt m, m)
          |> choreo_expr_typ_eq correct_choreo_funapp)
       ; ("Correct infer pair"
          >:: fun _ ->
          Choreo.TProd
            ( Choreo.TLoc (Local.LocId ("Alice", m), Local.TInt m, m)
            , Choreo.TLoc (Local.LocId ("Bob", m), Local.TInt m, m)
            , m )
          |> choreo_expr_typ_eq correct_choreo_pair)
       ; ("Correct infer fst"
          >:: fun _ ->
          Choreo.TLoc (Local.LocId ("Alice", m), Local.TInt m, m)
          |> choreo_expr_typ_eq correct_fst)
       ; ("Correct infer snd"
          >:: fun _ ->
          Choreo.TLoc (Local.LocId ("Bob", m), Local.TInt m, m)
          |> choreo_expr_typ_eq correct_snd)
       ; ("Correct infer left"
          >:: fun _ ->
          Choreo.TSum
            ( Choreo.TLoc (Local.LocId ("Alice", m), Local.TInt m, m)
            , Choreo.TVar (Choreo.Typ_Id ("T0", m), m)
            , m )
          |> choreo_expr_typ_eq correct_left)
       ; ("Correct infer right"
          >:: fun _ ->
          Choreo.TSum
            ( Choreo.TVar (Choreo.Typ_Id ("T0", m), m)
            , Choreo.TLoc (Local.LocId ("Alice", m), Local.TInt m, m)
            , m )
          |> choreo_expr_typ_eq correct_right)
       ; ("Correct infer sync"
          >:: fun _ ->
          let sync_expr =
            Choreo.Sync
              ( Local.LocId ("Alice", m)
              , Local.LabelId ("Bob", m)
              , Local.LocId ("Charlie", m)
              , Choreo.LocExpr
                  (Local.LocId ("Alice", m), Local.Val (Local.Int (1, m), m), m)
              , m )
          in
          Choreo.TLoc (Local.LocId ("Alice", m), Local.TInt m, m)
          |> choreo_expr_typ_eq sync_expr)
       ; ("Correct funapp with non-TLoc type"
          >:: fun _ -> Choreo.TUnit m |> choreo_expr_typ_eq unit_funapp)
       ]
;;

let choreo_binding_suite =
  "Choreo binding type inference tests"
  >::: [ ("Correct infer let with int"
          >:: fun _ ->
          Choreo.TLoc (Local.LocId ("Alice", m), Local.TInt m, m)
          |> choreo_expr_typ_eq correct_choreo_let_int_e)
       ; ("Correct infer let with float"
          >:: fun _ ->
          Choreo.TLoc (Local.LocId ("Alice", m), Local.TFloat m, m)
          |> choreo_expr_typ_eq correct_choreo_let_float_e)
       ; ("Correct infer let with bool"
          >:: fun _ ->
          Choreo.TLoc (Local.LocId ("Bob", m), Local.TBool m, m)
          |> choreo_expr_typ_eq correct_choreo_let_bool_e)
       ; ("Correct infer let with string"
          >:: fun _ ->
          Choreo.TProd
            ( Choreo.TLoc (Local.LocId ("Charlie", m), Local.TInt m, m)
            , Choreo.TLoc (Local.LocId ("Charlie", m), Local.TString m, m)
            , m )
          |> choreo_expr_typ_eq correct_choreo_let_str_e)
       ; ("Correct infer nested let"
          >:: fun _ ->
          Choreo.TLoc (Local.LocId ("Bob", m), Local.TBool m, m)
          |> choreo_expr_typ_eq correct_choreo_nested_binding)
       ]
;;

let correct_choreo_pattern_suite =
  "Choreo pattern type inference tests"
  >::: [ ("Correct infer default pattern"
          >:: fun _ -> Choreo.TUnit m |> choreo_pattern_typ_eq choreo_def_p [])
       ; ("Correct infer var pattern"
          >:: fun _ ->
          Choreo.TVar (Choreo.Typ_Id ("T0", m), m)
          |> choreo_pattern_typ_eq
               choreo_var_p
               [ "foo", Choreo.TVar (Choreo.Typ_Id ("T0", m), m) ])
       ; ("Correct infer location int pattern"
          >:: fun _ ->
          Choreo.TLoc (Local.LocId ("Alice", m), Local.TInt m, m)
          |> choreo_pattern_typ_eq choreo_loc_int_p [])
      ; ("Correct infer location float pattern"
          >:: fun _ ->
          Choreo.TLoc (Local.LocId ("Alice", m), Local.TFloat m, m)
          |> choreo_pattern_typ_eq choreo_loc_float_p [])
       ; ("Correct infer pair pattern"
          >:: fun _ ->
          Choreo.TProd
            ( Choreo.TVar (Choreo.Typ_Id ("T0", m), m)
            , Choreo.TLoc (Local.LocId ("Alice", m), Local.TInt m, m)
            , m )
          |> choreo_pattern_typ_eq
               choreo_pair_p
               [ "foo", Choreo.TVar (Choreo.Typ_Id ("T0", m), m) ])
       ; ("Correct infer left pattern"
          >:: fun _ ->
          Choreo.TSum
            ( Choreo.TLoc (Local.LocId ("Alice", m), Local.TInt m, m)
            , Choreo.TVar (Choreo.Typ_Id ("T0", m), m)
            , m )
          |> choreo_pattern_typ_eq choreo_left_loc_p [])
       ; ("Correct pattern match"
          >:: fun _ ->
          Choreo.TLoc (Local.LocId ("Alice", m), Local.TInt m, m)
          |> choreo_expr_typ_eq choreo_correct_pattn_match)
       ; ("Correct left pattern with non-TLoc type"
          >:: fun _ ->
          Choreo.TSum
            ( Choreo.TLoc
                (Local.LocId ("dummy", m), Local.TVar (Local.TypId ("T0", m), m), m)
            , Choreo.TVar (Choreo.Typ_Id ("T1", m), m)
            , m )
          |> choreo_pattern_typ_eq choreo_left_def_p [])
       ; ("Correct right pattern with TLoc type"
          >:: fun _ ->
          Choreo.TSum
            ( Choreo.TVar (Choreo.Typ_Id ("T0", m), m)
            , Choreo.TLoc (Local.LocId ("Alice", m), Local.TInt m, m)
            , m )
          |> choreo_pattern_typ_eq choreo_right_loc_p [])
       ; ("Correct choreo match with TLoc patterns"
          >:: fun _ ->
          Choreo.TLoc (Local.LocId ("Alice", m), Local.TInt m, m)
          |> choreo_expr_typ_eq choreo_right_left_match)
       ]
;;

let incorrect_choreo_type_suite =
  "Detect choreo type errors"
  >::: [ ("Type error in if condition"
          >:: fun _ ->
          Failure "Expected boolean type"
          |> choreo_expr_typ_failures incorrect_choreo_if_condition)
       ; ("Location mismatch in send"
          >:: fun _ ->
          Failure "Source location mismatch"
          |> choreo_expr_typ_failures incorrect_choreo_send)
       ; ("Type error in function application"
          >:: fun _ ->
          Failure "Expected function type"
          |> choreo_expr_typ_failures incorrect_choreo_funapp)
       ; ("Type error in let declaration"
          >:: fun _ ->
          Failure "Type mismatch" |> choreo_expr_typ_failures incorrect_choreo_let_type)
       ; ("Unbound variable in let"
          >:: fun _ ->
          Failure "Variable not found when inferring expression"
          |> choreo_expr_typ_failures incorrect_choreo_let_binding)
       ; ("Location mismatch in variable use"
          >:: fun _ ->
          Failure "Source location mismatch"
          |> choreo_expr_typ_failures incorrect_choreo_location)
       ; ("Type error in pattern match - return type mismatch"
          >:: fun _ ->
          Failure "Unification failed"
          |> choreo_expr_typ_failures choreo_mismatched_return_match)
       ; ("Type error in pattern match - pattern type mismatch"
          >:: fun _ ->
          Failure "Type of patterns are not sum types"
          |> choreo_expr_typ_failures choreo_mismatched_pattn_match)
       ; ("Send with mismatched types"
          >:: fun _ ->
          let mismatch_send =
            Choreo.Send
              ( Local.LocId ("Alice", m)
              , Choreo.Let
                  (*expression of wrong type at Alice's loc*)
                  ( [ Choreo.Decl
                        ( Choreo.Var (Local.VarId ("x", m), m)
                        , Choreo.TLoc (Local.LocId ("Alice", m), Local.TString m, m)
                        , m )
                    ]
                  , Choreo.LocExpr
                      ( Local.LocId ("Alice", m)
                      , Local.Val (Local.Int (1, m), m) (*string expected but got int*)
                      , m )
                  , m )
              , Local.LocId ("Bob", m)
              , m )
          in
          Failure "Type mismatch" |> choreo_expr_typ_failures mismatch_send)
       ; ("Send with non-TLoc type"
          >:: fun _ ->
          let bad_send =
            Choreo.Send
              (Local.LocId ("Alice", m), Choreo.Unit m, Local.LocId ("Bob", m), m)
          in
          Failure "Type mismatch" |> choreo_expr_typ_failures bad_send)
       ; ("Let with multiple declarations"
          >:: fun _ ->
          let multi_decl_let =
            Choreo.Let
              ( [ Choreo.Decl
                    ( Choreo.Var (Local.VarId ("x", m), m)
                    , Choreo.TLoc (Local.LocId ("Alice", m), Local.TInt m, m)
                    , m )
                ; Choreo.Decl
                    ( Choreo.Var (Local.VarId ("y", m), m)
                    , Choreo.TLoc (Local.LocId ("Bob", m), Local.TInt m, m)
                    , m )
                ]
              , Choreo.Unit m
              , m )
          in
          Choreo.TUnit m |> choreo_expr_typ_eq multi_decl_let)
       ; ("Fst on non-product type"
          >:: fun _ ->
          let bad_fst = Choreo.Fst (Choreo.Unit m, m) in
          Failure "Expected product type" |> choreo_expr_typ_failures bad_fst)
       ; ("Snd on non-product type"
          >:: fun _ ->
          let bad_snd = Choreo.Snd (Choreo.Unit m, m) in
          Failure "Expected product type" |> choreo_expr_typ_failures bad_snd)
       ; ("Left with non-TLoc type"
          >:: fun _ ->
          let bad_left = Choreo.Left (Choreo.Unit m, m) in
          Failure "Expected location type in Left" |> choreo_expr_typ_failures bad_left)
       ; ("Right with non-TLoc type"
          >:: fun _ ->
          let bad_right = Choreo.Right (Choreo.Unit m, m) in
          Failure "Expected location type in Right" |> choreo_expr_typ_failures bad_right
         )
       ]
;;

(*------------------------Choreo stmt tests-------------------------------*)
let choreo_assign_test =
  Choreo.Assign
    ( [ Choreo.Var (Local.VarId ("x", m), m); Choreo.Var (Local.VarId ("y", m), m) ]
    , Choreo.LocExpr (Local.LocId ("Alice", m), Local.Val (Local.Int (1, m), m), m)
    , m )
;;

let choreo_decl_pattern_mismatch =
  Choreo.Let
    ( [ Choreo.Decl
          ( Choreo.Pair
              (*pair instead of var for a pattern mismatch case*)
              ( Choreo.Var (Local.VarId ("x", m), m)
              , Choreo.Var (Local.VarId ("y", m), m)
              , m )
          , Choreo.TLoc (Local.LocId ("Alice", m), Local.TInt m, m)
          , m )
      ]
    , Choreo.Unit m
    , m )
;;

let choreo_stmt_suite =
  "Choreo statement tests"
  >::: [ ("choreo assign test"
          >:: fun _ ->
          let _, t, _ = infer_choreo_stmt [] [] choreo_assign_test in
          let expected_t = Choreo.TLoc (Local.LocId ("Alice", m), Local.TInt m, m) in
          assert_equal true (chreo_typ_eq t expected_t))
       ; ("choreo decl pattern mismatch"
          >:: fun _ ->
          Failure "Pattern mismatch"
          |> choreo_expr_typ_failures choreo_decl_pattern_mismatch)
       ]
;;

(*------------------Bisect (Coverage check) test--------------------------*)
let unification_suite =
  "Unification helper functions tests"
  >::: [ ("Correct unify_local string"
          >:: fun _ -> unify_local_success (Local.TString m) (Local.TString m) [])
       ; ("Correct unify_local unit"
          >:: fun _ -> unify_local_success (Local.TUnit m) (Local.TUnit m) [])
       ; ("Correct unify_local var"
          >:: fun _ ->
          unify_local_success
            (Local.TVar (Local.TypId ("X", m), m))
            (Local.TInt m)
            [ "X", Local.TInt m ])
       ; ("Incorrect unify_local var occurs check"
          >:: fun _ ->
          let tvar = Local.TVar (Local.TypId ("X", m), m) in
          unify_local_failure
            tvar
            (Local.TProd (tvar, Local.TUnit m, m))
            "Occurs check failed")
       ; ("Correct unify_local var right side"
          >:: fun _ ->
          let tvar = Local.TVar (Local.TypId ("X", m), m) in
          unify_local_success (Local.TInt m) tvar [ "X", Local.TInt m ])
       ; ("Correct unify_local same var"
          >:: fun _ ->
          let tvar = Local.TVar (Local.TypId ("X", m), m) in
          unify_local_success tvar tvar [])
       ; ("Correct unify_local prod"
          >:: fun _ ->
          unify_local_success
            (Local.TProd (Local.TInt m, Local.TBool m, m))
            (Local.TProd (Local.TInt m, Local.TBool m, m))
            [])
       ; ("Correct unify_local sum"
          >:: fun _ ->
          unify_local_success
            (Local.TSum (Local.TInt m, Local.TBool m, m))
            (Local.TSum (Local.TInt m, Local.TBool m, m))
            [])
       ; ("Incorrect unify_local prod mismatch"
          >:: fun _ ->
          unify_local_failure
            (Local.TProd (Local.TInt m, Local.TBool m, m))
            (Local.TProd (Local.TBool m, Local.TBool m, m))
            "Unification failed")
       ; ("Correct unify_choreo unit"
          >:: fun _ -> unify_choreo_success (Choreo.TUnit m) (Choreo.TUnit m) [])
       ; ("Incorrect unify_choreo loc"
          >:: fun _ ->
          unify_choreo_failure
            (Choreo.TLoc (Local.LocId ("Alice", m), Local.TInt m, m))
            (Choreo.TLoc (Local.LocId ("Bob", m), Local.TInt m, m))
            "Location mismatch")
       ; ("Incorrect unify_choreo var"
          >:: fun _ ->
          let tvar = Choreo.TVar (Choreo.Typ_Id ("X", m), m) in
          unify_choreo_failure
            tvar
            (Choreo.TProd (tvar, Choreo.TUnit m, m))
            "Occurs check failed")
       ; ("Correct unify_choreo var right side"
          >:: fun _ ->
          let tvar = Choreo.TVar (Choreo.Typ_Id ("X", m), m) in
          unify_choreo_success (Choreo.TUnit m) tvar [ "X", Choreo.TUnit m ])
       ; ("Correct unify_choreo same var"
          >:: fun _ ->
          let tvar = Choreo.TVar (Choreo.Typ_Id ("X", m), m) in
          unify_choreo_success tvar tvar [])
       ; ("Correct unify_choreo map"
          >:: fun _ ->
          unify_choreo_success
            (Choreo.TMap (Choreo.TUnit m, Choreo.TUnit m, m))
            (Choreo.TMap (Choreo.TUnit m, Choreo.TUnit m, m))
            [])
       ; ("Correct unify_choreo prod"
          >:: fun _ ->
          unify_choreo_success
            (Choreo.TProd (Choreo.TUnit m, Choreo.TUnit m, m))
            (Choreo.TProd (Choreo.TUnit m, Choreo.TUnit m, m))
            [])
       ; ("Correct unify_choreo sum"
          >:: fun _ ->
          unify_choreo_success
            (Choreo.TSum (Choreo.TUnit m, Choreo.TUnit m, m))
            (Choreo.TSum (Choreo.TUnit m, Choreo.TUnit m, m))
            [])
       ; ("Incorrect unify_choreo map mismatch"
          >:: fun _ ->
          unify_choreo_failure
            (Choreo.TMap (Choreo.TUnit m, Choreo.TUnit m, m))
            (Choreo.TMap
               (Choreo.TLoc (Local.LocId ("Alice", m), Local.TInt m, m), Choreo.TUnit m, m))
            "Unification failed")
       ]
;;

let helper_suite =
  "Helper function tests"
  >::: [ ("extract_local_ctx test"
          >:: fun _ ->
          let global_ctx =
            [ "Alice", "x", Local.TInt m
            ; "Bob", "y", Local.TBool m
            ; "Alice", "z", Local.TString m
            ]
          in
          let result = extract_local_ctx global_ctx "Alice" in
          let expected = [ "x", Local.TInt m; "z", Local.TString m ] in
          assert_equal expected result)
       ; ("get_choreo_subst test"
          >:: fun _ ->
          let local_subst = [ "x", Local.TInt m; "y", Local.TBool m ] in
          let loc_id = Local.LocId ("Alice", m) in
          let result = get_choreo_subst local_subst loc_id in
          assert_equal
            [ "x", Choreo.TLoc (loc_id, Local.TInt m, m)
            ; "y", Choreo.TLoc (loc_id, Local.TBool m, m)
            ]
            result)
       ; ("get_choreo_ctx test"
          >:: fun _ ->
          let local_ctx = [ "x", Local.TInt m; "y", Local.TBool m ] in
          let loc_id = Local.LocId ("Alice", m) in
          let result = get_choreo_ctx local_ctx loc_id in
          assert_equal
            [ "x", Choreo.TLoc (loc_id, Local.TInt m, m)
            ; "y", Choreo.TLoc (loc_id, Local.TBool m, m)
            ]
            result)
       ; ("get_local_subst non-TLoc test"
          >:: fun _ ->
          let choreo_subst =
            [ "x", Choreo.TUnit m
            ; "y", Choreo.TLoc (Local.LocId ("Alice", m), Local.TInt m, m)
            ]
          in
          let loc_id = Local.LocId ("Alice", m) in
          let result = get_local_subst choreo_subst loc_id in
          assert_equal [ "y", Local.TInt m ] result)
       ; ("apply local substitution to TVar"
          >:: fun _ ->
          let tvar = Local.TVar (Local.TypId ("X", m), m) in
          let subst = [ "X", Local.TInt m ] in
          let result = apply_subst_typ_local subst tvar in
          assert_equal true (local_typ_eq result (Local.TInt m)))
       ; ("apply choreo substitution to TVar"
          >:: fun _ ->
          let tvar = Choreo.TVar (Choreo.Typ_Id ("X", m), m) in
          let subst = [ "X", Choreo.TUnit m ] in
          let result = apply_subst_typ_choreo subst tvar in
          assert_equal true (chreo_typ_eq result (Choreo.TUnit m)))
       ]
;;


let suite =
  "Float Tests"
  >::: [ "Pretty Print"
         >::: [ ("testcase0 pretty print" >:: fun _ -> peq Floats_testcases.exf0)
              ; ("testcase1 pretty print" >:: fun _ -> peq Floats_testcases.exf1)
              ; ("testcase2 pretty print" >:: fun _ -> peq Floats_testcases.exf2)
              ; ("testcase3 pretty print" >:: fun _ -> peq Floats_testcases.exf3)
              ]
       ; "Dot"
         >::: [ ("testcase0 dot" >:: fun _ -> deq Floats_testcases.exf0 Floats_testcases.dot0)
              ; ("testcase1 dot" >:: fun _ -> deq Floats_testcases.exf1 Floats_testcases.dot1)
              ; ("testcase2 dot" >:: fun _ -> deq Floats_testcases.exf2 Floats_testcases.dot2)
              ; ("testcase3 dot" >:: fun _ -> deq Floats_testcases.exf3 Floats_testcases.dot3)
         ]
       ; "Type Checking"
         >::: [ ("testcase1 type" >:: fun _ -> peq Floats_testcases.exf0)
              ; ("testcase2 type" >:: fun _ -> peq Floats_testcases.exf1)
              ; ("testcase3 type" >:: fun _ -> peq Floats_testcases.exf2)
              ; ("testcase4 type" >:: fun _ -> peq Floats_testcases.exf3)
          ]
       ]
;;

open Ast_core

module DummyInfo = struct
  type t = int
end

module LocalAst = Local.With (DummyInfo)
module ChoreoAst = Ast_core.Choreo.With (DummyInfo)

let test_expression_match_LOC (old_meta : int) (new_meta : int) =
  let var_int = Local.M.Int (1, old_meta) in
  let expr_pair1 : int Local.M.expr = Local.M.Val (var_int, old_meta) in
  let expr_pair2 : int Local.M.expr = Local.M.Val (var_int, old_meta) in
  let pat_pair1 : int Local.M.pattern = Local.M.Val (var_int, old_meta) in
  let (val_pat : int Local.M.expr) =
    Local.M.Match (expr_pair1, [ pat_pair1, expr_pair2 ], old_meta)
  in
  let (new_info : int Local.M.expr) = LocalAst.set_info_expr new_meta val_pat in
  assert_equal new_meta (LocalAst.get_info_expr new_info)
;;

let test_expression_right_LOC (old_meta : int) (new_meta : int) =
  let val_int = Local.M.Int (1, old_meta) in
  let val_expr : int Local.M.expr = Local.M.Val (val_int, old_meta) in
  let var_right = Local.M.Right (val_expr, 1) in
  let (new_right : int Local.M.expr) = LocalAst.set_info_expr new_meta var_right in
  assert_equal new_meta (LocalAst.get_info_expr new_right)
;;

let test_expression_left_LOC (old_meta : int) (new_meta : int) =
  let val_int = Local.M.Int (1, old_meta) in
  let val_expr : int Local.M.expr = Local.M.Val (val_int, old_meta) in
  let var_left = Local.M.Left (val_expr, 1) in
  let (new_left : int Local.M.expr) = LocalAst.set_info_expr new_meta var_left in
  assert_equal new_meta (LocalAst.get_info_expr new_left)
;;

let test_expression_snd_LOC (old_meta : int) (new_meta : int) =
  let val_int = Local.M.Int (1, old_meta) in
  let val_expr : int Local.M.expr = Local.M.Val (val_int, old_meta) in
  let var_snd = Local.M.Snd (val_expr, 1) in
  let (new_snd : int Local.M.expr) = LocalAst.set_info_expr new_meta var_snd in
  assert_equal new_meta (LocalAst.get_info_expr new_snd)
;;

let test_expression_fst_LOC (old_meta : int) (new_meta : int) =
  let val_int = Local.M.Int (1, old_meta) in
  let expr_1 : int Local.M.expr = Local.M.Val (val_int, old_meta) in
  let fst = Local.M.Fst (expr_1, 1) in
  let (new_fst : int Local.M.expr) = LocalAst.set_info_expr new_meta fst in
  assert_equal new_meta (LocalAst.get_info_expr new_fst)
;;

let test_expression_pair_LOC (old_meta : int) (new_meta : int) =
  let val_int = Local.M.Int (1, old_meta) in
  let expr_pair1 : int Local.M.expr = Local.M.Val (val_int, old_meta) in
  let expr_pair2 : int Local.M.expr = Local.M.Val (val_int, old_meta) in
  let (pair_expr : int Local.M.expr) = Local.M.Pair (expr_pair1, expr_pair2, old_meta) in
  let (new_pair : int Local.M.expr) = LocalAst.set_info_expr new_meta pair_expr in
  assert_equal new_meta (LocalAst.get_info_expr new_pair)
;;

let test_expression_let_LOC
  (old_meta : int)
  (new_meta : int)
  (input_int : int)
  (input_int2 : int)
  =
  let var_id = Local.M.VarId ("hi", old_meta) in
  let old_sum =
    Local.M.TSum (Local.M.TUnit old_meta, Local.M.TString input_int, input_int2)
  in
  let (var_expr : int Local.M.expr) = Local.M.Var (var_id, old_meta) in
  let (let_expr : int Local.M.expr) =
    Local.M.Let (var_id, old_sum, var_expr, var_expr, 1)
  in
  let (new_let : int Local.M.expr) = LocalAst.set_info_expr new_meta let_expr in
  assert_equal new_meta (LocalAst.get_info_expr new_let)
;;

let test_expression_binop_LOC (old_meta : int) (new_meta : int) =
  let var_id = Local.M.VarId ("hi", old_meta) in
  let (var_expr : int Local.M.expr) = Local.M.Var (var_id, old_meta) in
  let plus = Local.M.Plus 1 in
  let (bi_op : int Local.M.expr) = Local.M.BinOp (var_expr, plus, var_expr, 1) in
  let (new_bi_op : int Local.M.expr) = LocalAst.set_info_expr new_meta bi_op in
  assert_equal new_meta (LocalAst.get_info_expr new_bi_op)
;;

let test_expression_unop_LOC (old_meta : int) (new_meta : int) =
  let var_id = Local.M.VarId ("hi", old_meta) in
  let (var_expr : int Local.M.expr) = Local.M.Var (var_id, old_meta) in
  let neg = Local.M.Neg 1 in
  let (un_op : int Local.M.expr) = Local.M.UnOp (neg, var_expr, 1) in
  let (new_un_op : int Local.M.expr) = LocalAst.set_info_expr new_meta un_op in
  assert_equal new_meta (LocalAst.get_info_expr new_un_op)
;;

let test_expression_var_LOC (old_meta : int) (new_meta : int) =
  let var_int = Local.M.VarId ("hi", old_meta) in
  let (var_expr : int Local.M.expr) = Local.M.Var (var_int, old_meta) in
  let (new_expr : int Local.M.expr) = LocalAst.set_info_expr new_meta var_expr in
  assert_equal new_meta (LocalAst.get_info_expr new_expr)
;;

let test_expression_val_LOC (old_meta : int) (new_meta : int) =
  let val_int = Local.M.Int (1, old_meta) in
  let (int_expr : int Local.M.expr) = Local.M.Val (val_int, old_meta) in
  let (new_expr : int Local.M.expr) = LocalAst.set_info_expr new_meta int_expr in
  assert_equal new_meta (LocalAst.get_info_expr new_expr)
;;

let test_expression_unit_LOC (new_meta : int) =
  let val_unit = Local.M.Unit 1 in
  let (new_expr : int Local.M.expr) = LocalAst.set_info_expr new_meta val_unit in
  assert_equal new_meta (LocalAst.get_info_expr new_expr)
;;

let test_pattern_pair_LOC (old_meta : int) (new_meta : int) =
  let val_int = Local.M.Int (1, old_meta) in
  let pat_pair1 : int Local.M.pattern = Local.M.Val (val_int, old_meta) in
  let pat_pair2 : int Local.M.pattern = Local.M.Val (val_int, old_meta) in
  let (pat_pair : int Local.M.pattern) = Local.M.Pair (pat_pair1, pat_pair2, old_meta) in
  let (new_pat_pair : int Local.M.pattern) =
    LocalAst.set_info_pattern new_meta pat_pair
  in
  assert_equal new_meta (LocalAst.get_info_pattern new_pat_pair)
;;

let test_pattern_right_LOC (old_meta : int) (new_meta : int) =
  let var_id = Local.M.VarId ("hi", 1) in
  let (var_pat1 : int Local.M.pattern) = Local.M.Var (var_id, old_meta) in
  let (val_pat_right : int Local.M.pattern) = Local.M.Right (var_pat1, old_meta) in
  let (new_pat : int Local.M.pattern) =
    LocalAst.set_info_pattern new_meta val_pat_right
  in
  assert_equal new_meta (LocalAst.get_info_pattern new_pat)
;;

let test_pattern_left_LOC (old_meta : int) (new_meta : int) =
  let var_id = Local.M.VarId ("hi", 1) in
  let (var_pat1 : int Local.M.pattern) = Local.M.Var (var_id, old_meta) in
  let (val_pat_left : int Local.M.pattern) = Local.M.Left (var_pat1, old_meta) in
  let (new_pat : int Local.M.pattern) = LocalAst.set_info_pattern new_meta val_pat_left in
  assert_equal new_meta (LocalAst.get_info_pattern new_pat)
;;

let test_pattern_variable_LOC (old_meta : int) (new_meta : int) =
  let var_id = Local.M.VarId ("hi", 1) in
  let (val_pat : int Local.M.pattern) = Local.M.Var (var_id, old_meta) in
  let (new_pat : int Local.M.pattern) = LocalAst.set_info_pattern new_meta val_pat in
  assert_equal new_meta (LocalAst.get_info_pattern new_pat)
;;

let test_pattern_value_LOC (old_meta : int) (new_meta : int) =
  let val_int = Local.M.Int (1, old_meta) in
  let (pat : int Local.M.pattern) = Local.M.Val (val_int, 1) in
  let (new_pat : int Local.M.pattern) = LocalAst.set_info_pattern new_meta pat in
  assert_equal new_meta (LocalAst.get_info_pattern new_pat)
;;

let test_pattern_default_LOC (old_meta : int) (new_meta : int) =
  let old_default = Local.M.Default 1 in
  let new_default = LocalAst.set_info_pattern old_meta old_default in
  assert_equal old_meta (LocalAst.get_info_pattern new_default);
  let new_default2 = LocalAst.set_info_pattern new_meta old_default in
  assert_equal new_meta (LocalAst.get_info_pattern new_default2)
;;

let test_loc_id_LOC (old_meta : int) (new_meta : int) =
  let old_loc_id = Local.M.LocId ("string", old_meta) in
  let new_loc_id = LocalAst.set_info_locid new_meta old_loc_id in
  assert_equal new_meta (LocalAst.get_info_locid new_loc_id)
;;

let test_var_id_LOC (old_meta : int) (new_meta : int) =
  let old_var_id = Local.M.VarId ("string", old_meta) in
  let new_var_id = LocalAst.set_info_varid new_meta old_var_id in
  assert_equal new_meta (LocalAst.get_info_varid new_var_id)
;;

let test_type_id_LOC (old_meta : int) (new_meta : int) =
  let old_type_id = Local.M.TypId ("string", old_meta) in
  let new_type_id = LocalAst.set_info_typid new_meta old_type_id in
  assert_equal new_meta (LocalAst.get_info_typid new_type_id)
;;

let test_type_sum_LOC
  (old_meta : int)
  (new_meta : int)
  (input_int : int)
  (input_int2 : int)
  =
  let old_sum =
    Local.M.TSum (Local.M.TUnit old_meta, Local.M.TString input_int, input_int2)
  in
  let new_sum = LocalAst.set_info_typ new_meta old_sum in
  assert_equal new_meta (LocalAst.get_info_typ new_sum)
;;

let test_type_prod_LOC
  (old_meta : int)
  (new_meta : int)
  (input_int : int)
  (input_int2 : int)
  =
  let old_prod =
    Local.M.TProd (Local.M.TUnit old_meta, Local.M.TString input_int, input_int2)
  in
  let new_prod = LocalAst.set_info_typ new_meta old_prod in
  assert_equal new_meta (LocalAst.get_info_typ new_prod)
;;

let test_type_var_LOC (old_meta : int) (new_meta : int) (input_int : int) =
  let typ_id = Local.M.TypId ("string", old_meta) in
  let old_var = Local.M.TVar (typ_id, input_int) in
  let new_var = LocalAst.set_info_typ new_meta old_var in
  assert_equal new_meta (LocalAst.get_info_typ new_var)
;;

let test_type_unit_LOC (new_meta : int) (input_int : int) =
  let old_info = Local.M.TUnit input_int in
  let new_info = LocalAst.set_info_typ new_meta old_info in
  assert_equal new_meta (LocalAst.get_info_typ new_info)
;;

let test_type_bool_LOC (new_meta : int) (input_int : int) =
  let old_info = Local.M.TBool input_int in
  let new_info = LocalAst.set_info_typ new_meta old_info in
  assert_equal new_meta (LocalAst.get_info_typ new_info)
;;

let test_type_string_LOC (new_meta : int) (input_int : int) =
  let old_info = Local.M.TString input_int in
  let new_info = LocalAst.set_info_typ new_meta old_info in
  assert_equal new_meta (LocalAst.get_info_typ new_info)
;;

let test_type_int_LOC (new_meta : int) (input_int : int) =
  let old_info = Local.M.TInt input_int in
  let new_info = LocalAst.set_info_typ new_meta old_info in
  assert_equal new_meta (LocalAst.get_info_typ new_info)
;;

let test_type_float_LOC (new_meta : int) (input_float : int) =
  let old_info = Local.M.TFloat input_float in
  let new_info = LocalAst.set_info_typ new_meta old_info in
  assert_equal new_meta (LocalAst.get_info_typ new_info)
;;

let test_not_LOC (new_meta : int) (old_meta : int) =
  let old_not_op = Local.M.Not old_meta in
  assert_equal old_meta (LocalAst.get_info_unop old_not_op);
  let new_not_op = LocalAst.set_info_unop new_meta old_not_op in
  assert_equal new_meta (LocalAst.get_info_unop new_not_op)
;;

let test_neg_LOC (new_meta : int) (old_meta : int) =
  let old_neg_op = Local.M.Neg old_meta in
  assert_equal old_meta (LocalAst.get_info_unop old_neg_op);
  let new_neg_op = LocalAst.set_info_unop new_meta old_neg_op in
  assert_equal new_meta (LocalAst.get_info_unop new_neg_op)
;;

let test_geq_LOC (new_meta : int) (old_meta : int) =
  let old_geq_op = Local.M.Geq old_meta in
  assert_equal old_meta (LocalAst.get_info_binop old_geq_op);
  let new_geq_op = LocalAst.set_info_binop new_meta old_geq_op in
  assert_equal new_meta (LocalAst.get_info_binop new_geq_op)
;;

let test_gt_LOC (new_meta : int) (old_meta : int) =
  let old_gt_op = Local.M.Gt old_meta in
  assert_equal old_meta (LocalAst.get_info_binop old_gt_op);
  let new_gt_op = LocalAst.set_info_binop new_meta old_gt_op in
  assert_equal new_meta (LocalAst.get_info_binop new_gt_op)
;;

let test_lt_LOC (new_meta : int) (old_meta : int) =
  let old_lt_op = Local.M.Lt old_meta in
  assert_equal old_meta (LocalAst.get_info_binop old_lt_op);
  let new_lt_op = LocalAst.set_info_binop new_meta old_lt_op in
  assert_equal new_meta (LocalAst.get_info_binop new_lt_op)
;;

let test_neq_LOC (new_meta : int) (old_meta : int) =
  let old_neq_op = Local.M.Neq old_meta in
  assert_equal old_meta (LocalAst.get_info_binop old_neq_op);
  let new_neq_op = LocalAst.set_info_binop new_meta old_neq_op in
  assert_equal new_meta (LocalAst.get_info_binop new_neq_op)
;;

let test_leq_LOC (new_meta : int) (old_meta : int) =
  let old_leq_op = Local.M.Leq old_meta in
  assert_equal old_meta (LocalAst.get_info_binop old_leq_op);
  let new_leq_op = LocalAst.set_info_binop new_meta old_leq_op in
  assert_equal new_meta (LocalAst.get_info_binop new_leq_op)
;;

let test_eq_LOC (new_meta : int) (old_meta : int) =
  let old_eq_op = Local.M.Eq old_meta in
  assert_equal old_meta (LocalAst.get_info_binop old_eq_op);
  let new_eq_op = LocalAst.set_info_binop new_meta old_eq_op in
  assert_equal new_meta (LocalAst.get_info_binop new_eq_op)
;;

let test_div_LOC (new_meta : int) (old_meta : int) =
  let old_div_op = Local.M.Div old_meta in
  assert_equal old_meta (LocalAst.get_info_binop old_div_op);
  let new_div_op = LocalAst.set_info_binop new_meta old_div_op in
  assert_equal new_meta (LocalAst.get_info_binop new_div_op)
;;

let test_times_LOC (new_meta : int) (old_meta : int) =
  let old_times_op = Local.M.Times old_meta in
  assert_equal old_meta (LocalAst.get_info_binop old_times_op);
  let new_times_op = LocalAst.set_info_binop new_meta old_times_op in
  assert_equal new_meta (LocalAst.get_info_binop new_times_op)
;;

let test_ftimes_LOC (new_meta : int) (old_meta : int) =
  let old_times_op = Local.M.FTimes old_meta in
  assert_equal old_meta (LocalAst.get_info_binop old_times_op);
  let new_times_op = LocalAst.set_info_binop new_meta old_times_op in
  assert_equal new_meta (LocalAst.get_info_binop new_times_op)
;;

let test_fdiv_LOC (new_meta : int) (old_meta : int) =
  let old_div_op = Local.M.FDiv old_meta in
  assert_equal old_meta (LocalAst.get_info_binop old_div_op);
  let new_div_op = LocalAst.set_info_binop new_meta old_div_op in
  assert_equal new_meta (LocalAst.get_info_binop new_div_op)
;;

let test_and_LOC (new_meta : int) (old_meta : int) =
  let old_and_op = Local.M.And old_meta in
  assert_equal old_meta (LocalAst.get_info_binop old_and_op);
  let new_and_op = LocalAst.set_info_binop new_meta old_and_op in
  assert_equal new_meta (LocalAst.get_info_binop new_and_op)
;;

let test_or_LOC (new_meta : int) (old_meta : int) =
  let old_or_op = Local.M.Or old_meta in
  assert_equal old_meta (LocalAst.get_info_binop old_or_op);
  let new_or_op = LocalAst.set_info_binop new_meta old_or_op in
  assert_equal new_meta (LocalAst.get_info_binop new_or_op)
;;

let test_minus_LOC (new_meta : int) (old_meta : int) =
  let old_minus_op = Local.M.Minus old_meta in
  assert_equal old_meta (LocalAst.get_info_binop old_minus_op);
  let new_minus_op = LocalAst.set_info_binop new_meta old_minus_op in
  assert_equal new_meta (LocalAst.get_info_binop new_minus_op)
;;

let test_plus_LOC (new_meta : int) (old_meta : int) =
  let old_plus_op = Local.M.Plus old_meta in
  assert_equal old_meta (LocalAst.get_info_binop old_plus_op);
  let new_plus_op = LocalAst.set_info_binop new_meta old_plus_op in
  assert_equal new_meta (LocalAst.get_info_binop new_plus_op)
;;

let test_fminus_LOC (new_meta : int) (old_meta : int) =
  let old_minus_op = Local.M.FMinus old_meta in
  assert_equal old_meta (LocalAst.get_info_binop old_minus_op);
  let new_minus_op = LocalAst.set_info_binop new_meta old_minus_op in
  assert_equal new_meta (LocalAst.get_info_binop new_minus_op)
;;

let test_fplus_LOC (new_meta : int) (old_meta : int) =
  let old_plus_op = Local.M.FPlus old_meta in
  assert_equal old_meta (LocalAst.get_info_binop old_plus_op);
  let new_plus_op = LocalAst.set_info_binop new_meta old_plus_op in
  assert_equal new_meta (LocalAst.get_info_binop new_plus_op)
;;

let test_change_bool_LOC (new_meta : int) (old_meta : int) (input_bool : bool) =
  let old_info = Local.M.Bool (input_bool, old_meta) in
  let new_info = LocalAst.set_info_value new_meta old_info in
  assert_equal new_meta (LocalAst.get_info_value new_info)
;;

let test_change_string_LOC (new_meta : int) (old_meta : int) (input_string : string) =
  let old_info = Local.M.String (input_string, old_meta) in
  let new_info = LocalAst.set_info_value new_meta old_info in
  assert_equal new_meta (LocalAst.get_info_value new_info)
;;

let test_change_int_LOC (old_int : 'a) (new_int : 'a) =
  let old_info = Local.M.Int (old_int, old_int) in
  let new_info = LocalAst.set_info_value new_int old_info in
  assert_equal new_int (LocalAst.get_info_value new_info)
;;

let test_change_float_LOC (old_int : 'a) (new_int : 'a) =
  let old_info = Local.M.Float (1.0, old_int) in
  let new_info = LocalAst.set_info_value new_int old_info in
  assert_equal new_int (LocalAst.get_info_value new_info)
;;

(* add float here *)

(*-----------------------------------------------------------*)
(* LOC Test Suite *)
(*-----------------------------------------------------------*)
let loc_suite =
  "Ast_core Local Tests"
  >::: [ "Int Tests"
         >::: [ ("test_change_int 1 2" >:: fun _ -> test_change_int_LOC 1 2)
              ; ("test_change_int 2 3" >:: fun _ -> test_change_int_LOC 2 3)
              ; ("test_change_int 10 20" >:: fun _ -> test_change_int_LOC 10 20)
              ; ("test_change_int (-1) (-2)" >:: fun _ -> test_change_int_LOC (-1) (-2))
              ; ("test_change_int 1000 2000" >:: fun _ -> test_change_int_LOC 1000 2000)
         ]
            ; "Float Tests"
              >::: [ ("test_change_float 1 2" >:: fun _ -> test_change_float_LOC 1 2)
                   ; ("test_change_float 2 3" >:: fun _ -> test_change_float_LOC 2 3)
                   ; ("test_change_float 10 20" >:: fun _ -> test_change_float_LOC 10 20)
                   ; ("test_change_float (-1) (-2)" >:: fun _ -> test_change_float_LOC (-1) (-2))
                   ; ("test_change_float 1000 2000" >:: fun _ -> test_change_int_LOC 1000 2000)
              ]
       ; "String Tests"
         >::: [ ("test_change_string 1 2 \"hello\""
                 >:: fun _ -> test_change_string_LOC 1 2 "hello")
              ; ("test_change_string 2 3 \"hellonjdvsbvjsbgjkbs\""
                 >:: fun _ -> test_change_string_LOC 2 3 "hellonjdvsbvjsbgjkbs")
              ; ("test_change_string 10 20 \"hi\""
                 >:: fun _ -> test_change_string_LOC 10 20 "hi")
              ; ("test_change_string 1000 2000 \"hello\""
                 >:: fun _ -> test_change_string_LOC 1000 2000 "hello")
              ; ("test_change_string (-1) (-2) \"hello\""
                 >:: fun _ -> test_change_string_LOC (-1) (-2) "hello")
              ]
       ; "Bool Tests"
         >::: [ ("test_change_bool 1 2 false" >:: fun _ -> test_change_bool_LOC 1 2 false)
              ; ("test_change_bool 2 3 true" >:: fun _ -> test_change_bool_LOC 2 3 true)
              ; ("test_change_bool 10 20 false"
                 >:: fun _ -> test_change_bool_LOC 10 20 false)
              ; ("test_change_bool 1000 2000 true"
                 >:: fun _ -> test_change_bool_LOC 1000 2000 true)
              ; ("test_change_bool (-1) (-2) false"
                 >:: fun _ -> test_change_bool_LOC (-1) (-2) false)
              ]
       ; "Operators Tests"
         >::: [ ("test_plus 1 2" >:: fun _ -> test_plus_LOC 1 2)
              ; ("test_minus 1 2" >:: fun _ -> test_minus_LOC 1 2)
              ; ("test_fplus 1 2" >:: fun _ -> test_fplus_LOC 1 2)
              ; ("test_fminus 1 2" >:: fun _ -> test_fminus_LOC 1 2)
              ; ("test_or 1 2" >:: fun _ -> test_or_LOC 1 2)
              ; ("test_and 1 2" >:: fun _ -> test_and_LOC 1 2)
              ; ("test_not 1 2" >:: fun _ -> test_not_LOC 1 2)
              ; ("test_neg 1 2" >:: fun _ -> test_neg_LOC 1 2)
              ; ("test_type_int 1 2" >:: fun _ -> test_type_int_LOC 1 2)
              ; ("test_type_float 1 2" >:: fun _ -> test_type_float_LOC 1 2)
              ; ("test_type_string 1 2" >:: fun _ -> test_type_string_LOC 1 2)
              ; ("test_type_bool 1 2" >:: fun _ -> test_type_bool_LOC 1 2)
              ; ("test_times 1 2" >:: fun _ -> test_times_LOC 1 2)
              ; ("test_div 1 2" >:: fun _ -> test_div_LOC 1 2)
              ; ("test_ftimes 1 2" >:: fun _ -> test_ftimes_LOC 1 2)
              ; ("test_fdiv 1 2" >:: fun _ -> test_fdiv_LOC 1 2)
              ; ("test_lt 1 2" >:: fun _ -> test_lt_LOC 1 2)
              ; ("test_gt 1 2" >:: fun _ -> test_gt_LOC 1 2)
              ; ("test_leq 1 2" >:: fun _ -> test_leq_LOC 1 2)
              ; ("test_geq 1 2" >:: fun _ -> test_geq_LOC 1 2)
              ; ("test_neq 1 2" >:: fun _ -> test_neq_LOC 1 2)
              ; ("test_eq 1 2" >:: fun _ -> test_eq_LOC 1 2)
              ]
       ; "Type Tests"
         >::: [ ("test_type_int 1 2" >:: fun _ -> test_type_int_LOC 1 2)
              ; ("test_type_float 1 2" >:: fun _ -> test_type_float_LOC 1 2)
              ; ("test_type_string 1 2" >:: fun _ -> test_type_string_LOC 1 2)
              ; ("test_type_bool 1 2" >:: fun _ -> test_type_bool_LOC 1 2)
              ; ("test_type_prod 1 2 3 4" >:: fun _ -> test_type_prod_LOC 1 2 3 4)
              ; ("test_type_sum 1 2 3 4" >:: fun _ -> test_type_sum_LOC 1 2 3 4)
              ; ("test_type_var 1 2 3" >:: fun _ -> test_type_var_LOC 1 2 3)
              ; ("test_type_unit 1 2" >:: fun _ -> test_type_unit_LOC 1 2)
              ; ("test_type_id 1 2" >:: fun _ -> test_type_id_LOC 1 2)
              ; ("test_var_id 1 2" >:: fun _ -> test_var_id_LOC 1 2)
              ; ("test_loc_id 1 2" >:: fun _ -> test_loc_id_LOC 1 2)
              ]
       ; "Pattern Tests"
         >::: [ ("test_pattern_default 1 2" >:: fun _ -> test_pattern_default_LOC 1 2)
              ; ("test_pattern_value 1 2" >:: fun _ -> test_pattern_value_LOC 1 2)
              ; ("test_pattern_variable 1 2" >:: fun _ -> test_pattern_variable_LOC 1 2)
              ; ("test_pattern_left 1 2" >:: fun _ -> test_pattern_left_LOC 1 2)
              ; ("test_pattern_right 1 2" >:: fun _ -> test_pattern_right_LOC 1 2)
              ; ("test_pattern_pair 1 2" >:: fun _ -> test_pattern_pair_LOC 1 2)
              ]
       ; "Expression Tests"
         >::: [ ("test_expression_unit 2" >:: fun _ -> test_expression_unit_LOC 2)
              ; ("test_expression_val 1 2" >:: fun _ -> test_expression_val_LOC 1 2)
              ; ("test_expression_unop 1 2" >:: fun _ -> test_expression_unop_LOC 1 2)
              ; ("test_expression_var 1 2" >:: fun _ -> test_expression_var_LOC 1 2)
              ; ("test_expression_binop 1 2" >:: fun _ -> test_expression_binop_LOC 1 2)
              ; ("test_expression_let 1 2 3 4"
                 >:: fun _ -> test_expression_let_LOC 1 2 3 4)
              ; ("test_expression_fst 1 2" >:: fun _ -> test_expression_fst_LOC 1 2)
              ; ("test_expression_snd 1 2" >:: fun _ -> test_expression_snd_LOC 1 2)
              ; ("test_expression_left 1 2" >:: fun _ -> test_expression_left_LOC 1 2)
              ; ("test_expression_right 1 2" >:: fun _ -> test_expression_right_LOC 1 2)
              ; ("test_expression_match 1 2" >:: fun _ -> test_expression_match_LOC 1 2)
              ; ("test_expression_pair 1 2" >:: fun _ -> test_expression_pair_LOC 1 2)
              ]
       ]
;;

(*-----------------------------------------------------------*)
(* CH Get + Set Info Pattern Tests *)
(*-----------------------------------------------------------*)





let all_suites =
  "All float tests"
  >::: [ (*Local test suites*)
         const_suite
       ; local_binding_suite
       ; correct_pattn_suite
       ; incorrect_local_type_suite
       ; (*Choreo test suites*)
         choreo_const_suite
       ; choreo_binding_suite
       ; correct_choreo_pattern_suite
       ; incorrect_choreo_type_suite
       ; choreo_stmt_suite
       ; (*Unification test suite*)
         unification_suite
       ; (*Helper functions test suite*)
         helper_suite
        ; suite
        ; loc_suite
       ]
;;


let () = run_test_tt_main all_suites
