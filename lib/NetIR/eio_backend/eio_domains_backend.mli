open Ppxlib

val location_type : string list -> core_type
val who_i_am : string -> structure_item list
val am_i : string -> expression -> expression

val send : string -> expression -> string -> expression
val recv : string -> core_type -> string -> expression

val choose : string -> string -> string -> expression
val recv_label : string -> string -> expression

val runtime : structure_item list

val wrap_location :
  string -> structure -> structure -> structure_item list

val entry_point : string list -> structure_item list