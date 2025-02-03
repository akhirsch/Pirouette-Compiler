{- 
This program choreographes two threads, Ping and Pong. 
Ping begins with the value 100 and sends it to Pong. 
Pong decrements the value by 1 and prints it.
Pong then passes the decremented value back to Ping.
The process continues for all numbers 100 to 1.
-}


helper curr :=
    let Pong.x := [Ping] Ping.curr ~> Pong; in
    let Pong.y := Pong.x-1; in
    let Ping.x := [Pong] Pong.y ~> Ping; in
    --Ping.print_endline Ping."number";            --x errors out--      -- citation: ian/testing branch examples/ep.pir --
    if Ping.(x>0)
    then Ping[L] ~> Pong;
        Ping.helper Ping.x
        --Pong.print_endline Pong."number"
    else Ping[R] ~> Pong;
        Ping.print_endline Ping."done";

main := 
    let Ping.x := Ping.100; in 
    
    Ping.helper Ping.x;


{-
RUN RESULTS:
>dune exec pirc pingpong.pir

= Printed to terminal:
Entering directory '/Users/clairehuyck/Pirouette-Compiler'
Leaving directory '/Users/clairehuyck/Pirouette-Compiler'
= New files created:
pingpong.Ping.ast
pingpong.Pong.ast
pingpong.ast
pingpong.ml 


>dune exec ocamlc pingpong.ml 

= Printed to terminal:
Entering directory '/Users/clairehuyck/Pirouette-Compiler'
Leaving directory '/Users/clairehuyck/Pirouette-Compiler'
File "pingpong.ml", line 1, characters 21-49:
1 | let chan_Ping_Pong = Domainslib.Chan.make_bounded 0
                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Error: Unbound module Domainslib

-}