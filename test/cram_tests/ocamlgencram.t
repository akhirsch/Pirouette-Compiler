Every example compiles without errors:

  Open utop with the backend loaded and run the backend tests:
  
  $ ls
  $ dune utop NetIR 
  > #install_printer Ppxlib.Pprintast.expression;;
  > open Ppxlib;;
  > let loc = Location.none;;
  > let int_ty = Ast_builder.Default.ptyp_constr ~loc (Ast_builder.Default.Located.lident ~loc "int") [];;
  > Backend.Dummybackend.send "Bob" (Ast_builder.Default.eint ~loc 3) "Alice";;
  > Backend.Dummybackend.recv "Bob" int_ty "Alice";;
  > Backend.Dummybackend.choose "Bob" "Alice" "L";;
  > Backend.Dummybackend.recv_label "Alice" "Bob";;
  > Backend.Dummybackend.am_i "Bob" (Ast_builder.Default.evar ~loc "x");;
  