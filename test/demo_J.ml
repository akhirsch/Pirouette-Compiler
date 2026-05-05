open Http_pirc

[@@@ocaml.warning "-39"]
let () =
  let config_file_path : string = "test/demo.yaml" in
  match Lwt_main.run (Config_parser.load_config config_file_path) with
  | Some cfg -> (Send_receive.config := (Some cfg); ())
  | None ->
      failwith
        (Printf.sprintf "Failed to load config from %s" config_file_path)
let () =
  Printf.printf "Starting process_%s...\n" "J";
  Send_receive.init_http_server "J" ();
  (let process_J =
     let rec print_idle_PIROUETTE_ID arg = Display.print_idle arg in
     let rec print_waiting_PIROUETTE_ID arg = Display.print_waiting arg in
     let rec print_sending_PIROUETTE_ID arg = Display.print_sending arg in
     let rec print_done_PIROUETTE_ID arg = Display.print_done arg in
     let rec clear_console_PIROUETTE_ID arg = Display.clear_console arg in
     let rec sleep_PIROUETTE_ID arg = Unix.sleep arg in
     let rec print_string_PIROUETTE_ID arg = print_string arg in
     let rec print_endline_PIROUETTE_ID arg = print_endline arg in
     let rec print_int_PIROUETTE_ID arg = print_int arg in
     let rec print_newline_PIROUETTE_ID arg = print_newline arg in
     let rec prerr_string_PIROUETTE_ID arg = prerr_string arg in
     let rec prerr_endline_PIROUETTE_ID arg = prerr_endline arg in
     let rec prerr_int_PIROUETTE_ID arg = prerr_int arg in
     let rec prerr_newline_PIROUETTE_ID arg = prerr_newline arg in
     let rec string_cat_PIROUETTE_ID arg = String.cat arg in
     let rec cat_PIROUETTE_ID arg = String.cat arg in
     let rec string_of_int_PIROUETTE_ID arg = string_of_int arg in
     let rec string_of_bool_PIROUETTE_ID arg = string_of_bool arg in
     let rec length_PIROUETTE_ID arg = String.length arg in
     let rec filenm_get_current_dir_name_PIROUETTE_ID arg =
       (fun () -> (Filename.current_dir_name)) arg in
     let rec filenm_get_parent_dir_name_PIROUETTE_ID arg =
       (fun () -> (Filename.parent_dir_name)) arg in
     let rec filenm_get_dir_sep_PIROUETTE_ID arg =
       (fun () -> (Filename.dir_sep)) arg in
     let rec filenm_concat_path_PIROUETTE_ID arg = Filename.concat arg in
     let rec filenm_is_relative_filepath_PIROUETTE_ID arg =
       Filename.is_relative arg in
     let rec filenm_is_implicit_filepath_PIROUETTE_ID arg =
       Filename.is_implicit arg in
     let rec filenm_check_suffix_PIROUETTE_ID arg = Filename.check_suffix arg in
     let rec filenm_chop_suffix_PIROUETTE_ID arg = Filename.chop_suffix arg in
     let rec filenm_get_file_extension_PIROUETTE_ID arg =
       Filename.extension arg in
     let rec filenm_remove_file_extension_noerr_PIROUETTE_ID arg =
       Filename.remove_extension arg in
     let rec filenm_remove_file_extension_PIROUETTE_ID arg =
       Filename.chop_extension arg in
     let rec filenm_get_basename_from_path_PIROUETTE_ID arg =
       Filename.basename arg in
     let rec filenm_get_dirname_from_path_PIROUETTE_ID arg =
       Filename.dirname arg in
     let rec filenm_get_null_file_PIROUETTE_ID arg =
       (fun () -> (Filename.null)) arg in
     let rec filenm_create_temp_file_PIROUETTE_ID arg =
       Filename.temp_file arg in
     let rec filenm_get_temp_dir_PIROUETTE_ID arg = Filename.temp_dir arg in
     let rec filenm_get_temp_dir_name_PIROUETTE_ID arg =
       Filename.get_temp_dir_name arg in
     let rec filenm_set_temp_dir_name_PIROUETTE_ID arg =
       Filename.set_temp_dir_name arg in
     let rec filenm_quote_filename_PIROUETTE_ID arg = Filename.quote arg in
     let rec sys_get_argv_PIROUETTE_ID arg =
       (fun () -> (Sys.executable_name)) arg in
     let rec sys_is_file_PIROUETTE_ID arg = Sys.file_exists arg in
     let rec sys_is_directory_PIROUETTE_ID arg = Sys.is_directory arg in
     let rec sys_is_regular_file_PIROUETTE_ID arg = Sys.is_regular_file arg in
     let rec sys_remove_file_PIROUETTE_ID arg = Sys.remove arg in
     let rec sys_rename_file_PIROUETTE_ID arg = Sys.rename arg in
     let rec sys_move_file_PIROUETTE_ID arg = Sys.rename arg in
     let rec sys_get_env_PIROUETTE_ID arg = Sys.getenv arg in
     let rec sys_run_command_PIROUETTE_ID arg = Sys.command arg in
     let rec sys_change_dir_PIROUETTE_ID arg = Sys.chdir arg in
     let rec sys_ch_dir_PIROUETTE_ID arg = Sys.chdir arg in
     let rec sys_cd_PIROUETTE_ID arg = Sys.chdir arg in
     let rec sys_make_dir_PIROUETTE_ID arg = Sys.mkdir arg in
     let rec sys_mkdir_PIROUETTE_ID arg = Sys.mkdir arg in
     let rec sys_rmdir_PIROUETTE_ID arg = Sys.rmdir arg in
     let rec sys_remove_empty_dir_PIROUETTE_ID arg = Sys.rmdir arg in
     let rec sys_get_cwd_PIROUETTE_ID arg = Sys.getcwd arg in
     let rec sys_get_os_type_PIROUETTE_ID arg = (fun () -> (Sys.os_type)) arg in
     let rec sys_get_wordsize_PIROUETTE_ID arg =
       (fun () -> (Sys.word_size)) arg in
     let rec sys_get_ocaml_int_size_PIROUETTE_ID arg =
       (fun () -> (Sys.int_size)) arg in
     let rec sys_get_ocaml_max_string_length_PIROUETTE_ID arg =
       (fun () -> (Sys.max_string_length)) arg in
     let rec sys_get_ocaml_max_array_length_PIROUETTE_ID arg =
       (fun () -> (Sys.max_array_length)) arg in
     let rec sys_get_ocaml_max_floatarray_length_PIROUETTE_ID arg =
       (fun () -> (Sys.max_floatarray_length)) arg in
     let rec sys_check_big_endian_PIROUETTE_ID arg =
       (fun () -> (Sys.big_endian)) arg in
     let rec err_get_backtrace_PIROUETTE_ID arg = Printexc.get_backtrace arg in
     let rec err_record_backtrace_PIROUETTE_ID arg =
       Printexc.record_backtrace arg in
     let rec err_get_backtrace_status_PIROUETTE_ID arg =
       Printexc.backtrace_status arg in
     let rec digest_compare_PIROUETTE_ID arg = Digest.compare arg in
     let rec digest_is_equal_PIROUETTE_ID arg = Digest.equal arg in
     let rec digest_string_PIROUETTE_ID arg = Digest.string arg in
     let rec digest_substring_PIROUETTE_ID arg = Digest.substring arg in
     let rec digest_file_PIROUETTE_ID arg = Digest.file arg in
     let rec digest_convert_to_hex_string_PIROUETTE_ID arg =
       Digest.to_hex arg in
     let rec digest_convert_hex_string_to_digest_PIROUETTE_ID arg =
       Digest.of_hex arg in
     let rec rand_init_PIROUETTE_ID arg = Random.init arg in
     let rec rand_self_init_PIROUETTE_ID arg = Random.self_init arg in
     let rec rand_bits_PIROUETTE_ID arg = Random.bits arg in
     let rec rand_int_PIROUETTE_ID arg = Random.int arg in
     let rec rand_full_int_PIROUETTE_ID arg = Random.full_int arg in
     let rec rand_bool_PIROUETTE_ID arg = Random.bool arg in
     let rec exit_PIROUETTE_ID arg = exit arg in
     let rec exit_hook_PIROUETTE_ID arg = at_exit arg in
     let rec main_PIROUETTE_ID =
       let rec idle_PIROUETTE_ID = print_idle_PIROUETTE_ID "[J] idle" in
       let rec nap_PIROUETTE_ID = sleep_PIROUETTE_ID 1 in
       let rec waiting_PIROUETTE_ID =
         print_waiting_PIROUETTE_ID "J waiting on D..." in
       let rec inbox_PIROUETTE_ID =
         Marshal.from_string (Send_receive.receive_message ~location:"J") 0 in
       let rec nap_PIROUETTE_ID = sleep_PIROUETTE_ID () in
       let rec received_PIROUETTE_ID =
         print_done_PIROUETTE_ID "J received from D!" in
       let rec nap_PIROUETTE_ID = sleep_PIROUETTE_ID 1 in
       let rec sending_PIROUETTE_ID =
         print_sending_PIROUETTE_ID "J sending to B..." in
       let rec _unit_21 =
         let val_20 = inbox_PIROUETTE_ID in
         match Lwt_main.run
                 (Send_receive.send_message ~location:"B"
                    ~data:(Marshal.to_string val_20 []))
         with
         | Ok () -> ()
         | Error msg -> failwith ("Send error: " ^ msg) in
       let rec nap_PIROUETTE_ID = sleep_PIROUETTE_ID 1 in
       let rec done_PIROUETTE_ID =
         print_done_PIROUETTE_ID "J send to B sucessful!" in
       () in
     () in
   ignore process_J)