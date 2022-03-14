(* type for inserting/updating values into an existing database*)
type value_type =
  | String of string
  | Int of int
  | Float of float