open OUnit2
open Ast_core
open Parsing

(* Helper function to parse a string into a Net AST *)
let parse_net_string str =
  let lexbuf = Lexing.from_string str in
  try Net_parser.prog Net_lexer.read lexbuf with
  | Net_lexer.SyntaxError msg -> failwith (Printf.sprintf "Lexer error: %s" msg)
  | Net_parser.Error ->
      let pos = lexbuf.Lexing.lex_curr_p in
      failwith
        (Printf.sprintf "Parser error at line %d, column %d" pos.Lexing.pos_lnum
           (pos.Lexing.pos_cnum - pos.Lexing.pos_bol))

(* Basic Structure Tests *)
let basic_structure_tests =
  "Basic Structure Tests"
  >::: [
         ( "test_parse_empty_program" >:: fun _ ->
           let result = parse_net_string "" in
           assert_equal [] result );
         ( "test_parse_comments" >:: fun _ ->
           let result =
             parse_net_string
               "-- This is a comment\n\
                x : unit; {- This is a\n\
                multi-line comment -} y : unit;"
           in
           match result with
           | [
            Net.M.Decl
              (Local.M.Var (Local.M.VarId ("x", _), _), Net.M.TUnit _, _);
            Net.M.Decl
              (Local.M.Var (Local.M.VarId ("y", _), _), Net.M.TUnit _, _);
           ] ->
               ()
           | _ -> assert_failure "Failed to parse program with comments" );
       ]

(* Declaration Tests *)
let declaration_tests =
  "Declaration Tests"
  >::: [
         ( "test_parse_unit_declaration" >:: fun _ ->
           let result = parse_net_string "x : unit;" in
           match result with
           | [
            Net.M.Decl
              (Local.M.Var (Local.M.VarId ("x", _), _), Net.M.TUnit _, _);
           ] ->
               ()
           | _ -> assert_failure "Failed to parse unit declaration" );
         ( "test_parse_type_declaration" >:: fun _ ->
           let result = parse_net_string "type myType := unit;" in
           match result with
           | [ Net.M.TypeDecl (Local.M.TypId ("myType", _), Net.M.TUnit _, _) ]
             ->
               ()
           | _ -> assert_failure "Failed to parse type declaration" );
         ( "test_parse_foreign_declaration" >:: fun _ ->
           let result =
             parse_net_string "foreign print : unit := \"console.log\";"
           in
           match result with
           | [
            Net.M.ForeignDecl
              (Local.M.VarId ("print", _), Net.M.TUnit _, "console.log", _);
           ] ->
               ()
           | _ -> assert_failure "Failed to parse foreign declaration" );
         ( "test_parse_complex_types" >:: fun _ ->
           let result =
             parse_net_string
               "x : client.int; y : unit -> unit; z : unit * unit; w : unit + \
                unit;"
           in
           match result with
           | [
            Net.M.Decl
              ( Local.M.Var (Local.M.VarId ("x", _), _),
                Net.M.TLoc (Local.M.LocId ("client", _), Local.M.TInt _, _),
                _ );
            Net.M.Decl
              ( Local.M.Var (Local.M.VarId ("y", _), _),
                Net.M.TMap (Net.M.TUnit _, Net.M.TUnit _, _),
                _ );
            Net.M.Decl
              ( Local.M.Var (Local.M.VarId ("z", _), _),
                Net.M.TProd (Net.M.TUnit _, Net.M.TUnit _, _),
                _ );
            Net.M.Decl
              ( Local.M.Var (Local.M.VarId ("w", _), _),
                Net.M.TSum (Net.M.TUnit _, Net.M.TUnit _, _),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse complex types" );
       ]

(* Expression Tests *)
let expression_tests =
  "Expression Tests"
  >::: [
         ( "test_parse_basic_assignment" >:: fun _ ->
           let result = parse_net_string "x := unit;" in
           match result with
           | [
            Net.M.Assign
              ([ Local.M.Var (Local.M.VarId ("x", _), _) ], Net.M.Unit _, _);
           ] ->
               ()
           | _ -> assert_failure "Failed to parse basic assignment" );
         ( "test_parse_function_definition" >:: fun _ ->
           let result = parse_net_string "f := fun x -> unit;" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("f", _), _) ],
                Net.M.FunDef
                  ([ Local.M.Var (Local.M.VarId ("x", _), _) ], Net.M.Unit _, _),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse function definition" );
         ( "test_parse_let_expression" >:: fun _ ->
           let result = parse_net_string "x := let y : unit; in unit;" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Let
                  ( [
                      Net.M.Decl
                        ( Local.M.Var (Local.M.VarId ("y", _), _),
                          Net.M.TUnit _,
                          _ );
                    ],
                    Net.M.Unit _,
                    _ ),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse let expression" );
         ( "test_parse_if_expression" >:: fun _ ->
           let result = parse_net_string "x := if unit then unit else unit;" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.If (Net.M.Unit _, Net.M.Unit _, Net.M.Unit _, _),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse if expression" );
         ( "test_parse_ret_expression" >:: fun _ ->
           let result = parse_net_string "x := ret 42;" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Ret (Local.M.Val (Local.M.Int (42, _), _), _),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse ret expression" );
       ]

(* Product and Sum Type Tests *)
let product_sum_tests =
  "Product and Sum Type Tests"
  >::: [
         ( "test_parse_pairs" >:: fun _ ->
           let result =
             parse_net_string "p := (unit, unit); x := fst p; y := snd p;"
           in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("p", _), _) ],
                Net.M.Pair (Net.M.Unit _, Net.M.Unit _, _),
                _ );
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Fst (Net.M.Var (Local.M.VarId ("p", _), _), _),
                _ );
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("y", _), _) ],
                Net.M.Snd (Net.M.Var (Local.M.VarId ("p", _), _), _),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse pairs and accessors" );
         ( "test_parse_sum_types" >:: fun _ ->
           let result = parse_net_string "l := left unit; r := right unit;" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("l", _), _) ],
                Net.M.Left (Net.M.Unit _, _),
                _ );
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("r", _), _) ],
                Net.M.Right (Net.M.Unit _, _),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse sum type constructors" );
       ]

