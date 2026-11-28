open Ppxlib

(* This test generates a complete OCaml program in which Alice
   sends the integer 42 to Bob. Bob checks that the received
   value is correct.

   The generated OCaml code must be compiled and executed
   separately to verify successful runtime communication 
   
   How to compile and execute the code:
   dune build
   dune exec ./test/domaintests/full_test.exe 
   dune exec ./test/domaintests/full_test.exe > ./test/domaintests/generated_eio.ml 
   
  NEXT BOTH of these lines as one command:
   ocamlfind ocamlopt -thread -package eio,eio_main -linkpkg \
  ./test/domaintests/generated_eio.ml -o ./test/domaintests/generated_eio.exe
   
  Continue with:
  ./test/domaintests/generated_eio.exe
  Note: the output will be empty this signals a successful compiled program
  
  CLEAN UP:
  rm -f test/domaintests/generated_eio.{ml,cmi,cmx,o,exe}
  *)

module A = Netir.Nometa
module Gen = Netir.Eiogen.MkOcamlGen (A)
open A

let alice_prog =
  [
    emlocdecl "Alice";
    emlocdecl "Bob";
    defndecl "_message" [] (send (intlit 42) "Bob");
  ]

let bob_prog =
  [
    emlocdecl "Alice";
    emlocdecl "Bob";
    defndecl "message" [] (recv intty "Alice");
    defndecl "_check_message" []
      (mkmatch (var "message")
         [
           (intlitpat 42, unitlit);
           ( wildcardpat,
             funapp (var "failwith")
               (stringlit "Bob received an incorrect message from Alice") );
         ]);
  ]

let generated =
  Eio_domains_backend.runtime
  @ Gen.program_gen "Alice" alice_prog
  @ Gen.program_gen "Bob" bob_prog
  @ Eio_domains_backend.entry_point [ "Alice"; "Bob" ]

let () =
  Pprintast.structure Format.std_formatter generated;
  Format.pp_print_flush Format.std_formatter ()
