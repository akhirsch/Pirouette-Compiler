main :=
  let
    R.x := [S] S.(3.2) ~> R;
  in
    if
      R.(x > 5.4)
    then
      R[L] ~> S; S.("Hello")
    else
      R[R] ~> S; S.("Bye");
