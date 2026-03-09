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
      let rec broadcast_opt freq =
        if freq > 0 then (
          Mpi.send "L" (loc_to_rank "B") 0 Mpi.comm_world;
          Mpi.send "L" (loc_to_rank "C") 0 Mpi.comm_world;
          broadcast_opt (freq - 1))
        else (
          Mpi.send "R" (loc_to_rank "B") 0 Mpi.comm_world;
          Mpi.send "R" (loc_to_rank "C") 0 Mpi.comm_world;
          let t2 = Unix.gettimeofday () in
          Printf.printf "Loop execution time %fs \n" (t2 -. t1);
          print_endline "Terminate - Optimized")
      in
      broadcast_opt 100000
  | 1 ->
      let rec broadcast_opt freq =
        match Mpi.receive (loc_to_rank "A") Mpi.any_tag Mpi.comm_world with
        | "R" ->
            Mpi.send "R" (loc_to_rank "D") 0 Mpi.comm_world;
            Mpi.send "R" (loc_to_rank "E") 0 Mpi.comm_world;
            let rec x = 9 in
            ()
        | "L" ->
            Mpi.send "L" (loc_to_rank "D") 0 Mpi.comm_world;
            Mpi.send "L" (loc_to_rank "E") 0 Mpi.comm_world;
            let rec x = 10 in
            broadcast_opt ()
        | _ -> failwith "Runtime Error: Unmatched label"
      in
      broadcast_opt ()
  | 2 ->
      let rec broadcast_opt freq =
        match Mpi.receive (loc_to_rank "A") Mpi.any_tag Mpi.comm_world with
        | "L" ->
            Mpi.send "L" (loc_to_rank "F") 0 Mpi.comm_world;
            Mpi.send "L" (loc_to_rank "G") 0 Mpi.comm_world;
            let rec x = 10 in
            broadcast_opt ()
        | "R" ->
            Mpi.send "R" (loc_to_rank "F") 0 Mpi.comm_world;
            Mpi.send "R" (loc_to_rank "G") 0 Mpi.comm_world;
            let rec x = 9 in
            ()
        | _ -> failwith "Runtime Error: Unmatched label"
      in
      broadcast_opt ()
  | 3 ->
      let rec broadcast_opt freq =
        match Mpi.receive (loc_to_rank "B") Mpi.any_tag Mpi.comm_world with
        | "R" ->
            let rec x = 9 in
            ()
        | "L" ->
            let rec x = 10 in
            broadcast_opt ()
        | _ -> failwith "Runtime Error: Unmatched label"
      in
      broadcast_opt ()
  | 4 ->
      let rec broadcast_opt freq =
        match Mpi.receive (loc_to_rank "B") Mpi.any_tag Mpi.comm_world with
        | "L" ->
            let rec x = 10 in
            broadcast_opt ()
        | "R" ->
            let rec x = 9 in
            ()
        | _ -> failwith "Runtime Error: Unmatched label"
      in
      broadcast_opt ()
  | 5 ->
      let rec broadcast_opt freq =
        match Mpi.receive (loc_to_rank "C") Mpi.any_tag Mpi.comm_world with
        | "R" ->
            let rec x = 9 in
            ()
        | "L" ->
            let rec x = 10 in
            broadcast_opt ()
        | _ -> failwith "Runtime Error: Unmatched label"
      in
      broadcast_opt ()
  | 6 ->
      let rec broadcast_opt freq =
        match Mpi.receive (loc_to_rank "C") Mpi.any_tag Mpi.comm_world with
        | "L" ->
            let rec x = 10 in
            broadcast_opt ()
        | "R" ->
            let rec x = 9 in
            ()
        | _ -> failwith "Runtime Error: Unmatched label"
      in
      broadcast_opt ()
  | _ -> failwith "Runtime Error: Unknown rank"
