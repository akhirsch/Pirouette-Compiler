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
        p63[L] ~> p64;
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
        let p1.res_31 := [p32] p32.31 ~> p1; in
        let p1.res_32 := [p33] p33.32 ~> p1; in
        let p1.res_33 := [p34] p34.33 ~> p1; in
        let p1.res_34 := [p35] p35.34 ~> p1; in
        let p1.res_35 := [p36] p36.35 ~> p1; in
        let p1.res_36 := [p37] p37.36 ~> p1; in
        let p1.res_37 := [p38] p38.37 ~> p1; in
        let p1.res_38 := [p39] p39.38 ~> p1; in
        let p1.res_39 := [p40] p40.39 ~> p1; in
        let p1.res_40 := [p41] p41.40 ~> p1; in
        let p1.res_41 := [p42] p42.41 ~> p1; in
        let p1.res_42 := [p43] p43.42 ~> p1; in
        let p1.res_43 := [p44] p44.43 ~> p1; in
        let p1.res_44 := [p45] p45.44 ~> p1; in
        let p1.res_45 := [p46] p46.45 ~> p1; in
        let p1.res_46 := [p47] p47.46 ~> p1; in
        let p1.res_47 := [p48] p48.47 ~> p1; in
        let p1.res_48 := [p49] p49.48 ~> p1; in
        let p1.res_49 := [p50] p50.49 ~> p1; in
        let p1.res_50 := [p51] p51.50 ~> p1; in
        let p1.res_51 := [p52] p52.51 ~> p1; in
        let p1.res_52 := [p53] p53.52 ~> p1; in
        let p1.res_53 := [p54] p54.53 ~> p1; in
        let p1.res_54 := [p55] p55.54 ~> p1; in
        let p1.res_55 := [p56] p56.55 ~> p1; in
        let p1.res_56 := [p57] p57.56 ~> p1; in
        let p1.res_57 := [p58] p58.57 ~> p1; in
        let p1.res_58 := [p59] p59.58 ~> p1; in
        let p1.res_59 := [p60] p60.59 ~> p1; in
        let p1.res_60 := [p61] p61.60 ~> p1; in
        let p1.res_61 := [p62] p62.61 ~> p1; in
        let p1.res_62 := [p63] p63.62 ~> p1; in
        let p1.res_63 := [p64] p64.63 ~> p1; in
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
        p63[R] ~> p64;
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
        let p1.res_31 := [p32] p32.31 ~> p1; in
        let p1.res_32 := [p33] p33.32 ~> p1; in
        let p1.res_33 := [p34] p34.33 ~> p1; in
        let p1.res_34 := [p35] p35.34 ~> p1; in
        let p1.res_35 := [p36] p36.35 ~> p1; in
        let p1.res_36 := [p37] p37.36 ~> p1; in
        let p1.res_37 := [p38] p38.37 ~> p1; in
        let p1.res_38 := [p39] p39.38 ~> p1; in
        let p1.res_39 := [p40] p40.39 ~> p1; in
        let p1.res_40 := [p41] p41.40 ~> p1; in
        let p1.res_41 := [p42] p42.41 ~> p1; in
        let p1.res_42 := [p43] p43.42 ~> p1; in
        let p1.res_43 := [p44] p44.43 ~> p1; in
        let p1.res_44 := [p45] p45.44 ~> p1; in
        let p1.res_45 := [p46] p46.45 ~> p1; in
        let p1.res_46 := [p47] p47.46 ~> p1; in
        let p1.res_47 := [p48] p48.47 ~> p1; in
        let p1.res_48 := [p49] p49.48 ~> p1; in
        let p1.res_49 := [p50] p50.49 ~> p1; in
        let p1.res_50 := [p51] p51.50 ~> p1; in
        let p1.res_51 := [p52] p52.51 ~> p1; in
        let p1.res_52 := [p53] p53.52 ~> p1; in
        let p1.res_53 := [p54] p54.53 ~> p1; in
        let p1.res_54 := [p55] p55.54 ~> p1; in
        let p1.res_55 := [p56] p56.55 ~> p1; in
        let p1.res_56 := [p57] p57.56 ~> p1; in
        let p1.res_57 := [p58] p58.57 ~> p1; in
        let p1.res_58 := [p59] p59.58 ~> p1; in
        let p1.res_59 := [p60] p60.59 ~> p1; in
        let p1.res_60 := [p61] p61.60 ~> p1; in
        let p1.res_61 := [p62] p62.61 ~> p1; in
        let p1.res_62 := [p63] p63.62 ~> p1; in
        let p1.res_63 := [p64] p64.63 ~> p1; in
        p1.();

main :=
    let p1.start_time := p1.gettimeofday p1.(); in
    let p1._ := loop p1.1000000; in
    let p1.end_time := p1.gettimeofday p1.(); in
    let p1.time_diff := p1.sub_float p1.end_time p1.start_time; in
    p1.print_float p1.time_diff;
