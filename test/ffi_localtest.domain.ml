[@@@warning "-26"]
;;let domain_Alice =
    Domain.spawn
      (fun _ ->
         let rec print_string_PIROUETTE_ID : ((string) -> (unit)) =
           fun arg -> print_string arg in
         let rec print_endline_PIROUETTE_ID : ((string) -> (unit)) =
           fun arg -> print_endline arg in
         let rec print_int_PIROUETTE_ID : ((int) -> (unit)) =
           fun arg -> print_int arg in
         let rec print_newline_PIROUETTE_ID : ((unit) -> (unit)) =
           fun arg -> print_newline arg in
         let rec prerr_string_PIROUETTE_ID : ((string) -> (unit)) =
           fun arg -> prerr_string arg in
         let rec prerr_endline_PIROUETTE_ID : ((string) -> (unit)) =
           fun arg -> prerr_endline arg in
         let rec prerr_int_PIROUETTE_ID : ((int) -> (unit)) =
           fun arg -> prerr_int arg in
         let rec prerr_newline_PIROUETTE_ID : ((unit) -> (unit)) =
           fun arg -> prerr_newline arg in
         let rec string_cat_PIROUETTE_ID
           : ((string) -> ((string) -> (string))) = fun arg -> String.cat arg in
         let rec cat_PIROUETTE_ID : ((string) -> ((string) -> (string))) =
           fun arg -> String.cat arg in
         let rec string_of_int_PIROUETTE_ID : ((int) -> (string)) =
           fun arg -> string_of_int arg in
         let rec string_of_bool_PIROUETTE_ID : ((bool) -> (string)) =
           fun arg -> string_of_bool arg in
         let rec length_PIROUETTE_ID : ((string) -> (int)) =
           fun arg -> String.length arg in
         let rec filenm_get_current_dir_name_PIROUETTE_ID
           : ((unit) -> (string)) =
           fun arg -> (fun () -> (Filename.current_dir_name)) arg in
         let rec filenm_get_parent_dir_name_PIROUETTE_ID
           : ((unit) -> (string)) =
           fun arg -> (fun () -> (Filename.parent_dir_name)) arg in
         let rec filenm_get_dir_sep_PIROUETTE_ID : ((unit) -> (string)) =
           fun arg -> (fun () -> (Filename.dir_sep)) arg in
         let rec filenm_concat_path_PIROUETTE_ID
           : ((string) -> ((string) -> (string))) =
           fun arg -> Filename.concat arg in
         let rec filenm_is_relative_filepath_PIROUETTE_ID
           : ((string) -> (bool)) = fun arg -> Filename.is_relative arg in
         let rec filenm_is_implicit_filepath_PIROUETTE_ID
           : ((string) -> (bool)) = fun arg -> Filename.is_implicit arg in
         let rec filenm_check_suffix_PIROUETTE_ID
           : ((string) -> ((string) -> (bool))) =
           fun arg -> Filename.check_suffix arg in
         let rec filenm_chop_suffix_PIROUETTE_ID
           : ((string) -> ((string) -> (string))) =
           fun arg -> Filename.chop_suffix arg in
         let rec filenm_get_file_extension_PIROUETTE_ID
           : ((string) -> (string)) = fun arg -> Filename.extension arg in
         let rec filenm_remove_file_extension_noerr_PIROUETTE_ID
           : ((string) -> (string)) =
           fun arg -> Filename.remove_extension arg in
         let rec filenm_remove_file_extension_PIROUETTE_ID
           : ((string) -> (string)) = fun arg -> Filename.chop_extension arg in
         let rec filenm_get_basename_from_path_PIROUETTE_ID
           : ((string) -> (string)) = fun arg -> Filename.basename arg in
         let rec filenm_get_dirname_from_path_PIROUETTE_ID
           : ((string) -> (string)) = fun arg -> Filename.dirname arg in
         let rec filenm_get_null_file_PIROUETTE_ID : ((unit) -> (string)) =
           fun arg -> (fun () -> (Filename.null)) arg in
         let rec filenm_create_temp_file_PIROUETTE_ID
           : ((string) -> ((string) -> (string))) =
           fun arg -> Filename.temp_file arg in
         let rec filenm_get_temp_dir_PIROUETTE_ID
           : ((string) -> ((string) -> (string))) =
           fun arg -> Filename.temp_dir arg in
         let rec filenm_get_temp_dir_name_PIROUETTE_ID : ((unit) -> (string))
           = fun arg -> Filename.get_temp_dir_name arg in
         let rec filenm_set_temp_dir_name_PIROUETTE_ID : ((string) -> (unit))
           = fun arg -> Filename.set_temp_dir_name arg in
         let rec filenm_quote_filename_PIROUETTE_ID : ((string) -> (string))
           = fun arg -> Filename.quote arg in
         let rec sys_get_argv_PIROUETTE_ID : ((unit) -> (string)) =
           fun arg -> (fun () -> (Sys.executable_name)) arg in
         let rec sys_is_file_PIROUETTE_ID : ((string) -> (bool)) =
           fun arg -> Sys.file_exists arg in
         let rec sys_is_directory_PIROUETTE_ID : ((string) -> (bool)) =
           fun arg -> Sys.is_directory arg in
         let rec sys_is_regular_file_PIROUETTE_ID : ((string) -> (bool)) =
           fun arg -> Sys.is_regular_file arg in
         let rec sys_remove_file_PIROUETTE_ID : ((string) -> (unit)) =
           fun arg -> Sys.remove arg in
         let rec sys_rename_file_PIROUETTE_ID
           : ((string) -> ((string) -> (unit))) = fun arg -> Sys.rename arg in
         let rec sys_move_file_PIROUETTE_ID
           : ((string) -> ((string) -> (unit))) = fun arg -> Sys.rename arg in
         let rec sys_get_env_PIROUETTE_ID : ((string) -> (string)) =
           fun arg -> Sys.getenv arg in
         let rec sys_run_command_PIROUETTE_ID : ((string) -> (int)) =
           fun arg -> Sys.command arg in
         let rec sys_change_dir_PIROUETTE_ID : ((string) -> (unit)) =
           fun arg -> Sys.chdir arg in
         let rec sys_ch_dir_PIROUETTE_ID : ((string) -> (unit)) =
           fun arg -> Sys.chdir arg in
         let rec sys_cd_PIROUETTE_ID : ((string) -> (unit)) =
           fun arg -> Sys.chdir arg in
         let rec sys_make_dir_PIROUETTE_ID : ((string) -> ((int) -> (unit)))
           = fun arg -> Sys.mkdir arg in
         let rec sys_mkdir_PIROUETTE_ID : ((string) -> ((int) -> (unit))) =
           fun arg -> Sys.mkdir arg in
         let rec sys_rmdir_PIROUETTE_ID : ((string) -> (unit)) =
           fun arg -> Sys.rmdir arg in
         let rec sys_remove_empty_dir_PIROUETTE_ID : ((string) -> (unit)) =
           fun arg -> Sys.rmdir arg in
         let rec sys_get_cwd_PIROUETTE_ID : ((unit) -> (string)) =
           fun arg -> Sys.getcwd arg in
         let rec sys_get_os_type_PIROUETTE_ID : ((unit) -> (string)) =
           fun arg -> (fun () -> (Sys.os_type)) arg in
         let rec sys_get_wordsize_PIROUETTE_ID : ((unit) -> (int)) =
           fun arg -> (fun () -> (Sys.word_size)) arg in
         let rec sys_get_ocaml_int_size_PIROUETTE_ID : ((unit) -> (int)) =
           fun arg -> (fun () -> (Sys.int_size)) arg in
         let rec sys_get_ocaml_max_string_length_PIROUETTE_ID
           : ((unit) -> (int)) =
           fun arg -> (fun () -> (Sys.max_string_length)) arg in
         let rec sys_get_ocaml_max_array_length_PIROUETTE_ID
           : ((unit) -> (int)) =
           fun arg -> (fun () -> (Sys.max_array_length)) arg in
         let rec sys_get_ocaml_max_floatarray_length_PIROUETTE_ID
           : ((unit) -> (int)) =
           fun arg -> (fun () -> (Sys.max_floatarray_length)) arg in
         let rec sys_check_big_endian_PIROUETTE_ID : ((unit) -> (bool)) =
           fun arg -> (fun () -> (Sys.big_endian)) arg in
         let rec err_get_backtrace_PIROUETTE_ID : ((unit) -> (string)) =
           fun arg -> Printexc.get_backtrace arg in
         let rec err_record_backtrace_PIROUETTE_ID : ((bool) -> (unit)) =
           fun arg -> Printexc.record_backtrace arg in
         let rec err_get_backtrace_status_PIROUETTE_ID : ((unit) -> (bool)) =
           fun arg -> Printexc.backtrace_status arg in
         let rec digest_compare_PIROUETTE_ID
           : ((string) -> ((string) -> (int))) =
           fun arg -> Digest.compare arg in
         let rec digest_is_equal_PIROUETTE_ID
           : ((string) -> ((string) -> (bool))) = fun arg -> Digest.equal arg in
         let rec digest_string_PIROUETTE_ID : ((string) -> (string)) =
           fun arg -> Digest.string arg in
         let rec digest_substring_PIROUETTE_ID
           : ((string) -> ((int) -> ((int) -> (string)))) =
           fun arg -> Digest.substring arg in
         let rec digest_file_PIROUETTE_ID : ((string) -> (string)) =
           fun arg -> Digest.file arg in
         let rec digest_convert_to_hex_string_PIROUETTE_ID
           : ((string) -> (string)) = fun arg -> Digest.to_hex arg in
         let rec digest_convert_hex_string_to_digest_PIROUETTE_ID
           : ((string) -> (string)) = fun arg -> Digest.of_hex arg in
         let rec rand_init_PIROUETTE_ID : ((int) -> (unit)) =
           fun arg -> Random.init arg in
         let rec rand_self_init_PIROUETTE_ID : ((unit) -> (unit)) =
           fun arg -> Random.self_init arg in
         let rec rand_bits_PIROUETTE_ID : ((unit) -> (int)) =
           fun arg -> Random.bits arg in
         let rec rand_int_PIROUETTE_ID : ((int) -> (int)) =
           fun arg -> Random.int arg in
         let rec rand_full_int_PIROUETTE_ID : ((int) -> (int)) =
           fun arg -> Random.full_int arg in
         let rec rand_bool_PIROUETTE_ID : ((unit) -> (bool)) =
           fun arg -> Random.bool arg in
         let rec exit_PIROUETTE_ID : ((int) -> (unit)) = fun arg -> exit arg in
         let rec exit_hook_PIROUETTE_ID : (((unit) -> (unit)) -> (unit)) =
           fun arg -> at_exit arg in
         let rec _unit = () in
         let rec stdlib_version_PIROUETTE_ID = () in
         let rec display_stdlib_info_PIROUETTE_ID _ = () in
         let rec _unit = () in let rec main_PIROUETTE_ID = 5 in ()) in
  Domain.join domain_Alice
