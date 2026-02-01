commstime E.iterations E.init_num :=

	    if E.(iterations > 0) then
	       E[L] ~> A;
	       E[L] ~> B;
	       E[L] ~> C;
	       E[L] ~> D;

               let B.init_num := [E] E.init_num ~> B; in
               let C.delta := [B] B.init_num ~> C; in
	       let C.successor := C.(delta + 1); in
	       let A.successor := [C] C.successor ~> A; in
               let D.delta := [B] B.init_num ~> D; in	       
	       let B.init_num := [A] A.successor ~> B; in 
	       let E.new_iterations := E.(iterations - 1); in
	       let E.new_init_num := [B] B.init_num ~> E; in
	       commstime E.new_iterations E.new_init_num

             else
	       E[R] ~> A;
	       E[R] ~> B;
	       E[R] ~> C;
	       E[R] ~> D;
              
               E.print_string E."Communications Time completed successfully";



main := commstime E.10 E.0;

