+++
title = "DOT"
weight = 1
+++

DOT is a language by GraphViz which allows you to define nodes and edges in a graph and render them visually. To generate DOT code, we want to walk the ast and represent each node of the ast as a string: node_name [label="Text"];. As we walk the tree, we will keep concatenating these nodes together. The DOT code can either be written to a file, or pasted directly into the command line.
To render DOT code in your command line:
For a file: dot -Tsvg ast.dot > output.svg
For a string: echo -e 'digraph { "n0 [label=\"Emulated Loc Decl [test.ml: 1:15--1:16]\"];\nn0 -> n1;\nn1 [label=\"Name example [test.ml: 2:20--2:50]\"];\n" }' | dot -Tsvg > output.svg

## section 2

