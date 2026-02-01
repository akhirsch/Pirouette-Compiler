make_pingpong : (Bob.int -> Bob.int) {- or Bob.(int -> int) -} -> (Alice.int -> Alice.unit);

make_pingpong handler {- or Bob.handler -} := 
  let do_pingpong Alice.value :=
    [Alice] Alice.value ~> Bob.received;
    let Bob.result := handler Bob.received; in
    let Alice.response := [Bob] Bob.result ~> Alice; in
    Alice.print_int Alice.response;
  in
  do_pingpong
;

main := 
  let Alice.choice := Alice.read_line Alice.(); in
  let handler1 := fun Bob.x -> Bob.(x * 2); in
  let handler2 x {- or Bob.x -} := Bob.(x + 1); in
  let Bob.handler2 Bob.x := Bob.(x + 1); in
  if Alice.(choice = "double") then
    Alice[DOUBLE] ~> Bob;
    make_pingpong (fun Bob.x -> Bob.(x * 2)) Alice.5
  else
    Alice[ADDONE] ~> Bob;
    make_pingpong (fun Bob.x -> Bob.(x + 1)) Alice.5
;
