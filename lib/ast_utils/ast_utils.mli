(** {b ast_utils} AST utility functions

    Provides shared helper functions for working with AST structures across the
    compiler. Includes routines for:

    - Traversal and extraction – e.g., [extract_locs] collects all
      choreography locations from a statement block.
    - Serialization and pretty-printing – functions prefixed with
      [jsonify_*] and [pprint_*] convert ASTs to JSON or formatted source text.
    - Graph visualization – [stringify_dot_choreo_ast] and [dot_choreo_ast]
      export a choreography AST to DOT format for visual inspection.
    - Foreign function interface (FFI) utilities

    These utilities are intended for developer and tooling use (testing,
    visualization, and compiler diagnostics), not for end-user programs.
    They help understand how Pirouette code becomes an AST, where you can see the
    structure of choreographies and visualize communication patterns.
*)

(** {1 Location Extraction}

    Example workflow for extracting location information:

    {b Input (Pirouette):}
    {[
      x : Alice.int;
      send Alice -> Bob;
      y : Bob.string
    ]}

(** [extract_locs] extracts all location identifiers from choreographic 
      statement block [stmts].
      
      Returns a list of unique location names (as strings) found in location-qualified
      types, expressions, or patterns. *)
val extract_locs : 'a Ast_core.Choreo.M.stmt_block -> string list

(** {1 JSON Serialization} 
    
    Functions for converting AST structures to JSON format, useful for 
    external tooling, debugging, and data interchange. The JSON output 
    represents the internal OCaml AST structure.
    
    Example workflow:

    {b Input (Pirouette):}
    {[
      x : Alice.int;
      x := [Alice] 5;
      send Alice x -> Bob
    ]}

    {b OCaml:}
    {[
      (* Convert to JSON string *)
      let json_str = stringify_jsonify_choreo_ast stmts in
      print_endline json_str;

      (* Or write directly to file *)
      let oc = open_out "ast.json" in
      jsonify_choreo_ast oc stmts;
      close_out oc;

      (* Same functions exist for network IR *)
      let net_json = stringify_jsonify_net_ast net_stmts in
      jsonify_net_ast (open_out "net.json") net_stmts
    ]}

    {b Terminal:}
    {[
      $ cat ast.json | jq .
      $ jq '.statements[0]' ast.json
    ]}

    {b Expected:} JSON representing the OCaml AST structure:
    {[
      {
        "statements": [
          {
            "type": "Decl",
            "pattern": {"type": "Var", "id": "x"},
            "typ": {"type": "TLoc", "location": "Alice", "local_type": "TInt"}
          },
          {
            "type": "Assign",
            "patterns": [{"type": "Var", "id": "x"}],
            "expr": {"type": "LocExpr", "location": "Alice", ...}
          },
          {
            "type": "Send",
            "sender": "Alice",
            "expr": {"type": "Var", "id": "x"},
            "receiver": "Bob"
          }
        ]
      }
    ]}

    {b Raises:} Functions writing to channels may raise [Sys_error] if file
    operations fail. *)

(** [stringify_jsonify_choreo_ast] converts choreographic statement 
      block [stmts] to a JSON string representation.
      
      Returns the entire AST structure as a JSON-formatted string, including
      all nested expressions, types, and patterns.*)
val stringify_jsonify_choreo_ast : 'a Ast_core.Choreo.M.stmt_block -> string

(** [stringify_jsonify_net_ast] converts network statement block [stmts] 
      to a JSON string representation.
      
      Returns the network IR AST structure as a JSON-formatted string, including
      explicit send/receive operations and choice coordination. *)
val stringify_jsonify_net_ast : 'a Ast_core.Net.M.stmt_block -> string

(** [jsonify_choreo_ast] writes choreographic statement block [stmts] 
      as JSON to output channel [oc].
      
      Serializes the AST structure to JSON and writes it directly to the 
      specified output channel (file, stdout, etc.).*)
val jsonify_choreo_ast : out_channel -> 'a Ast_core.Choreo.M.stmt_block -> unit

(** [jsonify_net_ast] writes network statement block [stmts] as JSON 
      to output channel [oc].
      
      Serializes the network IR AST structure to JSON and writes it to the 
      specified output channel. *)
val jsonify_net_ast : out_channel -> 'a Ast_core.Net.M.stmt_block -> unit

    Example workflow:

    {b Input (AST in memory):}
    {[
      (* Some choreographic AST after parsing/transformation *)
      let stmts = ...
    ]}

    {b OCaml:}
    {[
      (* Convert to Pirouette source string *)
      let pirouette_code = stringify_pprint_choreo_ast stmts in
      print_endline pirouette_code;

      (* Or write directly to file *)
      let oc = open_out "output.pir" in
      pprint_choreo_ast oc stmts;
      close_out oc;

      (* Same functions exist for network IR *)
      let net_code = stringify_pprint_net_ast net_stmts in
      pprint_net_ast stdout net_stmts
    ]}

    {b Terminal:}
    {[
      $ cat output.pir
    ]}

    {b Expected:} Reconstructed Pirouette source code:
    {[
      x : Alice.int;
      x := [Alice] 5;
      send Alice x -> Bob
    ]}

    {b Raises:} Functions writing to channels may raise [Sys_error] if file
    operations fail.*)

