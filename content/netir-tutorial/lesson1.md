+++
title = "Lesson 1"
weight = 1
+++

# Installing Pirouette

In order to install the Pirouette compiler, you will need to use [`git`](https://git-scm.com) and [`opam`](https://opam.ocaml.org/).

You can then install the dependencies with the line
```
opam install . --deps-only --with-test
```

Finally, you can build the compiler with the line
```
dune build
```

To make sure it's running, run the test suite with
```
dune exec pirc -- examples/ex1.pir
```
You should see `ex1.ml` as a file now.
You can compile this file

## Global installation

<p style="background-color:Tomato; text-align:center">
	<b>Warning!</b> This is <em>not</em> recommended. <br />
	You should run your code inside of the opam sandbox for now.
</p>

To install globally, you can type 
```
opam install .
```
At which point, you should be able to just run
```
pirc -- examples/ex1.pir
```
