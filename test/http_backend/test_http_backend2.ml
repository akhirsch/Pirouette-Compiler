(* Runs the participants for the choreography described in 'participant.ml'.

   Each participant corresponds to a process. This driver picks addresses,
   starts everyone, and collects results (ensuring everyone exits with
   status 0).
*)

open OUnit2

let participant_count = 10

(* Timeout in case of deadlock / other failure. *)
let timeout_seconds = 5.0

(* Get free ports, traps if unable.

   Note: Another process could take a port in the meantime. However, this
   event is unlikely and handing a socket to the child process would add
   significant complexity. *)
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

let name_of (location : string) : string =
  List.hd (String.split_on_char '=' location)

let run_participant ~(log : Unix.file_descr) (locations : string list)
    (location : string) : string * int =
  (* Move participant's location to the front *)
  let arguments =
    "participant.exe" :: location :: List.filter (( <> ) location) locations
  in
  (* Run participant (using `log` for stdout/stderr) *)
  let exit_code =
    Unix.create_process "./participant.exe" (Array.of_list arguments) Unix.stdin
      log log
  in
  (name_of location, exit_code)

(* How each participant exited, or [None] for one still running at [deadline],
   which we kill so it doesn't outlive the test. *)
let wait_for_all (participants : (string * int) list) ~(deadline : float) :
    (string * Unix.process_status option) list =
  let exited = Hashtbl.create participant_count in
  let rec poll () =
    let pending =
      List.filter (fun (_, pid) -> not (Hashtbl.mem exited pid)) participants
    in
    if pending <> [] then
      if Unix.gettimeofday () > deadline then
        List.iter
          (fun (_, pid) ->
            (try Unix.kill pid Sys.sigkill with Unix.Unix_error _ -> ());
            ignore (Unix.waitpid [] pid);
            Hashtbl.replace exited pid None)
          pending
      else begin
        List.iter
          (fun (_, pid) ->
            match Unix.waitpid [ WNOHANG ] pid with
            | 0, _ -> ()
            | _, status -> Hashtbl.replace exited pid (Some status))
          pending;
        (* [select] with no descriptors is just a sleep between sweeps. *)
        ignore (Unix.select [] [] [] 0.05);
        poll ()
      end
  in
  poll ();
  List.map (fun (name, pid) -> (name, Hashtbl.find exited pid)) participants

let describe (name, status) =
  Printf.sprintf "  %s %s" name
    (match status with
    | Some (Unix.WEXITED code) -> Printf.sprintf "exited %d" code
    | Some (Unix.WSIGNALED signal) ->
        Printf.sprintf "killed by signal %d" signal
    | Some (Unix.WSTOPPED signal) ->
        Printf.sprintf "stopped by signal %d" signal
    | None -> "did not finish in time")

let test_ring _ =
  (* Get free ports and format as participant inputs.
     Each location has the form "p[index]=http://localhost:[port]" *)
  let locations =
    get_free_ports participant_count
    |> List.mapi (fun index port ->
        Printf.sprintf "p%02d=http://localhost:%d" index port)
  in
  (* Create shared log file (each line will name its participant) *)
  let log_path = Filename.temp_file "pirc-http-backend2" ".log" in
  let log = Unix.openfile log_path [ O_WRONLY; O_TRUNC ] 0o600 in
  (* Start each participant *)
  let participants =
    Fun.protect
      ~finally:(fun () -> Unix.close log)
      (fun () -> List.map (run_participant ~log locations) locations)
  in
  (* Wait for everyone, up to deadline *)
  let statuses =
    wait_for_all participants ~deadline:(Unix.gettimeofday () +. timeout_seconds)
  in
  let failures =
    statuses |> List.filter (fun (_, status) -> status <> Some (Unix.WEXITED 0))
  in
  if failures <> [] then
    assert_failure
      (Printf.sprintf "%d of %d participants failed:\n%s\noutput:\n%s"
         (List.length failures) participant_count
         (String.concat "\n" (List.map describe statuses))
         (In_channel.with_open_bin log_path In_channel.input_all))

let () =
  run_test_tt_main
    ("http_backend2" >::: [ "a token goes around a ring of 10" >:: test_ring ])
