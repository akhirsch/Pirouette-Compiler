foreign gettimeofday : unit -> unit := "Unix:gettimeofday";
foreign print_float : unit -> unit := "Stdlib:print_float";
foreign sub_float : unit -> unit -> unit := "Stdlib:(-.)";

broadcast_opt freq :=

    if A.(freq > 0) then
    A[L] ~> B;
    A[L] ~> C;

        let B.x := B."10"; in
	let A.result_B := [B] B.x ~> A; in 
        let C.x := C."10"; in
	let A.result_C := [C] C.x ~> A; in 	
	broadcast_opt A.(freq - 1)

    else
    A[R] ~> B;
    A[R] ~> C;    

        let B.x := B."9"; in
	let A.result_B := [B] B.x ~> A; in 
        let C.x := C."9"; in
	let A.result_C := [C] C.x ~> A; in A.();
	
main :=

    let A.start_time := A.gettimeofday A.(); in
    let A._ := broadcast_opt A.10; in
    let A.end_time := A.gettimeofday A.(); in
    let A.time_diff := A.sub_float A.end_time A.start_time; in
    A.print_float A.time_diff;