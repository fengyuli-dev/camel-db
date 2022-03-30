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

type datatype =
  | Int
  | Float
  | String

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

(** split the stirng based on spaces and filter out empty*)
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
  | "QUIT" -> exit 0
  | "CREATE" -> Command Create
  | "SELECT" -> Command Select
  | "DROP" -> Command Drop
  | "INSERT" -> Command Insert
  | "DELETE" -> Command Delete
  | "UPDATE" -> Command Update
  | "DATABASE" -> Target Database
  | "TABLE" -> Target Table
  | "SET" -> SubCommand Set
  | "VALUES" -> SubCommand Values
  | "INTO" -> SubCommand Into
  | "FROM" -> SubCommand From
  | "WHERE" -> SubCommand Where
  | "=" -> BinaryOp EQ
  | ">" -> BinaryOp GT
  | ">=" -> BinaryOp GE
  | "<" -> BinaryOp LT
  | "<=" -> BinaryOp LE
  | "!=" -> BinaryOp NE
  | "AND" -> LogicOp AND
  | "OR" -> LogicOp OR
  | ";" -> EndOfQuery EOQ
  | "SAVE" -> Command Save
  | s -> match_terminal s

let tokenize s = List.map (fun e -> match_token e) (to_string_list s)