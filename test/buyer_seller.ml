let chan_Buyer_Seller = Domainslib.Chan.make_bounded 0
let chan_Buyer_User = Domainslib.Chan.make_bounded 0
let chan_Seller_Buyer = Domainslib.Chan.make_bounded 0
let chan_Seller_User = Domainslib.Chan.make_bounded 0
let chan_User_Buyer = Domainslib.Chan.make_bounded 0
let chan_User_Seller = Domainslib.Chan.make_bounded 0
let domain_Buyer =
  Domain.spawn
    (fun _ ->
       let rec _unit_3 = () in
       let rec bid = () in
       let rec _unit_2 =
         let val_1 = bid in
         Domainslib.Chan.send chan_Buyer_Seller (Marshal.to_string val_1 []) in
       if ()
       then let rec outcome = () in ()
       else (let rec outcome = () in ()))
let domain_Seller =
  Domain.spawn
    (fun _ ->
       let rec highest = 0 in
       let rec _unit_6 = () in
       let rec new_bid =
         Marshal.from_string (Domainslib.Chan.recv chan_Buyer_Seller) 0 in
       if new_bid > highest
       then
         (Domainslib.Chan.send chan_Seller_User "R";
          (let rec _unit_5 = () in ()))
       else
         (Domainslib.Chan.send chan_Seller_User "L";
          (let rec _unit_4 = () in ())))
let domain_User =
  Domain.spawn
    (fun _ ->
       let rec _unit_11 = () in
       let rec _unit_10 = 5 in
       let rec _unit_9 = () in
       match Domainslib.Chan.recv chan_Seller_User with
       | "L" -> let rec _unit_7 = () in "Bid accepted."
       | "R" -> let rec _unit_8 = () in "Bid not accepted."
       | _ -> failwith "Error: Unmatched label")