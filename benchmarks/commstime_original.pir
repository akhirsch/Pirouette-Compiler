commstime E.iterations B.init_num :=

	    if E.(iterations > 0) then
	       E[L] ~> A;
	       E[L] ~> B;
	       E[L] ~> C;
	       E[L] ~> D;

               let C.delta := [B] B.init_num ~> C; in
	       let C.successor := C.(delta + 1); in
	       let A.successor := [C] C.successor ~> A; in
	       let B.init_num := [A] A.successor ~> B; in
	       let E.new_iterations := E.(iterations - 1); in
               let D.delta := [B] B.init_num ~> D; in	       	       	       
	       commstime E.new_iterations B.init_num

             else
	       E[R] ~> A;
	       E[R] ~> B;
	       E[R] ~> C;
	       E[R] ~> D;
              
               E.print_string E."Communications Time completed successfully";
	       
main := commstime E.10 B.0;