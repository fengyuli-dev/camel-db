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

let col_type_to_string t =
  match t with
  | String -> "String"
  | Int -> "Int"
  | Float -> "Float"
  | Boolean -> "Boolean"

let val_type_to_string (t : val_type) =
  match t with
  | String s -> "String " ^ s
  | Int i -> "Int" ^ string_of_int i
  | Float f -> "Float " ^ string_of_float f
  | Boolean b -> "Boolean " ^ string_of_bool b