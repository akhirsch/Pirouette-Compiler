let exf0 = 
  "main := let R.x := [F] F.(6.5) ~> R; in\n\n
  R.x;"
;;

let exf1 = "main :=
  let
    R.x := [S] S.(3.2) ~> R;
  in
    if
      R.(x > 5.4)
    then
      R[L] ~> S; S.(\"Hello\")
    else
      R[R] ~> S; S.(\"Bye\");
";;

let exf2 = 
  "main :=
if R.(3.5 +. 5.5 > 2.1 -. 1.1)
then R[L] ~> S;
  	 let R.res := [S] S.(1,true) ~> R; in R.\"Sent\"
else R[R] ~> S;
  	 let R.res := [S] S.(0,false) ~> R; in R.\"why\"
;";;

let exf3 =
  "main :=
if R.(3.5 *. 5.5 > 2.1 /. 1.1)
then R[L] ~> S;
  	 let R.res := [S] S.\"Hello\" ~> R; in R.\"Sent\"
else R[R] ~> S;
  	 let R.res := [S] S.\"Bye\" ~> R; in R.\"why\"
;"

let dot0 = ""

let dot1 = ""

let dot2 = ""

let dot3 = ""


