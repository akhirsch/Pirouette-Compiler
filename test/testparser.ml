open OUnit2
open Netir.Ast.PosInfo_AST

let program_of_text input =
  let lexbuf = Lexing.from_string input in
  let returned = Netir.Parser.program Netir.Lexer.read lexbuf in
  Netir.Parsed_ast_processing.process_parsed_ast returned

let parse_type program_text =
  let full_program_text = "test : " ^ program_text in
  match program_of_text full_program_text with
  | [ TypeDecl (_, (_, "test"), t) ] -> t
  | _ -> assert_failure "Basic program structure not parsed"

let parse_expr program_text =
  let full_program_text = "test := " ^ program_text ^ ";" in
  match program_of_text full_program_text with
  | [ DefnDecl (_, (_, "test"), [], e) ] -> e
  | _ -> assert_failure "Basic program structure not parsed"

let parse_pat program_text =
  let full_program_text = "match true with | " ^ program_text ^ " := () end" in
  match parse_expr full_program_text with
  | Match (_, TrueLit _, [ (p, UnitLit _) ]) -> p
  | _ -> assert_failure "Basic pattern structure not parsed."

(* -- TYPE TESTS -- *)

let var_type_test _ =
  match parse_type "test" with
  | VarTy (_, (_, "test")) -> ()
  | _ -> assert_failure "Var type did not parse"

let unit_type_test _ =
  match parse_type "unit" with
  | UnitTy _ -> ()
  | _ -> assert_failure "Unit type did not parse"

let int_type_test _ =
  match parse_type "int" with
  | IntTy _ -> ()
  | _ -> assert_failure "Int type did not parse"

let float_type_test _ =
  match parse_type "float" with
  | FloatTy _ -> ()
  | _ -> assert_failure "Float type did not parse"

let char_type_test _ =
  match parse_type "char" with
  | CharTy _ -> ()
  | _ -> assert_failure "Char type did not parse"

let string_type_test _ =
  match parse_type "string" with
  | StringTy _ -> ()
  | _ -> assert_failure "String type did not parse"

let bool_type_test _ =
  match parse_type "bool" with
  | BoolTy _ -> ()
  | _ -> assert_failure "Bool type did not parse"

let simple_fun_test _ =
  match parse_type "unit -> bool" with
  | FunTy (_, UnitTy _, BoolTy _) -> ()
  | _ -> assert_failure "Simple fun type did not parse"

let multi_fun_test _ =
  match parse_type "string -> char -> int" with
  | FunTy (_, StringTy _, FunTy (_, CharTy _, IntTy _)) -> ()
  | _ -> assert_failure "Multi-fun type did not parse"

let fun_with_varty_test _ =
  match parse_type "string -> unit -> test" with
  | FunTy (_, StringTy _, FunTy (_, UnitTy _, VarTy (_, (_, "test")))) -> ()
  | _ -> assert_failure "Multi-fun type did not parse"

let loc_type_test _ =
  match parse_type "location {L}" with
  | LocTy (_, [ (_, "L") ]) -> ()
  | _ -> assert_failure "Location type did not parse"

let multi_loc_type_test _ =
  match parse_type "location {L1, L2}" with
  | LocTy (_, [ (_, "L1"); (_, "L2") ]) -> ()
  | _ -> assert_failure "Location type did not parse"

let typ_suite =
  [
    "var type" >:: var_type_test;
    "unit type" >:: unit_type_test;
    "int type" >:: int_type_test;
    "float type" >:: float_type_test;
    "char type" >:: char_type_test;
    "string type" >:: string_type_test;
    "bool type" >:: bool_type_test;
    "simple fun type" >:: simple_fun_test;
    "multi fun type" >:: multi_fun_test;
    "multi fun with varty" >:: fun_with_varty_test;
    "location type" >:: loc_type_test;
    "multi location type" >:: multi_loc_type_test;
  ]

(* -- PATTERN TESTS -- *)

let wildcardpat_test _ =
  match parse_expr "match true with\n      | _ := ()\n    end" with
  | Match (_, TrueLit _, [ (WildcardPat _, UnitLit _) ]) -> ()
  | _ -> assert_failure "Wildcard pattern did not parse"

let varpat_test _ =
  match parse_expr "match true with\n      | x := ()\n    end" with
  | Match (_, TrueLit _, [ (VarPat (_, (_, "x")), UnitLit _) ]) -> ()
  | _ -> assert_failure "VarLitPat pattern did not parse"

