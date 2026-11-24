(* This test verifies that entry_point generates the correct OCaml AST
   for launching all participants through Pir_runtime.run 

   Each location name should be paired with its corresponding module's
   run function (e.g., "Alice" with Loc_Alice.run).

   The generated AST is printed for manual inspection to check that
   the participant list and runtime call are constructed correctly

   This test verifies code generation, not runtime execution

to run this test: dune exec ./test/domaintests/entrypoint_test.exe *)

open Ppxlib

let () =
  let generated = Eio_domains_backend.entry_point [ "Alice"; "Bob" ] in
  Pprintast.structure Format.std_formatter generated;
  Format.pp_print_flush Format.std_formatter ()
