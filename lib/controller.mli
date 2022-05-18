(** A controller that executes SQL operations by calling the mathods in
    [rep.mli]. *)

open Tokenizer
open Type

(** Create a table. *)
val create :
  database -> string -> string list -> data_type list -> database

(** Select some entries in a table based on a filter function. *)
val select :
  database ->
  string ->
  string list ->
  (string list * string list -> bool) ->
  unit

(** Insert one entry into the table. *)
val insert :
  database -> string -> string list -> terminal list -> database

(** Delete some entries in a table based on a filter function. *)
val delete :
  database -> string -> (string list * string list -> bool) -> database

(** Update some entires in a table based on a fileter function. *)
val update :
  database ->
  string ->
  string list ->
  terminal list ->
  (string list * string list -> bool) ->
  database

(** [drop table_name] drops the table [table_name] from the database. *)
val drop : database -> string -> database

(** [save table_name] saves the proposed table to a csv file. *)
val save : database -> string -> unit

(** [read table_name] read the csv file to a database. *)
val read : database -> string -> database