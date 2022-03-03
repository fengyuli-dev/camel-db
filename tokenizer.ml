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

let to_string_list input =
  input |> String.trim
  |> String.split_on_char ' '
  |> List.map String.trim
  |> List.filter (fun e -> e <> "")

(* TODO: Tokenizer does not support string with spaces. It also does not
   support spaces around binary operators. *)
let match_terminal s =
  try Terminal (Int (int_of_string s))
  with _ -> (
    try Terminal (Float (float_of_string s))
    with _ -> Terminal (String s))

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
  | "CHAR" -> Datatype String
  | "TEXT" -> Datatype String
  | "VARCHAR" -> Datatype String
  | s -> match_terminal s

let tokenize s = List.map (fun e -> match_token e) (to_string_list s)
