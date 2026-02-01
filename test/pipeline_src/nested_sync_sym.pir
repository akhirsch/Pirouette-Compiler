nested_sync n :=
    if A.(n > 0) then
        A[LB] ~> B;
        let B._ := B.print_endline B."Hit LB"; in
        A[LB] ~> C;
        let C._ := C.print_endline C."Hit LC"; in
        nested_sync A.(n - 1)
    else
        A[RB] ~> B;
        let B._ := B.print_endline B."Hit RB"; in
        A[RC] ~> C;
        let C._ := C.print_endline C."Hit RC"; in
        A.print_endline A."Done with all the syncs";

main := nested_sync A.3;