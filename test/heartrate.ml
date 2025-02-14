let chan_AGC_LPF = Domainslib.Chan.make_bounded 0
let chan_LPF_AGC = Domainslib.Chan.make_bounded 0
let domain_AGC =
  Domain.spawn
    (fun _ ->
       let rec heartrate a b =
         let rec _unit_6 = () in
         let rec _unit_5 = () in
         let rec x = a in
         let rec y = b in
         match Domainslib.Chan.recv chan_LPF_AGC with
         | "R" -> () 
         | "L" ->
             let rec _unit_4 =
               let val_3 = x in
               Domainslib.Chan.send chan_AGC_LPF (Marshal.to_string val_3 []) in
             if y <> 0
             then
               (Domainslib.Chan.send chan_AGC_LPF "L";
                (let rec _unit_2 =
                   let val_1 = y in
                   Domainslib.Chan.send chan_AGC_LPF
                     (Marshal.to_string val_1 []) in
                 ()))
             else (Domainslib.Chan.send chan_AGC_LPF "R"; ())
         | _ -> failwith "Error: Unmatched label" in
       (heartrate 1) 1)
let domain_LPF =
  Domain.spawn
    (fun _ ->
       let rec heartrate a b =
         let rec x = 0 in
         let rec y = 0 in
         let rec _unit_8 = () in
         let rec _unit_7 = () in
         if x <> 0
         then
           (Domainslib.Chan.send chan_LPF_AGC "L";
            (let rec x =
               Marshal.from_string (Domainslib.Chan.recv chan_AGC_LPF) 0 in
             match Domainslib.Chan.recv chan_AGC_LPF with
             | "R" -> (x + y) / 2
             | "L" ->
                 let rec y =
                   Marshal.from_string (Domainslib.Chan.recv chan_AGC_LPF) 0 in
                 (x + y) / 2
             | _ -> failwith "Error: Unmatched label"))
         else (Domainslib.Chan.send chan_LPF_AGC "R"; ((x + y) / 2) ) in
       ( ))