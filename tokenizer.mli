type command_type =
  | Create
  | Select
  | Drop
  | Insert
  | Delete
  | Update

type target_type =
  | Database
  | Table

type binary_op =
  | EQ
  | GT
  | LT
  | GE
  | LE
  | NE

type logic_op =
  | AND
  | OR

type datatype =
  | Int
  | Float
  | String

type terminal =
  | Int of int
  | Float of float
  | String of string

type token =
  | Command of command_type
  | Target of target_type
  | BinaryOp of binary_op
  | LogicOp of logic_op
  | Datatype of datatype
  | Terminal of terminal

val tokenize : string -> token list
