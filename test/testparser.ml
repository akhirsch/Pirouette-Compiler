open OUnit2
open Netir.Ast.PosInfo_AST

let program_of_text input =
  let lexbuf = Lexing.from_string input in
  let returned = Netir.Parser.program Netir.Lexer.read lexbuf in
    Netir.Parsed_ast_processing.process_parsed_ast returned

let parse_type program_text =
  let full_program_text = "test : " ^ program_text in
  match program_of_text full_program_text with
    | [TypeDecl (_, (_, "test"), t)] -> t
    | _ -> assert_failure "Basic program structure not parsed"

let parse_expr program_text =
  let full_program_text = "test := " ^ program_text ^ ";" in
  match program_of_text full_program_text with
    | [DefnDecl (_, (_, "test"), [], e)] -> e
    | _ -> assert_failure "Basic program structure not parsed"

let parse_pat program_text =
  let full_program_text = "match true with | " ^ program_text ^ " := () end" in
  match parse_expr full_program_text with 
    | Match (_, TrueLit _, [(p, UnitLit _)]) -> p
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
    | FunTy (_, StringTy _, (FunTy (_, CharTy _, IntTy _))) -> ()
    | _ -> assert_failure "Multi-fun type did not parse"

let fun_with_varty_test _ =
  match parse_type "string -> unit -> test" with
    | FunTy (_, StringTy _, (FunTy (_, UnitTy _, VarTy (_, (_, "test"))))) -> ()
    | _ -> assert_failure "Multi-fun type did not parse"

let loc_type_test _ =
  match parse_type "location {L}" with 
    | LocTy (_, [(_, "L")]) -> () 
    | _ -> assert_failure "Location type did not parse"

let multi_loc_type_test _ =
  match parse_type "location {L1, L2}" with
    | LocTy (_, [(_, "L1") ; (_, "L2")]) -> () 
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
  match parse_expr 
    "match true with
      | _ := ()
    end" with
    | Match (_, TrueLit _, [
      (WildcardPat _, UnitLit _)
    ]) -> ()
    | _ -> assert_failure "Wildcard pattern did not parse"

let varpat_test _ =
  match parse_expr 
    "match true with
      | x := ()
    end" with
    | Match (_, TrueLit _, [
      (VarPat (_, (_, "x")), UnitLit _)
    ]) -> ()
    | _ -> assert_failure "VarLitPat pattern did not parse"

let unitpat_test _ =
  match parse_expr 
    "match true with
      | () := ()
    end" with
    | Match (_, TrueLit _, [
      (UnitLitPat _, UnitLit _)
    ]) -> ()
    | _ -> assert_failure "UnitLitPat pattern did not parse"

let intpat_test _ =
  match parse_expr 
    "match true with
      | 1 := ()
    end" with
    | Match (_, TrueLit _, [
      (IntLitPat (_, 1), UnitLit _)
    ]) -> ()
    | _ -> assert_failure "IntLitPat pattern did not parse"

let floatpat_test _ =
  match parse_expr 
    "match true with
      | 1.0 := ()
    end" with
    | Match (_, TrueLit _, [
      (FloatLitPat (_, 1.0), UnitLit _)
    ]) -> ()
    | _ -> assert_failure "FloatLitPat pattern did not parse"

let charpat_test _ =
  match parse_expr 
    "match true with
      | 'a' := ()
    end" with
    | Match (_, TrueLit _, [
      (CharLitPat (_, 'a'), UnitLit _)
    ]) -> ()
    | _ -> assert_failure "CharLitPat pattern did not parse"

let stringpat_test _ =
  match parse_expr 
    "match true with
      | \"Test\" := ()
    end" with
    | Match (_, TrueLit _, [
      (StringLitPat (_, "Test"), UnitLit _)
    ]) -> ()
    | _ -> assert_failure "StringLitPat pattern did not parse"

let truepat_test _ =
  match parse_expr 
    "match true with
      | true := ()
    end" with
    | Match (_, TrueLit _, [
      (TrueLitPat _, UnitLit _)
    ]) -> ()
    | _ -> assert_failure "TrueLitPat pattern did not parse"

