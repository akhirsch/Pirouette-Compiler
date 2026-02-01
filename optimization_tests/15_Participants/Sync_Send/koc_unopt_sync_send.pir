broadcast_unopt freq :=

    if A.(freq > 0) then
    A[L] ~> B;
    A[L] ~> C;    
    A[L] ~> D;
    A[L] ~> E;
    A[L] ~> F;
    A[L] ~> G;
    A[L] ~> H;
    A[L] ~> I;    
    A[L] ~> J;
    A[L] ~> K;
    A[L] ~> L;
    A[L] ~> M;
    A[L] ~> N;
    A[L] ~> O;

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
	broadcast_unopt A.(freq - 1)

    else 
    A[R] ~> B;
    A[R] ~> C;
    A[R] ~> D;
    A[R] ~> E;
    A[R] ~> F;
    A[R] ~> G;
    A[R] ~> H;
    A[R] ~> I;    
    A[R] ~> J;
    A[R] ~> K;
    A[R] ~> L;
    A[R] ~> M;
    A[R] ~> N;
    A[R] ~> O;

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
	let A.result_O := [O] O.x ~> A; in A.print_endline A."Terminate - Unoptimized";

main := broadcast_unopt A.1000;