open OUnit2
open Ppxlib
open Ast_core.Net.M
open Codegen.Emit_core
open Ast_core.Local.M
open Codegen.Msg_intf
module Net = Ast_core.Net.M
module Local = Ast_core.Local.M

let expr_to_string expr = Pprintast.string_of_expression expr
let loc = { !Ast_helper.default_loc with loc_ghost = true }

let contains_substring string substring =
  let s_length = String.length string in
  let sub_length = String.length substring in
  if sub_length = 0
  then true
  else if sub_length > s_length
  then false
  else (
    let rec check_subs i =
      if i > s_length - sub_length
      then false
      else if String.sub string i sub_length = substring
      then true
      else check_subs (i + 1)
    in
    check_subs 0)
;;

(*---------------------- Local expression tests ------------------------- *)

let local_unit _ =
  let expr = Unit () in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "()")
;;

let local_int _ =
  let expr = Val (Int (12, ()), ()) in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "12")
;;

let local_true _ =
  let expr = Val (Bool (true, ()), ()) in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "true")
;;

let local_false _ =
  let expr = Val (Bool (false, ()), ()) in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "false")
;;

let local_string _ =
  let expr = Val (String ("hello", ()), ()) in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "\"hello\"")
;;

let test_local_var _ =
  let expr = Var (VarId ("Alice", ()), ()) in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "Alice")
;;

let local_unop_not _ =
  let expr = UnOp (Not (), Val (Bool (true, ()), ()), ()) in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "not");
  assert_equal true (contains_substring result "true")
;;

let local_unop_neg _ =
  let expr = UnOp (Neg (), Val (Int (5, ()), ()), ()) in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "-");
  assert_equal true (contains_substring result "5")
;;

let local_binop_plus _ =
  let expr = BinOp (Val (Int (5, ()), ()), Plus (), Val (Int (3, ()), ()), ()) in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "5");
  assert_equal true (contains_substring result "+");
  assert_equal true (contains_substring result "3")
;;

let local_binop_minus _ =
  let expr = BinOp (Val (Int (10, ()), ()), Minus (), Val (Int (4, ()), ()), ()) in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "10");
  assert_equal true (contains_substring result "-");
  assert_equal true (contains_substring result "4")
;;

let local_binop_times _ =
  let expr = BinOp (Val (Int (5, ()), ()), Times (), Val (Int (7, ()), ()), ()) in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "5");
  assert_equal true (contains_substring result "*");
  assert_equal true (contains_substring result "7")
;;

let local_binop_and _ =
  let expr = BinOp (Val (Bool (true, ()), ()), And (), Val (Bool (false, ()), ()), ()) in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "true");
  assert_equal true (contains_substring result "&&");
  assert_equal true (contains_substring result "false")
;;

let local_binop_or _ =
  let expr = BinOp (Val (Bool (true, ()), ()), Or (), Val (Bool (false, ()), ()), ()) in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "true");
  assert_equal true (contains_substring result "||");
  assert_equal true (contains_substring result "false")
;;

let local_binop_eq _ =
  let expr = BinOp (Val (Int (15, ()), ()), Eq (), Val (Int (15, ()), ()), ()) in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "15");
  assert_equal true (contains_substring result "=");
  assert_equal true (contains_substring result "15")
;;

let local_binop_lt _ =
  let expr = BinOp (Val (Int (5, ()), ()), Lt (), Val (Int (10, ()), ()), ()) in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "5");
  assert_equal true (contains_substring result "<");
  assert_equal true (contains_substring result "10")
;;

let local_binop_div _ =
  let expr = BinOp (Val (Int (10, ()), ()), Div (), Val (Int (2, ()), ()), ()) in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "10");
  assert_equal true (contains_substring result "/");
  assert_equal true (contains_substring result "2")
;;

let local_binop_neq _ =
  let expr = BinOp (Val (Int (6, ()), ()), Neq (), Val (Int (9, ()), ()), ()) in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "6");
  assert_equal true (contains_substring result "<>");
  assert_equal true (contains_substring result "9")
;;

let local_binop_leq _ =
  let expr = BinOp (Val (Int (2, ()), ()), Leq (), Val (Int (12, ()), ()), ()) in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "2");
  assert_equal true (contains_substring result "<=");
  assert_equal true (contains_substring result "12")
