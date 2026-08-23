+++
title = "Functional Programming"
weight = 1
+++

NetIR is a functional programming language with builtin [communication primitives](@/netir/communication.md).

# Basics

Basic functional programming comes from primitive data and primitive operations.
Booleans, integers, floats, characters, and strings are all primitive data.
Integer and float addition, subtraction, multiplication, and division are all defined, as are the logical `&&` and `||` operators on booleans.
We also have boolean `~` and integer/float `-` negation.
Adding appropriate primitives for characters and strings still needs to be done.

# Functions

Anonymous recursive functions can be created with the syntax `fun f x := e`, where `f` is the internal name of the function for recursive calls, and `x` is the argument to the function.
You can write `fun x := e` for an anonymous non-recursive function, but this is treated as syntactic sugar for `fun _f x := e`, where `_f` is a special name that does not appear in the body `e`.

Alternatively, functions may be defined in a more-permanent way as a definition.
We write
```
f : t1 -> t2
f x = e
```
To mean that `f` is declared to be a function from type `t1` to type `t2`, where `e` is the body whenever `x` is the argument.

# Pattern Matching

Function definitions can be split into multiple cases for pattern matching.
For instance, we can write
```
fib : int -> int
fib 0 = 1
fib 1 = 1
fib n = fib (n - 1) + fib (n - 2)
```
for the Fibonacci function.

Alternatively, we can use `match` as follows:
```
fib : int -> int
fib n = match n with
        | 0 => 1
        | 1 => 1
        | _ => fib (n - 1) + fib (n - 2)
        end
```
