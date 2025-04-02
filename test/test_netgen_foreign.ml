module Ch = Ast_core.Choreo.M
module Net = Ast_core.Net.M
module Loc = Ast_core.Local.M

open OUnit2

let test_epp_foreign_decl _ =
  let dummy_info = () in
  (* Create a test foreign declaration using the Choreo version.
     We use Ch.ForeignDecl and Ch.TLoc; note that the inner type is built
     with Loc.TUnit, since TLoc expects a Local.typ *)
  let foreign_decl =
    Ch.ForeignDecl(
      Loc.VarId("print", dummy_info),
      Ch.TLoc(Loc.LocId("P1", dummy_info), Loc.TUnit dummy_info, dummy_info),
      "@printer:print",
      dummy_info
    )
  in
  
  (* Test projection to "P1":
     The conversion function should preserve the type as Net.TLoc,
     and its inner type should be the local type Loc.TUnit *)
  let p1_result = List.hd (Netgen.epp_choreo_to_net [foreign_decl] "P1") in
  (match p1_result with
  | Net.ForeignDecl (Loc.VarId(name, _), Net.TLoc(inner_typ, _), ext_name, _) ->
      assert_equal "print" name ~msg:"Function name should be preserved";
      assert_equal "@printer:print" ext_name ~msg:"External name should be preserved";
      (match inner_typ with
       | Loc.TUnit _ -> ()
       | _ -> assert_failure "Expected inner type to be Loc.TUnit")
  | _ -> assert_failure "Expected ForeignDecl in P1 projection");
  
  (* Test projection to "P2":
     The conversion function should turn the foreign declaration type into Net.TUnit *)
  let p2_result = List.hd (Netgen.epp_choreo_to_net [foreign_decl] "P2") in
  (match p2_result with
  | Net.ForeignDecl (Loc.VarId(name, _), Net.TUnit _, ext_name, _) ->
      assert_equal "print" name ~msg:"Function name should be preserved";
      assert_equal "@printer:print" ext_name ~msg:"External name should be preserved"
  | _ -> assert_failure "Expected ForeignDecl with TUnit in P2 projection")

let suite =
  "NetgenForeignTests" >::: [
    "test_epp_foreign_decl" >:: test_epp_foreign_decl;
  ]

let () = 
  run_test_tt_main suite
  