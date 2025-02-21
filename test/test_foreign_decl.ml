open OUnit2
open Ast_core
open Ast_utils

(* Helper function to create a dummy location info *)
let dummy_loc = ()

(* Helper function to create a ForeignDecl node *)
let make_foreign_decl id typ foreign_name =
  Choreo.M.ForeignDecl (
    Local.M.VarId (id, dummy_loc),
    typ,
    foreign_name,
    dummy_loc
  )

(* Helper function to create a simple choreo type *)
let make_simple_type () = 
  Choreo.M.TUnit dummy_loc

let test_pprint_foreign_decl _ =
  let foreign_decl = make_foreign_decl "my_func" (make_simple_type ()) "external_func" in
  let buf = Buffer.create 100 in
  let fmt = Format.formatter_of_buffer buf in
  Pprint_ast.pprint_choreo_stmt fmt foreign_decl;
  Format.pp_print_flush fmt ();
  let result = Buffer.contents buf in
  assert_equal 
    ~msg:"Pretty printed foreign decl should match expected format"
    "foreign my_func : unit := \"external_func\";"
    (String.trim result)

let test_jsonify_foreign_decl _ =
  let foreign_decl = make_foreign_decl "my_func" (make_simple_type ()) "external_func" in
  let json = Jsonify_ast.jsonify_choreo_stmt foreign_decl in
  let expected = `Assoc [
    "ForeignDecl",
    `Assoc [
      "id", `String "my_func";
      "choreo_type", `String "TUnit";
      "foreign_name", `String "external_func"
    ]
  ] in
  assert_equal 
    ~msg:"JSON serialization should match expected structure"
    ~printer:Yojson.Basic.to_string
    expected
    json

let test_complex_type_foreign_decl _ =
  let complex_type = Choreo.M.TMap (
    Choreo.M.TUnit dummy_loc,
    Choreo.M.TUnit dummy_loc,
    dummy_loc
  ) in
  let foreign_decl = make_foreign_decl "complex_func" complex_type "external_complex" in
  
  (* Test pretty printing *)
  let buf = Buffer.create 100 in
  let fmt = Format.formatter_of_buffer buf in
  Pprint_ast.pprint_choreo_stmt fmt foreign_decl;
  Format.pp_print_flush fmt ();
  let result = Buffer.contents buf in
  assert_equal 
    ~msg:"Pretty printed complex foreign decl should match expected format"
    "foreign complex_func : unit -> unit := \"external_complex\";"
    (String.trim result);

  (* Test JSON serialization *)
  let json = Jsonify_ast.jsonify_choreo_stmt foreign_decl in
  let expected = `Assoc [
    "ForeignDecl",
    `Assoc [
      "id", `String "complex_func";
      "choreo_type", `Assoc [
        "TMap", `List [
          `String "TUnit";
          `String "TUnit"
        ]
      ];
      "foreign_name", `String "external_complex"
    ]
  ] in
  assert_equal 
    ~msg:"JSON serialization of complex type should match expected structure"
    ~printer:Yojson.Basic.to_string
    expected
    json

let suite =
  "ForeignDecl tests" >::: [
    "test_pprint_foreign_decl" >:: test_pprint_foreign_decl;
    "test_jsonify_foreign_decl" >:: test_jsonify_foreign_decl;
    "test_complex_type_foreign_decl" >:: test_complex_type_foreign_decl;
  ]

let () =
  run_test_tt_main suite