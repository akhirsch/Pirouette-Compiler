open OUnit2
module Local = Ast_core.Local.M
module Choreo = Ast_core.Choreo.M
module Net = Ast_core.Net.M

(*NOTE; testing here is limited only to changes made in sean/netgen-refactor.*)

let _m = Obj.magic () (* dummy metainfo to make the types work; taken from netgen *)

(*
  These functions exists to help expose the behavior of "merge_net_stmt" 
  and "merge_net_expr". The cases one wants to test can simply be passed in
  and the structure will ensure that those functions in Netgen are run.
  
  This may seem a bit conveluted, and frankly it is, but with Netgen only
  having epp_choreo exposed, this is the best way to target a unit test.

  The purpose of the "merge_net_stmt," as far as I can tell, is to help cull
  redundant code. If two net statements are found to be the same, it will
  simply return one of them. This is why we have equal and not equal tests;
  when they're not equal, they should be returned as-in.

  ChooseFor is left untested, as all input to "merge_net_stmt" is a return
  value from "epp_choreo_stmt," which cannot return a ChooseFor statement.
  Thus, I don't believe this code will ever be run.
*)
let make_merge_test_equal (e1_in : 'a Choreo.expr) (e2_in : 'a Choreo.expr)
    (e_out : 'a Net.expr) =
  let actual_input =
    [
      Choreo.Assign
        ([ Choreo.Default _m ], Choreo.If (Choreo.Unit _m, e1_in, e2_in, _m), _m);
    ]
  in
  let expected = [ Net.Assign ([ Local.Default _m ], e_out, _m) ] in
  (actual_input, expected)

let make_merge_test_not_equal (e1_in : 'a Choreo.expr) (e2_in : 'a Choreo.expr)
    (e1_out : 'a Net.expr) (e2_out : 'a Net.expr) =
  let actual_input =
    [
      Choreo.Assign
        ([ Choreo.Default _m ], Choreo.If (Choreo.Unit _m, e1_in, e2_in, _m), _m);
    ]
  in
  let expected =
    [
      Net.Assign
        ([ Local.Default _m ], Net.If (Net.Unit _m, e1_out, e2_out, _m), _m);
    ]
  in
  (actual_input, expected)

let epp_choreo_expr_tests =
  "epp choreo exps tests"
  >::: [
         ( "merge net fst equal" >:: fun _ ->
           let in_stmt = Choreo.Fst (Choreo.Unit _m, _m) in
           let out_stmt = Net.Fst (Net.Unit _m, _m) in
           let input, expected =
             make_merge_test_equal in_stmt in_stmt out_stmt
           in
           let result = Netgen.epp_choreo_to_net input "" in
           assert_equal result expected );
         ( "merge net fst not equal" >:: fun _ ->
           let in_stmt1 = Choreo.Fst (Choreo.Unit _m, _m) in
           let in_stmt2 =
             Choreo.Fst (Choreo.Var (Local.VarId ("foo", _m), _m), _m)
           in
           let out_stmt1 = Net.Fst (Net.Unit _m, _m) in
           let out_stmt2 =
             Net.Fst (Net.Var (Local.VarId ("foo", _m), _m), _m)
           in
           let input, expected =
             make_merge_test_not_equal in_stmt1 in_stmt2 out_stmt1 out_stmt2
           in
           let result = Netgen.epp_choreo_to_net input "" in
           assert_equal result expected );
         ( "merge net Snd equal" >:: fun _ ->
           let in_stmt = Choreo.Snd (Choreo.Unit _m, _m) in
           let out_stmt = Net.Snd (Net.Unit _m, _m) in
           let input, expected =
             make_merge_test_equal in_stmt in_stmt out_stmt
           in
           let result = Netgen.epp_choreo_to_net input "" in
           assert_equal result expected );
         ( "merge net Snd not equal" >:: fun _ ->
           let in_stmt1 = Choreo.Snd (Choreo.Unit _m, _m) in
           let in_stmt2 =
             Choreo.Snd (Choreo.Var (Local.VarId ("foo", _m), _m), _m)
           in
           let out_stmt1 = Net.Snd (Net.Unit _m, _m) in
           let out_stmt2 =
             Net.Snd (Net.Var (Local.VarId ("foo", _m), _m), _m)
           in
           let input, expected =
             make_merge_test_not_equal in_stmt1 in_stmt2 out_stmt1 out_stmt2
           in
           let result = Netgen.epp_choreo_to_net input "" in
           assert_equal result expected );
         ( "merge net Left equal" >:: fun _ ->
           let in_stmt = Choreo.Left (Choreo.Unit _m, _m) in
           let out_stmt = Net.Left (Net.Unit _m, _m) in
           let input, expected =
             make_merge_test_equal in_stmt in_stmt out_stmt
           in
           let result = Netgen.epp_choreo_to_net input "" in
           assert_equal result expected );
         ( "merge net Left not equal" >:: fun _ ->
           let in_stmt1 = Choreo.Left (Choreo.Unit _m, _m) in
           let in_stmt2 =
             Choreo.Left (Choreo.Var (Local.VarId ("foo", _m), _m), _m)
           in
           let out_stmt1 = Net.Left (Net.Unit _m, _m) in
           let out_stmt2 =
             Net.Left (Net.Var (Local.VarId ("foo", _m), _m), _m)
           in
           let input, expected =
             make_merge_test_not_equal in_stmt1 in_stmt2 out_stmt1 out_stmt2
           in
           let result = Netgen.epp_choreo_to_net input "" in
           assert_equal result expected );
         ( "merge net Right equal" >:: fun _ ->
           let in_stmt = Choreo.Right (Choreo.Unit _m, _m) in
           let out_stmt = Net.Right (Net.Unit _m, _m) in
           let input, expected =
             make_merge_test_equal in_stmt in_stmt out_stmt
           in
           let result = Netgen.epp_choreo_to_net input "" in
           assert_equal result expected );
         ( "merge net Right not equal" >:: fun _ ->
           let in_stmt1 = Choreo.Right (Choreo.Unit _m, _m) in
           let in_stmt2 =
             Choreo.Right (Choreo.Var (Local.VarId ("foo", _m), _m), _m)
           in
           let out_stmt1 = Net.Right (Net.Unit _m, _m) in
           let out_stmt2 =
             Net.Right (Net.Var (Local.VarId ("foo", _m), _m), _m)
           in
           let input, expected =
             make_merge_test_not_equal in_stmt1 in_stmt2 out_stmt1 out_stmt2
           in
           let result = Netgen.epp_choreo_to_net input "" in
           assert_equal result expected );
         ( "merge net Send equal" >:: fun _ ->
           let in_stmt =
             Choreo.Send
               ( Local.LocId ("Alice", _m),
                 Choreo.Unit _m,
                 Local.LocId ("Bob", _m),
                 _m )
           in
           let out_stmt = Net.Send (Net.Unit _m, Local.LocId ("Bob", _m), _m) in
           let input, expected =
             make_merge_test_equal in_stmt in_stmt out_stmt
           in
           let result = Netgen.epp_choreo_to_net input "Alice" in
           assert_equal result expected );
         ( "merge net Send not equal" >:: fun _ ->
           let in_stmt1 =
             Choreo.Send
               ( Local.LocId ("Alice", _m),
                 Choreo.Unit _m,
                 Local.LocId ("Bob", _m),
                 _m )
           in
           let in_stmt2 =
             Choreo.Send
               ( Local.LocId ("Alice", _m),
                 Choreo.Unit _m,
                 Local.LocId ("Charlie", _m),
                 _m )
           in
           let out_stmt1 =
             Net.Send (Net.Unit _m, Local.LocId ("Bob", _m), _m)
           in
           let out_stmt2 =
             Net.Send (Net.Unit _m, Local.LocId ("Charlie", _m), _m)
           in
           let input, expected =
             make_merge_test_not_equal in_stmt1 in_stmt2 out_stmt1 out_stmt2
           in
           let result = Netgen.epp_choreo_to_net input "Alice" in
           assert_equal result expected );
         ( "merge net Let equal" >:: fun _ ->
           let in_stmt =
             Choreo.Let
               ( [
                   Choreo.Decl
                     ( Default _m,
                       Choreo.TFun (Choreo.TUnit _m, Choreo.TUnit _m, _m),
                       _m );
                 ],
                 Choreo.Unit _m,
                 _m )
           in
           let out_stmt =
             Net.Let
               ( [
                   Net.Decl
                     (Default _m, Net.TFun (Net.TUnit _m, Net.TUnit _m, _m), _m);
                 ],
                 Net.Unit _m,
                 _m )
           in
           let input, expected =
             make_merge_test_equal in_stmt in_stmt out_stmt
           in
           let result = Netgen.epp_choreo_to_net input "Alice" in
           assert_equal result expected );
         ( "merge net Let not equal" >:: fun _ ->
           let in_stmt1 =
             Choreo.Let
               ( [
                   Choreo.Decl
                     ( Default _m,
                       Choreo.TFun (Choreo.TUnit _m, Choreo.TUnit _m, _m),
                       _m );
                 ],
                 Choreo.Unit _m,
                 _m )
           in
           let in_stmt2 =
             Choreo.Let
               ( [
                   Choreo.Decl
                     ( Default _m,
                       Choreo.TFun
                         ( Choreo.TUnit _m,
                           Choreo.TFun (Choreo.TUnit _m, Choreo.TUnit _m, _m),
                           _m ),
                       _m );
                 ],
                 Choreo.Unit _m,
                 _m )
           in
           let out_stmt1 =
             Net.Let
               ( [
                   Net.Decl
                     (Default _m, Net.TFun (Net.TUnit _m, Net.TUnit _m, _m), _m);
                 ],
                 Net.Unit _m,
                 _m )
           in
           let out_stmt2 =
             Net.Let
               ( [
                   Net.Decl
                     ( Default _m,
                       Net.TFun
                         ( Net.TUnit _m,
                           Net.TFun (Net.TUnit _m, Net.TUnit _m, _m),
                           _m ),
                       _m );
                 ],
                 Net.Unit _m,
                 _m )
           in
           let input, expected =
             make_merge_test_not_equal in_stmt1 in_stmt2 out_stmt1 out_stmt2
           in
           let result = Netgen.epp_choreo_to_net input "Alice" in
           assert_equal result expected );
         ( "merge net stmt Assign equal" >:: fun _ ->
           let in_stmt =
             Choreo.Let
               ( [
                   Choreo.Assign
                     ([ Default _m ], Choreo.Fst (Choreo.Unit _m, _m), _m);
                 ],
                 Choreo.Unit _m,
                 _m )
           in
           let out_stmt =
             Net.Let
               ( [ Net.Assign ([ Default _m ], Net.Fst (Net.Unit _m, _m), _m) ],
                 Net.Unit _m,
                 _m )
           in
           let input, expected =
             make_merge_test_equal in_stmt in_stmt out_stmt
           in
           let result = Netgen.epp_choreo_to_net input "Alice" in
           assert_equal result expected );
         ( "merge net stmt Assign not equal" >:: fun _ ->
           let in_stmt1 =
             Choreo.Let
               ( [
                   Choreo.Assign
                     ([ Default _m ], Choreo.Fst (Choreo.Unit _m, _m), _m);
                 ],
                 Choreo.Unit _m,
                 _m )
           in
           let in_stmt2 =
             Choreo.Let
               ( [
                   Choreo.Assign
                     ([ Default _m ], Choreo.Snd (Choreo.Unit _m, _m), _m);
                 ],
                 Choreo.Unit _m,
                 _m )
           in
           let out_stmt1 =
             Net.Let
               ( [ Net.Assign ([ Default _m ], Net.Fst (Net.Unit _m, _m), _m) ],
                 Net.Unit _m,
                 _m )
           in
           let out_stmt2 =
             Net.Let
               ( [ Net.Assign ([ Default _m ], Net.Snd (Net.Unit _m, _m), _m) ],
                 Net.Unit _m,
                 _m )
           in
           let input, expected =
             make_merge_test_not_equal in_stmt1 in_stmt2 out_stmt1 out_stmt2
           in
           let result = Netgen.epp_choreo_to_net input "Alice" in
           assert_equal result expected );
         ( "epp_choreo Match equal" >:: fun _ ->
           let input =
             [
               Choreo.Assign
                 ( [ Choreo.Default _m ],
                   Choreo.Match
                     ( Choreo.Unit _m,
                       [
                         (Choreo.Default _m, Choreo.Unit _m);
                         (Choreo.Default _m, Choreo.Unit _m);
                       ],
                       _m ),
                   _m );
             ]
           in
           let expected =
             [ Net.Assign ([ Local.Default _m ], Net.Unit _m, _m) ]
           in
           let result = Netgen.epp_choreo_to_net input "Alice" in
           assert_equal result expected );
         ( "epp_choreo Match not equal" >:: fun _ ->
           let input =
             [
               Choreo.Assign
                 ( [ Choreo.Default _m ],
                   Choreo.Match
                     ( Choreo.Unit _m,
                       [
                         (Choreo.Default _m, Choreo.Unit _m);
                         (Choreo.Default _m, Choreo.Snd (Choreo.Unit _m, _m));
                       ],
                       _m ),
                   _m );
             ]
           in
           let expected =
             [
               Net.Assign
                 ( [ Local.Default _m ],
                   Net.Match
                     ( Net.Unit _m,
                       [
                         (Local.Default _m, Net.Unit _m);
                         (Local.Default _m, Net.Snd (Net.Unit _m, _m));
                       ],
                       _m ),
                   _m );
             ]
           in
           let result = Netgen.epp_choreo_to_net input "Alice" in
           assert_equal result expected );
       ]

let suite = "Netgen tests" >::: [ epp_choreo_expr_tests ]
