Choose prints to stdin:

  $ dune exec pirc -- -p cram_programs/choose.pir -o ./choose
  $ cat ./choose
  emulated location Alice
  emulated location Bob
  a := choose [L] for Alice;

Multi_loc prints to stdin:

  $ dune exec pirc -- -p cram_programs/multi_loc.pir -o ./multi_loc
  $ cat ./multi_loc
  emulated location Alice
  emulated location Bob
  emulated location Carol
  a := send 1 to Alice;
  b := send 2 to Bob;

Recv prints to stdin:

  $ dune exec pirc -- -p cram_programs/recv.pir -o ./recv
  $ cat ./recv
  emulated location Alice
  emulated location Bob
  a := recv int from Alice;

Send prints to stdin:

  $ dune exec pirc -- -p cram_programs/send.pir -o ./send
  $ cat ./send
  emulated location Alice
  emulated location Bob
  a := send 3 to Alice;
