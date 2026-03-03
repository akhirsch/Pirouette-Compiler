(** Choreography visualization using Graphviz DOT language.

    This module provides utilities for visualizing Pirouette choreographies as
    directed graphs using the DOT graph description language. The generated DOT
    code can be rendered into images using Graphviz tools.

    {2 Visualization Features}

    - Nodes represent choreographic statements and expressions
    - Edges show control flow and communication patterns
    - Support for all choreographic constructs (send, select, if/then/else,
      etc.)
    - Customizable node labels via metadata conversion

    {2 Prerequisites}

    Before using this module, you need: 1. Graphviz installed on your system 2.
    A Pirouette choreography source file 3. The Pirouette compiler built *)

val generate_dot_code :
  ('a -> string) -> 'a Ast_core.Choreo.M.stmt_block -> string
(** [generate_dot_code metadata_to_string stmts] generates DOT graph code for
    visualizing a choreography.

    {b Parameters:}
    - [metadata_to_string]: Function to convert AST metadata to strings (for
      node labels)
    - [stmts]: The choreographic statement block to visualize

    {b Returns} a complete DOT graph specification as a string, ready to be
    processed by Graphviz tools (dot, neato, etc.) to generate visual diagrams.

    {b Input (Choreography):}
    {[
      x : Alice.int;
      x := [Alice] 5;
      send Alice x -> Bob;
      y : Bob.int;
      y := [Bob] x + 1
    ]}

    {b Visual Output:}
    {v
     _____________________
    | Decl: x : Alice.int |
    |_____________________|
              |
              |
     ________ ▼ __________
    | Assign x := [Alice] |
    |         5           |
    |_____________________|
              |
              |
     ________ ▼ __________
    | Send Alice -> Bob   |
    |_____________________|
              |
              |
     ________ ▼ __________
    | Declare y : Bob.int |
    |_____________________|
              |
              |
     ________ ▼ __________
    | Assign y := [Bob]   |
    |         x + 1       |
    |_____________________|
    v}

    {b Use cases:}
    - Visualizing choreographic protocols for presentations
    - Debugging complex choreographies
    - Understanding control flow and message passing
    - Documentation and teaching
    - Protocol analysis and verification

    {b Note:} The generated DOT code includes:
    - All declarations, assignments, and expressions as nodes
    - Control flow edges (sequential, conditional branches)
    - Communication edges (sends, receives)
    - Proper formatting for readability *)
