let exf0 = 
  "main := let R.x := [F] F.(6.5) ~> R; in\n\n
  R.x;"
;;

let exf1 = "main :=
  let
    R.x := [S] S.(3.2) ~> R;
  in
    if
      R.(x > 5.4)
    then
      R[L] ~> S; S.(\"Hello\")
    else
      R[R] ~> S; S.(\"Bye\");
";;

let exf2 = 
  "main :=
if R.(3.5 +. 5.5 > 2.1 -. 1.1)
then R[L] ~> S;
  	 let R.res := [S] S.(1,true) ~> R; in R.\"Sent\"
else R[R] ~> S;
  	 let R.res := [S] S.(0,false) ~> R; in R.\"why\"
;";;

let exf3 =
  "main :=
if R.(3.5 *. 5.5 > 2.1 /. 1.1)
then R[L] ~> S;
  	 let R.res := [S] S.\"Hello\" ~> R; in R.\"Sent\"
else R[R] ~> S;
  	 let R.res := [S] S.\"Bye\" ~> R; in R.\"why\"
;"

let dot0 = "digraphG{n0[label=\"Assign[1:0-4:6]\"];n0->n1;n0->n2;n1[label=\"main[1:0-1:4]\"];n2[label=\"Let[1:8-4:5]\"];n2->n3;n2->n9;n3[label=\"Assign[1:12-1:36]\"];n3->n4;n3->n6;n4[label=\"R[1:12-1:15]\"];n4->n5;n5[label=\"x[1:14-1:15]\"];n6[label=\"Sendfrom:F[1:19-1:35]\"];n6[label=\"Sendto:R[1:19-1:35]\"];n6->n7;n7[label=\"F[1:23-1:30]\"];n7->n8;n8[label=\"6.5[1:26-1:29]\"];n9[label=\"R[4:2-4:5]\"];n9->n10;n10[label=\"x[4:4-4:5]\"];}"

let dot1 = "digraphG{n0[label=\"Assign[1:0-10:27]\"];n0->n1;n0->n2;n1[label=\"main[1:0-1:4]\"];n2[label=\"Let[2:2-10:26]\"];n2->n3;n2->n9;n3[label=\"Assign[3:4-3:28]\"];n3->n4;n3->n6;n4[label=\"R[3:4-3:7]\"];n4->n5;n5[label=\"x[3:6-3:7]\"];n6[label=\"Sendfrom:S[3:11-3:27]\"];n6[label=\"Sendto:R[3:11-3:27]\"];n6->n7;n7[label=\"S[3:15-3:22]\"];n7->n8;n8[label=\"3.2[3:18-3:21]\"];n9[label=\"If[5:4-10:26]\"];n9->n10;n9->n15;n9->n18;n10[label=\"R[6:6-6:17]\"];n10->n11;n11[label=\"BinOp[6:8-6:17]\"];n11->n12;n11->n13;n11->n14;n12[label=\"x[6:9-6:10]\"];n13[label=\"5.4[6:13-6:16]\"];n14[label=\">[6:11-6:12]\"];n15[label=\"Sync:R[L]->S[8:6-8:28]\"];n15->n16;n16[label=\"S[8:17-8:28]\"];n16->n17;n17[label=\"Hello[8:26-8:27]\"];n18[label=\"Sync:R[R]->S[10:6-10:26]\"];n18->n19;n19[label=\"S[10:17-10:26]\"];n19->n20;n20[label=\"Bye[10:24-10:25]\"];}
"

let dot2 = "digraphG{n0[label=\"Assign[1:0-7:1]\"];n0->n1;n0->n2;n1[label=\"main[1:0-1:4]\"];n2[label=\"If[2:0-6:49]\"];n2->n3;n2->n14;n2->n26;n3[label=\"R[2:3-2:30]\"];n3->n4;n4[label=\"BinOp[2:5-2:30]\"];n4->n5;n4->n9;n4->n13;n5[label=\"BinOp[2:6-2:16]\"];n5->n6;n5->n7;n5->n8;n6[label=\"3.5[2:6-2:9]\"];n7[label=\"5.5[2:13-2:16]\"];n8[label=\"+.[2:10-2:12]\"];n9[label=\"BinOp[2:19-2:29]\"];n9->n10;n9->n11;n9->n12;n10[label=\"2.1[2:19-2:22]\"];n11[label=\"1.1[2:26-2:29]\"];n12[label=\"-.[2:23-2:25]\"];n13[label=\">[2:17-2:18]\"];n14[label=\"Sync:R[L]->S[3:5-4:49]\"];n14->n15;n15[label=\"Let[4:4-4:49]\"];n15->n16;n15->n24;n16[label=\"Assign[4:8-4:37]\"];n16->n17;n16->n19;n17[label=\"R[4:8-4:13]\"];n17->n18;n18[label=\"res[4:10-4:13]\"];n19[label=\"Sendfrom:S[4:17-4:36]\"];n19[label=\"Sendto:R[4:17-4:36]\"];n19->n20;n20[label=\"S[4:21-4:31]\"];n20->n21;n21[label=\"Pair[4:23-4:31]\"];n21->n22;n21->n23;n22[label=\"1[4:24-4:25]\"];n23[label=\"true[4:26-4:30]\"];n24[label=\"R[4:41-4:49]\"];n24->n25;n25[label=\"Sent[4:48-4:49]\"];n26[label=\"Sync:R[R]->S[5:5-6:49]\"];n26->n27;n27[label=\"Let[6:4-6:49]\"];n27->n28;n27->n36;n28[label=\"Assign[6:8-6:38]\"];n28->n29;n28->n31;n29[label=\"R[6:8-6:13]\"];n29->n30;n30[label=\"res[6:10-6:13]\"];n31[label=\"Sendfrom:S[6:17-6:37]\"];n31[label=\"Sendto:R[6:17-6:37]\"];n31->n32;n32[label=\"S[6:21-6:32]\"];n32->n33;n33[label=\"Pair[6:23-6:32]\"];n33->n34;n33->n35;n34[label=\"0[6:24-6:25]\"];n35[label=\"false[6:26-6:31]\"];n36[label=\"R[6:42-6:49]\"];n36->n37;n37[label=\"why[6:48-6:49]\"];}"

let dot3 = "digraphG{n0[label=\"Assign[1:0-7:1]\"];n0->n1;n0->n2;n1[label=\"main[1:0-1:4]\"];n2[label=\"If[2:0-6:45]\"];n2->n3;n2->n14;n2->n24;n3[label=\"R[2:3-2:30]\"];n3->n4;n4[label=\"BinOp[2:5-2:30]\"];n4->n5;n4->n9;n4->n13;n5[label=\"BinOp[2:6-2:16]\"];n5->n6;n5->n7;n5->n8;n6[label=\"3.5[2:6-2:9]\"];n7[label=\"5.5[2:13-2:16]\"];n8[label=\"*.[2:10-2:12]\"];n9[label=\"BinOp[2:19-2:29]\"];n9->n10;n9->n11;n9->n12;n10[label=\"2.1[2:19-2:22]\"];n11[label=\"1.1[2:26-2:29]\"];n12[label=\"/.[2:23-2:25]\"];n13[label=\">[2:17-2:18]\"];n14[label=\"Sync:R[L]->S[3:5-4:48]\"];n14->n15;n15[label=\"Let[4:4-4:48]\"];n15->n16;n15->n22;n16[label=\"Assign[4:8-4:36]\"];n16->n17;n16->n19;n17[label=\"R[4:8-4:13]\"];n17->n18;n18[label=\"res[4:10-4:13]\"];n19[label=\"Sendfrom:S[4:17-4:35]\"];n19[label=\"Sendto:R[4:17-4:35]\"];n19->n20;n20[label=\"S[4:21-4:30]\"];n20->n21;n21[label=\"Hello[4:29-4:30]\"];n22[label=\"R[4:40-4:48]\"];n22->n23;n23[label=\"Sent[4:47-4:48]\"];n24[label=\"Sync:R[R]->S[5:5-6:45]\"];n24->n25;n25[label=\"Let[6:4-6:45]\"];n25->n26;n25->n32;n26[label=\"Assign[6:8-6:34]\"];n26->n27;n26->n29;n27[label=\"R[6:8-6:13]\"];n27->n28;n28[label=\"res[6:10-6:13]\"];n29[label=\"Sendfrom:S[6:17-6:33]\"];n29[label=\"Sendto:R[6:17-6:33]\"];n29->n30;n30[label=\"S[6:21-6:28]\"];n30->n31;n31[label=\"Bye[6:27-6:28]\"];n32[label=\"R[6:38-6:45]\"];n32->n33;n33[label=\"why[6:44-6:45]\"];}"


