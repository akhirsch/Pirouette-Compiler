(** Code generation for MPI-based communication backend.

    This module provides code generation for distributed programs using MPI
    (Message Passing Interface) for communication. It implements a
    message-passing backend where endpoints communicate via MPI primitives,
    designed for high-performance computing (HPC) environments and compute
    clusters.

    {2 Backend Overview}

    The MPI backend uses:
    - MPI (Message Passing Interface) standard for inter-process communication
    - MPI rank to determine which endpoint code to execute
    - All processes run the same executable but branch based on rank

    {2 Architecture}

    {v
      _______________________________________________________
      |                    MPI Job                          |
      |  ___________     ___________       ___________      |
      | | Process 0 |   | Process 1 |     | Process 2 |     |
      | |  (Alice)  |   |   (Bob)   |     | (Jackie)  |     |
      | |  Rank: 0  |   |  Rank: 1  |     |  Rank: 2  |     | 
      | |___________|   |___________|     |___________|     |
      |      |                |                 |           |
      |      | mpi send/recv  |  mpi send/recv  |           |
      |      |________________|_________________|           |
      |                                                     |
      |_____________________________________________________|
                          Compute Cluster 
    v}
    Communication happens via MPI:
    - Single executable launched via MPI Job
    - Each process gets a unique rank (0, 1, 2, ...)
    - Processes branch on rank to execute different endpoint code
    - MPI_Send and MPI_Recv for point-to-point communication
    - Handles low-latency, high-bandwidth data transfer *)

(**{2 Message MPI Interface Module}*)

module Msg_mpi_intf : Msg_intf.M
(** Message interface implementation for MPI-based communication.

    This module implements [Msg_intf.M] using MPI primitives for send/recv
    operations. It generates code that:
    - Sends data via MPI_Send to a specific rank
    - Receives data via MPI_Recv from a specific rank
    - Maps endpoint names to MPI ranks *)

val emit_toplevel_mpi :
  out_channel -> string list -> 'a Ast_core.Net.M.stmt_block list -> unit
(** [emit_toplevel_mpi oc locations stmt_blocks] generates a complete MPI
    program that runs all endpoints in a single executable using SPMD model and
    writes it to output channel [oc].

    Parameters:
    - [oc]: output channel to write generated OCaml code to (e.g., file)
    - [locations]: list of endpoint names in the choreography (e.g.,
      ["Alice"; "Bob"; "Carol"])
    - [stmt_blocks]: network IR statement blocks for each endpoint (after
      projection)

    Generates a complete runnable MPI program that: 1. Initializes MPI and gets
    process rank 2. Maps endpoint names to MPI ranks (Alice=0, Bob=1, Carol=2,
    ...) 3. Branches on rank to execute the appropriate endpoint's code 4. Uses
    MPI_Send/MPI_Recv for communication 5. Finalizes MPI before exit

    {b Important:} Unlike HTTP backend, this generates {b one program} that
    contains all endpoints. The MPI runtime launches multiple copies, and each
    process executes different code based on its rank. *)