(** [stringify_pprint_choreo_ast] converts choreographic statement block 
      [stmts] to formatted Pirouette source code as a string.
      
      Pretty-prints the AST back into readable Pirouette syntax, preserving
      structure and formatting for human readability.*)
val stringify_pprint_choreo_ast : 'a Ast_core.Choreo.M.stmt_block -> string

(** [stringify_pprint_net_ast] converts network statement block [stmts] 
      to formatted source code as a string.
      
      Pretty-prints the network IR AST with explicit communication primitives
      (Send, Recv, ChooseFor, AllowChoice). *)
val stringify_pprint_net_ast : 'a Ast_core.Net.M.stmt_block -> string

(** [pprint_choreo_ast] writes choreographic statement block [stmts] 
      as formatted Pirouette source code to output channel [oc].*)
val pprint_choreo_ast : out_channel -> 'a Ast_core.Choreo.M.stmt_block -> unit

(** [pprint_net_ast] writes network statement block [stmts] as 
      formatted source code to output channel [oc].
      
      Outputs the network IR with explicit send/receive operations in a 
      readable format. *)
val pprint_net_ast : out_channel -> 'a Ast_core.Net.M.stmt_block -> unit

    Example workflow:

    {b Input (Pirouette):}
    {[
      x : Alice.int;
      send Alice x -> Bob
    ]}

    {b OCaml:}
    {[
      (* Convert to DOT string *)
      let dot_str = stringify_dot_choreo_ast (fun _ -> "") stmts in

      (* Or write directly to file *)
      let oc = open_out "ast.dot" in
      dot_choreo_ast oc (fun _ -> "") stmts;
      close_out oc
    ]}

    {b Terminal:}
    {[
      $ dot -Tpng ast.dot -o ast.png
      $ dot -Tsvg ast.dot -o ast.svg
      $ open ast.png
    ]}

    {b Expected:} Visual graph showing AST structure:
    {v
              stmt_block
             /          \
           Decl          Send
         /    \        /  |  \
       Var  TLoc   Alice  x  Bob
        |   / \
        x Alice TInt
    v}

    {b Raises:} Functions writing to channels may raise [Sys_error] if file
    operations fail.*)

(** [stringify_dot_choreo_ast] converts choreographic 
      statement block [stmts] to a DOT graph representation as a string.
      
      Parameters:
      - [meta_to_string]: function to convert metadata ['a] to a string for 
        node labels
      - [stmts]: the statement block to visualize
      
      Returns a DOT format string to produce visual diagrams of the AST structure.*)
val stringify_dot_choreo_ast : ('a -> string) -> 'a Ast_core.Choreo.M.stmt_block -> string

(** [dot_choreo_ast] writes choreographic statement 
      block [stmts] as a DOT graph to output channel [oc].
      
      {b Note on documentation:} Although the function signature uses unlabeled 
      parameters, the documentation uses descriptive parameter names ([oc], 
      [meta_to_string], [stmts]) for clarity. This is standard OCaml documentation 
      practice - parameter names in docs help readers understand each argument's 
      purpose, even when the signature doesn't include explicit labels.
      
      Parameters:
      - [oc]: output channel to write DOT format to
      - [meta_to_string]: function to convert metadata ['a] to string labels
      - [stmts]: the statement block to visualize*)
val dot_choreo_ast
  :  out_channel
  -> ('a -> string)
  -> 'a Ast_core.Choreo.M.stmt_block
  -> unit

    Returns a DOT format string to produce visual diagrams of the AST structure.*)

val dot_choreo_ast :
  out_channel -> ('a -> string) -> 'a Ast_core.Choreo.M.stmt_block -> unit
(** [dot_choreo_ast] writes choreographic statement block [stmts] as a DOT graph
    to output channel [oc].

    {b Note on documentation:} Although the function signature uses unlabeled
    parameters, the documentation uses descriptive parameter names ([oc],
    [meta_to_string], [stmts]) for clarity. This is standard OCaml documentation
    practice - parameter names in docs help readers understand each argument's
    purpose, even when the signature doesn't include explicit labels.

    Parameters:
    - [oc]: output channel to write DOT format to
    - [meta_to_string]: function to convert metadata ['a] to string labels
    - [stmts]: the statement block to visualize*)

(** {1 Foreign Function Interface (FFI) Utilities}

    Functions for parsing and extracting information about foreign function
    declarations. Used during code generation to properly link external
    functions. *)

(** [parse_external_name] parses a foreign function name specification 
      into [(module_name, function_name, alias)]. See section example for usage. *)
val parse_external_name : string -> string option * string * string option

val collect_ffi_info
  :  'a Ast_core.Choreo.M.stmt list
  -> (string option * string * string option) list

val ast_list_info_map
  :  ('a -> 'b)
  -> 'a Ast_core.Choreo.M.stmt_block
  -> 'b Ast_core.Choreo.M.stmt_block