;;

let local_binop_gt _ =
  let expr = BinOp (Val (Int (14, ()), ()), Gt (), Val (Int (4, ()), ()), ()) in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "14");
  assert_equal true (contains_substring result ">");
  assert_equal true (contains_substring result "4")
;;

let local_binop_geq _ =
  let expr = BinOp (Val (Int (15, ()), ()), Geq (), Val (Int (1, ()), ()), ()) in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "15");
  assert_equal true (contains_substring result ">=");
  assert_equal true (contains_substring result "1")
;;

let local_let_int _ =
  let expr =
    Let (VarId ("x", ()), TUnit (), Val (Int (2, ()), ()), Var (VarId ("x", ()), ()), ())
  in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "let rec x =");
  (*the let bindings are recursive let bindings!!*)
  assert_equal true (contains_substring result "2");
  assert_equal true (contains_substring result "in x")
;;

let local_let_nested _ =
  let expr =
    Let
      ( VarId ("x", ())
      , TUnit ()
      , Val (Int (1, ()), ())
      , Let
          ( VarId ("y", ())
          , TUnit ()
          , Val (Int (2, ()), ())
          , BinOp (Var (VarId ("x", ()), ()), Plus (), Var (VarId ("y", ()), ()), ())
          , () )
      , () )
  in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "let rec x = 1");
  assert_equal true (contains_substring result "let rec y = 2");
  assert_equal true (contains_substring result "x + y")
;;

let local_pair _ =
  let expr = Pair (Val (Int (1, ()), ()), Val (Bool (true, ()), ()), ()) in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "1");
  assert_equal true (contains_substring result ",");
  assert_equal true (contains_substring result "true")
;;

let local_fst _ =
  let expr = Fst (Pair (Val (Int (1, ()), ()), Val (Bool (true, ()), ()), ()), ()) in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "fst");
  assert_equal true (contains_substring result "1");
  assert_equal true (contains_substring result "true")
;;

let local_snd _ =
  let expr = Snd (Pair (Val (Int (1, ()), ()), Val (Bool (true, ()), ()), ()), ()) in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "snd");
  assert_equal true (contains_substring result "1");
  assert_equal true (contains_substring result "true")
;;

let local_left _ =
  let expr = Left (Val (Bool (true, ()), ()), ()) in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "Left");
  assert_equal true (contains_substring result "true")
;;

let local_right _ =
  let expr = Right (Val (Bool (false, ()), ()), ()) in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "Right");
  assert_equal true (contains_substring result "false")
;;

let local_match_int _ =
  let expr =
    Match
      ( Left (Val (Int (123, ()), ()), ())
      , [ Left (Var (VarId ("x", ()), ()), ()), Var (VarId ("x", ()), ())
        ; Right (Var (VarId ("y", ()), ()), ()), Val (Bool (false, ()), ())
        ]
      , () )
  in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "match");
  assert_equal true (contains_substring result "Left");
  assert_equal true (contains_substring result "Right");
  assert_equal true (contains_substring result "123");
  assert_equal true (contains_substring result "x");
  assert_equal true (contains_substring result "y");
  assert_equal true (contains_substring result "false")
;;

let local_match_pair _ =
  let expr =
    Match
      ( Pair (Val (Int (123, ()), ()), Val (Bool (true, ()), ()), ())
      , [ ( Pair (Var (VarId ("Alice", ()), ()), Var (VarId ("Bob", ()), ()), ())
          , Var (VarId ("Alice", ()), ()) )
        ]
      , () )
  in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "match");
  assert_equal true (contains_substring result "123");
  assert_equal true (contains_substring result "true");
  assert_equal true (contains_substring result "Alice");
  assert_equal true (contains_substring result "Bob")
;;

(*---------------------------- Local pattern tests ------------------------------ *)
let local_pat_default _ =
  let expr = Match (Val (Int (222, ()), ()), [ Default (), Unit () ], ()) in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "match");
  assert_equal true (contains_substring result "_");
  assert_equal true (contains_substring result "()")
;;

let local_pat_int _ =
  let expr = Match (Val (Int (7, ()), ()), [ Val (Int (7, ()), ()), Unit () ], ()) in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "match");
  assert_equal true (contains_substring result "7");
  assert_equal true (contains_substring result "()")
;;

