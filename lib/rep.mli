(** Internal Representation of the database. *)
open Type

exception Internal of string
exception WrongTableStructure
exception WrongType
exception IllegalName

val default_int : int
val default_float : float
val default_string : string


val get_row_num : table -> int
val get_col_num : table -> int

(* [get_field_name_list table] returns assoc list of column names and
   datatypes. *)
val get_field_name_list :
  database -> string -> (string * data_type) list

(* [get_column_data table column] returns list of data in this column as
   string list. *)
val get_column_data : database -> string -> string -> string list

(** [create_table name field_list] creates a table with table name of
    [name] and fields from [field_list]. *)
val create_table :
  database -> string -> (string * data_type) list -> database

(** [create_empty_database base_name] creates a database with given
    name, used in controller to create parent_db.*)
val create_empty_database : string -> database

(** [select name field_list filtering_function] returns a table only
    with rows that satisfy the condition *)
val select :
  database ->
  string ->
  string list ->
  (string list * string list -> bool) ->
  table

(** [insert_row name fieldname_type_value_list] returns a table with one
    row inserted, the columns that is specified in the function have
    customized values. The rest of the columns get default values.*)
val insert_row :
  database -> string -> (string * data_type * string) list -> database

(** [delete_row name filtering_function] returns a table without the
    selected rows *)
val delete_row :
  database -> string -> (string list * string list -> bool) -> database

(** [update_row name fieldname_type_value_list filtering_function]
    returns an updated table with the rows fitting the condition
    updated. *)
val update_row :
  database ->
  string ->
  (string * data_type * string) list ->
  (string list * string list -> bool) ->
  database

(** [drop_table name] drops the given table *)
val drop_table : database -> string -> database
