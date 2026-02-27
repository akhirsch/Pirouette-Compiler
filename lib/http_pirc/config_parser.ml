open Lwt.Infix
(** Configuration parsing for Pirouette choreographies.

    This module handles parsing of YAML configuration files that map
    choreographic locations to concrete HTTP addresses. *)

type location_config = {
  location : string;
      (** The location identifier as it appears in the choreography. *)
  http_address : string;
      (** The http_address is the address where this location will run. *)
}

type config = {
  locations : location_config list;  (** List of all location configurations. *)
}
(** Complete configuration for all locations in a choreography. *)

(** [parse_location_config] accepts a [yaml] value, and returns [config] if
    [yaml] represents a valid location configuration with both "location" and
    "http_address" fields, and [None] if [yaml] is malformed or missing required
    fields.

    Requires: [yaml] is a valid YAML value.

    Example valid YAML structure:
    {[
      location: "alice"
      http_address: "localhost:8001"
    ]} *)
let parse_location_config yaml =
  match yaml with
  | `O [ ("location", `String loc); ("http_address", `String addr) ] ->
      Some { location = loc; http_address = addr }
  | _ -> None

(** [parse_config] accepts [yaml] value, returning [config] - a record
    containing all successfully parsed locations - if [yaml] has a locations
    array, and [None] if the [yaml] value is malformed or missing the locations
    field.

    Requires: [yaml] is a valid YAML value.

    Example valid YAML structure:
    {[
      locations:
        - location: "alice"
          http_address: "localhost:8001"
        - location: "bob"
          http_address: "localhost:8002"
    ]} *)

let parse_config yaml =
  match yaml with
  | `O [ ("locations", `A locs) (* locs is a list of YAML entries*) ] ->
      let parsed_locs = List.filter_map parse_location_config locs in
      Some { locations = parsed_locs }
  | _ -> None

(** [load_config] accepts a [filename], returning [config] if the configuration
    file at [filename] can be successfully loaded and parsed, and [None] if the
    file does not exist or cannot be parsed.

    Requires: [filename] is a valid file path pointing to a YAML file.*)
let load_config filename =
  Lwt_io.with_file ~mode:Input filename (fun ic ->
      Lwt_io.read ic >>= fun contents ->
      let yaml = Yaml.of_string_exn contents in
      Lwt.return (parse_config yaml))

(** [check_locations] accepts a [config choreo_ast] value, and returns
    [Ok locations] containing only the locations from [config] that are used in
    [choreo_ast] if all locations in [choreo_ast] have corresponding entries in
    [config]. Returns [Error msg] listing the undefined locations otherwise.

    Requires: [choreo_ast] is a valid choreography AST. *)
let check_locations config choreo_ast =
  let extracted_locs = Ast_utils.extract_locs choreo_ast in
  let config_locs =
    List.map (fun loc_config -> loc_config.location) config.locations
  in
  let undefined_locs =
    List.filter (fun loc -> not (List.mem loc config_locs)) extracted_locs
  in
  if List.length undefined_locs > 0 then
    Error
      (Printf.sprintf "Undefined locations found: %s"
         (String.concat ", " undefined_locs))
  else
    Ok
      (List.filter
         (fun loc_config -> List.mem loc_config.location extracted_locs)
         config.locations)
