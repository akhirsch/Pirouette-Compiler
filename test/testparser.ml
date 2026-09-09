open OUnit2
module A = Netir.Ast.MkAST (Metainfo.Meta.PosInfo)
open A

let parse_type program_text =
  let full_program_text = "test : " ^ program_text in
  let lexbuf = Lexing.from_string full_program_text in
  let returned = Netir.Parser.program Netir.Lexer.read lexbuf in
  match returned with
    | [TypeDecl (_, (_, "test"), t)] -> t
    | _ -> assert_failure "Basic program structure not parsed"

(* -- TYPE TESTS -- *)

let unit_type_test _ =
  match parse_type "unit" with | UnitTy _ -> () | _ -> assert_failure "Unit Type did not parse"

let int_type_test _ =
  match parse_type "int" with | IntTy _ -> () | _ -> assert_failure "Int type did not parse"

let float_type_test _ =
  match parse_type "float" with | FloatTy _ -> () | _ -> assert_failure "Float type did not parse"

let char_type_test _ =
  match parse_type "char" with | CharTy _ -> () | _ -> assert_failure "Char type did not parse"

let string_type_test _ = 
   match parse_type "string" with | StringTy _ -> () | _ -> assert_failure "String type did not parse"

let bool_type_test _ =
  match parse_type "bool" with | BoolTy _ -> () | _ -> assert_failure "Bool type did not parse"

let simple_fun_test _ =
  match parse_type "unit -> bool" with | FunTy (_, UnitTy _, BoolTy _) -> () | _ -> assert_failure "Simple fun type did not parse"

let multi_fun_test _ =
  match parse_type "string -> char -> int" with
    | FunTy (_, StringTy _, (FunTy (_, CharTy _, IntTy _))) -> ()
    | _ -> assert_failure "Multi-fun type did not parse"

let loc_type_test _ =
  match parse_type "location l" with | LocTy (_, [(_, "l")]) -> () | _ -> assert_failure "Location type did not parse"

let suite =
  [
    (* -- TYPE TESTS -- *)
    (* "var type" >:: () TODO; *)
    "unit type" >:: unit_type_test;
    "int type" >:: int_type_test;
    "float type" >:: float_type_test;
    "char type" >:: char_type_test;
    "string type" >:: string_type_test;
    "bool type" >:: bool_type_test;
    "simple fun type" >:: simple_fun_test;
    "multi fun type" >:: multi_fun_test;
    "location type" >:: loc_type_test

  ]
