open Import_resolver
open OUnit2
open Ast_core
open Parsing

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
  | result -> Sys.remove tmp; result
  | exception e -> Sys.remove tmp; raise e

(* ----------------------- Import Tests --------------------------------- *)

let test_basic_import filename = 
  (* 
  1. Create a temp file with some valid Pirouette content
  2. Create a program that imports it
  3. Run the resolver
  4. Check the result
  *)
  with_tmp_pir "foreign type Int32;" (fun tmp ->
    let import_stmt = Choreo.M.ImportDecl (tmp, 0) in
    let resolved = Import_resolver.resolve_imports (Filename.dirname tmp) [import_stmt] in
    (* ImportDecl should be gone, foreign type decl should be there *)
    assert_equal 1 (List.length resolved)
  )
  
(* 
Test PLAN: 
Basic import: imported definitions appear in the output, ImportDecl node is removed
Transitive imports: A imports B imports C, all definitions end up in the final stmt_block
Local + imported definitions coexist: order is preserved correctly
Bad path: file not found → raises error
Bad path: file is not valid Pirouette → raises error*)

(* TEST SUITE CALLS *)
let import_test_suite =
  "Import Tests"
  >::: [
         ( "Basic Import Test" >:: fun _ ->
           test_basic_import () );
       ]

let () =
  run_test_tt_main import_test_suite