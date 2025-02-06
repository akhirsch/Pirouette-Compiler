{-2/6/2024

This is the pirouette translation of HasChor example of the carkey problem. When the car
is locked it will try to send a wake signal. If the wake signal is recieved by the key
then the key is present and will send a signal back to the car. Then, the car will send a challege 
for the key to compute locally. (for now the challenge is pseudo-code and not actually meant to
be computed. The answer from the key would be an input from the user) If the key sends the correct 
answer the car is unlocked, otherwise the car will lock.

-}

main := 

let CAR.locked := CAR.true; in
let KEY.present := KEY.false; in

if CAR.(locked)
  then CAR[L] ~> KEY;

    let KEY.receive_wake_signal := [CAR] CAR."myKey" ~> KEY; in
    if KEY.(receive_wake_signal = "myKey")

      then KEY[L] ~> CAR;
        let KEY.present := KEY.true; in
        let CAR.receive_present_signal := [KEY] KEY."Key Present" ~> CAR; in
        let KEY.problem := [CAR] CAR."Solve the challenge: 1+1 = ?\n" ~> KEY; in
        let CAR.answer := [KEY] KEY.input ~> CAR; in

        if CAR.(answer = "2")

          then CAR[R] ~> KEY;
            --this is where you would print a message about the car being unlocked
            let CAR.locked := CAR.false; in
            CAR.locked
            

          else CAR[L] ~> KEY;
            --this is where you would print a message about incorrect answer, or wake signal not recieved
            CAR.locked
            

      else KEY[R] ~> CAR;
        let CAR.locked := CAR.false; in
        CAR.locked
       

  else CAR[R] ~> KEY;

    
    let CAR.lock_signal := [KEY] KEY."LOCK" ~> CAR; in

    if CAR.(lock_signal = "LOCK") 

        then KEY[L] ~> CAR;
          let CAR.locked := CAR.true; in
          CAR.locked
              
        else KEY[R] ~> CAR;
          CAR.locked
          

      

{-
NetIR:
  CAR:

  locked : Bool
  locked = true -- to start
  Allow KEY choice
  | L => "Locked"
  | R => "Unlocked"

  let answer = recieve from KEY in
  let lock_signal = recieve from KEY in


  KEY:

  present : Bool
  present = false -- to start
  input : string
  Allow KEY choice
  | L => "Present"
  | R => "Not Present"

  let problem = receive from CAR in
  send input to CAR
  
-}



;