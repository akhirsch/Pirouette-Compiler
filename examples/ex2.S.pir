(
  (main) :=
    (let
       (
         (_) := ((ret (3)) ~> R)
       )
     in
       (allow R choice
        | R -> ret ("Bye")
        | L -> ret ("Hello")))
)
