{- 
This program choreographes two threads, Ping and Pong. 
Ping begins with the value 100 and sends it to Pong. 
Pong decrements the value by 1 and prints it.
Pong then passes the decremented value back to Ping.
The process continues for all numbers > 0.
 -}

helper curr :=
    curr ~> Pong.x;
    let Pong.x := Pong.(x)-1 in     --? Pong.(x-1) ?--
    Pong.print_int Pong.x;          -- I want to print x here but that is not a pirouette feature --
    Pong.x ~> Ping.x; 
    if Ping.(x>0)
    then helper Ping.x
;

main := 
    let Ping.x := 100 in
    if Ping.(x>0)
    then helper Ping.x
;


{-
NetIR:
    Ping:
    let x = 100 in
    while x > 0
    do 
        send x to Ping;
        let x = recieve from Pong;

    Pong:
    let x = recieve from Ping in
    let x = x-1 in
    print "i: " ^ Pong.x;
    send x to Pong
-}