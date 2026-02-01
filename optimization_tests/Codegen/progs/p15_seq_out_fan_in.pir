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
        let p4.res_2 := [p7] p7.2 ~> p4; in
        let p4.res_1 := [p6] p6.1 ~> p4; in
        let p5.res_2 := [p9] p9.2 ~> p5; in
        let p5.res_1 := [p8] p8.1 ~> p5; in
        let p2.res_2 := [p5] p5.2 ~> p2; in
        let p2.res_1 := [p4] p4.1 ~> p2; in
        let p10.res_2 := [p13] p13.2 ~> p10; in
        let p10.res_1 := [p12] p12.1 ~> p10; in
        let p11.res_2 := [p15] p15.2 ~> p11; in
        let p11.res_1 := [p14] p14.1 ~> p11; in
        let p3.res_2 := [p11] p11.2 ~> p3; in
        let p3.res_1 := [p10] p10.1 ~> p3; in
        let p1.res_2 := [p3] p3.2 ~> p1; in
        let p1.res_1 := [p2] p2.1 ~> p1; in
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
        let p4.res_2 := [p7] p7.2 ~> p4; in
        let p4.res_1 := [p6] p6.1 ~> p4; in
        let p5.res_2 := [p9] p9.2 ~> p5; in
        let p5.res_1 := [p8] p8.1 ~> p5; in
        let p2.res_2 := [p5] p5.2 ~> p2; in
        let p2.res_1 := [p4] p4.1 ~> p2; in
        let p10.res_2 := [p13] p13.2 ~> p10; in
        let p10.res_1 := [p12] p12.1 ~> p10; in
        let p11.res_2 := [p15] p15.2 ~> p11; in
        let p11.res_1 := [p14] p14.1 ~> p11; in
        let p3.res_2 := [p11] p11.2 ~> p3; in
        let p3.res_1 := [p10] p10.1 ~> p3; in
        let p1.res_2 := [p3] p3.2 ~> p1; in
        let p1.res_1 := [p2] p2.1 ~> p1; in
        p1.();

main :=
    let p1.start_time := p1.gettimeofday p1.(); in
    let p1._ := loop p1.1000000; in
    let p1.end_time := p1.gettimeofday p1.(); in
    let p1.time_diff := p1.sub_float p1.end_time p1.start_time; in
    p1.print_float p1.time_diff;
