foreign gettimeofday : unit -> unit := "@Unix:gettimeofday";
foreign print_float : unit -> unit := "@Stdlib:print_float";
foreign sub_float : unit -> unit -> unit := "@Stdlib:(-.)";

P1.test_collatz inp :=

        if P1.(inp = 1)
        then 
            P1.0
        else 
            let P1.res1 := P1.(inp/2); in 
            let P1.res2 := P1.(res1 * 2); in
                if P1.(res2 = inp) then
                    let P1.part_res := P1.test_collatz P1.(res1); in P1.(part_res + 1)
                else 
                    let P1.res3 := P1.(3 * inp + 1); in
                    let P1.res4 := P1.test_collatz P1.res3; in
                    P1.(1 + res4);

P2.test_collatz inp :=

        if P2.(inp = 1)
        then 
            P2.0
        else 
            let P2.res1 := P2.(inp/2); in 
            let P2.res2 := P2.(res1 * 2); in
                if P2.(res2 = inp) then
                    let P2.part_res := P2.test_collatz P2.(res1); in P2.(part_res + 1)
                else 
                    let P2.res3 := P2.(3 * inp + 1); in
                    let P2.res4 := P2.test_collatz P2.res3; in
                    P2.(1 + res4);

P3.test_collatz inp :=

        if P3.(inp = 1)
        then 
            P3.0
        else 
            let P3.res1 := P3.(inp/2); in 
            let P3.res2 := P3.(res1 * 2); in
                if P3.(res2 = inp) then
                    let P3.part_res := P3.test_collatz P3.(res1); in P3.(part_res + 1)
                else 
                    let P3.res3 := P3.(3 * inp + 1); in
                    let P3.res4 := P3.test_collatz P3.res3; in
                    P3.(1 + res4);

P4.test_collatz inp :=

        if P4.(inp = 1)
        then 
            P4.0
        else 
            let P4.res1 := P4.(inp/2); in 
            let P4.res2 := P4.(res1 * 2); in
                if P4.(res2 = inp) then
                    let P4.part_res := P4.test_collatz P4.(res1); in P4.(part_res + 1)
                else 
                    let P4.res3 := P4.(3 * inp + 1); in
                    let P4.res4 := P4.test_collatz P4.res3; in
                    P4.(1 + res4);

P5.test_collatz inp :=

        if P5.(inp = 1)
        then 
            P5.0
        else 
            let P5.res1 := P5.(inp/2); in 
            let P5.res2 := P5.(res1 * 2); in
                if P5.(res2 = inp) then
                    let P5.part_res := P5.test_collatz P5.(res1); in P5.(part_res + 1)
                else 
                    let P5.res3 := P5.(3 * inp + 1); in
                    let P5.res4 := P5.test_collatz P5.res3; in
                    P5.(1 + res4);

P6.test_collatz inp :=

        if P6.(inp = 1)
        then 
            P6.0
        else 
            let P6.res1 := P6.(inp/2); in 
            let P6.res2 := P6.(res1 * 2); in
                if P6.(res2 = inp) then
                    let P6.part_res := P6.test_collatz P6.(res1); in P6.(part_res + 1)
                else 
                    let P6.res3 := P6.(3 * inp + 1); in
                    let P6.res4 := P6.test_collatz P6.res3; in
                    P6.(1 + res4);

P7.test_collatz inp :=

        if P7.(inp = 1)
        then 
            P7.0
        else 
            let P7.res1 := P7.(inp/2); in 
            let P7.res2 := P7.(res1 * 2); in
                if P7.(res2 = inp) then
                    let P7.part_res := P7.test_collatz P7.(res1); in P7.(part_res + 1)
                else 
                    let P7.res3 := P7.(3 * inp + 1); in
                    let P7.res4 := P7.test_collatz P7.res3; in
                    P7.(1 + res4);

