test_func x :=
if A.(x > 5)
 then
  A[L] ~> B;
  B.5
 else
  A[R] ~> B;
  B.12;

main := test_func A.6;
 