open Ppxlib

module Net  = Netir.Nometa
(* with this declared now i can write N.___ avoiding name conflicts *)

let loc = Location.none

(* <raw NetIR constructor pattern>  ->  <ppxlib [%…] quotation> *) 
let rec gen_typ (t : Net.typ) : core_type =
  match t with
    | Net.VarTy ((), ((), x)) ->  [[%type: unit], [[[%type: unit], [%type: string]]]]
    | Net.UnitTy () -> [%type: unit]
    | Net.IntTy () -> [%type: int]
    | Net.FloatTy () -> [%type: float]
    | Net.CharTy () -> [%type: char]
    | Net.StringTy () -> [%type: string]
    | Net.BoolTy () -> [%type: bool]
   (* | Net.FunTy ((), t1, t2) -> ([%type: unit], [%type: t1], [%type: t2]) *)
    | Net.FunTy ((), t1, t2) -> [%type: [%t gen_typ t1] -> [%t gen_typ t2]]
    | Net.LocTy ((), List.map (fun s -> ((), s)) ls) ->  [[%type: unit], [%fun]]
    |_ -> Failwith "Error on general type"






  