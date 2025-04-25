type shape :=
  | Point of P1.int
  | Triangle of (P1.int*P1.int*P1.int)
;

main :=
  let P1.s := P1.Triangle(10, 20, 30); in
  let P1.result := 
    match P1.s with
    | Point(x) -> P1.x
    | Triangle(x, y, z) -> 
        if P1.(x > 0) 
        then P1.y 
        else P1.z
  ; in
  if P1.(result > 0) then
    P1[L] ~> P2;
         P2.result
  else
    P1[R] ~> P2;
         P2.0
;

{-
NetIR:
  P1:
  let s = Triangle(10, 20, 30)
  let result = match s with
  | Point(x) => x
  | Triangle(x, y, z) => if x > 0 then y else z
  if result > 0 
  then choose L for P2
  else choose R for P2
  
  P2:
  Allow P1 choice
  | L => result
  | R => 0
-}