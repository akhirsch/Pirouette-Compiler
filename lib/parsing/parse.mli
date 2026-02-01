val parse_with_error : string -> Lexing.lexbuf -> Parsed_ast.Choreo.stmt_block

(** [parse_net_with_error] parses network IR Pirouette code from a 
    lexer buffer into a network AST.
    
    This function is typically used for parsing intermediate representations
    or for testing purposes. It produces a [Parsed_ast.Net.stmt_block] which
    is the result of endpoint projection, containing explicit send/recv
    operations rather than choreographic constructs.
    
    {b Parameters:}
    - [lexbuf]: lexer buffer containing the network IR code to parse
    
    {b Returns:} A network statement block representing the parsed program.

    {b Raises:} Parsing exceptions if the source code contains syntax errors. *)
val parse_net_with_error : Lexing.lexbuf -> Parsed_ast.Net.stmt_block
