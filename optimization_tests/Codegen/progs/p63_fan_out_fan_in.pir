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
        p8[L] ~> p10;
        p8[L] ~> p11;
        p9[L] ~> p12;
        p9[L] ~> p13;
        p7[L] ~> p14;
        p7[L] ~> p15;
        p14[L] ~> p16;
        p14[L] ~> p17;
        p15[L] ~> p18;
        p15[L] ~> p19;
        p5[L] ~> p20;
        p5[L] ~> p21;
        p20[L] ~> p22;
        p20[L] ~> p23;
        p22[L] ~> p24;
        p22[L] ~> p25;
        p23[L] ~> p26;
        p23[L] ~> p27;
        p21[L] ~> p28;
        p21[L] ~> p29;
        p28[L] ~> p30;
        p28[L] ~> p31;
        p29[L] ~> p32;
        p29[L] ~> p33;
        p3[L] ~> p34;
        p3[L] ~> p35;
        p34[L] ~> p36;
        p34[L] ~> p37;
        p36[L] ~> p38;
        p36[L] ~> p39;
        p38[L] ~> p40;
        p38[L] ~> p41;
        p39[L] ~> p42;
        p39[L] ~> p43;
        p37[L] ~> p44;
        p37[L] ~> p45;
        p44[L] ~> p46;
        p44[L] ~> p47;
        p45[L] ~> p48;
        p45[L] ~> p49;
        p35[L] ~> p50;
        p35[L] ~> p51;
        p50[L] ~> p52;
        p50[L] ~> p53;
        p52[L] ~> p54;
        p52[L] ~> p55;
        p53[L] ~> p56;
        p53[L] ~> p57;
        p51[L] ~> p58;
        p51[L] ~> p59;
        p58[L] ~> p60;
        p58[L] ~> p61;
        p59[L] ~> p62;
        p59[L] ~> p63;
        let p8.res_2 := [p11] p11.2 ~> p8; in
        let p8.res_1 := [p10] p10.1 ~> p8; in
        let p9.res_2 := [p13] p13.2 ~> p9; in
        let p9.res_1 := [p12] p12.1 ~> p9; in
        let p6.res_2 := [p9] p9.2 ~> p6; in
        let p6.res_1 := [p8] p8.1 ~> p6; in
        let p14.res_2 := [p17] p17.2 ~> p14; in
        let p14.res_1 := [p16] p16.1 ~> p14; in
        let p15.res_2 := [p19] p19.2 ~> p15; in
        let p15.res_1 := [p18] p18.1 ~> p15; in
        let p7.res_2 := [p15] p15.2 ~> p7; in
        let p7.res_1 := [p14] p14.1 ~> p7; in
        let p4.res_2 := [p7] p7.2 ~> p4; in
        let p4.res_1 := [p6] p6.1 ~> p4; in
        let p22.res_2 := [p25] p25.2 ~> p22; in
        let p22.res_1 := [p24] p24.1 ~> p22; in
        let p23.res_2 := [p27] p27.2 ~> p23; in
        let p23.res_1 := [p26] p26.1 ~> p23; in
        let p20.res_2 := [p23] p23.2 ~> p20; in
        let p20.res_1 := [p22] p22.1 ~> p20; in
        let p28.res_2 := [p31] p31.2 ~> p28; in
        let p28.res_1 := [p30] p30.1 ~> p28; in
        let p29.res_2 := [p33] p33.2 ~> p29; in
        let p29.res_1 := [p32] p32.1 ~> p29; in
        let p21.res_2 := [p29] p29.2 ~> p21; in
        let p21.res_1 := [p28] p28.1 ~> p21; in
        let p5.res_2 := [p21] p21.2 ~> p5; in
        let p5.res_1 := [p20] p20.1 ~> p5; in
        let p2.res_2 := [p5] p5.2 ~> p2; in
        let p2.res_1 := [p4] p4.1 ~> p2; in
        let p38.res_2 := [p41] p41.2 ~> p38; in
        let p38.res_1 := [p40] p40.1 ~> p38; in
        let p39.res_2 := [p43] p43.2 ~> p39; in
        let p39.res_1 := [p42] p42.1 ~> p39; in
        let p36.res_2 := [p39] p39.2 ~> p36; in
        let p36.res_1 := [p38] p38.1 ~> p36; in
        let p44.res_2 := [p47] p47.2 ~> p44; in
        let p44.res_1 := [p46] p46.1 ~> p44; in
        let p45.res_2 := [p49] p49.2 ~> p45; in
        let p45.res_1 := [p48] p48.1 ~> p45; in
        let p37.res_2 := [p45] p45.2 ~> p37; in
        let p37.res_1 := [p44] p44.1 ~> p37; in
        let p34.res_2 := [p37] p37.2 ~> p34; in
        let p34.res_1 := [p36] p36.1 ~> p34; in
        let p52.res_2 := [p55] p55.2 ~> p52; in
        let p52.res_1 := [p54] p54.1 ~> p52; in
        let p53.res_2 := [p57] p57.2 ~> p53; in
        let p53.res_1 := [p56] p56.1 ~> p53; in
        let p50.res_2 := [p53] p53.2 ~> p50; in
        let p50.res_1 := [p52] p52.1 ~> p50; in
        let p58.res_2 := [p61] p61.2 ~> p58; in
        let p58.res_1 := [p60] p60.1 ~> p58; in
        let p59.res_2 := [p63] p63.2 ~> p59; in
        let p59.res_1 := [p62] p62.1 ~> p59; in
        let p51.res_2 := [p59] p59.2 ~> p51; in
        let p51.res_1 := [p58] p58.1 ~> p51; in
        let p35.res_2 := [p51] p51.2 ~> p35; in
        let p35.res_1 := [p50] p50.1 ~> p35; in
        let p3.res_2 := [p35] p35.2 ~> p3; in
        let p3.res_1 := [p34] p34.1 ~> p3; in
        let p1.res_2 := [p3] p3.2 ~> p1; in
        let p1.res_1 := [p2] p2.1 ~> p1; in
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
        p8[R] ~> p10;
        p8[R] ~> p11;
        p9[R] ~> p12;
        p9[R] ~> p13;
        p7[R] ~> p14;
        p7[R] ~> p15;
        p14[R] ~> p16;
        p14[R] ~> p17;
        p15[R] ~> p18;
        p15[R] ~> p19;
        p5[R] ~> p20;
        p5[R] ~> p21;
        p20[R] ~> p22;
        p20[R] ~> p23;
        p22[R] ~> p24;
        p22[R] ~> p25;
        p23[R] ~> p26;
        p23[R] ~> p27;
        p21[R] ~> p28;
        p21[R] ~> p29;
        p28[R] ~> p30;
        p28[R] ~> p31;
        p29[R] ~> p32;
        p29[R] ~> p33;
        p3[R] ~> p34;
        p3[R] ~> p35;
        p34[R] ~> p36;
        p34[R] ~> p37;
        p36[R] ~> p38;
        p36[R] ~> p39;
        p38[R] ~> p40;
        p38[R] ~> p41;
        p39[R] ~> p42;
        p39[R] ~> p43;
        p37[R] ~> p44;
        p37[R] ~> p45;
        p44[R] ~> p46;
        p44[R] ~> p47;
        p45[R] ~> p48;
        p45[R] ~> p49;
        p35[R] ~> p50;
        p35[R] ~> p51;
        p50[R] ~> p52;
        p50[R] ~> p53;
        p52[R] ~> p54;
        p52[R] ~> p55;
        p53[R] ~> p56;
        p53[R] ~> p57;
        p51[R] ~> p58;
        p51[R] ~> p59;
        p58[R] ~> p60;
        p58[R] ~> p61;
        p59[R] ~> p62;
        p59[R] ~> p63;
        let p8.res_2 := [p11] p11.2 ~> p8; in
        let p8.res_1 := [p10] p10.1 ~> p8; in
        let p9.res_2 := [p13] p13.2 ~> p9; in
        let p9.res_1 := [p12] p12.1 ~> p9; in
        let p6.res_2 := [p9] p9.2 ~> p6; in
        let p6.res_1 := [p8] p8.1 ~> p6; in
        let p14.res_2 := [p17] p17.2 ~> p14; in
        let p14.res_1 := [p16] p16.1 ~> p14; in
        let p15.res_2 := [p19] p19.2 ~> p15; in
        let p15.res_1 := [p18] p18.1 ~> p15; in
        let p7.res_2 := [p15] p15.2 ~> p7; in
        let p7.res_1 := [p14] p14.1 ~> p7; in
        let p4.res_2 := [p7] p7.2 ~> p4; in
        let p4.res_1 := [p6] p6.1 ~> p4; in
        let p22.res_2 := [p25] p25.2 ~> p22; in
        let p22.res_1 := [p24] p24.1 ~> p22; in
        let p23.res_2 := [p27] p27.2 ~> p23; in
        let p23.res_1 := [p26] p26.1 ~> p23; in
        let p20.res_2 := [p23] p23.2 ~> p20; in
        let p20.res_1 := [p22] p22.1 ~> p20; in
        let p28.res_2 := [p31] p31.2 ~> p28; in
        let p28.res_1 := [p30] p30.1 ~> p28; in
        let p29.res_2 := [p33] p33.2 ~> p29; in
        let p29.res_1 := [p32] p32.1 ~> p29; in
        let p21.res_2 := [p29] p29.2 ~> p21; in
        let p21.res_1 := [p28] p28.1 ~> p21; in
        let p5.res_2 := [p21] p21.2 ~> p5; in
        let p5.res_1 := [p20] p20.1 ~> p5; in
        let p2.res_2 := [p5] p5.2 ~> p2; in
        let p2.res_1 := [p4] p4.1 ~> p2; in
        let p38.res_2 := [p41] p41.2 ~> p38; in
        let p38.res_1 := [p40] p40.1 ~> p38; in
        let p39.res_2 := [p43] p43.2 ~> p39; in
        let p39.res_1 := [p42] p42.1 ~> p39; in
        let p36.res_2 := [p39] p39.2 ~> p36; in
        let p36.res_1 := [p38] p38.1 ~> p36; in
        let p44.res_2 := [p47] p47.2 ~> p44; in
        let p44.res_1 := [p46] p46.1 ~> p44; in
        let p45.res_2 := [p49] p49.2 ~> p45; in
        let p45.res_1 := [p48] p48.1 ~> p45; in
        let p37.res_2 := [p45] p45.2 ~> p37; in
        let p37.res_1 := [p44] p44.1 ~> p37; in
        let p34.res_2 := [p37] p37.2 ~> p34; in
        let p34.res_1 := [p36] p36.1 ~> p34; in
        let p52.res_2 := [p55] p55.2 ~> p52; in
        let p52.res_1 := [p54] p54.1 ~> p52; in
        let p53.res_2 := [p57] p57.2 ~> p53; in
        let p53.res_1 := [p56] p56.1 ~> p53; in
        let p50.res_2 := [p53] p53.2 ~> p50; in
        let p50.res_1 := [p52] p52.1 ~> p50; in
        let p58.res_2 := [p61] p61.2 ~> p58; in
        let p58.res_1 := [p60] p60.1 ~> p58; in
        let p59.res_2 := [p63] p63.2 ~> p59; in
        let p59.res_1 := [p62] p62.1 ~> p59; in
        let p51.res_2 := [p59] p59.2 ~> p51; in
        let p51.res_1 := [p58] p58.1 ~> p51; in
        let p35.res_2 := [p51] p51.2 ~> p35; in
        let p35.res_1 := [p50] p50.1 ~> p35; in
        let p3.res_2 := [p35] p35.2 ~> p3; in
        let p3.res_1 := [p34] p34.1 ~> p3; in
        let p1.res_2 := [p3] p3.2 ~> p1; in
        let p1.res_1 := [p2] p2.1 ~> p1; in
        p1.();

main :=
    let p1.start_time := p1.gettimeofday p1.(); in
    let p1._ := loop p1.1000000; in
    let p1.end_time := p1.gettimeofday p1.(); in
    let p1.time_diff := p1.sub_float p1.end_time p1.start_time; in
    p1.print_float p1.time_diff;
