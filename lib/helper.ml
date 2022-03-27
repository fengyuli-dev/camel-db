open Tokenizer
open Parser

exception Malformed of string

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

let pp_tokens tokens =
  " { \n"
  ^ String.concat "\n" (List.map token_to_string tokens)
  ^ "\n  } "

let rec find elt lst =
  match lst with
  | [] ->
      raise (Malformed "command does not have the correct subcommand")
  | h :: t -> if h = elt then 0 else 1 + find elt t

let rec sublist i j l =
  match l with
  | [] -> raise (Malformed "empty list")
  | h :: t ->
      let tail = if j = 0 then [] else sublist (i - 1) (j - 1) t in
      if i > 0 then tail else h :: tail

let get_this_command (tokens : token list) : token list =
  let eoq_index = find (EndOfQuery EOQ) tokens in
  sublist 0 (eoq_index - 1) tokens

let get_list_after_where (tokens : token list) : token list =
  let where_index = find (SubCommand Where) tokens in
  sublist (where_index + 1) (List.length tokens - 1) tokens

let get_other_commands (tokens : token list) : token list =
  let eoq_index = find (EndOfQuery EOQ) tokens in
  sublist (eoq_index + 1) (List.length tokens - 1) tokens

let duplicate_in_list f lst =
  List.length lst = List.length (List.sort_uniq f lst)

let rec function_to_list f init =
  match f init with
  | None -> []
  | Some (x, next) -> x :: function_to_list f next

let range n =
  let in_range x = if x >= n then None else Some (x, x + 1) in
  function_to_list in_range 0
