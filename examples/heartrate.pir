main := 
let LPF.x := LPF.0; in
let LPF.y := LPF.0; in
let AGC.x := AGC.0; in
let AGC.y := AGC.0; in

if LPF.(x != 0)
then LPF[L] ~> AGC;
let LPF.x := [AGC] AGC.x ~> LPF; in
  if AGC.(y != 0)
  then AGC[L] ~> LPF;
  let LPF.y := [AGC] AGC.y ~> LPF; in
  LPF.((x+y)/2)
  else AGC[R] ~> LPF;
  LPF.((x+y)/2)
  else LPF[R] ~> AGC;
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