
{-intializing the state of all the nodes-}
A.state := A."off";
B.state := B."off";
C.state := C."off";
D.state := D."off";
E.state := E."off";
F.state := F."off";
G.state := G."off";
H.state := H."off";
I.state := I."off";
J.state := J."off";
K.state := K."off";
L.state := L."off";
M.state := M."off";
N.state := N."off";
O.state := O."off";
P.state := P."off";

A.inbox := A."None";
B.inbox := B."None";
C.inbox := C."None";
D.inbox := D."None";
E.inbox := E."None";
F.inbox := F."None";
G.inbox := G."None";
H.inbox := H."None";
I.inbox := I."None";
J.inbox := J."None";
K.inbox := K."None";
L.inbox := L."None";
M.inbox := M."None";
N.inbox := N."None";
O.inbox := O."None";
P.inbox := P."None";


[A] A."send" ~> B.inbox;
A.state := A."sending";
B.state := B."waiting";
if B.inbox = B."send"


