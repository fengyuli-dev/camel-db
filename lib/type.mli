(** Representation of all types in the database. *)

(** Supported data types. *)
type data_type =
  | Int
  | Float
  | String

(** Terminal symbols. *)
type terminal =
  | Int of int
  | Float of float
  | String of string

(** SQL command types. *)
type command_type =
  | Create
  | Select
  | Drop
  | Insert
  | Delete
  | Update
  | Save

(** Keywords affiliated with a SQL command. *)
type sub_command_type =
  | From
  | Where
  | Set
  | Values
  | Into

(** Operation targets. *)
type target_type =
  | Database
  | Table

(** Binary operations. *)
type binary_op =
  | EQ
  | GT
  | LT
  | GE
  | LE
  | NE

(** Logic operations. *)
type logic_op =
  | AND
  | OR

(** EOS token. *)
type end_of_query = EOQ

(** Token types. *)
type token =
  | Command of command_type
  | SubCommand of sub_command_type
  | Target of target_type
  | BinaryOp of binary_op
  | LogicOp of logic_op
  | Datatype of data_type
  | Terminal of terminal
  | EndOfQuery of end_of_query

(** Expression types and types for condition expression in
    [parse_where]. *)
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

(** Tree type. *)
type 'a tree =
  | EmptyLeaf
  | Leaf of (int * 'a)
  | Node of (int * 'a * 'a tree * 'a tree)

(** A column of a table in the database. *)
type column = {
  field_name : string;
  data_type : data_type;
  data : string tree;
}

(** A table in the database. *)
type table = {
  table_name : string;
  columns : column tree;
  num_rows : int;
}

(** The database type. *)
type database = {
  database_name : string;
  tables : table tree;
  num_tables : int;
}