let unitpat_test _ =
  match parse_expr "match true with\n      | () := ()\n    end" with
  | Match (_, TrueLit _, [ (UnitLitPat _, UnitLit _) ]) -> ()
  | _ -> assert_failure "UnitLitPat pattern did not parse"

let intpat_test _ =
  match parse_expr "match true with\n      | 1 := ()\n    end" with
  | Match (_, TrueLit _, [ (IntLitPat (_, 1), UnitLit _) ]) -> ()
  | _ -> assert_failure "IntLitPat pattern did not parse"

let floatpat_test _ =
  match parse_expr "match true with\n      | 1.0 := ()\n    end" with
  | Match (_, TrueLit _, [ (FloatLitPat (_, 1.0), UnitLit _) ]) -> ()
  | _ -> assert_failure "FloatLitPat pattern did not parse"

let charpat_test _ =
  match parse_expr "match true with\n      | 'a' := ()\n    end" with
  | Match (_, TrueLit _, [ (CharLitPat (_, 'a'), UnitLit _) ]) -> ()
  | _ -> assert_failure "CharLitPat pattern did not parse"

let stringpat_test _ =
  match parse_expr "match true with\n      | \"Test\" := ()\n    end" with
  | Match (_, TrueLit _, [ (StringLitPat (_, "Test"), UnitLit _) ]) -> ()
  | _ -> assert_failure "StringLitPat pattern did not parse"

let truepat_test _ =
  match parse_expr "match true with\n      | true := ()\n    end" with
  | Match (_, TrueLit _, [ (TrueLitPat _, UnitLit _) ]) -> ()
  | _ -> assert_failure "TrueLitPat pattern did not parse"

let falsepat_test _ =
  match parse_expr "match true with\n      | false := ()\n    end" with
  | Match (_, TrueLit _, [ (FalseLitPat _, UnitLit _) ]) -> ()
  | _ -> assert_failure "FalseLitPat pattern did not parse"

let locpat_test _ =
  match parse_pat "TEST" with
  | LocLitPat (_, (_, "TEST")) -> ()
  | _ -> assert_failure "LocLitPat did not parse"

let constructorpat_test _ =
  let full_program_text =
    "data test :=\n\
    \      | tt : test\n\
    \      | ff : unit -> test\n\
    \    \n\
    \    main :=\n\
    \      match variable with\n\
    \      | tt := ()\n\
    \      | ff (_) := ()\n\
    \      end;"
  in
  match program_of_text full_program_text with
  | [
   VariantDecl
     ( _,
       (_, "test"),
       [
         ((_, "tt"), [], VarTy (_, (_, "test")));
         ((_, "ff"), [ UnitTy _ ], VarTy (_, (_, "test")));
       ] );
   DefnDecl
     ( _,
       (_, "main"),
       [],
       Match
         ( _,
           Var (_, (_, "variable")),
           [
             (ConstructorPat (_, (_, "tt"), []), UnitLit _);
             (ConstructorPat (_, (_, "ff"), [ WildcardPat _ ]), UnitLit _);
           ] ) );
  ] ->
      ()
  | _ -> assert_failure "ConstructorPat did not parse"

let constructorpat_varpat_test _ =
  let full_program_text =
    "data test :=\n\
    \      | left : test\n\
    \      \n\
    \    main := \n\
    \      match variable with\n\
    \        | left := ()\n\
    \        | right := ()\n\
    \      end;"
  in
  match program_of_text full_program_text with
  | [
   VariantDecl (_, (_, "test"), [ ((_, "left"), [], VarTy (_, (_, "test"))) ]);
   DefnDecl
     ( _,
       (_, "main"),
       [],
       Match
         ( _,
           Var (_, (_, "variable")),
           [
             (ConstructorPat (_, (_, "left"), []), UnitLit _);
             (VarPat (_, (_, "right")), UnitLit _);
           ] ) );
  ] ->
      ()
  | _ ->
      assert_failure
        "Parsing error when no argument ConstructorPat and VarPat are both \
         matched on."

let loc_name_pat_test _ =
  match parse_pat "[[n]]" with
  | LocNamePat (_, (_, "n")) -> ()
  | _ -> assert_failure "LocNamePat did not parse"

