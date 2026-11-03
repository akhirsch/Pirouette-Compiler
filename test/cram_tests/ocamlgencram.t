Every example compiles without errors:

  $ for example in cram_programs/*.pir; do
  > pirc $example
  > rm -f *.ml
  > done

Send is logged:

  $ pirc cram_programs/send.pir
  $ ocaml Bob.ml
  Bob: would have sent 3 to Alice
  $ rm -f *.ml

Recv is logged:

  $ pirc cram_programs/recv.pir
  $ ocaml Bob.ml
  Bob: would have received int from Alice
  $ rm -f *.ml

Choose is logged:

  $ pirc cram_programs/choose.pir
  $ ocaml Bob.ml
  Bob: would have chosen L for Alice
  $ rm -f *.ml

A participant can talk to more than one location:

  $ pirc cram_programs/three_locations.pir
  $ ocaml Carol.ml
  Carol: would have sent 1 to Alice
  Carol: would have sent 2 to Bob
  $ rm -f *.ml
  