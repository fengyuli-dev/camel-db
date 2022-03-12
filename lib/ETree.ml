type data =
  | Int of int
  | Float of float
  | String of string

type expr_type =
  | NOT
  | AND
  | OR
  | EQ
  | GT
  | LT
  | GE
  | LE
  | NE
  | String of string

type expr_tree =
  | Leaf
  | Node of expr_tree list
