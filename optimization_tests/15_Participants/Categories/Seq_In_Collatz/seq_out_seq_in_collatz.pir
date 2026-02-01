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

loop iter :=

    if P1.(iter > 0) then
    
    P1[L] ~> P2;
    P1[L] ~> P3;
    P1[L] ~> P4;
    P1[L] ~> P5;
    P1[L] ~> P6;
    P1[L] ~> P7;
    P1[L] ~> P8;
    P1[L] ~> P9;
    P1[L] ~> P10;
    P1[L] ~> P11;
    P1[L] ~> P12;
    P1[L] ~> P13;
    P1[L] ~> P14;
    P1[L] ~> P15;
    
        let P2.result  := P2.test_collatz P2.931386509544713451; in 
                  let P1.reply_P2 := [P2] P2.result ~> P1; in
        let P3.result  := P3.test_collatz P3.931386509544713451; in 
                  let P1.reply_P3 := [P3] P3.result ~> P1; in
        let P4.result  := P4.test_collatz P4.931386509544713451; in 
                  let P1.reply_P4 := [P4] P4.result ~> P1; in
        let P5.result  := P5.test_collatz P5.931386509544713451; in 
                  let P1.reply_P5 := [P5] P5.result ~> P1; in
        let P6.result  := P6.test_collatz P6.931386509544713451; in 
                  let P1.reply_P6 := [P6] P6.result ~> P1; in
        let P7.result  := P7.test_collatz P7.931386509544713451; in 
                  let P1.reply_P7 := [P7] P7.result ~> P1; in
        let P8.result  := P8.test_collatz P8.931386509544713451; in 
                  let P1.reply_P8 := [P8] P8.result ~> P1; in
        let P9.result  := P9.test_collatz P9.931386509544713451; in 
                  let P1.reply_P9 := [P9] P9.result ~> P1; in
        let P10.result  := P10.test_collatz P10.931386509544713451; in 
                  let P1.reply_P10 := [P10] P10.result ~> P1; in
        let P11.result  := P11.test_collatz P11.931386509544713451; in 
                  let P1.reply_P11 := [P11] P11.result ~> P1; in
        let P12.result  := P12.test_collatz P12.931386509544713451; in 
                  let P1.reply_P12 := [P12] P12.result ~> P1; in
        let P13.result  := P13.test_collatz P13.931386509544713451; in 
                  let P1.reply_P13 := [P13] P13.result ~> P1; in
        let P14.result  := P14.test_collatz P14.931386509544713451; in 
                  let P1.reply_P14 := [P14] P14.result ~> P1; in
        let P15.result  := P15.test_collatz P15.931386509544713451; in 
                  let P1.reply_P15 := [P15] P15.result ~> P1; in
		  loop P1.(iter - 1)

    else 

    P1[R] ~> P2;
    P1[R] ~> P3;
    P1[R] ~> P4;
    P1[R] ~> P5;
    P1[R] ~> P6;
    P1[R] ~> P7;
    P1[R] ~> P8;
    P1[R] ~> P9;
    P1[R] ~> P10;
    P1[R] ~> P11;
    P1[R] ~> P12;
    P1[R] ~> P13;
    P1[R] ~> P14;
    P1[R] ~> P15; in 
    P1.print_endline P1."Terminate - Unoptimized";


main :=
    let P1.start_time := P1.gettimeofday P1.(); in
    let P1._ := loop P1.1000000; in
    let P1.end_time := P1.gettimeofday P1.(); in
    let P1.time_diff := P1.sub_float P1.end_time P1.start_time; in
    P1.print_float P1.time_diff;