{-works-}

type X := (A.int * B.int);

type X := 
| constructor1: A.int, A.int, B.int, C.int:X;
| constructor2: A.int, A.int, B.int, C.int:X;
| constructor3: A.int, A.int, B.int, C.int:X;

{-works-}
type X := | constructor: A.int, A.int, B.int, C.int:X;

{-works-}
type X := | constructor: A.int: X;

{-type X := | constructor: cat.int -> dog.int -> lizard.int : Y; -}

{- doesn't work, if we want this, process arg list as typ_id-}
{-type X := | constructor: int -> int: X; -}


{-does work, but process as a send??? arg list as choreo_types/local_types-}
{-type X := | constructor: A.int -> A.int: X;-}

{-does work-}
type X := 
| constructor: X;


{- doesn't work
type X := 
| constructor: arg1 -> arg2; -}

{-comment-}