(lang dune 3.14)

(using menhir 3.0)

(name pirc)

(generate_opam_files true)

(source
 (github akhirsch/Pirouette-Compiler))

(authors "Andrew K. Hirsch" "Foundations of Decentralization Group")

(maintainers "Andrew K. Hirsch")

(license "Apache-2.0")

(package
 (name pirc)
 (synopsis "Pirouette Compiler")
 (description "A compiler for a typed functional choreographic language.")
 (depends
  (dune :build)
  (menhir :build)
  (ocaml
   (>= 5.0.0))
  (ppxlib
   (and
    (= 0.35.0)
    :build))
  (bisect_ppx :with-test)
  (ocamlformat
   (and
    (>= 0.27.0)
    :dev))))
