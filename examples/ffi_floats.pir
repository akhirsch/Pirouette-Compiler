foreign gettimeofday : unit -> unit := "Unix:gettimeofday";
foreign sleep : unit -> unit := "Unix:sleep";
foreign print_float : unit -> unit := "Stdlib:print_float";
foreign sub_float : unit -> unit -> unit := "Stdlib:(-.)";

main :=
    let A.start_t := A.gettimeofday A.(); in
    let A.x := A.sleep A.1; in
    let A.end_t := A.gettimeofday A.(); in
    let A.diff := A.sub_float A.end_t A.start_t; in
    A.print_float A.diff;