let chan_CAR_KEY = Domainslib.Chan.make_bounded 0
let chan_KEY_CAR = Domainslib.Chan.make_bounded 0
let domain_CAR =
  Domain.spawn
    (fun _ ->
       let rec locked = true in
       let rec _unit_6 = () in
       if locked
       then
         (Domainslib.Chan.send chan_CAR_KEY "L";
          (let rec _unit_5 =
             let val_4 = "myKey" in
             Domainslib.Chan.send chan_CAR_KEY (Marshal.to_string val_4 []) in
           match Domainslib.Chan.recv chan_KEY_CAR with
           | "L" ->
               let rec _unit_3 = () in
               let rec receive_present_signal =
                 Marshal.from_string (Domainslib.Chan.recv chan_KEY_CAR) 0 in
               let rec _unit_2 =
                 let val_1 = "Solve the challenge: 1+1 = ?\n" in
                 Domainslib.Chan.send chan_CAR_KEY
                   (Marshal.to_string val_1 []) in
               let rec answer =
                 Marshal.from_string (Domainslib.Chan.recv chan_KEY_CAR) 0 in
               if answer = "2"
               then
                 (Domainslib.Chan.send chan_CAR_KEY "R";
                  (let rec locked = false in locked))
               else (Domainslib.Chan.send chan_CAR_KEY "L"; locked)
           | "R" -> let rec locked = false in locked
           | _ -> failwith "Error: Unmatched label"))
       else
         (Domainslib.Chan.send chan_CAR_KEY "R";
          (let rec lock_signal =
             Marshal.from_string (Domainslib.Chan.recv chan_KEY_CAR) 0 in
           match Domainslib.Chan.recv chan_KEY_CAR with
           | "R" -> locked
           | "L" -> let rec locked = true in locked
           | _ -> failwith "Error: Unmatched label")))
let domain_KEY =
  Domain.spawn
    (fun _ ->
       let rec _unit_16 = () in
       let rec present = false in
       match Domainslib.Chan.recv chan_CAR_KEY with
       | "R" ->
           let rec _unit_9 =
             let val_8 = "LOCK" in
             Domainslib.Chan.send chan_KEY_CAR (Marshal.to_string val_8 []) in
           if ()
           then
             (Domainslib.Chan.send chan_KEY_CAR "L";
              (let rec _unit_7 = () in ()))
           else (Domainslib.Chan.send chan_KEY_CAR "R"; ())
       | "L" ->
           let rec receive_wake_signal =
             Marshal.from_string (Domainslib.Chan.recv chan_CAR_KEY) 0 in
           if receive_wake_signal = "myKey"
           then
             (Domainslib.Chan.send chan_KEY_CAR "L";
              (let rec present = true in
               let rec _unit_15 =
                 let val_14 = "Key Present" in
                 Domainslib.Chan.send chan_KEY_CAR
                   (Marshal.to_string val_14 []) in
               let rec problem =
                 Marshal.from_string (Domainslib.Chan.recv chan_CAR_KEY) 0 in
               let rec _unit_13 =
                 let val_12 = input in
                 Domainslib.Chan.send chan_KEY_CAR
                   (Marshal.to_string val_12 []) in
               match Domainslib.Chan.recv chan_CAR_KEY with
               | "L" -> ()
               | "R" -> let rec _unit_11 = () in ()
               | _ -> failwith "Error: Unmatched label"))
           else
             (Domainslib.Chan.send chan_KEY_CAR "R";
              (let rec _unit_10 = () in ()))
       | _ -> failwith "Error: Unmatched label")