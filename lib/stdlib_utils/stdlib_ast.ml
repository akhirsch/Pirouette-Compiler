open Ast_core.Choreo.M
open Ast_core.Local.M

let ast : 'a Ast_core.Choreo.M.stmt_block =
  [ ForeignDecl
      ( VarId ("print_string_PIROUETTE_ID", ())
      , TMap (TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ()), TUnit (), ())
      , "print_string"
      , () )
  ; ForeignDecl
      ( VarId ("print_endline_PIROUETTE_ID", ())
      , TMap (TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ()), TUnit (), ())
      , "print_endline"
      , () )
  ; ForeignDecl
      ( VarId ("print_int_PIROUETTE_ID", ())
      , TMap (TLoc (LocId ("PIRSTDLIBLOC", ()), TInt (), ()), TUnit (), ())
      , "print_int"
      , () )
  ; ForeignDecl
      ( VarId ("print_newline_PIROUETTE_ID", ())
      , TMap (TUnit (), TUnit (), ())
      , "print_newline"
      , () )
  ; ForeignDecl
      ( VarId ("prerr_string_PIROUETTE_ID", ())
      , TMap (TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ()), TUnit (), ())
      , "prerr_string"
      , () )
  ; ForeignDecl
      ( VarId ("prerr_endline_PIROUETTE_ID", ())
      , TMap (TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ()), TUnit (), ())
      , "prerr_endline"
      , () )
  ; ForeignDecl
      ( VarId ("prerr_int_PIROUETTE_ID", ())
      , TMap (TLoc (LocId ("PIRSTDLIBLOC", ()), TInt (), ()), TUnit (), ())
      , "prerr_int"
      , () )
  ; ForeignDecl
      ( VarId ("prerr_newline_PIROUETTE_ID", ())
      , TMap (TUnit (), TUnit (), ())
      , "prerr_newline"
      , () )
  ; ForeignDecl
      ( VarId ("string_cat_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , TMap
              ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
              , TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
              , () )
          , () )
      , "String.cat"
      , () )
  ; ForeignDecl
      ( VarId ("cat_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , TMap
              ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
              , TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
              , () )
          , () )
      , "String.cat"
      , () )
  ; ForeignDecl
      ( VarId ("string_of_int_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TInt (), ())
          , TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , () )
      , "string_of_int"
      , () )
  ; ForeignDecl
      ( VarId ("string_of_bool_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TBool (), ())
          , TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , () )
      , "string_of_bool"
      , () )
  ; ForeignDecl
      ( VarId ("length_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , TLoc (LocId ("PIRSTDLIBLOC", ()), TInt (), ())
          , () )
      , "String.length"
      , () )
  ; ForeignDecl
      ( VarId ("filenm_get_current_dir_name_PIROUETTE_ID", ())
      , TMap (TUnit (), TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ()), ())
      , "((fun () -> (Filename.current_dir_name)))"
      , () )
  ; ForeignDecl
      ( VarId ("filenm_get_parent_dir_name_PIROUETTE_ID", ())
      , TMap (TUnit (), TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ()), ())
      , "((fun () -> (Filename.parent_dir_name)))"
      , () )
  ; ForeignDecl
      ( VarId ("filenm_get_dir_sep_PIROUETTE_ID", ())
      , TMap (TUnit (), TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ()), ())
      , "((fun () -> (Filename.dir_sep)))"
      , () )
  ; ForeignDecl
      ( VarId ("filenm_concat_path_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , TMap
              ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
              , TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
              , () )
          , () )
      , "Filename.concat"
      , () )
  ; ForeignDecl
      ( VarId ("filenm_is_relative_filepath_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , TLoc (LocId ("PIRSTDLIBLOC", ()), TBool (), ())
          , () )
      , "Filename.is_relative"
      , () )
  ; ForeignDecl
      ( VarId ("filenm_is_implicit_filepath_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , TLoc (LocId ("PIRSTDLIBLOC", ()), TBool (), ())
          , () )
      , "Filename.is_implicit"
      , () )
  ; ForeignDecl
      ( VarId ("filenm_check_suffix_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , TMap
              ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
              , TLoc (LocId ("PIRSTDLIBLOC", ()), TBool (), ())
              , () )
          , () )
      , "Filename.check_suffix"
      , () )
  ; ForeignDecl
      ( VarId ("filenm_chop_suffix_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , TMap
              ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
              , TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
              , () )
          , () )
      , "Filename.chop_suffix"
      , () )
  ; ForeignDecl
      ( VarId ("filenm_get_file_extension_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , () )
      , "Filename.extension"
      , () )
  ; ForeignDecl
      ( VarId ("filenm_remove_file_extension_noerr_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , () )
      , "Filename.remove_extension"
      , () )
  ; ForeignDecl
      ( VarId ("filenm_remove_file_extension_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , () )
      , "Filename.chop_extension"
      , () )
  ; ForeignDecl
      ( VarId ("filenm_get_basename_from_path_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , () )
      , "Filename.basename"
      , () )
  ; ForeignDecl
      ( VarId ("filenm_get_dirname_from_path_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , () )
      , "Filename.dirname"
      , () )
  ; ForeignDecl
      ( VarId ("filenm_get_null_file_PIROUETTE_ID", ())
      , TMap (TUnit (), TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ()), ())
      , "((fun () -> (Filename.null)))"
      , () )
  ; ForeignDecl
      ( VarId ("filenm_create_temp_file_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , TMap
              ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
              , TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
              , () )
          , () )
      , "Filename.temp_file"
      , () )
  ; ForeignDecl
      ( VarId ("filenm_get_temp_dir_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , TMap
              ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
              , TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
              , () )
          , () )
      , "Filename.temp_dir"
      , () )
  ; ForeignDecl
      ( VarId ("filenm_get_temp_dir_name_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TUnit (), ())
          , TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , () )
      , "Filename.get_temp_dir_name"
      , () )
  ; ForeignDecl
      ( VarId ("filenm_set_temp_dir_name_PIROUETTE_ID", ())
      , TMap (TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ()), TUnit (), ())
      , "Filename.set_temp_dir_name"
      , () )
  ; ForeignDecl
      ( VarId ("filenm_quote_filename_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , () )
      , "Filename.quote"
      , () )
  ; ForeignDecl
      ( VarId ("sys_get_argv_PIROUETTE_ID", ())
      , TMap (TUnit (), TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ()), ())
      , "((fun () -> (Sys.executable_name)))"
      , () )
  ; ForeignDecl
      ( VarId ("sys_is_file_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , TLoc (LocId ("PIRSTDLIBLOC", ()), TBool (), ())
          , () )
      , "Sys.file_exists"
      , () )
  ; ForeignDecl
      ( VarId ("sys_is_directory_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , TLoc (LocId ("PIRSTDLIBLOC", ()), TBool (), ())
          , () )
      , "Sys.is_directory"
      , () )
  ; ForeignDecl
      ( VarId ("sys_is_regular_file_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , TLoc (LocId ("PIRSTDLIBLOC", ()), TBool (), ())
          , () )
      , "Sys.is_regular_file"
      , () )
  ; ForeignDecl
      ( VarId ("sys_remove_file_PIROUETTE_ID", ())
      , TMap (TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ()), TUnit (), ())
      , "Sys.remove"
      , () )
  ; ForeignDecl
      ( VarId ("sys_rename_file_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , TMap (TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ()), TUnit (), ())
          , () )
      , "Sys.rename"
      , () )
  ; ForeignDecl
      ( VarId ("sys_move_file_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , TMap (TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ()), TUnit (), ())
          , () )
      , "Sys.rename"
      , () )
  ; ForeignDecl
      ( VarId ("sys_get_env_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , () )
      , "Sys.getenv"
      , () )
  ; ForeignDecl
      ( VarId ("sys_run_command_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , TLoc (LocId ("PIRSTDLIBLOC", ()), TInt (), ())
          , () )
      , "Sys.command"
      , () )
  ; ForeignDecl
      ( VarId ("sys_change_dir_PIROUETTE_ID", ())
      , TMap (TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ()), TUnit (), ())
      , "Sys.chdir"
      , () )
  ; ForeignDecl
      ( VarId ("sys_ch_dir_PIROUETTE_ID", ())
      , TMap (TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ()), TUnit (), ())
      , "Sys.chdir"
      , () )
  ; ForeignDecl
      ( VarId ("sys_cd_PIROUETTE_ID", ())
      , TMap (TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ()), TUnit (), ())
      , "Sys.chdir"
      , () )
  ; ForeignDecl
      ( VarId ("sys_make_dir_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , TMap (TLoc (LocId ("PIRSTDLIBLOC", ()), TInt (), ()), TUnit (), ())
          , () )
      , "Sys.mkdir"
      , () )
  ; ForeignDecl
      ( VarId ("sys_mkdir_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , TMap (TLoc (LocId ("PIRSTDLIBLOC", ()), TInt (), ()), TUnit (), ())
          , () )
      , "Sys.mkdir"
      , () )
  ; ForeignDecl
      ( VarId ("sys_rmdir_PIROUETTE_ID", ())
      , TMap (TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ()), TUnit (), ())
      , "Sys.rmdir"
      , () )
  ; ForeignDecl
      ( VarId ("sys_remove_empty_dir_PIROUETTE_ID", ())
      , TMap (TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ()), TUnit (), ())
      , "Sys.rmdir"
      , () )
  ; ForeignDecl
      ( VarId ("sys_get_cwd_PIROUETTE_ID", ())
      , TMap (TUnit (), TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ()), ())
      , "Sys.getcwd"
      , () )
  ; ForeignDecl
      ( VarId ("sys_get_os_type_PIROUETTE_ID", ())
      , TMap (TUnit (), TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ()), ())
      , "((fun () -> (Sys.os_type)))"
      , () )
  ; ForeignDecl
      ( VarId ("sys_get_wordsize_PIROUETTE_ID", ())
      , TMap (TUnit (), TLoc (LocId ("PIRSTDLIBLOC", ()), TInt (), ()), ())
      , "((fun () -> (Sys.word_size)))"
      , () )
  ; ForeignDecl
      ( VarId ("sys_get_ocaml_int_size_PIROUETTE_ID", ())
      , TMap (TUnit (), TLoc (LocId ("PIRSTDLIBLOC", ()), TInt (), ()), ())
      , "((fun () -> (Sys.int_size)))"
      , () )
  ; ForeignDecl
      ( VarId ("sys_get_ocaml_max_string_length_PIROUETTE_ID", ())
      , TMap (TUnit (), TLoc (LocId ("PIRSTDLIBLOC", ()), TInt (), ()), ())
      , "((fun () -> (Sys.max_string_length)))"
      , () )
  ; ForeignDecl
      ( VarId ("sys_get_ocaml_max_array_length_PIROUETTE_ID", ())
      , TMap (TUnit (), TLoc (LocId ("PIRSTDLIBLOC", ()), TInt (), ()), ())
      , "((fun () -> (Sys.max_array_length)))"
      , () )
  ; ForeignDecl
      ( VarId ("sys_get_ocaml_max_floatarray_length_PIROUETTE_ID", ())
      , TMap (TUnit (), TLoc (LocId ("PIRSTDLIBLOC", ()), TInt (), ()), ())
      , "((fun () -> (Sys.max_floatarray_length)))"
      , () )
  ; ForeignDecl
      ( VarId ("sys_check_big_endian_PIROUETTE_ID", ())
      , TMap (TUnit (), TLoc (LocId ("PIRSTDLIBLOC", ()), TBool (), ()), ())
      , "((fun () -> (Sys.big_endian)))"
      , () )
  ; ForeignDecl
      ( VarId ("err_get_backtrace_PIROUETTE_ID", ())
      , TMap (TUnit (), TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ()), ())
      , "Printexc.get_backtrace"
      , () )
  ; ForeignDecl
      ( VarId ("err_record_backtrace_PIROUETTE_ID", ())
      , TMap (TLoc (LocId ("PIRSTDLIBLOC", ()), TBool (), ()), TUnit (), ())
      , "Printexc.record_backtrace"
      , () )
  ; ForeignDecl
      ( VarId ("err_get_backtrace_status_PIROUETTE_ID", ())
      , TMap (TUnit (), TLoc (LocId ("PIRSTDLIBLOC", ()), TBool (), ()), ())
      , "Printexc.backtrace_status"
      , () )
  ; ForeignDecl
      ( VarId ("digest_compare_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , TMap
              ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
              , TLoc (LocId ("PIRSTDLIBLOC", ()), TInt (), ())
              , () )
          , () )
      , "Digest.compare"
      , () )
  ; ForeignDecl
      ( VarId ("digest_is_equal_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , TMap
              ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
              , TLoc (LocId ("PIRSTDLIBLOC", ()), TBool (), ())
              , () )
          , () )
      , "Digest.equal"
      , () )
  ; ForeignDecl
      ( VarId ("digest_string_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , () )
      , "Digest.string"
      , () )
  ; ForeignDecl
      ( VarId ("digest_substring_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , TMap
              ( TLoc (LocId ("PIRSTDLIBLOC", ()), TInt (), ())
              , TMap
                  ( TLoc (LocId ("PIRSTDLIBLOC", ()), TInt (), ())
                  , TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
                  , () )
              , () )
          , () )
      , "Digest.substring"
      , () )
  ; ForeignDecl
      ( VarId ("digest_file_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , () )
      , "Digest.file"
      , () )
  ; ForeignDecl
      ( VarId ("digest_convert_to_hex_string_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , () )
      , "Digest.to_hex"
      , () )
  ; ForeignDecl
      ( VarId ("digest_convert_hex_string_to_digest_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
          , () )
      , "Digest.of_hex"
      , () )
  ; ForeignDecl
      ( VarId ("rand_init_PIROUETTE_ID", ())
      , TMap (TLoc (LocId ("PIRSTDLIBLOC", ()), TInt (), ()), TUnit (), ())
      , "Random.init"
      , () )
  ; ForeignDecl
      ( VarId ("rand_self_init_PIROUETTE_ID", ())
      , TMap (TUnit (), TUnit (), ())
      , "Random.self_init"
      , () )
  ; ForeignDecl
      ( VarId ("rand_bits_PIROUETTE_ID", ())
      , TMap (TUnit (), TLoc (LocId ("PIRSTDLIBLOC", ()), TInt (), ()), ())
      , "Random.bits"
      , () )
  ; ForeignDecl
      ( VarId ("rand_int_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TInt (), ())
          , TLoc (LocId ("PIRSTDLIBLOC", ()), TInt (), ())
          , () )
      , "Random.int"
      , () )
  ; ForeignDecl
      ( VarId ("rand_full_int_PIROUETTE_ID", ())
      , TMap
          ( TLoc (LocId ("PIRSTDLIBLOC", ()), TInt (), ())
          , TLoc (LocId ("PIRSTDLIBLOC", ()), TInt (), ())
          , () )
      , "Random.full_int"
      , () )
  ; ForeignDecl
      ( VarId ("rand_bool_PIROUETTE_ID", ())
      , TMap (TUnit (), TLoc (LocId ("PIRSTDLIBLOC", ()), TBool (), ()), ())
      , "Random.bool"
      , () )
  ; ForeignDecl
      ( VarId ("exit_PIROUETTE_ID", ())
      , TMap (TLoc (LocId ("PIRSTDLIBLOC", ()), TInt (), ()), TUnit (), ())
      , "exit"
      , () )
  ; ForeignDecl
      ( VarId ("exit_hook_PIROUETTE_ID", ())
      , TMap (TMap (TUnit (), TUnit (), ()), TUnit (), ())
      , "at_exit"
      , () )
  ; Decl
      ( Var (VarId ("stdlib_version_PIROUETTE_ID", ()), ())
      , TLoc (LocId ("PIRSTDLIBLOC", ()), TString (), ())
      , () )
  ; Assign
      ( Var (VarId ("stdlib_version_PIROUETTE_ID", ()), ()) :: []
      , LocExpr (LocId ("PIRSTDLIBLOC", ()), Val (String ("0.0.2", ()), ()), ())
      , () )
  ; Assign
      ( Var (VarId ("display_stdlib_info_PIROUETTE_ID", ()), ()) :: []
      , FunDef
          ( Default () :: []
          , FunApp
              ( LocExpr
                  ( LocId ("PIRSTDLIBLOC", ())
                  , Var (VarId ("print_endline_PIROUETTE_ID", ()), ())
                  , () )
              , FunApp
                  ( FunApp
                      ( Var (VarId ("string_cat_PIROUETTE_ID", ()), ())
                      , FunApp
                          ( FunApp
                              ( Var (VarId ("string_cat_PIROUETTE_ID", ()), ())
                              , LocExpr
                                  ( LocId ("PIRSTDLIBLOC", ())
                                  , Val
                                      ( String
                                          ( "====================================\n\
                                             PIROUETTE STANDARD LIBRARY INFO\n\n\
                                             Library version: "
                                          , () )
                                      , () )
                                  , () )
                              , () )
                          , Var (VarId ("stdlib_version_PIROUETTE_ID", ()), ())
                          , () )
                      , () )
                  , LocExpr
                      ( LocId ("PIRSTDLIBLOC", ())
                      , Val
                          ( String
                              ( "\n\
                                 Last modified: 10/31/2025\n\n\
                                 ====================================\n"
                              , () )
                          , () )
                      , () )
                  , () )
              , () )
          , () )
      , () )
  ]
;;
