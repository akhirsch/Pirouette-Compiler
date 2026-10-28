Every example compiles without errors:

  $ for example in cram_programs/*.pir; do
  > pirc $example
  > rm -f *.ml
  > done

Send is logged:

  $ pirc cram_programs/send.pir
  $ ocaml Bob.ml
  $ rm -f *.ml

Recv is logged:

  $ pirc cram_programs/recv.pir
  $ ocaml Bob.ml
  $ rm -f *.ml

Choose is logged:

  $ pirc cram_programs/choose.pir
  $ ocaml Bob.ml
  $ rm -f *.ml

A participant can talk to more than one location:

  $ pirc cram_programs/three_locations.pir
  $ ocaml Carol.ml
  $ rm -f *.ml