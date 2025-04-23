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
let dot_1 = "digraphG{n0[label=\"Assign[1:0-11:8]\"];n0->n1;n0->n2;n1[label=\"main[1:0-1:4]\"];n2[label=\"Let[1:8-11:7]\"];n2->n3;n2->n9;n3[label=\"Assign[1:12-1:32]\"];n3->n4;n3->n6;n4[label=\"R[1:12-1:15]\"];n4->n5;n5[label=\"x[1:14-1:15]\"];n6[label=\"Sendfrom:S[1:19-1:31]\"];n6[label=\"Sendto:R[1:19-1:31]\"];n6->n7;n7[label=\"S[1:23-1:26]\"];n7->n8;n8[label=\"3[1:25-1:26]\"];n9[label=\"If[3:0-11:7]\"];n9->n10;n9->n15;n9->n18;n10[label=\"R[3:3-3:10]\"];n10->n11;n11[label=\"BinOp[3:5-3:10]\"];n11->n12;n11->n13;n11->n14;n12[label=\"x[3:6-3:7]\"];n13[label=\"5[3:8-3:9]\"];n14[label=\">[3:7-3:8]\"];n15[label=\"Sync:R[L]->S[5:5-7:9]\"];n15->n16;n16[label=\"S[7:0-7:9]\"];n16->n17;n17[label=\"Hello[7:8-7:9]\"];n18[label=\"Sync:R[R]->S[9:5-11:7]\"];n18->n19;n19[label=\"S[11:0-11:7]\"];n19->n20;n20[label=\"Bye[11:6-11:7]\"];}"
let dot_1_pretty = 
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
let dot_2 = "digraphG{n0[label=\"Assign[1:0-6:51]\"];n0->n1;n0->n2;n1[label=\"main[1:0-1:4]\"];n2[label=\"If[2:4-6:50]\"];n2->n3;n2->n14;n2->n26;n3[label=\"R[2:7-2:20]\"];n3->n4;n4[label=\"BinOp[2:9-2:20]\"];n4->n5;n4->n9;n4->n13;n5[label=\"BinOp[2:10-2:13]\"];n5->n6;n5->n7;n5->n8;n6[label=\"3[2:10-2:11]\"];n7[label=\"5[2:12-2:13]\"];n8[label=\"+[2:11-2:12]\"];n9[label=\"BinOp[2:16-2:19]\"];n9->n10;n9->n11;n9->n12;n10[label=\"2[2:16-2:17]\"];n11[label=\"1[2:18-2:19]\"];n12[label=\"-[2:17-2:18]\"];n13[label=\">[2:14-2:15]\"];n14[label=\"Sync:R[L]->S[3:9-4:50]\"];n14->n15;n15[label=\"Let[4:5-4:50]\"];n15->n16;n15->n24;n16[label=\"Assign[4:9-4:38]\"];n16->n17;n16->n19;n17[label=\"R[4:9-4:14]\"];n17->n18;n18[label=\"res[4:11-4:14]\"];n19[label=\"Sendfrom:S[4:18-4:37]\"];n19[label=\"Sendto:R[4:18-4:37]\"];n19->n20;n20[label=\"S[4:22-4:32]\"];n20->n21;n21[label=\"Pair[4:24-4:32]\"];n21->n22;n21->n23;n22[label=\"1[4:25-4:26]\"];n23[label=\"true[4:27-4:31]\"];n24[label=\"R[4:42-4:50]\"];n24->n25;n25[label=\"Sent[4:49-4:50]\"];n26[label=\"Sync:R[R]->S[5:9-6:50]\"];n26->n27;n27[label=\"Let[6:5-6:50]\"];n27->n28;n27->n36;n28[label=\"Assign[6:9-6:39]\"];n28->n29;n28->n31;n29[label=\"R[6:9-6:14]\"];n29->n30;n30[label=\"res[6:11-6:14]\"];n31[label=\"Sendfrom:S[6:18-6:38]\"];n31[label=\"Sendto:R[6:18-6:38]\"];n31->n32;n32[label=\"S[6:22-6:33]\"];n32->n33;n33[label=\"Pair[6:24-6:33]\"];n33->n34;n33->n35;n34[label=\"0[6:25-6:26]\"];n35[label=\"false[6:27-6:32]\"];n36[label=\"R[6:43-6:50]\"];n36->n37;n37[label=\"why[6:49-6:50]\"];}"
let dot_2_pretty =
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

