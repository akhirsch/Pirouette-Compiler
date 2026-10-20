(* dummybackend.ml — runtime for emulated locations
   generated files call into this when they run
   nothing actually gets sent or recieved we just log it *)
open Ppxlib
open Ast_builder.Default

let loc = Location.none
(* ---- Location type ---- *)
(* Returns the location type. We know in this backedn that locations are
   all member of the variant constructed in "who_i_am." Thus, we can simply
   return that variant as our type.*)
let location_type _ =
   ptyp_var ~loc "pir_me"

(* ---- identity ---- *)
(* gets set once at the top of every generated file
   let () = Dummybackend.who_i_am me
   so the log knows who is talking *)
let who_i_am name = 
   [%stri let pir_me = [%e estring ~loc name]]

(* ---- log helper ---- *)
(* print to stdout instead of a file
   cram captures this directly so no log files to clean up *)
let log  (msg : string) : Ppxlib.expression = 
   [%expr Printf.printf "%s: %s\n%!" pir_me [%e estring ~loc msg]]

(* ---- outgoing ----
   what is the code text of the payload so the log shows whats being sent
   v is the actual value passed along like andrew said
   not printing v itself bc we dont know its type at runtime *)
let send (payload : expression) (dest : string) =
   let what = Pprintast.string_of_expression payload in
      log ("would have sent " ^ what ^ " to " ^ dest)
  
(* ---- incoming ----
   ty is the type we expected to get so the log shows that
   still no real value to give back so failwith for now *)
let recv (ty : core_type) (src : string) : expression =
   let ty_text = Format.asprintf "%a" Pprintast.core_type ty in
   let log_expr = log ("would have received " ^ ty_text ^ " from " ^ src) in
      [%expr [%e log_expr]; Random.int 999]

(* logs which label got picked for dest *)
let choose (dest : string) (label : string) = (*TODO*)
  log ("would have chosen " ^ label ^ " for " ^ dest)

(* same open question as recv but return type is always string
   this is what the AllowChoice match uses *)
let recv_label (src : string) = (*TODO*)
   let log_expr = log ("would have received a label from " ^ src) in
      [%expr [%e log_expr]; Random.int 999] 

let am_i e =
   [%expr String.equal [%e e] pir_me]