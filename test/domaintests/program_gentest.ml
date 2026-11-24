(* we are not manually constructing header and defns this time!!! We want 
program_gen to do that work so we can verify our partitioning change

Verifies:
The location variant is generated before pir_me
Type aliases remain at module scope
Custom variants remain at module scope
Value definitions are placed inside run
Communication expressions have access to pir_chans
The partitioning prevents unsupported structure items 
from reaching the failwith in wrap_location

Run this test with: dune exec ./test/domaintests/program_gentest.exe 

The generated OCaml AST is printed for inspection 

Output shows: Type declarations and location identity information should remain
at module scope, while value definitions should be generated inside
the run function, where pir_chans is in scope
*)

open Ppxlib

module A = Netir.Nometa
module Gen = Netir.Eiogen.MkOcamlGen (A)

open A

let prog =
  [
    emlocdecl "Alice";
    emlocdecl "Bob";
    typealiasdecl "user_id" intty;
    variantdecl "color"
      [
        ("Red", [], varty "color");
        ("Blue", [], varty "color");
      ];
    defndecl "message" [] (send (intlit 42) "Bob");
  ]

let () =
  let generated = Gen.program_gen "Alice" prog in
  Pprintast.structure Format.std_formatter generated;
  Format.pp_print_flush Format.std_formatter ()
