module Pos_info = struct
  type t =
    { fname : string
    ; start : int * int (* line, column *)
    ; stop : int * int (* line, column *)
    }

  let string_of_pos { fname = _; start; stop } =
    Printf.sprintf "[%d:%d-%d:%d]" (fst start) (snd start) (fst stop) (snd stop)
  ;;
end

module Local = Ast_core.Local.With (Pos_info)
module Choreo = Ast_core.Choreo.With (Pos_info)
module Net = Ast_core.Net.With (Pos_info)
