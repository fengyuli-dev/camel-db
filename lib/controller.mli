open Tokenizer
open Type

(** [create table_name cols terminals] *)
val create :
  database -> string -> string list -> data_type list -> database

(** [select table columns filter_function] *)
val select :
  database -> string -> string list -> (string list * string list -> bool) -> unit

(** [insert table columns values] *)
val insert :
  database -> string -> string list -> terminal list -> database

(** [delete table_name filtering_function] *)
val delete : database -> string -> (string list * string list -> bool) -> database

(** [update table columns values filtering_function] *)
val update :
  database ->
  string ->
  string list ->
  terminal list ->
  (string list * string list -> bool) ->
  database

(** [drop table_name] *)
val drop : database -> string -> database

(** [save table_name] saves the proposed table to a csv file. *)
val save : database -> string -> unit

