(** {b Choreo:} Core choreography abstract syntax tree definitions. This module
    defines the AST structures for choreographic programs, including types,
    patterns, expressions, and statements that operate across multiple
    distributed locations. *)

(** {b M:} This module defines the AST structures for choreographic programs.
    All AST nodes are parameterized by a metadata type ['a], allowing different
    compiler passes to attach their own annotations (source locations, type
    information, etc.). *)
module M : sig
  (** {1 Type Identifiers}

      Pairs a type name with metadata. Used to name types in choreographic
      declarations and references. Each identifier carries metadata of type
      ['a], allowing the compiler to track source locations and attach type
      information.*)

  type 'a typ_id =
    | Typ_Id of string * 'a
        (** Type identifiers: [typ_id] (name + metadata).

            {b Internal AST Structure:} [Typ_Id(name, meta)]
            - [name]: type name as a string (e.g., "Sum", "Result").
            - [meta]: node metadata (source, typing info, etc.).

            {b Pirouette Syntax:}
            {[
              type Result = int + string
            ]}

            {b OCaml:}
            {[
              let result_id = Typ_Id ("Result", ()) in
              result_id
            ]}*)

  (** {1 Choreographic Types}

      ['a typ] represent the types of values and communications in a
      choreography. Each node carries metadata of type ['a], allowing compiler
      passes to attach annotations such as source locations or type information.*)

  type 'a typ =
    | TUnit of 'a
        (** Unit type: represents the absence of a meaningful value.

            {b Internal AST Structure:} [TUnit(metadata)]
            - [metadata]: node metadata

            {b Pirouette Syntax:}
            {[
              (* Function returning unit *)
              print_message : string -> unit

              (* Function taking unit as argument *)
              get_time : unit -> int
            ]}

            {b OCaml:}
            {[
              let unit_type = TUnit () in
              (* unit_type now represents the unit type in the AST *)
              unit_type
            ]} *)
    | TLoc of 'a Local.M.loc_id * 'a Local.M.typ * 'a
        (** Location-qualified type: a value of a local type at a specific
            location

            {b Internal AST Structure:} [TLoc(location, local_type, meta)]
            - [location]: the location identifier
            - [local_type]: the local type at that location
            - [meta]: node metadata

            {b Pirouette Syntax:}
            {[
              Alice.int
            ]}

            {b Ocaml:}
            {[
              let alice_int =
                TLoc (Local.M.LocId ("Alice", ()), Local.M.TInt (), ())
                (* () is unit type metadata*)
              in
              alice_int
            ]} *)
    | TVar of 'a typ_id * 'a
        (** Type variable

            {b Internal AST Structure:} [TVar(type_id, meta)]

            {b Pirouette Syntax:}
            {[
              'a
            ]}

            {b Ocaml:}
            {[
              let type_var_a = TVar (Typ_Id ("a", ()), ()) in
              type_var_a
            ]}*)
    | TMap of 'a typ * 'a typ * 'a
        (** Function type (domain -> codomain)

            {b Internal AST Structure:} [TMap(domain, codomain, meta)]

            {b Pirouette Syntax:}
            {[
              int -> string
            ]}

            {b Ocaml:}
            {[
              let int_to_string = TMap (TInt (), TString (), ()) in
              int_to_string
            ]}*)
    | TProd of 'a typ * 'a typ * 'a
        (** Product type (pair).

            {b Internal AST Structure:} [TProd(left, right, meta)]

            {b Pirouette Syntax:}
            {[
              int * string
            ]}

            {b Ocaml:}
            {[
              let int_string_pair = TProd (TInt (), TString (), ()) in
              int_string_pair
            ]}*)
    | TSum of 'a typ * 'a typ * 'a
        (** Sum type: tagged union representing a choice between two
            alternatives.

            A value is either Left (first type) or Right (second type), but not
            both.

            {b Internal AST Structure:} [TSum(left, right, meta)]

            {b Pirouette Syntax:}
            {[
              int
              + string (* either int or string *) bool
              + unit (* either bool or unit *) (int * int)
              + string (* either a pair or a string *)
            ]}

            {b Ocaml:}
            {[
              let int_or_string = TSum (TInt (), TString (), ()) in
              int_or_string
            ]}*)

  (** {1 Choreographic Patterns}

      ['a pattern] for destructuring values, annotated with metadata of type
      ['a]. Patterns can match values distributed across multiple locations. *)

  type 'a pattern =
    | Default of 'a
        (** Wildcard that matches any data and binds nothing.

            {b Internal AST Structure:} [Default(meta)]

            {b Pirouette Syntax:}
            {[
              _
            ]}

            {b Ocaml:}
            {[
              let wildcard = Default () in
              wildcard
            ]}*)
    | Var of 'a Local.M.var_id * 'a
        (** Variable binding

            {b Internal AST Structure:} [Var(var_id, meta)]

            {b Pirouette Syntax:}
            {[
              x
            ]}

            {b Ocaml:}
            {[
              let var_x = Var (Local.M.VarId ("x", ()), ()) in
              var_x
            ]}*)
    | Pair of 'a pattern * 'a pattern * 'a
        (** Pair pattern for destructuring products. Contains a pattern for the
            first element, a pattern for the second element, and metadata.

            {b Internal AST Structure:}
            [Pair(left_pattern, right_pattern, meta)]

            {b Pirouette Syntax:}
            {[
              x, y
            ]}
            The pattern matcher recursively works through both sub-patterns to
            destructure nested pairs.

            {b Ocaml:}
            {[
              let pair_xy =
                Pair
                  ( Var (Local.M.VarId ("x", ()), ()),
                    Var (Local.M.VarId ("y", ()), ()),
                    () )
              in
              pair_xy
            ]}*)
    | LocPat of 'a Local.M.loc_id * 'a Local.M.pattern * 'a
        (** Location-qualified pattern: matches a local pattern at a specific
            location

            {b Internal AST Structure:} [LocPat(location, local_pattern, meta)]

            {b Pirouette Syntax:}
            {[
              Alice.x
            ]}

            {b Ocaml:}
            {[
              let alice_x =
                LocPat
                  ( Local.M.LocId ("Alice", ()),
                    Local.M.Var (Local.M.VarId ("x", ()), ()),
                    () )
              in
              alice_x
            ]}*)
    | Left of 'a pattern * 'a
        (** Left constructor of sum type.

            {b Internal AST Structure:} [Left(pattern, meta)]

            {b Pirouette Syntax:}
            {[
              Left x
            ]}

            {b Ocaml:}
            {[
              let left_x = Left (Var (var_id_x, ()), ()) in
              left_x
            ]}*)
    | Right of 'a pattern * 'a
        (** Right constructor of sum type.

            {b Internal AST Structure:} [Right(pattern, meta)]

            {b Pirouette Syntax:}
            {[
              Right x
            ]}

            {b Ocaml:}
            {[
              let right_x = Right (Var (var_id_x, ()), ()) in
              right_x
            ]}*)

  (** {1 Choreographic Expressions}

      ['a expr] annotated with metadata of type ['a]. Expressions describe
      computations and communications in a choreography, including message
      passing between locations. *)

  type 'a expr =
    | Unit of 'a
        (** Unit value

            {b Internal AST Structure:} [Unit(meta)]

            {b Pirouette Syntax:}
            {[
              ()
            ]}

            {b Ocaml:}
            {[
              let unit_expr = Unit () in
              unit_expr
            ]}*)
    | Var of 'a Local.M.var_id * 'a
        (** Variable reference.

            {b Internal AST Structure:} [Var(var_id, meta)]

            {b Pirouette Syntax:}
            {[
              x
            ]}

            {b Ocaml:}
            {[
              let var_x = Var (Local.M.VarId ("x", ()), ()) in
              var_x
            ]}*)
    | LocExpr of 'a Local.M.loc_id * 'a Local.M.expr * 'a
        (** Location-qualified expression: a local expression at a specific
            location

            {b Internal AST Structure:} [LocExpr(location, local_expr, meta)]

            {b Pirouette Syntax:}
            {[
              Alice.x
            ]}

            {b Ocaml:}
            {[
              let alice_x =
                LocExpr
                  ( Local.M.LocId ("Alice", ()),
                    Local.M.Var (Local.M.VarId ("x", ()), ()),
                    () )
              in
              alice_x
            ]}*)
    | Send of 'a Local.M.loc_id * 'a expr * 'a Local.M.loc_id * 'a
        (** Message send:

            {b Internal AST Structure:} [Send(sender, value, receiver, meta)]
            - [sender]: origin location
            - [value]: expression being transmitted
            - [receiver]: destination location
            - [meta]: node metadata (source span, type info)

            {b Pirouette Syntax:}
            {[
              send Alice 42 -> Bob
            ]}

            {b Ocaml:}
            {[
              let s = Send ("Alice", Int 42, "Bob", m_send)
            ]}*)
    | Sync of
        'a Local.M.loc_id
        * 'a Local.M.sync_label
        * 'a Local.M.loc_id
        * 'a expr
        * 'a
        (** Synchronizing choices: transfers control flow, One location makes a
            choice and synchronizes with another location about which branch to
            take.

            {b Internal AST Structure:} [Sync(chooser, label, peer, cont, meta)]
            - [chooser]: location making the choice
            - [label]: selected branch label
            - [peer]: location to be informed
            - [cont]: continuation expression after synchronization
            - [meta]: metadata for this sync

            {b Pirouette Syntax:}
            {[
              (* General form *)
              select Alice Ready -> Bob; <continuation>

              (* Concrete example *)
              select Alice Ready -> Bob; send Alice 42 -> Bob
            ]}

            The continuation can be any expression (Send, Let, Unit, etc.)

            {b Ocaml:}
            {[
              let alice_ready_bob =
                Sync
                  ( Local.M.LocId ("Alice", ()),
                    (* 1. chooser - Alice makes the choice *)
                    Local.M.Ready (),
                    (* 2. label - "Ready" branch selected *)
                    Local.M.LocId ("Bob", ()),
                    (* 3. peer - Bob is informed *)
                    Send
                      ( Local.M.LocId ("Alice", ()),
                        Unit (),
                        Local.M.LocId ("Bob", ()),
                        () ),
                    () )
              in
              alice_ready_bob
            ]}*)
    | If of 'a expr * 'a expr * 'a expr * 'a
        (** Conditional expression: Standard if-then-else conditional

            {b Internal AST Structure:} [If(cond, then_expr, else_expr, meta)]

            {b Pirouette Syntax:}
            {[
              if cond then e1 else e2
            ]}

            {b Ocaml:}
            {[
              let if_expr =
                If
                  ( Var (Local.M.VarId ("cond", ()), ()),
                    Var (Local.M.VarId ("e1", ()), ()),
                    Var (Local.M.VarId ("e2", ()), ()),
                    () )
              in
              if_expr
            ]}*)
    | Let of 'a stmt_block * 'a expr * 'a
        (** Let binding of a statement block: Introduces local bindings

            {b Internal AST Structure:} [Let(stmt_block, body, meta)]

            {b Pirouette Syntax:}
            {[
              let x = 5 in
              x + 1
            ]}

            {b Ocaml:}
            {[
              let let_expr =
                Let
                  ( [
                      Assign ([ Var (Local.M.VarId ("x", ()), ()) ], Unit (), ());
                    ],
                    Unit (),
                    () )
              in
              let_expr
            ]}*)
    | FunDef of 'a pattern list * 'a expr * 'a
        (** Function definition

            {b Internal AST Structure:} [FunDef(params, body, meta)]

            {b Pirouette Syntax:}
            {[
              fun x y -> x + y
            ]}

            {b Ocaml:}
            {[
              let fun_xy =
                FunDef
                  ( [
                      Var (Local.M.VarId ("x", ()), ());
                      Var (Local.M.VarId ("y", ()), ());
                    ],
                    Unit (),
                    () )
              in
              fun_xy
            ]}*)
    | FunApp of 'a expr * 'a expr * 'a
        (** Function Application

            {b Internal AST Structure:}
            [FunApp(function_expr, argument_expr, meta)]

            {b Pirouette Syntax:}
            {[
              add 3 (*fuction(add)arguement(3)*)
            ]}

            {b Ocaml:}
            {[
              let add_3 =
                FunApp (Var (Local.M.VarId ("add", ()), ()), Unit (), ())
              in
              add_3
            ]}*)
    | Pair of 'a expr * 'a expr * 'a
        (** Pair construction: Creates a pair value containing two expressions.
            {b Internal AST Structure:}[Pair(left_expr, right_expr, meta)]

            {b Pirouette Syntax:}
            {[
              x, y
            ]}

            {b Ocaml:}
            {[
              let pair_xy =
                Pair
                  ( Var (Local.M.VarId ("x", ()), ()),
                    Var (Local.M.VarId ("y", ()), ()),
                    () )
              in
              pair_xy
            ]}*)
    | Fst of 'a expr * 'a
        (** First projection from pair: extracts the first element from a pair
            expression.

            {b Internal AST Structure:} [Fst(pair_expr, meta)]

            {b Pirouette Syntax:}
            {[
              fst p
            ]}

            {b Ocaml:}
            {[
              let p = (5, "hello")
              let x = fst p (* x = 5 *)
            ]} *)
    | Snd of 'a expr * 'a
        (** Second projection from pair: extracts the second element from a pair
            expression.

            {b Internal AST Structure:} [Snd(pair_expr, meta)]

            {b Pirouette Syntax:}
            {[
              snd p
            ]}

            {b Ocaml:}
            {[
              let p = (5, "hello")
              let y = snd p (* y = "hello" *)
            ]} *)
    | Left of 'a expr * 'a
        (** Left injection into sum type: constructs a Left value containing the
            given expression.

            The ['a expr] can be any expression type. The result is a sum type
            value tagged as Left.

            {b Internal AST Structure:}[Left(payload, meta)]
            - [payload]: any expression; the *resulting value* is tagged as
              Left.
            - [meta]: metadata for the Left node.

            {b Pirouette Syntax:}
            {[
              Left 5
            ]}

            {b Ocaml:}
            {[
              Left (Int 5, m)
            ]}*)
    | Right of 'a expr * 'a
        (** Right injection into sum type: constructs a Left value containing
            the given expression.

            The ['a expr] can be any expression type. The result is a sum type
            value tagged as Right.

            {b Internal AST Structure:} [Right(payload, meta)]
            - [payload]: any expression; the resulting value is tagged as Right.
            - [meta]: metadata for the Right node.

            {b Pirouette Syntax:}
            {[
              Right "hello"
            ]}

            {b Ocaml:}
            {[
              Right (String "hello", m)
            ]}*)
    | Match of 'a expr * ('a pattern * 'a expr) list * 'a
        (** Pattern matching expression: matches an expression against a list of
            pattern-case pairs.

            The first ['a expr] is the value to match, the list contains
            pattern-case pairs where each pattern is tried in order until one
            matches, then its corresponding expression is evaluated.

            Requires: At least one pattern must match the value
            (exhaustiveness).

            {b Internal AST Structure:} [Match(expr, cases, meta)]
            - [expr]: expression to inspect
            - [cases]: list of (pattern, expression) pairs
            - [meta]: metadata for the match node

            {b Pirouette Syntax:}
            {[
              match x with Left v -> v + 1 | Right v -> v - 1
            ]}

            {b OCaml:}
            {[
              let match_expr =
                Match
                  ( Var (Local.M.VarId ("x", ()), ()),
                    [
                      (Left (Var (Local.M.VarId ("v", ()), ()), ()), Unit ());
                      (Right (Var (Local.M.VarId ("v", ()), ()), ()), Unit ());
                    ],
                    () )
                (* () is the metadata*)
              in
              match_expr
            ]} *)

  (** {1 Choreographic Statements}

      annotated with metadata of type ['a]. Statements declare variables, types,
      and perform assignments. *)

  and 'a stmt =
    | Decl of 'a pattern * 'a typ * 'a
        (** Type declaration: declares that a pattern has a specific type.

            {b Internal AST Structure:} [Decl(pattern, typ, meta)]

            {b Pirouette Syntax:}
            {[
              x : int
            ]}

            {b Ocaml:}
            {[
              let x_int_decl =
                Decl (Var (Local.M.VarId ("x", ()), ()), TInt (), ())
              in
              x_int_decl
            ]}*)
    | Assign of 'a pattern list * 'a expr * 'a
        (** Assignment: binds patterns to the result of evaluating an
            expression.

            The ['a pattern list] contains patterns to bind, ['a expr] is the
            value to assign, and ['a] is metadata. Multiple patterns allow
            destructuring of tuple results.

            {b Internal AST Structure:} [Assign(patterns, expr, meta)]

            {b Pirouette Syntax:}
            {[
              x := 5 (x, y) := (1, 2)
            ]}

            {b Ocaml:}
            {[
              let x_assign =
                Assign ([ Var (Local.M.VarId ("x", ()), ()) ], Unit (), ())
                (*The Unit (()) is a place holder for 5 in this example, which would need a
              a constructor in the real implementation (e.g. IntLiteral)*)
              in
              x_assign
            ]}*)
    | TypeDecl of 'a Local.M.typ_id * 'a typ * 'a
        (** Type alias declaration: defines a new type name for an existing
            type.

            {b Internal AST Structure:} [TypeDecl(type_id, typ, meta)]

            {b Pirouette Syntax:}
            {[
              type Result = int * int
            ]}

            {b Ocaml:}
            {[
              let result_type_decl =
                TypeDecl
                  ( Local.M.Typ_Id ("Result", ()),
                    (*type id*)
                    TProd (TInt (), TInt (), ()),
                    (*typ*)
                    () )
                (* () is the metadata*)
              in
              result_type_decl
            ]} *)
    | ForeignDecl of 'a Local.M.var_id * 'a typ * string * 'a
        (** Foreign function declaration: declares an external function with its
            type and external name.

            {b Internal AST Structure:}
            [ForeignDecl(var_id, typ, external_name, meta)]

            The ['a Local.M.var_id] is the internal name, ['a typ] is its type,
            [string] is the external name (e.g., from C library), and ['a] is
            metadata.

            {b Pirouette Syntax:}
            {[
              foreign print : string -> unit = "print"
            ]}

            {b OCaml:}
            {[
              let print_foreign =
                ForeignDecl
                  ( Local.M.VarId ("print", ()),
                    TMap (TString (), TUnit (), ()),
                    "print",
                    () )
              in
              print_foreign
            ]}*)

  (** {1 Choreographic Statement Block}

      A block of statements forming a sequence of declarations and assignments.
      Statements in a block are executed in order, with each statement
      potentially introducing bindings visible to subsequent statements. *)

  and 'a stmt_block = 'a stmt list
  (** Block of Statements

      {b Internal AST Structure:} [stmt_block] is a list of ['a stmt]

      {b Pirouette Syntax:}
      {[
        x : int;
        x := 5;
        y : int;
        y := x + 10
      ]}

      {b OCaml:}
      {[
        let stmt_block =
          [
            Decl (Var (VarId ("x", ()), ()), TInt (), ());
            Assign ([ Var (VarId ("x", ()), ()) ], Val (Int (5, ()), ()), ());
            Decl (Var (VarId ("y", ()), ()), TInt (), ());
            Assign ([ Var (VarId ("y", ()), ()) ], Unit (), ());
          ]
        in
        stmt_block
      ]} *)
end

(** {b With:} This module uses a Functor for creating AST types with concrete
    metadata. A functor is a parametrized module that takes one or more modules
    as arguments and returns a new module as a result.

    The polymorphic AST types (['a typ], ['a expr], etc.) allow any metadata
    type ['a]. This functor instantiates those types with a specific metadata
    type [Info.t], making the AST concrete and providing utilities to access and
    modify the metadata annotations.

    {b Functor use:}

    Different compiler passes need different metadata:
    - Parser attaches source locations
    - Type checker attaches type information
    - Code generator attaches target-specific data

    This functor lets each pass work with its own metadata type while reusing
    the same AST structure.

    {b Parameters:} The input module specification - defines what metadata type
    to use.

    {b Signature:} The output module - provides concrete AST types and utility
    functions for the specified metadata type.*)
module With : functor
  (Info : sig
     type t
     (** The concrete metadata type for this instantiation. AST types with
         [Info.t] metadata *)
   end)
  -> sig
  type nonrec typ_id = Info.t M.typ_id
  type nonrec typ = Info.t M.typ
  type nonrec pattern = Info.t M.pattern
  type nonrec expr = Info.t M.expr
  type nonrec stmt = Info.t M.stmt
  type nonrec stmt_block = stmt list

  (** {1 Metadata Accessors}

      Functions to extract metadata from AST nodes. *)

  val get_info_typid : typ_id -> Info.t
  (** [get_info_typid tid] is the metadata annotation from type identifier
      [tid].*)

  val get_info_typ : typ -> Info.t
  (** [get_info_typ t] is the metadata annotation from type [t].*)

  val get_info_pattern : pattern -> Info.t
  (** [get_info_pattern p] is the metadata annotation from pattern [p].*)

  val get_info_expr : expr -> Info.t
  (** [get_info_expr e] is the metadata annotation from expression [e].*)

  val get_info_stmt : stmt -> Info.t
  (** [get_info_stmt s] is the metadata annotation from statement [s].*)

  (** {1 Metadata Modifiers}

      Functions to set metadata at AST nodes *)

  val set_info_typid : Info.t -> typ_id -> typ_id
  (** [set_info_typid info tid] is type identifier [tid] with its metadata
      replaced by [info].*)

  val set_info_typ : Info.t -> typ -> typ
  (** [set_info_typ info t] is type [t] with its metadata replaced by [info].*)

  val set_info_pattern : Info.t -> pattern -> pattern
  (**[set_info_pattern info p] is pattern [p] with its metadata replaced by
     [info].*)

  val set_info_expr : Info.t -> expr -> expr
  (** [set_info_expr info e] is expression [e] with its metadata replaced by
      [info].*)

  val set_info_stmt : Info.t -> stmt -> stmt
  (** [set_info_stmt info s] is statement [s] with its metadata replaced by
      [info].*)
end
