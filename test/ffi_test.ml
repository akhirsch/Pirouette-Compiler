open OUnit2
open Ast_core
open Ppxlib
open Ocamlgen.Emit_core

module DummyInfo = struct
  type t = int (* stand-in for real metadata like source locations *)
end

module LocalAst = Local.With (DummyInfo)
module ChoreoAst = Ast_core.Choreo.With (DummyInfo)
module NetAst = Ast_core.Net.With (DummyInfo)

(*---------------------FFI AST_CORE TESTS-------------------------------------*)
(* Local Test *)

(* The tests "test_get_info_tforegin_local" and "test_set_info_tforeign_Local"  verify that TForeign
which is the node that was added for the FFI correctly supports get_info/set_info 
pattern that the rest of the AST nodes use*)
let test_get_info_tforeign_Local (meta : int) =
  let typ_id = Local.M.TypId ("Int32", meta) in
  (* a type identifier node tagged with metadata *)
  let typ = Local.M.TForeign (typ_id, meta) in
  (* wrap it as TForeign *)
  assert_equal meta (LocalAst.get_info_typ typ)

(* here is the check that reads the info back out and gives the meta data *)

let test_set_info_tforeign_Local (old_meta : int) (new_meta : int) =
  let typ_id = Local.M.TypId ("Int32", old_meta) in
  (* construct a type identifier with the old metadata *)
  let old_typ = Local.M.TForeign (typ_id, old_meta) in
  (* wrap it in TForeign also with old meta data *)
  let new_typ = LocalAst.set_info_typ new_meta old_typ in
  (* replace the old metadata with new meta data *)
  assert_equal new_meta (LocalAst.get_info_typ new_typ)

(* confirm the NEW meta data is what we get back *)

(* Choreo Tests *)

(* Get info Choreo - TForeign Test *)
let test_get_info_tforeign_Choreo (meta : int) =
  let typ_id = Choreo.M.Typ_Id ("Int32", meta) in
  let typ = Choreo.M.TForeign (typ_id, meta) in
  assert_equal meta (ChoreoAst.get_info_typ typ)

(* Set info Choreo - Tforeign Test *)
let test_set_info_tforeign_Choreo (old_meta : int) (new_meta : int) =
  let typ_id = Choreo.M.Typ_Id ("Int32", old_meta) in
  let old_typ = Choreo.M.TForeign (typ_id, old_meta) in
  let new_typ = ChoreoAst.set_info_typ new_meta old_typ in
  assert_equal new_meta (ChoreoAst.get_info_typ new_typ)

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

let test_set_info_foreigndecl_Choreo (old_meta : int) (new_meta : int) =
  let var_id = Local.M.VarId ("my_func", old_meta) in
  let loc_id = Local.M.LocId ("Alice", old_meta) in
  let typ_id = Local.M.TypId ("Int32", old_meta) in
  let local_typ = Local.M.TForeign (typ_id, old_meta) in
  (* using the local foreign type! *)
  let typ = Choreo.M.TLoc (loc_id, local_typ, old_meta) in
  let old_stmt =
    Choreo.M.ForeignDecl (var_id, typ, "Math:calculate", old_meta)
  in
  let new_stmt = ChoreoAst.set_info_stmt new_meta old_stmt in
  assert_equal new_meta (ChoreoAst.get_info_stmt new_stmt)

let test_get_info_foreigntypedecl_Choreo (meta : int) =
  let typ_id = Local.M.TypId ("Int32", meta) in
  let stmt = Choreo.M.ForeignTypeDecl (typ_id, meta) in
  assert_equal meta (ChoreoAst.get_info_stmt stmt)

let test_set_info_foreigntypedecl_Choreo (old_meta : int) (new_meta : int) =
  let typ_id = Local.M.TypId ("Int32", old_meta) in
  let old_stmt = Choreo.M.ForeignTypeDecl (typ_id, old_meta) in
  let new_stmt = ChoreoAst.set_info_stmt new_meta old_stmt in
  assert_equal new_meta (ChoreoAst.get_info_stmt new_stmt)

(* NET tests *)

let test_get_info_tforeign_Net (meta : int) =
  let typ_id = Local.M.TypId ("Int32", meta) in
  (* net.TForeign takes a local.typ_id *)
  let typ = Net.M.TForeign (typ_id, meta) in
  assert_equal meta (NetAst.get_info_typ typ)

