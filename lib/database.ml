(** Inner representation of the database. *)

type val_type =
  | String of string
  | Int of int
  | Char of char
  | Float of float
  | Boolean of bool

type col_type =
  | String
  | Int
  | Float
  | Boolean
  
let col_type_to_string t = 
  match t with 
  | String -> "String"
  | Int -> "Int"
  | Float -> "Float"
  | Boolean -> "Boolean"