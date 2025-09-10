broadcast_opt freq :=

    if A.(freq > 0) then
    A[L] ~> B;
    A[L] ~> C;    
    B[L] ~> D;
    B[L] ~> E;
    C[L] ~> F;
    C[L] ~> G;
    D[L] ~> H;
    D[L] ~> I;    
    E[L] ~> J;
    E[L] ~> K;
    F[L] ~> L;
    F[L] ~> M;
    G[L] ~> N;
    G[L] ~> O;

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
        let H.x := H.10; in
	let A.result_H := [H] H.x ~> A; in 	
        let I.x := I.10; in
	let A.result_I := [I] I.x ~> A; in 	
        let J.x := J.10; in
	let A.result_J := [J] J.x ~> A; in 	
        let K.x := K.10; in
	let A.result_K := [K] K.x ~> A; in 	
        let L.x := L.10; in
	let A.result_L := [L] L.x ~> A; in 	
        let M.x := M.10; in
	let A.result_M := [M] M.x ~> A; in 	
	let N.x := N.10; in
	let A.result_N := [N] N.x ~> A; in 	
        let O.x := O.10; in
	let A.result_O := [O] O.x ~> A; in 		
	broadcast_opt A.(freq - 1)

    else
    
    A[R] ~> B;
    A[R] ~> C;    
    B[R] ~> D;
    B[R] ~> E;
    C[R] ~> F;
    C[R] ~> G;
    D[R] ~> H;
    D[R] ~> I;    
    E[R] ~> J;
    E[R] ~> K;
    F[R] ~> L;
    F[R] ~> M;
    G[R] ~> N;
    G[R] ~> O;

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
	let A.result_G := [G] G.x ~> A; in 	
        let H.x := H.9; in
	let A.result_H := [H] H.x ~> A; in 	
        let I.x := I.9; in
	let A.result_I := [I] I.x ~> A; in 	
        let J.x := J.9; in
	let A.result_J := [J] J.x ~> A; in 	
        let K.x := K.9; in
	let A.result_K := [K] K.x ~> A; in 	
        let L.x := L.9; in
	let A.result_L := [L] L.x ~> A; in 	
        let M.x := M.9; in
	let A.result_M := [M] M.x ~> A; in 	
	let N.x := N.9; in
	let A.result_N := [N] N.x ~> A; in 	
        let O.x := O.9; in
	let A.result_O := [O] O.x ~> A; in A.print_endline A."Terminate - Optimized";
	
main := broadcast_opt A.100000;