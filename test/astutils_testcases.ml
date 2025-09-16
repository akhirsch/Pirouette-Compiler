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

let simple_net = "y1 : unit;"

let map_net_audvy = "net_map_typ : P1.bool -> P2.bool;"
let prod_net_audvy = "net_prod_typ : P1.int * P2.int;"
let sum_net_audvy = "net_sum_typ : P1.int + P2.int;"


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
;;

let netir_ex4_audvy =
  "\n\
  y : P1.string;\n\
  y := ret (\"Hello\");\n
  x : P2.string;\n
  x := P2 <~ y;\n"
;;

let netir_exprint_jackie = 
  "\n\
   x : R.int;\n\
   x := ret (3);\n\
   y : unit;\n\
   y := if ret (x > 5)\n\
        then choose L for S in unit\n\
        else choose R for S in unit;\n\n\
   msg : S.string;\n\
   msg := allow choice from R with\n\
          | L -> ret (\"Hello\")\n\
          | R -> ret (\"Bye\");\n"
;;

let netir_ex5_jackie = 
   "\n\
    x : R.int;\n\
    x := ret (3);\n\
    y : S.string;\n\
    p1 : unit;\n\
    p1 := if ret(3 > fst 5)\n\
        then choose L for S in unit\n\
        else choose R for S in Unit;\n"

let netir_ex6_audvy =
  "\n\
  main := let _ := send ret 3 ~> R; in allow choice from R with\n\
  \                                    | R -> ret \"Bye\"\n\
  \                                    | L -> ret \"Hello\";\n"

let netir_ex7_audvy =
  "\n\
  main := let x := recv from S; in if ret x > 5 then choose L for S in unit else \n\
  \                               choose R for S in unit;\n"




let netir_ex8_audvy =  
  "\n\
  main := let x := fst unit; in x;\n"


 
let netir_ex9_audvy =  
  "\n\
  main := let x := snd unit; in x;\n"


let netir_ex10_audvy =
  "\n\
  y := fun x -> unit;\n\
  z := y ;"


let netir_ex11_audvy = (* Not Effective *)
  "\n\
  type my_type := unit;\n"


let netir_ex12_audvy =
  "\n\
  main := let x := left ret (3,2); in x;\n"

let netir_ex13_audvy =
  "\n\
  main := let x := right ret (3,2); in x;\n"

let netir_ex14_audvy =   (* Not compiling; This may be a bug on the lexer side since ID COLONEQ NETEXPR should be valid against ID COLONEQ (NETEXPR,NETEXPR)  *)
  "\n\
  x := (unit, unit);\n"