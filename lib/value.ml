(** type for inserting/updating values into an existing database this
    type is necessary because the values inserted could be either
    stirng, int, or float, and we are putting everything in a list so
    they have to have the same type*)
type value_type =
  | String of string
  | Int of int
  | Float of float