P8.test_collatz inp :=

        if P8.(inp = 1)
        then 
            P8.0
        else 
            let P8.res1 := P8.(inp/2); in 
            let P8.res2 := P8.(res1 * 2); in
                if P8.(res2 = inp) then
                    let P8.part_res := P8.test_collatz P8.(res1); in P8.(part_res + 1)
                else 
                    let P8.res3 := P8.(3 * inp + 1); in
                    let P8.res4 := P8.test_collatz P8.res3; in
                    P8.(1 + res4);

P9.test_collatz inp :=

        if P9.(inp = 1)
        then 
            P9.0
        else 
            let P9.res1 := P9.(inp/2); in 
            let P9.res2 := P9.(res1 * 2); in
                if P9.(res2 = inp) then
                    let P9.part_res := P9.test_collatz P9.(res1); in P9.(part_res + 1)
                else 
                    let P9.res3 := P9.(3 * inp + 1); in
                    let P9.res4 := P9.test_collatz P9.res3; in
                    P9.(1 + res4);

P10.test_collatz inp :=

        if P10.(inp = 1)
        then 
            P10.0
        else 
            let P10.res1 := P10.(inp/2); in 
            let P10.res2 := P10.(res1 * 2); in
                if P10.(res2 = inp) then
                    let P10.part_res := P10.test_collatz P10.(res1); in P10.(part_res + 1)
                else 
                    let P10.res3 := P10.(3 * inp + 1); in
                    let P10.res4 := P10.test_collatz P10.res3; in
                    P10.(1 + res4);

P11.test_collatz inp :=

        if P11.(inp = 1)
        then 
            P11.0
        else 
            let P11.res1 := P11.(inp/2); in 
            let P11.res2 := P11.(res1 * 2); in
                if P11.(res2 = inp) then
                    let P11.part_res := P11.test_collatz P11.(res1); in P11.(part_res + 1)
                else 
                    let P11.res3 := P11.(3 * inp + 1); in
                    let P11.res4 := P11.test_collatz P11.res3; in
                    P11.(1 + res4);

P12.test_collatz inp :=

        if P12.(inp = 1)
        then 
            P12.0
        else 
            let P12.res1 := P12.(inp/2); in 
            let P12.res2 := P12.(res1 * 2); in
                if P12.(res2 = inp) then
                    let P12.part_res := P12.test_collatz P12.(res1); in P12.(part_res + 1)
                else 
                    let P12.res3 := P12.(3 * inp + 1); in
                    let P12.res4 := P12.test_collatz P12.res3; in
                    P12.(1 + res4);

P13.test_collatz inp :=

        if P13.(inp = 1)
        then 
            P13.0
        else 
            let P13.res1 := P13.(inp/2); in 
            let P13.res2 := P13.(res1 * 2); in
                if P13.(res2 = inp) then
                    let P13.part_res := P13.test_collatz P13.(res1); in P13.(part_res + 1)
                else 
                    let P13.res3 := P13.(3 * inp + 1); in
                    let P13.res4 := P13.test_collatz P13.res3; in
                    P13.(1 + res4);

P14.test_collatz inp :=

        if P14.(inp = 1)
        then 
            P14.0
        else 
            let P14.res1 := P14.(inp/2); in 
            let P14.res2 := P14.(res1 * 2); in
                if P14.(res2 = inp) then
                    let P14.part_res := P14.test_collatz P14.(res1); in P14.(part_res + 1)
                else 
                    let P14.res3 := P14.(3 * inp + 1); in
                    let P14.res4 := P14.test_collatz P14.res3; in
                    P14.(1 + res4);

P15.test_collatz inp :=

        if P15.(inp = 1)
        then 
            P15.0
        else 
            let P15.res1 := P15.(inp/2); in 
            let P15.res2 := P15.(res1 * 2); in
                if P15.(res2 = inp) then
                    let P15.part_res := P15.test_collatz P15.(res1); in P15.(part_res + 1)
                else 
                    let P15.res3 := P15.(3 * inp + 1); in
                    let P15.res4 := P15.test_collatz P15.res3; in
                    P15.(1 + res4);

