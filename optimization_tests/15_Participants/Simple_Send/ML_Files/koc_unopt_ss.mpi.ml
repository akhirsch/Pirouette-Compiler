let loc_to_rank = function
  | "A" -> 0
  | "B" -> 1
  | "C" -> 2
  | "D" -> 3
  | "E" -> 4
  | "F" -> 5
  | "G" -> 6
  | "H" -> 7
  | "I" -> 8
  | "J" -> 9
  | "K" -> 10
  | "L" -> 11
  | "M" -> 12
  | "N" -> 13
  | "O" -> 14
  | _ -> failwith "Runtime Error: Unknown location"
;;

let _ = Mpi.barrier Mpi.comm_world

let _ =
  match Mpi.comm_rank Mpi.comm_world with
  | 0 ->
    let t1 = Unix.gettimeofday () in
    let rec broadcast_unopt freq =
      if freq > 0
      then (
        Mpi.send "L" (loc_to_rank "B") 0 Mpi.comm_world;
        Mpi.send "L" (loc_to_rank "C") 0 Mpi.comm_world;
        Mpi.send "L" (loc_to_rank "D") 0 Mpi.comm_world;
        Mpi.send "L" (loc_to_rank "E") 0 Mpi.comm_world;
        Mpi.send "L" (loc_to_rank "F") 0 Mpi.comm_world;
        Mpi.send "L" (loc_to_rank "G") 0 Mpi.comm_world;
        Mpi.send "L" (loc_to_rank "H") 0 Mpi.comm_world;
        Mpi.send "L" (loc_to_rank "I") 0 Mpi.comm_world;
        Mpi.send "L" (loc_to_rank "J") 0 Mpi.comm_world;
        Mpi.send "L" (loc_to_rank "K") 0 Mpi.comm_world;
        Mpi.send "L" (loc_to_rank "L") 0 Mpi.comm_world;
        Mpi.send "L" (loc_to_rank "M") 0 Mpi.comm_world;
        Mpi.send "L" (loc_to_rank "N") 0 Mpi.comm_world;
        Mpi.send "L" (loc_to_rank "O") 0 Mpi.comm_world;
        broadcast_unopt (freq - 1))
      else (
        Mpi.send "R" (loc_to_rank "B") 0 Mpi.comm_world;
        Mpi.send "R" (loc_to_rank "C") 0 Mpi.comm_world;
        Mpi.send "R" (loc_to_rank "D") 0 Mpi.comm_world;
        Mpi.send "R" (loc_to_rank "E") 0 Mpi.comm_world;
        Mpi.send "R" (loc_to_rank "F") 0 Mpi.comm_world;
        Mpi.send "R" (loc_to_rank "G") 0 Mpi.comm_world;
        Mpi.send "R" (loc_to_rank "H") 0 Mpi.comm_world;
        Mpi.send "R" (loc_to_rank "I") 0 Mpi.comm_world;
        Mpi.send "R" (loc_to_rank "J") 0 Mpi.comm_world;
        Mpi.send "R" (loc_to_rank "K") 0 Mpi.comm_world;
        Mpi.send "R" (loc_to_rank "L") 0 Mpi.comm_world;
        Mpi.send "R" (loc_to_rank "M") 0 Mpi.comm_world;
        Mpi.send "R" (loc_to_rank "N") 0 Mpi.comm_world;
        Mpi.send "R" (loc_to_rank "O") 0 Mpi.comm_world;
        let rec result_O =
          Marshal.from_string (Mpi.receive (loc_to_rank "O") Mpi.any_tag Mpi.comm_world) 0
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
        ()
      | "L" ->
        let rec x = 10 in
        broadcast_unopt ()
      | _ -> failwith "Runtime Error: Unmatched label"
    in
    broadcast_unopt ()
  | 2 ->
    let rec broadcast_unopt freq =
      match Mpi.receive (loc_to_rank "A") Mpi.any_tag Mpi.comm_world with
      | "L" ->
        let rec x = 10 in
        broadcast_unopt ()
      | "R" ->
        let rec x = 9 in
        ()
      | _ -> failwith "Runtime Error: Unmatched label"
    in
    broadcast_unopt ()
  | 3 ->
    let rec broadcast_unopt freq =
      match Mpi.receive (loc_to_rank "A") Mpi.any_tag Mpi.comm_world with
      | "R" ->
        let rec x = 9 in
        ()
      | "L" ->
        let rec x = 10 in
        broadcast_unopt ()
      | _ -> failwith "Runtime Error: Unmatched label"
    in
    broadcast_unopt ()
  | 4 ->
    let rec broadcast_unopt freq =
      match Mpi.receive (loc_to_rank "A") Mpi.any_tag Mpi.comm_world with
      | "L" ->
        let rec x = 10 in
        broadcast_unopt ()
      | "R" ->
        let rec x = 9 in
        ()
      | _ -> failwith "Runtime Error: Unmatched label"
    in
    broadcast_unopt ()
  | 5 ->
    let rec broadcast_unopt freq =
      match Mpi.receive (loc_to_rank "A") Mpi.any_tag Mpi.comm_world with
      | "R" ->
        let rec x = 9 in
        ()
      | "L" ->
        let rec x = 10 in
        broadcast_unopt ()
      | _ -> failwith "Runtime Error: Unmatched label"
    in
    broadcast_unopt ()
  | 6 ->
    let rec broadcast_unopt freq =
      match Mpi.receive (loc_to_rank "A") Mpi.any_tag Mpi.comm_world with
      | "L" ->
        let rec x = 10 in
        broadcast_unopt ()
      | "R" ->
        let rec x = 9 in
        ()
      | _ -> failwith "Runtime Error: Unmatched label"
    in
    broadcast_unopt ()
  | 7 ->
    let rec broadcast_unopt freq =
      match Mpi.receive (loc_to_rank "A") Mpi.any_tag Mpi.comm_world with
      | "R" ->
        let rec x = 9 in
        ()
      | "L" ->
        let rec x = 10 in
        broadcast_unopt ()
      | _ -> failwith "Runtime Error: Unmatched label"
    in
    broadcast_unopt ()
  | 8 ->
    let rec broadcast_unopt freq =
      match Mpi.receive (loc_to_rank "A") Mpi.any_tag Mpi.comm_world with
      | "L" ->
        let rec x = 10 in
        broadcast_unopt ()
      | "R" ->
        let rec x = 9 in
        ()
      | _ -> failwith "Runtime Error: Unmatched label"
    in
    broadcast_unopt ()
  | 9 ->
    let rec broadcast_unopt freq =
      match Mpi.receive (loc_to_rank "A") Mpi.any_tag Mpi.comm_world with
      | "L" ->
        let rec x = 10 in
        broadcast_unopt ()
      | "R" ->
        let rec x = 9 in
        ()
      | _ -> failwith "Runtime Error: Unmatched label"
    in
    broadcast_unopt ()
  | 10 ->
    let rec broadcast_unopt freq =
      match Mpi.receive (loc_to_rank "A") Mpi.any_tag Mpi.comm_world with
      | "R" ->
        let rec x = 9 in
        ()
      | "L" ->
        let rec x = 10 in
        broadcast_unopt ()
      | _ -> failwith "Runtime Error: Unmatched label"
    in
    broadcast_unopt ()
  | 11 ->
    let rec broadcast_unopt freq =
      match Mpi.receive (loc_to_rank "A") Mpi.any_tag Mpi.comm_world with
      | "R" ->
        let rec x = 9 in
        ()
      | "L" ->
        let rec x = 10 in
        broadcast_unopt ()
      | _ -> failwith "Runtime Error: Unmatched label"
    in
    broadcast_unopt ()
  | 12 ->
    let rec broadcast_unopt freq =
      match Mpi.receive (loc_to_rank "A") Mpi.any_tag Mpi.comm_world with
      | "L" ->
        let rec x = 10 in
        broadcast_unopt ()
      | "R" ->
        let rec x = 9 in
        ()
      | _ -> failwith "Runtime Error: Unmatched label"
    in
    broadcast_unopt ()
  | 13 ->
    let rec broadcast_unopt freq =
      match Mpi.receive (loc_to_rank "A") Mpi.any_tag Mpi.comm_world with
      | "L" ->
        let rec x = 10 in
        broadcast_unopt ()
      | "R" ->
        let rec x = 9 in
        ()
      | _ -> failwith "Runtime Error: Unmatched label"
    in
    broadcast_unopt ()
  | 14 ->
    let rec broadcast_unopt freq =
      match Mpi.receive (loc_to_rank "A") Mpi.any_tag Mpi.comm_world with
      | "L" ->
        let rec x = 10 in
        broadcast_unopt ()
      | "R" ->
        let rec x = 9 in
        let rec _unit_2 =
          let val_1 = x in
          Mpi.send (Marshal.to_string val_1 []) (loc_to_rank "A") 0 Mpi.comm_world
        in
        ()
      | _ -> failwith "Runtime Error: Unmatched label"
    in
    broadcast_unopt ()
  | _ -> failwith "Runtime Error: Unknown rank"
;;
