type shape :=
  | Point of P1.int
  | Triangle of (P1.int*P1.int*P1.int)
;

main :=
  let P1.s := P1.Triangle(10, 20, 30); in
  match P1.s with
  | Point(x) -> P1.x
  | Triangle(x, y, z) -> 
      if P1.(x > 0) 
      then P1.y 
      else P1.z
;