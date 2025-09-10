nested_sync n :=
    if A.(n > 0) then
        A[LB] ~> B;
        A[LB] ~> C;
        let B._ := B.print_endline B."Hit LB"; in
        let C._ := C.print_endline C."Hit LC"; in
        nested_sync A.(n - 1)
    else
        A[RB] ~> B;
        A[RC] ~> C;
        A.print_endline A."Done with all the syncs";

main := nested_sync A.3;