let test_set_info_tforeign_Net (old_meta : int) (new_meta : int) =
  let typ_id = Local.M.TypId ("Int32", old_meta) in
  let old_typ = Net.M.TForeign (typ_id, old_meta) in
  let new_typ = NetAst.set_info_typ new_meta old_typ in
  assert_equal new_meta (NetAst.get_info_typ new_typ)

(* get info net statement for a ForeignDecl a foreign function declaration 
projected down to the network level*)
let test_get_info_foreigndecl_Net (meta : int) =
  let var_id = Local.M.VarId ("my_func", meta) in
  (* Realistic FFI type: a foreign type located at a specific location *)
  let loc_id = Local.M.LocId ("Alice", meta) in
  let typ_id = Local.M.TypId ("Int32", meta) in
  let local_typ = Local.M.TForeign (typ_id, meta) in
  let typ = Net.M.TLoc (loc_id, local_typ, meta) in
  let stmt = Net.M.ForeignDecl (var_id, typ, "Math:calculate", meta) in
  assert_equal meta (NetAst.get_info_stmt stmt)

(* set info net net stmt(is the net level IR after endpoint projection) for a 
ForeignDecl a foreign function declaration projected down to the network level *)
let test_set_info_foreigndecl_Net (old_meta : int) (new_meta : int) =
  let var_id = Local.M.VarId ("my_func", old_meta) in
  let loc_id = Local.M.LocId ("Alice", old_meta) in
  let typ_id = Local.M.TypId ("Int32", old_meta) in
  let local_typ = Local.M.TForeign (typ_id, old_meta) in
  (* using the local foreign type! *)
  let typ = Net.M.TLoc (loc_id, local_typ, old_meta) in
  let old_stmt = Net.M.ForeignDecl (var_id, typ, "Math:calculate", old_meta) in
  let new_stmt = NetAst.set_info_stmt new_meta old_stmt in
  assert_equal new_meta (NetAst.get_info_stmt new_stmt)

(* get net stmt(net stmt is the net level IR after endpoint projection) info for 
ForeignTypeDecl which is a foreign type projected down to net level *)
let test_get_info_foreigntypedecl_Net (meta : int) =
  let typ_id = Local.M.TypId ("Int32", meta) in
  let stmt = Net.M.ForeignTypeDecl (typ_id, meta) in
  assert_equal meta (NetAst.get_info_stmt stmt)

let test_set_info_foreigntypedecl_Net (old_meta : int) (new_meta : int) =
  let typ_id = Local.M.TypId ("Int32", old_meta) in
  let old_stmt = Net.M.ForeignTypeDecl (typ_id, old_meta) in
  let new_stmt = NetAst.set_info_stmt new_meta old_stmt in
  assert_equal new_meta (NetAst.get_info_stmt new_stmt)

(*---------------------FFI AST_UTLIS TESTS-------------------------------------*)
(* ast_locs test *)

(* Note: ast_locs is a private module inside ast_utils so it cannot be referenced
   directly from this test file. The public API is Ast_utils which wraps ast_locs
   internally, which is why we had to use Ast_utils.extract_locs here instead. *)

(* ForeignTypeDecl has no location, so extract_locs should return empty *)
let test_foreigntypedecl_no_locs () =
  let typ_id = Local.M.TypId ("Int32", 1) in
  let stmt = Choreo.M.ForeignTypeDecl (typ_id, 1) in
  let result = Ast_utils.extract_locs [ stmt ] in
  assert_equal [] result

(* ForeignDecl with a unit type has no located types in its signature
   so extract_locs should return empty. *)
let test_foreigndecl_no_locs () =
  let var_id = Local.M.VarId ("f", 1) in
  let stmt = Choreo.M.ForeignDecl (var_id, Choreo.M.TUnit 1, "f", 1) in
  let result = Ast_utils.extract_locs [ stmt ] in
  assert_equal [] result

