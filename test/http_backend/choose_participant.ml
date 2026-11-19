(* One location of the label-passing test choreography.

   A single label is passed once around a ring. Location 0 chooses it;
   everyone else forwards what they received; location 0 checks the label
   came back intact.

   This file tests `choose`/`recv_label` similar to how 'participant.ml' tests
   `send`/`recv`.
  *)

module Backend = Backend.Http_backend

let chosen_label = "go"

let () =
  let { Ring.me; index; prev; next; _ } = Ring.locate () in
  if index = 0 then
    (* Start the chain, then check what came back *)
    let () = Backend.choose next chosen_label in
    let label = Backend.recv_label prev in
    if label = chosen_label then Printf.printf "%s: ok\n" me
    else (
      Printf.eprintf "%s: label came back as '%s', expected '%s'\n" me label
        chosen_label;
      exit 1)
  else
    (* Forward the label onwards *)
    Backend.choose next (Backend.recv_label prev)
