(* One location of the test choreography.

   The choreography is a number list passed once around a ring. Location 0 starts;
   everyone else appends their own index and passes it on; location 0 checks
   the final result.

   We're testing we don't get a deadlock and that results are in the right
   order. If `send` or `recv` aren't implemented correctly, something will
   likely break. *)

module Backend = Backend.Http_backend

type failure = UnexpectedResult of int list * int list

(** Performs the choreography from our `position` in the ring. Returns
    `UnexpectedResult` if the list comes back wrong. *)
let main ({ index; count; prev; next; _ } : Ring.position) :
    (unit, failure) Result.t =
  if index = 0 then
    (* Start chain *)
    let () = Backend.send next [ index ] in
    (* After last peer finishes, check results are [0; ...; <count>] *)
    let result : int list = Backend.recv prev in
    let expected = List.init count Fun.id in
    if result = expected then Result.Ok ()
    else Result.Error (UnexpectedResult (result, expected))
  else
    (* Get prev result *)
    let current_result = Backend.recv prev in
    (* Add our id and pass onto the next *)
    Backend.send next (current_result @ [ index ]);
    Result.Ok ()

let () =
  let position = Ring.locate () in
  (* Throw on error *)
  match main position with
  | Ok () -> Printf.printf "%s: ok\n" position.me
  | Error (UnexpectedResult (result, expected)) ->
      let describe nums = String.concat ";" (List.map string_of_int nums) in
      Printf.eprintf "%s: result came back as [%s], expected [%s]\n" position.me
        (describe result) (describe expected);
      exit 1