(* ForeignDecl declares a foreign function whose type signature is written with 
Pirouette types so it can refrence the types below Alice.Int and Bob.String 
which are real choreographic locations that need to be tracked which is why extract_type
resurses into it *)
let test_foreigndecl_with_locs () =
  let var_id = Local.M.VarId ("f", 1) in
  let alice = Local.M.LocId ("Alice", 1) in
  let bob = Local.M.LocId ("Bob", 1) in
  let t_in = Choreo.M.TLoc (alice, Local.M.TInt 1, 1) in
  let t_out = Choreo.M.TLoc (bob, Local.M.TString 1, 1) in
  let typ = Choreo.M.TMap (t_in, t_out, 1) in
  let stmt = Choreo.M.ForeignDecl (var_id, typ, "f", 1) in
  let result = Ast_utils.extract_locs [ stmt ] in
  assert_equal [ "Alice"; "Bob" ] (List.sort String.compare result)

(* TForeign has no location it has a type name with no internal structure
so extract_locs should return empty. *)
let test_tforeign_extract_type_no_locs () =
  let typ_id = Choreo.M.Typ_Id ("Int32", 1) in
  let typ = Choreo.M.TForeign (typ_id, 1) in
  let stmt = Choreo.M.Decl (Choreo.M.Default 1, typ, 1) in
  let result = Ast_utils.extract_locs [ stmt ] in
  assert_equal [] result

(* AST_UTILS -  parse external name tests *)

(* simple function name with no package or search path *)
let test_parse_external_name_simple () =
  let result = Ast_utils.parse_external_name "feed" in
  assert_equal (None, "feed", None) result

(* function name with a package *)
let test_parse_external_name_with_package () =
  let result = Ast_utils.parse_external_name "Pet:feed" in
  assert_equal (Some "Pet", "feed", None) result

(* function name with a package and search path *)
let test_parse_external_name_with_search_path () =
  let result = Ast_utils.parse_external_name "Pet:feed@/usr/lib" in
  assert_equal (Some "Pet", "feed", Some "/usr/lib") result

(* function name with nested module path here Actions is a submodule it represents 
a nested module path in OCaml. So Pet:Actions.feed means the function feed 
lives inside the Actions submodule inside the Pet package *)
let test_parse_external_name_nested_module () =
  let result = Ast_utils.parse_external_name "Pet:Actions.feed" in
  assert_equal (Some "Pet", "Actions.feed", None) result

(* AST_UTILS -  collect_ffi_info tests *)

(* empty statement list returns empty *)
let test_collect_ffi_info_empty () =
  let result = Ast_utils.collect_ffi_info [] in
  assert_equal [] result

(* test that an invalid format raises an exception  hits the failwith brnch in the : split
match when both sides are empty coverage in bisect report *)
let test_parse_external_name_invalid () =
  assert_raises
    (Failure
       "Invalid external function format. Expected \
        [Package:][Submodule.]function[@searchpath]") (fun () ->
      Ast_utils.parse_external_name ":")

(* test that multiple @ symbols raises the impossible failure hits the catch all branch 
input with 2 or more @ symbols will hit that branch needed coverage for this in bisect *)
let test_parse_external_name_multiple_at () =
  assert_raises (Failure "Impossible Failure") (fun () ->
      Ast_utils.parse_external_name "Pet:feed@path1@path2")

(* verifies that a single ForeignDecl is collected *)
let test_collect_ffi_info_single () =
  let var_id = Local.M.VarId ("f", 1) in
  (* f is the name of the foreign function *)
  let stmt = Choreo.M.ForeignDecl (var_id, Choreo.M.TUnit 1, "Pet:feed", 1) in
  (* building a stmt with f as name and tunit as type and Pet:feed as external symbol/name *)
  let result = Ast_utils.collect_ffi_info [ stmt ] in
  assert_equal [ (Some "Pet", "feed", None) ] result

(* collect_ffi_info [stmt] passes the single statement in a list to the function which should find the 
ForeignDecl parse "Pet:feed" using parse_external_name, and return the result 
 TUnit type is just a placeholder here since collect_ffi_info only cares about
 the external symbol string, not the type signature.*)

(* non-ForeignDecl statements are ignored *)
let test_collect_ffi_info_ignores_other_stmts () =
  let typ_id = Local.M.TypId ("Int32", 1) in
  let stmt = Choreo.M.ForeignTypeDecl (typ_id, 1) in
  let result = Ast_utils.collect_ffi_info [ stmt ] in
  assert_equal [] result