let dot_3_aaaahhhhh = "digraph G {\nn0 [label=\"Decl [1:0-1:10]\"];\nn0 -> n1;\nn0 -> n2;\nn1 [label=\"y [1:0-1:1]\"];\nn2 [label=\"P2 [1:3-1:9]\"];\nn2 -> n3;\nn3 [label=\"Int [1:6-1:9]\"];\n\nn4 [label=\"Assign [2:2-7:1]\"];\nn4 -> n5;\nn4 -> n6;\nn5 [label=\"y [2:2-2:3]\"];\nn6 [label=\"If [2:7-6:8]\"];\nn6 -> n7;\nn6 -> n12;\nn6 -> n15;\nn7 [label=\"P1 [2:10-2:18]\"];\nn7 -> n8;\nn8 [label=\"BinOp [2:13-2:18]\"];\nn8 -> n9;\nn8 -> n10;\nn8 -> n11;\nn9 [label=\"3 [2:14-2:15]\"];\nn10 [label=\"5 [2:16-2:17]\"];\nn11 [label=\"> [2:15-2:16]\"];\nn12 [label=\"Sync: P1[L] -> P2 [3:7-4:8]\"];\nn12 -> n13;\nn13 [label=\"P2 [4:4-4:8]\"];\nn13 -> n14;\nn14 [label=\"5 [4:7-4:8]\"];\nn15 [label=\"Sync: P1[R] -> P2 [5:7-6:8]\"];\nn15 -> n16;\nn16 [label=\"P2 [6:4-6:8]\"];\nn16 -> n17;\nn17 [label=\"9 [6:7-6:8]\"];\n\n}"
  let dot_3 =
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
  n17 [label=\"9 [6:7-6:8]\"];\n\
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

let dot_5 = "digraphG{n0[label=\"Assign[1:0-6:51]\"];n0->n1;n0->n2;n1[label=\"main[1:0-1:4]\"];n2[label=\"If[2:4-6:50]\"];n2->n3;n2->n14;n2->n26;n3[label=\"R[2:7-2:20]\"];n3->n4;n4[label=\"BinOp[2:9-2:20]\"];n4->n5;n4->n9;n4->n13;n5[label=\"BinOp[2:10-2:13]\"];n5->n6;n5->n7;n5->n8;n6[label=\"3[2:10-2:11]\"];n7[label=\"5[2:12-2:13]\"];n8[label=\"/[2:11-2:12]\"];n9[label=\"BinOp[2:16-2:19]\"];n9->n10;n9->n11;n9->n12;n10[label=\"2[2:16-2:17]\"];n11[label=\"1[2:18-2:19]\"];n12[label=\"*[2:17-2:18]\"];n13[label=\"<[2:14-2:15]\"];n14[label=\"Sync:R[L]->S[3:9-4:50]\"];n14->n15;n15[label=\"Let[4:5-4:50]\"];n15->n16;n15->n24;n16[label=\"Assign[4:9-4:38]\"];n16->n17;n16->n19;n17[label=\"R[4:9-4:14]\"];n17->n18;n18[label=\"res[4:11-4:14]\"];n19[label=\"Sendfrom:S[4:18-4:37]\"];n19[label=\"Sendto:R[4:18-4:37]\"];n19->n20;n20[label=\"S[4:22-4:32]\"];n20->n21;n21[label=\"Pair[4:24-4:32]\"];n21->n22;n21->n23;n22[label=\"1[4:25-4:26]\"];n23[label=\"true[4:27-4:31]\"];n24[label=\"R[4:42-4:50]\"];n24->n25;n25[label=\"Sent[4:49-4:50]\"];n26[label=\"Sync:R[R]->S[5:9-6:50]\"];n26->n27;n27[label=\"Let[6:5-6:50]\"];n27->n28;n27->n36;n28[label=\"Assign[6:9-6:39]\"];n28->n29;n28->n31;n29[label=\"R[6:9-6:14]\"];n29->n30;n30[label=\"res[6:11-6:14]\"];n31[label=\"Sendfrom:S[6:18-6:38]\"];n31[label=\"Sendto:R[6:18-6:38]\"];n31->n32;n32[label=\"S[6:22-6:33]\"];n32->n33;n33[label=\"Pair[6:24-6:33]\"];n33->n34;n33->n35;n34[label=\"0[6:25-6:26]\"];n35[label=\"false[6:27-6:32]\"];n36[label=\"R[6:43-6:50]\"];n36->n37;n37[label=\"why[6:49-6:50]\"];}"

let dot_5_pretty =
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

let dot_6 = "digraphG{n0[label=\"Assign[1:0-11:8]\"];n0->n1;n0->n2;n1[label=\"main[1:0-1:4]\"];n2[label=\"Let[1:8-11:7]\"];n2->n3;n2->n9;n3[label=\"Assign[1:12-1:32]\"];n3->n4;n3->n6;n4[label=\"R[1:12-1:15]\"];n4->n5;n5[label=\"x[1:14-1:15]\"];n6[label=\"Sendfrom:S[1:19-1:31]\"];n6[label=\"Sendto:R[1:19-1:31]\"];n6->n7;n7[label=\"S[1:23-1:26]\"];n7->n8;n8[label=\"3[1:25-1:26]\"];n9[label=\"If[3:0-11:7]\"];n9->n10;n9->n15;n9->n18;n10[label=\"R[3:3-3:10]\"];n10->n11;n11[label=\"BinOp[3:5-3:10]\"];n11->n12;n11->n13;n11->n14;n12[label=\"x[3:6-3:7]\"];n13[label=\"5[3:8-3:9]\"];n14[label=\"<[3:7-3:8]\"];n15[label=\"Sync:R[L]->S[5:5-7:9]\"];n15->n16;n16[label=\"S[7:0-7:9]\"];n16->n17;n17[label=\"Hello[7:8-7:9]\"];n18[label=\"Sync:R[R]->S[9:5-11:7]\"];n18->n19;n19[label=\"S[11:0-11:7]\"];n19->n20;n20[label=\"Bye[11:6-11:7]\"];}"

let pir_7 =
  "main := let R.x := [S] S.3 ~> R; in \n\n\
   if R.(x<=5) \n\n\
   then R[L] ~> S; \n\n\
   S.\"Hello\"\n\n\
   else R[R] ~> S; \n\n\
   S.\"Bye\";\n"
;;

let dot_8 = "digraphG{n0[label=\"Assign[1:0-11:8]\"];n0->n1;n0->n2;n1[label=\"main[1:0-1:4]\"];n2[label=\"Let[1:8-11:7]\"];n2->n3;n2->n9;n3[label=\"Assign[1:12-1:32]\"];n3->n4;n3->n6;n4[label=\"R[1:12-1:15]\"];n4->n5;n5[label=\"x[1:14-1:15]\"];n6[label=\"Sendfrom:S[1:19-1:31]\"];n6[label=\"Sendto:R[1:19-1:31]\"];n6->n7;n7[label=\"S[1:23-1:26]\"];n7->n8;n8[label=\"3[1:25-1:26]\"];n9[label=\"If[3:0-11:7]\"];n9->n10;n9->n15;n9->n18;n10[label=\"R[3:3-3:11]\"];n10->n11;n11[label=\"BinOp[3:5-3:11]\"];n11->n12;n11->n13;n11->n14;n12[label=\"x[3:6-3:7]\"];n13[label=\"5[3:9-3:10]\"];n14[label=\">=[3:7-3:9]\"];n15[label=\"Sync:R[L]->S[5:5-7:9]\"];n15->n16;n16[label=\"S[7:0-7:9]\"];n16->n17;n17[label=\"Hello[7:8-7:9]\"];n18[label=\"Sync:R[R]->S[9:5-11:7]\"];n18->n19;n19[label=\"S[11:0-11:7]\"];n19->n20;n20[label=\"Bye[11:6-11:7]\"];}"

let pir_8 =
  "main := let R.x := [S] S.3 ~> R; in \n\n\
   if R.(x>=5) \n\n\
   then R[L] ~> S; \n\n\
   S.\"Hello\"\n\n\
   else R[R] ~> S; \n\n\
   S.\"Bye\";\n"
;;

let dot_7 = "digraphG{n0[label=\"Assign[1:0-11:8]\"];n0->n1;n0->n2;n1[label=\"main[1:0-1:4]\"];n2[label=\"Let[1:8-11:7]\"];n2->n3;n2->n9;n3[label=\"Assign[1:12-1:32]\"];n3->n4;n3->n6;n4[label=\"R[1:12-1:15]\"];n4->n5;n5[label=\"x[1:14-1:15]\"];n6[label=\"Sendfrom:S[1:19-1:31]\"];n6[label=\"Sendto:R[1:19-1:31]\"];n6->n7;n7[label=\"S[1:23-1:26]\"];n7->n8;n8[label=\"3[1:25-1:26]\"];n9[label=\"If[3:0-11:7]\"];n9->n10;n9->n15;n9->n18;n10[label=\"R[3:3-3:11]\"];n10->n11;n11[label=\"BinOp[3:5-3:11]\"];n11->n12;n11->n13;n11->n14;n12[label=\"x[3:6-3:7]\"];n13[label=\"5[3:9-3:10]\"];n14[label=\"<=[3:7-3:9]\"];n15[label=\"Sync:R[L]->S[5:5-7:9]\"];n15->n16;n16[label=\"S[7:0-7:9]\"];n16->n17;n17[label=\"Hello[7:8-7:9]\"];n18[label=\"Sync:R[R]->S[9:5-11:7]\"];n18->n19;n19[label=\"S[11:0-11:7]\"];n19->n20;n20[label=\"Bye[11:6-11:7]\"];}"

let pir_9 =
  "main := let R.x := [S] S.3 ~> R; in \n\n\
   if R.(x=5) \n\n\
   then R[L] ~> S; \n\n\
   S.true\n\n\
   else R[R] ~> S; \n\n\
   S.false;\n"
;;

let dot_9 = "digraphG{n0[label=\"Assign[1:0-11:8]\"];n0->n1;n0->n2;n1[label=\"main[1:0-1:4]\"];n2[label=\"Let[1:8-11:7]\"];n2->n3;n2->n9;n3[label=\"Assign[1:12-1:32]\"];n3->n4;n3->n6;n4[label=\"R[1:12-1:15]\"];n4->n5;n5[label=\"x[1:14-1:15]\"];n6[label=\"Sendfrom:S[1:19-1:31]\"];n6[label=\"Sendto:R[1:19-1:31]\"];n6->n7;n7[label=\"S[1:23-1:26]\"];n7->n8;n8[label=\"3[1:25-1:26]\"];n9[label=\"If[3:0-11:7]\"];n9->n10;n9->n15;n9->n18;n10[label=\"R[3:3-3:10]\"];n10->n11;n11[label=\"BinOp[3:5-3:10]\"];n11->n12;n11->n13;n11->n14;n12[label=\"x[3:6-3:7]\"];n13[label=\"5[3:8-3:9]\"];n14[label=\"=[3:7-3:8]\"];n15[label=\"Sync:R[L]->S[5:5-7:6]\"];n15->n16;n16[label=\"S[7:0-7:6]\"];n16->n17;n17[label=\"true[7:2-7:6]\"];n18[label=\"Sync:R[R]->S[9:5-11:7]\"];n18->n19;n19[label=\"S[11:0-11:7]\"];n19->n20;n20[label=\"false[11:2-11:7]\"];}"

let pir_10 =
  "main := let R.x := [S] S.-3 ~> R; in \n\n\
   if R.(x!=5) \n\n\
   then R[L] ~> S; \n\n\
   S.true\n\n\
   else R[R] ~> S; \n\n\
   S.false;\n"
;;

let dot_10 = "digraphG{n0[label=\"Assign[1:0-11:8]\"];n0->n1;n0->n2;n1[label=\"main[1:0-1:4]\"];n2[label=\"Let[1:8-11:7]\"];n2->n3;n2->n11;n3[label=\"Assign[1:12-1:33]\"];n3->n4;n3->n6;n4[label=\"R[1:12-1:15]\"];n4->n5;n5[label=\"x[1:14-1:15]\"];n6[label=\"Sendfrom:S[1:19-1:32]\"];n6[label=\"Sendto:R[1:19-1:32]\"];n6->n7;n7[label=\"S[1:23-1:27]\"];n7->n8;n8[label=\"UnOp[1:25-1:27]\"];n8->n9;n8->n10;n9[label=\"3[1:26-1:27]\"];n10[label=\"-[1:25-1:26]\"];n11[label=\"If[3:0-11:7]\"];n11->n12;n11->n17;n11->n20;n12[label=\"R[3:3-3:11]\"];n12->n13;n13[label=\"BinOp[3:5-3:11]\"];n13->n14;n13->n15;n13->n16;n14[label=\"x[3:6-3:7]\"];n15[label=\"5[3:9-3:10]\"];n16[label=\"!=[3:7-3:9]\"];n17[label=\"Sync:R[L]->S[5:5-7:6]\"];n17->n18;n18[label=\"S[7:0-7:6]\"];n18->n19;n19[label=\"true[7:2-7:6]\"];n20[label=\"Sync:R[R]->S[9:5-11:7]\"];n20->n21;n21[label=\"S[11:0-11:7]\"];n21->n22;n22[label=\"false[11:2-11:7]\"];}"


(* let pir_11 = 
  "main := 
let LPF.x := LPF.0; in
let LPF.y := LPF.0; in
let AGC.x := AGC.0; in
let AGC.y := AGC.0; in

if LPF.(x != 0)
then LPF[L] ~> AGC;
let LPF.x := [AGC] AGC.x ~> LPF; in
  if AGC.(y != 0)
  then AGC[L] ~> LPF;
  let LPF.y := [AGC] AGC.y ~> LPF; in
  LPF.((x+y)/2)
  else AGC[R] ~> LPF;
  LPF.((x+y)/2)
  else LPF[R] ~> AGC;
  LPF.((x+y)/2)
  ;"

  let dot_11 = "" *)

  let pir_12 =
    "main := let R.x := [S] S.true ~> R; in \n\n\
     if R.(x && true) \n\n\
     then R[L] ~> S; \n\n\
     S.\"Hello\"\n\n\
     else R[R] ~> S; \n\n\
     S.\"Bye\";\n"
  ;;

  let dot_12 = "digraphG{n0[label=\"Assign[1:0-11:8]\"];n0->n1;n0->n2;n1[label=\"main[1:0-1:4]\"];n2[label=\"Let[1:8-11:7]\"];n2->n3;n2->n9;n3[label=\"Assign[1:12-1:35]\"];n3->n4;n3->n6;n4[label=\"R[1:12-1:15]\"];n4->n5;n5[label=\"x[1:14-1:15]\"];n6[label=\"Sendfrom:S[1:19-1:34]\"];n6[label=\"Sendto:R[1:19-1:34]\"];n6->n7;n7[label=\"S[1:23-1:29]\"];n7->n8;n8[label=\"true[1:25-1:29]\"];n9[label=\"If[3:0-11:7]\"];n9->n10;n9->n15;n9->n18;n10[label=\"R[3:3-3:16]\"];n10->n11;n11[label=\"BinOp[3:5-3:16]\"];n11->n12;n11->n13;n11->n14;n12[label=\"x[3:6-3:7]\"];n13[label=\"true[3:11-3:15]\"];n14[label=\"&&[3:8-3:10]\"];n15[label=\"Sync:R[L]->S[5:5-7:9]\"];n15->n16;n16[label=\"S[7:0-7:9]\"];n16->n17;n17[label=\"Hello[7:8-7:9]\"];n18[label=\"Sync:R[R]->S[9:5-11:7]\"];n18->n19;n19[label=\"S[11:0-11:7]\"];n19->n20;n20[label=\"Bye[11:6-11:7]\"];}"

  let pir_13 =
    "main := let R.x := [S] S.true ~> R; in \n\n\
     if R.(x||true) \n\n\
     then R[L] ~> S; \n\n\
     S.\"Hello\"\n\n\
     else R[R] ~> S; \n\n\
     S.\"Bye\";\n"
  ;;

  let dot_13 = "digraphG{n0[label=\"Assign[1:0-11:8]\"];n0->n1;n0->n2;n1[label=\"main[1:0-1:4]\"];n2[label=\"Let[1:8-11:7]\"];n2->n3;n2->n9;n3[label=\"Assign[1:12-1:35]\"];n3->n4;n3->n6;n4[label=\"R[1:12-1:15]\"];n4->n5;n5[label=\"x[1:14-1:15]\"];n6[label=\"Sendfrom:S[1:19-1:34]\"];n6[label=\"Sendto:R[1:19-1:34]\"];n6->n7;n7[label=\"S[1:23-1:29]\"];n7->n8;n8[label=\"true[1:25-1:29]\"];n9[label=\"If[3:0-11:7]\"];n9->n10;n9->n15;n9->n18;n10[label=\"R[3:3-3:14]\"];n10->n11;n11[label=\"BinOp[3:5-3:14]\"];n11->n12;n11->n13;n11->n14;n12[label=\"x[3:6-3:7]\"];n13[label=\"true[3:9-3:13]\"];n14[label=\"||[3:7-3:9]\"];n15[label=\"Sync:R[L]->S[5:5-7:9]\"];n15->n16;n16[label=\"S[7:0-7:9]\"];n16->n17;n17[label=\"Hello[7:8-7:9]\"];n18[label=\"Sync:R[R]->S[9:5-11:7]\"];n18->n19;n19[label=\"S[11:0-11:7]\"];n19->n20;n20[label=\"Bye[11:6-11:7]\"];}"

  let pir_14 =
      "y: P2.string;
      y := if P1.(\"hi\" != \"bye\")
      then P1[L] ~> P2;
        P2.\"hello\"
      else P1[R] ~> P2;
        P2.\"bye\"
    ;"

  let dot_14 = "digraphG{n0[label=\"Decl[1:0-1:13]\"];n0->n1;n0->n2;n1[label=\"y[1:0-1:1]\"];n2[label=\"P2[1:3-1:12]\"];n2->n3;n3[label=\"String[1:6-1:12]\"];n4[label=\"Assign[2:6-7:5]\"];n4->n5;n4->n6;n5[label=\"y[2:6-2:7]\"];n6[label=\"If[2:11-6:16]\"];n6->n7;n6->n12;n6->n15;n7[label=\"P1[2:14-2:32]\"];n7->n8;n8[label=\"BinOp[2:17-2:32]\"];n8->n9;n8->n10;n8->n11;n9[label=\"hi[2:21-2:22]\"];n10[label=\"bye[2:30-2:31]\"];n11[label=\"!=[2:23-2:25]\"];n12[label=\"Sync:P1[L]->P2[3:11-4:18]\"];n12->n13;n13[label=\"P2[4:8-4:18]\"];n13->n14;n14[label=\"hello[4:17-4:18]\"];n15[label=\"Sync:P1[R]->P2[5:11-6:16]\"];n15->n16;n16[label=\"P2[6:8-6:16]\"];n16->n17;n17[label=\"bye[6:15-6:16]\"];}"
    ;;

  let pir_15 =
    "main :=
      if R.(not true = true)
      then R[L] ~> S;
        let R.res := [S] S.(1,true) ~> R; in R.\"Sent\"
      else R[R] ~> S;
        let R.res := [S] S.(0,false) ~> R; in R.\"why\";"
  ;;

  let dot_15 = "digraphG{n0[label=\"Assign[1:0-6:54]\"];n0->n1;n0->n2;n1[label=\"main[1:0-1:4]\"];n2[label=\"If[2:6-6:53]\"];n2->n3;n2->n10;n2->n22;n3[label=\"R[2:9-2:28]\"];n3->n4;n4[label=\"BinOp[2:11-2:28]\"];n4->n5;n4->n8;n4->n9;n5[label=\"UnOp[2:12-2:20]\"];n5->n6;n5->n7;n6[label=\"true[2:16-2:20]\"];n7[label=\"not[2:12-2:15]\"];n8[label=\"true[2:23-2:27]\"];n9[label=\"=[2:21-2:22]\"];n10[label=\"Sync:R[L]->S[3:11-4:53]\"];n10->n11;n11[label=\"Let[4:8-4:53]\"];n11->n12;n11->n20;n12[label=\"Assign[4:12-4:41]\"];n12->n13;n12->n15;n13[label=\"R[4:12-4:17]\"];n13->n14;n14[label=\"res[4:14-4:17]\"];n15[label=\"Sendfrom:S[4:21-4:40]\"];n15[label=\"Sendto:R[4:21-4:40]\"];n15->n16;n16[label=\"S[4:25-4:35]\"];n16->n17;n17[label=\"Pair[4:27-4:35]\"];n17->n18;n17->n19;n18[label=\"1[4:28-4:29]\"];n19[label=\"true[4:30-4:34]\"];n20[label=\"R[4:45-4:53]\"];n20->n21;n21[label=\"Sent[4:52-4:53]\"];n22[label=\"Sync:R[R]->S[5:11-6:53]\"];n22->n23;n23[label=\"Let[6:8-6:53]\"];n23->n24;n23->n32;n24[label=\"Assign[6:12-6:42]\"];n24->n25;n24->n27;n25[label=\"R[6:12-6:17]\"];n25->n26;n26[label=\"res[6:14-6:17]\"];n27[label=\"Sendfrom:S[6:21-6:41]\"];n27[label=\"Sendto:R[6:21-6:41]\"];n27->n28;n28[label=\"S[6:25-6:36]\"];n28->n29;n29[label=\"Pair[6:27-6:36]\"];n29->n30;n29->n31;n30[label=\"0[6:28-6:29]\"];n31[label=\"false[6:30-6:35]\"];n32[label=\"R[6:46-6:53]\"];n32->n33;n33[label=\"why[6:52-6:53]\"];}"
;;
let pir_16 =
  "y: P2.bool;
  y := if P1.(true != false)
  then P1[L] ~> P2;
    P2.\"hello\"
  else P1[R] ~> P2;
    P2.\"bye\"
;"

let dot_16 = "digraphG{n0[label=\"Decl[1:0-1:11]\"];n0->n1;n0->n2;n1[label=\"y[1:0-1:1]\"];n2[label=\"P2[1:3-1:10]\"];n2->n3;n3[label=\"Bool[1:6-1:10]\"];n4[label=\"Assign[2:2-7:1]\"];n4->n5;n4->n6;n5[label=\"y[2:2-2:3]\"];n6[label=\"If[2:7-6:12]\"];n6->n7;n6->n12;n6->n15;n7[label=\"P1[2:10-2:28]\"];n7->n8;n8[label=\"BinOp[2:13-2:28]\"];n8->n9;n8->n10;n8->n11;n9[label=\"true[2:14-2:18]\"];n10[label=\"false[2:22-2:27]\"];n11[label=\"!=[2:19-2:21]\"];n12[label=\"Sync:P1[L]->P2[3:7-4:14]\"];n12->n13;n13[label=\"P2[4:4-4:14]\"];n13->n14;n14[label=\"hello[4:13-4:14]\"];n15[label=\"Sync:P1[R]->P2[5:7-6:12]\"];n15->n16;n16[label=\"P2[6:4-6:12]\"];n16->n17;n17[label=\"bye[6:11-6:12]\"];}"

let pir_17 =
  "y: P2.unit;
  y := if P1.(true != false)
  then P1[L] ~> P2;
    P2.\"hi\"
  else P1[R] ~> P2;
    P2.\"bye\"
;"

let dot_17 = "digraphG{n0[label=\"Decl[1:0-1:11]\"];n0->n1;n0->n2;n1[label=\"y[1:0-1:1]\"];n2[label=\"P2[1:3-1:10]\"];n2->n3;n3[label=\"Unit[1:6-1:10]\"];n4[label=\"Assign[2:2-7:1]\"];n4->n5;n4->n6;n5[label=\"y[2:2-2:3]\"];n6[label=\"If[2:7-6:12]\"];n6->n7;n6->n12;n6->n15;n7[label=\"P1[2:10-2:28]\"];n7->n8;n8[label=\"BinOp[2:13-2:28]\"];n8->n9;n8->n10;n8->n11;n9[label=\"true[2:14-2:18]\"];n10[label=\"false[2:22-2:27]\"];n11[label=\"!=[2:19-2:21]\"];n12[label=\"Sync:P1[L]->P2[3:7-4:11]\"];n12->n13;n13[label=\"P2[4:4-4:11]\"];n13->n14;n14[label=\"hi[4:10-4:11]\"];n15[label=\"Sync:P1[R]->P2[5:7-6:12]\"];n15->n16;n16[label=\"P2[6:4-6:12]\"];n16->n17;n17[label=\"bye[6:11-6:12]\"];}"

let pir_18 =
  "main := 
  helper R.3
;

helper a := if R.(a > 2-1)
    then R[L] ~> S;
  	  let R.res := [S] S.(1,true) ~> R; in R.\"Sent\"
    else R[R] ~> S;
  	  let R.res := [S] S.(0,false) ~> R; in R.\"why\"
;
"

let dot_18 = "digraphG{n0[label=\"Assign[1:0-3:1]\"];n0->n1;n0->n2;n1[label=\"main[1:0-1:4]\"];n2[label=\"FunApp[2:2-2:12]\"];n2->n3;n2->n4;n3[label=\"helper[2:2-2:8]\"];n4[label=\"R[2:9-2:12]\"];n4->n5;n5[label=\"3[2:11-2:12]\"];n6[label=\"Assign[5:0-10:1]\"];n6->n7;n6->n8;n6->n9;n7[label=\"helper[5:0-5:6]\"];n8[label=\"a[5:7-5:8]\"];n9[label=\"If[5:12-9:50]\"];n9->n10;n9->n18;n9->n30;n10[label=\"R[5:15-5:26]\"];n10->n11;n11[label=\"BinOp[5:17-5:26]\"];n11->n12;n11->n13;n11->n17;n12[label=\"a[5:18-5:19]\"];n13[label=\"BinOp[5:22-5:25]\"];n13->n14;n13->n15;n13->n16;n14[label=\"2[5:22-5:23]\"];n15[label=\"1[5:24-5:25]\"];n16[label=\"-[5:23-5:24]\"];n17[label=\">[5:20-5:21]\"];n18[label=\"Sync:R[L]->S[6:9-7:50]\"];n18->n19;n19[label=\"Let[7:5-7:50]\"];n19->n20;n19->n28;n20[label=\"Assign[7:9-7:38]\"];n20->n21;n20->n23;n21[label=\"R[7:9-7:14]\"];n21->n22;n22[label=\"res[7:11-7:14]\"];n23[label=\"Sendfrom:S[7:18-7:37]\"];n23[label=\"Sendto:R[7:18-7:37]\"];n23->n24;n24[label=\"S[7:22-7:32]\"];n24->n25;n25[label=\"Pair[7:24-7:32]\"];n25->n26;n25->n27;n26[label=\"1[7:25-7:26]\"];n27[label=\"true[7:27-7:31]\"];n28[label=\"R[7:42-7:50]\"];n28->n29;n29[label=\"Sent[7:49-7:50]\"];n30[label=\"Sync:R[R]->S[8:9-9:50]\"];n30->n31;n31[label=\"Let[9:5-9:50]\"];n31->n32;n31->n40;n32[label=\"Assign[9:9-9:39]\"];n32->n33;n32->n35;n33[label=\"R[9:9-9:14]\"];n33->n34;n34[label=\"res[9:11-9:14]\"];n35[label=\"Sendfrom:S[9:18-9:38]\"];n35[label=\"Sendto:R[9:18-9:38]\"];n35->n36;n36[label=\"S[9:22-9:33]\"];n36->n37;n37[label=\"Pair[9:24-9:33]\"];n37->n38;n37->n39;n38[label=\"0[9:25-9:26]\"];n39[label=\"false[9:27-9:32]\"];n40[label=\"R[9:43-9:50]\"];n40->n41;n41[label=\"why[9:49-9:50]\"];}"

let pir_19 =
  "main := let x := P2.(1,2); in\n\n\
  if P1.(true != false)\n\n\
  then P1[L] ~> P2;\n\n\
    P2.(fst x)\n\n\
  else P1[R] ~> P2;\n\n\
    P2.(snd x)\n\n\
;"

let dot_19 = "digraphG{n0[label=\"Assign[1:0-13:1]\"];n0->n1;n0->n2;n1[label=\"main[1:0-1:4]\"];n2[label=\"Let[1:8-11:10]\"];n2->n3;n2->n9;n3[label=\"Assign[1:12-1:26]\"];n3->n4;n3->n5;n4[label=\"x[1:12-1:13]\"];n5[label=\"P2[1:17-1:25]\"];n5->n6;n6[label=\"Pair[1:20-1:25]\"];n6->n7;n6->n8;n7[label=\"1[1:21-1:22]\"];n8[label=\"2[1:23-1:24]\"];n9[label=\"If[3:0-11:10]\"];n9->n10;n9->n15;n9->n19;n10[label=\"P1[3:3-3:21]\"];n10->n11;n11[label=\"BinOp[3:6-3:21]\"];n11->n12;n11->n13;n11->n14;n12[label=\"true[3:7-3:11]\"];n13[label=\"false[3:15-3:20]\"];n14[label=\"!=[3:12-3:14]\"];n15[label=\"Sync:P1[L]->P2[5:5-7:10]\"];n15->n16;n16[label=\"P2[7:0-7:10]\"];n16->n17;n17[label=\"Fst[7:3-7:10]\"];n17->n18;n18[label=\"x[7:8-7:9]\"];n19[label=\"Sync:P1[R]->P2[9:5-11:10]\"];n19->n20;n20[label=\"P2[11:0-11:10]\"];n20->n21;n21[label=\"Snd[11:3-11:10]\"];n21->n22;n22[label=\"x[11:8-11:9]\"];}"

let pir_20 =
  "main := let x := P2.(1,2); in\n\n\
  if P1.(true != false)\n\n\
  then P1[L] ~> P2;\n\n\
    P2.(snd x)\n\n\
  else P1[R] ~> P2;\n\n\
    P2.(fst x)\n\n\
;"

let dot_20 = "digraphG{n0[label=\"Assign[1:0-13:1]\"];n0->n1;n0->n2;n1[label=\"main[1:0-1:4]\"];n2[label=\"Let[1:8-11:10]\"];n2->n3;n2->n9;n3[label=\"Assign[1:12-1:26]\"];n3->n4;n3->n5;n4[label=\"x[1:12-1:13]\"];n5[label=\"P2[1:17-1:25]\"];n5->n6;n6[label=\"Pair[1:20-1:25]\"];n6->n7;n6->n8;n7[label=\"1[1:21-1:22]\"];n8[label=\"2[1:23-1:24]\"];n9[label=\"If[3:0-11:10]\"];n9->n10;n9->n15;n9->n19;n10[label=\"P1[3:3-3:21]\"];n10->n11;n11[label=\"BinOp[3:6-3:21]\"];n11->n12;n11->n13;n11->n14;n12[label=\"true[3:7-3:11]\"];n13[label=\"false[3:15-3:20]\"];n14[label=\"!=[3:12-3:14]\"];n15[label=\"Sync:P1[L]->P2[5:5-7:10]\"];n15->n16;n16[label=\"P2[7:0-7:10]\"];n16->n17;n17[label=\"Snd[7:3-7:10]\"];n17->n18;n18[label=\"x[7:8-7:9]\"];n19[label=\"Sync:P1[R]->P2[9:5-11:10]\"];n19->n20;n20[label=\"P2[11:0-11:10]\"];n20->n21;n21[label=\"Fst[11:3-11:10]\"];n21->n22;n22[label=\"x[11:8-11:9]\"];}"

let pir_21 =
  "main := let x := P2.(1,2); in\n\n\
  if P1.(true != false)\n\n\
  then P1[L] ~> P2;\n\n\
    P2.(left x)\n\n\
  else P1[R] ~> P2;\n\n\
    P2.(right x)\n\n\
;"

let dot_21 = "digraphG{n0[label=\"Assign[1:0-13:1]\"];n0->n1;n0->n2;n1[label=\"main[1:0-1:4]\"];n2[label=\"Let[1:8-11:12]\"];n2->n3;n2->n9;n3[label=\"Assign[1:12-1:26]\"];n3->n4;n3->n5;n4[label=\"x[1:12-1:13]\"];n5[label=\"P2[1:17-1:25]\"];n5->n6;n6[label=\"Pair[1:20-1:25]\"];n6->n7;n6->n8;n7[label=\"1[1:21-1:22]\"];n8[label=\"2[1:23-1:24]\"];n9[label=\"If[3:0-11:12]\"];n9->n10;n9->n15;n9->n19;n10[label=\"P1[3:3-3:21]\"];n10->n11;n11[label=\"BinOp[3:6-3:21]\"];n11->n12;n11->n13;n11->n14;n12[label=\"true[3:7-3:11]\"];n13[label=\"false[3:15-3:20]\"];n14[label=\"!=[3:12-3:14]\"];n15[label=\"Sync:P1[L]->P2[5:5-7:11]\"];n15->n16;n16[label=\"P2[7:0-7:11]\"];n16->n17;n17[label=\"Left[7:3-7:11]\"];n17->n18;n18[label=\"x[7:9-7:10]\"];n19[label=\"Sync:P1[R]->P2[9:5-11:12]\"];n19->n20;n20[label=\"P2[11:0-11:12]\"];n20->n21;n21[label=\"Right[11:3-11:12]\"];n21->n22;n22[label=\"x[11:10-11:11]\"];}"

let pir_22 =
  "main := let x := P2.(1,2); in\n\n\
  if P1.(true != false)\n\n\
  then P1[L] ~> P2;\n\n\
    P2.(right x)\n\n\
  else P1[R] ~> P2;\n\n\
    P2.(left x)\n\n\
;"

let dot_22 = "digraphG{n0[label=\"Assign[1:0-13:1]\"];n0->n1;n0->n2;n1[label=\"main[1:0-1:4]\"];n2[label=\"Let[1:8-11:11]\"];n2->n3;n2->n9;n3[label=\"Assign[1:12-1:26]\"];n3->n4;n3->n5;n4[label=\"x[1:12-1:13]\"];n5[label=\"P2[1:17-1:25]\"];n5->n6;n6[label=\"Pair[1:20-1:25]\"];n6->n7;n6->n8;n7[label=\"1[1:21-1:22]\"];n8[label=\"2[1:23-1:24]\"];n9[label=\"If[3:0-11:11]\"];n9->n10;n9->n15;n9->n19;n10[label=\"P1[3:3-3:21]\"];n10->n11;n11[label=\"BinOp[3:6-3:21]\"];n11->n12;n11->n13;n11->n14;n12[label=\"true[3:7-3:11]\"];n13[label=\"false[3:15-3:20]\"];n14[label=\"!=[3:12-3:14]\"];n15[label=\"Sync:P1[L]->P2[5:5-7:12]\"];n15->n16;n16[label=\"P2[7:0-7:12]\"];n16->n17;n17[label=\"Right[7:3-7:12]\"];n17->n18;n18[label=\"x[7:10-7:11]\"];n19[label=\"Sync:P1[R]->P2[9:5-11:11]\"];n19->n20;n20[label=\"P2[11:0-11:11]\"];n20->n21;n21[label=\"Left[11:3-11:11]\"];n21->n22;n22[label=\"x[11:9-11:10]\"];}"

let pir_23 =
  "main := let x := P2.(); in\n\n\
  if P1.(true != false)\n\n\
  then P1[L] ~> P2;\n\n\
    ()\n\n\
  else P1[R] ~> P2;\n\n\
    ()\n\n\
;"
;;

let dot_23 = "digraphG{n0[label=\"Assign[1:0-13:1]\"];n0->n1;n0->n2;n1[label=\"main[1:0-1:4]\"];n2[label=\"Let[1:8-11:2]\"];n2->n3;n2->n7;n3[label=\"Assign[1:12-1:23]\"];n3->n4;n3->n5;n4[label=\"x[1:12-1:13]\"];n5[label=\"P2[1:17-1:22]\"];n5->n6;n6[label=\"()[1:20-1:22]\"];n7[label=\"If[3:0-11:2]\"];n7->n8;n7->n13;n7->n15;n8[label=\"P1[3:3-3:21]\"];n8->n9;n9[label=\"BinOp[3:6-3:21]\"];n9->n10;n9->n11;n9->n12;n10[label=\"true[3:7-3:11]\"];n11[label=\"false[3:15-3:20]\"];n12[label=\"!=[3:12-3:14]\"];n13[label=\"Sync:P1[L]->P2[5:5-7:2]\"];n13->n14;n14[label=\"()[7:0-7:2]\"];n15[label=\"Sync:P1[R]->P2[9:5-11:2]\"];n15->n16;n16[label=\"()[11:0-11:2]\"];}"

let pir_24 =
  "main :=\n\n\
  let P1.x := P2.6; in\n\n\
  match P1.x with\n\n\
  |P2.0 -> P1.\"Zero\"\n\n\
  |P2.1 -> P1.\"One\"\n\n\ 
  |_ -> P1.\"Other\"\n\n\
;"
let dot_24 = "digraphG{n0[label=\"Assign[1:0-14:1]\"];n0->n1;n0->n2;n1[label=\"main[1:0-1:4]\"];n2[label=\"Let[3:0-12:18]\"];n2->n3;n2->n8;n3[label=\"Assign[3:4-3:17]\"];n3->n4;n3->n6;n4[label=\"P1[3:4-3:8]\"];n4->n5;n5[label=\"x[3:7-3:8]\"];n6[label=\"P2[3:12-3:16]\"];n6->n7;n7[label=\"6[3:15-3:16]\"];n8[label=\"Match[5:0-12:18]\"];n8->n9;n8->n11n16n21;n9[label=\"P1[5:6-5:10]\"];n9->n10;n10[label=\"x[5:9-5:10]\"];n11[label=\"Case\"];n11->n12;n11->n14;n12[label=\"P2[7:1-7:5]\"];n12->n13;n13[label=\"0[7:4-7:5]\"];n14[label=\"P1[7:9-7:18]\"];n14->n15;n15[label=\"Zero[7:17-7:18]\"];n16[label=\"Case\"];n16->n17;n16->n19;n17[label=\"P2[9:1-9:5]\"];n17->n18;n18[label=\"1[9:4-9:5]\"];n19[label=\"P1[9:9-9:17]\"];n19->n20;n20[label=\"One[9:16-9:17]\"];n21[label=\"Case\"];n21->n22;n21->n23;n22[label=\"Default[12:3-12:4]\"];n23[label=\"P1[12:8-12:18]\"];n23->n24;n24[label=\"Other[12:17-12:18]\"];}"

let pir_25 =
  "main :=
  let P1.x := P1.6; in
  let P1.y :=
  P1.(match x with
  |0 -> \"Zero\"
  |1 -> \"One\"
  |_ -> \"Other\"); in
P1.y
;"

let dot_25 = "digraphG{n0[label=\"Assign[1:0-9:1]\"];n0->n1;n0->n2;n1[label=\"main[1:0-1:4]\"];n2[label=\"Let[2:2-8:4]\"];n2->n3;n2->n8;n3[label=\"Assign[2:6-2:19]\"];n3->n4;n3->n6;n4[label=\"P1[2:6-2:10]\"];n4->n5;n5[label=\"x[2:9-2:10]\"];n6[label=\"P1[2:14-2:18]\"];n6->n7;n7[label=\"6[2:17-2:18]\"];n8[label=\"Let[3:2-8:4]\"];n8->n9;n8->n24;n9[label=\"Assign[3:6-7:17]\"];n9->n10;n9->n12;n10[label=\"P1[3:6-3:10]\"];n10->n11;n11[label=\"y[3:9-3:10]\"];n12[label=\"P1[4:2-7:16]\"];n12->n13;n13[label=\"Match[4:5-7:16]\"];n13->n14;n13->n15n18n21;n14[label=\"x[4:12-4:13]\"];n15[label=\"Case\"];n15->n16;n15->n17;n16[label=\"0[5:3-5:4]\"];n17[label=\"Zero[5:13-5:14]\"];n18[label=\"Case\"];n18->n19;n18->n20;n19[label=\"1[6:3-6:4]\"];n20[label=\"One[6:12-6:13]\"];n21[label=\"Case\"];n21->n22;n21->n23;n22[label=\"Default[7:3-7:4]\"];n23[label=\"Other[7:14-7:15]\"];n24[label=\"P1[8:0-8:4]\"];n24->n25;n25[label=\"y[8:3-8:4]\"];}"