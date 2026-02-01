{- Communication Pattern:
   1. Three threads perform independent computations
   2. Thread 1 sends to Thread 0, Thread 2 sends to Thread 0
   3. Thread 0 combines all results

   Message passing pattern:
   Thread 1 -> Thread 0
   Thread 2 -> Thread 0
-}

compute_local x := (x, x); -- cannot write `x*2` --

main := 
  let A.(x, y) := compute_local A.0;
      B.(x, y) := compute_local B.1;
      C.(x, y) := compute_local C.2; in
  let A.(x1, y1) := [B] B.(x, y) ~> A;
      A.(x2, y2) := [C] C.(x, y) ~> A; in
  let A.(sx, sy) := A.(x+x1+x2, y+y1+y2); in
  ((A.print_int A.sx, A.print_string A." "), A.print_int A.sy);