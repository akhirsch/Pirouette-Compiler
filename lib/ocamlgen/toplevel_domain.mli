(** Code generation for Domain-based communication backend.

    This module provides code generation for distributed programs using OCaml's
    Domain module for parallelism. It implements a message-passing backend where
    endpoints communicate via OCaml channels, running as separate domains
    (parallel execution contexts) within a single process.

    {2 Backend Overview}

    The Domain backend uses:
    - OCaml [Domain] module for parallelism (separate threads of execution)
    - OCaml [Chan] (channels) for inter-domain communication
    - All endpoints run in the same process but different domains

    {b Use case:} Testing choreographies locally or running on multi-core
    machines where all endpoints can share memory space.

    {2 Architecture}

    {v
       ______________________________
      |       Main Process          |
      |  alice     -->     bob      |
      | (domain)          (domain)  |
      |     |                ^      |
      |     |________________|      |
      |         Channel Send        |
      |_____________________________|
            Single Process 
    v}
    Communication happens via channels:
    - Each endpoint runs in its own domain
    - Channels connect domains for message passing
    - Messages are marshaled and sent through channels*)

(**{2 Message Channel Interface Module}*)

module Msg_chan_intf : Msg_intf.M
(** Message interface implementation for channel-based communication.

    This module implements [Msg_intf.M] using OCaml channels for send/recv
    operations. It generates code that:
    - Sends data by writing to a channel: [Chan.send channel data]
    - Receives data by reading from a channel: [Chan.recv channel]

    Channels are established between domains at program startup, and all
    communication goes through these channels*)

val emit_toplevel_domain :
  out_channel -> string list -> 'a Ast_core.Net.M.stmt_block list -> unit
(** [emit_toplevel_domain oc locations stmt_blocks] generates a complete OCaml
    program for the Domain backend and writes it to output channel [oc].

    Parameters:
    - [oc]: output channel to write generated OCaml code to (e.g., file)
    - [locations]: list of endpoint names in the choreography (e.g.,
      ["Alice"; "Bob"; "Jackie"])
    - [stmt_blocks]: network IR statement blocks for each endpoint (after
      projection)

    Generates a complete runnable OCaml program that: 1. Creates channels
    connecting all endpoints 2. Spawns a domain for each endpoint 3. Each domain
    executes its projected code 4. Main thread waits for all domains to complete

    {b Note:} This backend is useful for:
    - Testing choreographies locally without network setup
    - Debugging with all endpoints in one process *)
