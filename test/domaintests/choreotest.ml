(* 

to run this:
dune exec ./test/domaintests/choreotest.exe
dune exec ./test/domaintests/choreotest.exe > ./test/domaintests/generated_choreo.ml 

Then all of this:
ocamlfind ocamlopt -thread -package eio,eio_main -linkpkg \
  ./test/domaintests/generated_choreo.ml \
  -o ./test/domaintests/generated_choreo.exe
  
Next:
./test/domaintests/generated_choreo.exe

CLEAN UP: 
rm -f ./test/domaintests/generated_choreo.{ml,cmi,cmx,o,exe}
*)

open Ppxlib
module A = Netir.Nometa
module Gen = Netir.Eiogen.MkOcamlGen (A)
open A

let alice_prog =
  [
    emlocdecl "Alice";
    emlocdecl "Bob";
    defndecl "message" [] (send (intlit 42) "Bob");
  ]

let bob_prog =
  [
    emlocdecl "Alice";
    emlocdecl "Bob";
    defndecl "message" [] (recv intty "Alice");
    defndecl "check_message" []
      (mkmatch (var "message") [ (intlitpat 42, unitlit) ]);
  ]

(* Test the new choreography_gen function *)
let generated =
  Gen.choreography_gen [ ("Alice", alice_prog); ("Bob", bob_prog) ]

let () =
  Pprintast.structure Format.std_formatter generated;
  Format.pp_print_flush Format.std_formatter ()