(* duplicates are removed *)
let test_collect_ffi_info_deduplicates () =
  let var_id = Local.M.VarId ("f", 1) in
  let stmt = Choreo.M.ForeignDecl (var_id, Choreo.M.TUnit 1, "Pet:feed", 1) in
  let result = Ast_utils.collect_ffi_info [ stmt; stmt ] in
  assert_equal [ (Some "Pet", "feed", None) ] result

(* Note: ast_local_type_info_map, ast_choreo_type_info_map, and ast_info_map are not
exposed in ast_utils.mli so they cannot be called directly from this test file.
we test them indirectly through ast_list_info_map which is public and internally calls 
all three functions when mapping over a statement block. *)

(* test that ast_list_info_map with a ForeignDecl is mapped correctly
with external symbol/name preserved *)
let test_ast_info_map_foreigndecl () =
  let var_id = Local.M.VarId ("f", 1) in
  let typ = Choreo.M.TUnit 1 in
  let stmt = Choreo.M.ForeignDecl (var_id, typ, "Pet:feed", 1) in
  (* stmt builds a ForeignDecl with f, TUnit, external symbol "Pet:feed", and metadata 1 *)
  let result = Ast_utils.ast_list_info_map (fun _ -> 2) [ stmt ] in
  (* mapping over the stmt replacing meta 1 with 2 *)
  assert_equal
    [
      Choreo.M.ForeignDecl
        (Local.M.VarId ("f", 2), Choreo.M.TUnit 2, "Pet:feed", 2);
    ]
    result

(* the assert verifies that f is preserved and the metadata on VarId/Tunit/outer ForeignDecl all updated to 2
and the external symbol/name was not changed the key part being verified is that symbol/name 
bc it sould never be touched by map function *)

(* ForeignTypeDecl metadata is mapped correctly, type name is preserved *)
let test_ast_info_map_foreigntypedecl () =
  let typ_id = Local.M.TypId ("Int32", 1) in
  let stmt = Choreo.M.ForeignTypeDecl (typ_id, 1) in
  let result = Ast_utils.ast_list_info_map (fun _ -> 2) [ stmt ] in
  assert_equal
    [ Choreo.M.ForeignTypeDecl (Local.M.TypId ("Int32", 2), 2) ]
    result

(* TForeign at the local level is nested two levels deep inside a TLoc inside a ForeignDecl
so we need to verify that the metadata map correctly recurses all the way down to it. Thats why
we assert the FULL nested structure to confirm that the recursion worked as expected at every level *)
let test_ast_local_type_info_map_tforeign () =
  let var_id = Local.M.VarId ("f", 1) in
  let loc_id = Local.M.LocId ("Alice", 1) in
  (* creaes the location alice withg meta 1 *)
  let typ_id = Local.M.TypId ("Int32", 1) in
  (* create the typeid Int32 with meta 1 *)
  let local_typ = Local.M.TForeign (typ_id, 1) in
  (* wrapping Int32 as TForeign with meta 1 the node to be tested! *)
  let typ = Choreo.M.TLoc (loc_id, local_typ, 1) in
  (* creating the type signature Alice.Int32 *)
  let stmt = Choreo.M.ForeignDecl (var_id, typ, "Pet:feed", 1) in
  let result = Ast_utils.ast_list_info_map (fun _ -> 2) [ stmt ] in
  (* ast_list_info_map (fun _ -> 2) [stmt] maps over the statement 
  which internally calls ast_local_type_info_map when it recurses into the TLoc 
  and finds the TForeign inside*)
  let expected_local_typ = Local.M.TForeign (Local.M.TypId ("Int32", 2), 2) in
  (* the expected result after mapping
  TForeign with metadata updated to 2 and type name Int32 preserved*)
  let expected_typ =
    Choreo.M.TLoc (Local.M.LocId ("Alice", 2), expected_local_typ, 2)
  in
  assert_equal
    [
      Choreo.M.ForeignDecl (Local.M.VarId ("f", 2), expected_typ, "Pet:feed", 2);
    ]
    result

(* asserting the entire structure verifying that the outer ForeignDecl meta was updated
  TLoc inside has meta updated and Alice preserved and TForeign the innermost had meta updated
  but Int32 preserved*)

(* TForeign metadata is mapped correctly at the choreo level tested indirectly
   through a ForeignDecl whose type signature contains a choreo TForeign *)