let pattern_suite =
  [
    "WildcardPat" >:: wildcardpat_test;
    "VarPat" >:: varpat_test;
    "UnitLitPat" >:: unitpat_test;
    "IntLitPat" >:: intpat_test;
    "FloatLitPat" >:: floatpat_test;
    "CharLitPat" >:: charpat_test;
    "StringLitPat" >:: stringpat_test;
    "TrueLitPat" >:: truepat_test;
    "FalseLitPat" >:: falsepat_test;
    "LocaLitPat" >:: locpat_test;
    "ConstructorPat" >:: constructorpat_test;
    "VarPat ConstructoPat separation test" >:: constructorpat_varpat_test;
    "LocNamePat" >:: loc_name_pat_test;
  ]

(* -- BIN/UN OP TESTS -- *)

let neg_test _ =
  match parse_expr "- 1" with
  | Unop (_, Neg _, IntLit _) -> ()
  | _ -> assert_failure "Neg operator did not parse"

let not_test _ =
  match parse_expr "!true" with
  | Unop (_, Not _, TrueLit _) -> ()
  | _ -> assert_failure "Not operator did not parse"

let plus_test _ =
  match parse_expr "1 + 1" with
  | Binop (_, Plus _, IntLit _, IntLit _) -> ()
  | _ -> assert_failure "Plus operator did not parse"

let minus_test _ =
  match parse_expr "1 - 1" with
  | Binop (_, Minus _, IntLit _, IntLit _) -> ()
  | _ -> assert_failure "Minus operator did not parse"

let times_test _ =
  match parse_expr "1 * 1" with
  | Binop (_, Times _, IntLit _, IntLit _) -> ()
  | _ -> assert_failure "Times operator did not parse"

let div_test _ =
  match parse_expr "1 / 1" with
  | Binop (_, Div _, IntLit _, IntLit _) -> ()
  | _ -> assert_failure "Div operator did not parse"

let and_test _ =
  match parse_expr "true && false" with
  | Binop (_, And _, TrueLit _, FalseLit _) -> ()
  | _ -> assert_failure "And operator did not parse"

let or_test _ =
  match parse_expr "true || false" with
  | Binop (_, Or _, TrueLit _, FalseLit _) -> ()
  | _ -> assert_failure "Or operator did not parse"

let eq_test _ =
  match parse_expr "1 == 1" with
  | Binop (_, Eq _, IntLit _, IntLit _) -> ()
  | _ -> assert_failure "Eq operator did not parse"

let neq_test _ =
  match parse_expr "1 != 1" with
  | Binop (_, Neq _, IntLit _, IntLit _) -> ()
  | _ -> assert_failure "Neq operator did not parse"

let lt_test _ =
  match parse_expr "1 < 1" with
  | Binop (_, Lt _, IntLit _, IntLit _) -> ()
  | _ -> assert_failure "Lt operator did not parse"

let leq_test _ =
  match parse_expr "1 <= 1" with
  | Binop (_, Leq _, IntLit _, IntLit _) -> ()
  | _ -> assert_failure "Leq operator did not parse"

let gt_test _ =
  match parse_expr "1 > 1" with
  | Binop (_, Gt _, IntLit _, IntLit _) -> ()
  | _ -> assert_failure "Gt operator did not parse"

let geq_test _ =
  match parse_expr "1 >= 1" with
  | Binop (_, Geq _, IntLit _, IntLit _) -> ()
  | _ -> assert_failure "Geq operator did not parse"

let op_suite =
  [
    "Neg" >:: neg_test;
    "Not" >:: not_test;
    "Plus" >:: plus_test;
    "Minus" >:: minus_test;
    "Times" >:: times_test;
    "Div" >:: div_test;
    "And" >:: and_test;
    "Or" >:: or_test;
    "Eq" >:: eq_test;
    "Neq" >:: neq_test;
    "Lt" >:: lt_test;
    "Leq" >:: leq_test;
    "Gt" >:: gt_test;
    "Geq" >:: geq_test;
  ]

(* -- EXPR TESTS -- *)

let var_test _ =
  match parse_expr "x" with
  | Var (_, (_, "x")) -> ()
  | _ -> assert_failure "var did not parse"

let unit_test _ =
  match parse_expr "()" with
  | UnitLit _ -> ()
  | _ -> assert_failure "unit did not parse"