P16.test_collatz inp :=

        if P16.(inp = 1)
        then 
            P16.0
        else 
            let P16.res1 := P16.(inp/2); in 
            let P16.res2 := P16.(res1 * 2); in
                if P16.(res2 = inp) then
                    let P16.part_res := P16.test_collatz P16.(res1); in P16.(part_res + 1)
                else 
                    let P16.res3 := P16.(3 * inp + 1); in
                    let P16.res4 := P16.test_collatz P16.res3; in
                    P16.(1 + res4);

P17.test_collatz inp :=

        if P17.(inp = 1)
        then 
            P17.0
        else 
            let P17.res1 := P17.(inp/2); in 
            let P17.res2 := P17.(res1 * 2); in
                if P17.(res2 = inp) then
                    let P17.part_res := P17.test_collatz P17.(res1); in P17.(part_res + 1)
                else 
                    let P17.res3 := P17.(3 * inp + 1); in
                    let P17.res4 := P17.test_collatz P17.res3; in
                    P17.(1 + res4);

P18.test_collatz inp :=

        if P18.(inp = 1)
        then 
            P18.0
        else 
            let P18.res1 := P18.(inp/2); in 
            let P18.res2 := P18.(res1 * 2); in
                if P18.(res2 = inp) then
                    let P18.part_res := P18.test_collatz P18.(res1); in P18.(part_res + 1)
                else 
                    let P18.res3 := P18.(3 * inp + 1); in
                    let P18.res4 := P18.test_collatz P18.res3; in
                    P18.(1 + res4);

P19.test_collatz inp :=

        if P19.(inp = 1)
        then 
            P19.0
        else 
            let P19.res1 := P19.(inp/2); in 
            let P19.res2 := P19.(res1 * 2); in
                if P19.(res2 = inp) then
                    let P19.part_res := P19.test_collatz P19.(res1); in P19.(part_res + 1)
                else 
                    let P19.res3 := P19.(3 * inp + 1); in
                    let P19.res4 := P19.test_collatz P19.res3; in
                    P19.(1 + res4);

P20.test_collatz inp :=

        if P20.(inp = 1)
        then 
            P20.0
        else 
            let P20.res1 := P20.(inp/2); in 
            let P20.res2 := P20.(res1 * 2); in
                if P20.(res2 = inp) then
                    let P20.part_res := P20.test_collatz P20.(res1); in P20.(part_res + 1)
                else 
                    let P20.res3 := P20.(3 * inp + 1); in
                    let P20.res4 := P20.test_collatz P20.res3; in
                    P20.(1 + res4);

P21.test_collatz inp :=

        if P21.(inp = 1)
        then 
            P21.0
        else 
            let P21.res1 := P21.(inp/2); in 
            let P21.res2 := P21.(res1 * 2); in
                if P21.(res2 = inp) then
                    let P21.part_res := P21.test_collatz P21.(res1); in P21.(part_res + 1)
                else 
                    let P21.res3 := P21.(3 * inp + 1); in
                    let P21.res4 := P21.test_collatz P21.res3; in
                    P21.(1 + res4);

P22.test_collatz inp :=

        if P22.(inp = 1)
        then 
            P22.0
        else 
            let P22.res1 := P22.(inp/2); in 
            let P22.res2 := P22.(res1 * 2); in
                if P22.(res2 = inp) then
                    let P22.part_res := P22.test_collatz P22.(res1); in P22.(part_res + 1)
                else 
                    let P22.res3 := P22.(3 * inp + 1); in
                    let P22.res4 := P22.test_collatz P22.res3; in
                    P22.(1 + res4);

P23.test_collatz inp :=

        if P23.(inp = 1)
        then 
            P23.0
        else 
            let P23.res1 := P23.(inp/2); in 
            let P23.res2 := P23.(res1 * 2); in
                if P23.(res2 = inp) then
                    let P23.part_res := P23.test_collatz P23.(res1); in P23.(part_res + 1)
                else 
                    let P23.res3 := P23.(3 * inp + 1); in
                    let P23.res4 := P23.test_collatz P23.res3; in
                    P23.(1 + res4);

