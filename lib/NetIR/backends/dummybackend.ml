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
let location_type _ = ptyp_var ~loc "pir_emulated_location"

(* Takes a location name as a string, and returns the corresponding constructor
   from our emmulated location variant.*)
let package_constructor id =
  pexp_construct ~loc { txt = Lident ("Pir_" ^ id); loc } None

(* ---- identity ---- *)
(* gets set once at the top of every generated file
   let () = Dummybackend.who_i_am me
   so the log knows who is talking *)
let who_i_am name = [%stri let pir_me = [%e package_constructor name]]

(* ---- log helper ---- *)
(* print to stdout instead of a file
   cram captures this directly so no log files to clean up *)
let log (me : string) (msg : string) : Ppxlib.expression =
  [%expr Printf.printf "%s\n%!" [%e estring ~loc (me ^ ": " ^ msg)]]

(* ---- outgoing ----
   what is the code text of the payload so the log shows whats being sent
   v is the actual value passed along like andrew said
   not printing v itself bc we dont know its type at runtime *)
let send (me : string) (payload : expression) (dest : string) =
  let what = Pprintast.string_of_expression payload in
  log me ("would have sent " ^ what ^ " to " ^ dest)

(* ---- incoming ----
   ty is the type we expected to get so the log shows that
   still no real value to give back so failwith for now *)
let recv (me : string) (ty : core_type) (src : string) : expression =
  let ty_text = Format.asprintf "%a" Pprintast.core_type ty in
  let log_expr = log me ("would have received " ^ ty_text ^ " from " ^ src) in
  [%expr
    [%e log_expr];
    Random.int 999]

(* logs which label got picked for dest *)
let choose (me : string) (dest : string) (label : string) =
  (*TODO*)
  log me ("would have chosen " ^ label ^ " for " ^ dest)

let recv_label (me : string) (src : string) =
  (*TODO*)
  let log_expr = log me ("would have received a label from " ^ src) in
  [%expr
    [%e log_expr];
    Random.int 999]

let am_i (me : string) e =
  (* Since locations are constructors fo the emulated declaration variant,
      we can check if some expression equals our own variant by matching on
      the argument to ami, and returning true if it matches the "me" 
      constructor.*)
  let cases =
    [
      case
        ~lhs:(ppat_construct ~loc { txt = Lident ("Pir_" ^ me); loc } None)
        ~guard:None ~rhs:[%expr true];
      case ~lhs:[%pat? _] ~guard:None ~rhs:[%expr false];
    ]
  in
  pexp_match ~loc e cases
