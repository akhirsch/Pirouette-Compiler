open OUnit2
open Ast_core

module DummyInfo = struct
  type t = int (* stand-in for real metadata like source locations *)
end

module LocalAst = Local.With (DummyInfo)
module ChoreoAst = Ast_core.Choreo.With (DummyInfo)


(* Local FFI Type Tests *)

(* The tests "test_get_info_tforegin_local" and "test_set_info_tforeign_Local"  verify that TForeign
which is the node that was added for the FFI correctly supports the standard  get_info/set_info 
pattern that the rest of the AST nodes use*)
let test_get_info_tforeign_Local (meta : int) =
  let typ_id = Local.M.TypId ("Int32", meta) in (* a type identifier node tagged with metadata *)
  let typ = Local.M.TForeign (typ_id, meta) in (* wrap it as TForeign *)
  assert_equal meta (LocalAst.get_info_typ typ) (* here is the check that reads the info back out and gives the meta data *)
;;

let test_set_info_tforeign_Local (old_meta : int) (new_meta : int) =
  let typ_id = Local.M.TypId ("Int32", old_meta) in (* construct a type identifier with the old metadata *)
  let old_typ = Local.M.TForeign (typ_id, old_meta) in (* wrap it in TForeign also with old meta data *)
  let new_typ = LocalAst.set_info_typ new_meta old_typ in (* replace the old metadata with new meta data *)
  assert_equal new_meta (LocalAst.get_info_typ new_typ) (* confirm the NEW meta data is what we get back *)
;;


(* Choreo Tests *)

(* Get info Choreo - TForeign Test *)
let test_get_info_tforeign_Choreo (meta : int) =
  let typ_id = Choreo.M.Typ_Id ("Int32", meta) in
  let typ = Choreo.M.TForeign (typ_id, meta) in
  assert_equal meta (ChoreoAst.get_info_typ typ)
;;
(* Set info Choreo - Tforeign Test *)
let test_set_info_tforeign_Choreo (old_meta : int) (new_meta : int) =
  let typ_id = Choreo.M.Typ_Id ("Int32", old_meta) in
  let old_typ = Choreo.M.TForeign (typ_id, old_meta) in
  let new_typ = ChoreoAst.set_info_typ new_meta old_typ in
  assert_equal new_meta (ChoreoAst.get_info_typ new_typ)
;;

(* check that get_info_stmt correctly reads metadata off a ForeignDecl stat node *)
let test_get_info_foreigndecl_Choreo (meta : int) =
  let var_id = Local.M.VarId ("my_func", meta) in
  (* Realistic FFI type: a foreign type located at a specific location *)
  let loc_id = Local.M.LocId ("Alice", meta) in
  let typ_id = Local.M.TypId ("Int32", meta) in
  let local_typ = Local.M.TForeign (typ_id, meta) in
  let typ = Choreo.M.TLoc (loc_id, local_typ, meta) in
  let stmt = Choreo.M.ForeignDecl (var_id, typ, "Math:calculate", meta) in
  assert_equal meta (ChoreoAst.get_info_stmt stmt)
;;

let test_set_info_foreigndecl_Choreo (old_meta : int) (new_meta : int) =
  let var_id = Local.M.VarId ("my_func", old_meta) in
  let loc_id = Local.M.LocId ("Alice", old_meta) in
  let typ_id = Local.M.TypId ("Int32", old_meta) in
  let local_typ = Local.M.TForeign (typ_id, old_meta) in (* using the local foreign type! *)
  let typ = Choreo.M.TLoc (loc_id, local_typ, old_meta) in
  let old_stmt = Choreo.M.ForeignDecl (var_id, typ, "Math:calculate", old_meta) in
  let new_stmt = ChoreoAst.set_info_stmt new_meta old_stmt in
  assert_equal new_meta (ChoreoAst.get_info_stmt new_stmt)
;;

let test_get_info_foreigntypedecl_Choreo (meta : int) =
  let typ_id = Local.M.TypId ("Int32", meta) in
  let stmt = Choreo.M.ForeignTypeDecl (typ_id, meta) in
  assert_equal meta (ChoreoAst.get_info_stmt stmt)
;;

let test_set_info_foreigntypedecl_Choreo (old_meta : int) (new_meta : int) =
  let typ_id = Local.M.TypId ("Int32", old_meta) in
  let old_stmt = Choreo.M.ForeignTypeDecl (typ_id, old_meta) in
  let new_stmt = ChoreoAst.set_info_stmt new_meta old_stmt in
  assert_equal new_meta (ChoreoAst.get_info_stmt new_stmt)
;;

(* TEST SUITE *)

let local_ffi_suite =
  "Local FFI Tests"
  >::: [ "get_info TForeign" >:: (fun _ -> test_get_info_tforeign_Local 1)
       ; "set_info TForeign" >:: (fun _ -> test_set_info_tforeign_Local 1 2)
       ]
;;

let choreo_ffi_suite =
  "Choreo FFI Tests"
  >::: [ "get_info ForeignDecl" >:: (fun _ -> test_get_info_foreigndecl_Choreo 1)
       ; "set_info ForeignDecl" >:: (fun _ -> test_set_info_foreigndecl_Choreo 1 2)
       ; "get_info ForeignTypeDecl" >:: (fun _ -> test_get_info_foreigntypedecl_Choreo 1)
       ; "set_info ForeignTypeDecl" >:: (fun _ -> test_set_info_foreigntypedecl_Choreo 1 2)
       ; "get_info TForeign Choreo" >:: (fun _ -> test_get_info_tforeign_Choreo 1)
       ; "set_info TForeign Choreo" >:: ( fun _ -> test_set_info_tforeign_Choreo 1 2)
       ]
;;

let () =
  run_test_tt_main local_ffi_suite;
  run_test_tt_main choreo_ffi_suite
;;