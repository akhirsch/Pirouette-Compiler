Choose prints to stdout:

  $ dune exec pirc -- -d cram_programs/choose.pir
  digraph G {
  n0 [label="EmulatedLocDecl [: 1:0--1:23]"];
  n0 -> n1;
  n1 [label="Name Alice [: 1:18--1:23]"];
  
  n2 [label="EmulatedLocDecl [: 2:0--2:21]"];
  n2 -> n3;
  n3 [label="Name Bob [: 2:18--2:21]"];
  
  n4 [label="Defn Decl [: 3:0--3:26]"];
  n4 -> n5;
  n4 -> n6;
  n5 [label="Name a [: 3:0--3:1]"];
  n6 [label="ChooseFor [: 3:5--3:25]"];
  n6 -> n7;
  n6 -> n8;
  n7 [label="Name Alice [: 3:20--3:25]"];
  n8 [label="Label"];
  n8 -> n9;
  n9 [label="Name L [: 3:13--3:14]"];
  
  }

Multi_loc prints to stdout:

  $ dune exec pirc -- -d cram_programs/multi_loc.pir
  digraph G {
  n0 [label="EmulatedLocDecl [: 1:0--1:23]"];
  n0 -> n1;
  n1 [label="Name Alice [: 1:18--1:23]"];
  
  n2 [label="EmulatedLocDecl [: 2:0--2:21]"];
  n2 -> n3;
  n3 [label="Name Bob [: 2:18--2:21]"];
  
  n4 [label="EmulatedLocDecl [: 3:0--3:23]"];
  n4 -> n5;
  n5 [label="Name Carol [: 3:18--3:23]"];
  
  n6 [label="Defn Decl [: 4:0--4:21]"];
  n6 -> n7;
  n6 -> n8;
  n7 [label="Name a [: 4:0--4:1]"];
  n8 [label="Send [: 4:5--4:20]"];
  n8 -> n9;
  n8 -> n11;
  n9 [label="IntLit [: 4:10--4:11]"];
  n9 -> n10;
  n10 [label="Int 1"];
  n11 [label="Name Alice [: 4:15--4:20]"];
  
  n12 [label="Defn Decl [: 5:0--5:19]"];
  n12 -> n13;
  n12 -> n14;
  n13 [label="Name b [: 5:0--5:1]"];
  n14 [label="Send [: 5:5--5:18]"];
  n14 -> n15;
  n14 -> n17;
  n15 [label="IntLit [: 5:10--5:11]"];
  n15 -> n16;
  n16 [label="Int 2"];
  n17 [label="Name Bob [: 5:15--5:18]"];
  
  }

Recv prints to stdout:

  $ dune exec pirc -- -d cram_programs/recv.pir
  digraph G {
  n0 [label="EmulatedLocDecl [: 1:0--1:23]"];
  n0 -> n1;
  n1 [label="Name Alice [: 1:18--1:23]"];
  
  n2 [label="EmulatedLocDecl [: 2:0--2:21]"];
  n2 -> n3;
  n3 [label="Name Bob [: 2:18--2:21]"];
  
  n4 [label="Defn Decl [: 3:0--3:25]"];
  n4 -> n5;
  n4 -> n6;
  n5 [label="Name a [: 3:0--3:1]"];
  n6 [label="Recv [: 3:5--3:24]"];
  n6 -> n7;
  n6 -> n8;
  n7 [label="Int Type [: 3:10--3:13]"];
  n8 [label="Name Alice [: 3:19--3:24]"];
  
  }

Send prints to stdout:

  $ dune exec pirc -- -d cram_programs/send.pir
  digraph G {
  n0 [label="EmulatedLocDecl [: 1:0--1:23]"];
  n0 -> n1;
  n1 [label="Name Alice [: 1:18--1:23]"];
  
  n2 [label="EmulatedLocDecl [: 2:0--2:21]"];
  n2 -> n3;
  n3 [label="Name Bob [: 2:18--2:21]"];
  
  n4 [label="Defn Decl [: 3:0--3:21]"];
  n4 -> n5;
  n4 -> n6;
  n5 [label="Name a [: 3:0--3:1]"];
  n6 [label="Send [: 3:5--3:20]"];
  n6 -> n7;
  n6 -> n9;
  n7 [label="IntLit [: 3:10--3:11]"];
  n7 -> n8;
  n8 [label="Int 3"];
  n9 [label="Name Alice [: 3:15--3:20]"];
  
  }
