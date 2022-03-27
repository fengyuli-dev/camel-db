(** Internal representation of the database*)

exception Internal of string
exception WrongTableStructure
exception WrongType
exception IllegalName

type data_type =
  | Int
  | Float
  | String

type column
type table
