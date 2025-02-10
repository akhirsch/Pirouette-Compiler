main := 

let LPF.x := LPF.1; in
let LPF.y := LPF.1; in
let AGC.x := AGC.1; in
let AGC.y := AGC.1; in

let LPF.x := [AGC] AGC.x ~> LPF; in
-- this is where I would wait
let LPF.y := [AGC] AGC.y ~> LPF; in
-- this is where I would wait
LPF.((x+y)/2)


{-
NetIR:
  AGC:
  x : float
  y : float
  send x to LPF
  send y to LPF
  

  LPF:
  let x = receive from AGC in 
  let y = receive from AGC in
  x + y / 2
-}
;