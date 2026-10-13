(* dummybackend.ml — runtime for emulated locations
   generated files call into this when they run
   nothing actually gets sent or recieved we just log it *)

(* ---- identity ---- *)
(* gets set once at the top of every generated file
   let () = Dummybackend.who_i_am me
   so the log knows who is talking *)
let me = ref ""
let who_i_am name = me := name

(* ---- log helper ---- *)
(* print to stdout instead of a file
   cram captures this directly so no log files to clean up *)
let log (msg : string) : unit =
  Printf.printf "%s: %s\n%!" !me msg

(* ---- outgoing ----
   just log and return unit and keep going
   ignoring the payload rn bc cant print a polymorphic 'a
   without a converter ASK ANDREW if we want the value too *)
let send (dest : string) (_v : 'a) : unit = log ("would have sent to " ^ dest)

(* logs which label got picked for dest *)
let choose (dest : string) (label : string) : unit =
  log ("would have chosen " ^ label ^ " for " ^ dest)

(* ---- incoming ----
   these have to return something so the program can keep going
   but theres no real value to give back so idk yet
   ASK ANDREW what recv should return
   failwith for now so generated files still typecheck *)
let recv (src : string) : 'a =
  log ("would have received from " ^ src);
  failwith "Dummybackend.recv: no value (emulated)"

(* same open question as recv but return type is always string
   this is what the AllowChoice match uses *)
let recv_label (src : string) : string =
  log ("would have received a label from " ^ src);
  failwith "Dummybackend.recv_label: no label (emulated)"
