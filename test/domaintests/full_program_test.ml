(* This test verifies that the OCaml AST for each participant is
   generated and combined with the shared runtime and entry point
   to produce a complete OCaml AST representing the choreography.

   The generated code is printed for manual check to verify
   that all components are present correctly structured, and placed in the correct order.

   This test verifies code generation, not compilation or
   runtime execution

to run this test: dune exec ./test/domaintests/full_program_test.exe 

NOTE: we are manually supplying each participant's NetIR program
      We are verifying complete program generation from NetIR.    *)

open Ppxlib
module A = Netir.Nometa
module Gen = Netir.Eiogen.MkOcamlGen (A)
open A

(* NetIR program for Alice: send the integer 42 to Bob. *)
let alice_prog =
  [
    emlocdecl "Alice";
    emlocdecl "Bob";
    defndecl "message" [] (send (intlit 42) "Bob");
  ]

(* NetIR program for Bob: receive an integer from Alice. *)
let bob_prog =
  [
    emlocdecl "Alice";
    emlocdecl "Bob";
    defndecl "message" [] (recv intty "Alice");
  ]

(* Combine the shared runtime, generated location modules,
   and entry point into one complete OCaml AST. *)
let generated =
  Eio_domains_backend.runtime
  @ Gen.program_gen "Alice" alice_prog
  @ Gen.program_gen "Bob" bob_prog
  @ Eio_domains_backend.entry_point [ "Alice"; "Bob" ]

(* Print the complete generated program for manual inspection. *)
let () =
  Pprintast.structure Format.std_formatter generated;
  Format.pp_print_flush Format.std_formatter ()
