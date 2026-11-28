open Ppxlib

(*
   Label Communication Test

   Purpose:
   This test verifies that the Eio backend correctly generates
   and executes label communication between two participants.

   Alice sends the label "continue" to Bob. Bob receives the
   label and executes the corresponding branch.

   This is a positive test designed to verify that valid label
   communication completes successfully.

   Compiler Warning Investigation:
   This test was also created to investigate warning 32 (unused value declarations)

   Previous integer communication tests used send and recv, leaving send_label and recv_label unused.

  Verifies:  that unused declaration warnings depend on which generated runtime 
  functions the program requires.

  How to run this test: 

   1. Inspect the generated OCaml AST:
      dune exec ./test/domaintests/labeltest.exe

   2. Generate the OCaml program:
      dune exec ./test/domaintests/labeltest.exe \
        > ./test/domaintests/generated_label.ml

   3. Compile the generated program:
      ocamlfind ocamlopt -thread -package eio,eio_main -linkpkg \
        -I test/domaintests \
        -w +a -warn-error -a \
        ./test/domaintests/generated_label.ml \
        -o ./test/domaintests/generated_label.exe

      Note:
      The -w +a flag enables all compiler warnings.
      The -warn-error -a flag prevents warnings from being
      treated as compilation errors.

      No compiler warnings are suppressed.
      Warning 70 (missing-mli) is expected because the generated
      program does not have an explicit interface file.

      Manual compilation is used to isolate runtime behavior
      from the unresolved unused declaration warnings
      encountered during Dune compilation.

   4. Execute the generated program:
      ./test/domaintests/generated_label.exe

   5. Check the exit status:
      echo $?

   Expected Results:
   - OCaml code generation succeeds.
   - Compilation succeeds.
   - Alice successfully sends the label "continue".
   - Bob receives the label and executes the expected branch.
   - No runtime errors are reported.
   - The program returns an exit status of 0.

   No terminal output is expected during successful execution
   because the generated program contains no print statements.

   Cleanup:
   Remove the temporary generated source and compilation
   artifacts after completing the test:
      rm -f test/domaintests/generated_label.{ml,mli,cmi,cmx,o,exe}

   Related Test:
   labelerrortest.ml is the corresponding negative test.
   It intentionally sends an unexpected label to verify that
   the generated error-handling mechanism reports the failure.
*)

module A = Netir.Nometa
module Gen = Netir.Eiogen.MkOcamlGen (A)
open A

let alice_prog =
  [
    emlocdecl "Alice";
    emlocdecl "Bob";
    defndecl "_send_label" []
      (choosefor "Bob" (mklab "continue"));
  ]

let bob_prog =
  [
    emlocdecl "Alice";
    emlocdecl "Bob";
    defndecl "_receive_label" []
      (allowchoice "Alice"
         [
           (mklab "continue", unitlit);
         ]);
  ]

let generated =
  Gen.choreography_gen
    [ ("Alice", alice_prog); ("Bob", bob_prog) ]

let () =
  Pprintast.structure Format.std_formatter generated;
  Format.pp_print_flush Format.std_formatter ()