let int_test _ =
  match parse_expr "1" with
  | IntLit (_, 1) -> ()
  | _ -> assert_failure "int did not parse"

let float_test _ =
  match parse_expr "1.0" with
  | FloatLit (_, 1.0) -> ()
  | _ -> assert_failure "var did not parse"

let char_test _ =
  match parse_expr "'c'" with
  | CharLit (_, 'c') -> ()
  | _ -> assert_failure "char did not parse"

let string_test _ =
  match parse_expr "\"Hello\"" with
  | StringLit (_, "Hello") -> ()
  | _ -> assert_failure "string did not parse"

let true_test _ =
  match parse_expr "true" with
  | TrueLit _ -> ()
  | _ -> assert_failure "true did not parse"

let false_test _ =
  match parse_expr "false" with
  | FalseLit _ -> ()
  | _ -> assert_failure "false did not parse"

let constructorlit_test _ =
  let program_text =
    "data test :=\n\
    \      | left : int -> test\n\
    \      \n\
    \    main :=\n\
    \      left 1\n\
    \    ;"
  in
  match program_of_text program_text with
  | [
   VariantDecl
     (_, (_, "test"), [ ((_, "left"), [ IntTy _ ], VarTy (_, (_, "test"))) ]);
   DefnDecl
     (_, (_, "main"), [], ConstructorLit (_, (_, "left"), [ IntLit (_, 1) ]));
  ] ->
      ()
  | _ -> assert_failure "ConstructorLit did not parse"

let multi_constructorlit_test _ =
  let program_text =
    "data test :=\n\
    \      | left : int -> bool -> string -> test\n\
    \      \n\
    \    main :=\n\
    \      left 1 true \"test\"\n\
    \    ;"
  in
  match program_of_text program_text with
  | [
   VariantDecl
     ( _,
       (_, "test"),
       [
         ((_, "left"), [ IntTy _; BoolTy _; StringTy _ ], VarTy (_, (_, "test")));
       ] );
   DefnDecl
     ( _,
       (_, "main"),
       [],
       ConstructorLit
         (_, (_, "left"), [ IntLit (_, 1); TrueLit _; StringLit (_, "test") ])
     );
  ] ->
      ()
  | _ -> assert_failure "ConstructorLit did not parse"

let empty_constructorlit_test _ =
  let program_text =
    "data test :=\n      | left : test\n      \n    main :=\n      left\n    ;"
  in
  match program_of_text program_text with
  | [
   VariantDecl (_, (_, "test"), [ ((_, "left"), [], VarTy (_, (_, "test"))) ]);
   DefnDecl (_, (_, "main"), [], ConstructorLit (_, (_, "left"), []));
  ] ->
      ()
  | _ -> assert_failure "Empty ConstructorLit did not parse"

let loc_test _ =
  match parse_expr "TEST" with
  | LocLit (_, (_, "TEST")) -> ()
  | _ -> assert_failure "loc did not parse"

let match_test _ =
  match
    parse_expr
      "match true with\n      | true := ()\n      | false := ()\n    end"
  with
  | Match
      (_, TrueLit _, [ (TrueLitPat _, UnitLit _); (FalseLitPat _, UnitLit _) ])
    ->
      ()
  | _ -> assert_failure "match did not parse"

let rec_test _ =
  match parse_expr "fun f x := true" with
  | RecAbs (_, (_, "f"), (_, "x"), TrueLit _) -> ()
  | _ -> assert_failure "rec did not parse"

let fun_test _ =
  match parse_expr "f x" with
  | FunApp (_, Var (_, (_, "f")), Var (_, (_, "x"))) -> ()
  | _ -> assert_failure "fun did not parse"

let multi_arg_app_test _ =
  match parse_expr "f g h x" with
  | FunApp
      ( _,
        Var (_, (_, "f")),
        FunApp
          ( _,
            Var (_, (_, "g")),
            FunApp (_, Var (_, (_, "h")), Var (_, (_, "x"))) ) ) ->
      ()
  | _ -> assert_failure "Multi arg fun construction did not parse as expected"

let typeconstr_test _ =
  match parse_expr "1 : int" with
  | TypeConstr (_, IntLit _, IntTy _) -> ()
  | _ -> assert_failure "typeconst did not parse"

let send_test _ =
  match parse_expr "send true to john" with
  | Send (_, TrueLit _, (_, "john")) -> ()
  | _ -> assert_failure "send did not parse"

