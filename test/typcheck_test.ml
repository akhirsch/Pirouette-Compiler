(*
   File: typcheck_tests.ml
   Date: 10-10-2024

   Tests for the type checking module.
   Read and parse the string representation of a program from Testcases.ml to AST
   Call the type checking function on the AST with the expected type and check if the
   type checking is successful.
*)

open OUnit2
open Typing.Typ_infer

let m : ftv = Ok "dummy info"
let assert_true = assert_equal true

(*--------------------Local type inference testcases--------------------*)

(*Const type inference testcases*)
let correct_unit_e = Local.Unit m
let correct_binop_bool_e = Local.BinOp (Val (Int (1, m), m), Eq m, Val (Int (1, m), m), m)
let correct_binop_int_e = Local.BinOp (Val (Int (1, m), m), Plus m, Val (Int (1, m), m), m)
let correct_unop_bool_e = Local.UnOp (Not m, correct_binop_bool_e, m)
let correct_and_bool_e = Local.BinOp (correct_binop_bool_e, And m, correct_unop_bool_e, m)
let correct_unop_int_e = Local.UnOp (Neg m, correct_binop_int_e, m)
let correct_pair_e = Local.Pair (correct_binop_int_e, Val (String ("hello", m), m), m)
let correct_fst = Local.Fst (correct_pair_e, m)
let correct_snd = Local.Snd (correct_pair_e, m)
let correct_left = Local.Left (correct_binop_int_e, m)
let correct_right = Local.Right (correct_binop_int_e, m)
let correct_variant = Local.Constructors ()

(*Binding local type variables*)
let int_var = Local.BinOp (correct_binop_int_e, Plus m, Var (VarId ("foo", m), m), m)
let bool_var = Local.BinOp (Var (VarId ("foo", m), m), Or m, Val (Bool (false, m), m), m)
let string_var = Local.Pair (correct_binop_int_e, Var (VarId ("foo", m), m), m)

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
       ; ("Correct infer local not bool"
          >:: fun _ -> TBool m |> local_expr_typ_eq correct_unop_bool_e)
       ; ("Correct infer local and bool"
          >:: fun _ -> TBool m |> local_expr_typ_eq correct_and_bool_e)
       ; ("Correct infer local neg int"
          >:: fun _ -> TInt m |> local_expr_typ_eq correct_unop_int_e)
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
       ; ("Correct pattern match" >:: fun _ -> TInt m |> local_expr_typ_eq int_pattn_match)
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
       ; ("type error in local unop bool"
          >:: fun _ ->
          Failure "Unification failed" |> local_expr_typ_failures incorrect_unop_bool_e)
       ; ("type error in local binop bool 2"
          >:: fun _ ->
          Failure "Unification failed" |> local_expr_typ_failures incorrect_and_bool_e)
       ; ("type error in local unop int"
          >:: fun _ ->
          Failure "Unification failed" |> local_expr_typ_failures incorrect_unop_int_e)
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

(*--------------------Choreo type inference testcases--------------------*)

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

(*--------------------Detect choreo type errors--------------------*)
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

let variants_type_test_local =
  "variants test local"
  >::: [
    
         "type declaration matches type returned"
         >:: (fun _ ->
           let input = (*test input data*) in
           let expected_output = (*expected result**) in
           let actual_output = My_module.function_to_test input in
           assert_equal expected_output actual_output);

         "type declaration matches type returned for multiple constructos"
         >:: (fun _ ->
           let expected = 42 (*placeholders*)in
           let result = 21 + 21 in
           assert_equal expected result ~msg:"Optional message on failure");

         "type checking fails if type returned does no match type declaration"
         >:: (fun _ ->
            assert_raises (Failure "An expected error message") (fun () -> 
                My_module.function_that_fails ()
            ))

       ]
;;

let variants_type_test_choreo =
  "variant tests local"
  >::: [
    
         "type declaration matches type returned"
         >:: (fun _ ->
           let input = (* ... your test input data ... *) in
           let expected_output = (* ... the result you expect ... *) in
           let actual_output = My_module.function_to_test input in
           assert_equal expected_output actual_output);

         "type declaration matches type returned for multiple constructos"
         >:: (fun _ ->
           let expected = 42 in
           let result = 21 + 21 in
           assert_equal expected result ~msg:"Optional message on failure");

         "type checking fails if type returned does no match type declaration"
         >:: (fun _ ->
            assert_raises (Failure "An expected error message") (fun () -> 
                My_module.function_that_fails ()
            ))

       ]
;;

let () = run_test_tt_main suite
;;

let all_suites =
  "All type inference tests"
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
       ; variants_type_test_local
       ; variants_type_test_choreo
       ]
;;

let () =
  print_endline "\nRunning all type inference tests";
  run_test_tt_main all_suites
;;
