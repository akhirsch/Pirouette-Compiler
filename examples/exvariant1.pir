type testing :=
  | None
  | Some of P1.int
;

main :=
  let P1.x := P1.Some(123); in
  match P1.x with
  | None() -> P1.0
  | Some(n) -> P1.n
;