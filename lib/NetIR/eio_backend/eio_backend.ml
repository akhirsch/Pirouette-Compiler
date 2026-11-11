open Ppxlib
open Ast_builder.Default

let loc = Location.none

(* ---------------- LOCATION TYPE ---------------- *)

let location_type _ =
  failwith "TODO: location_type"


(* ---------------- IDENTITY ---------------- *)

let package_constructor id =
  failwith "TODO: package_constructor"

let who_i_am name =
  failwith "TODO: who_i_am"


(* ---------------- STREAM MANAGEMENT ---------------- *)

(* TODO:
   - how streams are identified
   - whether streams are directional
   - how are streams are accessed by fibers
   - how different message types are handled
*)

let stream_name src dest =
  failwith "TODO: stream_name"

let stream_ref src dest =
  failwith "TODO: stream_ref"


(* ---------------- SEND ---------------- *)

let send (me : string) (payload : expression) (dest : string)
    : expression =
  failwith "TODO: send"


(* ---------------- RECEIVE ---------------- *)

let recv (me : string) (ty : core_type) (src : string)
    : expression =
  failwith "TODO: recv"


(* ---------------- CHOOSE ---------------- *)

let choose (me : string) (dest : string) (label : string)
    : expression =
  failwith "TODO: choose"


(* ---------------- RECEIVE LABEL ---------------- *)

let recv_label (me : string) (src : string)
    : expression =
  failwith "TODO: recv_label"


(* ---------------- AM I ---------------- *)

let am_i (me : string) (e : expression)
    : expression =
  failwith "TODO: am_i"