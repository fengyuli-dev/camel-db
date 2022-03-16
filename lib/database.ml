(** Inner representation of the database. *)

type val_type =
  | String of string
  | Int of int
  | Char of char
  | Float of float
  | Boolean of bool

type col_type =   
  | String
  | Char
  | Int
  | Float
  | Boolean