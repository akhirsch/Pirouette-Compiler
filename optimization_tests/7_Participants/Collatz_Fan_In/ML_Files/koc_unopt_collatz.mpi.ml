let loc_to_rank = function
  | "A" -> 0
  | "B" -> 1
  | "C" -> 2
  | "D" -> 3
  | "E" -> 4
  | "F" -> 5
  | "G" -> 6
  | _ -> failwith "Runtime Error: Unknown location"
;;

let _ = Mpi.barrier Mpi.comm_world

let _ =
  match Mpi.comm_rank Mpi.comm_world with
  | 0 ->
    let t1 = Unix.gettimeofday () in
    let rec test_collatz inp =
      if inp = 1
      then 0
      else (
        let rec res1 = inp / 2 in
        let rec res2 = res1 * 2 in
        if res2 = inp
        then (
          let rec part_res = test_collatz res1 in
          part_res + 1)
        else (
          let rec res3 = (3 * inp) + 1 in
          let rec res4 = test_collatz res3 in
          1 + res4))
    in
    let rec _unit_1 = () in
    let rec _unit_2 = () in
    let rec _unit_3 = () in
    let rec _unit_4 = () in
    let rec _unit_5 = () in
    let rec _unit_6 = () in
    let rec broadcast_opt freq =
      if freq > 0
      then (
        Mpi.send "L1" (loc_to_rank "B") 0 Mpi.comm_world;
        Mpi.send "L2" (loc_to_rank "C") 0 Mpi.comm_world;
        Mpi.send "L3" (loc_to_rank "D") 0 Mpi.comm_world;
        Mpi.send "L4" (loc_to_rank "E") 0 Mpi.comm_world;
        Mpi.send "L5" (loc_to_rank "F") 0 Mpi.comm_world;
        Mpi.send "L6" (loc_to_rank "G") 0 Mpi.comm_world;
        let rec reply_B =
          Marshal.from_string (Mpi.receive (loc_to_rank "B") Mpi.any_tag Mpi.comm_world) 0
        in
        let rec reply_C =
          Marshal.from_string (Mpi.receive (loc_to_rank "C") Mpi.any_tag Mpi.comm_world) 0
        in
        let rec reply_D =
          Marshal.from_string (Mpi.receive (loc_to_rank "B") Mpi.any_tag Mpi.comm_world) 0
        in
        let rec reply_E =
          Marshal.from_string (Mpi.receive (loc_to_rank "B") Mpi.any_tag Mpi.comm_world) 0
        in
        let rec reply_F =
          Marshal.from_string (Mpi.receive (loc_to_rank "C") Mpi.any_tag Mpi.comm_world) 0
        in
        let rec reply_G =
          Marshal.from_string (Mpi.receive (loc_to_rank "C") Mpi.any_tag Mpi.comm_world) 0
        in
        broadcast_opt (freq - 1))
      else (
        Mpi.send "R1" (loc_to_rank "B") 0 Mpi.comm_world;
        Mpi.send "R2" (loc_to_rank "C") 0 Mpi.comm_world;
        Mpi.send "R3" (loc_to_rank "D") 0 Mpi.comm_world;
        Mpi.send "R4" (loc_to_rank "E") 0 Mpi.comm_world;
        Mpi.send "R5" (loc_to_rank "F") 0 Mpi.comm_world;
        Mpi.send "R6" (loc_to_rank "G") 0 Mpi.comm_world;
        let t2 = Unix.gettimeofday () in
        Printf.printf "Loop execution time %fs \n" (t2 -. t1);
        print_endline "Done with all the computations - Unoptimized")
    in
    broadcast_opt 100000
  | 1 ->
    let rec _unit_7 = () in
    let rec test_collatz inp =
      if inp = 1
      then 0
      else (
        let rec res1 = inp / 2 in
        let rec res2 = res1 * 2 in
        if res2 = inp
        then (
          let rec part_res = test_collatz res1 in
          part_res + 1)
        else (
          let rec res3 = (3 * inp) + 1 in
          let rec res4 = test_collatz res3 in
          1 + res4))
    in
    let rec _unit_8 = () in
    let rec _unit_9 = () in
    let rec _unit_10 = () in
    let rec _unit_11 = () in
    let rec _unit_12 = () in
    let rec broadcast_opt freq =
      match Mpi.receive (loc_to_rank "A") Mpi.any_tag Mpi.comm_world with
      | "L1" ->
        let rec result = test_collatz 931386509544713451 in
        let rec _unit_18 =
          let val_17 = result in
          Mpi.send (Marshal.to_string val_17 []) (loc_to_rank "A") 0 Mpi.comm_world
        in
        let rec reply_D =
          Marshal.from_string (Mpi.receive (loc_to_rank "D") Mpi.any_tag Mpi.comm_world) 0
        in
        let rec _unit_16 =
          let val_15 = reply_D in
          Mpi.send (Marshal.to_string val_15 []) (loc_to_rank "A") 0 Mpi.comm_world
        in
        let rec reply_E =
          Marshal.from_string (Mpi.receive (loc_to_rank "E") Mpi.any_tag Mpi.comm_world) 0
        in
        let rec _unit_14 =
          let val_13 = reply_E in
          Mpi.send (Marshal.to_string val_13 []) (loc_to_rank "A") 0 Mpi.comm_world
        in
        broadcast_opt ()
      | "R1" -> ()
      | _ -> failwith "Runtime Error: Unmatched label"
    in
    broadcast_opt ()
  | 2 ->
    let rec _unit_19 = () in
    let rec _unit_20 = () in
    let rec test_collatz inp =
      if inp = 1
      then 0
      else (
        let rec res1 = inp / 2 in
        let rec res2 = res1 * 2 in
        if res2 = inp
        then (
          let rec part_res = test_collatz res1 in
          part_res + 1)
        else (
          let rec res3 = (3 * inp) + 1 in
          let rec res4 = test_collatz res3 in
          1 + res4))
    in
    let rec _unit_21 = () in
    let rec _unit_22 = () in
    let rec _unit_23 = () in
    let rec _unit_24 = () in
    let rec broadcast_opt freq =
      match Mpi.receive (loc_to_rank "A") Mpi.any_tag Mpi.comm_world with
      | "L2" ->
        let rec result = test_collatz 931386509544713451 in
        let rec _unit_30 =
          let val_29 = result in
          Mpi.send (Marshal.to_string val_29 []) (loc_to_rank "A") 0 Mpi.comm_world
        in
        let rec reply_F =
          Marshal.from_string (Mpi.receive (loc_to_rank "F") Mpi.any_tag Mpi.comm_world) 0
        in
        let rec _unit_28 =
          let val_27 = reply_F in
          Mpi.send (Marshal.to_string val_27 []) (loc_to_rank "A") 0 Mpi.comm_world
        in
        let rec reply_G =
          Marshal.from_string (Mpi.receive (loc_to_rank "G") Mpi.any_tag Mpi.comm_world) 0
        in
        let rec _unit_26 =
          let val_25 = reply_G in
          Mpi.send (Marshal.to_string val_25 []) (loc_to_rank "A") 0 Mpi.comm_world
        in
        broadcast_opt ()
      | "R2" -> ()
      | _ -> failwith "Runtime Error: Unmatched label"
    in
    broadcast_opt ()
  | 3 ->
    let rec _unit_31 = () in
    let rec _unit_32 = () in
    let rec _unit_33 = () in
    let rec test_collatz inp =
      if inp = 1
      then 0
      else (
        let rec res1 = inp / 2 in
        let rec res2 = res1 * 2 in
        if res2 = inp
        then (
          let rec part_res = test_collatz res1 in
          part_res + 1)
        else (
          let rec res3 = (3 * inp) + 1 in
          let rec res4 = test_collatz res3 in
          1 + res4))
    in
    let rec _unit_34 = () in
    let rec _unit_35 = () in
    let rec _unit_36 = () in
    let rec broadcast_opt freq =
      match Mpi.receive (loc_to_rank "A") Mpi.any_tag Mpi.comm_world with
      | "R3" -> ()
      | "L3" ->
        let rec result = test_collatz 931386509544713451 in
        let rec _unit_38 =
          let val_37 = result in
          Mpi.send (Marshal.to_string val_37 []) (loc_to_rank "B") 0 Mpi.comm_world
        in
        broadcast_opt ()
      | _ -> failwith "Runtime Error: Unmatched label"
    in
    broadcast_opt ()
  | 4 ->
    let rec _unit_39 = () in
    let rec _unit_40 = () in
    let rec _unit_41 = () in
    let rec _unit_42 = () in
    let rec test_collatz inp =
      if inp = 1
      then 0
      else (
        let rec res1 = inp / 2 in
        let rec res2 = res1 * 2 in
        if res2 = inp
        then (
          let rec part_res = test_collatz res1 in
          part_res + 1)
        else (
          let rec res3 = (3 * inp) + 1 in
          let rec res4 = test_collatz res3 in
          1 + res4))
    in
    let rec _unit_43 = () in
    let rec _unit_44 = () in
    let rec broadcast_opt freq =
      match Mpi.receive (loc_to_rank "A") Mpi.any_tag Mpi.comm_world with
      | "R4" -> ()
      | "L4" ->
        let rec result = test_collatz 931386509544713451 in
        let rec _unit_46 =
          let val_45 = result in
          Mpi.send (Marshal.to_string val_45 []) (loc_to_rank "B") 0 Mpi.comm_world
        in
        broadcast_opt ()
      | _ -> failwith "Runtime Error: Unmatched label"
    in
    broadcast_opt ()
  | 5 ->
    let rec _unit_47 = () in
    let rec _unit_48 = () in
    let rec _unit_49 = () in
    let rec _unit_50 = () in
    let rec _unit_51 = () in
    let rec test_collatz inp =
      if inp = 1
      then 0
      else (
        let rec res1 = inp / 2 in
        let rec res2 = res1 * 2 in
        if res2 = inp
        then (
          let rec part_res = test_collatz res1 in
          part_res + 1)
        else (
          let rec res3 = (3 * inp) + 1 in
          let rec res4 = test_collatz res3 in
          1 + res4))
    in
    let rec _unit_52 = () in
    let rec broadcast_opt freq =
      match Mpi.receive (loc_to_rank "A") Mpi.any_tag Mpi.comm_world with
      | "L5" ->
        let rec result = test_collatz 931386509544713451 in
        let rec _unit_54 =
          let val_53 = result in
          Mpi.send (Marshal.to_string val_53 []) (loc_to_rank "C") 0 Mpi.comm_world
        in
        broadcast_opt ()
      | "R5" -> ()
      | _ -> failwith "Runtime Error: Unmatched label"
    in
    broadcast_opt ()
  | 6 ->
    let rec _unit_55 = () in
    let rec _unit_56 = () in
    let rec _unit_57 = () in
    let rec _unit_58 = () in
    let rec _unit_59 = () in
    let rec _unit_60 = () in
    let rec test_collatz inp =
      if inp = 1
      then 0
      else (
        let rec res1 = inp / 2 in
        let rec res2 = res1 * 2 in
        if res2 = inp
        then (
          let rec part_res = test_collatz res1 in
          part_res + 1)
        else (
          let rec res3 = (3 * inp) + 1 in
          let rec res4 = test_collatz res3 in
          1 + res4))
    in
    let rec broadcast_opt freq =
      match Mpi.receive (loc_to_rank "A") Mpi.any_tag Mpi.comm_world with
      | "L6" ->
        let rec result = test_collatz 931386509544713451 in
        let rec _unit_62 =
          let val_61 = result in
          Mpi.send (Marshal.to_string val_61 []) (loc_to_rank "C") 0 Mpi.comm_world
        in
        broadcast_opt ()
      | "R6" -> ()
      | _ -> failwith "Runtime Error: Unmatched label"
    in
    broadcast_opt ()
  | _ -> failwith "Runtime Error: Unknown rank"
;;