let local_pat_string _ =
  let expr =
    Match
      ( Val (String ("test", ()), ())
      , [ Val (String ("test", ()), ()), Val (Int (99, ()), ()) ]
      , () )
  in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "match");
  assert_equal true (contains_substring result "with");
  assert_equal true (contains_substring result "\"test\"");
  assert_equal true (contains_substring result "99")
;;

let local_pat_bool _ =
  let expr =
    Match
      ( Val (Bool (true, ()), ())
      , [ Val (Bool (true, ()), ()), Val (Int (123, ()), ()) ]
      , () )
  in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "match");
  assert_equal true (contains_substring result "true");
  assert_equal true (contains_substring result "123")
;;

let local_pat_var _ =
  let expr =
    Match
      ( Val (Int (321, ()), ())
      , [ ( Var (VarId ("x", ()), ())
          , BinOp (Var (VarId ("x", ()), ()), Plus (), Val (Int (1, ()), ()), ()) )
        ]
      , () )
  in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "match");
  assert_equal true (contains_substring result "321");
  assert_equal true (contains_substring result "x");
  assert_equal true (contains_substring result "x + 1")
;;

let local_pat_pair _ =
  let expr =
    Match
      ( Pair (Val (Int (12, ()), ()), Val (Int (23, ()), ()), ())
      , [ ( Pair (Var (VarId ("x", ()), ()), Var (VarId ("y", ()), ()), ())
          , BinOp (Var (VarId ("x", ()), ()), Plus (), Var (VarId ("y", ()), ()), ()) )
        ]
      , () )
  in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "match");
  assert_equal true (contains_substring result "12");
  assert_equal true (contains_substring result "23");
  assert_equal true (contains_substring result "x");
  assert_equal true (contains_substring result "y");
  assert_equal true (contains_substring result "x + y")
;;

let local_pat_left _ =
  let expr =
    Match
      ( Left (Val (Int (2, ()), ()), ())
      , [ ( Left (Var (VarId ("x", ()), ()), ())
          , BinOp (Var (VarId ("x", ()), ()), Times (), Val (Int (715, ()), ()), ()) )
        ; Right (Var (VarId ("y", ()), ()), ()), Var (VarId ("y", ()), ())
        ]
      , () )
  in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "match");
  assert_equal true (contains_substring result "Left 2");
  assert_equal true (contains_substring result "Right");
  assert_equal true (contains_substring result "x");
  assert_equal true (contains_substring result "x * 715");
  assert_equal true (contains_substring result "y")
;;

let local_pat_right _ =
  let expr =
    Match
      ( Right (Val (Int (3, ()), ()), ())
      , [ Left (Var (VarId ("x", ()), ()), ()), Var (VarId ("x", ()), ())
        ; ( Right (Var (VarId ("y", ()), ()), ())
          , BinOp (Var (VarId ("y", ()), ()), Plus (), Val (Int (55, ()), ()), ()) )
        ]
      , () )
  in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "match");
  assert_equal true (contains_substring result "Left");
  assert_equal true (contains_substring result "Right 3");
  assert_equal true (contains_substring result "x");
  assert_equal true (contains_substring result "y");
  assert_equal true (contains_substring result "y + 55")
;;

let local_pat_nested _ =
  let expr =
    Match
      ( Pair (Left (Val (Int (1, ()), ()), ()), Right (Val (Int (2, ()), ()), ()), ())
      , [ ( Pair
              ( Left (Var (VarId ("x", ()), ()), ())
              , Right (Var (VarId ("y", ()), ()), ())
              , () )
          , BinOp (Var (VarId ("x", ()), ()), Plus (), Var (VarId ("y", ()), ()), ()) )
        ]
      , () )
  in
  let result = expr_to_string (emit_local_pexp expr) in
  assert_equal true (contains_substring result "match");
  assert_equal true (contains_substring result "Left 1");
  assert_equal true (contains_substring result "Right 2");
  assert_equal true (contains_substring result "x");
  assert_equal true (contains_substring result "y");
  assert_equal true (contains_substring result "x + y")
;;

(*------------------------ Network expression tests ------------------------- *)

