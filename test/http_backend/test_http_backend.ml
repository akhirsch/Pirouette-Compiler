open OUnit2

(*---------------------------------------------------------------------------*)
(* Runner                                                                    *)
(*---------------------------------------------------------------------------*)

(** Timeout in case of deadlock / other failure. *)
let timeout_seconds = 5.0

(** Gets free ports, traps if unable.

    Note: Another process could take a port in the meantime. However, this event
    is unlikely and handing a socket to the child process would add significant
    complexity.

    FIXME: That event is not unlikely once two runners overlap, because we
    release every port before any participant binds it. With the suites in
    separate `(tests ...)` executables, dune ran them concurrently and the
    second runner was handed ports the first had just released; a participant
    then died binding its own address (`Unix.EADDRINUSE`) and the rest of its
    ring timed out. It reproduced in roughly 1 run in 8. Serializing the runners
    (one executable, or `(locks ports)`) hides it, but the window is still open
    within a single runner. *)
let get_free_ports (count : int) : int list =
  (* For each participant, create socket & get port *)
  let sockets_and_ports =
    List.init count (fun _ ->
        (* Create IPv4 streaming port with default protocol (TCP) *)
        let socket = Unix.socket PF_INET SOCK_STREAM 0 in
        (* Binding to address `localhost:0` tells kernel to assign us a port *)
        let localhost = Unix.ADDR_INET (Unix.inet_addr_loopback, 0) in
        Unix.bind socket localhost;
        (* Get assigned port *)
        match Unix.getsockname socket with
        | Unix.ADDR_INET (_, port) -> (socket, port)
        | Unix.ADDR_UNIX _ -> assert_failure "expected a TCP address")
  in
  (* Close sockets and extract ports

     Note: We first get all sockets & ports and then close; otherwise,
     the kernel might reuse the same port.
  *)
  sockets_and_ports
  |> List.map (fun (socket, port) ->
      Unix.close socket;
      port)

(** Starts the given `executable` as the participant at `location`. *)
let start_participant ~(log : Unix.file_descr) ~(executable : string)
    (locations : string list) (location : string) : Lwt_process.process_none =
  (* Move participant's location to the front *)
  let arguments =
    executable :: location :: List.filter (( <> ) location) locations
  in
  (* Run participant using `log` for stdout/stderr

     Note: In case of deadlock, `~timeout` will SIGKILL the participant. *)
  let process =
    Lwt_process.open_process_none ~timeout:timeout_seconds
      ~stdout:(`FD_copy log) ~stderr:(`FD_copy log)
      ("./" ^ executable, Array.of_list arguments)
  in
  process

(** Describes how a participant exited. *)
let describe (name, status) =
  Printf.sprintf "  %s %s" name
    (match status with
    | Unix.WEXITED code -> Printf.sprintf "exited %d" code
    | Unix.WSIGNALED signal when signal = Sys.sigkill ->
        (* A SIGKILL is `~timeout` above firing. *)
        Printf.sprintf "did not finish in %gs" timeout_seconds
    | Unix.WSIGNALED signal -> Printf.sprintf "killed by signal %d" signal
    | Unix.WSTOPPED signal -> Printf.sprintf "stopped by signal %d" signal)

(** Spawn `count` processes for each choreography participant described in
    `executable`. The runner picks addresses, starts everyone, and collects
    results (ensuring everyone exits with status 0) *)
let run ~(executable : string) ~(count : int) : unit =
  (* Get free ports and format as participant inputs.
     Each location has the form "p[index]=http://localhost:[port]" *)
  let locations =
    get_free_ports count
    |> List.mapi (fun index port ->
        Printf.sprintf "p%02d=http://localhost:%d" index port)
  in
  (* Create shared log file (each line will name its participant) *)
  let log_path = Filename.temp_file "pirc-http-backend" ".log" in
  let log = Unix.openfile log_path [ O_WRONLY; O_TRUNC ] 0o600 in
  (* Start each participant
     Note: `open_process_none` forks immediately, so every participant has
     inherited `log` by the time we close our copy. *)
  let participants =
    Fun.protect
      ~finally:(fun () -> Unix.close log)
      (fun () ->
        locations
        |> List.map (fun location ->
            (location, start_participant ~log ~executable locations location)))
  in
  (* Wait for everyone to exit (or be killed on timeout) *)
  let statuses =
    participants
    |> Lwt_list.map_p (fun (name, process) ->
        process#status |> Lwt.map (fun status -> (name, status)))
    |> Lwt_main.run
  in
  let failure_count =
    statuses
    |> List.filter (fun (_, status) -> status <> Unix.WEXITED 0)
    |> List.length
  in
  (* Report if there are failures *)
  if failure_count <> 0 then
    assert_failure
      (Printf.sprintf "%d of %d participants failed:\n%s\noutput:\n%s"
         failure_count count
         (String.concat "\n" (List.map describe statuses))
         (In_channel.with_open_bin log_path In_channel.input_all))

(*---------------------------------------------------------------------------*)
(* Test                                                                      *)
(*---------------------------------------------------------------------------*)

(* Creates two runners; one for the `send_participant` and one for
   the `choose_participant` choreography. *)
let () =
  run_test_tt_main
    ("http_backend"
    >::: [
           ( "a token goes around a ring of 100" >:: fun _ ->
             run ~executable:"send_participant.exe" ~count:100 );
           (* FIXME: Enable *)
           (* ( "a label goes around a ring of 10" >:: fun _ -> *)
           (*   run ~executable:"choose_participant.exe" ~count:10 ); *)
         ])
