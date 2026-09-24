(* dummybackend.ml — runtime for emulated locations.
   Generated participant files call into this module. Every communication
   operation logs the event to a file; nothing is really sent or received.
   Plain OCaml — no ppxlib. Each function name here must match what
   ocamlgen.ml emits. *)

(* ---- Identity -------------------------------------------------------------
   Who this running process is. 
   Needed by the AmI branch (compares a location against this) and used to prefix every log line

   ASK ANDREW : where does identity come from?
     (a) argv — one compiled program, run once per participant:
         ./alice Alice   ->   set_me Sys.argv.(1)
     (b) baked in per file — program_gen emits the name into each file.

   This decides three things that must agree: 
   - this definition, 
   - what program_gen emits at the top of each file
   - how the AmI branch in ocamlgen.ml spells its reference (bare [me] / [!me] / [Dummybackend.me])
   Also: is [me] a value or a function? *)

(* TODO: implement identity storage/ how to accesss
  storage — where should we keep the name? 
  let me : string ref = ref "" 
  A ref because if identity comes from argv, the name isn't known 
  until the program starts, so something has to set it after.
  accessing — how the rest of the code gets the identity 
  Reading a ref is !me; 
  setting it is a little function let set_me name = me := name, called once at startup. *)

(* ---- Log helper -----------------------------------------------------------
   Append one line to the log file. Private to this module — generated code
   never calls it directly.

   TODO(Andrew): log format — human-readable (current plan: "who: event target")
   or a machine-diffable trace we can compare against an expected run in tests?
   TODO(Andrew): fixed filename "emu.log", or one log per participant, or a
   path passed in? *)

(* TODO: implement log : string -> unit *)

(* ---- Outgoing operations --------------------------------------------------
   Handled at this point: log the event, return unit, continue. The payload is
   intentionally ignored 
   CONFIRM WITH ANDREW — we only record THAT something was sent to [dest], not its value? *)

(* TODO: implement send : string -> 'a -> unit
   Logs that a value was sent to [dest] 
   remember gnores the payload *)

(* TODO: implement choose : string -> string -> unit
   Logs that label [label] was chosen for [dest]. *)

(* ---- Incoming operations --------------------------------------------------
    must return a value so the generated program can continue, and the
   emulated backend has no real value to give -> is this how i should be doing things?!?!?!

   ASK ANDREW : what should recv return? Options:
     1. log-and-abort: log, then failwith. Program runs up to the first
        receive, then stops this seems the simplest and is enough to compile and run the send path.

     2. per-type defaults: recv_int -> 0, recv_string -> "", etc. 
        Translator picks the function from the type annotation. Runs to completion for
        base types, but user-defined types (VarTy) have no default.

     3. read from an input file/script: turns emulation into a scripted test
        harness. Most useful, most work, still needs per-type parsing

   Whichever we pick changes only these functions (and possibly splits recv
   into per-type variants that ocamlgen.ml chooses between). *)

(* TODO: implement recv : string -> 'a
   Logs a receive from [src], then returns a value per the decision above.
   (Placeholder for now: log then failwith so any generated file typechecks.) *)

(* TODO: implement recv_label : string -> string
   Logs a label-receive from [src], then returns the arrived label as a string.
   Used as the match subject in the AllowChoice branch. Same open question as
   recv, but the return type is fixed (string), so option 2 (return a default
   label) is available here without the VarTy problem. *)