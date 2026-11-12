type msg = Value of Obj.t | Label of string

type chans = (string * string, msg Eio.Stream.t) Hashtbl.t

let make_chans (locs : string list) : chans =
  let tbl = Hashtbl.create 16 in
  List.iter (fun s -> List.iter (fun d ->
    if s <> d then Hashtbl.add tbl (s, d) (Eio.Stream.create max_int)) locs) locs;
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
    (List.map (fun (_, prog) () -> Eio.Domain_manager.run dm (fun () -> prog chans)) progs)