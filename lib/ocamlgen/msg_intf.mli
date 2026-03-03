(** Message interface for pluggable communication backends.

    This module type defines the interface that message modules must implement
    to provide backend-specific code generation for network communication.
    Different implementations of this interface allow Pirouette to generate code
    for different communication mechanisms (HTTP, TCP, Unix pipes, MPI, etc.)
    without changing the core compiler.

    {2 Usage}

    The message interface separates {b what} to communicate (handled by
    [emit_core]) from {b how} to communicate (handled by implementations of this
    interface).

    [emit_core] automatically:
    - Marshals values before sending
    - Unmarshals values after receiving

    Message modules implement:
    - Backend-specific transport for marshaled data
    - Code generation for send/recv operations

    {b Note:} Different backends implement this interface differently. *)

(** {2 Module M: [emit_net_send] and [emit_net_recv]}*)

module type M = sig
  (** This module contains backend specific transport for marshaled data and
      code generation for send/recv operations.*)

  val emit_net_send :
    src:string -> dst:string -> Ppxlib.expression -> Ppxlib.expression
  (** [emit_net_send] generates OCaml code for sending marshaled data from [src]
      to [dst].

      Parameters:
      - [src]: name of the sending endpoint (e.g., "Alice")
      - [dst]: name of the receiving endpoint (e.g., "Bob")
      - [data_expr]: Ppxlib expression containing the marshaled data (already
        wrapped with [Marshal.to_string] by [emit_core])

      Returns a [Ppxlib.expression] that represents backend-specific send code.

      {b Called by:} [emit_core] when generating code for [Send] operations.

      The generated code will be compiled and executed at runtime to actually
      transmit the marshaled data over the network.*)

  val emit_net_recv : src:string -> dst:string -> Ppxlib.expression
  (** [emit_net_recv] generates OCaml code for receiving marshaled data from
      [src] at [dst].

      Parameters:
      - [src]: name of the sending endpoint (e.g., "Alice")
      - [dst]: name of the receiving endpoint (e.g., "Bob")

      Returns a [Ppxlib.expression] that represents backend-specific receive
      code. The returned expression should evaluate to a string containing the
      marshaled data, which [emit_core] will then unmarshal.

      {b Called by:} [emit_core] when generating code for [Recv] operations.

      The generated code will be compiled and executed at runtime to actually
      receive the marshaled data from the network and return it for
      unmarshaling.*)
end
