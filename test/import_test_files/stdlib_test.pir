main :=
  let Alice.x := Alice.print_string Alice."hello from Alice "; in
  let Bob.y := Bob.print_string Bob."hello from Bob"; in
  Alice.();