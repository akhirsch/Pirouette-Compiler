foreign print : unit -> unit := "@printer.ml:print_string_unit";

main := let R.x := [S] S.3 ~> R; in 
  if R.(x>5) 
  then R[L] ~> S;
       S.print S."Hello"
  else R[R] ~> S;
       S.print S."Bye";

{-
NetIR:
  S:
  2+3
  send 3 to R
  Allow R choice
  | L => print "Hello"
  | R => print "Bye"

  R:
  let x = receive from R in 
  if x > 5 
  then choose L for S
  else choose R for S
-}

