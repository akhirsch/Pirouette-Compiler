main := 
let LPF.x := [AGC] AGC.x ~> LPF; in
let LPF.y := [AGC] AGC.y ~> LPF; in
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