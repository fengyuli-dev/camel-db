(** Representation of dynamic adventure state. *)

val create : (name : string) (lst: category*type list) -> unit

val select : (cols: column list)(db : data_base)(function) -> unit

val insert : (table : string) (cols: string list)(values: 'a list ) string : 'a listvueala list) ()

val delete : (table : string) (condition : func)

val update : ()

val drop : (name : string)


