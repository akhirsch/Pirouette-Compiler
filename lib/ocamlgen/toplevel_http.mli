(** Code generation for HTTP-based communication backend. *)

(** This module provides code generation for distributed programs using HTTP
    for communication. It implements a message-passing backend where endpoints
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
open Ppxlib

(** [emit_toplevel_http] generates a complete OCaml program for a single 
  endpoint using HTTP communication and writes it to output channel [oc].
      
      Parameters:
      - [oc]: output channel to write generated OCaml code to (e.g., file)
      - [locations]: list of all endpoint names in the choreography (e.g., ["Alice"; "Bob"; "Carol"])
      - [stmt_blocks]: network IR statement blocks for all endpoints (after projection)
      - [target_endpoint]: which endpoint to generate code for (e.g., "Alice")
      
      Generates a complete runnable OCaml program that:
      1. Starts an HTTP server for receiving messages
      2. Executes the endpoint's projected code
      3. Sends HTTP POST requests to communicate with other endpoints
      4. Waits for HTTP requests when receiving
      
      {b Important:} Unlike [emit_toplevel_domain], this generates code for
      {b one endpoint at a time}. You must call this function once per endpoint
      to generate separate programs for each.
      
      {b Effect:} Writes a complete OCaml program for [target_endpoint] to [oc].
      The generated program is a standalone executable that runs an HTTP server
      and communicates with other endpoints via HTTP requests.*)
val emit_toplevel_http
  :  out_channel
  -> string list
  -> 'a Ast_core.Net.M.stmt_block list
  -> string
  -> unit

(** [emit_toplevel_init] is utilized by [emit_toplevel_http], attempting to load the [target_endpoint]
      
      Parameters:
      - [_loc_ids]: An endpoint name (e,g,, ["Alice"])
      - [config_file_path]: The name of the location of a YAML file containing a location (endpoint) name
      and an http address 
      
      {b Effect:} [config_file_path] is parsed as a YAML file. If successful, it is added to [config], a record
      containing all successfully parsed locations. Otherwise, the program will fail
      
      See {{!Http_pirc.Config_parser} the config parser documentation} for further reading*)
val emit_toplevel_init : 'a -> label -> structure_item list

(** [emit_domain_stri] is utilized by [emit_toplevel_http], separating each endpoint name with
statement block, and generating a structure item for each pair.
      
      Parameters:
      - [loc_id]: An endpoint name (e,g,, ["Alice"])
      - [net_stmts]: A network IR statement block for an endpoint
      
      {b Effect:} This function is called to create the [process_bindings] binding, which contains
      a list of structure items. This list is then written to [oc] from [emit_toplevel_http]*)
val emit_domain_stri
  :  label
  -> 'a Ast_core.Net.M.stmt_block
  -> Ppxlib.Parsetree.structure_item

(** {2 About Ppxlib}*)

(** See {{!ocamlgen.Emit_core}the emit_core documentation} for an overview of Ppxlib.

{b Metaquot:} Throughout toplevel_http.ml there are expressions of the form:
    {[
      let e = [%expr (*Some expression...*)]
    ]}
    
    This is a Ppxlib metaquot. The expression inside of the metaquot will not be evaluated
    to a value, but rather as a Parsetree Expression. This is used to generate OCaml code that
    will be transmitted as OCaml code, not as a value.

    Another type of metaquot used is:
    {[
      let stri = [%stri let a = (*Some value...*)]
    ]}
    
    This has the same effect as %expr, but for Structure Items, which could be values, exceptions, types, modules, etc.

{b Anti-Quotation:} Throughout toplevel_http.ml there are expressions of the form:
      {[
        let f = [%expr [%e (*Some expression...*)]]
      ]}

      This is a PPxlib anti-quotation. The expression inside of the anti-quotation will be seen as OCaml code
      and will be evaluated to a value. This is used within Metaquotations to dynamically generate values for 
      Parsetree Expressions

      Another type of anti-quotation used is:
      {[
        let [%p (*Some expression...*)]
      ]}

      This has the same effect as %expr, but for Patterns, which includes any pattern that you would use for pattern matching


 {b For further reading,} see {{:https://ocaml-ppx.github.io/ppxlib/ppxlib/generating-code.html} the PPxlib documentation on generating code}*)

(** {2 About Lwt}*)

(** Lwt is a concurrent programming library. The function:
{[
  Lwt.main.run (*arg*)
]}
runs the scheduler for asynchronous computations

*)
