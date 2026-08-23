+++
title = "Metadata"
description = "Metadata in the Pirouette Compiler"
weight = 1
+++

Look at the type of NetIR unary operation ASTs inside the Pirouette compiler:
```ocaml
type unop = Neg of m | Not of m
```
Both `Neg` and `Not` contain data of type `m`.
This is the type of abstract _metadata_.

This metadata collects any information about this term that has been gleaned by the compiler so far.
For instance, the parser produces an AST where the metadata has information about what file the term is found in, along with where in the file the term is found.
Similarly, the typechecker adds type information to the metadata, so that every expression has a type.

# Abstraction via Modules

The file `ast.mli` defines a module type ("signature") of ASTs.
This defines the AST datatype, but it keeps the type `m` of metadata abstract.
It then contains this line:
```ocaml
module MkAST : functor (M : Metainfo.Meta.Metainfo) -> AST with type m = M.t
```
This declares a _functor_, or a function from modules to modules.
Given a module `M` containing metainformation, the module `MkAST(M)` is an AST where the abstract type `m` is the type `M.t` of metainformation.

## The Metainfo Module Type

Outside of NetIR, the `Metainfo` module type declares that any type `t` with a function
```ocaml
val string_of_mi : t -> string
```
is valid metainfo.
Any module of this type can be used to create an AST type.

## Important Metainfo Modules
Two important modules of metainformation can be found in the module `Metainfo.Meta`.
The first is the _trivial_ metainformation, where `t = unit`.
Since `unit` represents uninteresting information, using the `MkAST` functor with the `TrivInfo` module as input represents a version of the AST with "no" metainformation.
(See [below](#asts-without-metainformation) for more information.)

The second is _position information_.
This contains data about where in a project a term is located.
For instance, imagine that `alice.nir` contains the code
```
main = ()
```
Then the expression `()` in the resulting AST would tell us that it is in the file `alice.nir`, on line `1` and columns `7-8`.
The type representing this is the following record:
```ocaml
type t = {
  filename : string;
  start : int * int (*line, column *);
  stop : int * int;
}
```

# ASTs without Metainformation

Sometimes it is useful to be able to create ASTs on the fly without generating metainformation.
This is especially true when testing.
The best way to do this is to use the trivial metainformation described above.
Doing so, however, leads to a lot of annoying boilerplate code.

The module `Netir.Nometa` automates away a lot of that boilerplate.
It includes the type of ASTs with trivial metadata, along with a number of [_smart constructors_](https://wiki.haskell.org/Smart_constructors).
Smart constructors are functions that "act like" the constructor of some type, but they allow you to do runtime shenanigans.
You can use them to check that invariants hold (like some data is always within bound), to do [runtime optimization](https://blog.greenberg.science/posts/smart-constructors-are-smarter-than-you-think/), or (as in this case) to reduce boilerplate.

As a simple example, consider the code
```ocaml
let varty (x : string) = VarTy ((), ((), x))
```
This creates a variable type from a string.
The `VarTy` constructor in `ast.mli` is declared as `| VarTy of m * name`, where `name` is declared as `type name = m * string`.
This means you need to store two pieces of metadata along with the string representing the type variable.
But that metadata is just `()`, making this unnecessary boilerplate!
The `varty` smart constructor gets rid of that boilerplate for you, so you only need to write `varty "foo"` to create a type variable called `foo`.

For another example, consider
```ocaml
let unop u e = Unop ((), u, e)
let mkneg = unop neg
let mknot = unop not
```
The first line is a smart constructor that takes two arguments: a unary operator and its operand.
However, there are only two possible unary operators!
So, rather than making you write `unop neg 3` to create the program `- 3`, the next line allows you to write `mkneg 3`.

