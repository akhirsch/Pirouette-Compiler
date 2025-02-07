let chan_AGC_LPF = Domainslib.Chan.make_bounded 0
let chan_LPF_AGC = Domainslib.Chan.make_bounded 0
let domain_AGC =
  Domain.spawn
    (fun _ ->
       let rec _unit_4 =
         let val_3 = x2 in
         Domainslib.Chan.send chan_AGC_LPF (Marshal.to_string val_3 []) in
       let rec _unit_2 =
         let val_1 = y2 in
         Domainslib.Chan.send chan_AGC_LPF (Marshal.to_string val_1 []) in
       ())
let domain_LPF =
  Domain.spawn
    (fun _ ->
       let rec x1 = Marshal.from_string (Domainslib.Chan.recv chan_AGC_LPF) 0 in
       let rec y1 = Marshal.from_string (Domainslib.Chan.recv chan_AGC_LPF) 0 in
       (x1 + y1) / 2)