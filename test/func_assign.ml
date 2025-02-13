let chan_A_B = Domainslib.Chan.make_bounded 0
let chan_B_A = Domainslib.Chan.make_bounded 0
let domain_A =
  Domain.spawn
    (fun _ ->
       let rec helper a = let rec result = a + 1 in result in
       let rec x = 0 in
       let rec _unit_1 = helper x in
       match Domainslib.Chan.recv chan_B_A with
       | "R" -> false
       | "L" -> true
       | _ -> failwith "Error: Unmatched label")
let domain_B =
  Domain.spawn
    (fun _ ->
       let rec helper a = let rec _unit_2 = () in () in
       let rec _unit_3 = () in
       let rec result = () () in
       if result = 0
       then (Domainslib.Chan.send chan_B_A "L"; ())
       else (Domainslib.Chan.send chan_B_A "R"; ()))