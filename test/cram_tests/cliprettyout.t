Choose prints to stdout:

  $ dune exec pirc -- -p cram_programs/choose.pir
  emulated location Alice
  emulated location Bob
  a := choose [L] for Alice;

Multi_loc prints to stdout:

  $ dune exec pirc -- -p cram_programs/multi_loc.pir
  emulated location Alice
  emulated location Bob
  emulated location Carol
  a := send 1 to Alice;
  b := send 2 to Bob;

Recv prints to stdout:

  $ dune exec pirc -- -p cram_programs/recv.pir
  emulated location Alice
  emulated location Bob
  a := recv int from Alice;

Send prints to stdout:

  $ dune exec pirc -- -p cram_programs/send.pir
  emulated location Alice
  emulated location Bob
  a := send 3 to Alice;
