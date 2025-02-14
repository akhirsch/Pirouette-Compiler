main := let R.x := [S] S.3.5 ~> R; in 
  if R.(x>5.3) 
  then R[L] ~> S;
       S."Hello"
  else R[R] ~> S;
       S."Bye";

{-
NetIR:
  S:
  2+3
  send 3 to R
  Allow R choice
  | L => "Hello"
  | R => "Bye"

  R:
  let x = receive from R in 
  if x > 5 
  then choose L for S
  else choose R for S
-}