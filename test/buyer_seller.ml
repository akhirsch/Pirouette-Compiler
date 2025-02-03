let chan_Buyer_Seller = Domainslib.Chan.make_bounded 0
let chan_Seller_Buyer = Domainslib.Chan.make_bounded 0
let domain_Buyer =
  Domain.spawn
    (fun _ ->
       let rec _unit_3 = () in
       let rec bid = 5 in
       let rec _unit_2 =
         let val_1 = bid in
         Domainslib.Chan.send chan_Buyer_Seller (Marshal.to_string val_1 []) in
       match Domainslib.Chan.recv chan_Seller_Buyer with
       | "L" -> false
       | "R" -> true
       | _ -> failwith "Error: Unmatched label")
let domain_Seller =
  Domain.spawn
    (fun _ ->
       let rec highest = 0 in
       let rec _unit_4 = () in
       let rec newbid =
         Marshal.from_string (Domainslib.Chan.recv chan_Buyer_Seller) 0 in
       if newbid > highest
       then (Domainslib.Chan.send chan_Seller_Buyer "R"; ())
       else (Domainslib.Chan.send chan_Seller_Buyer "L"; ()))