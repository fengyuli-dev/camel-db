type data =
  | Int of int
  | Float of float
  | String of string

type expr_type =
  | AND
  | OR
  | EQ
  | GT
  | LT
  | GE
  | LE
  | NE
  | String of string
  | Int of int
  | Float of float

type expr_tree =
  | Leaf
  | Node of expr_tree list
