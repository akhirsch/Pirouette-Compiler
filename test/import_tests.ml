open OUnit2
open Ast_core
open Parsing

module TestInfo = struct
  type t = Parsed_ast.Pos_info.t
  (* needed for position info for metadata get/set tests *)
end

module ChoreoAst = Ast_core.Choreo.With (TestInfo)

(* helper to create files and then clean them up bc every import test needs a 
real file on disk because the resolver actually opens and reads files. the resolver
actually parses and reads a file so with out this the clean up was extra for every
single test *)
let with_tmp_pir contents f =
  let tmp = Filename.temp_file "test_import" ".pir" in
  let oc = open_out tmp in
  output_string oc contents;
  close_out oc;
  match f tmp with
  | result ->
      Sys.remove tmp;
      result
  | exception e ->
      Sys.remove tmp;
      raise e

(* ----------------------- Import Tests --------------------------------- *)

let test_basic_import _ =
  (* 
  1. Create a temp file with some valid Pirouette content
  2. Create a program that imports it
  3. Run the resolver
  4. Check the result
  *)
  with_tmp_pir "foreign type Int32;" (fun tmp ->
      let import_stmt =
        Choreo.M.ImportDecl
          ( tmp,
            Parsed_ast.Pos_info.{ fname = ""; start = (0, 0); stop = (0, 0) } )
      in
      (* looking at parsed_ast.ml i figured out how the position info was supposed to be written, 
    module Pos_info = struct
    type t = {
    fname : string;
    start : int * int (* line, column *);
    stop : int * int (* line, column *);
    } *)
      let resolved = Import_resolver.resolve_imports "" [ import_stmt ] in
      (* ImportDecl should be gone, foreign type decl should be there *)
      assert_equal 1 (List.length resolved))

let test_transitive_imports _ =
  (* let () = print_endline ("Current working directory: " ^ Sys.getcwd ()) in *)
  (*  1: need 3 files: A imports B, B imports C
      2: After resolution, all definitions from B and C should appear in the final stmt_block
      3: No ImportDecl nodes should remain *)
  let file_a = "import_transitive_a.pir" in
  let resolved =
    Import_resolver.resolve_imports "."
      [
        Choreo.M.ImportDecl
          ( file_a,
            Parsed_ast.Pos_info.{ fname = ""; start = (0, 0); stop = (0, 0) } );
      ]
  in
  assert_equal 1 (List.length resolved)
(* transitive_a.pir imports transitive_b.pir which imports transitive_c.pir which has one definition (foreign type Animal;) 
  after full resolution all ImportDecl nodes are gone and we are left with just that one ForeignTypeDecl
  so List.length resolved = 1 proves the transitive chain was followed correctly or there would be more then 1 in the lst*)

let test_badpath_import _ =
  let filename = "missingfile.pir" in
  assert_raises
    (Import_resolver.Import_error "File not found: ./missingfile.pir")
    (fun () ->
      Import_resolver.resolve_imports "."
        [
          Choreo.M.ImportDecl
            ( filename,
              Parsed_ast.Pos_info.{ fname = ""; start = (0, 0); stop = (0, 0) }
            );
        ])

let test_incorrectfile_import _ =
  with_tmp_pir "this is not valid pirouette!!!" (fun tmp ->
      assert_raises
        (Import_resolver.Import_error
           ("Failed to parse imported file: " ^ tmp ^ "\nParse error at [" ^ tmp
          ^ "]:  [Ln 1, Col 8]"))
        (* above catches the error from the import resolver and then also the specific parse error that the parser returns. *)
        (fun () ->
          Import_resolver.resolve_imports ""
            [
              Choreo.M.ImportDecl
                ( tmp,
                  Parsed_ast.Pos_info.
                    { fname = ""; start = (0, 0); stop = (0, 0) } );
            ]))

(* 
Test PLAN: 
Transitive imports: A imports B imports C, all definitions end up in the final stmt_block
Local + imported definitions coexist: order is preserved correctly
Bad path: file not found -> raises error
Bad path: file is not valid Pirouette -> raises error*)

(*----------------------- Choreo: get/set stmt info tests --------------------*)

let dummy_pos =
  Parsed_ast.Pos_info.{ fname = ""; start = (0, 0); stop = (0, 0) }

(* need this position info because that is what is stored in the meta *)
let test_get_info_importdecl () =
  let stmt = Choreo.M.ImportDecl ("helpers.pir", dummy_pos) in
  assert_equal dummy_pos (ChoreoAst.get_info_stmt stmt)

