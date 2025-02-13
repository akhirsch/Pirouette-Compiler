{-
helper y :=
    if A.(y>5)
    then A[R] ~> B;
        B.0
    else A[L] ~> B;
        B.1;

main :=
    let A.x := A.0; in
    let B.z := A.helper A.x; in
    if B.(z=0)
    then B[R] ~> A;
        A.True      --should be false, but still compiles
    else B[L] ~> A;
        A.False;    --should be true, but still compiles
-}


helper a :=
    let A.result := A.a+1; in
    A.result;

main :=
    let A.x := A.0; in
    let B.result := A.helper A.x; in
    if B.(result=0)
    then B[L] ~> A;
        A.true
    else B[R] ~> A;
        A.false;