let recv_test _ =
  match parse_expr "recv int from susan" with
  | Recv (_, IntTy _, (_, "susan")) -> ()
  | _ -> assert_failure "recv did not parse"

let choose_test _ =
  match parse_expr "choose [L] for alice" with
  | ChooseFor (_, (_, "alice"), Label (_, "L")) -> ()
  | _ -> assert_failure "choose did not parse"

let ami_test _ =
  match parse_expr "AmI Alice" with
  | AmI (_, Var _) -> ()
  | _ -> assert_failure "ami did not parse"

let allow_test _ =
  match parse_expr "allow Alice choice\n      | [L] => true\n      end" with
  | AllowChoice (_, (_, "Alice"), [ (Label (_, "L"), TrueLit _) ]) -> ()
  | _ -> assert_failure "ami did not parse"

let expr_suite =
  [
    "Var" >:: var_test;
    "Unit" >:: unit_test;
    "Int" >:: int_test;
    "Float" >:: float_test;
    "Char" >:: char_test;
    "String" >:: string_test;
    "True" >:: true_test;
    "False" >:: false_test;
    "ConstructorLit" >:: constructorlit_test;
    "Multi ConstructorLit" >:: multi_constructorlit_test;
    "Empty ConstructorLit" >:: empty_constructorlit_test;
    "Loc" >:: loc_test;
    "Match" >:: match_test;
    "Rec" >:: rec_test;
    "Fun" >:: fun_test;
    "Multi App Fun" >:: multi_arg_app_test;
    "TypeConstr" >:: typeconstr_test;
    "Send" >:: send_test;
    "Recv" >:: recv_test;
    "ChooseFor" >:: choose_test;
    "AmI" >:: ami_test;
    "AllowChoice" >:: allow_test;
  ]

(* -- DECL TESTS -- *)

let emulated_loc_decl_test _ =
  let full_program_text = "emulated location test" in
  match program_of_text full_program_text with
  | [ EmulatedLocDecl (_, (_, "test")) ] -> ()
  | _ -> assert_failure "EmulatedLocDecl did not parse"

let type_decl_test _ =
  let full_program_text = "test : int" in
  match program_of_text full_program_text with
  | [ TypeDecl (_, (_, "test"), IntTy _) ] -> ()
  | _ -> assert_failure "TypeDecl did not parse"

let type_alias_decl_test _ =
  let full_program_text = "type test := int" in
  match program_of_text full_program_text with
  | [ TypeAliasDecl (_, (_, "test"), IntTy _) ] -> ()
  | _ -> assert_failure "TypeAliasDecl did not parse"

let empty_defndecl_test _ =
  let full_program_text = "test := ();" in
  match program_of_text full_program_text with
  | [ DefnDecl (_, (_, "test"), [], UnitLit _) ] -> ()
  | _ -> assert_failure "DefnDecl with no arguments did not parse"

let defndecl_test _ =
  let full_program_text = "test x := ();" in
  match program_of_text full_program_text with
  | [ DefnDecl (_, (_, "test"), [ VarPat (_, (_, "x")) ], UnitLit _) ] -> ()
  | _ -> assert_failure "DefnDecl with an argument did not parse"

let multi_defndecl_test _ =
  let full_program_text = "test x y _ := ();" in
  match program_of_text full_program_text with
  | [
   DefnDecl
     ( _,
       (_, "test"),
       [ VarPat (_, (_, "x")); VarPat (_, (_, "y")); WildcardPat _ ],
       UnitLit _ );
  ] ->
      ()
  | _ -> assert_failure "DefnDecl with multiple arguments did not parse"

let import_decl_test _ =
  let full_program_text = "import test" in
  match program_of_text full_program_text with
  | [ ImportDecl (_, (_, "test")) ] -> ()
  | _ -> assert_failure "ImportDecl did not parse"

let var_decl_single_test _ =
  let full_program_text = "data test :=\n      | typ1 : test" in
  match program_of_text full_program_text with
  | [
   VariantDecl (_, (_, "test"), [ ((_, "typ1"), [], VarTy (_, (_, "test"))) ]);
  ] ->
      ()
  | _ -> assert_failure "Single VariantDecl did not parse"

