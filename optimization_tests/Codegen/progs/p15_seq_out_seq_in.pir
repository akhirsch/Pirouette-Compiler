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
        let p1.res_1 := [p2] p2.1 ~> p1; in
        let p1.res_2 := [p3] p3.2 ~> p1; in
        let p1.res_3 := [p4] p4.3 ~> p1; in
        let p1.res_4 := [p5] p5.4 ~> p1; in
        let p1.res_5 := [p6] p6.5 ~> p1; in
        let p1.res_6 := [p7] p7.6 ~> p1; in
        let p1.res_7 := [p8] p8.7 ~> p1; in
        let p1.res_8 := [p9] p9.8 ~> p1; in
        let p1.res_9 := [p10] p10.9 ~> p1; in
        let p1.res_10 := [p11] p11.10 ~> p1; in
        let p1.res_11 := [p12] p12.11 ~> p1; in
        let p1.res_12 := [p13] p13.12 ~> p1; in
        let p1.res_13 := [p14] p14.13 ~> p1; in
        let p1.res_14 := [p15] p15.14 ~> p1; in
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
        let p1.res_1 := [p2] p2.1 ~> p1; in
        let p1.res_2 := [p3] p3.2 ~> p1; in
        let p1.res_3 := [p4] p4.3 ~> p1; in
        let p1.res_4 := [p5] p5.4 ~> p1; in
        let p1.res_5 := [p6] p6.5 ~> p1; in
        let p1.res_6 := [p7] p7.6 ~> p1; in
        let p1.res_7 := [p8] p8.7 ~> p1; in
        let p1.res_8 := [p9] p9.8 ~> p1; in
        let p1.res_9 := [p10] p10.9 ~> p1; in
        let p1.res_10 := [p11] p11.10 ~> p1; in
        let p1.res_11 := [p12] p12.11 ~> p1; in
        let p1.res_12 := [p13] p13.12 ~> p1; in
        let p1.res_13 := [p14] p14.13 ~> p1; in
        let p1.res_14 := [p15] p15.14 ~> p1; in
        p1.();

main :=
    let p1.start_time := p1.gettimeofday p1.(); in
    let p1._ := loop p1.1000000; in
    let p1.end_time := p1.gettimeofday p1.(); in
    let p1.time_diff := p1.sub_float p1.end_time p1.start_time; in
    p1.print_float p1.time_diff;
