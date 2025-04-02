let pir_1 =
  "main := let R.x := [S] S.3 ~> R; in \n\n\
   if R.(x>5) \n\n\
   then R[L] ~> S; \n\n\
   S.\"Hello\"\n\n\
   else R[R] ~> S; \n\n\
   S.\"Bye\";\n"
;;

let testcase_1 =
  "left _ := let \n\n\
   R.x := [S] left S.1 ~> R;\n\n\
   R.x := [S] right S.3 ~> R; in \n\n\
   if R.(x> fst 5) \n\n\
   then R[L] ~> S; \n\n\
   S.\"Hello\"\n\n\
   else R[R] ~> S; \n\n\
   S.\"Bye\";\n"
;;

let dot_1 = 
"digraph Example1{
    a[label=Assign]
    b[label=main]
    c[label=Let]
    d[label=Assign]
    e[label=\"R.\"]
    f[label=\"Send: R.\"]
    g[label=x]
    h[label=\"S.\"]
    i[label=3]
    j[label=If]
    k[label=\"R.\"]
    l[label=\"Sync: R[L] -> S\"]
    m[label=\"S.\"]
    n[label=\"Sync: R[R] -> S\"]
    o[label=\"S.\"]
    p[label=BinOp]
    q[label=x]
    r[label=5]
    s[label=\">\"]
    u[label=\"\"Hello\"\"]
    w[label=\"\"Bye\"\"]
    
    a -> {b c};
    c -> {d j};
    d -> {e f};
    e -> g;
    f -> h -> i;
    j -> {k l n };
    k -> p -> {q r s};
    l -> m;
    m -> u;
    n -> o;
    o -> w;
}"
;;

let pir_2 =
  "main :=
    if R.(3+5 > 2-1)
    then R[L] ~> S;
  	  let R.res := [S] S.(1,true) ~> R; in R.\"Sent\"
    else R[R] ~> S;
  	  let R.res := [S] S.(0,false) ~> R; in R.\"why\";"
;;

let dot_2 =
  "digraph Example2 {
    a[label=Assign];
    b[label=main];
    c[label=If];
    d[label=\"R.\"];
    e[label=Let];
    f[label=Let];
    g[label=BinOp];
    h[label=BinOp];
    i[label=BinOp];
    j[label=\">\"];
    k[label=3];
    l[label=5];
    m[label=\"+\"];
    n[label=2];
    o[label=1];
    p[label=\"-\"];
    q[label=Assign];
    r[label=\"R.\"];
    s[label=\"R.\"];
    t[label=\"Send: R\"];
    u[label=Res];
    v[label=Pair]; //check
    w[label=0];
    x[label=false];
    y[label=\"\"Why\"\"];
    z[label=Assign];
    aa[label=\"R.\"];
    ab[label=\"R.\"];
    ac[label=\"Send: R\"];
    ad[label=Res];
    ae[label=Pair]; //check
    af[label=1];
    ag[label=true];
    ah[label=\"\"Sent\"\"];
    ai[label=\"Sync: R[R] -> S\"];
    aj[label=\"Sync: R[L] -> S\"];
    
    a -> {b c};
    c -> {d ai aj};
    d -> g;
    g -> {h i j};
    h -> {k l m};
    i -> {n o p};
    e -> {q r};
    q -> {s t};
    s -> u;
    t -> v;
    v -> {w x};
    r -> y;
    f -> {z aa};
    z -> {ab ac};
    ab -> ad;
    ac -> ae;
    ae -> {af ag};
    aa -> ah;
    ai -> e;
    aj -> f
}"
;;

let pir_3 =
  "y: P2.int;
  y := if P1.(3>5)
  then P1[L] ~> P2;
    P2.5
  else P1[R] ~> P2;
    P2.9
;"
;;

let dot_3 = "digraph G {\nn0 [label=\"Decl [1:0-1:10]\"];\nn0 -> n1;\nn0 -> n2;\nn1 [label=\"y [1:0-1:1]\"];\nn2 [label=\"P2 [1:3-1:9]\"];\nn2 -> n3;\nn3 [label=\"Int [1:6-1:9]\"];\n\nn4 [label=\"Assign [2:2-7:1]\"];\nn4 -> n5;\nn4 -> n6;\nn5 [label=\"y [2:2-2:3]\"];\nn6 [label=\"If [2:7-6:8]\"];\nn6 -> n7;\nn6 -> n12;\nn6 -> n15;\nn7 [label=\"P1 [2:10-2:18]\"];\nn7 -> n8;\nn8 [label=\"BinOp [2:13-2:18]\"];\nn8 -> n9;\nn8 -> n10;\nn8 -> n11;\nn9 [label=\"3 [2:14-2:15]\"];\nn10 [label=\"5 [2:16-2:17]\"];\nn11 [label=\"> [2:15-2:16]\"];\nn12 [label=\"Sync: P1[L] -> P2 [3:7-4:8]\"];\nn12 -> n13;\nn13 [label=\"P2 [4:4-4:8]\"];\nn13 -> n14;\nn14 [label=\"5 [4:7-4:8]\"];\nn15 [label=\"Sync: P1[R] -> P2 [5:7-6:8]\"];\nn15 -> n16;\nn16 [label=\"P2 [6:4-6:8]\"];\nn16 -> n17;\nn17 [label=\"9 [6:7-6:8]\"];\n\n}"
  let dot_3_proper =
  "digraph G {\n\
  n0 [label=\"Decl [1:0-1:10]\"];\n\
  n0 -> n1;\n\
  n0 -> n2;\n\
  n1 [label=\"y [1:0-1:1]\"];\n\
  n2 [label=\"P2 [1:3-1:9]\"];\n\
  n2 -> n3;\n\
  n3 [label=\"Int [1:6-1:9]\"];\n\n\
  n4 [label=\"Assign [2:2-7:1]\"];\n\
  n4 -> n5;\n\
  n4 -> n6;\n\
  n5 [label=\"y [2:2-2:3]\"];\n\
  n6 [label=\"If [2:7-6:8]\"];\n\
  n6 -> n7;\n\
  n6 -> n12;\n\
  n6 -> n15;\n\
  n7 [label=\"P1 [2:10-2:18]\"];\n\
  n7 -> n8;\n\
  n8 [label=\"BinOp [2:13-2:18]\"];\n\
  n8 -> n9;\n\
  n8 -> n10;\n\
  n8 -> n11;\n\
  n9 [label=\"3 [2:14-2:15]\"];\n\
  n10 [label=\"5 [2:16-2:17]\"];\n\
  n11 [label=\"> [2:15-2:16]\"];\n\
  n12 [label=\"Sync: P1[L] -> P2 [3:7-4:8]\"];\n\
  n12 -> n13;\n\
  n13 [label=\"P2 [4:4-4:8]\"];\n\
  n13 -> n14;\n\
  n14 [label=\"5 [4:7-4:8]\"];\n\
  n15 [label=\"Sync: P1[R] -> P2 [5:7-6:8]\"];\n\
  n15 -> n16;\n\
  n16 [label=\"P2 [6:4-6:8]\"];\n\
  n16 -> n17;\n\
  n17 [label=\"9 [6:7-6:8]\"];\n\n\
  }"
  
let dot_3_example =
"digraph Example3 {
    a[label=Assign];
    b[label=\"y\"];
    c[label=\"P2.\"];
    d[label=Assign];
    e[label=y];
    f[label=If];
    g[label=\"P1.\"];
    h[label=\"Sync P1[L]\"];
    i[label=\"P2.\"];
    j[label=\"Sync P1[R]\"];
    k[label=\"P2.\"];
    l[label=BinOp];
    m[label=3];
    n[label=5];
    o[label=\">\"];
    q[label=5];
    s[label=9];
    t[label=int];
    
    a -> {b c};
    b -> d;
    d -> {e f}; 
    f -> {g h j};
    g -> l;
    l -> {m n o};
    h -> i;
    i -> q;
    j -> k;
    k -> s;
    c -> t;
}"
;;


let pir_4 =
  "y:= let P.y := y; in
	if P.(y > 3) then
		P.(1)
	else 
		let P2.a := [P1] P1.(z) ~> P2; in
	y;"
;;

let dot_4_example =
"digraph Example4 {
  a[label=Assign];
  b[label=y];
  c[label=Let];
  d[label=Assign];
  e[label=If];
  g[label=P];
  f[label=y];
  h[label=y];
  i[label=P];
  j[label=P];
  k[label=Let];
  l[label=BinOp];
  m[label=y];
  n[label=3];
  o[label=\">\"];
  p[label=1];
  q[label=Assign];
  r[label=y];
  s[label=P2];
  t[label=\"Send: P2\"];
  u[label=a];
  v[label=P1];
  w[label=z]; 
  
  a -> {b c};
  c -> {d e};
  d -> {f g};
  g -> h;
  e -> {i j k};
  i -> l;
  l -> {m n o};
  j -> p;
  k -> {q r};
  q -> {s t};
  s -> u;
  t -> v;
  v -> w;
}"
;;

let dot_4 = 
"digraph G {
n0 [label=\"Assign [1:0-6:3]\"];
n0 -> n1;
n0 -> n2;
n1 [label=\"y [1:0-1:1]\"];
n2 [label=\"Let [1:4-6:2]\"];
n2 -> n3 ;
n2 -> n7;
n3 [label=\"Assign [1:8-1:17]\"];
n3 -> n4;
n3 -> n6;
n4 [label=\"P [1:8-1:11]\"];
n4 -> n5;
n5 [label=\"y [1:10-1:11]\"];
n6 [label=\"y [1:15-1:16]\"];
n7 [label=\"If [2:1-6:2]\"];
n7 -> n8;
n7 -> n13;
n7 -> n15;
n8 [label=\"P [2:4-2:13]\"];
n8 -> n9;
n9 [label=\"BinOp [2:6-2:13]\"];
n9 -> n10;
n9 -> n11;
n9 -> n12;
n10 [label=\"y [2:7-2:8]\"];
n11 [label=\"3 [2:11-2:12]\"];
n12 [label=\"> [2:9-2:10]\"];
n13 [label=\"P [3:2-3:7]\"];
n13 -> n14;
n14 [label=\"1 [3:5-3:6]\"];
n15 [label=\"Let [5:2-6:2]\"];
n15 -> n16 ;
n15 -> n22;
n16 [label=\"Assign [5:6-5:32]\"];
n16 -> n17;
n16 -> n19;
n17 [label=\"P2 [5:6-5:10]\"];
n17 -> n18;
n18 [label=\"a [5:9-5:10]\"];
n19 [label=\"Send from: P1 [5:14-5:31]\"];
n19 [label=\"Send to: P2 [5:14-5:31]\"];
n19 -> n20;
n20 [label=\"P1 [5:19-5:25]\"];
n20 -> n21;
n21 [label=\"z [5:22-5:25]\"];
n22 [label=\"y [6:1-6:2]\"];
}"
;;

let pir_5 =
  "main :=
    if R.(3/5 < 2*1)
    then R[L] ~> S;
  	  let R.res := [S] S.(1,true) ~> R; in R.\"Sent\"
    else R[R] ~> S;
  	  let R.res := [S] S.(0,false) ~> R; in R.\"why\";"
;;

let dot_5 =
  "digraph Example5 {
    a[label=Assign];
    b[label=main];
    c[label=If];
    d[label=\"R.\"];
    e[label=Let];
    f[label=Let];
    g[label=BinOp];
    h[label=BinOp];
    i[label=BinOp];
    j[label=\"<\"];
    k[label=3];
    l[label=5];
    m[label=\"\\\"];
    n[label=2];
    o[label=1];
    p[label=\"*\"];
    q[label=Assign];
    r[label=\"R.\"];
    s[label=\"R.\"];
    t[label=\"Send: R\"];
    u[label=Res];
    v[label=Pair]; //check
    w[label=0];
    x[label=false];
    y[label=\"\"Why\"\"];
    z[label=Assign];
    aa[label=\"R.\"];
    ab[label=\"R.\"];
    ac[label=\"Send: R\"];
    ad[label=Res];
    ae[label=Pair]; //check
    af[label=1];
    ag[label=true];
    ah[label=\"\"Sent\"\"];
    ai[label=\"Sync: R[R] -> S\"];
    aj[label=\"Sync: R[L] -> S\"];
    
    a -> {b c};
    c -> {d ai aj};
    d -> g;
    g -> {h i j};
    h -> {k l m};
    i -> {n o p};
    e -> {q r};
    q -> {s t};
    s -> u;
    t -> v;
    v -> {w x};
    r -> y;
    f -> {z aa};
    z -> {ab ac};
    ab -> ad;
    ac -> ae;
    ae -> {af ag};
    aa -> ah;
    ai -> e;
    aj -> f
}"

let pir_6 =
  "main := let R.x := [S] S.3 ~> R; in \n\n\
   if R.(x<5) \n\n\
   then R[L] ~> S; \n\n\
   S.\"Hello\"\n\n\
   else R[R] ~> S; \n\n\
   S.\"Bye\";\n"
;;

let pir_7 =
  "main := let R.x := [S] S.3 ~> R; in \n\n\
   if R.(x<=5) \n\n\
   then R[L] ~> S; \n\n\
   S.\"Hello\"\n\n\
   else R[R] ~> S; \n\n\
   S.\"Bye\";\n"
;;
let pir_8 =
  "main := let R.x := [S] S.3 ~> R; in \n\n\
   if R.(x>=5) \n\n\
   then R[L] ~> S; \n\n\
   S.\"Hello\"\n\n\
   else R[R] ~> S; \n\n\
   S.\"Bye\";\n"
;;

let pir_9 =
  "main := let R.x := [S] S.3 ~> R; in \n\n\
   if R.(x=5) \n\n\
   then R[L] ~> S; \n\n\
   S.\"Hello\"\n\n\
   else R[R] ~> S; \n\n\
   S.\"Bye\";\n"
;;

;;