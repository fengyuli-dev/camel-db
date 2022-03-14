(** Representation of dynamic adventure state. *)
open Tokenizer

(** [create table_name col_name_col_type_list] *)
val create : string -> string * 'a list -> unit
(** [select table columns filter_function] *)
val select : string -> string list -> ('a list * 'a list -> bool) -> unit
(** [insert table_name cols value_list] *)
val insert : string -> string list -> 'a list -> unit
(** [delete table_name filtering_function] *)
val delete : string -> ('a list * 'a list -> bool) -> unit
(** [update table_name cols values filtering_function] *)
val update : string -> string list -> 'a list -> ('b list * 'b list -> bool) -> unit
(** [drop table_name] *)
val drop : string -> unit


