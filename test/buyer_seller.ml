let chan_Buyer_Seller = Domainslib.Chan.make_bounded 0
let chan_Buyer_User = Domainslib.Chan.make_bounded 0
let chan_Seller_Buyer = Domainslib.Chan.make_bounded 0
let chan_Seller_User = Domainslib.Chan.make_bounded 0
let chan_User_Buyer = Domainslib.Chan.make_bounded 0
let chan_User_Seller = Domainslib.Chan.make_bounded 0
let domain_Buyer =
  Domain.spawn
    (fun _ ->
       let rec new_bid_processer new_bid curr_highest =
         match Domainslib.Chan.recv chan_Seller_Buyer with
         | "R" -> new_bid
         | "L" -> ~- 1
         | _ -> failwith "Error: Unmatched label" in
       let rec _unit_3 = () in
       let rec bid = () in
       let rec _unit_2 =
         let val_1 = bid in
         Domainslib.Chan.send chan_Buyer_Seller (Marshal.to_string val_1 []) in
       let rec outcome = () in
       if outcome < 0
       then (Domainslib.Chan.send chan_Buyer_User "L"; ())
       else (Domainslib.Chan.send chan_Buyer_User "R"; ()))
let domain_Seller =
  Domain.spawn
    (fun _ ->
       let rec new_bid_processer new_bid curr_highest =
         if new_bid > highest
         then (Domainslib.Chan.send chan_Seller_Buyer "R"; ())
         else (Domainslib.Chan.send chan_Seller_Buyer "L"; ()) in
       let rec highest = 0 in
       let rec _unit_5 = () in
       let rec recieved =
         Marshal.from_string (Domainslib.Chan.recv chan_Buyer_Seller) 0 in
       let rec _unit_4 = (new_bid_processer recieved) highest in ())
let domain_User =
  Domain.spawn
    (fun _ ->
       let rec new_bid_processer new_bid curr_highest = () in
       let rec _unit_9 = () in
       let rec _unit_8 = 5 in
       let rec _unit_7 = () in
       let rec _unit_6 = () in
       match Domainslib.Chan.recv chan_Buyer_User with
       | "L" -> "Bid not accepted."
       | "R" -> "Bid accepted."
       | _ -> failwith "Error: Unmatched label")