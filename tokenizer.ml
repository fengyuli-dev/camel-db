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
  | Char
  | String

type terminal =
  | Int of int
  | Float of float
  | Char of char
  | String of string

type token =
  | Command of command_type
  | Target of target_type
  | BinaryOp of binary_op
  | LogicOp of logic_op
  | Datatype of datatype
  | Terminal of terminal

type tokens = token list

let to_string_list input =
  input |> String.trim
  |> String.split_on_char ' '
  |> List.map String.trim
  |> List.filter (fun e -> e <> "")

(* TODO: Implement this *)
let match_terminal s = Terminal (Int 1)

let match_token = function
  | "CREATE" -> Command Create
  | "SELECT" -> Command Select
  | "DROP" -> Command Drop
  | "INSERT" -> Command Insert
  | "DELETE" -> Command Delete
  | "UPDATE" -> Command Update
  | "DATABASE" -> Target Database
  | "TABLE" -> Target Table
  | "=" -> BinaryOp EQ
  | ">" -> BinaryOp GT
  | ">=" -> BinaryOp GE
  | "<" -> BinaryOp LT
  | "<=" -> BinaryOp LE
  | "!=" -> BinaryOp NE
  | "AND" -> LogicOp AND
  | "OR" -> LogicOp OR
  | "INTEGER" -> Datatype Int
  | "INT" -> Datatype Int
  | "FLOAT" -> Datatype Float
  | "DOUBLE" -> Datatype Float
  | "CHAR" -> Datatype Char
  | "TEXT" -> Datatype String
  | "VARCHAR" -> Datatype String
  | s -> match_terminal s
