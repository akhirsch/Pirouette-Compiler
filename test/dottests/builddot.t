Test that dot files build correctly
  $ ./dotvisual.exe
  $ dot ast.dot -Tsvg -o output.svg
  $ ./dotspecialchar.exe
  $ dot ast.dot -Tsvg -o output.svg

