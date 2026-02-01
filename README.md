## Install dependencies

```sh
opam install . --deps-only --with-test
```

## Build pirc

```sh
dune build
```

## Run tests

```sh
dune test
```

## Build and execute

```sh
dune exec pirc -- [options] <file>
```

if it has been installed by `dune install` you can run it directly:

```sh
pirc [options] <file>
``` 

E.g.:

```sh
cd examples
dune exec pirc -- -ast-dump json ex1.pir
pirc -ast-dump json ex2.pir
```

Then `pirc` will parse the file and dump the ASTs to the current directory (in pretty-printed format by default).

## Options

- `-ast-dump <pprint|json>`: Dump the AST in pretty-printed (*default*) or JSON format.

- `-msg-backend <domain|http|mpi>`: Specify the backend for parallel execution. `domain` (*default*) for [Domain(thread)-based parallelism](https://ocaml.org/manual/parallelism.html); `http` uses the HTTP backend ; `mpi` uses the Message Passing Interface, often across multiple machines.

- `-<pprint|json|dot>`: Dump the AST in pretty-printed or JSON format, or generate a [DOT](https://graphviz.org/doc/info/lang.html) file for AST visualization.
>>>>>>> 035a805a22b24c518650e3499f7d2bd01ced7f52

- use `-` to read the source code from `stdin`. E.g.:

```sh
cat examples/ex1.pir | dune exec pirc -- -
```

- use `-o <file>` to write the output to a file. E.g.:

```sh
dune exec pirc -- -json examples/1.pir -o out
```

## Pipeline Testing

~Tests are added by placing <testcase>.pir and <testcase>.ans files in test/test_src, then running `dune test` in the root directory. The test runner will compile the `.pir` file, run the compiled program, and compare the output to the `.ans` file. If the output matches the `.ans` file, the test passes.~
[TODO]

## Documentation

```sh
make docs
```

Then open pdf files in `docs` directory.

## Contribute

- Install dependencies:

  ```sh
  opam install . --deps-only --with-test --with-dev-setup
  ```

- [Git Guides](https://github.com/git-guides)

    - Name your branch `<your-names>/<feature>`

    - [Make your PR small and focused](https://artsy.github.io/blog/2021/03/09/strategies-for-small-focused-pull-requests/)
  
- [OCaml Programming Guidelines](https://ocaml.org/docs/guidelines)

    - You can format your code using `dune fmt`

    - [Avoid using `open`](https://ocaml.org/docs/guidelines#opening-modules)
 
- You can enable repo-wide githooks to make sure your code is formatted and can build

    ```sh
    chmod +x .githooks/pre-commit
    ```

    ```sh
    git config core.hooksPath .githooks
    ```
