# Dummy backend

Setup:

```ocaml
open Ppxlib
let loc = Location.none
let show e = print_endline (Pprintast.string_of_expression e)
let int_ty = Ast_builder.Default.ptyp_constr ~loc (Ast_builder.Default.Located.lident ~loc "int") []
```

Send logs the sender, payload and destination:

```ocaml
# show (Backend.Dummybackend.send "Bob" (Ast_builder.Default.eint ~loc 3) "Alice");;
Printf.printf "%s\n%!" "Bob: would have sent 3 to Alice"
- : unit = ()
```

Recv logs the expected type:

```ocaml
# show (Backend.Dummybackend.recv "Bob" int_ty "Alice");;
Printf.printf "%s\n%!" "Bob: would have received int from Alice";
Random.int 999
- : unit = ()
```

Choose logs the label and destination:

```ocaml
# show (Backend.Dummybackend.choose "Bob" "Alice" "L");;
Printf.printf "%s\n%!" "Bob: would have chosen L for Alice"
- : unit = ()
```

Recv label logs the receive:

```ocaml
# show (Backend.Dummybackend.recv_label "Alice" "Bob");;
Printf.printf "%s\n%!" "Alice: would have received a label from Bob";
Random.int 999
- : unit = ()
```

AmI checks against the participant's constructor:

```ocaml
# show (Backend.Dummybackend.am_i "Bob" (Ast_builder.Default.evar ~loc "x"));;
match x with | Pir_Bob -> true | _ -> false
- : unit = ()
```
