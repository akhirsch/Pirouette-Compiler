+++
title = "Types"
description = "Types in NetIR"
weight = 1
+++
NetIR is a typed programming language.

# Base Types

The base types of NetIR are as follows:
- `unit`
- `int`
- `float`
- `char`
- `string`
- `bool`

Each has its usual meaning.

# Function Types

Function types `t1 -> t2` have their usual meaning in functional programming.
Note that they are right-associative, so `t1 -> t2 -> t3` means `t1 -> (t2 -> t3)`, as is standard.

# Location Types

Locations in NetIR are the names of computational units running NetIR code.
These can be OS processes, HTTP nodes, MPI processes, or more.
They are also the basic unit of [communication](@/netir/communication.md).
NetIR code always runs on some process; we can probe the current process using [`AmI`](@/netir/ami.md).

A location type has the form `location {l1, l2, l3}`.
This is the type of location that can be any of `l1`, `l2`, or `l3`.
Each of these is the name of a previously-declared location.
The special location type `location` can be _any_ location.

# Type Aliases

Type aliases can be defined as
```
type tname := t
```
This declares `tname` as an alias for `t`; it will be treated as the same as `t` everywhere.

## Future Declaration

We may want to, in the future, allow for the creation of a type alias that is _not_ treated as the same as `t` everywhere.
Right now, you can do this by using an ADT (described below).
This requires explicit marshaling and unmarshaling using a constructor name, but that's okay.

# Algebraic Data Types

NetIR supports algebraic data types.
They are declared using the following syntax:
```
type tname :=
| cname : t1 -> t2 -> ... -> tn -> tname
...
```
Here, `tname` is the name of the newly-declared type, while `cname` is the name of a newly-declared constructor.
That constructor takes in `n` arguments, with types `t1` through `tn`.
The last type in the type of a constructor must always be the type name itself.

## A note on parsing

We parse ADT declarations by allowing constructors to have _arbitrary_ types.
This requires a more-flexible type ADT.
We then transform this ADT into a standard ADT, checking that the types of constructors are correct at that point.
This transformation might be best to do as part of typechecking.

# Records

NetIR does _NOT_ currently support record types.
Fixing this is future work.
