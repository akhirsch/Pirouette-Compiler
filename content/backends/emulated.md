+++
title = "Emulated Backend"
weight = 1
+++

The emulated backend runs NetIR programs cheaply by **logging** every
communication instead of performing it. Nothing is actually sent or received.
Each participant just prints what it _would_ have done.

This lets the team run compiled programs and debug the compiler without any
real networking, and the log gives cram tests something concrete to check.

## Pipeline

NetIR AST → `ocamlgen` → ppxlib Parsetree → `Pprintast` → one `.ml` file per participant

The backend has two parts:

- **`ocamlgen`** translates each participant's NetIR program into
  OCaml. It lives in `lib/NetIR/ocamlgen.ml`.
- **`Dummybackend`** is the library that defines what happens during communication.
  It lives in `lib/NetIR/backends/dummybackend.ml`.

## Generated files

Every generated file starts with a header that records which participant it
belongs to. For the emulated backend, we store all declared locations in an
OCaml variant. So the header when using the emulated backend uses that process's
constructor. Assuming our file is for "alice", in a network of "alice" and "bob":

```ocaml
type pir_emulated_location =
  | Pir_alice
  | Pir_bob

let pir_me = Pir_alice
```
The "Pir_" prefix is used to avoid naming collisions with user defined variable names.

Communication in NetIR becomes mainly print statements. This allows us to log communcations for quick
testing and verification, without requiring the infrastructure of actual communication.
Still assuming this is in the "alice" file:

| NetIR | Generated OCaml |
|---|---|
| `send X to bob` | `Printf.printf "%s/n%!" "alice would have sent X to bob"` |
| `receive int from bob` | `Printf.printf "%s/n%!" "alice would have received int from bob"` |
| `choose [L] for bob` | `Printf.printf "%s/n%!" "alice would have chosen L for bob"` |
| `allow bob choice \| [L] -> ...` | `TODO` |
| `AmI bob` | `match Pir_bob with \| Pir_alice -> true \| _ -> false` |

`send` is passed the payload twice: once as the text of the code being sent,
so it can be logged, and once as the actual value.

## The log

The log goes to stdout, one line per operation, prefixed with the participant's name.

## Receiving 

For now, both log the receive and then fail with an exception, so a generated program stops at its first receive