let test_ast_choreo_type_info_map_tforeign () =
  let var_id = Local.M.VarId ("f", 1) in
  let typ_id = Choreo.M.Typ_Id ("Int32", 1) in
  let typ = Choreo.M.TForeign (typ_id, 1) in
  (* constructing what we are testing *)
  let stmt = Choreo.M.ForeignDecl (var_id, typ, "Pet:feed", 1) in
  (* Put it inside a Choreo.ForeignDecl as the type signature
  because ForeignDecl is a statement that carries a choreo type *)
  let result = Ast_utils.ast_list_info_map (fun _ -> 2) [ stmt ] in
  assert_equal
    [
      Choreo.M.ForeignDecl
        ( Local.M.VarId ("f", 2),
          Choreo.M.TForeign (Choreo.M.Typ_Id ("Int32", 2), 2),
          "Pet:feed",
          2 );
    ]
    result

(* Assert the full result to confirm the map reached all the way into the TForeign *)

(*-------------------------FFI EMIT CORE TESTS ------------------------------*)

(* COPIED THESE THREE HELPERS FROM EMIT_CORE.ML *)
let expr_to_string expr = Pprintast.string_of_expression expr

(* COPIED THESE THREE HELPERS FROM EMIT_CORE.ML *)
let contains_substring string substring =
  let s_length = String.length string in
  let sub_length = String.length substring in
  if sub_length = 0 then true
  else if sub_length > s_length then false
  else
    let rec check_subs i =
      if i > s_length - sub_length then false
      else if String.sub string i sub_length = substring then true
      else check_subs (i + 1)
    in
    check_subs 0

(* COPIED THIS HELPER FROM EMIT_CORE.ML *)
let net_binding_test ~node_id stmt pattern_test expr_test =
  let binding =
    emit_net_binding ~self_id:node_id
      (module Ocamlgen.Toplevel_http.Msg_http_intf)
      stmt
  in
  let pattern_result = pattern_test binding.pvb_pat in
  let expr_result =
    contains_substring (expr_to_string binding.pvb_expr) expr_test
  in
  pattern_result && expr_result

(* used this approach since it tests through emit_net_binding which calls
 emit_foreign_decl indirectly and just checks that the output contains the 
 right substrings rather than doing exact string matching which was throwing that error
in the emit_core ffi tests *)

(* tests find_type_sig TForeign at the net level — foreign type used directly in type signature *)
let net_binding_foreign_decl_net_tforeign _ =
  let typ_id = Local.M.TypId ("Int32", ()) in
  let typ = Net.M.TForeign (typ_id, ()) in
  let stmt = Net.M.ForeignDecl (VarId ("pir_func", ()), typ, "Pet:feed", ()) in
  let pattern_test pat =
    match pat.ppat_desc with
    | Ppat_var { txt = var_name; _ } -> var_name = "pir_func"
    | _ -> false
  in
  assert_equal true
    (net_binding_test ~node_id:"testing" stmt pattern_test "Pet.feed")

(* tests find_local_type_sig TForeign foreign type nested inside a TLoc *)
let net_binding_foreign_decl_local_tforeign _ =
  let typ_id = Local.M.TypId ("Int32", ()) in
  let local_typ = Local.M.TForeign (typ_id, ()) in
  let loc_id = Local.M.LocId ("Alice", ()) in
  let typ = Net.M.TLoc (loc_id, local_typ, ()) in
  let stmt = Net.M.ForeignDecl (VarId ("pir_func", ()), typ, "Pet:feed", ()) in
  let pattern_test pat =
    match pat.ppat_desc with
    | Ppat_var { txt = var_name; _ } -> var_name = "pir_func"
    | _ -> false
  in
  assert_equal true
    (net_binding_test ~node_id:"testing" stmt pattern_test "Pet.feed")

(* TEST SUITE *)

let emit_core_ffi_suite =
  "Emit core Tests"
  >::: [
         ( "find_local_type_sig at net level TForeign" >:: fun _ ->
           net_binding_foreign_decl_local_tforeign () );
         ( "find_local_type_sig nested TForeign" >:: fun _ ->
           net_binding_foreign_decl_net_tforeign () );
       ]

