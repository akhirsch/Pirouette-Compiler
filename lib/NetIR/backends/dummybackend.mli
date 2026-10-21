(* dummybackend.mli — whats visible to the generated files
   log and the me ref are NOT in here on purpose
   generated code shouldnt touch those directly *)

(* ---- Location type ---- *)
(* Returns the location type, need to figure out what this is lol*)
val location_type : string list -> Ppxlib.core_type

(* ---- identity ---- *)
(* called once at the top of every generated file
   sets who this participant is so logs have the name *)
val who_i_am : string -> Ppxlib.structure_item

(* ---- outgoing ---- *)
(* send dest v  logs that we would have sent to dest
payload ignored for now ASK ANDREW *)
val send : string -> Ppxlib.expression -> string -> Ppxlib.expression

(* ---- incoming ---- *)
(* recv src  logs the receive then fails for now
   ASK ANDREW what this should actually return *)
val recv : string -> Ppxlib.core_type -> string -> Ppxlib.expression

(* choose dest label  logs which label got picked for dest *)
val choose : string -> string -> string -> Ppxlib.expression

(* recv_label src  logs the label receive
   always a string bc the AllowChoice match uses it *)
val recv_label : string -> string -> Ppxlib.expression
val am_i : string -> Ppxlib.expression -> Ppxlib.expression
