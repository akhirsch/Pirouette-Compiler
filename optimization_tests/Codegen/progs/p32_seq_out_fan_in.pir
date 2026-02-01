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
        p1[L] ~> p32;
        let p6.res_2 := [p9] p9.2 ~> p6; in
        let p6.res_1 := [p8] p8.1 ~> p6; in
        let p7.res_2 := [p11] p11.2 ~> p7; in
        let p7.res_1 := [p10] p10.1 ~> p7; in
        let p4.res_2 := [p7] p7.2 ~> p4; in
        let p4.res_1 := [p6] p6.1 ~> p4; in
        let p12.res_2 := [p15] p15.2 ~> p12; in
        let p12.res_1 := [p14] p14.1 ~> p12; in
        let p13.res_2 := [p17] p17.2 ~> p13; in
        let p13.res_1 := [p16] p16.1 ~> p13; in
        let p5.res_2 := [p13] p13.2 ~> p5; in
        let p5.res_1 := [p12] p12.1 ~> p5; in
        let p2.res_2 := [p5] p5.2 ~> p2; in
        let p2.res_1 := [p4] p4.1 ~> p2; in
        let p20.res_2 := [p23] p23.2 ~> p20; in
        let p20.res_1 := [p22] p22.1 ~> p20; in
        let p21.res_2 := [p25] p25.2 ~> p21; in
        let p21.res_1 := [p24] p24.1 ~> p21; in
        let p18.res_2 := [p21] p21.2 ~> p18; in
        let p18.res_1 := [p20] p20.1 ~> p18; in
        let p26.res_2 := [p29] p29.2 ~> p26; in
        let p26.res_1 := [p28] p28.1 ~> p26; in
        let p31.res_1 := [p32] p32.1 ~> p31; in
        let p27.res_2 := [p31] p31.2 ~> p27; in
        let p27.res_1 := [p30] p30.1 ~> p27; in
        let p19.res_2 := [p27] p27.2 ~> p19; in
        let p19.res_1 := [p26] p26.1 ~> p19; in
        let p3.res_2 := [p19] p19.2 ~> p3; in
        let p3.res_1 := [p18] p18.1 ~> p3; in
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
        p1[R] ~> p32;
        let p6.res_2 := [p9] p9.2 ~> p6; in
        let p6.res_1 := [p8] p8.1 ~> p6; in
        let p7.res_2 := [p11] p11.2 ~> p7; in
        let p7.res_1 := [p10] p10.1 ~> p7; in
        let p4.res_2 := [p7] p7.2 ~> p4; in
        let p4.res_1 := [p6] p6.1 ~> p4; in
        let p12.res_2 := [p15] p15.2 ~> p12; in
        let p12.res_1 := [p14] p14.1 ~> p12; in
        let p13.res_2 := [p17] p17.2 ~> p13; in
        let p13.res_1 := [p16] p16.1 ~> p13; in
        let p5.res_2 := [p13] p13.2 ~> p5; in
        let p5.res_1 := [p12] p12.1 ~> p5; in
        let p2.res_2 := [p5] p5.2 ~> p2; in
        let p2.res_1 := [p4] p4.1 ~> p2; in
        let p20.res_2 := [p23] p23.2 ~> p20; in
        let p20.res_1 := [p22] p22.1 ~> p20; in
        let p21.res_2 := [p25] p25.2 ~> p21; in
        let p21.res_1 := [p24] p24.1 ~> p21; in
        let p18.res_2 := [p21] p21.2 ~> p18; in
        let p18.res_1 := [p20] p20.1 ~> p18; in
        let p26.res_2 := [p29] p29.2 ~> p26; in
        let p26.res_1 := [p28] p28.1 ~> p26; in
        let p31.res_1 := [p32] p32.1 ~> p31; in
        let p27.res_2 := [p31] p31.2 ~> p27; in
        let p27.res_1 := [p30] p30.1 ~> p27; in
        let p19.res_2 := [p27] p27.2 ~> p19; in
        let p19.res_1 := [p26] p26.1 ~> p19; in
        let p3.res_2 := [p19] p19.2 ~> p3; in
        let p3.res_1 := [p18] p18.1 ~> p3; in
        let p1.res_2 := [p3] p3.2 ~> p1; in
        let p1.res_1 := [p2] p2.1 ~> p1; in
        p1.();

main :=
    let p1.start_time := p1.gettimeofday p1.(); in
    let p1._ := loop p1.1000000; in
    let p1.end_time := p1.gettimeofday p1.(); in
    let p1.time_diff := p1.sub_float p1.end_time p1.start_time; in
    p1.print_float p1.time_diff;
