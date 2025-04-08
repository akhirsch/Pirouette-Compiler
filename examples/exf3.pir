main :=
if R.(3.5 *. 5.5 > 2.1 /. 1.1)
then R[L] ~> S;
  	 let R.res := [S] S."Hello" ~> R; in R."Sent"
else R[R] ~> S;
  	 let R.res := [S] S."Bye" ~> R; in R."why"
;

{-
NetIR:
  S: 
  Allow R choice
  | L => send "Hello" to R
  | R => send "Bye" to R

  R:
  if 3*.5 > 2/.1
  then choose L for S
    "Sent"
    receive from S
  else choose R for S
    "why"
    receive from S
-}