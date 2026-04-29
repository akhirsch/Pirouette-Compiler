(* ANSI color codes *)
let gray = "\027[90m"
let yellow = "\027[33m"
let blue = "\027[34m"
let green = "\027[32m"
let reset = "\027[0m"
let print_idle msg = Printf.printf "%s%s%s\n%!" gray msg reset
let print_waiting msg = Printf.printf "%s%s%s\n%!" yellow msg reset
let print_sending msg = Printf.printf "%s%s%s\n%!" blue msg reset
let print_done msg = Printf.printf "%s%s%s\n%!" green msg reset
let clear_console () = Printf.printf "\027[2J\027[H%!"

