main :=
  
  let A.idle := A.print_idle A."[A] idle"; in
  let G.idle := G.print_idle G."[G] idle"; in
  let M.idle := M.print_idle M."[M] idle"; in
  let A.start := A.sleep A.1; in

  
  let A.inbox := A."hot potato"; in
  let A.sending := A.print_sending A."[A] sending to G..."; in
  let G.waiting := G.print_waiting G."[G] waiting on A..."; in
  let G.inbox := [A] A.inbox ~> G; in
  let A.done := A.print_done A."[A] done"; in
  let A.nap := A.sleep A.1; in

  let G.sending := G.print_sending G."[G] sending to M..."; in
  let M.waiting := M.print_waiting M."[M] waiting on G..."; in
  let M.inbox := [G] G.inbox ~> M; in
  let G.done := G.print_done G."[G] done"; in
  let G.nap := G.sleep G.1; in


  let M.sending := M.print_sending M."[M] sending to A..."; in
  let A.waiting := A.print_waiting A."[A] waiting on M..."; in
  let A.final := [M] M.inbox ~> A; in
  let M.done := M.print_done M."[M] done"; in
  let A.done2 := A.print_done A."[A] received! done"; in
  
  let A.final := A.print_done A."[A] Complete! Message passed through all nodes."; in
  let G.fin := [A] A.final ~> G; in
  let G.done2 := G.print_done G."[G] Complete!"; in
  let M.fin := [A] A.final ~> M; in
  let M.done2 := M.print_done M."[M] Complete!"; in
  A.();