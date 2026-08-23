+++
title = "Lesson 4"
description = "Using the Pirouette Compiler with NetIR"
weight = 1
+++

# Getting Help

You can get a help menu, explaining the various flags and how they are used, by writing `pirc -h` or `pirc --help`.

# Compiling Programs

In order to run a program with the simulated backend, we can write
```
pirc --netir -o alice.ml --backend simulated --location Alice alice.nir
```
Let's break this down.
The first flag tells the compiler that we're working with NetIR, rather than with Pirouette itself which is the default (see the Pirouette tutorial for writing Pirouette code).
The second says that the output (`-o` for "output") should be called `alice.ml`.
If the `-o alice.ml` argument is omitted, the compiler will by default print the code to the screen.
The third flag says that we should use the `simulated` backend.
This is currently the only backend, though other backends (such as an HTTP backend and a greenthread backend) are planned.
The fourth flag says that the location running this code is called `Alice`.
This is required by the simulated backend, though other backends (such as an MPI backend) may not require or even ignore this.
Finally, the input to the compiler is the file `alice.nir` (`nir` is a shortened version of NetIR).

This will produce a file called `alice.ml`, which contains OCaml code.
It can be compiled with the OCaml compiler and, if `main` is defined, run.

# Pretty-Printing Programs

In order to produce a pretty-printed version of the input code, we can use `--pretty-print` or `-P` instead of a `--backend` argument.
Thus, the following code will cause pretty-printed version of the code to appear on the screen:
```
pirc --netir --pretty-print alice.nir
```
Note that we do not need to supply `--location Alice` to the pretty printer.
In fact, doing so will be ignored.

You can produce an output file from the pretty printer by supplying an `-o` or `--output` argument.
Adding `-o alice-pretty.nir` will cause the pretty-printed code to be printed to the file `alice-pretty.nir` instead of `stdout`.
Importantly, you can supply the input file as the output file, so
```
pirc --netir -o alice.nir --pretty-print alice.nir
```
will replace the contents of `alice.nir` with their pretty-printed version, similar to `ocamlfmt`.

# AST Dotfiles

We can explore the AST structure of NetIR code using the `--dot` flag.
Thus, the following command will cause [Dot code](https://graphviz.org/doc/info/lang.html) representing the AST of the program in `alice.nir` to be printed to `stdout`.
```
pirc --netir --dot alice.nir
```
As with other files, a `-o` or `--output` parameter can be used to produce a file, for instance
```
pirc --netir --dot -o alice_netir.dot alice.nir
```
will cause the dot code to be printed to the file `alice_netir.dot` rather than `stdout`.

The program `dot` (provided by [graphviz](https://graphviz.org/)) can be used to turn this into a visual representation.
By default, this reads from `stdin` and produces output to `stdout`, so the following command will produce a file called `alice_netir.svg` that contains a lossless picture of Alice's NetIR program in AST form:
```
pirc --netir --dot alice.nir | dot -Tsvg > alice_netir.svg
```
For more on the `dot` program, see [the graphviz documentation](https://graphviz.org/doc/info/command.html).
