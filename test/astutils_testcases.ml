(*
   File: astutils_testcases.ml
   Date: 04-25-2024

   Strings for testing Pirouette modules.
*)

let testcase_1 =
  "left _ := let \n\n\
   R.x := [S] left S.1 ~> R;\n\n\
   R.x := [S] right S.3 ~> R; in \n\n\
   if R.(x> fst 5) \n\n\
   then R[L] ~> S; \n\n\
   S.\"Hello\"\n\n\
   else R[R] ~> S; \n\n\
   S.\"Bye\";\n"

let testcase_2 =
  "right (_,_) := \n\n\
   if R.(3+5 >= 2-1 || 3 != 3)\n\n\
   then R[L] ~> S;\n\n\
   let R.res := [S] (right x,y) ~> R; in R.\"Sent\"\n\n\
   else R[R] ~> S;\n\n\
   let R.res := [S] S.(left 0,snd false) ~> R; in R.\"why\";\n"

let testcase_3 =
  "type x := P2.int;\n\
   y : P2.int;\n\n\
   y := if P1.(3*2 < 5/2 && 3 = 3)\n\n\
   then P1[L] ~> P2;\n\n\
   P2.5\n\n\
   else P1[R] ~> P2;\n\n\
   P2.3\n\n\
   ;"

let testcase_4 =
  "y := if P1.(3*2 < 5/2 && 3 = 3)\n\n\
   then P1[L] ~> P2;\n\n\
   fst P2.5\n\n\
   else P1[R] ~> P2;\n\n\
   snd P2.5;\n"

let choreo_typs =
  "type choreo_sum_typ := P1.int + P2.int;\n\n\
   type choreo_unit := unit;\n\n\
   type choreo_prod_typ := P1.bool * P2.bool;\n\n\
   type choreo_map_typ := P1.bool -> P2.bool;\n"

let local_typs =
  "type local_unit := P1.unit;\n\n\
   type local_string := P1.string;\n\n\
   type local_prod_typ := P1.(int*string);\n\n\
   type local_sum_typ := P1.(int+string);\n"

let choreo_fundef =
  "foo := fun a -> (a, a);\n\n\
   _ := let P := foo P.3; in\n\n\
  \  if R.(x<=-5 && not false) \n\n\
  \  then R[L] ~> S; \n\n\
  \  S.\"Hello\"\n\n\
  \  else R[R] ~> S; \n\n\
  \  S.();\n"

let choreo_pat_match =
  "y := let P.y := y; in\n\n\
   match P.(5 >= 4 && 5/2 != 3 || 2 <= 2) with\n\n\
   |_->();\n"

let lcl_pat_match =
  "y := P.let y : int := 3 in\n\nmatch (x,z) with\n\n|(true,_)->(1,\"None\");\n"

let lcl_pat_match_2 =
  "y := P.let y : int := 3 in\n\n\
   match (x,z) with\n\n\
   |(left 1,right \"None\")->();\n"

let foreign_decl = "foreign myFunc : unit -> unit := \"external_function\";\n"
let simple_net = "y1 : unit;"

let netir_ex3 =
  "\n\
   y1 : unit;\n\
   y1 := if ret (3 > 5)\n\
  \       then choose L for P2 in unit\n\
  \       else choose R for P2 in unit;\n\n\
   y2 : p1.int;\n\
   y2 := allow choice from P1 with\n\
  \      | L -> ret (5)\n\
  \      | R -> ret (9);\n"

(* Below are some well-formatted tests for variants. These should pass. *)
let simple_variant = "type X := | constructor: X;"
let simple_different_name = "type Person := | Sam: Person;"
let two_constructors = "type Coin := \n| heads: Coin;\n\n\n| tails: Coin;\n\n\n"

let multiple_constructors1 =
  "type SchoolEmployee := \n\
   | Principal: SchoolEmployee;\n\n\n\
   | Teacher: SchoolEmployee;\n\n\n\
   | Janitor: SchoolEmployee;\n\n\n\
   | Security: SchoolEmployee;\n\n\n\
   | IT: SchoolEmployee;\n\n"

let multiple_constructors2 =
  "type Car := \n\
   | Civic: Honda;\n\n\n\
   | Accord: Honda;\n\n\n\
   | Camry: Toyota;\n\n\n\
   | Corolla: Honda;\n\n\n\
   | Altima: Nissan;\n\n"

(* test feed into prettyprint_test.ml and are testing local TForeign in prettyprint 
for the bisect report *)
let foreign_type_decl = "foreign type Int32;\n"

let foreign_decl_with_foreign_type =
  "foreign type Int32;\n\
   foreign myFunc : Alice.Int32 -> Bob.Int32 := \"Pet:feed\";\n"

let foreign_decl_choreo_tforeign =
  "foreign type Int32;\nforeign myFunc : Int32 := \"Pet:feed\";\n"

(* Int32 is a bare choreo-level foreign type, not located at any participant *)

let net_foreign_type_decl = "foreign type Int32;\n"

let net_foreign_decl_with_foreign_type =
  "foreign type Int32;\nforeign myFunc : Int32 := \"Pet:feed\";\n"

(* These tests are to ensure that variants can also have constructors which take multiple arguments *)
let simple_with_args = 
"type Operation := 
| op : Operation , Operation;\n\n
";;

let simple_many_args = 
"type Op := 
| plus : Op , Op , Op , Op , Op;\n\n
";;

let simple_mixed_args = 
"type operation := 
| plus : Int , Int , String , Bool , operation;\n\n
";;

let nats = 
"type nat := 
| zero : nat;\n\n
| suc : nat , nat;\n\n
";;

let multiple_constructors_with_args = 
"type IntOp := 
| plus : Int , Int , IntOp;\n\n
| minus : Int , Int , IntOp;\n\n
| multiply : Int , Int , IntOp;\n\n
| negative : Int , IntOp;\n\n
";;

(* Variants should also allow for recursive constructors. This is a test for that functionality *)
let recursive_variant_simple = 
"type increment := 
| zero : increment ;\n\n
| add1 : increment , increment;\n\n
";;

(* Below are some poorly formatted variants. These should fail. *)

let missing_constructor1 = "type X := ;"
let missing_constructor2 = "type X := : X;"
let missing_constructor_name = "type X := | : X;"
let missing_type = "type X := | constructor;"
let multiple_wrong_type1 =
  "type A := \n  | constructor1: A;\n\n\n  | constructor2: B;\n\n\n  "
let duplicate_constructors =
  (* constructors can't have the same name *)
  "type Coin := \n| heads: Coin;\n\n\n| heads: Coin;\n\n\n"
let type_constructor_same = "type Person := | Person : Person;"
(* constructors and types can't have the same name *)
