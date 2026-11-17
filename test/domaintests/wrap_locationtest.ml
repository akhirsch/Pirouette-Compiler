open Ppxlib

(* this test is verifying that the module Loc_Alice is generated and that
the AST source code that will be printed can be examined so that we can 
unserstand if wrap_location inside eiogen.ml  is working correctly. 
  
command to run test: dune exec ./test/domaintests/wrap_locationtest.exe *)
let loc = Location.none

let header =
  [
    [%stri type pir_emulated_location = Pir_Alice | Pir_Bob];
    [%stri let pir_me = Pir_Alice];
    [%stri let pir_am_i l = l = pir_me];
  ]

let defns =
  [
    [%stri let message = Pir_runtime.send pir_chans ~me:"Alice" ~dest:"Bob" 42];
  ]

let () =
  let generated = Eio_domains_backend.wrap_location "Alice" header defns in
  Pprintast.structure Format.std_formatter generated;
  Format.pp_print_flush Format.std_formatter ()
