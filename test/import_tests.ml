open OUnit2
open Ast_core
open Parsing

module TestInfo = struct
  type t = Parsed_ast.Pos_info.t
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

(* 
Test PLAN: 
Basic import: imported definitions appear in the output, ImportDecl node is removed
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

(* TEST SUITE CALLS *)
let import_test_suite =
  "Import Tests"
  >::: [
         ("Basic Import Test" >:: fun _ -> test_basic_import ());
         ("get_info ImportDecl" >:: fun _ -> test_get_info_importdecl ());
         ("set_info ImportDecl" >:: fun _ -> test_set_info_importdecl ());
       ]

let () =
  print_endline "\nRunning Import Tests";
  run_test_tt_main import_test_suite
