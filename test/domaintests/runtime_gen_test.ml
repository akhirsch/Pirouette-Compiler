(* verifies that the Ppxlib AST in eio_domains_backend.ml produces valid, 
executable OCaml code, and that the generated runtime supports communication 
between domains*)

(* Commands to run:
 1. dune exec ./test/domaintests/runtime_gen_test.exe > /tmp/pir_generated_test.ml
 2. ocamlfind ocamlopt -package eio,eio_main -linkpkg \
  /tmp/pir_generated_test.ml -o /tmp/pir_generated_test
  Note: There may be warnings this is FINE 
 3. /tmp/pir_generated_test *)

 (* expected output: 
  Bob received: 42
  Bob received label: continue
  Alice received: Message received 
  
  Verifies: 
   - The backend's runtime AST generates valid OCaml code
   - The generated code compiles and executes successfully
   - Communication channels are created between locations
   - Values and labels can be sent and received correctly
   - Communication works in both directions between Alice and Bob
   - Each location executes in its own OCaml domain

   This test exercises the actual generated runtime rather than a standalone
   copy of the implementation in pir_runtime.ml 
   
   NOT TESTING: the complete compiler pipeline *)

open Ppxlib

let loc = Location.none

let test_program =
  [
    [%stri
      let alice chans =
        Pir_runtime.send chans ~me:"Alice" ~dest:"Bob" 42;
        Pir_runtime.send_label chans ~me:"Alice" ~dest:"Bob" "continue";
        let response : string =
          Pir_runtime.recv chans ~me:"Alice" ~src:"Bob"
        in
        Printf.printf "Alice received: %s\n%!" response];

    [%stri
      let bob chans =
        let value : int =
          Pir_runtime.recv chans ~me:"Bob" ~src:"Alice"
        in
        Printf.printf "Bob received: %d\n%!" value;
        let label =
          Pir_runtime.recv_label chans ~me:"Bob" ~src:"Alice"
        in
        Printf.printf "Bob received label: %s\n%!" label;
        Pir_runtime.send chans ~me:"Bob" ~dest:"Alice" "Message received"];

    [%stri
      let () =
        Pir_runtime.run
          [("Alice", alice); ("Bob", bob)]];
  ]

(* Uses the runtime AST from eio_domains_backend.ml to generate executable
   OCaml code.
   NOTE: This tests only the runtime implementation, not the other
   backend functions or the eiogen.ml compiler integration. *)
let () =
  let program = Eio_domains_backend.runtime @ test_program in
  Pprintast.structure Format.std_formatter program;
  Format.pp_print_flush Format.std_formatter ()
