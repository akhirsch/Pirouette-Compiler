module type Metainfo = sig
  type t

  val string_of_mi : t -> string
end

module TrivInfo = struct
  type t = unit

  let string_of_mi _ = ""

end 

module PosInfo = struct
  type t = {
    filename : string;
    start : int * int (*line, column *);
    stop : int * int;
  }

  let string_of_mi { filename; start = l1, c1; stop = l2, c2 } =
    Printf.sprintf "[%s: %d:%d--%d:%d]" filename l1 c1 l2 c2
end