(* Pattern Matching Tests *)
let pattern_matching_tests =
  "Pattern Matching Tests"
  >::: [
         ( "test_parse_match_with_left" >:: fun _ ->
           let result =
             parse_net_string "x := match y with | left z -> unit;"
           in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Match
                  ( Net.M.Var (Local.M.VarId ("y", _), _),
                    [
                      ( Local.M.Left (Local.M.Var (Local.M.VarId ("z", _), _), _),
                        Net.M.Unit _ );
                    ],
                    _ ),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse match with left pattern" );
         ( "test_parse_match_with_right" >:: fun _ ->
           let result =
             parse_net_string "x := match y with | right z -> unit;"
           in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Match
                  ( Net.M.Var (Local.M.VarId ("y", _), _),
                    [
                      ( Local.M.Right
                          (Local.M.Var (Local.M.VarId ("z", _), _), _),
                        Net.M.Unit _ );
                    ],
                    _ ),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse match with right pattern" );
         ( "test_parse_match_with_pair" >:: fun _ ->
           let result =
             parse_net_string "x := match y with | (a, b) -> unit;"
           in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Match
                  ( Net.M.Var (Local.M.VarId ("y", _), _),
                    [
                      ( Local.M.Pair
                          ( Local.M.Var (Local.M.VarId ("a", _), _),
                            Local.M.Var (Local.M.VarId ("b", _), _),
                            _ ),
                        Net.M.Unit _ );
                    ],
                    _ ),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse match with pair pattern" );
         ( "test_parse_match_with_value" >:: fun _ ->
           let result = parse_net_string "x := match y with | 42 -> unit;" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Match
                  ( Net.M.Var (Local.M.VarId ("y", _), _),
                    [ (Local.M.Val (Local.M.Int (42, _), _), Net.M.Unit _) ],
                    _ ),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse match with value pattern" );
         ( "test_parse_match_with_default" >:: fun _ ->
           let result = parse_net_string "x := match y with | _ -> unit;" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Match
                  ( Net.M.Var (Local.M.VarId ("y", _), _),
                    [ (Local.M.Default _, Net.M.Unit _) ],
                    _ ),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse match with default pattern" );
         ( "test_parse_match_with_nested_patterns" >:: fun _ ->
           let result =
             parse_net_string "x := match y with | left (a, b) -> unit;"
           in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Match
                  ( Net.M.Var (Local.M.VarId ("y", _), _),
                    [
                      ( Local.M.Left
                          ( Local.M.Pair
                              ( Local.M.Var (Local.M.VarId ("a", _), _),
                                Local.M.Var (Local.M.VarId ("b", _), _),
                                _ ),
                            _ ),
                        Net.M.Unit _ );
                    ],
                    _ ),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse match with nested patterns" );
         ( "test_parse_match_with_multiple_cases" >:: fun _ ->
           let result =
             parse_net_string
               "x := match y with | left z -> unit | right w -> unit | _ -> \
                unit;"
           in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Match
                  ( Net.M.Var (Local.M.VarId ("y", _), _),
                    [
                      ( Local.M.Left (Local.M.Var (Local.M.VarId ("z", _), _), _),
                        Net.M.Unit _ );
                      ( Local.M.Right
                          (Local.M.Var (Local.M.VarId ("w", _), _), _),
                        Net.M.Unit _ );
                      (Local.M.Default _, Net.M.Unit _);
                    ],
                    _ ),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse match with multiple cases" );
       ]

(* Network Communication Tests *)
let network_communication_tests =
  "Network Communication Tests"
  >::: [
         ( "test_parse_send_recv" >:: fun _ ->
           let result =
             parse_net_string "x := send unit ~> server; y := recv from client;"
           in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Send (Net.M.Unit _, Local.M.LocId ("server", _), _),
                _ );
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("y", _), _) ],
                Net.M.Recv (Local.M.LocId ("client", _), _),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse send/recv expressions" );
         ( "test_parse_choose_allow" >:: fun _ ->
           let result =
             parse_net_string
               "x := choose option for client in unit; y := allow choice from \
                server with | option -> unit;"
           in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.ChooseFor
                  ( Local.M.LabelId ("option", _),
                    Local.M.LocId ("client", _),
                    Net.M.Unit _,
                    _ ),
                _ );
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("y", _), _) ],
                Net.M.AllowChoice
                  ( Local.M.LocId ("server", _),
                    [ (Local.M.LabelId ("option", _), Net.M.Unit _) ],
                    _ ),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse choose/allow expressions" );
         ( "test_parse_allow_with_multiple_options" >:: fun _ ->
           let result =
             parse_net_string
               "x := allow choice from server with | option1 -> unit | option2 \
                -> unit;"
           in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.AllowChoice
                  ( Local.M.LocId ("server", _),
                    [
                      (Local.M.LabelId ("option1", _), Net.M.Unit _);
                      (Local.M.LabelId ("option2", _), Net.M.Unit _);
                    ],
                    _ ),
                _ );
           ] ->
               ()
           | _ ->
               assert_failure
                 "Failed to parse allow choice with multiple options" );
       ]

(* Tests for each grammar production in net_expr *)
let net_expr_tests =
  "Net Expression Grammar Tests"
  >::: [
         ( "test_unit_literal" >:: fun _ ->
           let result = parse_net_string "x := unit;" in
           match result with
           | [
            Net.M.Assign
              ([ Local.M.Var (Local.M.VarId ("x", _), _) ], Net.M.Unit _, _);
           ] ->
               ()
           | _ -> assert_failure "Failed to parse unit literal in net_expr" );
         ( "test_var_reference" >:: fun _ ->
           let result = parse_net_string "x := y;" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Var (Local.M.VarId ("y", _), _),
                _ );
           ] ->
               ()
           | _ ->
               assert_failure "Failed to parse variable reference in net_expr"
         );
         ( "test_ret_expression" >:: fun _ ->
           let result = parse_net_string "x := ret 42;" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Ret (Local.M.Val (Local.M.Int (42, _), _), _),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse ret expression in net_expr" );
         ( "test_if_expression" >:: fun _ ->
           let result = parse_net_string "x := if unit then unit else unit;" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.If (Net.M.Unit _, Net.M.Unit _, Net.M.Unit _, _),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse if expression in net_expr" );
         ( "test_let_expression" >:: fun _ ->
           let result = parse_net_string "x := let y : unit; in unit;" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Let
                  ( [
                      Net.M.Decl
                        ( Local.M.Var (Local.M.VarId ("y", _), _),
                          Net.M.TUnit _,
                          _ );
                    ],
                    Net.M.Unit _,
                    _ ),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse let expression in net_expr" );
         ( "test_send_expression" >:: fun _ ->
           let result = parse_net_string "x := send unit ~> server;" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Send (Net.M.Unit _, Local.M.LocId ("server", _), _),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse send expression in net_expr"
         );
         ( "test_recv_expression" >:: fun _ ->
           let result = parse_net_string "x := recv from client;" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Recv (Local.M.LocId ("client", _), _),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse recv expression in net_expr"
         );
         ( "test_choose_expression" >:: fun _ ->
           let result =
             parse_net_string "x := choose option for client in unit;"
           in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.ChooseFor
                  ( Local.M.LabelId ("option", _),
                    Local.M.LocId ("client", _),
                    Net.M.Unit _,
                    _ ),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse choose expression in net_expr"
         );
         ( "test_allow_expression" >:: fun _ ->
           let result =
             parse_net_string
               "x := allow choice from server with | option -> unit;"
           in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.AllowChoice
                  ( Local.M.LocId ("server", _),
                    [ (Local.M.LabelId ("option", _), Net.M.Unit _) ],
                    _ ),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse allow expression in net_expr"
         );
         ( "test_function_definition" >:: fun _ ->
           let result = parse_net_string "f := fun x -> unit;" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("f", _), _) ],
                Net.M.FunDef
                  ([ Local.M.Var (Local.M.VarId ("x", _), _) ], Net.M.Unit _, _),
                _ );
           ] ->
               ()
           | _ ->
               assert_failure "Failed to parse function definition in net_expr"
         );
         ( "test_pair_expression" >:: fun _ ->
           let result = parse_net_string "p := (unit, unit);" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("p", _), _) ],
                Net.M.Pair (Net.M.Unit _, Net.M.Unit _, _),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse pair expression in net_expr"
         );
         ( "test_fst_expression" >:: fun _ ->
           let result = parse_net_string "x := fst p;" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Fst (Net.M.Var (Local.M.VarId ("p", _), _), _),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse fst expression in net_expr" );
         ( "test_snd_expression" >:: fun _ ->
           let result = parse_net_string "y := snd p;" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("y", _), _) ],
                Net.M.Snd (Net.M.Var (Local.M.VarId ("p", _), _), _),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse snd expression in net_expr" );
         ( "test_left_expression" >:: fun _ ->
           let result = parse_net_string "l := left unit;" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("l", _), _) ],
                Net.M.Left (Net.M.Unit _, _),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse left expression in net_expr"
         );
         ( "test_right_expression" >:: fun _ ->
           let result = parse_net_string "r := right unit;" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("r", _), _) ],
                Net.M.Right (Net.M.Unit _, _),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse right expression in net_expr"
         );
         ( "test_match_expression" >:: fun _ ->
           let result =
             parse_net_string
               "x := match y with | left z -> unit | right w -> unit;"
           in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Match
                  ( Net.M.Var (Local.M.VarId ("y", _), _),
                    [
                      ( Local.M.Left (Local.M.Var (Local.M.VarId ("z", _), _), _),
                        Net.M.Unit _ );
                      ( Local.M.Right
                          (Local.M.Var (Local.M.VarId ("w", _), _), _),
                        Net.M.Unit _ );
                    ],
                    _ ),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse match expression in net_expr"
         );
         ( "test_parenthesized_expression" >:: fun _ ->
           let result = parse_net_string "x := (unit);" in
           match result with
           | [
            Net.M.Assign
              ([ Local.M.Var (Local.M.VarId ("x", _), _) ], Net.M.Unit _, _);
           ] ->
               ()
           | _ ->
               assert_failure
                 "Failed to parse parenthesized expression in net_expr" );
       ]

