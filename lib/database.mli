(** Types needed for the inner representation of the database. *)

type val_type =
  | String of string
  | Int of int
  | Float of float
  | Boolean of bool

type col_type =
  | String
  | Int
  | Float
  | Boolean

(** [col_type_to_string col_type] converts the type of a column to a
    string *)
val col_type_to_string : col_type -> string

(** [val_type_to_string col_type] converts the type of a data value to a
    string representation *)
val val_type_to_string : val_type -> string
