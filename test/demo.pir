{-Start → OFF
Node A → Node G 
Node G → Node M
Node M → Node D
Node D → Node J
Node J → Node B
Node B → Node O
Node O → Node F
Node F → Node K
Node K → Node C
Node C → Node P
Node P → Node I 
Node I → Node N 
Node N → Node E 
Node E → Node L
Node L → Node H
Node H → Node A
END → OFF
-}
{- for the new http fix to work you on your machine you have to run these two commands:
dune build @install
dune install 

command for running the demo:
dune exec bin/main.exe -- test/demo.pir --msg-backend http   
-}

main :=
  let A.idle := A.print_idle A."[A] idle"; in
  let B.idle := B.print_idle B."[B] idle"; in
  let C.idle := C.print_idle C."[C] idle"; in
  let D.idle := D.print_idle D."[D] idle"; in
  let E.idle := E.print_idle E."[E] idle"; in
  let F.idle := F.print_idle F."[F] idle"; in
  let G.idle := G.print_idle G."[G] idle"; in
  let H.idle := H.print_idle H."[H] idle"; in
  let I.idle := I.print_idle I."[I] idle"; in
  let J.idle := J.print_idle J."[J] idle"; in
  let K.idle := K.print_idle K."[K] idle"; in
  let L.idle := L.print_idle L."[L] idle"; in
  let M.idle := M.print_idle M."[M] idle"; in
  let N.idle := N.print_idle N."[N] idle"; in
  let O.idle := O.print_idle O."[O] idle"; in
  let P.idle := P.print_idle P."[P] idle"; in
  {- then the chain begins -}
  let A.inbox := A."hello there!"; in
  let A.sending := A.print_sending A."A sending to G..."; in
  let G.waiting := G.print_waiting G."G waiting on A..."; in
  let G.inbox := [A] A.inbox ~> G; in
  let A.done := A.print_done A."A send to G sucessful!"; in
  let G.sending := G.print_sending G."G sending to M..."; in
  let M.waiting := M.print_waiting M."M waiting on G..."; in
  let M.inbox := [G] G.inbox ~> M; in
  let G.done := G.print_done G."G send to M sucessful!"; in
  M.();