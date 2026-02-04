let loc_to_rank = function
  | "A" -> 0
  | "B" -> 1
  | "C" -> 2
  | "D" -> 3
  | "E" -> 4
  | "F" -> 5
  | "G" -> 6
  | _ -> failwith "Runtime Error: Unknown location"

let _ = Mpi.barrier Mpi.comm_world

let _ =
  match Mpi.comm_rank Mpi.comm_world with
  | 0 ->
      let t1 = Unix.gettimeofday () in
      let rec broadcast_unopt freq =
        if freq > 0 then (
          Mpi.send "L" (loc_to_rank "B") 0 Mpi.comm_world;
          Mpi.send "L" (loc_to_rank "C") 0 Mpi.comm_world;
          Mpi.send "L" (loc_to_rank "D") 0 Mpi.comm_world;
          Mpi.send "L" (loc_to_rank "E") 0 Mpi.comm_world;
          Mpi.send "L" (loc_to_rank "F") 0 Mpi.comm_world;
          Mpi.send "L" (loc_to_rank "G") 0 Mpi.comm_world;
          let rec result_B =
            Marshal.from_string
              (Mpi.receive (loc_to_rank "B") Mpi.any_tag Mpi.comm_world)
              0
          in
          let rec result_C =
            Marshal.from_string
              (Mpi.receive (loc_to_rank "C") Mpi.any_tag Mpi.comm_world)
              0
          in
          let rec result_D =
            Marshal.from_string
              (Mpi.receive (loc_to_rank "D") Mpi.any_tag Mpi.comm_world)
              0
          in
          let rec result_E =
            Marshal.from_string
              (Mpi.receive (loc_to_rank "E") Mpi.any_tag Mpi.comm_world)
              0
          in
          let rec result_F =
            Marshal.from_string
              (Mpi.receive (loc_to_rank "F") Mpi.any_tag Mpi.comm_world)
              0
          in
          let rec result_G =
            Marshal.from_string
              (Mpi.receive (loc_to_rank "G") Mpi.any_tag Mpi.comm_world)
              0
          in
          broadcast_unopt (freq - 1))
        else (
          Mpi.send "R" (loc_to_rank "B") 0 Mpi.comm_world;
          Mpi.send "R" (loc_to_rank "C") 0 Mpi.comm_world;
          Mpi.send "R" (loc_to_rank "D") 0 Mpi.comm_world;
          Mpi.send "R" (loc_to_rank "E") 0 Mpi.comm_world;
          Mpi.send "R" (loc_to_rank "F") 0 Mpi.comm_world;
          Mpi.send "R" (loc_to_rank "G") 0 Mpi.comm_world;
          let rec result_B =
            Marshal.from_string
              (Mpi.receive (loc_to_rank "B") Mpi.any_tag Mpi.comm_world)
              0
          in
          let rec result_C =
            Marshal.from_string
              (Mpi.receive (loc_to_rank "C") Mpi.any_tag Mpi.comm_world)
              0
          in
          let rec result_D =
            Marshal.from_string
              (Mpi.receive (loc_to_rank "D") Mpi.any_tag Mpi.comm_world)
              0
          in
          let rec result_E =
            Marshal.from_string
              (Mpi.receive (loc_to_rank "E") Mpi.any_tag Mpi.comm_world)
              0
          in
          let rec result_F =
            Marshal.from_string
              (Mpi.receive (loc_to_rank "F") Mpi.any_tag Mpi.comm_world)
              0
          in
          let rec result_G =
            Marshal.from_string
              (Mpi.receive (loc_to_rank "G") Mpi.any_tag Mpi.comm_world)
              0
          in
          let t2 = Unix.gettimeofday () in
          Printf.printf "Loop execution time %fs \n" (t2 -. t1);
          print_endline "Terminate - Unoptimized")
      in
      broadcast_unopt 100000
  | 1 ->
      let rec broadcast_unopt freq =
        match Mpi.receive (loc_to_rank "A") Mpi.any_tag Mpi.comm_world with
        | "R" ->
            let rec x = 9 in
            let rec _unit_2 =
              let val_1 = x in
              Mpi.send
                (Marshal.to_string val_1 [])
                (loc_to_rank "A") 0 Mpi.comm_world
            in
            ()
        | "L" ->
            let rec x = 10 in
            let rec _unit_4 =
              let val_3 = x in
              Mpi.send
                (Marshal.to_string val_3 [])
                (loc_to_rank "A") 0 Mpi.comm_world
            in
            broadcast_unopt ()
        | _ -> failwith "Runtime Error: Unmatched label"
      in
      broadcast_unopt ()
  | 2 ->
      let rec broadcast_unopt freq =
        match Mpi.receive (loc_to_rank "A") Mpi.any_tag Mpi.comm_world with
        | "L" ->
            let rec x = 10 in
            let rec _unit_6 =
              let val_5 = x in
              Mpi.send
                (Marshal.to_string val_5 [])
                (loc_to_rank "A") 0 Mpi.comm_world
            in
            broadcast_unopt ()
        | "R" ->
            let rec x = 9 in
            let rec _unit_8 =
              let val_7 = x in
              Mpi.send
                (Marshal.to_string val_7 [])
                (loc_to_rank "A") 0 Mpi.comm_world
            in
            ()
        | _ -> failwith "Runtime Error: Unmatched label"
      in
      broadcast_unopt ()
  | 3 ->
      let rec broadcast_unopt freq =
        match Mpi.receive (loc_to_rank "A") Mpi.any_tag Mpi.comm_world with
        | "L" ->
            let rec x = 10 in
            let rec _unit_10 =
              let val_9 = x in
              Mpi.send
                (Marshal.to_string val_9 [])
                (loc_to_rank "A") 0 Mpi.comm_world
            in
            broadcast_unopt ()
        | "R" ->
            let rec x = 9 in
            let rec _unit_12 =
              let val_11 = x in
              Mpi.send
                (Marshal.to_string val_11 [])
                (loc_to_rank "A") 0 Mpi.comm_world
            in
            ()
        | _ -> failwith "Runtime Error: Unmatched label"
      in
      broadcast_unopt ()
  | 4 ->
      let rec broadcast_unopt freq =
        match Mpi.receive (loc_to_rank "A") Mpi.any_tag Mpi.comm_world with
        | "L" ->
            let rec x = 10 in
            let rec _unit_14 =
              let val_13 = x in
              Mpi.send
                (Marshal.to_string val_13 [])
                (loc_to_rank "A") 0 Mpi.comm_world
            in
            broadcast_unopt ()
        | "R" ->
            let rec x = 9 in
            let rec _unit_16 =
              let val_15 = x in
              Mpi.send
                (Marshal.to_string val_15 [])
                (loc_to_rank "A") 0 Mpi.comm_world
            in
            ()
        | _ -> failwith "Runtime Error: Unmatched label"
      in
      broadcast_unopt ()
  | 5 ->
      let rec broadcast_unopt freq =
        match Mpi.receive (loc_to_rank "A") Mpi.any_tag Mpi.comm_world with
        | "L" ->
            let rec x = 10 in
            let rec _unit_18 =
              let val_17 = x in
              Mpi.send
                (Marshal.to_string val_17 [])
                (loc_to_rank "A") 0 Mpi.comm_world
            in
            broadcast_unopt ()
        | "R" ->
            let rec x = 9 in
            let rec _unit_20 =
              let val_19 = x in
              Mpi.send
                (Marshal.to_string val_19 [])
                (loc_to_rank "A") 0 Mpi.comm_world
            in
            ()
        | _ -> failwith "Runtime Error: Unmatched label"
      in
      broadcast_unopt ()
  | 6 ->
      let rec broadcast_unopt freq =
        match Mpi.receive (loc_to_rank "A") Mpi.any_tag Mpi.comm_world with
        | "L" ->
            let rec x = 10 in
            let rec _unit_22 =
              let val_21 = x in
              Mpi.send
                (Marshal.to_string val_21 [])
                (loc_to_rank "A") 0 Mpi.comm_world
            in
            broadcast_unopt ()
        | "R" ->
            let rec x = 9 in
            let rec _unit_24 =
              let val_23 = x in
              Mpi.send
                (Marshal.to_string val_23 [])
                (loc_to_rank "A") 0 Mpi.comm_world
            in
            ()
        | _ -> failwith "Runtime Error: Unmatched label"
      in
      broadcast_unopt ()
  | _ -> failwith "Runtime Error: Unknown rank"
