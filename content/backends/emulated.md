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

- **`ocamlgen`** (compile time) translates each participant's NetIR program into
  OCaml. It lives in `lib/NetIR/ocamlgen.ml`.
- **`Dummybackend`** (runtime) is the library the generated files call into.
  It lives in `lib/NetIR/backends/dummybackend.ml`, in the `backend` library.

## Generated files

Every generated file starts with a header that records which participant it
belongs to:

```ocaml
let me = "alice"
let () = Backend.Dummybackend.who_i_am me
```

`me` is used by `AmI` checks, and `who_i_am` tells the runtime the participant's
name so every log line can include it.

Communication in NetIR becomes calls to the runtime:

| NetIR | Generated OCaml |
|---|---|
| `send X to Y` | `Backend.Dummybackend.send "Y" "X" x` |
| `receive T from Y` | `(Backend.Dummybackend.recv "Y" "T" : T)` |
| `choose [L] for Y` | `Backend.Dummybackend.choose "Y" "L"` |
| `allow Y choice \| [L] -> ...` | `match Backend.Dummybackend.recv_label "Y" with "L" -> ...` |
| `AmI Y` | `"Y" = me` |

`send` is passed the payload twice: once as the text of the code being sent,
so it can be logged, and once as the actual value.

## The log

The log goes to stdout, one line per operation, prefixed with the participant's name.

## Receiving 

For now, both log the receive and then fail with an exception, so a generated program stops at its first receive