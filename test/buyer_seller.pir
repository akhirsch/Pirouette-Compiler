{-
This program choreographes two , Buyer and Seller.
Buyer proposes a bid value and sends it to Seller.
Seller compares new bid to previous highest bid.
    Seller accepts higher new bids by sending true to Buyer. 
    OR
    Seller rejects lower new bids by sending false to Buyer.
Buyer thread recieves desision and prints a message stating successful bid acceptance or failed bid acceptance.
-}


new_bid_processer new_bid curr_highest :=
    if Seller.(new_bid>highest)
    then Seller[R] ~> Buyer;
        Buyer.new_bid
    else Seller[L] ~> Buyer;
        Buyer.(-1);

main :=
    let Seller.highest := Seller.0; in
    
    -- Ideally, I would read user input here --
    let Buyer.bid := User.5; in         
    
    let Seller.recieved := [Buyer] Buyer.bid ~> Seller; in    
    let Buyer.outcome := Seller.new_bid_processer Seller.recieved Seller.highest; in
    if Buyer.(outcome<0)
    then Buyer[L] ~> User;
        User."Bid not accepted."
    else Buyer[R] ~> User;
        User."Bid accepted."
;
