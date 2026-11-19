Multi_loc_error results print:

  $ dune exec pirc -- -p -v cram_programs/multi_loc_error.pir
  Syntax error in  at line 4, column 7: send
  [1]


  $ dune exec pirc -- -d -v cram_programs/multi_loc_error.pir
  Syntax error in  at line 4, column 7: send
  [1]

  $ dune exec pirc -- -p -v cram_programs/multi_loc_error.pir -o ./output
  Syntax error in  at line 4, column 7: send
  [1]
  $ cat ./output
  cat: ./output: No such file or directory
  [1]

Choose_error results print:

  $ dune exec pirc -- -p -v cram_programs/choose_error.pir
  Syntax error in  at line 3, column 8: choose
  [1]

  $ dune exec pirc -- -d -v cram_programs/choose_error.pir
  Syntax error in  at line 3, column 8: choose
  [1]

  $ dune exec pirc -- -p -v cram_programs/choose_error.pir -o ./output
  Syntax error in  at line 3, column 8: choose
  [1]
  $ cat ./output
  cat: ./output: No such file or directory
  [1]

Send_error results print:

  $ dune exec pirc -- -p -v cram_programs/send_error.pir
  Syntax error in  at line 2, column 14: location
  [1]

  $ dune exec pirc -- -d -v cram_programs/send_error.pir
  Syntax error in  at line 2, column 14: location
  [1]

  $ dune exec pirc -- -p -v cram_programs/send_error.pir -o ./output
  Syntax error in  at line 2, column 14: location
  [1]
  $ cat ./output
  cat: ./output: No such file or directory
  [1]
