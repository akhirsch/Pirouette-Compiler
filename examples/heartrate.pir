{-2/6/2025

This is the translation of heartrate.hs into pirouette code. 
Heartrate has two loactions, AGC and LPF. AGC sends two values 
to LPF, and then LPF computes the average locally 

-}



main := 
let LPF.x1 := [AGC] AGC.x2 ~> LPF; in
let LPF.y1 := [AGC] AGC.y2 ~> LPF; in
LPF.((x1+y1)/2)


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