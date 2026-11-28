module Pir_runtime :
  sig
    type channel_table
    val send : channel_table -> me:string -> dest:string -> 'a -> unit
    val send_label :
      channel_table -> me:string -> dest:string -> string -> unit
    val recv : channel_table -> me:string -> src:string -> 'a
    val recv_label : channel_table -> me:string -> src:string -> string
    val run : (string * (channel_table -> unit)) list -> unit
  end =
  struct
    type msg =
      | Value of Obj.t 
      | Label of string 
    type channel_table = ((string * string), msg Eio.Stream.t) Hashtbl.t
    let make_chans (locs : string list) =
      (let channel_hashtable = Hashtbl.create 16 in
       List.iter
         (fun s ->
            List.iter
              (fun d ->
                 if s <> d
                 then
                   Hashtbl.add channel_hashtable (s, d)
                     (Eio.Stream.create max_int)) locs) locs;
       channel_hashtable : channel_table)
    let channel (c : channel_table) src dst =
      match Hashtbl.find_opt c (src, dst) with
      | Some s -> s
      | None -> failwith (Printf.sprintf "no such channel %s -> %s" src dst)
    let send c ~me  ~dest  v =
      Eio.Stream.add (channel c me dest) (Value (Obj.repr v))
    let send_label c ~me  ~dest  l =
      Eio.Stream.add (channel c me dest) (Label l)
    let recv c ~me  ~src  =
      match Eio.Stream.take (channel c src me) with
      | Value v -> Obj.obj v
      | Label _ ->
          failwith
            (me ^ (": expected a value from " ^ (src ^ ", got a label")))
    let recv_label c ~me  ~src  =
      match Eio.Stream.take (channel c src me) with
      | Label l -> l
      | Value _ ->
          failwith
            (me ^ (": expected a label from " ^ (src ^ ", got a value")))
    let run (progs : (string * (channel_table -> unit)) list) =
      Eio_main.run @@
        (fun env ->
           let dm = Eio.Stdenv.domain_mgr env in
           let channels = make_chans (List.map fst progs) in
           Eio.Fiber.all
             (List.map
                (fun (_, prog) ->
                   fun () ->
                     Eio.Domain_manager.run dm (fun () -> prog channels))
                progs))
  end 
module Loc_Alice =
  struct
    type pir_emulated_location =
      | Pir_Alice 
      | Pir_Bob 
    let pir_me = Pir_Alice
    let pir_am_i l = l = pir_me
    let run pir_chans =
      let _send_label =
        Pir_runtime.send_label pir_chans ~me:"Alice" ~dest:"Bob" "continue" in
      ()
  end
module Loc_Bob =
  struct
    type pir_emulated_location =
      | Pir_Alice 
      | Pir_Bob 
    let pir_me = Pir_Bob
    let pir_am_i l = l = pir_me
    let run pir_chans =
      let _receive_label =
        match Pir_runtime.recv_label pir_chans ~me:"Bob" ~src:"Alice" with
        | "continue" -> ()
        | other ->
            failwith
              (Printf.sprintf "unexpected label %s from %s" other "Alice") in
      ()
  end
let () = Pir_runtime.run [("Alice", Loc_Alice.run); ("Bob", Loc_Bob.run)]