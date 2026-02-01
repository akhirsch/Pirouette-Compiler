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
        p1[L] ~> p33;
        p1[L] ~> p34;
        p1[L] ~> p35;
        p1[L] ~> p36;
        p1[L] ~> p37;
        p1[L] ~> p38;
        p1[L] ~> p39;
        p1[L] ~> p40;
        p1[L] ~> p41;
        p1[L] ~> p42;
        p1[L] ~> p43;
        p1[L] ~> p44;
        p1[L] ~> p45;
        p1[L] ~> p46;
        p1[L] ~> p47;
        p1[L] ~> p48;
        p1[L] ~> p49;
        p1[L] ~> p50;
        p1[L] ~> p51;
        p1[L] ~> p52;
        p1[L] ~> p53;
        p1[L] ~> p54;
        p1[L] ~> p55;
        p1[L] ~> p56;
        p1[L] ~> p57;
        p1[L] ~> p58;
        p1[L] ~> p59;
        p1[L] ~> p60;
        p1[L] ~> p61;
        p1[L] ~> p62;
        let p8.res_1 := [p10] p10.1 ~> p8; in
        let p9.res_2 := [p12] p12.2 ~> p9; in
        let p9.res_1 := [p11] p11.1 ~> p9; in
        let p6.res_2 := [p9] p9.2 ~> p6; in
        let p6.res_1 := [p8] p8.1 ~> p6; in
        let p13.res_2 := [p16] p16.2 ~> p13; in
        let p13.res_1 := [p15] p15.1 ~> p13; in
        let p14.res_2 := [p18] p18.2 ~> p14; in
        let p14.res_1 := [p17] p17.1 ~> p14; in
        let p7.res_2 := [p14] p14.2 ~> p7; in
        let p7.res_1 := [p13] p13.1 ~> p7; in
        let p4.res_2 := [p7] p7.2 ~> p4; in
        let p4.res_1 := [p6] p6.1 ~> p4; in
        let p21.res_2 := [p24] p24.2 ~> p21; in
        let p21.res_1 := [p23] p23.1 ~> p21; in
        let p22.res_2 := [p26] p26.2 ~> p22; in
        let p22.res_1 := [p25] p25.1 ~> p22; in
        let p19.res_2 := [p22] p22.2 ~> p19; in
        let p19.res_1 := [p21] p21.1 ~> p19; in
        let p27.res_2 := [p30] p30.2 ~> p27; in
        let p27.res_1 := [p29] p29.1 ~> p27; in
        let p28.res_2 := [p32] p32.2 ~> p28; in
        let p28.res_1 := [p31] p31.1 ~> p28; in
        let p20.res_2 := [p28] p28.2 ~> p20; in
        let p20.res_1 := [p27] p27.1 ~> p20; in
        let p5.res_2 := [p20] p20.2 ~> p5; in
        let p5.res_1 := [p19] p19.1 ~> p5; in
        let p2.res_2 := [p5] p5.2 ~> p2; in
        let p2.res_1 := [p4] p4.1 ~> p2; in
        let p37.res_2 := [p40] p40.2 ~> p37; in
        let p37.res_1 := [p39] p39.1 ~> p37; in
        let p38.res_2 := [p42] p42.2 ~> p38; in
        let p38.res_1 := [p41] p41.1 ~> p38; in
        let p35.res_2 := [p38] p38.2 ~> p35; in
        let p35.res_1 := [p37] p37.1 ~> p35; in
        let p43.res_2 := [p46] p46.2 ~> p43; in
        let p43.res_1 := [p45] p45.1 ~> p43; in
        let p44.res_2 := [p48] p48.2 ~> p44; in
        let p44.res_1 := [p47] p47.1 ~> p44; in
        let p36.res_2 := [p44] p44.2 ~> p36; in
        let p36.res_1 := [p43] p43.1 ~> p36; in
        let p33.res_2 := [p36] p36.2 ~> p33; in
        let p33.res_1 := [p35] p35.1 ~> p33; in
        let p51.res_2 := [p54] p54.2 ~> p51; in
        let p51.res_1 := [p53] p53.1 ~> p51; in
        let p52.res_2 := [p56] p56.2 ~> p52; in
        let p52.res_1 := [p55] p55.1 ~> p52; in
        let p49.res_2 := [p52] p52.2 ~> p49; in
        let p49.res_1 := [p51] p51.1 ~> p49; in
        let p57.res_2 := [p60] p60.2 ~> p57; in
        let p57.res_1 := [p59] p59.1 ~> p57; in
        let p58.res_2 := [p62] p62.2 ~> p58; in
        let p58.res_1 := [p61] p61.1 ~> p58; in
        let p50.res_2 := [p58] p58.2 ~> p50; in
        let p50.res_1 := [p57] p57.1 ~> p50; in
        let p34.res_2 := [p50] p50.2 ~> p34; in
        let p34.res_1 := [p49] p49.1 ~> p34; in
        let p3.res_2 := [p34] p34.2 ~> p3; in
        let p3.res_1 := [p33] p33.1 ~> p3; in
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
        p1[R] ~> p33;
        p1[R] ~> p34;
        p1[R] ~> p35;
        p1[R] ~> p36;
        p1[R] ~> p37;
        p1[R] ~> p38;
        p1[R] ~> p39;
        p1[R] ~> p40;
        p1[R] ~> p41;
        p1[R] ~> p42;
        p1[R] ~> p43;
        p1[R] ~> p44;
        p1[R] ~> p45;
        p1[R] ~> p46;
        p1[R] ~> p47;
        p1[R] ~> p48;
        p1[R] ~> p49;
        p1[R] ~> p50;
        p1[R] ~> p51;
        p1[R] ~> p52;
        p1[R] ~> p53;
        p1[R] ~> p54;
        p1[R] ~> p55;
        p1[R] ~> p56;
        p1[R] ~> p57;
        p1[R] ~> p58;
        p1[R] ~> p59;
        p1[R] ~> p60;
        p1[R] ~> p61;
        p1[R] ~> p62;
        let p8.res_1 := [p10] p10.1 ~> p8; in
        let p9.res_2 := [p12] p12.2 ~> p9; in
        let p9.res_1 := [p11] p11.1 ~> p9; in
        let p6.res_2 := [p9] p9.2 ~> p6; in
        let p6.res_1 := [p8] p8.1 ~> p6; in
        let p13.res_2 := [p16] p16.2 ~> p13; in
        let p13.res_1 := [p15] p15.1 ~> p13; in
        let p14.res_2 := [p18] p18.2 ~> p14; in
        let p14.res_1 := [p17] p17.1 ~> p14; in
        let p7.res_2 := [p14] p14.2 ~> p7; in
        let p7.res_1 := [p13] p13.1 ~> p7; in
        let p4.res_2 := [p7] p7.2 ~> p4; in
        let p4.res_1 := [p6] p6.1 ~> p4; in
        let p21.res_2 := [p24] p24.2 ~> p21; in
        let p21.res_1 := [p23] p23.1 ~> p21; in
        let p22.res_2 := [p26] p26.2 ~> p22; in
        let p22.res_1 := [p25] p25.1 ~> p22; in
        let p19.res_2 := [p22] p22.2 ~> p19; in
        let p19.res_1 := [p21] p21.1 ~> p19; in
        let p27.res_2 := [p30] p30.2 ~> p27; in
        let p27.res_1 := [p29] p29.1 ~> p27; in
        let p28.res_2 := [p32] p32.2 ~> p28; in
        let p28.res_1 := [p31] p31.1 ~> p28; in
        let p20.res_2 := [p28] p28.2 ~> p20; in
        let p20.res_1 := [p27] p27.1 ~> p20; in
        let p5.res_2 := [p20] p20.2 ~> p5; in
        let p5.res_1 := [p19] p19.1 ~> p5; in
        let p2.res_2 := [p5] p5.2 ~> p2; in
        let p2.res_1 := [p4] p4.1 ~> p2; in
        let p37.res_2 := [p40] p40.2 ~> p37; in
        let p37.res_1 := [p39] p39.1 ~> p37; in
        let p38.res_2 := [p42] p42.2 ~> p38; in
        let p38.res_1 := [p41] p41.1 ~> p38; in
        let p35.res_2 := [p38] p38.2 ~> p35; in
        let p35.res_1 := [p37] p37.1 ~> p35; in
        let p43.res_2 := [p46] p46.2 ~> p43; in
        let p43.res_1 := [p45] p45.1 ~> p43; in
        let p44.res_2 := [p48] p48.2 ~> p44; in
        let p44.res_1 := [p47] p47.1 ~> p44; in
        let p36.res_2 := [p44] p44.2 ~> p36; in
        let p36.res_1 := [p43] p43.1 ~> p36; in
        let p33.res_2 := [p36] p36.2 ~> p33; in
        let p33.res_1 := [p35] p35.1 ~> p33; in
        let p51.res_2 := [p54] p54.2 ~> p51; in
        let p51.res_1 := [p53] p53.1 ~> p51; in
        let p52.res_2 := [p56] p56.2 ~> p52; in
        let p52.res_1 := [p55] p55.1 ~> p52; in
        let p49.res_2 := [p52] p52.2 ~> p49; in
        let p49.res_1 := [p51] p51.1 ~> p49; in
        let p57.res_2 := [p60] p60.2 ~> p57; in
        let p57.res_1 := [p59] p59.1 ~> p57; in
        let p58.res_2 := [p62] p62.2 ~> p58; in
        let p58.res_1 := [p61] p61.1 ~> p58; in
        let p50.res_2 := [p58] p58.2 ~> p50; in
        let p50.res_1 := [p57] p57.1 ~> p50; in
        let p34.res_2 := [p50] p50.2 ~> p34; in
        let p34.res_1 := [p49] p49.1 ~> p34; in
        let p3.res_2 := [p34] p34.2 ~> p3; in
        let p3.res_1 := [p33] p33.1 ~> p3; in
        let p1.res_2 := [p3] p3.2 ~> p1; in
        let p1.res_1 := [p2] p2.1 ~> p1; in
        p1.();

main :=
    let p1.start_time := p1.gettimeofday p1.(); in
    let p1._ := loop p1.1000000; in
    let p1.end_time := p1.gettimeofday p1.(); in
    let p1.time_diff := p1.sub_float p1.end_time p1.start_time; in
    p1.print_float p1.time_diff;
