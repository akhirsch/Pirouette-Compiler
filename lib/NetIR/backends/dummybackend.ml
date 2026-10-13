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
let log (msg : string) : unit = Printf.printf "%s: %s\n%!" !me msg

(* ---- outgoing ----
   what is the code text of the payload so the log shows whats being sent
   v is the actual value passed along like andrew said
   not printing v itself bc we dont know its type at runtime *)
let send (dest : string) (what : string) (_v : 'a) : unit =
  log ("would have sent " ^ what ^ " to " ^ dest)

(* logs which label got picked for dest *)
let choose (dest : string) (label : string) : unit =
  log ("would have chosen " ^ label ^ " for " ^ dest)

(* ---- incoming ----
   ty is the type we expected to get so the log shows that
   still no real value to give back so failwith for now *)
let recv (src : string) (ty : string) : 'a =
  log ("would have received " ^ ty ^ " from " ^ src);
  failwith "Dummybackend.recv: no value (emulated)"

(* same open question as recv but return type is always string
   this is what the AllowChoice match uses *)
let recv_label (src : string) : string =
  log ("would have received a label from " ^ src);
  failwith "Dummybackend.recv_label: no label (emulated)"
