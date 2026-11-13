let alice chans =
  Printf.printf "Alice: sending 42\n%!";
  Pir_runtime.send chans ~me:"Alice" ~dest:"Bob" 42

let bob chans =
  Printf.printf "Bob: waiting\n%!";
  let value : int = Pir_runtime.recv chans ~me:"Bob" ~src:"Alice" in
  Printf.printf "Bob: received %d\n%!" value

let () = Pir_runtime.run [ ("Alice", alice); ("Bob", bob) ]
