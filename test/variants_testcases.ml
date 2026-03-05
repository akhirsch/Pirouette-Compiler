let simple = "type X := constructor : X;"
let true_constructor = "type T := true : T;"
let false_constructor = "type F := ;"

let boolean =
  "\n\
  \  type T := true : T;\n\
  \  type F := ;\n\
  \  type B := \n\
  \  | true : T ;\n\
  \  | false : F ;\n\
  \  ;\n"

let nats = "\n  type N := \n  | zero : N \n  | suc : N , N\n  ;\n"

(* I'm not sure what the syntax is for a parameterized ADT, 
so i'm doing it in agda style as a placeholder*)
let lst =
  "\n\
  \  type list A := \n\
  \  | [] : list A\n\
  \  | cons : list A , list A , list A\n\
  \  ;\n"
