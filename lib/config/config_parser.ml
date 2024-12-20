open Lwt.Infix

type location_config =
  { location : string
  ; http_address : string
  }

type config = { locations : location_config list }

let parse_location_config yaml =
  match yaml with
  | `O [ ("location", `String loc); ("http_address", `String addr) ] ->
    Some { location = loc; http_address = addr }
  | _ -> None
;;

let parse_config yaml =
  match yaml with
  | `O [ ("locations", `A locs) ] ->
    let parsed_locs = List.filter_map parse_location_config locs in
    Some { locations = parsed_locs }
  | _ -> None
;;

let load_config filename =
  Lwt_io.with_file ~mode:Input filename (fun ic ->
    Lwt_io.read ic
    >>= fun contents ->
    let yaml = Yaml.of_string_exn contents in
    Lwt.return (parse_config yaml))
;;

let check_locations config choreo_ast =
  let extracted_locs = Ast_utils.extract_locs choreo_ast in
  let config_locs = List.map (fun loc_config -> loc_config.location) config.locations in
  let undefined_locs =
    List.filter (fun loc -> not (List.mem loc config_locs)) extracted_locs
  in
  if List.length undefined_locs > 0
  then
    Error
      (Printf.sprintf "Undefined locations found: %s" (String.concat ", " undefined_locs))
  else
    Ok
      (List.filter
         (fun loc_config -> List.mem loc_config.location extracted_locs)
         config.locations)
;;