P24.test_collatz inp :=

        if P24.(inp = 1)
        then 
            P24.0
        else 
            let P24.res1 := P24.(inp/2); in 
            let P24.res2 := P24.(res1 * 2); in
                if P24.(res2 = inp) then
                    let P24.part_res := P24.test_collatz P24.(res1); in P24.(part_res + 1)
                else 
                    let P24.res3 := P24.(3 * inp + 1); in
                    let P24.res4 := P24.test_collatz P24.res3; in
                    P24.(1 + res4);

P25.test_collatz inp :=

        if P25.(inp = 1)
        then 
            P25.0
        else 
            let P25.res1 := P25.(inp/2); in 
            let P25.res2 := P25.(res1 * 2); in
                if P25.(res2 = inp) then
                    let P25.part_res := P25.test_collatz P25.(res1); in P25.(part_res + 1)
                else 
                    let P25.res3 := P25.(3 * inp + 1); in
                    let P25.res4 := P25.test_collatz P25.res3; in
                    P25.(1 + res4);

P26.test_collatz inp :=

        if P26.(inp = 1)
        then 
            P26.0
        else 
            let P26.res1 := P26.(inp/2); in 
            let P26.res2 := P26.(res1 * 2); in
                if P26.(res2 = inp) then
                    let P26.part_res := P26.test_collatz P26.(res1); in P26.(part_res + 1)
                else 
                    let P26.res3 := P26.(3 * inp + 1); in
                    let P26.res4 := P26.test_collatz P26.res3; in
                    P26.(1 + res4);

P27.test_collatz inp :=

        if P27.(inp = 1)
        then 
            P27.0
        else 
            let P27.res1 := P27.(inp/2); in 
            let P27.res2 := P27.(res1 * 2); in
                if P27.(res2 = inp) then
                    let P27.part_res := P27.test_collatz P27.(res1); in P27.(part_res + 1)
                else 
                    let P27.res3 := P27.(3 * inp + 1); in
                    let P27.res4 := P27.test_collatz P27.res3; in
                    P27.(1 + res4);

P28.test_collatz inp :=

        if P28.(inp = 1)
        then 
            P28.0
        else 
            let P28.res1 := P28.(inp/2); in 
            let P28.res2 := P28.(res1 * 2); in
                if P28.(res2 = inp) then
                    let P28.part_res := P28.test_collatz P28.(res1); in P28.(part_res + 1)
                else 
                    let P28.res3 := P28.(3 * inp + 1); in
                    let P28.res4 := P28.test_collatz P28.res3; in
                    P28.(1 + res4);

P29.test_collatz inp :=

        if P29.(inp = 1)
        then 
            P29.0
        else 
            let P29.res1 := P29.(inp/2); in 
            let P29.res2 := P29.(res1 * 2); in
                if P29.(res2 = inp) then
                    let P29.part_res := P29.test_collatz P29.(res1); in P29.(part_res + 1)
                else 
                    let P29.res3 := P29.(3 * inp + 1); in
                    let P29.res4 := P29.test_collatz P29.res3; in
                    P29.(1 + res4);

P30.test_collatz inp :=

        if P30.(inp = 1)
        then 
            P30.0
        else 
            let P30.res1 := P30.(inp/2); in 
            let P30.res2 := P30.(res1 * 2); in
                if P30.(res2 = inp) then
                    let P30.part_res := P30.test_collatz P30.(res1); in P30.(part_res + 1)
                else 
                    let P30.res3 := P30.(3 * inp + 1); in
                    let P30.res4 := P30.test_collatz P30.res3; in
                    P30.(1 + res4);

P31.test_collatz inp :=

        if P31.(inp = 1)
        then 
            P31.0
        else 
            let P31.res1 := P31.(inp/2); in 
            let P31.res2 := P31.(res1 * 2); in
                if P31.(res2 = inp) then
                    let P31.part_res := P31.test_collatz P31.(res1); in P31.(part_res + 1)
                else 
                    let P31.res3 := P31.(3 * inp + 1); in
                    let P31.res4 := P31.test_collatz P31.res3; in
                    P31.(1 + res4);

