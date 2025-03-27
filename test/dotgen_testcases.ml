
let pir_1 =
  "main := let R.x := S.3 ~> R; in 
  if R.(x>5) 
  then R[L] ~> S;
       S.\"Hello\"
  else R[R] ~> S;
       S.\"Bye\";"
;;

let dot_1 =
  digraph Example2 {
    a[label=Assign]
    b[label=main]
    c[label=Let]
    d[label=Assign]
    e[label="R."]
    f[label="Send: R."]
    g[label=x]
    h[label="S."]
    i[label=3]
    j[label=If]
    k[label="R."]
    l[label="Send: S."]
    m[label="S."]
    n[label="Send: S."]
    o[label="S."]
    p[label=BinOp]
    q[label=x]
    r[label=5]
    s[label=">"]
    t[label="R[L]"]
    u[label="\"Hello\""]
    v[label="R[R]"]
    w[label="\"Bye\""]
    
    a -> {b c};
    c -> {d j};
    d -> {e f};
    e -> g;
    f -> h -> i;
    j -> {k l m n o};
    k -> p -> {q r s};
    l -> t;
    m -> u;
    n -> v;
    o -> w;
}
;;

let pir_2 =
  "main :=
    if R.(3+5 > 2-1)
    then R[L] ~> S;
  	  let R.res := S.(1,true) ~> R; in R.\"Sent\"
    else R[R] ~> S;
  	  let R.res := S.(0,false) ~> R; in R.\"why\";"
;;

let dot_2 =
  digraph Example2 {
    a[label=Assign];
    b[label=main];
    c[label=If];
    d[label="R."];
    e[label=Let];
    f[label=Let];
    g[label=BinOp];
    h[label=BinOp];
    i[label=BinOp];
    j[label=">"];
    k[label=3];
    l[label=5];
    m[label="+"];
    n[label=2];
    o[label=1];
    p[label="-"];
    q[label=Assign];
    r[label="R."];
    s[label="R."];
    t[label="Send: R"];
    u[label=Res];
    v[label=Pair]; //check
    w[label=1];
    x[label=true];
    y[label="\"Why\""];
    z[label=Assign];
    aa[label="R."];
    ab[label="R."];
    ac[label="Send: R"];
    ad[label=Res];
    ae[label=Pair]; //check
    af[label=0];
    ag[label=false];
    ah[label="\"Sent\""];
    
    a -> {b c};
    c -> {d e f};
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
}
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

let dot_3 =
  digraph Example2 {
    a[label=Assign];
    b[label="y"];
    c[label="P2."];
    d[label=Assign];
    e[label=y];
    f[label=If];
    g[label="P1."];
    h[label="Send: P2."];
    i[label="P2."];
    j[label="Send: P2."];
    k[label="P2."];
    l[label=BinOp];
    m[label=3];
    n[label=5];
    o[label=">"];
    p[label="P1[L]"];
    q[label=5];
    r[label="P1[R]"];
    s[label=9];
    t[label=int];
    
    a -> {b c};
    b -> d;
    d -> {e f}; 
    f -> {g h i j k};
    g -> l;
    l -> {m n o};
    h -> p;
    i -> q;
    j -> r;
    k -> s;
    c -> t;
}
;;


let pir_4 =
  "y:= let P.y := y; in
	if P.(y > 3) then
		P.(1)
	else 
		let P2.a := P1.(z) ~> P2; in
	y;"
;;

let dot_4 =
  digraph Example4 {
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
    o[label=">"];
    p[label=1];
    q[label=Assign];
    r[label=y];
    s[label=P2];
    t[label="Send: P2"];
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
}
;;