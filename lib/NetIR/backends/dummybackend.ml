open Ppxlib
open Ast_builder.Default

let loc = Location.none

(* dummybackend.ml — runtime for emulated locations.
   Generated participant files call into this module. Every communication
   operation logs the event to a file; nothing is really sent or received.
  Each function name here must match what ocamlgen.ml emits *)

(* dummybackend.ml is the runtime: it defines 
   it defines send, recv, choose, recv_label, me
    runs when the generated file runs, and does the logging.*)

    (* log also what are sending and recieveing we want a log that is very deatailed
    this is going to be helpful for cram tests so we have all *)
    
(* ---- Identity ---------- *)
let who_i_am me =
      [%stri let _ = [%e estring ~loc me]]

(* ---- Log helper ---------------------
   Append one line to the log file privet HELPER to this module 
   generated code never calls it directly i think i need this to 
   see how my log is structured*)

(* TODO: implement log : string -> unit *)

(* ---- Outgoing operations ---------
   Handled at this point: log the event, return unit, continue
   no payload
   CONFIRM WITH ANDREW — we only record THAT something was sent to [dest], not its value? *)

(* TODO: implement send : string -> 'a -> unit
   Logs that a value was sent to [dest] 
   remember ignores the payload *)

(* TODO: implement choose : string -> string -> unit
   Logs that label [label] was chosen for [dest]. *)

(* ---- Incoming operations --------------------------------------------------
    must return a value so the generated program can continue, and the
   emulated backend has no real value to give -> is this how i should be doing things?!?!?!

   ASK ANDREW : what should recv return?  *)

(* TODO: implement recv : string -> 'a
   Logs a receive from [src], then returns a value per the decision above.
   (Placeholder for now: log then failwith so any generated file typechecks.) *)

(* TODO: implement recv_label : string -> string
   Logs a label-receive from [src], then returns the arrived label as a string.
   Used as the match subject in the AllowChoice branch. Same open question as
   recv, but the return type is fixed (string) *)
