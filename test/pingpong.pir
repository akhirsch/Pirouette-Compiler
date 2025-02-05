{- 
This program choreographes two threads, Ping and Pong. 
Ping begins with the value 100 and sends it to Pong. 
Pong decrements the value by 1 (and prints it).
Pong then passes the decremented value back to Ping.
The process continues for all numbers 100 to 1.
-}


main := 
    let Ping.x := Ping.100; in 
    let Pong.x := [Ping] Ping.x ~> Pong; in
    Ping.helper Ping.x;

helper curr :=
    let Pong.y := Pong.curr-1; in
    if Pong.(y>0)
    then Pong[L] ~> Ping;
        let Ping.x := [Pong] Pong.y ~> Ping; in
        Pong.helper Pong.x 
    else Pong[R] ~> Ping;
        Ping."done";


{- Lines 13 and 20, 
it appears the compiler may be struggling with helper 
functions since they are not a part of the necessary 
side of communication. Ping cannot comprehend Ping using
the helper and vise versa. 
In pingpong.ml, appears as () () -}


{- TO DO: add printing -}
--Ping.print_endline Ping."x"        --y errors out--      -- citation: ian/testing branch examples/ep.pir -- 