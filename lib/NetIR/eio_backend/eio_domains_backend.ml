open Ppxlib
open Ast_builder.Default

let loc = Location.none


(**
The idea behind this backend structure is that each individual backend will have its own unique dependencies
and will also likely require some specilized functions to be declared at the top level in order to make communication possible.

runtime (_locs : string list) : structure_item list 
is a function that will be used to prepend the runtime module at the beginning of the generated program so that functions like 
send and receive can simply call them to use the functionality. This makes it easier to modularize our backend structure, handle 
code generation, and make the generated code easier to follow visually (for debugging).

*)

(* ---------------- LOCATION TYPE ---------------- *)

let location_type _ =
  [%type: pir_emulated_location] (* ask jackie about this vs her implementation *)


(* ---------------- IDENTITY ---------------- *)

let package_constructor id =
  pexp_construct ~loc { txt = Lident ("Pir_" ^ id); loc } None

let who_i_am name = 
  [ [%stri let pir_me = [%e package_constructor name]];
    [%stri let pir_am_i l = (l = pir_me)] ]

let am_i (_me : string) e = [%expr pir_am_i [%e e]]


(* ---------------- SEND ---------------- *)

let send (me : string) (payload : expression) (dest : string) =
  [%expr
    Pir_runtime.send pir_chans ~me:[%e estring ~loc me]
      ~dest:[%e estring ~loc dest] [%e payload]]


(* ---------------- RECEIVE ---------------- *)

let recv (me : string) (ty : core_type) (src : string) =
  [%expr
    (Pir_runtime.recv pir_chans ~me:[%e estring ~loc me]
       ~src:[%e estring ~loc src]
      : [%t ty])]


(* ---------------- CHOOSE ---------------- *)

let choose (me : string) (dest : string) (label : string) = (* ask jackie if this looks correct *)
  [%expr
    Pir_runtime.send_label pir_chans ~me:[%e estring ~loc me]
      ~dest:[%e estring ~loc dest] [%e estring ~loc label]]


(* ---------------- RECEIVE LABEL ---------------- *)

let recv_label (me : string) (src : string) =
  [%expr
    Pir_runtime.recv_label pir_chans ~me:[%e estring ~loc me]
      ~src:[%e estring ~loc src]]



  (* --------------------------------------------------------------------------------------------- *)
  (* --------------------------------------------------------------------------------------------- *)
  (* --------------------------------------------------------------------------------------------- *)



(* ---------- runtime library ---------- *)

(** 
This is a module that gets prepended once to the top of the program so that each backend function described 
above can actually perform communications. Each backend will follow this structure of implementing the common functions above
and handling library-specific functions inside of the runtime library.
*)
let runtime =
  [ [%stri
      module Pir_runtime = struct
        [@@@warning "-a"]

        (* Here Obj.t could be explicit as a variant of all other types we allow in pirouette, but Obj.t allows any type to be used*)
        type msg = Value of Obj.t | Label of string 
        type channel_table = (string * string, msg Eio.Stream.t) Hashtbl.t

        (* 
        This function builds a lookup table containing a communication channel between every process in both directions.
        For a program with processes A, B, and C, it would generate:
          AB -> (Eio.stream for AB)
          AC -> (Eio.stream for AC)
          BA -> (Eio.stream for BA)
          BC -> (Eio.stream for BC)
          CA -> (Eio.stream for CA)
          CB -> (Eio.stream for CB)
        *)
        let make_chans (locs : string list) : channel_table =
          let channel_hashtable = Hashtbl.create 16 in (* initial size of 16 is arbitrary *)
          List.iter
            (fun s ->
              List.iter
                (fun d ->
                  if s <> d then
                    Hashtbl.add channel_hashtable (s, d) (Eio.Stream.create max_int))
                    (*Hashtbl.add tbl (s, d) (Eio.Stream.create max_int))*) (* Edited here - Jackie *)
                locs)
            locs;
          channel_hashtable

        let channel (c : channel_table) src dst =
          match Hashtbl.find_opt c (src, dst) with
          | Some s -> s
          | None -> failwith (Printf.sprintf "no such channel %s -> %s" src dst)

        let send c ~me ~dest v =
          Eio.Stream.add (channel c me dest) (Value (Obj.repr v))

        let send_label c ~me ~dest l = Eio.Stream.add (channel c me dest) (Label l)

        let recv c ~me ~src =
          match Eio.Stream.take (channel c src me) with
          | Value v -> Obj.obj v
          | Label _ ->
              failwith (me ^ ": expected a value from " ^ src ^ ", got a label")

        let recv_label c ~me ~src =
          match Eio.Stream.take (channel c src me) with
          | Label l -> l
          | Value _ ->
              failwith (me ^ ": expected a label from " ^ src ^ ", got a value")

        let run (progs : (string * (channel_table -> unit)) list) =
          Eio_main.run @@ fun env ->
          let dm = Eio.Stdenv.domain_mgr env in
          let channels = make_chans (List.map fst progs) in
          Eio.Fiber.all
            (List.map
               (fun (_, prog) () ->
                 Eio.Domain_manager.run dm (fun () -> prog channels))
               progs)
      end] ]

(* ---------- structure: one module per location, then the launcher ---------- *)

(* [header] = the location variant, pir_me, and type-like declarations.
   [defns]  = the DefnDecls, which must not run until [run] is called. 
   
   wrap_location makes a module for each location to run its own code.
   *)
let wrap_location (me : string) (header : structure) (defns : structure) :
    structure_item list =
  let open_defns =
    pexp_open ~loc
      (open_infos ~loc ~expr:(pmod_structure ~loc defns) ~override:Fresh)
      [%expr ()]
  in
  let run_item = [%stri let run = fun pir_chans -> [%e open_defns]] in
  [ pstr_module ~loc
      (module_binding ~loc
         ~name:(Located.mk ~loc (Some ("Loc_" ^ me)))
         ~expr:(pmod_structure ~loc ([ [%stri [@@@warning "-a"]] ] @ header @ [ run_item ]))) ]
         let entry_point (_locs : string list) : structure_item list =
          (* added _ in front of locs here bc this is a WIP need to run tests to see if we are on track *)
  failwith "TODO" (*not sure what to do here yet *)