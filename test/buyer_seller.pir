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
    let Buyer.bid := Buyer.5; in                            -- Ideally, I would read user input here --
    let Seller.newbid := [Buyer] Buyer.bid ~> Seller; in
    if Seller.(newbid>highest)
    then Seller[R] ~> Buyer;
        Buyer.true;
    else Seller[L] ~> Buyer;
        Buyer.false
;


{-
RUN RESULTS:
>dune exec pirc buyer_seller.pir

=Printed to terminal:
Entering directory '/Users/clairehuyck/Pirouette-Compiler'
Leaving directory '/Users/clairehuyck/Pirouette-Compiler'
=New files created:
buyer_seller.Buyer.ast 
buyer_seller.Seller.ast 
buyer_seller.ast
buyer_seller.ml

>dune exec ocamlc buyer_seller.ml
=Printed to terminal:
Entering directory '/Users/clairehuyck/Pirouette-Compiler'
Leaving directory '/Users/clairehuyck/Pirouette-Compiler'
File "buyer_seller.ml", line 1, characters 24-52:
1 | let chan_Buyer_Seller = Domainslib.Chan.make_bounded 0
                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Error: Unbound module Domainslib
-}