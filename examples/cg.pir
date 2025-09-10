{- Communication Pattern:
   1. Matrix-vector multiplication: each process handles subset of rows
   2. Global reductions for dot products
   3. Parallel vector updates

   For 3 processes:
   - Process 0 handles rows 0 to n/3
   - Process 1 handles rows n/3 to 2n/3
   - Process 2 handles rows 2n/3 to n
-}

{- compute_mv_prod mv_sum1 mv_sum2 :=
     let mv_result := mv_sum1 + mv_sum2; in
     mv_result;
-}

iterate count local_result :=
  if A.(count = 0)
  then
    A[DONE] ~> B;
    A[DONE] ~> C;
    A.print_int A.local_result
  else
    A[CONT] ~> B;
    A[CONT] ~> C;
    let A.mv_sum1 := [B] B.1 ~> A;
        A.mv_sum2 := [C] C.2 ~> A; in
    let A.mv_result := A.(mv_sum1 + mv_sum2); in
    let B.mv_sum1 := [A] A.0 ~> B;
        B.mv_sum2 := [C] C.2 ~> B; in
    let B.mv_result := B.(mv_sum1 + mv_sum2); in
    let C.mv_sum1 := [A] A.0 ~> C;
        C.mv_sum2 := [B] B.1 ~> C; in
    let C.mv_result := C.(mv_sum1 + mv_sum2); in
    let A.sum1 := [B] B.mv_result ~> A;
        A.sum2 := [C] C.mv_result ~> A; in
    let A.dot_result := A.(mv_result + sum1 + sum2); in
    let _ := A.iterate A.(count - 1) A.(dot_result + 1);
        _ := B.iterate B.(count - 1) B.0;
        _ := C.iterate C.(count - 1) C.0; in
    ();

main := (A.iterate A.10 A.0,
         B.iterate B.10 B.0),
         C.iterate C.10 C.0;

