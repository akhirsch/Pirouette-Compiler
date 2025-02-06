{-tried using same variable names, or at least similar to be able to follow haschor code, it would a return a bool for whether or not the car is locked-}

main := 

let CAR.locked := CAR.true; in
let KEY.present := KEY.false; in

--when car is locked, locked == true, left branch
if CAR.(locked)
  then CAR[L] ~> KEY;

    let KEY.receive_wake_signal := [CAR] CAR."myKey" ~> KEY; in
    if KEY.(receive_wake_signal = "myKey" && present = true)

      then KEY[L] ~> CAR;
        let CAR.receive_present_signal := [KEY] KEY."Key Present" ~> CAR; in
        let KEY.problem := [CAR] CAR."Solve the challenge: 1+1 = ?\n" ~> KEY; in
        let CAR.answer := [KEY] KEY.input ~> CAR; in

        if CAR.(answer = "2")

          then CAR[R] ~> KEY;
            --this is where you would print a message about the car being unlocked
            let CAR.locked := CAR.false; in
            CAR.locked
            --CAR.print_endline CAR."LLR"

          else CAR[L] ~> KEY;
            --this is where you would print a message about incorrect answer, or wake signal not recieved
            let CAR.locked := CAR.true; in
            CAR.locked
            --CAR.print_endline CAR."LLL"

      else KEY[R] ~> CAR;
        
        let CAR.locked := CAR.true; in
        CAR.locked
        --CAR.print_endline CAR."LR"

  else CAR[R] ~> KEY;

    
      if KEY.(present)

        then KEY[L] ~> CAR;
          let CAR.lock_signal := [KEY] KEY."LOCK" ~> CAR; in

          if CAR.(lock_signal = "LOCK") 

            then CAR[L] ~> KEY;
              let CAR.locked := CAR.true; in
              CAR.locked
              --CAR.print_endline CAR."RLL"

            else CAR[R] ~> KEY;
              let CAR.locked := CAR.false; in
              CAR.locked
              --CAR.print_endline CAR."RLR"

        else KEY[R] ~> CAR;
          let CAR.locked := CAR.false; in
          CAR.locked
          --CAR.print_endline CAR."RR"

      

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

-- failed attempts

{-
--first attempt
match CAR with
| left -> match KEY with
            | left -> let CAR.answer := [CAR] CAR. ~> KEY.problem;
            | right -> CAR."Locked";
| right -> match KEY with
            |left -> CAR."Locked"
            |right -> CAR."Locked"

-}

{-if  then  send problem to key  else  car stays locked
| CAR."Unlocked" -> 
if KEY = "Present" then \- lock the car else autolock the car 
the idea of it but def not right syntax-}


;