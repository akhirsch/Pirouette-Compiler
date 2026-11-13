open OUnit2
module A = Netir.Ast.PosInfo_AST
module Mapper = Netir.Astmapper.ASTMapper (Netir.Ast.PosInfo_AST) (Netir.Nometa)
module VM = Netir.Variant_matching.MkVariantMatching (Netir.Nometa)

let tables_of_text input =
  let program_mapper = Mapper.program_map (fun _ -> ()) in
  let lexbuf = Lexing.from_string input in
  let raw_prog = Netir.Parser.program Netir.Lexer.read lexbuf in
  let processed_prog =
    Netir.Parsed_ast_processing.process_parsed_ast raw_prog
  in
  let nometa_prog = program_mapper processed_prog in
  VM.get_variant_tables nometa_prog

let check_string expected actual msg =
  match (expected, actual) with
  | Some e, Some a -> assert_equal ~cmp:String.equal ~msg e a
  | None, None -> ()
  | _ -> assert_failure msg

let check_list expected actual msg =
  let cmp = List.equal String.equal in
  match (expected, actual) with
  | Some e, Some a -> assert_equal ~cmp ~msg e a
  | None, None -> ()
  | _ -> assert_failure msg

let no_variant _ =
  let program_text = {|main := ();|} in
  let variant_map, constructor_map = tables_of_text program_text in
  match (variant_map "main", constructor_map "main") with
  | None, None -> ()
  | _ -> assert_failure "Empty lookup functions returned something"

let single_constructor_single_var _ =
  let program_text = "data v_test := | c_test : v_test" in
  let variant_map, constructor_map = tables_of_text program_text in
  check_list (Some [ "c_test" ]) (variant_map "v_test") "variant_map failed";
  check_list None (variant_map "nothing")
    "Variant map produced non-existent constructors";
  check_string (Some "v_test") (constructor_map "c_test")
    "constructor_map failed";
  check_string None
    (constructor_map "nothing")
    "constructor map produced non-existent variant"

let multi_constructor_single_var _ =
  let program_text =
    {|data v_test := 
      | c1_test : v_test
      | c2_test : int -> v_test
      | c3_test : bool -> v_test|}
  in
  let variant_map, constructor_map = tables_of_text program_text in
  check_list
    (Some [ "c1_test"; "c2_test"; "c3_test" ])
    (variant_map "v_test") "variant_map failed";
  check_list None (variant_map "nothing")
    "variant_map produced non-existent constructors";
  check_string (Some "v_test")
    (constructor_map "c1_test")
    "c1_test did not map correctly";
  check_string (Some "v_test")
    (constructor_map "c2_test")
    "c2_test did not map correctly";
  check_string (Some "v_test")
    (constructor_map "c3_test")
    "c3_test did not map correctly";
  check_string None
    (constructor_map "nothing")
    "constructor_map produced non-existent variant"

let single_constructor_multi_var _ =
  let program_text =
    {|data v1_test := | c1_test : v1_test
      data v2_test := | c2_test : v2_test|}
  in
  let variant_map, constructor_map = tables_of_text program_text in
  check_list (Some [ "c1_test" ]) (variant_map "v1_test")
    "v1_test did not map correctly";
  check_list (Some [ "c2_test" ]) (variant_map "v2_test")
    "v2_test did not map correctly";
  check_list None (variant_map "nothing")
    "variant_map produced non-existent constructors";
  check_string (Some "v1_test")
    (constructor_map "c1_test")
    "c1_test did not map correctly";
  check_string (Some "v2_test")
    (constructor_map "c2_test")
    "c2_test did not map correctly";
  check_string None
    (constructor_map "nothing")
    "constructor_map produced non-existent variant"

let multi_constructor_multi_var _ =
  let program_text =
    {|data v1_test := 
        | c1_test1 : v1_test
        | c1_test2 : v1_test
      data v2_test := 
        | c2_test1 : v2_test
        | c2_test2 : v2_test|}
  in
  let variant_map, constructor_map = tables_of_text program_text in
  check_list
    (Some [ "c1_test1"; "c1_test2" ])
    (variant_map "v1_test") "v1_test did not map correctly";
  check_list
    (Some [ "c2_test1"; "c2_test2" ])
    (variant_map "v2_test") "v2_test did not map correctly";
  check_list None (variant_map "nothing")
    "variant_map produced non-existent constructors";
  check_string (Some "v1_test")
    (constructor_map "c1_test1")
    "c1_test1 did not map correctly";
  check_string (Some "v1_test")
    (constructor_map "c1_test2")
    "c1_test2 did not map correctly";
  check_string (Some "v2_test")
    (constructor_map "c2_test1")
    "c2_test1 did not map correctly";
  check_string (Some "v2_test")
    (constructor_map "c2_test2")
    "c2_test2 did not map correctly";
  check_string None
    (constructor_map "nothing")
    "constructor_map produced non-existent variant"

let suite =
  [
    "No variant" >:: no_variant;
    "Single constructor single var" >:: single_constructor_single_var;
    "Multi constructor single var" >:: multi_constructor_single_var;
    "Single constructor multi var" >:: single_constructor_multi_var;
    "Multi constructor multi var" >:: multi_constructor_multi_var;
  ]
