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
        p1[L] ~> p16;
        p1[L] ~> p17;
        p1[L] ~> p18;
        p1[L] ~> p19;
        p1[L] ~> p20;
        p1[L] ~> p21;
        p1[L] ~> p22;
        p1[L] ~> p23;
        p1[L] ~> p24;
        p1[L] ~> p25;
        p1[L] ~> p26;
        p1[L] ~> p27;
        p1[L] ~> p28;
        p1[L] ~> p29;
        p1[L] ~> p30;
        p1[L] ~> p31;
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
        let p1.res_15 := [p16] p16.15 ~> p1; in
        let p1.res_16 := [p17] p17.16 ~> p1; in
        let p1.res_17 := [p18] p18.17 ~> p1; in
        let p1.res_18 := [p19] p19.18 ~> p1; in
        let p1.res_19 := [p20] p20.19 ~> p1; in
        let p1.res_20 := [p21] p21.20 ~> p1; in
        let p1.res_21 := [p22] p22.21 ~> p1; in
        let p1.res_22 := [p23] p23.22 ~> p1; in
        let p1.res_23 := [p24] p24.23 ~> p1; in
        let p1.res_24 := [p25] p25.24 ~> p1; in
        let p1.res_25 := [p26] p26.25 ~> p1; in
        let p1.res_26 := [p27] p27.26 ~> p1; in
        let p1.res_27 := [p28] p28.27 ~> p1; in
        let p1.res_28 := [p29] p29.28 ~> p1; in
        let p1.res_29 := [p30] p30.29 ~> p1; in
        let p1.res_30 := [p31] p31.30 ~> p1; in
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
        p1[R] ~> p16;
        p1[R] ~> p17;
        p1[R] ~> p18;
        p1[R] ~> p19;
        p1[R] ~> p20;
        p1[R] ~> p21;
        p1[R] ~> p22;
        p1[R] ~> p23;
        p1[R] ~> p24;
        p1[R] ~> p25;
        p1[R] ~> p26;
        p1[R] ~> p27;
        p1[R] ~> p28;
        p1[R] ~> p29;
        p1[R] ~> p30;
        p1[R] ~> p31;
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
        let p1.res_15 := [p16] p16.15 ~> p1; in
        let p1.res_16 := [p17] p17.16 ~> p1; in
        let p1.res_17 := [p18] p18.17 ~> p1; in
        let p1.res_18 := [p19] p19.18 ~> p1; in
        let p1.res_19 := [p20] p20.19 ~> p1; in
        let p1.res_20 := [p21] p21.20 ~> p1; in
        let p1.res_21 := [p22] p22.21 ~> p1; in
        let p1.res_22 := [p23] p23.22 ~> p1; in
        let p1.res_23 := [p24] p24.23 ~> p1; in
        let p1.res_24 := [p25] p25.24 ~> p1; in
        let p1.res_25 := [p26] p26.25 ~> p1; in
        let p1.res_26 := [p27] p27.26 ~> p1; in
        let p1.res_27 := [p28] p28.27 ~> p1; in
        let p1.res_28 := [p29] p29.28 ~> p1; in
        let p1.res_29 := [p30] p30.29 ~> p1; in
        let p1.res_30 := [p31] p31.30 ~> p1; in
        p1.();

main :=
    let p1.start_time := p1.gettimeofday p1.(); in
    let p1._ := loop p1.1000000; in
    let p1.end_time := p1.gettimeofday p1.(); in
    let p1.time_diff := p1.sub_float p1.end_time p1.start_time; in
    p1.print_float p1.time_diff;
