+++
title = "Lesson 2"
weight = 1
+++

# Your first NetIR program

NetIR programs consist of a series of _declarations_.
Declarations include _type declarations_, _definitions_, and _type definitions_.
The special name `main` indicates the entry point of a program.

Definitions give names to data, including functions.
We can write our first functions as follows:
```
fib : int -> int
fib x := if x == 0
         then 1
  		 else if x == 1
		      then 1
		      else fib (x - 1) + fib (x - 2)
```
This computes the famous _Fibonacci sequence_. 
Note that we start by declaring its type: `fib : int -> int`.
Then, we declare the function: we write `fib x`, where `x` is the input variable (of type `int`, according to our earlier type declaration).
We then write `:=` to tell the compiler that this is a definition.
We then write the body of the function.
Note that this looks and feels just like a "normal" functional programming language, because NetIR _is_ a normal functional programming language!

# Creating Data Types

You can define a _type alias_ as follows:
```
type foo := int
```
Now, the type `foo` will mean the same thing as `int`:
```
bar : foo
bar := 6
```
Note that we have declared `bar` to have type `foo`, but we have defined `bar` to be `6`, which is an integer.
Since `foo` is just `int`, this is no problem!

We can then define more-complicated data types as follows:
```
type baz := 
| bax : baz
| bay : foo -> baz
```
This declares an _algebraic datatype_ (or _variant_) with two constructors: `bax`, which takes no inputs; and `bay`, which takes one `foo` (or `int`) input.

We can then write a function over this datatype using pattern matching as follows:
```
baz_to_int : baz -> int
baz_to_int bax     := -1
baz_to_int (bay n) := n
```
Note that we have _two_ definitions of `baz_to_int`, one for each pattern.
The first one says what to do if the input is a `bax`: return the default value `-1`.
The second one says what to do if the input is a `bay`: return the value `n` stored inside the data the data we were given.
