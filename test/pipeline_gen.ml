let shm_flags = "-thread -linkpkg -package threads,domainslib"

let gen_rules flags basename =
  Printf.printf
    {|
(rule
 (target %s.ml)
 (action
  (run %%{bin:pirc} ../pipeline_src/%s.pir)))

(rule
 (target %s.exe)
 (deps %s.ml)
 (action
  (run ocamlfind ocamlopt -o %s.exe %s %s.ml)))

(rule
 (with-stdout-to
  %s.res
  (run ./%s.exe)))

(rule
 (alias pipeline-%s)
 (action
  (diff ../pipeline_src/%s.ans %s.res)))

(alias
 (name test-pipeline)
 (deps
  (alias pipeline-%s)))
|}
    basename basename
    basename basename basename flags basename
    basename basename
    basename basename basename
    basename
[@@ocamlformat "disable"]

let () =
  Sys.readdir "../pipeline_src"
  |> Array.to_list
  |> List.filter_map (Filename.chop_suffix_opt ~suffix:".pir")
  |> List.iter (gen_rules shm_flags);
  Printf.printf
    {|
(alias
 (name runtest)
 (deps
  (alias test-pipeline)))
|}
;;
