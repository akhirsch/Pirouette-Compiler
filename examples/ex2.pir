main :=
  let
    R.x := [S] S.(3) ~> R;
  in
    if
      R.(x > 5)
    then
      R[L] ~> S; S.("Hello")
    else
      R[R] ~> S; S.("Bye");
