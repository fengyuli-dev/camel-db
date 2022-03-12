(** Representation of dynamic adventure state. *)

type table
type record
type data_type

(** [create table_name col_name_col_type_list] *)
val create : string -> string * data_type list -> unit
(** [select table columns filter_function] *)
val select : string -> string list -> (record -> bool) -> unit
(** [insert table_name cols value_list] *)
val insert : string -> string list -> 'a list -> unit
(** [delete table_name filtering_function] *)
val delete : string -> (record -> bool) -> unit
(** [update cols values filtering_function] *)
val update : string list -> 'a list -> (record -> bool) -> unit
(** [drop table_name] *)
val drop : string -> unit


