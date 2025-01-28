main := let Pong.curr := Ping.x ~> Pong.x; in
    if Pong.(x>0)
    then 
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