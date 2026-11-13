(* this test can be run with dune exec ./test/domaintests/domaintest2.ml *)
(* Line 5 is intended to keep this test from actually running completely *)
let alice stream =
  Printf.printf "Alice: sending\n%!";
  Eio.Stream.take stream;
  Printf.printf "Alice: sent 42\n%!"

let bob stream =
  Printf.printf "Bob: waiting for message\n%!";
  let value = Eio.Stream.take stream in
  Printf.printf "Bob: received %d\n%!" value

let () =
  Eio_main.run @@ fun env ->
  let domain_mgr = Eio.Stdenv.domain_mgr env in
  let alice_to_bob = Eio.Stream.create 10 in

  Eio.Fiber.both
    (fun () -> Eio.Domain_manager.run domain_mgr (fun () -> alice alice_to_bob))
    (fun () -> Eio.Domain_manager.run domain_mgr (fun () -> bob alice_to_bob))
