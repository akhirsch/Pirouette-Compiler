main :=
  let A.x := A.print_sending A."hello from A"; in
  let B.y := B.print_waiting B."waiting on B"; in
  let C.z := C.print_idle C."idle"; in
  let D.p := D.print_done D."D is done"; in 
  A.();