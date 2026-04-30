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

  let M.sending := M.print_sending M."M sending to D..."; in
  let D.waiting := D.print_waiting D."D waiting on M..."; in
  let D.inbox := [M] M.inbox ~> D; in
  let M.done := M.print_done M."M send to D sucessful!"; in

  let D.sending := D.print_sending D."D sending to J..."; in
  let J.waiting := J.print_waiting J."J waiting on D..."; in
  let J.inbox := [D] D.inbox ~> J; in
  let D.done := D.print_done D."D send to J sucessful!"; in

  let J.sending := J.print_sending J."J sending to B..."; in
  let B.waiting := B.print_waiting B."B waiting on J..."; in
  let B.inbox := [J] J.inbox ~> B; in
  let J.done := J.print_done J."J send to B sucessful!"; in

  let B.sending := B.print_sending B."B sending to O..."; in
  let O.waiting := O.print_waiting O."O waiting on B..."; in
  let O.inbox := [B] B.inbox ~> O; in
  let B.done := B.print_done B."B send to O sucessful!"; in

  let O.sending := O.print_sending O."O sending to F..."; in
  let F.waiting := F.print_waiting F."F waiting on O..."; in
  let F.inbox := [O] O.inbox ~> F; in
  let O.done := O.print_done O."O send to F sucessful!"; in

  let F.sending := F.print_sending F."F sending to K..."; in
  let K.waiting := K.print_waiting K."K waiting on F..."; in
  let K.inbox := [F] F.inbox ~> K; in
  let F.done := F.print_done F."F send to K sucessful!"; in

  let K.sending := K.print_sending K."K sending to C..."; in
  let C.waiting := C.print_waiting C."C waiting on K..."; in
  let C.inbox := [K] K.inbox ~> C; in
  let K.done := K.print_done K."K send to C sucessful!"; in

  let C.sending := C.print_sending C."C sending to P..."; in
  let P.waiting := P.print_waiting P."P waiting on C..."; in
  let P.inbox := [C] C.inbox ~> P; in
  let C.done := C.print_done C."C send to P sucessful!"; in

  let P.sending := P.print_sending P."P sending to I..."; in
  let I.waiting := I.print_waiting I."I waiting on P..."; in
  let I.inbox := [P] P.inbox ~> I; in
  let P.done := P.print_done P."P send to I sucessful!"; in

  let I.sending := I.print_sending I."I sending to N..."; in
  let N.waiting := N.print_waiting N."N waiting on I..."; in
  let N.inbox := [I] I.inbox ~> N; in
  let I.done := I.print_done I."I send to N sucessful!"; in

  let N.sending := N.print_sending N."N sending to E..."; in
  let E.waiting := E.print_waiting E."E waiting on N..."; in
  let E.inbox := [N] N.inbox ~> E; in
  let N.done := N.print_done N."N send to E sucessful!"; in

  let E.sending := E.print_sending E."E sending to L..."; in
  let L.waiting := L.print_waiting L."L waiting on E..."; in
  let L.inbox := [E] E.inbox ~> L; in
  let E.done := E.print_done E."E send to L sucessful!"; in

  let L.sending := L.print_sending L."L sending to H..."; in
  let H.waiting := H.print_waiting H."H waiting on L..."; in
  let H.inbox := [L] L.inbox ~> H; in
  let L.done := L.print_done L."L send to H sucessful!"; in

  let H.sending := H.print_sending H."H sending to A..."; in
  let A.waiting := A.print_waiting A."A waiting on H..."; in
  let A.inbox := [H] H.inbox ~> A; in
  let H.done := H.print_done H."H send to A sucessful!"; in

  A.();