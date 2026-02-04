(** Location set operations and AST location extraction utilities.

    This module provides utilities for managing sets of location identifiers and
    extracting location information from AST nodes. Location sets are used
    throughout the compiler to track which endpoints participate in
    choreographic operations.

    {2 Use Cases}

    Location sets are essential for:
    - Endpoint projection: Determining which locations to project for
    - Type checking: Verifying location consistency
    - Code generation: Knowing which executables to generate
    - Analysis: Understanding protocol participants *)

(** {1 Location Sets} *)

module LocSet : sig
  (** Set of location identifiers.

      A [LocSet.t] represents a collection of unique endpoint names (locations)
      in a choreography. Functions are categorized as:
      - {b Construction}: Creating and building sets
      - {b Queries}: Testing properties and getting information
      - {b Set Operations}: Combining and modifying sets
      - {b Comparison}: Comparing sets
      - {b Iteration}: Processing set elements
      - {b Selection}: Choosing specific elements
      - {b Search}: Finding elements
      - {b Sequences}: Converting to/from sequences

      {b Common operations:}
      - [empty]: Create empty set
      - [singleton "Alice"]: Single-location set
      - [add "Bob" s]: Add location to set
      - [union s1 s2]: Combine two location sets
      - [elements s]: Convert to list for iteration *)

  type elt = string
  (** Element type: locatuon names as strings (e.g. "Alice", "Bob", "Server")*)

  type t = Set.Make(String).t
  (** The type of location sets. *)

  val empty : t
  (** [empty] is the empty location set.

      {b Category:} Construction

      {b Example:}
      {[
        let s = LocSet.empty
        (* s = {} *)
      ]} *)

  val is_empty : t -> bool
  (** [is_empty] returns [true] if [s] contains no locations.

      {b Category:} Queries

      {b Example:}
      {[
        LocSet.is_empty LocSet.empty = true
        LocSet.is_empty (LocSet.singleton "Alice") = false
      ]} *)

  val mem : elt -> t -> bool
  (** [mem] returns [true] if [loc] is in [s].

      {b Category:} Queries

      {b Example:}
      {[
        let s = LocSet.of_list ["Alice"; "Bob"] in
        LocSet.mem "Alice" s = true
        LocSet.mem "Carol" s = false
      ]} *)

  val add : elt -> t -> t
  (** [add] returns a set containing all elements of [s] plus [loc].

      {b Category:} Construction

      {b Example:}
      {[
        let s = LocSet.empty in
        let s = LocSet.add "Alice" s in
        let s = LocSet.add "Bob" s in
        (* s = {"Alice", "Bob"} *)
      ]} *)

  val singleton : elt -> t
  (** [singleton] creates a set containing only [loc], part of Constructing
      location sets.

      {b Category:} Construction

      {b Example:}
      {[
        let s = LocSet.singleton "Alice"
        (* s = {"Alice"} *)
      ]} *)

  val remove : elt -> t -> t
  (** [remove] returns a set containing all elements of [s] except [loc].

      {b Category:} Set Operations *)

  val union : t -> t -> t
  (** [union] returns the union of [s1] and [s2].

      {b Category:} Set Operations

      {b Example:}
      {[
        let s1 = LocSet.of_list ["Alice"; "Bob"] in
        let s2 = LocSet.of_list ["Bob"; "Carol"] in
        LocSet.union s1 s2 = {"Alice", "Bob", "Carol"}
      ]} *)

  val inter : t -> t -> t
  (** [inter s1 s2] returns the intersection of [s1] and [s2].

      {b Category:} Set Operations

      {b Example:}
      {[
        let s1 = LocSet.of_list ["Alice"; "Bob"] in
        let s2 = LocSet.of_list ["Bob"; "Carol"] in
        LocSet.inter s1 s2 = {"Bob"}
      ]} *)

  val disjoint : t -> t -> bool
  (** [disjoint] returns [true] if [s1] and [s2] have no common elements.

      {b Category:} Queries *)

  val diff : t -> t -> t
  (** [diff] returns the set difference [s1 \ s2].

      {b Category:} Set Operations

      {b Example:}
      {[
        let s1 = LocSet.of_list ["Alice"; "Bob"; "Carol"] in
        let s2 = LocSet.of_list ["Bob"] in
        LocSet.diff s1 s2 = {"Alice", "Carol"}
      ]} *)

  val compare : t -> t -> int
  (** [compare] returns a total ordering on sets.

      {b Category:} Comparison *)

  val equal : t -> t -> bool
  (** [equal] returns [true] if [s1] and [s2] contain the same locations.

      {b Category:} Comparison *)

  val subset : t -> t -> bool
  (** [subset] returns [true] if [s1] is a subset of [s2].

      {b Category:} Comparison *)

  val iter : (elt -> unit) -> t -> unit
  (** [iter f s] applies [f] to each location in [s] in ascending order.

      {b Category:} Iteration

      {b Example:}
      {[
        let s = LocSet.of_list [ "Alice"; "Bob" ] in
        LocSet.iter (fun loc -> Printf.printf "Location: %s\n" loc) s
        (* Prints:
            Location: Alice
            Location: Bob *)
      ]} *)

  val map : (elt -> elt) -> t -> t
  (** [map f s] returns the set of locations [f loc] for each [loc] in [s].

      {b Category:} Iteration *)

  val fold : (elt -> 'a -> 'a) -> t -> 'a -> 'a
  (** [fold] computes [(f locN ... (f loc2 (f loc1 init))...)].

      {b Category:} Iteration

      {b Example:}
      {[
        let s = LocSet.of_list [ "Alice"; "Bob"; "Carol" ] in
        LocSet.fold (fun loc acc -> loc :: acc) s []
        (* Returns: ["Carol"; "Bob"; "Alice"] (reverse order) *)
      ]} *)

  val for_all : (elt -> bool) -> t -> bool
  (** [for_all] returns [true] if [p loc] is true for all [loc] in [s].

      {b Category:} Queries *)

  val exists : (elt -> bool) -> t -> bool
  (** [exists] returns [true] if [p loc] is true for at least one [loc] in [s].

      {b Category:} Queries *)

  val filter : (elt -> bool) -> t -> t
  (** [filter] returns the set of locations in [s] satisfying predicate [p].

      {b Category:} Set Operations *)

  val filter_map : (elt -> elt option) -> t -> t
  (** [filter_map] applies [f] to each location and keeps only [Some] results.

      {b Category:} Iteration *)

  val partition : (elt -> bool) -> t -> t * t
  (** [partition] returns a pair [(s1, s2)] where [s1] contains locations
      satisfying [p] and [s2] contains the rest.

      {b Category:} Set Operations *)

  val cardinal : t -> int
  (** [cardinal] returns the number of locations in [s].

      {b Category:} Queries

      {b Example:}
      {[
        let s = LocSet.of_list [ "Alice"; "Bob"; "Carol" ] in
        LocSet.cardinal s = 3
      ]} *)

  val elements : t -> elt list
  (** [elements] returns the list of locations in [s] in ascending order.

      {b Category:} Queries

      {b Example:}
      {[
        let s = LocSet.of_list [ "Carol"; "Alice"; "Bob" ] in
        LocSet.elements s = [ "Alice"; "Bob"; "Carol" ]
      ]} *)

  val min_elt : t -> elt
  (** [min_elt s] returns the smallest location in [s].

      {b Category:} Selection

      {b Raises:} [Not_found] if [s] is empty. *)

  val min_elt_opt : t -> elt option
  (** [min_elt_opt s] returns [Some loc] where [loc] is the smallest location,
      or [None] if [s] is empty.

      {b Category:} Selection *)

  val max_elt : t -> elt
  (** [max_elt] returns the largest location in [s].

      {b Category:} Selection

      {b Raises:} [Not_found] if [s] is empty. *)

  val max_elt_opt : t -> elt option
  (** [max_elt_opt s] returns [Some loc] where [loc] is the largest location, or
      [None] if [s] is empty.

      {b Category:} Selection *)

  val choose : t -> elt
  (** [choose] returns an arbitrary location from [s].

      {b Category:} Selection

      {b Raises:} [Not_found] if [s] is empty. *)

  val choose_opt : t -> elt option
  (** [choose_opt] returns [Some loc] for an arbitrary location, or [None] if
      [s] is empty.

      {b Category:} Selection *)

  val split : elt -> t -> t * bool * t
  (** [split] returns [(l, present, r)] where [l] contains locations less than
      [loc], [present] is true if [loc] was in [s], and [r] contains locations
      greater than [loc].

      {b Category:} Set Operations *)

  val find : elt -> t -> elt
  (** [find] returns [loc] if it is in [s].

      {b Category:} Search

      {b Raises:} [Not_found] if [loc] is not in [s]. *)

  val find_opt : elt -> t -> elt option
  (** [find_opt] returns [Some loc] if [loc] is in [s], [None] otherwise.

      {b Category:} Search *)

  val find_first : (elt -> bool) -> t -> elt
  (** [find_first] returns the smallest location satisfying predicate [p].

      {b Category:} Search

      {b Raises:} [Not_found] if no location satisfies [p]. *)

  val find_first_opt : (elt -> bool) -> t -> elt option
  (** [find_first_opt] returns [Some loc] for the smallest location satisfying
      [p], or [None] if none exists.

      {b Category:} Search *)

  val find_last : (elt -> bool) -> t -> elt
  (** [find_last] returns the largest location satisfying predicate [p].

      {b Category:} Search

      {b Raises:} [Not_found] if no location satisfies [p]. *)

  val find_last_opt : (elt -> bool) -> t -> elt option
  (** [find_last_opt] returns [Some loc] for the largest location satisfying
      [p], or [None] if none exists.

      {b Category:} Search *)

  val of_list : elt list -> t
  (** [of_list] creates a set from a list of locations.

      {b Category:} Construction

      {b Example:}
      {[
        let s = LocSet.of_list [ "Alice"; "Bob"; "Carol" ]
        (* s = {"Alice", "Bob", "Carol"} *)
      ]} *)

  val to_seq_from : elt -> t -> elt Seq.t
  (** [to_seq_from loc s] returns a sequence of locations >= [loc] in ascending
      order.

      {b Category:} Sequences *)

  val to_seq : t -> elt Seq.t
  (** [to_seq] returns a sequence of locations in ascending order.

      {b Category:} Sequences *)

  val to_rev_seq : t -> elt Seq.t
  (** [to_rev_seq] returns a sequence of locations in descending order.

      {b Category:} Sequences *)

  val add_seq : elt Seq.t -> t -> t
  (** [add_seq] adds all locations from [seq] to [s].

      {b Category:} Construction *)

  val of_seq : elt Seq.t -> t
  (** [of_seq] creates a set from a sequence of locations.

      {b Category:} Construction *)
end

val extract_stmt_block : 'a Ast_core.Choreo.M.stmt_block -> LocSet.t
(** [extract_stmt_block stmts] extracts all location identifiers mentioned in a
    choreographic statement block.

    Traverses the entire AST and collects every location identifier that appears
    in:
    - Type annotations ([Alice.int])
    - Location-qualified expressions ([[Alice] expr])
    - Patterns ([Alice.x])
    - Send operations ([send Alice x -> Bob])
    - Synchronization operations ([Alice[label] ~> Bob])

    {b Use cases:}
    - Determining which endpoint executables need to be generated
    - Endpoint projection (knowing which locations to project for)
    - Protocol analysis (understanding all participants)
    - Validation (ensuring all referenced locations are defined)

    {b Returns:} A set containing all unique location identifiers found in the
    choreography, ordered alphabetically.

    {b Note:} This function only extracts location identifiers that appear
    syntactically in the AST. It does not perform semantic analysis or
    validation - use type checking for that.*)
