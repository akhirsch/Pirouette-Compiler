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
;;

let testcase_2 =
  "right (_,_) := \n\n\
   if R.(3+5 >= 2-1 || 3 != 3)\n\n\
   then R[L] ~> S;\n\n\
   let R.res := [S] (right x,y) ~> R; in R.\"Sent\"\n\n\
   else R[R] ~> S;\n\n\
   let R.res := [S] S.(left 0,snd false) ~> R; in R.\"why\";\n"
;;

let testcase_3 =
  "type x := P2.int;\n\
   y : P2.int;\n\n\
   y := if P1.(3*2 < 5/2 && 3 = 3)\n\n\
   then P1[L] ~> P2;\n\n\
   P2.5\n\n\
   else P1[R] ~> P2;\n\n\
   ()\n\n\
   P2.3\n\n\
   ;"
;;

let testcase_4 =
  "y := if P1.(3*2 < 5/2 && 3 = 3)\n\n\
   then P1[L] ~> P2;\n\n\
   fst P2.5\n\n\
   else P1[R] ~> P2;\n\n\
   snd P2.5;\n"
;;

let choreo_typs =
  "type choreo_sum_typ := P1.int + P2.int;\n\n\
   type choreo_unit := unit;\n\n\
   type choreo_prod_typ := P1.bool * P2.bool;\n\n\
   type choreo_map_typ := P1.bool -> P2.bool;\n"
;;

let local_typs =
  "type local_unit := P1.unit;\n\n\
   type local_string := P1.string;\n\n\
   type local_prod_typ := P1.(int*string);\n\n\
   type local_sum_typ := P1.(int+string);\n"
;;

let choreo_fundef =
  "foo := fun a -> (a, a);\n\n\
   _ := let P := foo P.3; in\n\n\
  \  if R.(x<=-5 && not false) \n\n\
  \  then R[L] ~> S; \n\n\
  \  S.\"Hello\"\n\n\
  \  else R[R] ~> S; \n\n\
  \  S.();\n"
;;

let choreo_pat_match =
  "y := let P.y := y; in\n\nmatch P.(5 >= 4 && 5/2 != 3 || 2 <= 2) with\n\n|_->();\n"
;;

let lcl_pat_match =
  "y := P.let y : int := 3 in\n\nmatch (x,z) with\n\n|(true,_)->(1,\"None\");\n"
;;

let lcl_pat_match_2 =
  "y := P.let y : int := 3 in\n\nmatch (x,z) with\n\n|(left 1,right \"None\")->();\n"
;;

let foreign_decl = "foreign myFunc : unit -> unit := \"external_function\";\n"
let net_test_1 = ""

let constructor1 = 
  "type x :=\n\n\
  | construct1 : arg1, arg2, arg3\n"
;;

let constructor2 =
  "type x :=\n\n\
  | construct1 : arg1, arg2, arg3\n\n\
  | construct2 : arg1, arg2, arg3\n"
;;

let constructor3 =
  "type x :=\n\n\
  | construct1 : arg1, arg2, arg3\n\n\
  | construct2 : arg1, arg2, arg3\n\n\
  | construct3 : arg1, arg2, arg3\n"
;;


let no_constructor_list = "type x :="
;;

let one_constructor_one_arg =
  "type x :=\n\n\
  | Construct1 : arg1\n"
;;

let one_constructor_multi_arg =
  "type x :=\n\n\
  | Construct1 : arg1, arg2, arg3\n"
;;

let two_constructors_one_arg =
  "type x :=\n\n\
  | Construct1 : arg_a\n\n\
  | Construct2 : arg_b\n"
;;

let two_constructors_multi_arg =
  "type x :=\n\n\
  | Construct1 : arg1, arg2\n\n\
  | Construct2 : arg3, arg4, arg5\n"
;;

let ten_constructors_ten_args =
  "type x :=\n\n\
  | C1 : a1, a2, a3, a4, a5, a6, a7, a8, a9, a10\n\n\
  | C2 : b1, b2, b3, b4, b5, b6, b7, b8, b9, b10\n\n\
  | C3 : c1, c2, c3, c4, c5, c6, c7, c8, c9, c10\n\n\
  | C4 : d1, d2, d3, d4, d5, d6, d7, d8, d9, d10\n\n\
  | C5 : e1, e2, e3, e4, e5, e6, e7, e8, e9, e10\n\n\
  | C6 : f1, f2, f3, f4, f5, f6, f7, f8, f9, f10\n\n\
  | C7 : g1, g2, g3, g4, g5, g6, g7, g8, g9, g10\n\n\
  | C8 : h1, h2, h3, h4, h5, h6, h7, h8, h9, h10\n\n\
  | C9 : i1, i2, i3, i4, i5, i6, i7, i8, i9, i10\n\n\
  | C10 : j1, j2, j3, j4, j5, j6, j7, j8, j9, j10\n"
;;

let negative_missing_colon =
  "type x :=\n\n\
  | Construct1 arg1, arg2, arg3\n"
;;

let negative_missing_pipe =
  "type x :=\n\n\
  | Construct1 : arg1\n\n\
  Construct2 : arg2\n"
;;