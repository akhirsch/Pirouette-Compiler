y: P2.int;
y := if P1.(3>5)
   then P1[L] ~> P2;
          P2.5
     else P1[R] ~> P2;
          P2.9
;

{-
NetIR:
  P1:
  y : unit
  y = if 3>5 
    then choose L for P2
    else choose R for P2

  P2:
  y: int
  y = Allow P1 choice
    | L => 5
    | R => 9
-}