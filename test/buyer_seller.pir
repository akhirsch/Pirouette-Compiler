{-
This program choreographes two , Buyer and Seller.
Buyer proposes a bid value and sends it to Seller.
Seller compares new bid to previous highest bid.
    Seller accepts higher new bids by sending true to Buyer. 
    OR
    Seller rejects lower new bids by sending false to Buyer.
Buyer thread recieves desision and prints a message stating successful bid acceptance or failed bid acceptance.
-}

main :=
    let Seller.highest := Seller.0; in
    -- Ideally, I would read user input here --
    let Buyer.bid := User.5; in      
    let Seller.new_bid := [Buyer] Buyer.bid ~> Seller; in  

    if Seller.(new_bid>highest)
    then Seller[R] ~> Buyer;
        let Buyer.outcome := True; in
        Buyer.outcome
    else Seller[L] ~> Buyer;
        let Buyer.outcome := False; in
        Buyer.outcome
    
    if Buyer.outcome
    then Buyer[L] ~> User;
        User."Bid not accepted."
    else Buyer[R] ~> User;
        User."Bid accepted.";