(* Parser Error Tests *)
let parser_error_tests =
  "Parser Error Tests"
  >::: [
         ( "test_incomplete_if" >:: fun _ ->
           try
             let _ = parse_net_string "x := if unit then unit;" in
             assert_failure "Expected parser error but got success"
           with _ -> () );
         ( "test_missing_arrow" >:: fun _ ->
           try
             let _ = parse_net_string "f := fun x unit;" in
             assert_failure "Expected parser error but got success"
           with _ -> () );
         ( "test_missing_semicolon" >:: fun _ ->
           try
             let _ = parse_net_string "x : unit" in
             assert_failure "Expected parser error but got success"
           with _ -> () );
         ( "test_wrong_send_syntax" >:: fun _ ->
           try
             let _ = parse_net_string "x := send unit -> server;" in
             assert_failure "Expected parser error but got success"
           with _ -> () );
         ( "test_incomplete_match" >:: fun _ ->
           try
             let _ = parse_net_string "x := match y with;" in
             assert_failure "Expected parser error but got success"
           with _ -> () );
       ]

(* Operator Precedence Tests *)
let precedence_tests =
  "Operator Precedence Tests"
  >::: [
         ( "test_arithmetic_precedence" >:: fun _ ->
           let result = parse_net_string "x := ret (1 + 2 * 3);" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Ret
                  ( Local.M.BinOp
                      ( Local.M.Val (Local.M.Int (1, _), _),
                        Local.M.Plus _,
                        Local.M.BinOp
                          ( Local.M.Val (Local.M.Int (2, _), _),
                            Local.M.Times _,
                            Local.M.Val (Local.M.Int (3, _), _),
                            _ ),
                        _ ),
                    _ ),
                _ );
           ] ->
               ()
           | _ ->
               assert_failure
                 "Failed to parse arithmetic with correct precedence" );
         ( "test_comparison_precedence" >:: fun _ ->
           let result = parse_net_string "x := ret (1 + 2 > 3 * 4);" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Ret
                  ( Local.M.BinOp
                      ( Local.M.BinOp
                          ( Local.M.Val (Local.M.Int (1, _), _),
                            Local.M.Plus _,
                            Local.M.Val (Local.M.Int (2, _), _),
                            _ ),
                        Local.M.Gt _,
                        Local.M.BinOp
                          ( Local.M.Val (Local.M.Int (3, _), _),
                            Local.M.Times _,
                            Local.M.Val (Local.M.Int (4, _), _),
                            _ ),
                        _ ),
                    _ ),
                _ );
           ] ->
               ()
           | _ ->
               assert_failure
                 "Failed to parse comparison operations with correct precedence"
         );
         ( "test_parse_arithmetic_expression" >:: fun _ ->
           let result = parse_net_string "x := ret (1 + 2 * 3 - 4 / 2);" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Ret
                  ( Local.M.BinOp
                      ( Local.M.BinOp
                          ( Local.M.Val (Local.M.Int (1, _), _),
                            Local.M.Plus _,
                            Local.M.BinOp
                              ( Local.M.Val (Local.M.Int (2, _), _),
                                Local.M.Times _,
                                Local.M.Val (Local.M.Int (3, _), _),
                                _ ),
                            _ ),
                        Local.M.Minus _,
                        Local.M.BinOp
                          ( Local.M.Val (Local.M.Int (4, _), _),
                            Local.M.Div _,
                            Local.M.Val (Local.M.Int (2, _), _),
                            _ ),
                        _ ),
                    _ ),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse arithmetic expression" );
       ]

