(** Representation of all types in the database. *)

(* General types*)
type datatype =
  (*TODO: refactor Database.col_type*)
  | Int
  | Float
  | String

type val_type =
  | String of string
  | Int of int
  | Float of float

(* Parser types*)
type command_type =
  | Create
  | Select
  | Drop
  | Insert
  | Delete
  | Update
  | Save

type sub_command_type =
  | From
  | Where
  | Set
  | Values
  | Into

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

type terminal =
  | Int of int
  | Float of float
  | String of string

type end_of_query = EOQ

type token =
  | Command of command_type
  | SubCommand of sub_command_type
  | Target of target_type
  | BinaryOp of binary_op
  | LogicOp of logic_op
  | Datatype of datatype
  | Terminal of terminal
  | EndOfQuery of end_of_query

(* type for condition expression in parse_where *)
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
