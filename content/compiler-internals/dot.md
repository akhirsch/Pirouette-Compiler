+++
title = "DOT"
weight = 1
+++

DOT is a language by GraphViz which allows you to define nodes and edges in a graph and render them visually. To generate DOT code, we want to walk the ast and represent each node of the ast as a string: node_name [label="Text"];. As we walk the tree, we will keep concatenating these nodes together. The DOT code can either be written to a file, or pasted directly into the command line.
To render DOT code in your command line:
For a file: dot -Tsvg ast.dot > output.svg
For a string: echo -e 'digraph { "n0 [label=\"Emulated Loc Decl [test.ml: 1:15--1:16]\"];\nn0 -> n1;\nn1 [label=\"Name example [test.ml: 2:20--2:50]\"];\n" }' | dot -Tsvg > output.svg

## Example DOT AST
Below is an example of a rendered DOT AST.
<img src="/img/example_dot_ast.svg" alt="Graph of nodes describing an AST">

For reference, this is the corresponding DOT code:
"digraph G {\n\
   n0 [label=\"Variant Decl [test.ml: 1:15--1:16]\"];\n\
   n0 -> n1;\n\
   n0 -> n2;\n\
   n1 [label=\"Name test [test.ml: 2:20--2:50]\"];\n\
   n2 [label=\"Variant Constructor\"];\n\
   n2 -> n3;\n\
   n2 -> n4;\n\
   n3 [label=\"Name typ1 [test.ml: 3:31--3:41]\"];\n\
   n4 [label=\"Var Type [test.ml: 4:10--4:20]\"];\n\
   n4 -> n5;\n\
   n5 [label=\"Name test [test.ml: 5:1--5:17]\"];\n\n\
   n6 [label=\"Import Decl [test.ml: 6:15--6:16]\"];\n\
   n6 -> n7;\n\
   n7 [label=\"Name test [test.ml: 7:20--7:50]\"];\n\n\
   n8 [label=\"Defn Decl [test.ml: 8:15--8:16]\"];\n\
   n8 -> n9;\n\
   n8 -> n10;\n\
   n8 -> n12;\n\
   n9 [label=\"Name test [test.ml: 9:20--9:50]\"];\n\
   n10 [label=\"Var Pat [test.ml: 10:31--10:41]\"];\n\
   n10 -> n11;\n\
   n11 [label=\"Name x [test.ml: 11:10--11:20]\"];\n\
   n12 [label=\"UnitLit [test.ml: 12:1--12:17]\"];\n\n\
   n13 [label=\"Type Alias Decl [test.ml: 13:15--13:16]\"];\n\
   n13 -> n14;\n\
   n13 -> n15;\n\
   n14 [label=\"Name test [test.ml: 14:20--14:50]\"];\n\
   n15 [label=\"Int Type [test.ml: 15:31--15:41]\"];\n\n\
   }\n"