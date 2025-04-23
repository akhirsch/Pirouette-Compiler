main :=
  let P1.x := P2.6; in
  match P1.x with
  |P2.0 -> P1."Zero"
  |P2.1 -> P1."One"
  |_ -> P1."Other"
;