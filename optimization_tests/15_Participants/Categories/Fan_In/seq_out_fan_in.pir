foreign gettimeofday : unit -> unit := "@Unix:gettimeofday";
foreign print_float : unit -> unit := "@Stdlib:print_float";
foreign sub_float : unit -> unit -> unit := "@Stdlib:(-.)";

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

        let P2.result := P2.2; in 
        let P1.reply_P2 := [P2] P2.result ~> P1; in

        let P3.result := P3.3; in 
        let P1.reply_P3 := [P3] P3.result ~> P1; in 

        let P4.result := P4.4; in 
	let P2.reply_P4 := [P4] P4.result ~> P2; in
        let P1.reply_P4 := [P2] P2.reply_P4 ~> P1; in 

        let P5.result := P5.5; in 
	let P2.reply_P5 := [P5] P5.result ~> P2; in
        let P1.reply_P5 := [P2] P2.reply_P5 ~> P1; in 

        let P6.result := P6.6; in 
        let P3.reply_P6 := [P6] P6.result ~> P3; in
        let P1.reply_P6 := [P3] P3.reply_P6 ~> P1; in 	

        let P7.result := P7.7; in 
	let P3.reply_P7 := [P7] P7.result ~> P3; in
	let P1.reply_P7 := [P3] P3.reply_P7 ~> P1; in

        let P8.result := P8.8; in 
	let P4.reply_P8 := [P8] P8.result ~> P4; in
	let P2.reply_P8 := [P4] P4.reply_P8 ~> P2; in
	let P1.reply_P8 := [P2] P2.reply_P8 ~> P1; in 

        let P9.result := P9.9; in 
	let P4.reply_P9 := [P9] P9.result ~> P4; in
	let P2.reply_P9 := [P4] P4.reply_P9 ~> P2; in
	let P1.reply_P9 := [P2] P2.reply_P9 ~> P1; in 

        let P10.result := P10.10; in 
	let P5.reply_P10 := [P10] P10.result ~> P5; in
	let P2.reply_P10 := [P5] P5.reply_P10 ~> P2; in
	let P1.reply_P10 := [P2] P2.reply_P10 ~> P1; in 

        let P11.result := P11.11; in 
	let P5.reply_P11 := [P11] P11.result ~> P5; in
	let P2.reply_P11 := [P5] P5.reply_P11 ~> P2; in
	let P1.reply_P11 := [P2] P2.reply_P11 ~> P1; in 

        let P12.result := P12.12; in 
	let P6.reply_P12 := [P12] P12.result ~> P6; in
	let P3.reply_P12 := [P6] P6.reply_P12 ~> P3; in
	let P1.reply_P12 := [P3] P3.reply_P12 ~> P1; in 

        let P13.result := P13.13; in 
	let P6.reply_P13 := [P13] P13.result ~> P6; in
	let P3.reply_P13 := [P6] P6.reply_P13 ~> P3; in
	let P1.reply_P13 := [P3] P3.reply_P13 ~> P1; in 

        let P14.result := P14.14; in 
	let P7.reply_P14 := [P14] P14.result ~> P7; in
	let P3.reply_P14 := [P7] P7.reply_P14 ~> P3; in
	let P1.reply_P14 := [P3] P3.reply_P14 ~> P1; in 

        let P15.result := P15.15; in 
	let P7.reply_P15 := [P15] P15.result ~> P7; in
	let P3.reply_P15 := [P7] P7.reply_P15 ~> P3; in
	let P1.reply_P15 := [P3] P3.reply_P15 ~> P1; in loop P1.(iter - 1)

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
        P1[R] ~> P15;
        let P1._ := P1.(); in P1.print_endline P1."Terminate Unoptimized"

main :=
    let P1.start_time := P1.gettimeofday P1.(); in
    let P1._ := loop P1.1000000; in
    let P1.end_time := P1.gettimeofday P1.(); in
    let P1.time_diff := P1.sub_float P1.end_time P1.start_time; in
    P1.print_float P1.time_diff;