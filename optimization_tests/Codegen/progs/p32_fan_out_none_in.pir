foreign gettimeofday : unit -> unit := "@Unix:gettimeofday";
foreign print_float : unit -> unit := "@Stdlib:print_float";
foreign sub_float : unit -> unit -> unit := "@Stdlib:(-.)";

loop iter :=
    if p1.(iter > 0) then
        p1[L] ~> p2;
        p1[L] ~> p3;
        p2[L] ~> p4;
        p2[L] ~> p5;
        p4[L] ~> p6;
        p4[L] ~> p7;
        p6[L] ~> p8;
        p6[L] ~> p9;
        p7[L] ~> p10;
        p7[L] ~> p11;
        p5[L] ~> p12;
        p5[L] ~> p13;
        p12[L] ~> p14;
        p12[L] ~> p15;
        p13[L] ~> p16;
        p13[L] ~> p17;
        p3[L] ~> p18;
        p3[L] ~> p19;
        p18[L] ~> p20;
        p18[L] ~> p21;
        p20[L] ~> p22;
        p20[L] ~> p23;
        p21[L] ~> p24;
        p21[L] ~> p25;
        p19[L] ~> p26;
        p19[L] ~> p27;
        p26[L] ~> p28;
        p26[L] ~> p29;
        p27[L] ~> p30;
        p27[L] ~> p31;
        p31[L] ~> p32;
        loop p1.(iter - 1)
    else
        p1[R] ~> p2;
        p1[R] ~> p3;
        p2[R] ~> p4;
        p2[R] ~> p5;
        p4[R] ~> p6;
        p4[R] ~> p7;
        p6[R] ~> p8;
        p6[R] ~> p9;
        p7[R] ~> p10;
        p7[R] ~> p11;
        p5[R] ~> p12;
        p5[R] ~> p13;
        p12[R] ~> p14;
        p12[R] ~> p15;
        p13[R] ~> p16;
        p13[R] ~> p17;
        p3[R] ~> p18;
        p3[R] ~> p19;
        p18[R] ~> p20;
        p18[R] ~> p21;
        p20[R] ~> p22;
        p20[R] ~> p23;
        p21[R] ~> p24;
        p21[R] ~> p25;
        p19[R] ~> p26;
        p19[R] ~> p27;
        p26[R] ~> p28;
        p26[R] ~> p29;
        p27[R] ~> p30;
        p27[R] ~> p31;
        p31[R] ~> p32;
        p1.();

main :=
    let p1.start_time := p1.gettimeofday p1.(); in
    let p1._ := loop p1.1000000; in
    let p1.end_time := p1.gettimeofday p1.(); in
    let p1.time_diff := p1.sub_float p1.end_time p1.start_time; in
    p1.print_float p1.time_diff;
