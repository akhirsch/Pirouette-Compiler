(* Where a participant sits in the test ring.

   Both participant executables pass a value once around a ring, so they share
   the same notion of who comes before and after them. *)

type position = {
  me : string;  (** Our own location name *)
  index : int;  (** Our position in the ring *)
  count : int;  (** Number of participants *)
  prev : string;  (** Location we receive from *)
  next : string;  (** Location we send to *)
}

(** Locates us in the ring using the arguments the backend was given.

    The ring is the location names sorted lexicographically, so every
    participant agrees on the order without being told it.

    Raises if we aren't among the names. *)
let locate () : position =
  (* Parse the peer names, dropping the hostnames and the program name *)
  let peers =
    Sys.argv |> Array.to_list |> List.tl
    |> List.map (fun arg -> arg |> String.split_on_char '=' |> List.hd)
  in
  (* Our name is first; the ring is everyone sorted *)
  let me = List.hd peers in
  let ring = List.sort compare peers in
  let count = List.length ring in
  let index = ring |> List.find_index (( = ) me) |> Option.get in
  {
    me;
    index;
    count;
    prev = List.nth ring ((index - 1 + count) mod count);
    next = List.nth ring ((index + 1) mod count);
  }
