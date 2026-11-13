(* dummybackend.mli — whats visible to the generated files
   log and the me ref are NOT in here on purpose
   generated code shouldnt touch those directly *)

(* ---- Location type ---- *)
val location_type : string list -> Ppxlib.core_type

(* ---- identity ---- *)
val who_i_am : string -> Ppxlib.structure_item

(* ---- outgoing ---- *)
val send : string -> Ppxlib.expression -> string -> Ppxlib.expression

(* ---- incoming ---- *)
val recv : string -> Ppxlib.core_type -> string -> Ppxlib.expression

(* choose dest label  logs which label got picked for dest *)
val choose : string -> string -> string -> Ppxlib.expression
val recv_label : string -> string -> Ppxlib.expression
val am_i : string -> Ppxlib.expression -> Ppxlib.expression
