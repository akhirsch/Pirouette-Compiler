(** {b Net:} Network-level intermediate representation (IR). This module defines the AST structures for network programs with explicit 
    communication and synchronization. Unlike choreographic ASTs which describe 
    global protocols, network ASTs represent distributed computation after 
    endpoint projection, with explicit send/receive and choice coordination 
    primitives for each location. *)

(**{b M:} This module captures explicit communication, synchronization, and dataflow 
    between locations after endpoint projection. It forms the compiler's bridge 
    between choreographic ASTs and backend code generation.
    
    Unlike the choreography AST (which describes global protocols) or local AST
    (which describes single-endpoint computation), the network IR represents
    distributed computation with explicit send/receive primitives and choice
    coordination.
    
    All AST nodes are parameterized by metadata type ['a] for compiler passes
    to attach annotations. *)
module M : sig
  (** {1 Network Types} 
  
  ['a typ] represent types at the network level, forming the bridge between 
    choreographic types and backend code generation. These types appear in 
    projected endpoint programs with explicit send/receive operations. Each 
    node carries metadata of type ['a], allowing compiler passes to attach 
    annotations. *)

  type 'a typ =
    | TUnit of 'a
    (** Unit type
          
    {b Internal AST Structure:} [TUnit(metadata)]
          
    {b Pirouette Syntax:}
        {[
          unit
        ]}
          
    {b OCaml AST Construction:}
        {[
          let unit_type = 
            TUnit(())              
          in
          unit_type]} *)
    | TLoc of 'a Local.M.loc_id * 'a Local.M.typ * 'a
    (** Location-qualified type: a value of a local type at a specific location.
          
      {b Internal AST Structure:} [TLoc(location, local_type, metadata)]
          
      {b Pirouette Syntax:}
          {[
            Alice.int
          ]}
          
      {b OCaml AST Construction:}
          {[
            let alice_int = 
              TLoc(Local.M.LocId("Alice", ()), 
                   Local.M.TInt(()), 
                   ())
            in              
            alice_int]} *)
    | TMap of 'a typ * 'a typ * 'a
    (** Function type
          
      {b Internal AST Structure:} [TMap(domain, codomain, metadata)]
          
      {b Pirouette Syntax:}
          {[
            int -> string
          ]}
          
      {b OCaml AST Construction:}
          {[
            let int_to_string = 
              TMap(TInt(()), TString(()), ())
            in
            int_to_string]} *)
    | TProd of 'a typ * 'a typ * 'a
    (** Product type (pairs)
          
      {b Internal AST Structure:} [TProd(left_type, right_type, metadata)]
          
      {b Pirouette Syntax:}
          {[
            int * string
          ]}
          
      {b OCaml AST Construction:}
          {[
            let int_string_pair = 
              TProd(TInt(()), TString(()), ())
            in
            int_string_pair]} *)
    | TSum of 'a typ * 'a typ * 'a
    (** Sum type (tagged unions)
          
      {b Internal AST Structure:} [TSum(left_type, right_type, metadata)]
          
      {b Pirouette Syntax:}
          {[
            int + string
          ]}
          
      {b OCaml AST Construction:}
          {[
            let int_or_string = 
              TSum(TInt(()), TString(()), ())
            in
            int_or_string ]} *)

  (** {1 Network Expressions} 
      
       ['a expr] represent computations in projected endpoint programs after 
    choreographic projection. Unlike choreographic expressions which describe 
    global protocols, network expressions include explicit [Send]/[Recv] for 
    communication and [ChooseFor]/[AllowChoice] for synchronization. Each 
    expression carries metadata of type ['a], allowing compiler passes to 
    attach annotations. *)

  type 'a expr =
    | Unit of 'a
    (** Unit value
          
      {b Internal AST Structure:} [Unit(metadata)]
          
      {b Pirouette Syntax:}
          {[
            ()
          ]}
          
      {b OCaml AST Construction:}
          {[
            let unit_expr = 
              Unit(())              
            in
            unit_expr]} *)
    | Var of 'a Local.M.var_id * 'a
    (** Variable reference
          
      {b Internal AST Structure:} [Var(var_id, metadata)]
          
      {b Pirouette Syntax:}
          {[
            x
          ]}
          
      {b OCaml AST Construction:}
          {[
            let var_x = 
              Var(Local.M.VarId("x", ()), ())              
            in
            var_x]} *)
    | Ret of 'a Local.M.expr * 'a
    (** Return a local expression: wraps a computation in a network context.
    
      {b Internal AST Structure:} [Ret(local_expr, metadata)]

      {b Note:} This constructor does not have Pirouette syntax - it is inserted
      automatically by the compiler during endpoint projection to distinguish 
      pure local computation from network operations.
      
      Used to embed local expressions (like arithmetic, variable references, 
      function calls) within the network IR, marking them as "compute this 
      locally, then use the result in the network context." Think of it as a bridge
      between local and network worlds.
      
      {b Ocaml:}
      {[
          (* Wraps the local computation "5 + 3" *)
          let ret_val = 
            Ret(Local.M.BinOp( (*BinOp there are two operands*)
                  Local.M.Val(Local.M.Int(5, ()), ()), (* Local Int 5*)
                  Local.M.Plus(()), (* Local operator *)
                  Local.M.Val(Local.M.Int(3, ()), ()), (* Local Int 3 *)
                  ()), (* () is the metadata*)
                ())
          in
          ret_val
        ]}*)
    | If of 'a expr * 'a expr * 'a expr * 'a
    (** Conditional expression
      
      {b Internal AST Structure:} [If(cond, then_expr, else_expr, metadata)]
      
      {b Pirouette Syntax:}
        {[
          if cond then e1 else e2
        ]}
      
      {b OCaml:}
        {[
          let if_expr = 
            If(Var(Local.M.VarId("cond", ()), ()), 
               Var(Local.M.VarId("e1", ()), ()), 
               Var(Local.M.VarId("e2", ()), ()), 
               ()) (* () is the metadata*)
          in
          if_expr]} *)
    | Let of 'a stmt list * 'a expr * 'a
    (** Let binding with statement block
          
      {b Internal AST Structure:} [Let(stmt_list, body_expr, metadata)]
          
      {b Pirouette Syntax:}
        {[
          let x = 5 in x + 1
        ]}
          
      {b OCaml:}
        {[
           let let_expr = 
              Let([Assign([Local.M.Var(Local.M.VarId("x", ()), ())],
                        Unit(()),
                        ())],
                Unit(()),
                ())
            in
            let_expr]} *)
    | Send of 'a expr * 'a Local.M.loc_id * 'a
    (** Send expression: transmits a value to a specified location.
      
      {b Internal AST Structure:} [Send(value_expr, destination, metadata)]
      
      {b Pirouette Syntax:}
        {[
          send Alice 42 -> Bob
        ]}
      
      {b Note:} The [Send] constructor is generated during endpoint projection.
      The choreographic [send] operation above is projected into separate [Send] 
      operations for the sender and [Recv] operations for the receiver.
      
      {b OCaml AST Construction:}
        {[
          (* Alice's projected code *)
          let send_to_bob = 
            Send(Ret(Local.M.Val(Local.M.Int(42, ()), ()), ()), 
                 Local.M.LocId("Bob", ()), 
                 ())
          in
          send_to_bob]} *)
    | Recv of 'a Local.M.loc_id * 'a
    (** Receive expression: receives a value from a specified location.
      
      {b Internal AST Structure:} [Recv(source, metadata)]
      
      {b Pirouette Syntax:}
        {[
          send Alice 42 -> Bob
        ]}
      
      {b Note:} The [Recv] constructor is generated during endpoint projection.
      The choreographic [send] operation above is projected into [Send] operations 
      for the sender and [Recv] operations for the receiver.
      
      {b OCaml AST Construction:}
        {[
          (* Bob's projected code *)
          let recv_from_alice = 
            Recv(Local.M.LocId("Alice", ()), ())
          in
          recv_from_alice]} *)
    | ChooseFor of 'a Local.M.sync_label * 'a Local.M.loc_id * 'a expr * 'a
    (** Make a choice and inform a location: selects a branch and notifies peer.
      
      {b Internal AST Structure:} [ChooseFor(label, peer, continuation, metadata)]
      - [label]: the choice/branch being selected
      - [peer]: location to be notified
      - [continuation]: expression after choice is communicated
      - [metadata]: node metadata
      
      {b Pirouette Syntax:}
        {[
          select Alice Ready -> Bob; continuation
        ]}
      
      {b Note:} The [ChooseFor] constructor is generated during endpoint projection.
      The choreographic [select] operation above is projected into [ChooseFor] 
      operations for the chooser and [AllowChoice] operations for the peer.
      
      {b OCaml AST Construction:}
        {[
          (* Alice's projected code *)
          let choose_ready = 
            ChooseFor(Local.M.LabelId("Ready", ()), 
                      Local.M.LocId("Bob", ()), 
                      Unit(()), 
                      ())
          in
          choose_ready]} *)
    | AllowChoice of 'a Local.M.loc_id * ('a Local.M.sync_label * 'a expr) list * 'a
    (** Allow/offer choices from a location: receives choice and branches accordingly.
      
      {b Internal AST Structure:} [AllowChoice(chooser, branches, metadata)]
      - [chooser]: location making the choice
      - [branches]: list of (label, expression) pairs for each possible choice
      - [metadata]: node metadata
      
      Dual to [ChooseFor] - this is the receiver's side.
      
      {b Pirouette Syntax:}
        {[
          select Alice Ready -> Bob; continuation
        ]}
      
      {b Note:} The [AllowChoice] constructor is generated during endpoint projection.
      The choreographic [select] operation above is projected into [ChooseFor] 
      operations for the chooser and [AllowChoice] operations for the peer.
      
      {b OCaml AST Construction:}
        {[
          (* Bob's projected code *)
          let allow_alice_choice = 
            AllowChoice(Local.M.LocId("Alice", ()), 
                        [(Local.M.LabelId("Ready", ()), Unit(()));
                         (Local.M.LabelId("NotReady", ()), Unit(()))], 
                        ())
          in
          allow_alice_choice]} *)
    | FunDef of 'a Local.M.pattern list * 'a expr * 'a
    (** Function Definition
          
      {b Internal AST Structure:} [FunDef(params, body, metadata)]
          
      {b Pirouette Syntax:}
          {[
            fun x y -> x + y
          ]}
          
      {b OCaml:}
        {[
          let fun_xy = 
            FunDef([Local.M.Var(Local.M.VarId("x", ()), ());
                    Local.M.Var(Local.M.VarId("y", ()), ())],
                   Ret(Local.M.BinOp(
                         Local.M.Var(Local.M.VarId("x", ()), ()),
                         Local.M.Plus(()),
                         Local.M.Var(Local.M.VarId("y", ()), ()),
                         ()),
                       ()),
                   ())
          in
          fun_xy]} *)
    | FunApp of 'a expr * 'a expr * 'a
    (** Function Application
          
    {b Internal AST Structure:} [FunApp(function_expr, argument_expr, metadata)]
          
      {b Pirouette Syntax:}
        {[
          add 3
        ]}
          
      {b OCaml:}
        {[
          let add_3 = 
            FunApp(Var(Local.M.VarId("add", ()), ())                       
            Unit(()),
            ())
          in
          add_3]} *)
    | Pair of 'a expr * 'a expr * 'a
    (** Pair Construction
    
      {b Internal AST Structure:} [Pair(left_expr, left_expr, metadata)]
      
      {b Pirouette Syntax:}
        {[
          (x,y)
        ]}
          
        {b Ocaml:}
          {[
            let pair_xy = 
              Pair(Var(Local.M.VarId("x", ()), ()),
                   Var(Local.M.VarId("y", ()), ()),
                   ())
            in
            pair_xy]}*)
    | Fst of 'a expr * 'a
    (** First projection from pair
          
      {b Internal AST Structure:} [Snd(pair_expr, metadata)]
          
      {b Pirouette Syntax:}
        {[
          fst z
        ]}
          
      {b OCaml:}            
        {[
          let first = 
            Snd(Var(Local.M.VarId("z", ()), ()), ())              
          in
          first]} *)
    | Snd of 'a expr * 'a
    (** Second projection from pair
          
      {b Internal AST Structure:} [Snd(pair_expr, metadata)]
          
      {b Pirouette Syntax:}
        {[
          snd p
        ]}
          
      {b OCaml:}            
        {[
          let second = 
            Snd(Var(Local.M.VarId("p", ()), ()), ())              
          in
          second]} *)
    | Left of 'a expr * 'a
    (** Left injection into sum type
          
      {b Internal AST Structure:} [Right(expr, metadata)]
          
      {b Pirouette Syntax:}
        {[
          Left y
        ]}
      
      {b OCaml:}
        {[
          let left_y =                 
            Right(Var(Local.M.VarId("x", ()), ()), ())
          in
          left_y]} *)
    | Right of 'a expr * 'a
    (** Right injection into sum type
          
      {b Internal AST Structure:} [Right(expr, metadata)]
          
      {b Pirouette Syntax:}
        {[
          Right x
        ]}
      
      {b OCaml:}
        {[
          let right_x =                 
            Right(Var(Local.M.VarId("x", ()), ()), ())
          in
          right_x]} *)
    | Match of 'a expr * ('a Local.M.pattern * 'a expr) list * 'a
    (** Pattern matching
      
    {b Internal AST Structure:} [Match(expr, cases, metadata)]
      - [expr]: expression to match
      - [cases]: list of (pattern, expression) pairs
      - [metadata]: node metadata
      
    {b Pirouette Syntax:}
        {[
          match x with
          | Left v -> v + 1
          | Right v -> v - 1
        ]}
      
    {b OCaml:}
        {[
          let match_expr = 
            Match(Var(Local.M.VarId("x", ()), ()),
                  [(Local.M.Left(Local.M.Var(Local.M.VarId("v", ()), ()), ()),
                    Ret(Local.M.BinOp(
                          Local.M.Var(Local.M.VarId("v", ()), ()),
                          Local.M.Plus(()),
                          Local.M.Val(Local.M.Int(1, ()), ()),
                          ()),
                        ()));
                   (* First case: Left v -> v + 1 *)
                   
                   (Local.M.Right(Local.M.Var(Local.M.VarId("v", ()), ()), ()),
                    Ret(Local.M.BinOp(
                          Local.M.Var(Local.M.VarId("v", ()), ()),
                          Local.M.Minus(()),
                          Local.M.Val(Local.M.Int(1, ()), ()),
                          ()),
                        ()))],
                   (* Second case: Right v -> v - 1 *)
                  ())
          in
          match_expr]} *)

  (** {1 Network Statements}
    
    ['a stmt] represent statements in projected endpoint programs after 
    choreographic projection. These include variable declarations, assignments, 
    type aliases, and foreign function declarations. Each statement carries 
    metadata of type ['a], allowing compiler passes to attach annotations.*)

  and 'a stmt =
    | Decl of 'a Local.M.pattern * 'a typ * 'a
    (** Type declaration
          
      {b Internal AST Structure:} [Decl(pattern, typ, metadata)]
          
      {b Pirouette Syntax:}
        {[
          x : int
        ]}
          
      {b OCaml:}
        {[
          let x_int_decl = 
             Decl(Local.M.Var(Local.M.VarId("x", ()), ()),
                 TInt(()),                   
                 ())
          in
          x_int_decl]} *)
    | Assign of 'a Local.M.pattern list * 'a expr * 'a
    (** Assignment
          
      {b Internal AST Structure:} [Assign(patterns, expr, metadata)]
          
      {b Pirouette Syntax:}
            {[
              x := 5
            ]}
          
      {b OCaml :}
        {[            
          let x_assign = 
            Assign([Local.M.Var(Local.M.VarId("x", ()), ())],
                Unit(()),
                ())
          in
          x_assign]} *)
    | TypeDecl of 'a Local.M.typ_id * 'a typ * 'a
    (** Type alias declaration: a way to give more meaningful name to an 
    existing type. Not creating a new type.
          
      {b Internal AST Structure:} [TypeDecl(typ_id, typ, metadata)]
          
      {b Pirouette Syntax:}         
        {[
          type Result = int * int.  (* Result is another word for int * int *)
          type Name = string        (* Name is just another word for string *)
          type Age = int            (* Age is just another word for int *)
          type Person = string * int (* Person is a pair of name and age *)
        ]}
          
      {b OCaml:}
        {[
      (* result is another name for int * int *)
          let result_decl = 
            TypeDecl(Local.M.TypId("Result", ()),                          
            TProd(TInt(()), TInt(()), ()),
            ())
          in
          result_decl]} *)
    | ForeignDecl of 'a Local.M.var_id * 'a typ * string * 'a

  (** {1 Net Statement Block}*)

  (** Statement Block: a sequence of statements executed in order.
  
  {b Internal AST Structure:} [stmt_block] is a list of ['a stmt]
  
    {b Pirouette Syntax:}
      {[
        x : int;
        x:= 5;
        y : int;
        y:= x + 10]}
      
    {b Ocaml:}
      {[
        let stmt_block = 
             [Decl(Local.M.Var(Local.M.VarId("x", ()), ()), 
                TInt(()), 
                ());
           (* Declaring local variable "x" with type TInt *)
           Assign([Local.M.Var(Local.M.VarId("x", ()), ())], 
                  Ret(Local.M.Val(Local.M.Int(5, ()), ()), ()), 
                  ());
           (* Assigning value 5 to variable "x" *)
           Decl(Local.M.Var(Local.M.VarId("y", ()), ()), 
                TInt(()), 
                ());
           (* Declaring local variable "y" with type TInt *)
           Assign([Local.M.Var(Local.M.VarId("y", ()), ())], 
                  Ret(Local.M.BinOp(
                        Local.M.Var(Local.M.VarId("x", ()), ()), 
                        Local.M.Plus(()), 
                        Local.M.Val(Local.M.Int(10, ()), ()), 
                        ()), 
                      ()), 
                  ())]
           (* Assigning "x + 10" to variable "y" *)
        in
        stmt_block]} *)
  and 'a stmt_block = 'a stmt list
end

(**{b With:} This module uses a functor for creating network AST types 
with concrete metadata.
    
    Instantiates the polymorphic network AST with a specific metadata type. *)
module With : functor
    (Info : sig
       (** [type t] is the concrete metadata type*)
       type t
     end)
    -> sig
  type nonrec typ = Info.t M.typ
  type nonrec expr = Info.t M.expr
  type nonrec stmt = Info.t M.stmt
  type nonrec stmt_block = Info.t M.stmt_block

  (** {1 Metadata Acessors}

  Functions to extract metadata from AST nodes. *)

  (** [get_info_typ t] is the metadata from type [t]. *)
  val get_info_typ : typ -> Info.t

  (** [get_info_expr e] is the metadata from expression [e]. *)
  val get_info_expr : expr -> Info.t

  (** [get_info_stmt s] is the metadata from statement [s]. *)
  val get_info_stmt : stmt -> Info.t

  (** {1 Metadata Modifiers}

  Functions to replace metadata in AST nodes*)

  (** [set_info_typ info t] is type [t] with metadata replaced by [info]. *)
  val set_info_typ : Info.t -> typ -> typ

  (** [set_info_expr info e] is expression [e] with metadata replaced by [info]. *)
  val set_info_expr : Info.t -> expr -> expr

  (** [set_info_stmt info s] is statement [s] with metadata replaced by [info]. *)
  val set_info_stmt : Info.t -> stmt -> stmt
end