let falsepat_test _ =
  match parse_expr 
    "match true with
      | false := ()
    end" with
    | Match (_, TrueLit _, [
      (FalseLitPat _, UnitLit _)
    ]) -> ()
    | _ -> assert_failure "FalseLitPat pattern did not parse"

let locpat_test _ = 
  match parse_pat "TEST" with
    | LocLitPat (_, (_, "TEST")) -> ()
    | _ -> assert_failure "LocLitPat did not parse"

let constructorpat_test _ =
  let full_program_text = 
    "data test :=
      | tt : test
      | ff : unit -> test
    
    main :=
      match variable with
      | tt := ()
      | ff (_) := ()
      end;" in
  match program_of_text full_program_text with
    | [VariantDecl (_, (_, "test"), [
        ((_, "tt"), [], VarTy (_, (_, "test")));
        ((_, "ff"), [UnitTy _], VarTy (_, (_, "test")))]
      );
      
      DefnDecl (_, (_, "main"), [], Match (_, Var (_, (_, "variable")), [
        (ConstructorPat (_, (_, "tt"), []), UnitLit _);
        (ConstructorPat (_, (_, "ff"), [WildcardPat _]), UnitLit _)
      ]))] -> ()
    | _ -> assert_failure "ConstructorPat did not parse"
  
let constructorpat_varpat_test _ =
  let full_program_text =
    "data test :=
      | left : test
      
    main := 
      match variable with
        | left := ()
        | right := ()
      end;" in
  match program_of_text full_program_text with
    | [VariantDecl (_, (_, "test"), [((_, "left"), [], VarTy (_, (_, "test")));]
      );
      
      DefnDecl (_, (_, "main"), [], Match (_, Var (_, (_, "variable")), [
        (ConstructorPat (_, (_, "left"), []), UnitLit _);
        (VarPat (_, (_, "right")), UnitLit _)
      ]))] -> ()
    | _ -> assert_failure "Parsing error when no argument ConstructorPat and VarPat are both matched on."

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

let op_suite = 
  [

  ]

(* -- EXPR TESTS -- *)

let match_test _ =
  match parse_expr 
    "match true with
      | true := ()
      | false := ()
    end" with
    | Match (_, TrueLit _, [
      (TrueLitPat _, UnitLit _);
      (FalseLitPat _, UnitLit _)
    ]) -> ()
    | _ -> assert_failure "match did not parse"

let expr_suite =
  [
    "Match" >:: match_test;
  ]

(* -- DECL TESTS -- *)

let var_decl_single_test _ =
  let full_program_text =
    "data test :=
      | typ1 : test" in
  match program_of_text full_program_text with
    | [VariantDecl (_, (_, "test"), [(_, "typ1"), [], VarTy (_, (_, "test"))])] -> ()
    | _ -> assert_failure "Single VariantDecl did not parse"

let var_decl_multi_test _ =
  let full_program_text =
    "data test :=
      | typ1 : test
      | typ2 : int -> test" in
  match program_of_text full_program_text with
    | [VariantDecl (_, (_, "test"), [
        (_, "typ1"), [], VarTy (_, (_, "test"));
        (_, "typ2"), [IntTy _], VarTy (_, (_, "test"))
        ])] -> ()
    | _ -> assert_failure "Multi VariantDecl did not parse"

let var_decl_long_type_test _ =
  let full_program_text =
    "data test :=
      | typ1 : unit -> int -> float -> char -> string -> bool -> test" in
    match program_of_text full_program_text with
    | [VariantDecl (_, (_, "test"), [(_, "typ1"), [
      UnitTy _;
      IntTy _;
      FloatTy _;
      CharTy _;
      StringTy _;
      BoolTy _;
      ], VarTy (_, (_, "test"))])] -> ()
    | _ -> assert_failure "VariantDecl with many types on one constructor did nor parse."

let decl_suite = 
  [
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

let misc_suite = 
  [
    "Newline" >:: newline_char_test;
    "Tab" >:: tab_char_test;
    "Apostrophe" >:: apo_char_test;
    "Backslash" >:: backslash_char_test;
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
