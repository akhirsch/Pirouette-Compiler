(lang dune 3.14)

(using menhir 3.0)

(name pirc)

(generate_opam_files true)

(source
 (github Foundations-of-Decentralization-Group/Pirouette-Compiler))

(authors "Author Name")

(maintainers "Maintainer Name")

(license LICENSE)

(documentation https://dl.acm.org/doi/10.1145/3498684)

(package
 (name http_pirc)
 (depends
  (lwt :build)
  (cohttp-lwt-unix :build)
  (cohttp :build))
 (allow_empty))

(package
 (name pirc)
 (synopsis "Pirouette Compiler")
 (description "Higher-order typed functional choreographies")
 (depends
  (cohttp-lwt-unix :build)
  (dune :build)
  (lwt :build)
  (lwt_ppx :build)
  (menhir :build)
  (ocaml (>= 5.0.0))
  (ppxlib (and (= 0.35.0):build))
  (yaml :build)
  (yojson :build)
  (bisect_ppx :with-test)
  (domainslib :with-test)
  (mpi :with-test)
  (logs :with-test)
  (ocamlfind :with-test)
  (ounit2 :with-test)
  (ocamlformat (and (>= 0.27.0):dev)))
 (allow_empty))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
