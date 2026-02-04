(** Network code generation via endpoint projection.

    {2 Overview}
    This module implements endpoint projection (EPP), the core transformation
    that converts choreographic programs into executable network code for
    individual endpoints. Given a global choreography and a target location, EPP
    generates the local program that location should execute.

    Endpoint projection transforms:
    - Location-qualified expressions: local computations (removing qualifiers)
    - Choreographic [send] operations: [Send] and [Recv] primitives (data
      transfer)
    - Choreographic [select] operation: [ChooseFor] and [AllowChoice] primitives

    This transformation ensures that distributed programs maintain the
    communication patterns and safety properties specified in the choreography.
*)

(**{2 End Point Projection}*)

val epp_choreo_to_net :
  'a Ast_core.Choreo.M.stmt list -> string -> 'a Ast_core.Net.M.stmt list
(** [epp_choreo_to_net] projects choreographic statement list [stmts] onto
    endpoint [location], producing network IR statements.

    Performs endpoint projection (EPP) to extract the behavior of a specific
    location from a global choreography. The resulting network IR contains
    explicit send/receive operations and choice coordination for that endpoint.

    Parameters:
    - [stmts]: choreographic statement list representing the global protocol
    - [location]: name of the endpoint to project for (e.g., "Alice", "Bob")

    Returns the network IR statement list for the specified location, with
    choreographic constructs transformed into explicit communication primitives.

    {b Raises:} May raise projection errors if the choreography cannot be safely
    projected (e.g., location appears in conflicting branches). *)

(** {2 Local Computations Example}

    Input (Pirouette):
    {[
      x : Alice.int;
      x := [Alice] 5 + 3;
      y : Bob.int;
      y := [Bob] 10 * 2
    ]}

    OCaml:
    {[
      let alice_stmts = epp_choreo_to_net choreo_stmts "Alice" in
      let bob_stmts = epp_choreo_to_net choreo_stmts "Bob" in
    ]}

    Alice's projected code:
    {[
      x : int;
      x := Ret(5 + 3)
      (* Note: [Alice] qualifier removed, becomes local computation *)
      (* Bob's computation doesn't appear in Alice's code *)
    ]}

    Bob's projected code:
    {[
      y : int;
      y := Ret(10 * 2)
      (* Note: [Bob] qualifier removed, becomes local computation *)
      (* Alice's computation doesn't appear in Bob's code *)
    ]}

    {b Note:} Location qualifiers like [Alice] are removed during projection.
    Each endpoint only gets the computations qualified with their own location.
    No communication occurs - these are purely local operations.*)

(** {2 Data Transfer Example : Send/Recv}

    Input (Pirouette):
    {[
      x : Alice.int;
      x := [Alice] 5;
      send Alice x -> Bob;
      y : Bob.int;
      y := [Bob] x + 1
    ]}

    OCaml:
    {[
      (* Project for Alice *)
      let alice_stmts = epp_choreo_to_net choreo_stmts "Alice" in

      (* Project for Bob *)
      let bob_stmts = epp_choreo_to_net choreo_stmts "Bob" in

      (* Visualize results *)
      print_endline "Alice's code:";
      pprint_net_ast stdout alice_stmts;
      print_endline "\nBob's code:";
      pprint_net_ast stdout bob_stmts
    ]}

    Alice's projected code:
    {[
      x : int;
      x := Ret(5);
      Send(Ret(x), Bob)
    ]}

    Bob's projected code:
    {[
      x : int;
      x := Recv(Alice);
      y : int;
      y := Ret(x + 1)
    ]}

    {b Note:} [Send] and [Recv] transfer data values between endpoints.*)

(** {2 Decision Coordination Example: ChooseFor/AllowChoice}

    Input (Pirouette):
    {[
      x : Alice.int;
      x := [Alice] readInput();
      if [Alice] x > 10 then
        select Alice High -> Bob;
        send Alice x -> Bob
      else
        select Alice Low -> Bob;
        send Alice 0 -> Bob
    ]}

    OCaml:
    {[
      let alice_stmts = epp_choreo_to_net choreo_stmts "Alice" in
      let bob_stmts = epp_choreo_to_net choreo_stmts "Bob" in
    ]}

    Alice's projected code:
    {[
      x : int;
      x := Ret(readInput());
      if Ret(x > 10) then
        ChooseFor(High, Bob, Send(Ret(x), Bob))
      else
        ChooseFor(Low, Bob, Send(Ret(0), Bob))
    ]}

    Bob's projected code:
    {[
      AllowChoice (Alice, [ (High, x) := Recv Alice; (Low, x) := Recv Alice ])
    ]}

    {b Note:} The difference between communication primitives:
    - [Send]/[Recv]: Transfer data values ("send the number 42")
    - [ChooseFor]/[AllowChoice]: Coordinate control flow decisions ("I chose
      branch High, follow that path")

    Alice makes a local decision based on [x > 10], tells Bob which branch she
    chose ([High] or [Low]), and Bob waits to hear which label Alice picked
    before proceeding. *)
