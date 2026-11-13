(* To run this test: dune exec ./test/domaintests/pir_runtime.exe *)
(* This is a stand alone copy to make sure the runtime functions work as expected
it is not calling on the actual implementation of the eio_diomains_backend *)

(* Test the runtime's communication between two locations, Alice and Bob.
   Alice sends an integer and a label to Bob, then waits for a response.
   Bob receives both messages and sends a confirmation back to Alice.
   This verifies value passing, label passing, and bidirectional communication!!!! *)

type msg = Value of Obj.t | Label of string
type chans = (string * string, msg Eio.Stream.t) Hashtbl.t

let make_chans (locs : string list) : chans =
  let tbl = Hashtbl.create 16 in
  List.iter
    (fun s ->
      List.iter
        (fun d ->
          if s <> d then Hashtbl.add tbl (s, d) (Eio.Stream.create max_int))
        locs)
    locs;
  tbl

let chan (c : chans) src dst =
  match Hashtbl.find_opt c (src, dst) with
  | Some s -> s
  | None -> failwith (Printf.sprintf "no channel %s -> %s" src dst)

let send c ~me ~dest v = Eio.Stream.add (chan c me dest) (Value (Obj.repr v))
let send_label c ~me ~dest l = Eio.Stream.add (chan c me dest) (Label l)

let recv c ~me ~src =
  match Eio.Stream.take (chan c src me) with
  | Value v -> Obj.obj v
  | Label _ -> failwith (me ^ ": expected value from " ^ src ^ ", got label")

let recv_label c ~me ~src =
  match Eio.Stream.take (chan c src me) with
  | Label l -> l
  | Value _ -> failwith (me ^ ": expected label from " ^ src ^ ", got value")

(* [progs] pairs each location name with its generated [run] function *)
let run (progs : (string * (chans -> unit)) list) =
  Eio_main.run @@ fun env ->
  let dm = Eio.Stdenv.domain_mgr env in
  let chans = make_chans (List.map fst progs) in
  Eio.Fiber.all
    (List.map
       (fun (_, prog) () -> Eio.Domain_manager.run dm (fun () -> prog chans))
       progs)


(* Runtime communication test:
   The following code tests the runtime implementation above by
   simulating communication between two Pirouette locations.
   Alice sends a value and a label to Bob, and Bob sends a response.
   This verifies channel creation, message passing, and execution
   across separate domains. *)

(* Alice sending messages to Bob and receiving a response. *)
let alice chans =
  Printf.printf "Alice: sending 42\n%!";
  send chans ~me:"Alice" ~dest:"Bob" 42;

  send_label chans ~me:"Alice" ~dest:"Bob" "continue";

  let response : string = recv chans ~me:"Alice" ~src:"Bob" in
  Printf.printf "Alice: received %s\n%!" response

(* Bob receiving a value and label, then responding to Alice. *)
let bob chans =
  let value : int = recv chans ~me:"Bob" ~src:"Alice" in
  Printf.printf "Bob: received %d\n%!" value;

  let label = recv_label chans ~me:"Bob" ~src:"Alice" in
  Printf.printf "Bob: received label %s\n%!" label;

  send chans ~me:"Bob" ~dest:"Alice" "Message received"

(* Run Alice and Bob in separate domains using the runtime's channel table *)
let () = run [ ("Alice", alice); ("Bob", bob) ]
