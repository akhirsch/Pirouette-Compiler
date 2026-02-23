(** Parser specification for the Pirouette choreographic programming language.*)

(**  This file defines the grammar rules for parsing Pirouette source code into
    Abstract Syntax Trees (ASTs). It is processed by Menhir/ocamlyacc to generate
    the actual parser implementation.
    
    {2 Parser Overview}
    
    The parser works in conjunction with the lexer to transform Pirouette source
    code into structured AST nodes:
    
    {v
      Source text  →  Lexer  →  Tokens  →        Parser  →  Parsed_ast
      "x := 5"        read      [ID; COLONEQ; INT]         Choreo.stmt_block
    v}
    
    {2 Key Features}
    
    {b Position Tracking:} All AST nodes include source position information
    ([Pos_info.t]) for accurate error reporting. The [gen_pos] function extracts
    position data from Menhir's [$startpos] and [$endpos] markers.
    
    {b Operator Precedence:} Precedence rules (defined via [%left], [%right], 
    [%nonassoc]) resolve ambiguities in expressions. Higher declarations in the
    precedence list bind more tightly.
    
    {b Grammar Structure:}
    - [prog]: Top-level entry point (statement block + EOF)
    - [stmt]: Choreographic statements (declarations, assignments, type definitions)
    - [choreo_expr]: Choreographic expressions (send, sync, if/then/else, etc.)
    - [local_expr]: Local expressions (arithmetic, variables, pattern matching)
    - [choreo_pattern]/[local_pattern]: Pattern matching constructs
    - [choreo_type]/[local_type]: Type annotations
    
    {2 Pirouette Syntax Examples}
    
    {b Variable declaration and assignment:}
    {[
      x : Alice.int;
      x := [Alice] 5;
    ]}
    
    {b Communication (send):}
    {[
      send Alice x -> Bob
      (* Or with destructuring: *)
      [Alice] x ~> Bob.y; rest
    ]}
    
    {b Synchronization (select):}
    {[
      Alice[Ready] ~> Bob;
      (* Alice sends label "Ready" to Bob *)
    ]}
    
    {b Control flow:}
    {[
      if [Alice] x > 10 then
        (* true branch *)
      else
        (* false branch *)
    ]}
    
    {b Foreign function declarations:}
    {[
      foreign sqrt : Alice.float -> Alice.float := "sqrt";
    ]}
    
    {2 Output}
    
    The parser produces [Parsed_ast.Choreo.stmt_block], which contains:
    - All AST nodes with [Pos_info.t] metadata (filename, line, column)
    - Proper nesting and structure according to the grammar
    - Ready for type checking and further compilation stages
    
    {2 Error Handling}
    
    Parse errors include position information automatically via Menhir's error
    reporting. The [gen_pos] function ensures all AST nodes track their source
    locations for detailed error messages.
    
    {2 Notes}
    
    - Semicolons are currently required after statements (marked for potential removal)
    - Operator precedence follows standard mathematical conventions
    - Entry point is [%start prog] which returns [Parsed_ast.Choreo.stmt_block] *)

(** Operator Precedence and Associativity:
    - Defines the precedence and associativity rules for operators to resolve ambiguities in expressions.*)

(** [prog] parses a stmt_block aka list of statements and add EOF at the end of code block.*)

(** [stmt_block] parses and returns the list of statements.*)

(**  [stmt] parses statements within a choreography and constructs corresponding AST nodes.
    - Returns: An AST node representing the statement.
    - Example: Parsing a pattern, a colon, a choreography type, and a semicolon results in a `Decl` node with the pattern, type, and metadata. *)

(** [local_expr] parses local expressions and constructs corresponding AST nodes.

    - Returns: An AST node representing the local expression.*)

(** [choreo_pattern] parses patterns used in choreography expressions and constructs corresponding AST nodes.*)

(** [local_pattern] parses patterns used in local expressions within choreographies and constructs corresponding AST nodes.*)

(** [choreo_type] parses choreography types and constructs corresponding AST nodes.

    - Returns: An AST node representing the choreography type.
*)

(** [local_type] parses local types and constructs corresponding AST nodes.

    - Returns: An AST node representing the local type.
*)

(** [var_id] parses an identifier for a variable and constructs a corresponding AST node.

    - Returns: A `VarId` node containing the identifier and its metadata.
    - Example: Parsing an `ID` token results in a `VarId` node with the identifier and associated metadata.
*)

(** [choreo_case] parses case expressions for choreography expressions and constructs corresponding AST nodes.

    Each case is defined by a pattern and an expression, separated by an arrow.

    - Returns: A tuple containing the parsed pattern and the corresponding choreography expression.
    - Example: Parsing a vertical bar, a pattern, an arrow, and a choreography expression results in a tuple of the pattern and expression.
*)

(** [local_case] parses case expressions for local expressions and constructs corresponding AST nodes.

    Similar to [case], but specifically for local expressions within a choreography.

    - Returns: A tuple containing the parsed local pattern and the corresponding local expression.
    - Example: Parsing a vertical bar, a local pattern, an arrow, and a local expression results in a tuple of the local pattern and expression.
*)

(** [bin_op] parses binary operators and constructs corresponding AST nodes.

    Each operator is associated with a specific constructor that takes location information as an argument.

    - Returns: An AST node representing the binary operation.
    - Example: Parsing the token PLUS with location info at position 1 results in [Plus ($1)].
*)
