# Notes on our Standard Library

By default, the `stdlib_linker ()` function (invoked by `main.ml`) will return the Abstract Syntax Tree saved within `stdlib_ast.ml`. `stdlib_compiler.ml` will generate three standard libraries (one for each interface ie. domain/mgi/etc), and `stdlib_linker.ml` will link the correct stdlib based on which is needed at runtime / Pirouette-program compile-time.

However, the behavior of `stdlib_linker ()` can be configured to recompile the standard library.

## Prerequisites
1. Have a PIR_STDLIB environment variable on your system which points to the Pirouette Standard Library you would like to compile and save to `stdlib_ast.ml`
2. Go into `main.ml` and change `stdlib_linker ()` to `stdlib_linker ~recompile:true ()`
3. Create a dummy.pir file and leave it empty
4. [Optional] Create a test.pir file and write pirouette code that references any newly added standard library functions

## Steps
`cd` into your Pirouette Compiler top-level directory (the one containing /lib, /examples, /bin, etc. ) and run `dune clean; dune build`. We need to do this so that the changes we wrote in main are built back into the compiler. Then `cd` into the directory containing your `dummy.pir` file and run `dune exec pirc dummy.pir`. We need to do this so that the `stdlib_compiler ()` function, invoked from `stdlib_linker`, compiles and saves our standard library into `stdlib_ast.ml`. Now, go back to `main.ml` and change `stdlib_linker ~recompile:true ()` back to `stdlib_linker ()`, then `cd` back to your Pirouette Compiler top-level directory and run `dune clean; dune build` again. We need to do this last step so that the `stdlib_ast.ml` file that has our compiled standard library information is built into the compiler as a proper Dune package that can be referenced by other OCaml files. If you want to test to make sure everything got rebuilt correctly, take your test.pir (which calls or references a newly added identifier you just added to the Standard Library) and run `dune exec pirc test.pir`. You will see the normal outputted binaries and .ml files.

After this, your standard library should be compiled and saved into `stdlib_ast.ml` where all future invocations of `stdlib_linker ()` will grab your compiled standard library.