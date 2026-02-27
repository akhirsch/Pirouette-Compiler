(** Code generation for HTTP-based communication backend.

    This module provides code generation for distributed programs using HTTP for
    communication. It implements a message-passing backend where endpoints
    communicate via HTTP requests, running as separate processes that can be
    deployed on different machines.

    {2 Backend Overview}

    The HTTP backend uses:
    - HTTP POST requests for sending data between endpoints
    - HTTP server for receiving data at each endpoint
    - Each endpoint runs as an independent process with its own HTTP server
    - Endpoints can run on different machines across a network

    {2 Architecture}
    Generated programs have this structure:
    {v
     ___________               ___________
    | machine 1 |             | machine 2 |
    |           |    HTTP     |           |
    |  Alice    | ----------> |   Bob     | 
    |  :8000    |  (network)  |  :8001    |
    |___________|             |___________|
      (process)                 (process)
    v}

    Communication happens via HTTP:
    - Each endpoint runs an HTTP server on a port (e.g. "8000" and "8001")
    - Endpoints send data via HTTP POST to other endpoints' URLs
    - Messages are marshaled and sent in HTTP request bodies
    - Endpoints receive data via HTTP request handlers *)

(**{2 Message http Interface Module}*)

module Msg_http_intf : Msg_intf.M

val emit_toplevel_http :
  out_channel ->
  string list ->
  'a Ast_core.Net.M.stmt_block list ->
  string ->
  unit
(** [emit_toplevel_http] generates a complete OCaml program for a single
    endpoint using HTTP communication and writes it to output channel [oc].

    Parameters:
    - [oc]: output channel to write generated OCaml code to (e.g., file)
    - [locations]: list of all endpoint names in the choreography (e.g.,
      ["Alice"; "Bob"; "Carol"])
    - [stmt_blocks]: network IR statement blocks for all endpoints (after
      projection)
    - [target_endpoint]: which endpoint to generate code for (e.g., "Alice")

    Generates a complete runnable OCaml program that: 1. Starts an HTTP server
    for receiving messages 2. Executes the endpoint's projected code 3. Sends
    HTTP POST requests to communicate with other endpoints 4. Waits for HTTP
    requests when receiving

    {b Important:} Unlike [emit_toplevel_domain], this generates code for
    {b one endpoint at a time}. You must call this function once per endpoint to
    generate separate programs for each.

    {b Effect:} Writes a complete OCaml program for [target_endpoint] to [oc].
    The generated program is a standalone executable that runs an HTTP server
    and communicates with other endpoints via HTTP requests.*)