(* Boolean Literal Tests *)
let boolean_literal_tests =
  "Boolean Literal Tests"
  >::: [
         ( "test_parse_ret_true" >:: fun _ ->
           let result = parse_net_string "x := ret true;" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Ret (Local.M.Val (Local.M.Bool (true, _), _), _),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse ret true" );
         ( "test_parse_ret_false" >:: fun _ ->
           let result = parse_net_string "x := ret false;" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Ret (Local.M.Val (Local.M.Bool (false, _), _), _),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse ret false" );
       ]

let additional_token_tests =
  "Additional Token Tests"
  >::: [
         (* Boolean AND operator *)
         ( "test_parse_and_expression" >:: fun _ ->
           let result = parse_net_string "x := ret (true && false);" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Ret
                  ( Local.M.BinOp
                      ( Local.M.Val (Local.M.Bool (true, _), _),
                        Local.M.And _,
                        Local.M.Val (Local.M.Bool (false, _), _),
                        _ ),
                    _ ),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse boolean AND expression" );
         (* Boolean OR operator *)
         ( "test_parse_or_expression" >:: fun _ ->
           let result = parse_net_string "x := ret (true || false);" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Ret
                  ( Local.M.BinOp
                      ( Local.M.Val (Local.M.Bool (true, _), _),
                        Local.M.Or _,
                        Local.M.Val (Local.M.Bool (false, _), _),
                        _ ),
                    _ ),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse boolean OR expression" );
         (* NOT operator (must be inside ret) *)
         ( "test_parse_not_expression" >:: fun _ ->
           let result = parse_net_string "x := ret (not false);" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Ret
                  ( Local.M.UnOp
                      ( Local.M.Not _,
                        Local.M.Val (Local.M.Bool (false, _), _),
                        _ ),
                    _ ),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse not expression" );
         (* String type declaration *)
         ( "test_parse_string_type_declaration" >:: fun _ ->
           let result = parse_net_string "x : client.string;" in
           match result with
           | [
            Net.M.Decl
              ( Local.M.Var (Local.M.VarId ("x", _), _),
                Net.M.TLoc (Local.M.LocId ("client", _), Local.M.TString _, _),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse string type declaration" );
         (* Bool type declaration *)
         ( "test_parse_bool_type_declaration" >:: fun _ ->
           let result = parse_net_string "x : client.bool;" in
           match result with
           | [
            Net.M.Decl
              ( Local.M.Var (Local.M.VarId ("x", _), _),
                Net.M.TLoc (Local.M.LocId ("client", _), Local.M.TBool _, _),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse bool type declaration" );
         (* String literal assignment *)
         ( "test_parse_string_literal_assignment" >:: fun _ ->
           let result = parse_net_string "x := ret \"hello world\";" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Ret (Local.M.Val (Local.M.String ("hello world", _), _), _),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse string literal assignment" );
         ( "test_parse_eq_expression" >:: fun _ ->
           let result = parse_net_string "x := ret (1 = 2);" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Ret
                  ( Local.M.BinOp
                      ( Local.M.Val (Local.M.Int (1, _), _),
                        Local.M.Eq _,
                        Local.M.Val (Local.M.Int (2, _), _),
                        _ ),
                    _ ),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse EQ expression" );
         ( "test_parse_neq_expression" >:: fun _ ->
           let result = parse_net_string "x := ret (1 != 2);" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Ret
                  ( Local.M.BinOp
                      ( Local.M.Val (Local.M.Int (1, _), _),
                        Local.M.Neq _,
                        Local.M.Val (Local.M.Int (2, _), _),
                        _ ),
                    _ ),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse NEQ expression" );
         ( "test_parse_lt_expression" >:: fun _ ->
           let result = parse_net_string "x := ret (1 < 2);" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Ret
                  ( Local.M.BinOp
                      ( Local.M.Val (Local.M.Int (1, _), _),
                        Local.M.Lt _,
                        Local.M.Val (Local.M.Int (2, _), _),
                        _ ),
                    _ ),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse LT expression" );
         ( "test_parse_leq_expression" >:: fun _ ->
           let result = parse_net_string "x := ret (1 <= 2);" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Ret
                  ( Local.M.BinOp
                      ( Local.M.Val (Local.M.Int (1, _), _),
                        Local.M.Leq _,
                        Local.M.Val (Local.M.Int (2, _), _),
                        _ ),
                    _ ),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse LEQ expression" );
         ( "test_parse_gt_expression" >:: fun _ ->
           let result = parse_net_string "x := ret (1 > 2);" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Ret
                  ( Local.M.BinOp
                      ( Local.M.Val (Local.M.Int (1, _), _),
                        Local.M.Gt _,
                        Local.M.Val (Local.M.Int (2, _), _),
                        _ ),
                    _ ),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse GT expression" );
         ( "test_parse_geq_expression" >:: fun _ ->
           let result = parse_net_string "x := ret (1 >= 2);" in
           match result with
           | [
            Net.M.Assign
              ( [ Local.M.Var (Local.M.VarId ("x", _), _) ],
                Net.M.Ret
                  ( Local.M.BinOp
                      ( Local.M.Val (Local.M.Int (1, _), _),
                        Local.M.Geq _,
                        Local.M.Val (Local.M.Int (2, _), _),
                        _ ),
                    _ ),
                _ );
           ] ->
               ()
           | _ -> assert_failure "Failed to parse GEQ expression" );
       ]

(* Register the tests *)
let () =
  run_test_tt_main
    ("Net Parsing Test Suite"
    >::: [
           basic_structure_tests;
           declaration_tests;
           expression_tests;
           product_sum_tests;
           pattern_matching_tests;
           network_communication_tests;
           net_expr_tests;
           parser_error_tests;
           precedence_tests;
           boolean_literal_tests;
           additional_token_tests;
         ])