let var_decl_multi_test _ =
  let full_program_text =
    "data test :=\n      | typ1 : test\n      | typ2 : int -> test"
  in
  match program_of_text full_program_text with
  | [
   VariantDecl
     ( _,
       (_, "test"),
       [
         ((_, "typ1"), [], VarTy (_, (_, "test")));
         ((_, "typ2"), [ IntTy _ ], VarTy (_, (_, "test")));
       ] );
  ] ->
      ()
  | _ -> assert_failure "Multi VariantDecl did not parse"

let var_decl_long_type_test _ =
  let full_program_text =
    "data test :=\n\
    \      | typ1 : unit -> int -> float -> char -> string -> bool -> test"
  in
  match program_of_text full_program_text with
  | [
   VariantDecl
     ( _,
       (_, "test"),
       [
         ( (_, "typ1"),
           [ UnitTy _; IntTy _; FloatTy _; CharTy _; StringTy _; BoolTy _ ],
           VarTy (_, (_, "test")) );
       ] );
  ] ->
      ()
  | _ ->
      assert_failure
        "VariantDecl with many types on one constructor did nor parse."

let decl_suite =
  [
    "EmulatedLocDecl" >:: emulated_loc_decl_test;
    "TypeDecl" >:: type_decl_test;
    "TypeAliasDecl" >:: type_alias_decl_test;
    "Empty DefnDecl" >:: empty_defndecl_test;
    "DefnDecl" >:: defndecl_test;
    "Multi DefnDecl" >:: multi_defndecl_test;
    "ImportDecl" >:: import_decl_test;
    "VariantDecl single" >:: var_decl_single_test;
    "VariantDecl multi" >:: var_decl_multi_test;
    "VariandDecl many types" >:: var_decl_long_type_test;
  ]

(* -- MISC TESTS -- *)

let newline_char_test _ =
  match parse_expr "'\\n'" with
  | CharLit (_, '\n') -> ()
  | _ -> assert_failure "Newline character did not parse"

let tab_char_test _ =
  match parse_expr "'\\t'" with
  | CharLit (_, '\t') -> ()
  | _ -> assert_failure "Tab character did not parse"

let apo_char_test _ =
  match parse_expr "'\\''" with
  | CharLit (_, '\'') -> ()
  | _ -> assert_failure "Apostraphe character did nor parse"

let backslash_char_test _ =
  match parse_expr "'\\\\'" with
  | CharLit (_, '\\') -> ()
  | _ -> assert_failure "Backslash character did not parse"

let unknown_escape_char_test _ =
  let error = Netir.Lexer.SyntaxError "Unknown escape sequence: \\a" in
  assert_raises error (fun () -> parse_expr "'\\a'")

let newline_str_test _ =
  match parse_expr "\"\\n\"" with
  | StringLit (_, "\n") -> ()
  | _ -> assert_failure "Newline character did not parse"

let tab_str_test _ =
  match parse_expr "\"\\t\"" with
  | StringLit (_, "\t") -> ()
  | _ -> assert_failure "Tab character did not parse"

let quote_str_test _ =
  match parse_expr "\"\\\"\"" with
  | StringLit (_, "\"") -> ()
  | _ -> assert_failure "Apostraphe character did nor parse"

let backslash_str_test _ =
  match parse_expr "\"\\\\\"" with
  | StringLit (_, "\\") -> ()
  | _ -> assert_failure "Backslash character did not parse"

let unknown_escape_str_test _ =
  let error = Netir.Lexer.SyntaxError "Unknown escape sequence: \\a" in
  assert_raises error (fun () -> parse_expr "\"\\a\"")

let misc_suite =
  [
    "Newline Char" >:: newline_char_test;
    "Tab Char" >:: tab_char_test;
    "Apostrophe Char" >:: apo_char_test;
    "Backslash Char" >:: backslash_char_test;
    "Unknown Escape Char" >:: unknown_escape_char_test;
    "Newline Str" >:: newline_str_test;
    "Tab Str" >:: tab_str_test;
    "Quote Str" >:: quote_str_test;
    "Backslash Str" >:: backslash_str_test;
    "Unknown Escape Str" >:: unknown_escape_str_test;
  ]

let suite =
  [
    "Type tests" >::: typ_suite;
    "Pattern tests" >::: pattern_suite;
    "Op tests" >::: op_suite;
    "Expr tests" >::: expr_suite;
    "Decl tests" >::: decl_suite;
    "Misc tests" >::: misc_suite;
  ]
