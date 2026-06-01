module type Metainfo = sig
  type t

  val string_of_mi : t -> string
end

module PosInfo : Metainfo
