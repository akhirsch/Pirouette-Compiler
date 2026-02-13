let simple = "type X := constructor : X;";;
let true_constructor = "type T := true : T;";;
let false_constructor = "type F := ;";;
let boolean = "
  type T := true : T;
  type F := ;
  type B := 
  | true : T ;
  | false : F ;
  ;
";;
let nats = "
  type N := 
  | zero : N 
  | suc : N , N
  ;
";;
(* I'm not sure what the syntax is for a parameterized ADT, 
so i'm doing it in agda style as a placeholder*)
let lst = "
  type list A := 
  | [] : list A
  | cons : list A , list A , list A
  ;
";;