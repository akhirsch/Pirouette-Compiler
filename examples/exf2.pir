main :=
if R.(3.5 +. 5.5 > 2.1 -. 1.1)
then R[L] ~> S;
  	 let R.res := [S] S.(1,true) ~> R; in R."Sent"
else R[R] ~> S;
  	 let R.res := [S] S.(0,false) ~> R; in R."why"
;

{-
NetIR:
  S: 
  Allow R choice
  | L => send (1,true) to R
  | R => send (0,false) to R

  R:
  if 3+.5 > 2-.1
  then choose L for S
    "Sent"
    receive from S
  else choose R for S
    "why"
    receive from S
-}