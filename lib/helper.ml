open Tokenizer

let rec print_list to_string = function
  | [] -> ()
  | h :: t ->
      print_string (to_string h);
      print_string " ";
      print_list to_string t

let rec print_list_newline to_string = function
  | [] -> ()
  | h :: t ->
      print_endline (to_string h);
      print_list_newline to_string t

let key_value_pair_to_string to_string (k, v) =
  Printf.sprintf "key: %s, value: %s" (string_of_int k) (to_string v)

let terminal_to_string = function
  | Int x -> string_of_int x
  | Float x -> string_of_float x
  | String x -> x

let token_to_string = function
  | Command Create -> "Command Create"
  | Command Select -> "Command Select"
  | Command Drop -> "Command Drop"
  | Command Insert -> "Command Insert"
  | Command Delete -> "Command Delete"
  | Command Update -> "Command Update"
  | Target Database -> "Target Database"
  | Target Table -> "Target Table"
  | SubCommand Set -> "SubCommand Set"
  | SubCommand Values -> "SubCommand Values"
  | SubCommand Into -> "SubCommand Into"
  | SubCommand From -> "SubCommand From"
  | SubCommand Where -> "SubCommand Where"
  | BinaryOp EQ -> "BinaryOp EQ"
  | BinaryOp GT -> "BinaryOp GT"
  | BinaryOp GE -> "BinaryOp GE"
  | BinaryOp LT -> "BinaryOp LT"
  | BinaryOp LE -> "BinaryOp LE"
  | BinaryOp NE -> "BinaryOp NE"
  | LogicOp AND -> "LogicOp AND"
  | LogicOp OR -> "LogicOp OR"
  | EndOfQuery EOQ -> "EndOfQuery EOQ"
  | Datatype Int -> "Datatype Int"
  | Datatype Float -> "Datatype Float"
  | Datatype String -> "Datatype String"
  | Terminal t -> terminal_to_string t