let local_ffi_suite =
  "Local FFI Tests"
  >::: [
         ("get_info TForeign" >:: fun _ -> test_get_info_tforeign_Local 1);
         ("set_info TForeign" >:: fun _ -> test_set_info_tforeign_Local 1 2);
       ]

let choreo_ffi_suite =
  "Choreo FFI Tests"
  >::: [
         ("get_info ForeignDecl" >:: fun _ -> test_get_info_foreigndecl_Choreo 1);
         ( "set_info ForeignDecl" >:: fun _ ->
           test_set_info_foreigndecl_Choreo 1 2 );
         ( "get_info ForeignTypeDecl" >:: fun _ ->
           test_get_info_foreigntypedecl_Choreo 1 );
         ( "set_info ForeignTypeDecl" >:: fun _ ->
           test_set_info_foreigntypedecl_Choreo 1 2 );
         ( "get_info TForeign Choreo" >:: fun _ ->
           test_get_info_tforeign_Choreo 1 );
         ( "set_info TForeign Choreo" >:: fun _ ->
           test_set_info_tforeign_Choreo 1 2 );
       ]

let net_ffi_suite =
  "Net FFI Tests"
  >::: [
         ("get_info ForeignDecl" >:: fun _ -> test_get_info_foreigndecl_Net 1);
         ("set_info ForeignDecl" >:: fun _ -> test_set_info_foreigndecl_Net 1 2);
         ( "get_info ForeignTypeDecl" >:: fun _ ->
           test_get_info_foreigntypedecl_Net 1 );
         ( "set_info ForeignTypeDecl" >:: fun _ ->
           test_set_info_foreigntypedecl_Net 1 2 );
         ("get_info TForeign Net" >:: fun _ -> test_get_info_tforeign_Net 1);
         ("set_info TForeign Net" >:: fun _ -> test_set_info_tforeign_Net 1 2);
       ]

let ast_locs_ffi_suite =
  "Ast Locs FFI Tests"
  >::: [
         ("ForeignTypeDecl no locs" >:: fun _ -> test_foreigntypedecl_no_locs ());
         ("ForeignDecl no locs" >:: fun _ -> test_foreigndecl_no_locs ());
         ("ForeignDecl with locs" >:: fun _ -> test_foreigndecl_with_locs ());
         ( "TForeign extract_type no locs" >:: fun _ ->
           test_tforeign_extract_type_no_locs () );
       ]

let ast_utils_ffi_suite =
  "Ast Utils FFI Tests"
  >::: [
         ( "parse_external_name simple" >:: fun _ ->
           test_parse_external_name_simple () );
         ( "parse_external_name with package" >:: fun _ ->
           test_parse_external_name_with_package () );
         ( "parse_external_name with search path" >:: fun _ ->
           test_parse_external_name_with_search_path () );
         ( "parse_external_name nested module" >:: fun _ ->
           test_parse_external_name_nested_module () );
         ("collect_ffi_info empty" >:: fun _ -> test_collect_ffi_info_empty ());
         ("collect_ffi_info single" >:: fun _ -> test_collect_ffi_info_single ());
         ( "collect_ffi_info ignores other stmts" >:: fun _ ->
           test_collect_ffi_info_ignores_other_stmts () );
         ( "collect_ffi_info deduplicates" >:: fun _ ->
           test_collect_ffi_info_deduplicates () );
         ( "ast_list_info_map local TForeign" >:: fun _ ->
           test_ast_local_type_info_map_tforeign () );
         ( "ast_list_info_map choreo TForeign" >:: fun _ ->
           test_ast_choreo_type_info_map_tforeign () );
         ( "ast_list_info_map ForeignDecl" >:: fun _ ->
           test_ast_info_map_foreigndecl () );
         ( "ast_list_info_map ForeignTypeDecl" >:: fun _ ->
           test_ast_info_map_foreigntypedecl () );
         ( "parse_external_name invalid format" >:: fun _ ->
           test_parse_external_name_invalid () );
         ( "parse_external_name multiple @ symbols" >:: fun _ ->
           test_parse_external_name_multiple_at () );
       ]

let main_suite =
  "FFI test suite"
  >::: [
         local_ffi_suite;
         choreo_ffi_suite;
         net_ffi_suite;
         ast_locs_ffi_suite;
         ast_utils_ffi_suite;
         emit_core_ffi_suite;
       ]
