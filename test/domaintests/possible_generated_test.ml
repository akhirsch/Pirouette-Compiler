module Loc_ALICE = struct
  type pir_emulated_location = Pir_ALICE | Pir_BOB

  let pir_me = Pir_ALICE

  type main = unit

  let run =
   fun pir_chans ->
    let open struct
      let main =
        match match Pir_ALICE with Pir_ALICE -> true | _ -> false with
        | true -> Pir_runtime.send pir_chans ~me:"ALICE" ~dest:"BOB" 42
        | false -> (
            match match Pir_BOB with Pir_ALICE -> true | _ -> false with
            | true -> (
                match
                  (Pir_runtime.recv pir_chans ~me:"ALICE" ~src:"ALICE" : int)
                with
                | x -> ())
            | false -> ())
    end in
    ()
end

module Loc_BOB = struct
  type pir_emulated_location = Pir_ALICE | Pir_BOB

  let pir_me = Pir_BOB

  type main = unit

  let run =
   fun pir_chans ->
    let open struct
      let main =
        match match Pir_ALICE with Pir_BOB -> true | _ -> false with
        | true -> Pir_runtime.send pir_chans ~me:"BOB" ~dest:"BOB" 42
        | false -> (
            match match Pir_BOB with Pir_BOB -> true | _ -> false with
            | true -> (
                match
                  (Pir_runtime.recv pir_chans ~me:"BOB" ~src:"ALICE" : int)
                with
                | x -> ())
            | false -> ())
    end in
    ()
end

let () = Pir_runtime.run [ ("ALICE", Loc_ALICE.run); ("BOB", Loc_BOB.run) ]
