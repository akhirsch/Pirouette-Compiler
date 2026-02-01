foreign gettimeofday : unit -> unit := "@Unix:gettimeofday";
foreign print_float : unit -> unit := "@Stdlib:print_float";
foreign sub_float : unit -> unit -> unit := "@Stdlib:(-.)";

loop iter :=
    if p1.(iter > 0) then
        p1[L] ~> p2;
        p1[L] ~> p3;
        p1[L] ~> p4;
        p1[L] ~> p5;
        p1[L] ~> p6;
        p1[L] ~> p7;
        p1[L] ~> p8;
        p1[L] ~> p9;
        p1[L] ~> p10;
        p1[L] ~> p11;
        p1[L] ~> p12;
        p1[L] ~> p13;
        p1[L] ~> p14;
        p1[L] ~> p15;
        loop p1.(iter - 1)
    else
        p1[R] ~> p2;
        p1[R] ~> p3;
        p1[R] ~> p4;
        p1[R] ~> p5;
        p1[R] ~> p6;
        p1[R] ~> p7;
        p1[R] ~> p8;
        p1[R] ~> p9;
        p1[R] ~> p10;
        p1[R] ~> p11;
        p1[R] ~> p12;
        p1[R] ~> p13;
        p1[R] ~> p14;
        p1[R] ~> p15;
        p1.();

main :=
    let p1.start_time := p1.gettimeofday p1.(); in
    let p1._ := loop p1.1000000; in
    let p1.end_time := p1.gettimeofday p1.(); in
    let p1.time_diff := p1.sub_float p1.end_time p1.start_time; in
    p1.print_float p1.time_diff;
