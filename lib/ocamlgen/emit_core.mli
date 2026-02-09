(** OCaml code generation from Pirouette IR.
    
    This module converts Pirouette AST nodes (both Local and Network IR) into 
    OCaml Parsetree nodes that can be compiled into executable programs.
    
    The [emit_] functions transform Pirouette AST into OCaml AST:
    - [emit_local_pexp], [emit_local_ppat]: Convert Local AST (pure computation)
    - [emit_net_pexp], [emit_net_binding], [emit_net_fun_body]: Convert Network IR 
      (computation with communication)
    - Input: Pirouette AST nodes ([Ast_core.Local.M] and [Ast_core.Net.M] types)
    - Output: OCaml Parsetree nodes ([Ppxlib.expression], [Ppxlib.pattern], etc.)
    - Result: OCaml code that implements the choreography for a specific endpoint

    {2 About Ppxlib and Parsetree}
    
    {b Ppxlib} is a library for creating and manipulating OCaml AST nodes.
    We use Ppxlib to construct Parsetree nodes directly from Pirouette IR. 
    Instead of generating OCaml source code as strings and having the OCaml 
    parser read it, we build the Parsetree data structures directly. This avoids 
    error-prone string concatenation and provides type-safe code generation.
    
    {b Parsetree} is OCaml's internal representation of source code after parsing
    but before type checking. When the OCaml compiler reads source code, it 
    produces a Parsetree. We use Ppxlib to construct these same Parsetree nodes
    directly from Pirouette IR.

    {b Compilatin Flow:}
    
    See {{:https://github.com/akhirsch/Pirouette-Compiler/wiki/Compiler-Pipeline-Diagram}the Pirouette Wiki} for a
    Compiler Pipeline Diagram depicting the process of generating OCaml code from Pirouette code
    
    Using Ppxlib ensures:
    - Type-safe code generation (syntax errors caught at generation time)
    - Proper handling of OCaml language features
    - Integration with OCaml's compilation pipeline
    
   {2 The Emission Process}
    
    1. Network IR expressions/patterns → OCaml Parsetree expressions/patterns
    2. Communication primitives (Send/Recv) → Generated via pluggable message interface
       - Values are serialized using [Marshal.to_string] before sending
       - Values are deserialized using [Marshal.from_string] after receiving
    3. Local computations → Direct OCaml expressions
    
    The [Msg_intf.M] module provides pluggable code generation for 
    communication operations, allowing different runtime implementations
    (HTTP, TCP sockets, Unix pipes, message queues, etc.) to generate appropriate
    OCaml code for their backend. All backends use OCaml's [Marshal] module
    for serialization.*)

(** {1 Exceptions}*)

(** [Main_expr] is raised when encountering the main expression during
      code generation.
      
      This exception carries the OCaml expression that represents the program's
      entry point, allowing special handling of the main computation separately
      from other bindings. 
      
      The [Ppxlib.expression] is an OCaml AST node that can be compiled by the
      OCaml compiler.*)
exception Main_expr of Ppxlib.expression

(** {1 Local Code Emission}

  Functions for converting local AST nodes (pure computation without 
    communication) to OCaml code. These don't require a message module
    since they generate pure functional code. 
    
    These functions bridge between two AST systems:
    - Input: Pirouette's Local AST (internal IR)
    - Output: OCaml Parsetree via Ppxlib (OCaml compiler's IR) *)

(** [emit_local_pexp] converts a local expression [expr] to an OCaml
Parsetree expression.

  Generates OCaml code for pure local computation - arithmetic, variables,
  patternmatching, ect. - with out any communication primitives. 

  [Ppxlib.expression] is an OCaml data structure (records, variants, lists) 
  that represents code, not a string.
  
  {b Stage 1 - Pirouette source (what users write):}
    {[
    x + 1
    ]}
    
  {b Stage 2 - Pirouette Local AST (internal representation)}:
    {[
      Local.M.BinOp(
        Local.M.Var(Local.M.VarId("x", ()), ()),
        Local.M.Plus(()),
        Local.M.Var(Local.M.Int(1, ()), ())
        ()) (* all () is metadata *)
        ]}
        
  {b Stage 3 - call emit_local_pexp:}
    {[
      let local_ast = (*... the Local AST above...*) in
      let ocaml_parsetree = emit_local_pexp local_ast in
      (* ocaml_parsetree is a ppxlib.expression node *)
      ]}
      
  {b Stage 4 - OCaml Parsetree (Ppxlib.expression - OCaml compiler's IR):}
      {[
        (* A Ppxlib.expression representing: *)
        x + 1
      ]}
      
  {b Stage 5 - Final compiled OCaml code:}
      {[
        (* The OCaml compiler produces executable code for: *)
        x + 1
      ]}
      
      {b Summary:} This function translates from Pirouette's representation
      of local computation to OCaml's representation, enabling the OCaml
      compiler to generate executable code. *)
val emit_local_pexp : 'a Ast_core.Local.M.expr -> Ppxlib.expression

(** [emit_local_ppat] converts a Pirouette local pattern to an OCaml Parsetree 
pattern.

  Generates OCaml patterns for variable bindings, literals, pairs, 
  and sum type matching. 

  [Ppxlib.pattern] is a structured record that represents patterns as OCaml data, 
  not as strings.
  
  {b Stage 1 - Pirouette source (what users write):}
    {[
      (x, y)
    ]}
      
  {b Stage 2 - Pirouette Local AST (internal representation):}
    {[
      Local.M.Pair(
        Local.M.Var(Local.M.VarId("x", ()), ()),          
        Local.M.Var(Local.M.VarId("y", ()), ()),
        ()) (* all () is metadata *)
    ]}
      
  {b Stage 3 - Call emit_local_ppat:}
    {[        
      let local_pattern = (* ... the Local AST above ... *) in
      let ocaml_parsetree_pattern = emit_local_ppat local_pattern in
      (* ocaml_parsetree_pattern is a Ppxlib.pattern node *)
    ]}
            
  {b Stage 4 - OCaml Parsetree (Ppxlib.pattern - OCaml compiler's IR):}
    {[        
      (* A Ppxlib.pattern representing: *)
      (x, y)
    ]}
    
      
  {b Stage 5 - Used in compiled OCaml code:}
    {[
      (* In let bindings: *)
      let (x, y) = (1, 2) in
      x + y
  
      (* In match expressions: *)
      match pair_value with
      | (x, y) -> x + y
  
      (* In function parameters: *)
      let add_pair (x, y) = x + y
    ]}
      
    {b Summary:} Used in let bindings, function parameters, and match cases
      to bind variables from structured data.*)
val emit_local_ppat : 'a Ast_core.Local.M.pattern -> Ppxlib.pattern

(** {1 Network Code Emission}

  Functions for converting network IR nodes (with explicit communication) to 
  OCaml code using a pluggable message interface
  
  All network emissions functions require:
  - [self_id] the name of the current endpoint (e.g. "Bob" "Jackie")
  - [msg_module]: Code generator module implementing [Msg_intf.M] that produces
  OCaml expressions for send/recv operations. Different message modules can 
  generage code for different communication backends (HTTP,TCP, message queues, ect.)
  
  {b Data Serialization:} all sent values are automatically sterialized, preparing the
  objects/data for transmission accross different boundaries (machines) using:
  [Marshal.to_string] before transmission and deserialized using 
  [Marshal.from_string] upon receipt. This allows sending arbitrary OCaml 
    values over the network. *)

(** [emit_net_fun_body] generates an OCaml function body from Pirouette Net IR
  
    Parameters:
    - [self_id]: name of the current endpoint 
    - [Msg_intf.M]: module that generates code for communication operations
    - [Ast_core.Local.M.pattern list]: function parameters - Pirouette Local AST
    - [Ast_core.Net.M.expr]: network expression for function body - Priouette Net AST
    
    Creates a complete function expression with parameters and body, delegating
    communication operations to the message module.
      
    [Ppxlib.expression] is an OCaml data structure (records, variants, lists) 
    that represents code, not a string.
      
    {b Stage 1 - Pirouette source (choreography, before projection):}
      {[
        fun x y -> send Alice (x + y) -> Bob
      ]}
      
    {b Stage 2 - After projection to Alice's Network IR:}
      {[
        (* Parameters (Local AST): *)
        [Local.M.Var(Local.M.VarId("x", ()), ());
         Local.M.Var(Local.M.VarId("y", ()), ())]
         
        (* Body (Net AST): *)
        Net.M.Send(
          Net.M.Ret(Local.M.BinOp(
            Local.M.Var(Local.M.VarId("x", ()), ()), 
            Local.M.Plus(()), 
            Local.M.Var(Local.M.VarId("y", ()), ()), 
            ())),
          Local.M.LocId("Bob", ()),
          ()) (* all () is metadata *)
      ]}
      
    {b Stage 3 - Call emit_net_fun_body:}
      {[
      (* Take the Network IR from Stage 2: *)
      let params = [Local.M.Var(Local.M.VarId("x", ()), ());
                   Local.M.Var(Local.M.VarId("y", ()), ())] in
                   params
      let body = Net.M.Send(...) in  (* The Send expression from Stage 2 *)
                    body 
  
      (* Call the function: *)
      let fun_expr = emit_net_fun_body
         ~self_id:"Alice"
        (module Http_Msg)  
        (* Http_Msg is made up, it's an example of a module that implements Msg_intf.M *)
        params
        body in
        fun_expr (* fun_expr is a Ppxlib.expression *)
      ]}
      
    {b Stage 4 - OCaml Parsetree (Ppxlib.expression - OCaml compiler's IR):}
      {[
        (* A Ppxlib.expression representing: *)
        fun x y ->
        let val_1 = (x + y) in
        (* Message module generates backend-specific send *)
        (* with Marshal.to_string val_1 [] *)
        Http.send.send_to "Bob" (Marshal.to_string val_1 [])
      ]}

    {b Stage 5 - Final compiled OCaml code:}
    {[
    (* Executable OCaml function: *)
    fun x y ->
      let val_1 = (x + y) in
      Http_send.send_to "Bob" (Marshal.to_string val_1 [])
        
        (* The value (x + y) is:
           1. Computed and bound to val_1
           2. Serialized using Marshal.to_string
           3. Sent to Bob using backend-specific send function *)
      ]}

    {b Summary:} This function translates function definitions with 
      communication operations from Pirouette's representation to OCaml's 
      representation. Values are automatically marshaled before sending, allowing 
      transmission accross different boundaries (machines). *)
val emit_net_fun_body
  :  self_id:string
  -> (module Msg_intf.M)
  -> 'a Ast_core.Local.M.pattern list
  -> 'a Ast_core.Net.M.expr
  -> Ppxlib.expression

(** [emit_net_binding] converts a Pirouette network statement to an OCaml value 
  binding.
      
      Parameters:
      - [self_id]: name of the current endpoint
      - [Msg_intf.M]: the message module which code generator for communication operations
      - [Ast_core.Net.M.stmt]: network statement (typically Decl or Assign) from Pirouette Net AST
      
      Generates top-level bindings for the OCaml program, including variable
      declarations and assignments. Communication operations are generated via
      the message module.
      
      [Ppxlib.value_binding] is an OCaml data structure that represents 
      value bindings (let bindings) as structured data, not as strings.
      
      {b Stage 1 - Pirouette source (choreography, before projection):}
        {[
          send Alice 33 -> Bob
        ]}
      
      {b Stage 2 - After projection to Bob's Network IR:}
      *)
val emit_net_binding
  :  self_id:string
  -> (module Msg_intf.M)
  -> 'a Ast_core.Net.M.stmt
  -> Ppxlib.value_binding

(** [emit_net_pexp ~self_id msg_module expr] converts a Pirouette network 
      expression to an OCaml Parsetree expression.
      
      Parameters:
      - [self_id]: name of the current endpoint generating code for
      - [msg_module]: code generator implementing [Msg_intf.M] for communication
      - [expr]: network IR expression to convert (Pirouette Net AST)
      
      Transforms network operations including communication primitives, local
      computations, and control flow. Communication operations are delegated to
      the message module's code generators.
      
      [Ppxlib.expression] is an OCaml data structure (records, variants, lists) 
      that represents code, not a string.*)
val emit_net_pexp
  :  self_id:string
  -> (module Msg_intf.M)
  -> 'a Ast_core.Net.M.expr
  -> Ppxlib.expression

(** [emit_foreign_decl var_name typ external_name] generates an OCaml 
      external declaration for a foreign function.
      
      Parameters:
      - [var_name]: local name for the function
      - [typ]: type of the foreign function
      - [external_name]: external name to link against
      
      Creates OCaml [external] declarations that bind foreign functions from
      other languages (typically C) or libraries. Does not require a message
      module since FFI is independent of communication backend.*)
val emit_foreign_decl : string -> 'a Ast_core.Net.M.typ -> string -> Ppxlib.value_binding
