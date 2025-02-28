module Ch = Ast_core.Choreo.M
module Net = Ast_core.Net.M
module Loc = Ast_core.Local.M

open OUnit2
open Format
let pprint_net_stmt = Ast_utils.pprint_net_ast
let jsonify_net_stmt = Ast_utils.jsonify_net_ast

let capture_output f =
  let (r, w) = Unix.pipe () in
  let oc = Unix.out_channel_of_descr w in
  f oc;
  close_out oc;
  let ic = Unix.in_channel_of_descr r in
  let buf = Buffer.create 512 in
  (try
     while true do
       Buffer.add_string buf (input_line ic);
       Buffer.add_char buf '\n'
     done
   with End_of_file -> ());
  close_in ic;
  Buffer.contents buf

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

(* Helper function to create a test foreign declaration *)
let make_foreign_decl id typ ext_name =
  Net.ForeignDecl(Loc.VarId(id, ()), typ, ext_name, ())

(* Helper function to create test cases *)
let make_test_case name expected_pp expected_json stmt_block =
  name >:: fun _ ->
    (* Test pretty printing using capture_output; pass the whole statement block *)
    let pp_result = capture_output (fun oc -> pprint_net_stmt oc stmt_block) in
    assert_equal ~printer:(fun s -> s) expected_pp pp_result;

    (* Test JSON serialization using capture_output and parsing the result; pass the whole statement block *)
    let json_str = capture_output (fun oc -> jsonify_net_stmt oc stmt_block) in
    let json_result = Yojson.Basic.from_string json_str in
    assert_equal ~printer:Yojson.Basic.pretty_to_string expected_json json_result

let suite =
  "Net Foreign Declaration Tests" >::: [
    make_test_case
      "simple_unit_function"
      "foreign myFunc : unit -> unit := \"external_function\";"
      (`Assoc [
        "ForeignDecl",
        `Assoc [
          "id", `String "myFunc";
          "net_type", `Assoc ["TMap", `List [`String "TUnit"; `String "TUnit"]];
          "foreign_name", `String "external_function"
        ]
      ])
      ([make_foreign_decl
         "myFunc"
         (Net.TMap(Net.TUnit (), Net.TUnit (), ()))
         "external_function"] : _ Net.stmt list);

    make_test_case
      "complex_type_function"
      "foreign complexFunc : (int * bool) -> (string + unit) := \"complex_external\";"
      (`Assoc [
        "ForeignDecl",
        `Assoc [
          "id", `String "complexFunc";
          "net_type", `Assoc [
            "TMap",
            `List [
              `Assoc ["TLoc", `Assoc ["TProd", `List [`String "TInt"; `String "TBool"]]];
              `Assoc ["TLoc", `Assoc ["TSum", `List [`String "TString"; `String "TUnit"]]]
            ]
          ];
          "foreign_name", `String "complex_external"
        ]
      ])
      ([make_foreign_decl
         "complexFunc"
         (Net.TMap(
           Net.TLoc(Loc.TProd(Loc.TInt (), Loc.TBool (), ()), ()),
           Net.TLoc(Loc.TSum(Loc.TString (), Loc.TUnit (), ()), ()),
           ()))
         "complex_external"] : _ Net.stmt list);

    make_test_case
      "local_type_function"
      "foreign localFunc : int := \"local_func\";"
      (`Assoc [
        "ForeignDecl",
        `Assoc [
          "id", `String "localFunc";
          "net_type", `Assoc ["TLoc", `String "TInt"];
          "foreign_name", `String "local_func"
        ]
      ])
      ([make_foreign_decl
         "localFunc"
         (Net.TLoc(Loc.TInt (), ()))
         "local_func"] : _ Net.stmt list)
  ]

let () = run_test_tt_main suite