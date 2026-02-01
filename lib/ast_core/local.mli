(** {b Local:} Local endpoint abstract syntax tree (AST) definitions. This module defines the AST structures for local programs executed at a 
    single endpoint. Unlike choreographic ASTs which describe global protocols 
    across multiple locations, local ASTs represent pure computation at one 
    location with no distribution or communication primitives.*)

(**{b M:} This module defines the local IR used within a single endpoint/location.
    Unlike the choreography AST, no location qualifiers appear here - all values 
    are local by construction. This represents what a single participant executes
    after endpoint projection.
    
    All AST nodes are parameterized by metadata type ['a] for compiler passes
    to attach annotations. *)
module M : sig
  (** {1 Local Values} 
  
  ['a value] represent literal values (integers, strings, booleans) in local 
    computation. These are the concrete data values that exist at a single endpoint.
    Each value carries metadata of type ['a] for source location tracking and 
    type information. *)

  type 'a value =
    | Int of int * 'a
    (** Integer literal
          
      {b Internal AST Structure:} [Int(n, metadata)]
          
      {b Pirouette Syntax:}
      {[
        42
      ]}
          
      {b OCaml:}
      {[
        let int_42 =                
          Int(42, ())
        in
        int_42]} *)
    | String of string * 'a
    (** String literal
    
      {b Internal AST Structure:} [String(s, metadata)]
      
      {b Pirouette Syntax:}
      {[
        "hello"
      ]}
        
      {b Ocaml:}
      {[
        let str_hello = 
          String("hello", ())
        in 
        str_hello ]}*)
    | Bool of bool * 'a
    (** Boolean literal
    
      {b Internal AST Structure:} [Bool(b, metadata)]
      
      {b Pirouette Syntax:}
      {[
        true
      ]}
        
      {b Ocaml:}
      {[
        let bool_true = 
          Bool(true, ())
        in
        bool_true]}*)

  (** {1 Local Identifiers} 
    
    Internal representations of names. In Pirouette source code, these appear
    as simple names; the parser constructs these AST nodes. *)

  type 'a loc_id =
    | LocId of string * 'a
    (** Location Identifier: location name with metadata.
        
      {b Internal AST Structure:} [LocId(name, metadata)]
        
      {b Pirouette:}
        {[
          Alice   (* location name *)
          Bob     (* location name *)
          Server  (* location name *)
        ]}
      
      {b OCaml:}
        {[
          let alice = 
            LocId("Alice", ()) (* () is the metadata*)
          in
          alice
        ]}
       *)

  type 'a var_id =
    | VarId of string * 'a
    (** Variable Identifier: variable name with metadata.
        
      {b Internal AST Structure:} [VarId(name, metadata)]
        
      {b Pirouette:}
        {[
          x       (* variable name*)
          result  (*variable name*)
          count   (* variable name*)
          ]}
      
      Ocaml:
        {[
          let var_x = 
            VarId("x", ()) (* () is the metadata *)
          in
          var_x]}*)

  type 'a typ_id =
    | TypId of string * 'a
    (** Type Identifier: type name with metadata.
      
      {b Internal AST Structure:} [TypID(name, metadata)]
      
      {b Pirouette:}
        {[
          Result  (* type name *)
          Person  (* type name *)
          ]}

      {b Ocaml:}
        {[
          let person_name = 
            TypeId("Person", ()) (* () is the metadata *)
          in
          person_name]}*)

  type 'a sync_label =
    | LabelId of string * 'a
    (** Synchronization Label (for choices): label name with metadata.
        
      {b Internal AST Structure:} [LabelId(name, metadata)]
      
      {b Pirouette:}
        {[
          Ready (* sync label *)
          Yes   (* sync label *)
          No    (* sync label *)
          ]}
      
      {b Ocaml:}
        {[
          let ready_label =
            LabelId("Ready", ()) (* () is the metadata *)
          in
          ready_label]}*)

  (** {1 Local Operators} Operators for local computation at a single endpoint. These represent primitive
    operations on local values.*)

  (** {b Unary Operators:} operate on one operand
    
    ['a un_op] represent unary operations (logical negation, arithmetic negation) 
    performed on a single value. Each operator carries metadata of type ['a]. *)

  type 'a un_op =
    | Not of 'a
    (**Logical negation
    
    {b Internal AST Structure:} [Not(metadata)]

      {b Pirouette Syntax:} 
        {[
          not x
        ]}

      {b Ocaml:}
        {[
          let not_op = 
            Not(())
          in
          not_op]}*)
    | Neg of 'a
    (** Arethmetic negation
    
    {b Internal AST Structure:} [Neg(metadata)]

      {b Pirouette Syntax:} 
        {[
          -x
        ]}
          
      {b Ocaml:}
        {[
          let neg_op = 
            Neg(())
          in
          neg_op]}*)

  (** {b Binary Operators:} operate on two operands
    
    ['a bin_op] represent binary operations (arithmetic, logical, comparison) 
    performed on two values. Each operator carries metadata of type ['a]. *)

  type 'a bin_op =
    | Plus of 'a (** Addition: [x + y] *)
    | Minus of 'a (** Subtraction: [x - y] *)
    | Times of 'a (** Multiplication: [x * y] *)
    | Div of 'a (** Division: [x / y] *)
    | And of 'a (** Logical AND: [x && y] *)
    | Or of 'a (** Logical OR: [x || y] *)
    | Eq of 'a (** Equality: [x = y] *)
    | Neq of 'a (** Inequality: [x <> y] *)
    | Lt of 'a (** Less than: [x < y] *)
    | Leq of 'a (** Less than or equal: [x <= y] *)
    | Gt of 'a (** Greater than: [x > y] *)
    | Geq of 'a (** Greater than or equal: [x >= y] *)

  (** {1 Local Types} 
  
  ['a typ] represent the types of values in local computation at a single endpoint.
    Unlike choreographic types, local types do not include location qualifiers - all 
    values are local by construction. Each node carries metadata of type ['a], allowing 
    compiler passes to attach annotations such as source locations or type information. *)

  type 'a typ =
    | TUnit of 'a
    (** Unit type
    
      {b Internal AST Structure:} [TUnit(metadata)]

      {b Pirouette Syntax:}
        {[
          unit
        ]}
          
      {b Ocaml}
        {[
          let unit_type = 
            TUnit(())
          in 
          unit_type]}*)
    | TInt of 'a
    (** Integer type
    
      {b Internal AST Structure:} [TInt(metadata)]

      {b Pirouette Syntax:}
        {[
          int
        ]}
          
      {b Ocaml:}
        {[
          let int_type = 
            TInt(())  
          in
          int_type]}*)
    | TString of 'a
    (** String type
    
      {b Internal AST Structure:} [TString(metadata)]

      {b Pirouette Syntax:}
        {[
          string
        ]}
          
      {b Ocaml:}
        {[
          let string_type = 
            TString(())
          in
          string_type]}*)
    | TBool of 'a
    (** Boolean type
    
      {b Internal AST Structure:} [TBool(metadata)]

      {b Pirouette Syntax:}
        {[
          bool
        ]}
          
      {b Ocaml:}
        {[
          let bool_type = 
            TBool (())
          in
          bool_type]}*)
    | TVar of 'a typ_id * 'a
    (** Type variable
    
      {b Internal AST Structure:} [TVar(typ_id, metadata)]

      {b Pirouette Syntax:}
        {[
          'a
        ]}
          
      {b Ocaml:}
        {[
          let type_var = 
            TVar(TypId("a", ()), ())
          in 
          type_var]}*)
    | TProd of 'a typ * 'a typ * 'a
    (** Product type: pairs
    
      {b Internal AST Structure:} [TProd(left_type, right_type, metadata)]

      {b Pirouette Syntax:}
        {[
         int * string 
        ]}
          
      {b Ocaml:}
        {[
          let prod_int_string = 
            TProd(TInt(()), TString(()), ())
          (*TProd of int type * string type * () metadata*)
          in
          prod_int_string]}*)
    | TSum of 'a typ * 'a typ * 'a
    (** Sum type: tagged unions 
    
      {b Internal AST Structure:} [TSum(left_type, right_type, metadata)]

      {b Pirouette Syntax:}
        {[
          int + string 
        ]}
          
      {b Ocaml: }
        {[
          let sum_int_string = 
            TSum(TInt(()), TString(()), ())
          in
          sum_int_string]}*)

  (** {1 Local Patterns} 

  ['a pattern] represent patterns for matching and destructuring values in 
    local computation. These patterns bind variables, match literals, and 
    destructure compound data at a single endpoint. Each pattern carries 
    metadata of type ['a] for source location tracking and type information.*)

  type 'a pattern =
    | Default of 'a
    (** Default (wildcard) pattern
    
      {b Internal AST Structure:} [Default(metadata)]

      {b Pirouette Syntax:}
        {[
          _
        ]}
        
      {b Ocaml:}
        {[
          let wildcard =
            Default(())
          in
          wildcard]}*)
    | Val of 'a value * 'a
    (** Value pattern: matches specific literal
    
      {b Internal AST Structure:} [Val(value, metadata)]

      {b Pirouette Syntax:}
        {[
          78
          "hello world!"
          true
        ]}
        
      {b Ocaml:}
        {[  
          let val_pattern = 
            Val(Int(78, ()), ()) (* () is metadata*)
          in
          val_pattern]}*)
    | Var of 'a var_id * 'a
    (** Variable binding

      {b Internal AST Structure:} [Var(var_id, metadata)]

      {b Pirouette Syntax:}
        {[
          x
        ]}
        
      {b Ocaml:}
        {[  
          let var_x = 
            Var(VarId("x", ()), ()) (* () is metadata*)
          in
          var_x]}*)
    | Pair of 'a pattern * 'a pattern * 'a
    (** Pair Pattern
    
    {b Internal AST Structure:} [Pair(left_pattern, right_pattern, metadata)]

    {b Pirouette Syntax:}
        {[
          (x,y)
        ]}
        
      {b Ocaml:}
        {[  
          let pair_xy = 
            Pair(Var(VarId("x", ()), ()),
                  Var(VarId("y", ()), ()),
                  ()) (* () is metadata *)
          in
          pair_xy]}*)
    | Left of 'a pattern * 'a
    (** Left Sum Pattern
    
    {b Internal AST Structure:} [Left(pattern, metadata)]

    {b Pirouette Syntax:}
        {[
          Left x 
        ]}
        
      {b Ocaml:}
        {[  
          let left_x = 
            Left(Var(VarId("x", ()), ()), ())
            (*() metadata here for each Left/Var/VarId*)
          in
          left_x]}*)
    | Right of 'a pattern * 'a
    (** Right Sum Pattern
    
    {b Internal AST Structure:} [Right(pattern, metadata)]

   {b Pirouette Syntax:}
        {[
          Right y
        ]}
        
      {b Ocaml:}
        {[  
          let right_y = 
            Right(Var(VarId("y", ()), ()), ())
            (*() metadata here for each Right/Var/VarId *)
          in
          right_y]}*)

  (** {1 Local Expressions}
  
  ['a expr] represent pure computations at a single endpoint with no 
    communication or distribution. Local expressions include values, variables, 
    operators, conditionals, and pattern matching - all executed locally. Each 
    expression carries metadata of type ['a] for source location tracking and 
    type information.*)

  type 'a expr =
    | Unit of 'a
    (** Unit Value
    
    {b Internal AST Structure:} [Unit(metadata)]

    {b Pirouette Syntax:}
        {[
          ()
        ]}
        
      {b Ocaml:}
        {[  
          let unit_expr = 
            Unit(())
          in
          unit_expr]}*)
    | Val of 'a value * 'a
    (** Literal Value
    
    {b Internal AST Structure:} [Val(value, metadata)]

    {b Pirouette Syntax:}
        {[
          44
          "hello"
          true 
        ]}
        
      {b Ocaml:}
        {[  
          let val_44 =
            Val(Int(44, ()), ())
          in
          val_44]}*)
    | Var of 'a var_id * 'a
    (** Variable Reference
    
    {b Internal AST Structure:} [Var(var_id, metadata)]

    {b Pirouette Syntax:}
        {[
          x
        ]}
        
      {b Ocaml:}
        {[  
          let var_x = 
            Var(VarId("x", ()), ()) (* () is metadata *)
          in
          var_x]}*)
    | UnOp of 'a un_op * 'a expr * 'a
    (** Unary Operation 
    
    {b Internal AST Structure:} [UnOp(operator, expr, metadata)]

    {b Pirouette Syntax:}
        {[
          not x 
          -y
        ]}
        
      {b Ocaml:}
        {[  
          let not_x = 
            UnOp(Not(()), Var(VarId("x", ()), ()), ())
            (* () meta data for each UnOp/Not/Var/VarId*)
          in
          not_x]}*)
    | BinOp of 'a expr * 'a bin_op * 'a expr * 'a
    (** Binary Operation 
    
    {b Internal AST Structure:} [BinOp(left_expr, operator, right_expr, metadata)]

    {b Pirouette Syntax:}
        {[
          x + y
          a && b
        ]}
        
      {b Ocaml:}
        {[  
          let x_plus_y = 
            BinOp(Var(VarId("x", ()), ()), (* variable x *)
                  Plus(()),   (* the operand plus *)
                  Var(VarId("y", ()), ()), (* variable y*)
                  ()) (* () metadata *)
          in
          x_plus_y]}*)
    | Let of 'a var_id * 'a typ * 'a expr * 'a expr * 'a
    (** Let Binding 
    
    {b Internal AST Structure:} [Let(var_id, typ, bind_expr, body_expr, metadata)]

    {b Pirouette Syntax:}
        {[
          let x : int = 5 in x + 1 
        ]}
        
      {b Ocaml:}
        {[  
          let let_expr = 
            Let(VarId("x", ()),
            Tint(()),
            Val(Int(5, ()), ()),
            Unit(()),
            ())
          in
          let_expr ]}*)
    | Pair of 'a expr * 'a expr * 'a
    (** Pair Construction
    
    {b Internal AST Structure:} [Pair(left_expr, right_expr, metadata)]

    {b Pirouette Syntax:}
        {[
          (x,y)
        ]}
        
      {b Ocaml:}
        {[  
          let pair_xy = 
            Pair(Var(VarId("x", ()), ()),
                  Var(VarId("y", ()), ()),
                  ())
          in
          pair_xy]}*)
    | Fst of 'a expr * 'a
    (** First Projection
    
    {b Internal AST Structure:} [Fst(pair_expr, metadata)]

    {b Pirouette Syntax:}
        {[
          fst p
        ]}
        
      {b Ocaml:}
        {[  
          let first = 
            Fst(Var(VarId("p", ()), ()), ())
          (* () metadata for each Fst/Var/VarId *)
          in
          first]}*)
    | Snd of 'a expr * 'a
    (** Second Projection
    
    {b Internal AST Structure:} [Snd(pair_exp, metadata)]

    {b Pirouette Syntax:}
        {[
          snd p
        ]}
        
      {b Ocaml:}
        {[  
          let second = 
            Snd(Var(VarId("p", ()), ()), ())
          (* () metadata for each Snd/Var/VarId *)
          in
          second]}*)
    | Left of 'a expr * 'a
    (** Left Injection
    
    {b Internal AST Structure:} [Left(expr, metadata)]

    {b Pirouette Syntax:}
        {[
          Left x 
        ]}
        
      {b Ocaml:}
        {[  
          let left_x = 
            Left(Var(VarId("x", ()), ()), ())
          (* () metadata for each Left/Var/VarId*)
          in
          left_X]}*)
    | Right of 'a expr * 'a
    (** Right Injection
    
    {b Internal AST Structure:} [Right(expr, metadata)]

    {b Pirouette Syntax:}
        {[
          Right z
        ]}
        
      {b Ocaml:}
        {[  
          let right_z = 
            Right(Var(VarId("z", ()), ()), ())
            (* () metadata for each Right/Var/VarId*)
          in
          right_z]}*)
    | Match of 'a expr * ('a pattern * 'a expr) list * 'a
    (** Pattern Matching
    
    {b Internal AST Structure:} [Match(expr, cases, metadata)]

    {b Pirouette Syntax:}
        {[
          match x with 
          | 0 -> "zero"
          | n -> "non-zero"
        ]}
        
      {b Ocaml:}
        {[  
          let match_expr = 
            Match(Var(VarId("x", ()), ())
            [(Val(Int(0, ()), ()),
              Val(String("zero", ()), ()));
              (Var(VarId("n", ()), ()),
              Val(String("non-zero", ()), ()))],
              ())
          in
          match_expr
        ]}*)
end

(** {b With:} Module that uses a Functor for creating local AST types with concrete metadata.
    
    Similar to the choreography AST functor, this instantiates the polymorphic
    local AST with a specific metadata type. *)
module With : functor
    (Info : sig
       (** The concrete metadata type *)
       type t
     end)
    -> sig
  (** {1 Type Aliases}*)

  type nonrec value = Info.t M.value
  type nonrec loc_id = Info.t M.loc_id
  type nonrec var_id = Info.t M.var_id
  type nonrec typ_id = Info.t M.typ_id
  type nonrec sync_label = Info.t M.sync_label
  type nonrec un_op = Info.t M.un_op
  type nonrec bin_op = Info.t M.bin_op
  type nonrec typ = Info.t M.typ
  type nonrec pattern = Info.t M.pattern
  type nonrec expr = Info.t M.expr

  (** {1 Metadata Accessors} Functions to extract metadata from AST nodes. *)

  (** [get_info_value v] is the metadata from value [v]. *)
  val get_info_value : value -> Info.t

  (** [get_info_locid loc] is the metadata from location identifier [loc]. *)
  val get_info_locid : loc_id -> Info.t

  (** [get_info_varid var] is the metadata from variable identifier [var]. *)
  val get_info_varid : var_id -> Info.t

  (** [get_info_typid tid] is the metadata from type identifier [tid]. *)
  val get_info_typid : typ_id -> Info.t

  (** [get_info_unop op] is the metadata from unary operator [op]. *)
  val get_info_unop : un_op -> Info.t

  (** [get_info_binop op] is the metadata from binary operator [op]. *)
  val get_info_binop : bin_op -> Info.t

  (** [get_info_typ t] is the metadata from type [t]. *)
  val get_info_typ : typ -> Info.t

  (** [get_info_pattern p] is the metadata from pattern [p]. *)
  val get_info_pattern : pattern -> Info.t

  (** [get_info_expr e] is the metadata from expression [e]. *)
  val get_info_expr : expr -> Info.t

  (** {1 Metadata Modifiers} Functions to set metadata at AST nodes *)

  (** [set_info_value info v] is value [v] with metadata replaced by [info]. *)
  val set_info_value : Info.t -> value -> value

  (** [set_info_locid info loc] is location identifier [loc] with metadata replaced by [info]. *)
  val set_info_locid : Info.t -> loc_id -> loc_id

  (** [set_info_varid info var] is variable identifier [var] with metadata replaced by [info]. *)
  val set_info_varid : Info.t -> var_id -> var_id

  (** [set_info_typid info tid] is type identifier [tid] with metadata replaced by [info]. *)
  val set_info_typid : Info.t -> typ_id -> typ_id

  (** [set_info_unop info op] is unary operator [op] with metadata replaced by [info]. *)
  val set_info_unop : Info.t -> un_op -> un_op

  (** [set_info_binop info op] is binary operator [op] with metadata replaced by [info]. *)
  val set_info_binop : Info.t -> bin_op -> bin_op

  (** [set_info_typ info t] is type [t] with metadata replaced by [info]. *)
  val set_info_typ : Info.t -> typ -> typ

  (** [set_info_pattern info p] is pattern [p] with metadata replaced by [info]. *)
  val set_info_pattern : Info.t -> pattern -> pattern

  (** [set_info_expr info e] is expression [e] with metadata replaced by [info]. *)
  val set_info_expr : Info.t -> expr -> expr
end
