type expr =
  | Value of int
  | Variable of string
  | Op of {lft: expr; op: string; rght: expr}
  | Condition of {lft: expr; op: string; rght: expr}
  | Branch of {ift: expr; thn : expr; el: expr}
  | Sync of {sndr: string; d: string; rcvr: string}
  | Seq of {fst: expr; thn : expr}
  | Map of {name: string; arg: expr}
  | Assoc of {loc: string; arg: expr}
  | Abstraction of { param : string; body : expr }
  | Application of { funct : expr; argument : expr }
  | Comm_S of {sndr: expr; rcvr : expr}
[@@deriving show]