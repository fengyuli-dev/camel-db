open Tokenizer
open Type

(** [create table_name cols terminals] *)
val create : string -> string list -> data_type list -> unit
(** [select table columns filter_function] *)
val select : string -> string list -> ('a list * 'a list -> bool) -> unit
(** [insert table columns values] *)
val insert : string -> string list -> terminal list -> unit
(** [delete table_name filtering_function] *)
val delete : string -> ('a list * 'a list -> bool) -> unit
(** [update table columns values filtering_function] *)
val update : string -> string list -> terminal list -> 
  ('b list * 'b list -> bool) -> unit
(** [drop table_name] *)
val drop : string -> unit
(** [save table_name] saves the proposed table to a csv file. *)
val save : string -> unit
(** [get_parent_db] gives the output function the current db. *)
val get_parent_db : string
