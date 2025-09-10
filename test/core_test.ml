open OUnit2
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
              ; ("test_or 1 2" >:: fun _ -> test_or_LOC 1 2)
              ; ("test_and 1 2" >:: fun _ -> test_and_LOC 1 2)
              ; ("test_not 1 2" >:: fun _ -> test_not_LOC 1 2)
              ; ("test_neg 1 2" >:: fun _ -> test_neg_LOC 1 2)
              ; ("test_type_int 1 2" >:: fun _ -> test_type_int_LOC 1 2)
              ; ("test_type_string 1 2" >:: fun _ -> test_type_string_LOC 1 2)
              ; ("test_type_bool 1 2" >:: fun _ -> test_type_bool_LOC 1 2)
              ; ("test_times 1 2" >:: fun _ -> test_times_LOC 1 2)
              ; ("test_div 1 2" >:: fun _ -> test_div_LOC 1 2)
              ; ("test_lt 1 2" >:: fun _ -> test_lt_LOC 1 2)
              ; ("test_gt 1 2" >:: fun _ -> test_gt_LOC 1 2)
              ; ("test_leq 1 2" >:: fun _ -> test_leq_LOC 1 2)
              ; ("test_geq 1 2" >:: fun _ -> test_geq_LOC 1 2)
              ; ("test_neq 1 2" >:: fun _ -> test_neq_LOC 1 2)
              ; ("test_eq 1 2" >:: fun _ -> test_eq_LOC 1 2)
              ]
       ; "Type Tests"
         >::: [ ("test_type_int 1 2" >:: fun _ -> test_type_int_LOC 1 2)
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
let test_pattern_default_CH (old_meta : int) (new_meta : int) =
  let old_info = Choreo.M.Default 1 in
  let new_info = ChoreoAst.set_info_pattern old_meta old_info in
  assert_equal old_meta (ChoreoAst.get_info_pattern new_info);
  let new_info = ChoreoAst.set_info_pattern new_meta old_info in
  assert_equal new_meta (ChoreoAst.get_info_pattern new_info)
;;

let test_pattern_variable_CH (old_meta : int) (new_meta : int) =
  let var_id = Local.M.VarId ("2", 1) in
  let (val_pat : int Choreo.M.pattern) = Choreo.M.Var (var_id, old_meta) in
  let (new_info : int Choreo.M.pattern) = ChoreoAst.set_info_pattern new_meta val_pat in
  assert_equal new_meta (ChoreoAst.get_info_pattern new_info)
;;

let test_pattern_pair_CH (old_meta : int) (new_meta : int) =
  let var_id = Local.M.VarId ("2", old_meta) in
  let pat_pair1 : int Choreo.M.pattern = Choreo.M.Var (var_id, old_meta) in
  let pat_pair2 : int Choreo.M.pattern = Choreo.M.Var (var_id, old_meta) in
  let (val_pat : int Choreo.M.pattern) = Choreo.M.Pair (pat_pair1, pat_pair2, old_meta) in
  let (new_info : int Choreo.M.pattern) = ChoreoAst.set_info_pattern new_meta val_pat in
  assert_equal new_meta (ChoreoAst.get_info_pattern new_info)
;;

let test_pattern_locpat_CH (old_meta : int) (new_meta : int) =
  let loc_id = Local.M.LocId ("old_meta", old_meta) in
  let var_id = Local.M.VarId ("new_meta", new_meta) in
  let pat : int Local.M.pattern = Local.M.Var (var_id, old_meta) in
  let old_typ_var = Choreo.M.LocPat (loc_id, pat, old_meta) in
  let new_typ_var = ChoreoAst.set_info_pattern new_meta old_typ_var in
  assert_equal new_meta (ChoreoAst.get_info_pattern new_typ_var)
;;

let test_pattern_right_CH (old_meta : int) (new_meta : int) =
  let var_id = Local.M.VarId ("old_meta", old_meta) in
  let (var_pat1 : int Choreo.M.pattern) = Choreo.M.Var (var_id, old_meta) in
  let (val_pat : int Choreo.M.pattern) = Choreo.M.Right (var_pat1, old_meta) in
  let (new_info : int Choreo.M.pattern) = ChoreoAst.set_info_pattern new_meta val_pat in
  assert_equal new_meta (ChoreoAst.get_info_pattern new_info)
;;

let test_pattern_left_CH (old_meta : int) (new_meta : int) =
  let var_id = Local.M.VarId ("2", old_meta) in
  let (var_pat1 : int Choreo.M.pattern) = Choreo.M.Var (var_id, old_meta) in
  let (val_pat : int Choreo.M.pattern) = Choreo.M.Left (var_pat1, old_meta) in
  let (new_info : int Choreo.M.pattern) = ChoreoAst.set_info_pattern new_meta val_pat in
  assert_equal new_meta (ChoreoAst.get_info_pattern new_info)
;;

(*-----------------------------------------------------------*)
(* CH Get Info Typ Tests *)
(*-----------------------------------------------------------*)
let test_get_info_typid_CH (input : int) =
  let typ_var = Choreo.M.Typ_Id ("new_meta", input) in
  assert_equal input (ChoreoAst.get_info_typid typ_var)
;;

let test_get_info_tunit_CH (meta : int) =
  let typ_var = Choreo.M.TUnit meta in
  assert_equal meta (ChoreoAst.get_info_typ typ_var)
;;

let test_get_info_tloc_CH (meta : int) =
  let val_id = Local.M.LocId ("meta", meta) in
  let val_typ = Local.M.TInt meta in
  let typ_var = Choreo.M.TLoc (val_id, val_typ, meta) in
  assert_equal meta (ChoreoAst.get_info_typ typ_var)
;;

let test_get_info_tvar_CH (meta : int) =
  let val_id = Choreo.M.Typ_Id ("meta", meta) in
  let typ_var = Choreo.M.TVar (val_id, meta) in
  assert_equal meta (ChoreoAst.get_info_typ typ_var)
;;

let test_get_info_tmap_CH (meta1 : int) (meta2 : int) =
  let m1 = Choreo.M.Typ_Id ("m1", meta1) in
  let val1 = Choreo.M.TVar (m1, meta1) in
  let m2 = Choreo.M.Typ_Id ("m2", meta2) in
  let val2 = Choreo.M.TVar (m2, meta2) in
  let typ_var = Choreo.M.TMap (val1, val2, meta1) in
  assert_equal (ChoreoAst.get_info_typ typ_var) meta1
;;

let test_get_info_tprod_CH (meta1 : int) (meta2 : int) =
  let m1 = Choreo.M.Typ_Id ("m1", meta1) in
  let val1 = Choreo.M.TVar (m1, meta1) in
  let m2 = Choreo.M.Typ_Id ("m2", meta2) in
  let val2 = Choreo.M.TVar (m2, meta2) in
  let typ_var = Choreo.M.TProd (val1, val2, meta1) in
  assert_equal (ChoreoAst.get_info_typ typ_var) meta1
;;

let test_get_info_tsum_CH (meta1 : int) (meta2 : int) =
  let m1 = Choreo.M.Typ_Id ("m1", meta1) in
  let val1 = Choreo.M.TVar (m1, meta1) in
  let m2 = Choreo.M.Typ_Id ("m2", meta2) in
  let val2 = Choreo.M.TVar (m2, meta2) in
  let typ_var = Choreo.M.TSum (val1, val2, meta1) in
  assert_equal (ChoreoAst.get_info_typ typ_var) meta1
;;

(*-----------------------------------------------------------*)
(* CH Get Info Exp Tests *)
(*-----------------------------------------------------------*)
let test_get_info_unit_CH (meta : int) =
  let typ_var = Choreo.M.Unit meta in
  assert_equal meta (ChoreoAst.get_info_expr typ_var)
;;

let test_get_info_var_CH (meta : int) =
  let var_id = Local.M.VarId ("meta", meta) in
  let typ_var = Choreo.M.Var (var_id, meta) in
  assert_equal meta (ChoreoAst.get_info_expr typ_var)
;;

let test_get_info_locexpr_CH (meta1 : int) (meta2 : int) =
  let loc_id = Local.M.LocId ("m1", meta1) in
  let var_val = Local.M.Int (1, meta1) in
  let var_exp = Local.M.Val (var_val, meta2) in
  let typ_var = Choreo.M.LocExpr (loc_id, var_exp, meta2) in
  assert_equal meta2 (ChoreoAst.get_info_expr typ_var)
;;

let test_get_info_send_CH (meta1 : int) (meta2 : int) (meta3 : int) =
  let loc_id1 = Local.M.LocId ("meta1", meta1) in
  let exp = Choreo.M.Unit 1 in
  let loc_id2 = Local.M.LocId ("meta2", meta2) in
  let typ_var = Choreo.M.Send (loc_id1, exp, loc_id2, meta3) in
  assert_equal meta3 (ChoreoAst.get_info_expr typ_var)
;;

let test_get_info_sync_CH (meta1 : int) (meta2 : int) (meta3 : int) (meta4 : int) =
  let loc_id1 = Local.M.LocId ("meta1", meta1) in
  let label = Local.M.LabelId ("meta2", meta2) in
  let loc_id2 = Local.M.LocId ("meta3", meta3) in
  let exp = Choreo.M.Unit 1 in
  let typ_var = Choreo.M.Sync (loc_id1, label, loc_id2, exp, meta4) in
  assert_equal meta4 (ChoreoAst.get_info_expr typ_var)
;;

let test_get_info_if_CH (meta1 : int) (meta2 : int) (meta3 : int) (meta4 : int) =
  let m1 = Local.M.VarId ("m1", meta1) in
  let e1 = Choreo.M.Var (m1, meta1) in
  let m2 = Local.M.VarId ("m2", meta2) in
  let e2 = Choreo.M.Var (m2, meta2) in
  let m3 = Local.M.VarId ("m3", meta3) in
  let e3 = Choreo.M.Var (m3, meta3) in
  let typ_var = Choreo.M.If (e1, e2, e3, meta4) in
  assert_equal (ChoreoAst.get_info_expr typ_var) meta4
;;

let test_get_info_let_CH (meta1 : int) (meta2 : int) (meta3 : int) =
  let pat = Choreo.M.Default meta1 in
  let typ = Choreo.M.TUnit meta1 in
  let dec1 = Choreo.M.Decl (pat, typ, meta1) in
  let stmts : int Choreo.M.stmt_block = [ dec1 ] in
  let m2 = Local.M.VarId ("m2", meta2) in
  let exp = Choreo.M.Var (m2, meta2) in
  let typ_var = Choreo.M.Let (stmts, exp, meta3) in
  assert_equal meta3 (ChoreoAst.get_info_expr typ_var)
;;

let test_get_info_fundef_CH (meta1 : int) (meta2 : int) =
  let pat_list : 'a Choreo.M.pattern list =
    [ Choreo.M.Default meta1; Choreo.M.Default meta1 ]
  in
  let exp = Choreo.M.Unit 1 in
  let typ_var = Choreo.M.FunDef (pat_list, exp, meta2) in
  assert_equal meta2 (ChoreoAst.get_info_expr typ_var)
;;

let test_get_info_funapp_CH (meta : int) =
  let exp1 = Choreo.M.Unit 1 in
  let exp2 = Choreo.M.Unit 0 in
  let typ_var = Choreo.M.FunApp (exp1, exp2, meta) in
  assert_equal meta (ChoreoAst.get_info_expr typ_var)
;;

let test_get_info_pair_CH (meta1 : int) (meta2 : int) =
  let m1 = Local.M.VarId ("m1", meta1) in
  let m2 = Local.M.VarId ("m2", meta2) in
  let pat_pair1 : int Choreo.M.expr = Choreo.M.Var (m1, meta1) in
  let pat_pair2 = Choreo.M.Var (m2, meta2) in
  let typ_var : int Choreo.M.expr = Choreo.M.Pair (pat_pair1, pat_pair2, meta1) in
  assert_equal meta1 (ChoreoAst.get_info_expr typ_var)
;;

let test_get_info_fst_CH (meta : int) =
  let exp = Choreo.M.Unit 1 in
  let typ_var = Choreo.M.Fst (exp, meta) in
  assert_equal meta (ChoreoAst.get_info_expr typ_var)
;;

let test_get_info_snd_CH (meta : int) =
  let exp = Choreo.M.Unit 1 in
  let typ_var = Choreo.M.Snd (exp, meta) in
  assert_equal meta (ChoreoAst.get_info_expr typ_var)
;;

let test_get_info_left_CH (meta : int) =
  let exp = Choreo.M.Unit 1 in
  let typ_var = Choreo.M.Left (exp, meta) in
  assert_equal meta (ChoreoAst.get_info_expr typ_var)
;;

let test_get_info_right_CH (meta : int) =
  let exp = Choreo.M.Unit 1 in
  let typ_var = Choreo.M.Right (exp, meta) in
  assert_equal meta (ChoreoAst.get_info_expr typ_var)
;;

let test_get_info_match_CH (meta1 : int) (meta2 : int) =
  let exp = Choreo.M.Unit 1 in
  let pat = Choreo.M.Default meta1 in
  let cases : (int Choreo.M.pattern * int Choreo.M.expr) list = [ pat, exp ] in
  let typ_var = Choreo.M.Match (exp, cases, meta2) in
  assert_equal meta2 (ChoreoAst.get_info_expr typ_var)
;;

(*-----------------------------------------------------------*)
(* CH Set Info Typ Tests *)
(*-----------------------------------------------------------*)
let test_set_info_typid_CH (old_meta : int) (new_meta : int) =
  let old_typ_var = Choreo.M.Typ_Id ("old_meta", old_meta) in
  let new_typ_var = ChoreoAst.set_info_typid new_meta old_typ_var in
  assert_equal (ChoreoAst.get_info_typid new_typ_var) new_meta
;;

let test_set_info_tunit_CH (old_meta : int) (new_meta : int) =
  let old_typ_var = Choreo.M.TUnit old_meta in
  let new_typ_var = ChoreoAst.set_info_typ new_meta old_typ_var in
  assert_equal new_meta (ChoreoAst.get_info_typ new_typ_var)
;;

let test_set_info_tloc_CH (old_meta : int) (new_meta : int) =
  let val_id = Local.M.LocId ("old_meta", old_meta) in
  let val_typ = Local.M.TInt old_meta in
  let old_typ_var = Choreo.M.TLoc (val_id, val_typ, old_meta) in
  let new_typ_var = ChoreoAst.set_info_typ new_meta old_typ_var in
  assert_equal new_meta (ChoreoAst.get_info_typ new_typ_var)
;;

let test_set_info_tvar_CH (old_meta : int) (new_meta : int) =
  let val_id = Choreo.M.Typ_Id ("old_meta", old_meta) in
  let old_typ_var = Choreo.M.TVar (val_id, old_meta) in
  let new_typ_var = ChoreoAst.set_info_typ new_meta old_typ_var in
  assert_equal new_meta (ChoreoAst.get_info_typ new_typ_var)
;;

let test_set_info_tmap_CH (old_meta1 : int) (old_meta2 : int) (new_meta : int) =
  let m1 = Choreo.M.Typ_Id ("m1", old_meta1) in
  let val1 = Choreo.M.TVar (m1, old_meta1) in
  let m2 = Choreo.M.Typ_Id ("m2", old_meta2) in
  let val2 = Choreo.M.TVar (m2, old_meta2) in
  let old_typ_var = Choreo.M.TMap (val1, val2, old_meta1) in
  let new_typ_var = ChoreoAst.set_info_typ new_meta old_typ_var in
  assert_equal (ChoreoAst.get_info_typ new_typ_var) new_meta
;;

let test_set_info_tprod_CH (old_meta1 : int) (old_meta2 : int) (new_meta : int) =
  let m1 = Choreo.M.Typ_Id ("m1", old_meta1) in
  let val1 = Choreo.M.TVar (m1, old_meta1) in
  let m2 = Choreo.M.Typ_Id ("m2", old_meta2) in
  let val2 = Choreo.M.TVar (m2, old_meta2) in
  let old_typ_var = Choreo.M.TProd (val1, val2, old_meta1) in
  let new_typ_var = ChoreoAst.set_info_typ new_meta old_typ_var in
  assert_equal (ChoreoAst.get_info_typ new_typ_var) new_meta
;;

let test_set_info_tsum_CH (old_meta1 : int) (old_meta2 : int) (new_meta : int) =
  let m1 = Choreo.M.Typ_Id ("m1", old_meta1) in
  let val1 = Choreo.M.TVar (m1, old_meta1) in
  let m2 = Choreo.M.Typ_Id ("m2", old_meta2) in
  let val2 = Choreo.M.TVar (m2, old_meta2) in
  let old_typ_var = Choreo.M.TSum (val1, val2, old_meta1) in
  let new_typ_var = ChoreoAst.set_info_typ new_meta old_typ_var in
  assert_equal (ChoreoAst.get_info_typ new_typ_var) new_meta
;;

(*-----------------------------------------------------------*)
(* CH Set Info Exp Tests *)
(*-----------------------------------------------------------*)
let test_set_info_unit_CH (old_meta : int) (new_meta : int) =
  let old_typ_var = Choreo.M.Unit old_meta in
  let new_typ_var = ChoreoAst.set_info_expr new_meta old_typ_var in
  assert_equal new_meta (ChoreoAst.get_info_expr new_typ_var)
;;

let test_set_info_var_CH (old_meta : int) (new_meta : int) =
  let var_id = Local.M.VarId ("old_meta", old_meta) in
  let old_typ_var = Choreo.M.Var (var_id, old_meta) in
  let new_typ_var = ChoreoAst.set_info_expr new_meta old_typ_var in
  assert_equal new_meta (ChoreoAst.get_info_expr new_typ_var)
;;

let test_set_info_locexpr_CH (old_meta1 : int) (old_meta2 : int) (new_meta : int) =
  let loc_id = Local.M.LocId ("old_m1", old_meta1) in
  let var_val = Local.M.Int (1, old_meta1) in
  let var_exp = Local.M.Val (var_val, old_meta2) in
  let old_typ_var = Choreo.M.LocExpr (loc_id, var_exp, old_meta2) in
  let new_typ_var = ChoreoAst.set_info_expr new_meta old_typ_var in
  assert_equal new_meta (ChoreoAst.get_info_expr new_typ_var)
;;

let test_set_info_send_CH (meta1 : int) (meta2 : int) (meta3 : int) (new_meta : int) =
  let loc_id1 = Local.M.LocId ("meta1", meta1) in
  let exp = Choreo.M.Unit 1 in
  let loc_id2 = Local.M.LocId ("meta2", meta2) in
  let old_typ_var = Choreo.M.Send (loc_id1, exp, loc_id2, meta3) in
  let new_typ_var = ChoreoAst.set_info_expr new_meta old_typ_var in
  assert_equal new_meta (ChoreoAst.get_info_expr new_typ_var)
;;

let test_set_info_sync_CH
      (meta1 : int)
      (meta2 : int)
      (meta3 : int)
      (meta4 : int)
      (new_meta : int)
  =
  let loc_id1 = Local.M.LocId ("meta1", meta1) in
  let label = Local.M.LabelId ("meta2", meta2) in
  let loc_id2 = Local.M.LocId ("meta3", meta3) in
  let exp = Choreo.M.Unit 1 in
  let old_typ_var = Choreo.M.Sync (loc_id1, label, loc_id2, exp, meta4) in
  let new_typ_var = ChoreoAst.set_info_expr new_meta old_typ_var in
  assert_equal new_meta (ChoreoAst.get_info_expr new_typ_var)
;;

let test_set_info_if_CH
      (meta1 : int)
      (meta2 : int)
      (meta3 : int)
      (meta4 : int)
      (new_meta : int)
  =
  let m1 = Local.M.VarId ("m1", meta1) in
  let e1 = Choreo.M.Var (m1, meta1) in
  let m2 = Local.M.VarId ("m2", meta2) in
  let e2 = Choreo.M.Var (m2, meta2) in
  let m3 = Local.M.VarId ("m3", meta3) in
  let e3 = Choreo.M.Var (m3, meta3) in
  let old_typ_var = Choreo.M.If (e1, e2, e3, meta4) in
  let new_typ_var = ChoreoAst.set_info_expr new_meta old_typ_var in
  assert_equal (ChoreoAst.get_info_expr new_typ_var) new_meta
;;

let test_set_info_let_CH (meta1 : int) (meta2 : int) (meta3 : int) (new_meta : int) =
  let pat = Choreo.M.Default meta1 in
  let typ = Choreo.M.TUnit meta1 in
  let dec1 = Choreo.M.Decl (pat, typ, meta1) in
  let stmts : int Choreo.M.stmt_block = [ dec1 ] in
  let m2 = Local.M.VarId ("m2", meta2) in
  let exp = Choreo.M.Var (m2, meta2) in
  let old_typ_var = Choreo.M.Let (stmts, exp, meta3) in
  let new_typ_var = ChoreoAst.set_info_expr new_meta old_typ_var in
  assert_equal new_meta (ChoreoAst.get_info_expr new_typ_var)
;;

let test_set_info_fundef_CH (meta1 : int) (meta2 : int) (new_meta : int) =
  let pat_list : 'a Choreo.M.pattern list =
    [ Choreo.M.Default meta1; Choreo.M.Default meta1 ]
  in
  let exp = Choreo.M.Unit 1 in
  let old_typ_var = Choreo.M.FunDef (pat_list, exp, meta2) in
  let new_typ_var = ChoreoAst.set_info_expr new_meta old_typ_var in
  assert_equal new_meta (ChoreoAst.get_info_expr new_typ_var)
;;

let test_set_info_funapp_CH (old_meta : int) (new_meta : int) =
  let exp1 = Choreo.M.Unit 1 in
  let exp2 = Choreo.M.Unit 0 in
  let old_typ_var = Choreo.M.FunApp (exp1, exp2, old_meta) in
  let new_typ_var = ChoreoAst.set_info_expr new_meta old_typ_var in
  assert_equal new_meta (ChoreoAst.get_info_expr new_typ_var)
;;

let test_set_info_pair_CH (meta1 : int) (meta2 : int) (new_meta : int) =
  let m1 = Local.M.VarId ("m1", meta1) in
  let m2 = Local.M.VarId ("m2", meta2) in
  let pat_pair1 = Choreo.M.Var (m1, meta1) in
  let pat_pair2 = Choreo.M.Var (m2, meta2) in
  let old_typ_var = Choreo.M.Pair (pat_pair1, pat_pair2, meta1) in
  let new_typ_var = ChoreoAst.set_info_expr new_meta old_typ_var in
  assert_equal new_meta (ChoreoAst.get_info_expr new_typ_var)
;;

let test_set_info_fst_CH (old_meta : int) (new_meta : int) =
  let exp = Choreo.M.Unit 1 in
  let old_typ_var = Choreo.M.Fst (exp, old_meta) in
  let new_typ_var = ChoreoAst.set_info_expr new_meta old_typ_var in
  assert_equal new_meta (ChoreoAst.get_info_expr new_typ_var)
;;

let test_set_info_snd_CH (old_meta : int) (new_meta : int) =
  let exp = Choreo.M.Unit 1 in
  let old_typ_var = Choreo.M.Snd (exp, old_meta) in
  let new_typ_var = ChoreoAst.set_info_expr new_meta old_typ_var in
  assert_equal new_meta (ChoreoAst.get_info_expr new_typ_var)
;;

let test_set_info_left_CH (old_meta : int) (new_meta : int) =
  let exp = Choreo.M.Unit 1 in
  let old_typ_var = Choreo.M.Left (exp, old_meta) in
  let new_typ_var = ChoreoAst.set_info_expr new_meta old_typ_var in
  assert_equal new_meta (ChoreoAst.get_info_expr new_typ_var)
;;

let test_set_info_right_CH (old_meta : int) (new_meta : int) =
  let exp = Choreo.M.Unit 1 in
  let old_typ_var = Choreo.M.Right (exp, old_meta) in
  let new_typ_var = ChoreoAst.set_info_expr new_meta old_typ_var in
  assert_equal new_meta (ChoreoAst.get_info_expr new_typ_var)
;;

let test_set_info_match_CH (meta1 : int) (meta2 : int) (new_meta : int) =
  let exp = Choreo.M.Unit 1 in
  let pat = Choreo.M.Default meta1 in
  let cases : (int Choreo.M.pattern * int Choreo.M.expr) list = [ pat, exp ] in
  let old_typ_var = Choreo.M.Match (exp, cases, meta2) in
  let new_typ_var = ChoreoAst.set_info_expr new_meta old_typ_var in
  assert_equal new_meta (ChoreoAst.get_info_expr new_typ_var)
;;

(*-----------------------------------------------------------*)
(* CH Get Info Exp Tests *)
(*-----------------------------------------------------------*)
let test_info_stmt_decl_CH (meta1 : int) (meta2 : int) (new_meta : int) =
  let pat = Choreo.M.Default meta1 in
  let typ = Choreo.M.TUnit meta1 in
  let old_typ_var = Choreo.M.Decl (pat, typ, meta2) in
  let new_typ_var = ChoreoAst.set_info_stmt new_meta old_typ_var in
  assert_equal new_meta (ChoreoAst.get_info_stmt new_typ_var)
;;

let test_info_stmt_assign_CH (meta1 : int) (new_meta : int) =
  let pats : 'a Choreo.M.pattern list =
    [ Choreo.M.Default meta1; Choreo.M.Default meta1 ]
  in
  let exp = Choreo.M.Unit 1 in
  let old_typ_var = Choreo.M.Assign (pats, exp, meta1) in
  let new_typ_var = ChoreoAst.set_info_stmt new_meta old_typ_var in
  assert_equal new_meta (ChoreoAst.get_info_stmt new_typ_var)
;;

let test_info_stmt_typedecl_CH (meta1 : int) (meta2 : int) (new_meta : int) =
  let typ = Choreo.M.TUnit meta1 in
  let typ_id = Local.M.TypId ("typ_id", meta1) in
  let old_typ_var = Choreo.M.TypeDecl (typ_id, typ, meta2) in
  let new_typ_var = ChoreoAst.set_info_stmt new_meta old_typ_var in
  assert_equal new_meta (ChoreoAst.get_info_stmt new_typ_var)
;;

let test_info_stmt_foreigndecl_CH (meta1 : int) (new_meta : int) =
  let typ_id = Local.M.VarId ("typ_id", meta1) in
  let typ = Choreo.M.TUnit meta1 in
  let old_typ_var = Choreo.M.ForeignDecl (typ_id, typ, "m1", meta1) in
  let new_typ_var = ChoreoAst.set_info_stmt new_meta old_typ_var in
  assert_equal new_meta (ChoreoAst.get_info_stmt new_typ_var)
;;

(*-----------------------------------------------------------*)
(* CH Test Suite *)
(*-----------------------------------------------------------*)
let choreo_suite =
  "Ast_core Choreo Tests"
  >::: [ "CH Get + Set Info Pattern Tests"
         >::: [ ("test_pattern_default_CH" >:: fun _ -> test_pattern_default_CH 1 2)
              ; ("test_pattern_variable_CH" >:: fun _ -> test_pattern_variable_CH 1 2)
              ; ("test_pattern_pair_CH" >:: fun _ -> test_pattern_pair_CH 1 2)
              ; ("test_pattern_locpat_CH" >:: fun _ -> test_pattern_locpat_CH 1 2)
              ; ("test_pattern_right_CH" >:: fun _ -> test_pattern_right_CH 1 2)
              ; ("test_pattern_left_CH" >:: fun _ -> test_pattern_left_CH 1 2)
              ]
       ; "CH Get Info Typ Tests"
         >::: [ ("test_get_info_typid_CH" >:: fun _ -> test_get_info_typid_CH 2)
              ; ("test_get_info_tunit_CH" >:: fun _ -> test_get_info_tunit_CH 1)
              ; ("test_get_info_tloc_CH" >:: fun _ -> test_get_info_tloc_CH 1)
              ; ("test_get_info_tvar_CH" >:: fun _ -> test_get_info_tvar_CH 1)
              ; ("test_get_info_tmap_CH" >:: fun _ -> test_get_info_tmap_CH 1 2)
              ; ("test_get_info_tprod_CH" >:: fun _ -> test_get_info_tprod_CH 1 2)
              ; ("test_get_info_tsum_CH" >:: fun _ -> test_get_info_tsum_CH 1 2)
              ]
       ; "CH Get Info Exp Tests"
         >::: [ ("test_get_info_unit_CH" >:: fun _ -> test_get_info_unit_CH 1)
              ; ("test_get_info_var_CH" >:: fun _ -> test_get_info_var_CH 1)
              ; ("test_get_info_locexpr_CH" >:: fun _ -> test_get_info_locexpr_CH 1 2)
              ; ("test_get_info_send_CH" >:: fun _ -> test_get_info_send_CH 1 2 3)
              ; ("test_get_info_sync_CH" >:: fun _ -> test_get_info_sync_CH 1 2 3 4)
              ; ("test_get_info_if_CH" >:: fun _ -> test_get_info_if_CH 1 2 3 4)
              ; ("test_get_info_let_CH" >:: fun _ -> test_get_info_let_CH 1 2 3)
              ; ("test_get_info_fundef_CH" >:: fun _ -> test_get_info_fundef_CH 1 2)
              ; ("test_get_info_funapp_CH" >:: fun _ -> test_get_info_funapp_CH 1)
              ; ("test_get_info_pair_CH" >:: fun _ -> test_get_info_pair_CH 1 2)
              ; ("test_get_info_fst_CH" >:: fun _ -> test_get_info_fst_CH 1)
              ; ("test_get_info_snd_CH" >:: fun _ -> test_get_info_snd_CH 1)
              ; ("test_get_info_left_CH" >:: fun _ -> test_get_info_left_CH 1)
              ; ("test_get_info_right_CH" >:: fun _ -> test_get_info_right_CH 1)
              ; ("test_get_info_match_CH" >:: fun _ -> test_get_info_match_CH 1 2)
              ]
       ; "CH Set Info Typ Tests"
         >::: [ ("test_set_info_typid_CH" >:: fun _ -> test_set_info_typid_CH 3 4)
              ; ("test_set_info_tunit_CH" >:: fun _ -> test_set_info_tunit_CH 3 4)
              ; ("test_set_info_tloc_CH" >:: fun _ -> test_set_info_tloc_CH 3 4)
              ; ("test_set_info_tvar_CH" >:: fun _ -> test_set_info_tvar_CH 3 4)
              ; ("test_set_info_tmap_CH" >:: fun _ -> test_set_info_tmap_CH 3 4 5)
              ; ("test_set_info_tprod_CH" >:: fun _ -> test_set_info_tprod_CH 3 4 5)
              ; ("test_set_info_tsum_CH" >:: fun _ -> test_set_info_tsum_CH 3 4 5)
              ]
       ; "CH Set Info Exp Tests"
         >::: [ ("test_set_info_unit_CH" >:: fun _ -> test_set_info_unit_CH 3 4)
              ; ("test_set_info_var_CH" >:: fun _ -> test_set_info_var_CH 3 4)
              ; ("test_set_info_locexpr_CH" >:: fun _ -> test_set_info_locexpr_CH 3 4 5)
              ; ("test_set_info_send_CH" >:: fun _ -> test_set_info_send_CH 3 4 5 6)
              ; ("test_set_info_sync_CH" >:: fun _ -> test_set_info_sync_CH 3 4 5 6 7)
              ; ("test_set_info_if_CH" >:: fun _ -> test_set_info_if_CH 3 4 5 6 7)
              ; ("test_set_info_let_CH" >:: fun _ -> test_set_info_let_CH 3 4 5 6)
              ; ("test_set_info_fundef_CH" >:: fun _ -> test_set_info_fundef_CH 3 4 5)
              ; ("test_set_info_funapp_CH" >:: fun _ -> test_set_info_funapp_CH 3 4)
              ; ("test_set_info_pair_CH" >:: fun _ -> test_set_info_pair_CH 3 4 5)
              ; ("test_set_info_fst_CH" >:: fun _ -> test_set_info_fst_CH 3 4)
              ; ("test_set_info_snd_CH" >:: fun _ -> test_set_info_snd_CH 3 4)
              ; ("test_set_info_left_CH" >:: fun _ -> test_set_info_left_CH 3 4)
              ; ("test_set_info_right_CH" >:: fun _ -> test_set_info_right_CH 3 4)
              ; ("test_set_info_match_CH" >:: fun _ -> test_set_info_match_CH 3 4 5)
              ]
       ; "CH Get + Set Info Stmt Tests"
         >::: [ ("test_info_stmt_decl_CH" >:: fun _ -> test_info_stmt_decl_CH 1 2 3)
              ; ("test_info_stmt_assign_CH" >:: fun _ -> test_info_stmt_assign_CH 1 2)
              ; ("test_info_typedecl_CH" >:: fun _ -> test_info_stmt_typedecl_CH 1 2 3)
              ; ("test_info_foreigndecl_CH" >:: fun _ -> test_info_stmt_foreigndecl_CH 1 2)
              ]
       ]
;;

let () =
  run_test_tt_main loc_suite;
  run_test_tt_main choreo_suite
;;
