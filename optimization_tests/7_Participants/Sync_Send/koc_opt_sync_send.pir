broadcast_opt freq :=

    if A.(freq > 0) then
    A[L] ~> B;
    A[L] ~> C;    
    B[L] ~> D;
    B[L] ~> E;
    C[L] ~> F;
    C[L] ~> G;

        let B.x := B.10; in
	let A.result_B := [B] B.x ~> A; in 
        let C.x := C.10; in
	let A.result_C := [C] C.x ~> A; in 	
        let D.x := D.10; in
	let A.result_D := [D] D.x ~> A; in 	
        let E.x := E.10; in
	let A.result_E := [E] E.x ~> A; in 	
        let F.x := F.10; in
	let A.result_F := [F] F.x ~> A; in 	
        let G.x := G.10; in
	let A.result_G := [G] G.x ~> A; in 	
	broadcast_opt A.(freq - 1)

    else
    
    A[R] ~> B;
    A[R] ~> C;    
    B[R] ~> D;
    B[R] ~> E;
    C[R] ~> F;
    C[R] ~> G;

        let B.x := B.9; in
	let A.result_B := [B] B.x ~> A; in 
        let C.x := C.9; in
	let A.result_C := [C] C.x ~> A; in 	
        let D.x := D.9; in
	let A.result_D := [D] D.x ~> A; in 	
        let E.x := E.9; in
	let A.result_E := [E] E.x ~> A; in 	
        let F.x := F.9; in
	let A.result_F := [F] F.x ~> A; in 	
        let G.x := G.9; in
	let A.result_G := [G] G.x ~> A; in A.print_endline A."Terminate - Optimized";

main := broadcast_opt A.100000;