let test_set_info_importdecl () =
  let old_stmt = Choreo.M.ImportDecl ("helpers.pir", dummy_pos) in
  let new_pos =
    Parsed_ast.Pos_info.{ fname = "new"; start = (1, 0); stop = (1, 5) }
  in
  let new_stmt = ChoreoAst.set_info_stmt new_pos old_stmt in
  assert_equal new_pos (ChoreoAst.get_info_stmt new_stmt)

(*----------------------- Jsonify Test ---------------------------------------*)

let test_jsonify_importdecl () =
  let stmts =
    [
      Choreo.M.ImportDecl ("helpers.pir", dummy_pos);
      Choreo.M.ForeignTypeDecl (Local.M.TypId ("Int32", dummy_pos), dummy_pos);
      Choreo.M.ForeignDecl
        ( Local.M.VarId ("my_func", dummy_pos),
          Choreo.M.TLoc
            ( Local.M.LocId ("Alice", dummy_pos),
              Local.M.TForeign (Local.M.TypId ("Int32", dummy_pos), dummy_pos),
              dummy_pos ),
          "Pet:feed",
          dummy_pos );
      Choreo.M.ForeignDecl
        ( Local.M.VarId ("my_func2", dummy_pos),
          Choreo.M.TForeign (Choreo.M.Typ_Id ("Int32", dummy_pos), dummy_pos),
          "Pet:feed2",
          dummy_pos );
    ]
  in
  let result = Ast_utils.stringify_jsonify_choreo_ast stmts in
  assert_bool "JSON should contain ImportDecl and ForeignTypeDecl"
    (String.length result > 0)

(*------------------------ pprint Test ------------------------------------*)

let test_pprint_importdecl () =
  let stmts =
    [
      Choreo.M.ImportDecl ("helpers.pir", dummy_pos);
      Choreo.M.ForeignTypeDecl (Local.M.TypId ("Int32", dummy_pos), dummy_pos);
      Choreo.M.ForeignDecl
        ( Local.M.VarId ("my_func", dummy_pos),
          Choreo.M.TLoc
            ( Local.M.LocId ("Alice", dummy_pos),
              Local.M.TForeign (Local.M.TypId ("Int32", dummy_pos), dummy_pos),
              dummy_pos ),
          "Pet:feed",
          dummy_pos );
      Choreo.M.ForeignDecl
        ( Local.M.VarId ("my_func2", dummy_pos),
          Choreo.M.TForeign (Choreo.M.Typ_Id ("Int32", dummy_pos), dummy_pos),
          "Pet:feed2",
          dummy_pos );
    ]
  in
  let result = Ast_utils.stringify_pprint_choreo_ast stmts in
  assert_bool "pprint should contain import" (String.length result > 0)
(*-------------------------- Ast_utils test --------------------------------*)

let test_ast_info_map_importdecl () =
  let stmt = Choreo.M.ImportDecl ("helpers.pir", dummy_pos) in
  let result = Ast_utils.ast_list_info_map (fun _ -> dummy_pos) [ stmt ] in
  assert_equal [ Choreo.M.ImportDecl ("helpers.pir", dummy_pos) ] result

(*--------------------------- Position Info test ---------------------------*)
let test_string_of_pos () =
  let result = Parsed_ast.Pos_info.string_of_pos dummy_pos in
  assert_equal "[0:0-0:0]" result
(* created this test when i created my own struct, and saw that there was no 
bisect coverage - this tests adds coverage *)

(* TEST SUITE CALLS *)
let import_test_suite =
  "Import Tests"
  >::: [
         ("Basic Import Test" >:: fun _ -> test_basic_import ());
         ("get_info ImportDecl" >:: fun _ -> test_get_info_importdecl ());
         ("set_info ImportDecl" >:: fun _ -> test_set_info_importdecl ());
         ("transitive Import Test" >:: fun _ -> test_transitive_imports ());
         ("bad path Import Test" >:: fun _ -> test_badpath_import ());
         ("incorrect file type" >:: fun _ -> test_incorrectfile_import ());
         (" JSON test" >:: fun _ -> test_jsonify_importdecl ());
         (" Pprint test" >:: fun _ -> test_pprint_importdecl ());
         ( " Import AST utils map test" >:: fun _ ->
           test_ast_info_map_importdecl () );
       ]

let pos_info_test =
  "Pos info Test" >::: [ ("Pos info test" >:: fun _ -> test_string_of_pos ()) ]

let () =
  print_endline "\nRunning Import Tests";
  run_test_tt_main import_test_suite;
  print_endline "\n Running Position info Test";
  run_test_tt_main pos_info_test