loop iter :=

    if P1.(iter > 0) then
    
        P1[L] ~> P2;
        P1[L] ~> P3;
        P2[L] ~> P4;
        P2[L] ~> P5;
        P3[L] ~> P6;
        P3[L] ~> P7;
        P4[L] ~> P8;
        P4[L] ~> P9;
        P5[L] ~> P10;
        P5[L] ~> P11;
        P6[L] ~> P12;
        P6[L] ~> P13;
        P7[L] ~> P14;
        P7[L] ~> P15;
	P8[L] ~> P16;
	P8[L] ~> P17;
	P9[L] ~> P18;
	P9[L] ~> P19;
	P10[L] ~> P20;
	P10[L] ~> P21;
	P11[L] ~> P22;
	P11[L] ~> P23;
	P12[L] ~> P24;
	P12[L] ~> P25;
	P13[L] ~> P26;
	P13[L] ~> P27;
	P14[L] ~> P28;
	P14[L] ~> P29;
	P15[L] ~> P30;
	P15[L] ~> P31;

        let P2.result  := P2.test_collatz P2.931386509544713451; in 
        let P1.reply_P2 := [P2] P2.result ~> P1; in

        let P3.result  := P3.test_collatz P3.931386509544713451; in
        let P1.reply_P3 := [P3] P3.result ~> P1; in 

        let P4.result  := P4.test_collatz P4.931386509544713451; in
	let P2.reply_P4 := [P4] P4.result ~> P2; in
        let P1.reply_P4 := [P2] P2.reply_P4 ~> P1; in 

        let P5.result  := P5.test_collatz P5.931386509544713451; in
	let P2.reply_P5 := [P5] P5.result ~> P2; in
        let P1.reply_P5 := [P2] P2.reply_P5 ~> P1; in 

        let P6.result  := P6.test_collatz P6.931386509544713451; in 
        let P3.reply_P6 := [P6] P6.result ~> P3; in
        let P1.reply_P6 := [P3] P3.reply_P6 ~> P1; in 	

        let P7.result  := P7.test_collatz P7.931386509544713451; in
	let P3.reply_P7 := [P7] P7.result ~> P3; in
	let P1.reply_P7 := [P3] P3.reply_P7 ~> P1; in

        let P8.result  := P8.test_collatz P8.931386509544713451; in
	let P4.reply_P8 := [P8] P8.result ~> P4; in
	let P2.reply_P8 := [P4] P4.reply_P8 ~> P2; in
	let P1.reply_P8 := [P2] P2.reply_P8 ~> P1; in 

        let P9.result  := P9.test_collatz P9.931386509544713451; in
	let P4.reply_P9 := [P9] P9.result ~> P4; in
	let P2.reply_P9 := [P4] P4.reply_P9 ~> P2; in
	let P1.reply_P9 := [P2] P2.reply_P9 ~> P1; in 

        let P10.result  := P10.test_collatz P10.931386509544713451; in
	let P5.reply_P10 := [P10] P10.result ~> P5; in
	let P2.reply_P10 := [P5] P5.reply_P10 ~> P2; in
	let P1.reply_P10 := [P2] P2.reply_P10 ~> P1; in 

        let P11.result  := P11.test_collatz P11.931386509544713451; in
	let P5.reply_P11 := [P11] P11.result ~> P5; in
	let P2.reply_P11 := [P5] P5.reply_P11 ~> P2; in
	let P1.reply_P11 := [P2] P2.reply_P11 ~> P1; in 

        let P12.result  := P12.test_collatz P12.931386509544713451; in
	let P6.reply_P12 := [P12] P12.result ~> P6; in
	let P3.reply_P12 := [P6] P6.reply_P12 ~> P3; in
	let P1.reply_P12 := [P3] P3.reply_P12 ~> P1; in 

        let P13.result  := P13.test_collatz P13.931386509544713451; in
	let P6.reply_P13 := [P13] P13.result ~> P6; in
	let P3.reply_P13 := [P6] P6.reply_P13 ~> P3; in
	let P1.reply_P13 := [P3] P3.reply_P13 ~> P1; in 

        let P14.result  := P14.test_collatz P14.931386509544713451; in
	let P7.reply_P14 := [P14] P14.result ~> P7; in
	let P3.reply_P14 := [P7] P7.reply_P14 ~> P3; in
	let P1.reply_P14 := [P3] P3.reply_P14 ~> P1; in 

        let P15.result  := P15.test_collatz P15.931386509544713451; in
	let P7.reply_P15 := [P15] P15.result ~> P7; in
	let P3.reply_P15 := [P7] P7.reply_P15 ~> P3; in
	let P1.reply_P15 := [P3] P3.reply_P15 ~> P1; in 

        let P16.result  := P16.test_collatz P16.931386509544713451; in
	let P8.reply_P16 := [P16] P16.result ~> P8; in
	let P4.reply_P16 := [P8] P8.reply_P16 ~> P4; in
 	let P2.reply_P16 := [P4] P4.reply_P16 ~> P2; in
	let P1.reply_P16 := [P2] P2.reply_P16 ~> P1; in 

        let P17.result  := P17.test_collatz P17.931386509544713451; in
	let P8.reply_P17 := [P17] P17.result ~> P8; in
	let P4.reply_P17 := [P8] P8.reply_P17 ~> P4; in
 	let P2.reply_P17 := [P4] P4.reply_P17 ~> P2; in
	let P1.reply_P17 := [P2] P2.reply_P17 ~> P1; in 

        let P18.result  := P18.test_collatz P18.931386509544713451; in
	let P9.reply_P18 := [P18] P18.result ~> P9; in
	let P4.reply_P18 := [P9] P9.reply_P18 ~> P4; in
 	let P2.reply_P18 := [P4] P4.reply_P18 ~> P2; in
	let P1.reply_P18 := [P2] P2.reply_P18 ~> P1; in 

        let P19.result  := P19.test_collatz P19.931386509544713451; in
	let P9.reply_P19 := [P19] P19.result ~> P9; in
	let P4.reply_P19 := [P9] P9.reply_P19 ~> P4; in
 	let P2.reply_P19 := [P4] P4.reply_P19 ~> P2; in
	let P1.reply_P19 := [P2] P2.reply_P19 ~> P1; in 

        let P20.result  := P20.test_collatz P20.931386509544713451; in
	let P10.reply_P20 := [P20] P20.result ~> P10; in
	let P5.reply_P20 := [P10] P10.reply_P20 ~> P5; in
 	let P2.reply_P20 := [P5] P5.reply_P20 ~> P2; in
	let P1.reply_P20 := [P2] P2.reply_P20 ~> P1; in 

        let P21.result  := P21.test_collatz P21.931386509544713451; in
	let P10.reply_P21 := [P21] P21.result ~> P10; in
	let P5.reply_P21 := [P10] P10.reply_P21 ~> P5; in
 	let P2.reply_P21 := [P5] P5.reply_P21 ~> P2; in
	let P1.reply_P21 := [P2] P2.reply_P21 ~> P1; in 

        let P22.result  := P22.test_collatz P22.931386509544713451; in
	let P11.reply_P22 := [P22] P22.result ~> P11; in
	let P5.reply_P22 := [P11] P11.reply_P22 ~> P5; in
 	let P2.reply_P22 := [P5] P5.reply_P22 ~> P2; in
	let P1.reply_P22 := [P2] P2.reply_P22 ~> P1; in 

        let P23.result  := P23.test_collatz P23.931386509544713451; in
	let P11.reply_P23 := [P23] P23.result ~> P11; in
	let P5.reply_P23 := [P11] P11.reply_P23 ~> P5; in
 	let P2.reply_P23 := [P5] P5.reply_P23 ~> P2; in
	let P1.reply_P23 := [P2] P2.reply_P23 ~> P1; in 

        let P24.result  := P24.test_collatz P24.931386509544713451; in
	let P12.reply_P24 := [P24] P24.result ~> P12; in
	let P6.reply_P24 := [P12] P12.reply_P24 ~> P6; in
 	let P3.reply_P24 := [P6] P6.reply_P24 ~> P3; in
	let P1.reply_P24 := [P3] P3.reply_P24 ~> P1; in 

        let P25.result  := P25.test_collatz P25.931386509544713451; in
	let P12.reply_P25 := [P25] P25.result ~> P12; in
	let P6.reply_P25 := [P12] P12.reply_P25 ~> P6; in
 	let P3.reply_P25 := [P6] P6.reply_P25 ~> P3; in
	let P1.reply_P25 := [P3] P3.reply_P25 ~> P1; in 

        let P26.result  := P26.test_collatz P26.931386509544713451; in
	let P13.reply_P26 := [P26] P26.result ~> P13; in
	let P6.reply_P26 := [P13] P13.reply_P26 ~> P6; in
 	let P3.reply_P26 := [P6] P6.reply_P26 ~> P3; in
	let P1.reply_P26 := [P3] P3.reply_P26 ~> P1; in 

        let P27.result  := P27.test_collatz P27.931386509544713451; in
	let P13.reply_P27 := [P27] P27.result ~> P13; in
	let P6.reply_P27 := [P13] P13.reply_P27 ~> P6; in
 	let P3.reply_P27 := [P6] P6.reply_P27 ~> P3; in
	let P1.reply_P27 := [P3] P3.reply_P27 ~> P1; in 

        let P28.result  := P28.test_collatz P28.931386509544713451; in
	let P14.reply_P28 := [P28] P28.result ~> P14; in
	let P7.reply_P28 := [P14] P14.reply_P28 ~> P7; in
 	let P3.reply_P28 := [P7] P7.reply_P28 ~> P3; in
	let P1.reply_P28 := [P3] P3.reply_P28 ~> P1; in 

        let P29.result  := P29.test_collatz P29.931386509544713451; in
	let P14.reply_P29 := [P29] P29.result ~> P14; in
	let P7.reply_P29 := [P14] P14.reply_P29 ~> P7; in
 	let P3.reply_P29 := [P7] P7.reply_P29 ~> P3; in
	let P1.reply_P29 := [P3] P3.reply_P29 ~> P1; in 

        let P30.result  := P30.test_collatz P30.931386509544713451; in
	let P15.reply_P30 := [P30] P30.result ~> P15; in
	let P7.reply_P30 := [P15] P15.reply_P30 ~> P7; in
 	let P3.reply_P30 := [P7] P7.reply_P30 ~> P3; in
	let P1.reply_P30 := [P3] P3.reply_P30 ~> P1; in 

        let P31.result  := P31.test_collatz P31.931386509544713451; in
	let P15.reply_P31 := [P31] P31.result ~> P15; in
	let P7.reply_P31 := [P15] P15.reply_P31 ~> P7; in
 	let P3.reply_P31 := [P7] P7.reply_P31 ~> P3; in
	let P1.reply_P31 := [P3] P3.reply_P31 ~> P1; in loop P1.(iter - 1)

    else

        P1[R] ~> P2;
        P1[R] ~> P3;
        P2[R] ~> P4;
        P2[R] ~> P5;
        P3[R] ~> P6;
        P3[R] ~> P7;
        P4[R] ~> P8;
        P4[R] ~> P9;
        P5[R] ~> P10;
        P5[R] ~> P11;
        P6[R] ~> P12;
        P6[R] ~> P13;
        P7[R] ~> P14;
        P7[R] ~> P15;
	P8[R] ~> P16;
	P8[R] ~> P17;
	P9[R] ~> P18;
	P9[R] ~> P19;
	P10[R] ~> P20;
	P10[R] ~> P21;
	P11[R] ~> P22;
	P11[R] ~> P23;
	P12[R] ~> P24;
	P12[R] ~> P25;
	P13[R] ~> P26;
	P13[R] ~> P27;
	P14[R] ~> P28;
	P14[R] ~> P29;
	P15[R] ~> P30;
	P15[R] ~> P31;

        P1.();

main :=
    let P1.start_time := P1.gettimeofday P1.(); in
    let P1._ := loop P1.100; in
    let P1.end_time := P1.gettimeofday P1.(); in
    let P1.time_diff := P1.sub_float P1.end_time P1.start_time; in
    P1.print_float P1.time_diff;