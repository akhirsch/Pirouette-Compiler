let chan_A_B = Domainslib.Chan.make_bounded 0
let chan_A_C = Domainslib.Chan.make_bounded 0
let chan_B_A = Domainslib.Chan.make_bounded 0
let chan_B_C = Domainslib.Chan.make_bounded 0
let chan_C_A = Domainslib.Chan.make_bounded 0
let chan_C_B = Domainslib.Chan.make_bounded 0
let domain_A =
  Domain.spawn
    (fun _ ->
       let rec compute_local x = ((), ()) in
       let rec (x, y) = () 0
       and _unit_1 = () ()
       and _unit_2 = () () in
       let rec (x1, y1) =
         Marshal.from_string (Domainslib.Chan.recv chan_B_A) 0
       and (x2, y2) = Marshal.from_string (Domainslib.Chan.recv chan_C_A) 0 in
       let rec (sx, sy) = (((x + x1) + x2), ((y + y1) + y2)) in ())
let domain_B =
  Domain.spawn
    (fun _ ->
       let rec compute_local x = ((), ()) in
       let rec _unit_7 = () ()
       and (x, y) = () 1
       and _unit_8 = () () in
       let rec _unit_5 =
         let val_4 = (x, y) in
         Domainslib.Chan.send chan_B_A (Marshal.to_string val_4 [])
       and _unit_6 = () in let rec _unit_3 = () in ())
let domain_C =
  Domain.spawn
    (fun _ ->
       let rec compute_local x = ((), ()) in
       let rec _unit_13 = () ()
       and _unit_14 = () ()
       and (x, y) = () 2 in
       let rec _unit_10 = ()
       and _unit_12 =
         let val_11 = (x, y) in
         Domainslib.Chan.send chan_C_A (Marshal.to_string val_11 []) in
       let rec _unit_9 = () in ())