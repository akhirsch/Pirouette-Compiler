(* One location of the test choreography.

   The choreography is a number list passed once around a ring. Location 0 starts;
   everyone else appends their own index and passes it on; location 0 checks
   the final result.

   We're testing we don't get a deadlock and that results are in the right
   order. If `send` or `recv` aren't implemented correctly, something will
   likely break. *)

module Backend = Backend.Http_backend2

type failure = UnexpectedResult of int list * int list

(** Given `peers` containing an element `me`, performs choreography. Returns
    `UnexpectedResult` if an error occurs.

    Raises if peers is `me` isn't in peers. *)
let main (me : string) (peers : string list) : (unit, failure) Result.t =
  (* Sort peers lexicographically *)
  let ring = List.sort compare peers in
  (* Find sorted index; raises if `me` isn't in peers *)
  let peer_count = List.length ring in
  let my_index : int = ring |> List.find_index (( = ) me) |> Option.get in
  let prev = List.nth ring ((my_index - 1 + peer_count) mod peer_count) in
  let next = List.nth ring ((my_index + 1 + peer_count) mod peer_count) in
  if my_index = 0 then
    (* Start chain *)
    let () = Backend.send next [ my_index ] in
    (* After last peer finishes, check results are [0; ...; <peer_count>] *)
    let result : int list = Backend.recv prev in
    let expected = List.init peer_count Fun.id in
    if result = expected then Result.Ok ()
    else Result.Error (UnexpectedResult (result, expected))
  else
    (* Get prev result *)
    let current_result = Backend.recv prev in
    (* Add our id and pass onto the next *)
    Backend.send next (current_result @ [ my_index ]);
    Result.Ok ()

let () =
  (* Parse the peer names *)
  let peers =
    Sys.argv |> Array.to_list |> List.tl
    |> List.map (fun arg -> arg |> String.split_on_char '=' |> List.hd)
  in
  (* Our name should be first *)
  let me = List.hd peers in
  (* Throw on error *)
  match main me peers with
  | Ok () -> Printf.printf "%s: ok\n" me
  | Error (UnexpectedResult (result, expected)) ->
      let describe nums = String.concat ";" (List.map string_of_int nums) in
      Printf.eprintf "%s: result came back as [%s], expected [%s]\n" me
        (describe result) (describe expected);
      exit 1
