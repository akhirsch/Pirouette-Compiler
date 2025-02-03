let chan_Ping_Pong = Domainslib.Chan.make_bounded 0
let chan_Pong_Ping = Domainslib.Chan.make_bounded 0
let domain_Ping =
  Domain.spawn
    (fun _ ->
       let rec helper curr =
         let rec _unit_3 =
           let val_2 = curr in
           Domainslib.Chan.send chan_Ping_Pong (Marshal.to_string val_2 []) in
         let rec _unit_1 = () in
         let rec x =
           Marshal.from_string (Domainslib.Chan.recv chan_Pong_Ping) 0 in
         if x > 0
         then (Domainslib.Chan.send chan_Ping_Pong "L"; helper x)
         else (Domainslib.Chan.send chan_Ping_Pong "R"; print_endline "done") in
       let rec x = 100 in helper x)
let domain_Pong =
  Domain.spawn
    (fun _ ->
       let rec helper curr =
         let rec x =
           Marshal.from_string (Domainslib.Chan.recv chan_Ping_Pong) 0 in
         let rec y = x - 1 in
         let rec _unit_5 =
           let val_4 = y in
           Domainslib.Chan.send chan_Pong_Ping (Marshal.to_string val_4 []) in
         match Domainslib.Chan.recv chan_Ping_Pong with
         | "R" -> () ()
         | "L" -> () ()
         | _ -> failwith "Error: Unmatched label" in
       let rec _unit_6 = () in () ())