--foreign get_modulo : int -> int -> int := "@utils/Stdlib:(mod)"
--foreign print : unit -> unit := "@utils/Printf:printf"
--foreign print_int : unit -> unit := "@utils/Stdlib:print_int"
--foreign generate_random_int : int -> int := "@utils/Random:full_int"

E.get_length E.num_one := E.num_one;

experiment iterations :=
	   if E.(iterations > 0) then
	   E[L5] ~> A;
	   E[L5] ~> B;
	   E[L5] ~> C;
           E[L5] ~> D;

	      let E.rand_number := E.100; in   
	      let E.modulo_result := E.get_length E.4; in
	      	  if E.(modulo_result = 0) then
		  E[L1] ~> A;
		  E[L1] ~> B;
		  E[L1] ~> C;
		  E[L1] ~> D;
		  
		     let A.result := [E] E.modulo_result ~> A; in
                     experiment E.(iterations - 1)
		     
		  else
                  E[R1] ~> A;
		  E[R1] ~> B;
		  E[R1] ~> C;
		  E[R1] ~> D;
		  
		     if E.(modulo_result = 1) then
                     E[L2] ~> A;
		     E[L2] ~> B;
		     E[L2] ~> C;
		     E[L2] ~> D;
		     
		     	let B.result := [E] E.modulo_result ~> B; in
                        experiment E.(iterations - 1)
			
	             else
		     E[R2] ~> A;
		     E[R2] ~> B;
		     E[R2] ~> C;
		     E[R2] ~> D;
		     
			if E.(modulo_result = 2) then
			E[L3] ~> A;
		        E[L3] ~> B;
		        E[L3] ~> C;
		        E[L3] ~> D;
			
			   let C.result := [E] E.modulo_result ~> C; in 
                           experiment E.(iterations - 1)
			   
			else
			E[R3] ~> A;
		        E[R3] ~> B;
		        E[R3] ~> C;
		        E[R3] ~> D;
			
		           if E.(modulo_result = 3) then
          	           E[L4] ~> A;
		           E[L4] ~> B;
		           E[L4] ~> C;
		           E[L4] ~> D;

			      let D.result := [E] E.modulo_result ~> D; in 
                              experiment E.(iterations - 1)
			      
			   else
			   E[R4] ~> A;
		           E[R4] ~> B;
		           E[R4] ~> C;
		           E[R4] ~> D;

			       E.print_string E."Invalid Choice\n"
	   else
	   E[R5] ~> A;
	   E[R5] ~> B;
	   E[R5] ~> C;
           E[R5] ~> D;

		E.print_string E."Select Time completed successfully";

main := experiment E.1;