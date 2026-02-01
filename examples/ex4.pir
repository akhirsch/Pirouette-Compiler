y: P3.int;
y := if P1.(3>5)
   then P1[L] ~> P3;
          P3.5
     else P1[R] ~> P3;
          P3.9
;
{-
NetIR:
  P1:
  y : unit
  y = if 3>5 
    then choose L for P3
    else choose R for P3

  P3:
  y: int
  y = Allow P1 choice
    | L => 5
    | R => 9
-}