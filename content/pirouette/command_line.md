+++
title = "Command Line"
weight = 1
+++

# Interface

The command line interface (CLI) allows the use of the Pirouette compiler directly from the command line with a varied number of flags.

To compile a Pirouette program called `example.pirc` into OCaml, you would write `dune exec pirc -- example.pirc -o output.ml`

# Flags

The CLI comes with various flags that can be used to change how input is taken, change what is output, or both.

- `--output`: Allows compiler to output into a file, otherwise `stdout` will be used. Can also be set with `-o`.
- `--verbose`: Outputs debug information along with standard output. Can also be set with `-v`.
- `--input`: Allows taking a string of Pirouette code instead of a file. An example is `dune exec pirc -- --input "type foo := int" -o output.ml`. Can also be set with `-i`.
- `--pretty`: Displays the input as a pretty-printed AST. Note that if this flag is set, an ocaml file will not be created. Can also be set with `-p`.
- `--dot`: Creates DOT code representing the input as an AST that can be visualized as a graph. Note that if this flag is set, an ocaml file will not be created. Can also be set with `-d`.
