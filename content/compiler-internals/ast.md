+++
title = "ASTs"
weight = 1
+++

ASTs in the compiler are written using [modules](https://ocaml.org/docs/modules) and [functors](https://ocaml.org/docs/functors).
In particular, an AST module _type_ contains the AST described with abstract [metadata](@/compiler-internals/metadata.md), and then a functor allows that metadata to be instantiated.

## Transforming Metadata

The module `NetIR.Astmapper` describes a functor for AST _mappers_, which allow metadata to be transformed.
In particular, `NetIR.Astmapper.ASTMapper A1 A2`, where `A1` and `A2` are AST modules, describes how to use a function `f : A1.m -> A2.m` (i.e., a transformation of `A1` metadata into `A2` metadata) to transform `A1` trees into `A2` trees.
This is done using a simple tree walk.