(*hleper function for net expr testing*)
(*used Msg_http_intf as it creates string output so it's easier to use for testing*)
let net_expr_to_string ~node_id expr =
  expr_to_string (emit_net_pexp ~self_id:node_id (module Msg_http_intf) expr)
;;

let net_unit _ =
  let expr = Net.Unit () in
  let result = net_expr_to_string ~node_id:"testing" expr in
  assert_equal true (contains_substring result "()")
;;

let net_var _ =
  let expr = Net.Var (VarId ("Alice", ()), ()) in
  let result = net_expr_to_string ~node_id:"testing" expr in
  assert_equal true (contains_substring result "Alice")
;;

let net_ret _ =
  let expr = Net.Ret (Local.Val (Local.Int (123, ()), ()), ()) in
  let result = net_expr_to_string ~node_id:"testing" expr in
  assert_equal true (contains_substring result "123")
;;

let net_if _ =
  let expr =
    Net.If (Ret (Local.Val (Local.Bool (true, ()), ()), ()), Unit (), Unit (), ())
  in
  let result = net_expr_to_string ~node_id:"testing" expr in
  assert_equal true (contains_substring result "if");
  assert_equal true (contains_substring result "true");
  assert_equal true (contains_substring result "()");
  assert_equal true (contains_substring result "then");
  assert_equal true (contains_substring result "else")
;;

let net_let _ =
  let stmt =
    Assign
      ( [ Local.Var (VarId ("x", ()), ()) ]
      , Ret (Local.Val (Local.Int (77, ()), ()), ())
      , () )
  in
  let expr = Net.Let ([ stmt ], Var (VarId ("x", ()), ()), ()) in
  let result = net_expr_to_string ~node_id:"testing" expr in
  (*let is recursive here as well*)
  assert_equal true (contains_substring result "let rec");
  assert_equal true (contains_substring result "x");
  assert_equal true (contains_substring result "77")
;;

let net_fundef _ =
  let expr =
    Net.FunDef
      ( [ Local.Var (VarId ("x", ()), ()) ]
      , Ret (Local.Val (Local.Int (3, ()), ()), ())
      , () )
  in
  let result = net_expr_to_string ~node_id:"testing" expr in
  assert_equal true (contains_substring result "fun x");
  assert_equal true (contains_substring result "3")
;;

let net_funapp _ =
  let expr =
    Net.FunApp
      (Var (VarId ("lambda", ()), ()), Ret (Local.Val (Local.Int (321, ()), ()), ()), ())
  in
  let result = net_expr_to_string ~node_id:"testing" expr in
  assert_equal true (contains_substring result "lambda");
  assert_equal true (contains_substring result "321")
;;

let net_pair _ =
  let expr =
    Net.Pair
      ( Net.Ret (Local.Val (Local.Int (22, ()), ()), ())
      , Net.Ret (Local.Val (Local.Int (33, ()), ()), ())
      , () )
  in
  let result = net_expr_to_string ~node_id:"testing" expr in
  assert_equal true (contains_substring result "22,");
  assert_equal true (contains_substring result "33")
;;

let net_fst _ =
  let expr =
    Net.Fst (Pair (Ret (Local.Val (Local.Int (5, ()), ()), ()), Unit (), ()), ())
  in
  let result = net_expr_to_string ~node_id:"testing" expr in
  assert_equal true (contains_substring result "fst");
  assert_equal true (contains_substring result "5,");
  assert_equal true (contains_substring result "()")
;;

let net_snd _ =
  let expr =
    Net.Snd (Pair (Unit (), Ret (Local.Val (Local.Int (6, ()), ()), ()), ()), ())
  in
  let result = net_expr_to_string ~node_id:"testing" expr in
  assert_equal true (contains_substring result "snd");
  assert_equal true (contains_substring result "(),");
  assert_equal true (contains_substring result "6")
;;

let net_left _ =
  let expr = Net.Left (Ret (Local.Val (Local.Int (1, ()), ()), ()), ()) in
  let result = net_expr_to_string ~node_id:"testing" expr in
  assert_equal true (contains_substring result "Either.Left");
  assert_equal true (contains_substring result "1")
;;

let net_right _ =
  let expr = Net.Right (Ret (Local.Val (Local.Int (2, ()), ()), ()), ()) in
  let result = net_expr_to_string ~node_id:"testing" expr in
  assert_equal true (contains_substring result "Either.Right");
  assert_equal true (contains_substring result "2")
;;

let net_match _ =
  let expr =
    Net.Match
      ( Ret (Var (VarId ("x", ()), ()), ())
      , [ Local.Default (), Ret (Local.Val (Local.Bool (true, ()), ()), ()) ]
      , () )
  in
  let result = net_expr_to_string ~node_id:"testing" expr in
  assert_equal true (contains_substring result "match");
  assert_equal true (contains_substring result "x");
  assert_equal true (contains_substring result "_");
  assert_equal true (contains_substring result "true")
;;

let net_send _ =
  let expr =
    Net.Send
      (Ret (Local.Val (Local.String ("hello", ()), ()), ()), LocId ("Alice", ()), ())
  in
  let result = net_expr_to_string ~node_id:"testing" expr in
  assert_equal true (contains_substring result "Lwt_main.run");
  assert_equal true (contains_substring result "Send_receive.send_message");
  assert_equal true (contains_substring result "location");
  assert_equal true (contains_substring result "\"Alice\"");
  assert_equal true (contains_substring result "\"hello\"")
;;

let net_recv _ =
  let expr = Net.Recv (LocId ("Bob", ()), ()) in
  let result = net_expr_to_string expr ~node_id:"Bob" in
  assert_equal true (contains_substring result "Lwt_main.run");
  assert_equal true (contains_substring result "Send_receive.receive_message");
  assert_equal true (contains_substring result "\"Bob\"");
  assert_equal true (contains_substring result "location");
  assert_equal true (contains_substring result "Receive error:")
;;

let net_choose_for _ =
  let expr =
    Net.ChooseFor (LabelId ("option1", ()), LocId ("Charlie", ()), Unit (), ())
  in
  let result = net_expr_to_string ~node_id:"testing" expr in
  assert_equal true (contains_substring result "Lwt_main.run");
  assert_equal true (contains_substring result "Send_receive.send_message");
  assert_equal true (contains_substring result "\"Charlie\"");
  assert_equal true (contains_substring result "\"option1\"")
;;

let net_allow_choice _ =
  let expr =
    Net.AllowChoice
      ( LocId ("Alice", ())
      , [ LabelId ("option1", ()), Unit (); LabelId ("option2", ()), Unit () ]
      , () )
  in
  let result = net_expr_to_string ~node_id:"Alice" expr in
  assert_equal true (contains_substring result "Lwt_main.run");
  assert_equal true (contains_substring result "Send_receive.receive_message");
  assert_equal true (contains_substring result "\"Alice\"");
  assert_equal true (contains_substring result "\"option1\"");
  assert_equal true (contains_substring result "\"option2\"");
  assert_equal true (contains_substring result "Receive error:")
;;

(*-----------------------------Network binding tests-----------------------------*)
let net_binding_to_string ~node_id stmt =
  let binding = emit_net_binding ~self_id:node_id (module Msg_http_intf) stmt in
  expr_to_string binding.pvb_expr
;;

(*helper function that tests both the pattern (lhs) and expr (rhs) of a net binding
  the function is written this way as ppxlib doesn't have a straightforward pattern-to-string function*)
let net_binding_test ~node_id stmt pattern_test expr_test =
  let binding = emit_net_binding ~self_id:node_id (module Msg_http_intf) stmt in
  let pattern_result = pattern_test binding.pvb_pat in
  let expr_result = contains_substring (expr_to_string binding.pvb_expr) expr_test in
  pattern_result && expr_result
;;

let net_binding_empty_error _ =
  let stmt = Net.Assign ([], Unit (), ()) in
  assert_raises (Failure "Error: Empty assignment") (fun () ->
    net_binding_to_string ~node_id:"testing" stmt |> ignore)
;;

let net_binding_var _ =
  let stmt =
    Net.Assign
      ( [ Local.Var (VarId ("x", ()), ()) ]
      , Ret (Local.Val (Local.Int (123, ()), ()), ())
      , () )
  in
  (*manually checking the pattern description to verify the correct var name*)
  let pattern_test pat =
    match pat.ppat_desc with
    | Ppat_var { txt = var_name; _ } -> var_name = "x"
    | _ -> false
  in
  assert_equal true (net_binding_test ~node_id:"testing" stmt pattern_test "123")
;;

let net_binding_fun _ =
  let stmt =
    Net.Assign
      ( [ Local.Var (VarId ("f", ()), ()); Local.Var (VarId ("x", ()), ()) ]
      , Ret (Local.Var (Local.VarId ("y", ()), ()), ())
      , () )
  in
  let pattern_test pat =
    match pat.ppat_desc with
    | Ppat_var { txt = var_name; _ } -> var_name = "f"
    | _ -> false
  in
  assert_equal true (net_binding_test ~node_id:"testing" stmt pattern_test "fun x -> y")
;;

let net_binding_default _ =
  let stmt =
    Net.Assign ([ Local.Default () ], Ret (Local.Val (Local.Int (715, ()), ()), ()), ())
  in
  let pattern_test pat =
    match pat.ppat_desc with
    | Ppat_var { txt = var_name; _ } -> String.sub var_name 0 6 = "_unit_"
    | _ -> false
  in
  assert_equal true (net_binding_test ~node_id:"testing" stmt pattern_test "715")
;;

let net_binding_main_error _ =
  let stmt =
    Net.Assign
      ( [ Local.Var (VarId ("main", ()), ()) ]
      , Ret (Local.Val (Local.Int (1, ()), ()), ())
      , () )
  in
  assert_raises
    (Main_expr (Ast_builder.Default.eint ~loc 1))
    (fun () ->
      let _ = emit_net_binding ~self_id:"testing" (module Msg_http_intf) stmt in
      ())
;;

let net_binding_foreign_decl _ =
  let stmt = Net.ForeignDecl (VarId ("pir_func", ()), TUnit (), "foreign_function", ()) in
  let pattern_test pat =
    match pat.ppat_desc with
    | Ppat_var { txt = var_name; _ } -> var_name = "pir_func"
    | _ -> false
  in
  assert_equal
    true
    (net_binding_test
       ~node_id:"testing"
       stmt
       pattern_test
       "fun arg -> Foreign_function.foreign_function arg")
;;

(*need to test with something that isn't Assign or ForeignDecl*)
let net_binding_other _ =
  let stmt = Net.TypeDecl (TypId ("mytype", ()), TUnit (), ()) in
  let pattern_test pat =
    match pat.ppat_desc with
    | Ppat_var { txt = var_name; _ } -> var_name = "_unit"
    | _ -> false
  in
  assert_equal true (net_binding_test ~node_id:"testing" stmt pattern_test "()")
;;

(*----------------------------FFI test cases--------------------------------------*)

let test_basic_external_function _ =
  let binding = emit_foreign_decl "my_func" (TUnit ()) "simple_function" in
  let result = expr_to_string binding.pvb_expr in
  Printf.printf "\nExpected: fun arg -> Simple_function.simple_function arg\n";
  Printf.printf "Got: %s\n" (String.trim result);
  assert_equal
    ~msg:"Basic external function should create a simple wrapper"
    "fun arg -> Simple_function.simple_function arg"
    (String.trim result)
;;

let test_module_path_external_function _ =
  let binding = emit_foreign_decl "custom_fn" (TUnit ()) "@utils/math:calculate" in
  let result = expr_to_string binding.pvb_expr in
  Printf.printf "\nExpected: fun arg -> Math.calculate arg\n";
  Printf.printf "Got: %s\n" (String.trim result);
  assert_equal
    ~msg:"Module path external function should create proper module access"
    "fun arg -> Math.calculate arg"
    (String.trim result)
;;

let test_nested_module_path_external_function _ =
  let binding = emit_foreign_decl "deep_fn" (TUnit ()) "@utils/math/deep:calculate" in
  let result = expr_to_string binding.pvb_expr in
  Printf.printf "\nExpected: fun arg -> Deep.calculate arg\n";
  Printf.printf "Got: %s\n" (String.trim result);
  assert_equal
    ~msg:"Nested module path external function should create proper module access"
    "fun arg -> Deep.calculate arg"
    (String.trim result)
;;

let test_invalid_external_format _ =
  assert_raises
    (Failure "Invalid external function format. Expected @file:function")
    (fun () -> emit_foreign_decl "bad_fn" (TUnit ()) "@invalid_format" |> ignore)
;;

let test_empty_module_path _ =
  assert_raises
    (Failure "Invalid external function format. Expected @file:function")
    (fun () -> emit_foreign_decl "bad_fn" (TUnit ()) "@:function" |> ignore)
;;

let test_empty_function_name _ =
  assert_raises
    (Failure "Invalid external function format. Expected @file:function")
    (fun () -> emit_foreign_decl "bad_fn" (TUnit ()) "@module:" |> ignore)
;;

(*----------------------------- test suites ------------------------------------*)
let local_expr_suite =
  "Local expression tests"
  >::: [ "Unit" >:: local_unit
       ; "Int" >:: local_int
       ; "Bool (true)" >:: local_true
       ; "Bool (false)" >:: local_false
       ; "String" >:: local_string
       ; "Variable" >:: test_local_var
       ; "UnOp (not)" >:: local_unop_not
       ; "UnOp (neg)" >:: local_unop_neg
       ; "BinOp (plus)" >:: local_binop_plus
       ; "BinOp (minus)" >:: local_binop_minus
       ; "BinOp (times)" >:: local_binop_times
       ; "BinOp (div)" >:: local_binop_div
       ; "BinOp (and)" >:: local_binop_and
       ; "BinOp (or)" >:: local_binop_or
       ; "BinOp (eq)" >:: local_binop_eq
       ; "BinOp (neq)" >:: local_binop_neq
       ; "BinOp (lt)" >:: local_binop_lt
       ; "BinOp (leq)" >:: local_binop_leq
       ; "BinOp (gt)" >:: local_binop_gt
       ; "BinOp (geq)" >:: local_binop_geq
       ; "Let (int)" >:: local_let_int
       ; "Let (nested)" >:: local_let_nested
       ; "Pair" >:: local_pair
       ; "Fst" >:: local_fst
       ; "Snd" >:: local_snd
       ; "Left" >:: local_left
       ; "Right" >:: local_right
       ; "Match (int)" >:: local_match_int
       ; "Match (pair)" >:: local_match_pair
       ]
;;

let local_pat_suite =
  "Local pattern tests"
  >::: [ "Default pat" >:: local_pat_default
       ; "Int val pat" >:: local_pat_int
       ; "String val pat" >:: local_pat_string
       ; "Bool val pat" >:: local_pat_bool
       ; "Var pat" >:: local_pat_var
       ; "Pair pat" >:: local_pat_pair
       ; "Left pat" >:: local_pat_left
       ; "Right pat" >:: local_pat_right
       ; "Nested pat" >:: local_pat_nested
       ]
;;

let net_expr_suite =
  "Network expression tests"
  >::: [ "Unit" >:: net_unit
       ; "Variable" >:: net_var
       ; "Ret" >:: net_ret
       ; "If" >:: net_if
       ; "Let" >:: net_let
       ; "FunDef" >:: net_fundef
       ; "FunApp" >:: net_funapp
       ; "Pair" >:: net_pair
       ; "Fst" >:: net_fst
       ; "Snd" >:: net_snd
       ; "Left" >:: net_left
       ; "Right" >:: net_right
       ; "Match" >:: net_match
       ; "Send" >:: net_send
       ; "Recv" >:: net_recv
       ; "ChooseFor" >:: net_choose_for
       ; "AllowChoice" >:: net_allow_choice
       ]
;;

let net_binding_suite =
  "Network binding tests"
  >::: [ "Empty assignment error" >:: net_binding_empty_error
       ; "Var binding" >:: net_binding_var
       ; "FunDef" >:: net_binding_fun
       ; "Default binding" >:: net_binding_default
       ; "Main as var error" >:: net_binding_main_error
       ; "Foreign declaration" >:: net_binding_foreign_decl
       ; "Other binding" >:: net_binding_other
       ]
;;

let ffi_suite =
  "Foreign function tests"
  >::: [ "test_basic_external_function" >:: test_basic_external_function
       ; "test_module_path_external_function" >:: test_module_path_external_function
       ; "test_nested_module_path_external_function"
         >:: test_nested_module_path_external_function
       ; "test_invalid_external_format" >:: test_invalid_external_format
       ; "test_empty_module_path" >:: test_empty_module_path
       ; "test_empty_function_name" >:: test_empty_function_name
       ]
;;

let all_suites =
  "Emit_Core Tests"
  >::: [ local_expr_suite; local_pat_suite; net_expr_suite; net_binding_suite; ffi_suite ]
;;

let () = run_test_tt_main all_suites
