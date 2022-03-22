open Tokenizer
open Controller
open Database

exception Malformed of string
exception Empty

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

(** General Helpers within Parser *)
let rec terminal_to_string tokens =
  match tokens with
  | [] -> ""
  | Tokenizer.String s :: t -> s ^ " " ^ terminal_to_string t
  | Tokenizer.Int i :: t -> string_of_int i ^ " " ^ terminal_to_string t
  | Tokenizer.Float f :: t ->
      string_of_float f ^ " " ^ terminal_to_string t

let tokens_to_terminals tokens =
  List.map
    (fun t ->
      match t with
      | Terminal x -> x
      | _ -> raise (Malformed "Wrong Format in CREATE"))
    tokens

let token_to_terminal t =
  match t with
  | Terminal terminal -> terminal
  | _ -> raise (Malformed "not a terminal")

let token_list_to_terminal_list l =
  List.map (fun x -> token_to_terminal x) l

(** [explode s] turn a string into a list of characters*)
let explode (s : string) : char list =
  List.init (String.length s) (String.get s)

(** [find elt lst] find the index of the first elt in the list*)
let rec find elt lst =
  match lst with
  | [] ->
      raise (Malformed "command does not have the correct subcommand")
  | h :: t -> if h = elt then 0 else 1 + find elt t

(** [get_odd_elem] lst return only the odd elements of a given list*)
let get_odd_elem (lst : token list) : token list =
  List.filter (fun elt -> find elt lst mod 2 = 1) lst

(** [get_even_elem] lst return only the even elements of a given list*)
let get_even_elem (lst : token list) : token list =
  List.filter (fun elt -> find elt lst mod 2 = 0) lst

(** [remove_char c s] remove any instances of the character in a string *)
let remove_char (c : char) (s : string) : string =
  let char_list = explode s in
  let filtered_list =
    List.filter (fun letter -> letter <> c) char_list
  in
  List.fold_left (fun acc h -> acc ^ String.make 1 h) "" filtered_list

(** [trim_string s] remove all the () and , in a string *)
let trim_string (s : string) =
  s |> remove_char '(' |> remove_char ')' |> remove_char ','
  |> remove_char '\'' |> String.trim

let rec terminal_to_string_list (tokens : terminal list) : string list =
  match tokens with
  | [] -> []
  | Tokenizer.String s :: t ->
      trim_string s :: terminal_to_string_list t
  | Tokenizer.Int i :: t -> string_of_int i :: terminal_to_string_list t
  | Tokenizer.Float f :: t ->
      string_of_float f :: terminal_to_string_list t

let rec sublist i j l =
  match l with
  | [] -> raise (Malformed "empty list")
  | h :: t ->
      let tail = if j = 0 then [] else sublist (i - 1) (j - 1) t in
      if i > 0 then tail else h :: tail

(** [get_val_index tokens] get the index of the occurence token
    SubCommand Values in a tokens list *)
let rec get_val_index (tokens : token list) : int =
  find (SubCommand Values) tokens

(** [parse_table tokens sub_command] is a helper function that parses
    table name based on a sub_command keyword*)
let parse_table (tokens : token list) (sub_command : token) =
  match tokens with
  | [] -> failwith "no table"
  | h :: t ->
      if h = sub_command then
        terminal_to_string [ List.nth t 0 |> token_to_terminal ]
        |> trim_string
      else raise (Malformed "wrong command format")

(** [get_list_after_where tokens] return the sublist of tokens after the
    where keyword*)
let get_list_after_where (tokens : token list) : token list =
  let where_index = find (SubCommand Where) tokens in
  sublist (where_index + 1) (List.length tokens - 1) tokens

(** [parse_cols col_tokens] return the list of columns to according to
    the tokens*)
let parse_cols (cols_tokens : terminal list) : string list =
  cols_tokens |> terminal_to_string_list

(** [parse_select_columns tokens] convert list of tokens involving
    column names into a list of column names (with stripping). (used for
    select) *)
let parse_select_columns tokens =
  tokens |> terminal_to_string
  |> String.split_on_char ','
  |> List.map String.trim

let extract_name token =
  match token with
  | Terminal (String s) -> trim_string s
  | Terminal (Int i) -> string_of_int i
  | Terminal (Float f) -> string_of_float f
  | _ -> raise (Malformed "Invalid Column Name.")

(** [parse_vals vals_tokens] return a list of values to insert into
    columns *)
let parse_vals (vals_tokens : terminal list) : string list =
  vals_tokens |> terminal_to_string_list

(** [get_cols_list tokens] only return the list of terminals associated
    with columns *)
let get_cols_list (tokens : token list) : string list =
  let sub_list =
    let val_index = get_val_index tokens in
    sublist 2 (val_index - 1) tokens
  in
  terminal_to_string_list (token_list_to_terminal_list sub_list)

(** converts a token to a terminal string/int/float*)
let token_to_terminal (t : token) : terminal =
  match t with
  | Terminal t -> t
  | _ -> raise (Malformed "not a terminal")

(** converts a terminal string/int/float to the val_type
    string/int/float*)
let terminal_to_val_type (t : terminal) : Database.val_type =
  match t with
  | Tokenizer.String s -> Database.String s
  | Tokenizer.Int i -> Database.Int i
  | Tokenizer.Float f -> Database.Float f

(**[get_vals_list tokens] only return the list of temrinals associated
   with values*)
let get_vals_list (tokens : token list) : val_type list =
  let sublist =
    let val_index = get_val_index tokens in
    sublist (val_index + 1) (List.length tokens - 1) tokens
  in
  List.map
    (fun elt -> elt |> token_to_terminal |> terminal_to_val_type)
    sublist

(** [get_update_list tokens] return the sublist that contain columns and
    values to update*)
let get_update_list (tokens : token list) : token list =
  let set_index = find (SubCommand Set) tokens in
  let where_index = find (SubCommand Where) tokens in
  sublist (set_index + 1) (where_index - 1) tokens

(** [check_update_list] update_list return true if the update command is
    formatted correctly*)
let check_update_list (update_list : token list) : bool =
  let len = List.length update_list in
  len mod 3 = 0

(** [remove_eq] update_list remove the binary EQ elements in a token
    list*)
let remove_eq (update_list : token list) : token list =
  List.filter (fun elt -> elt <> BinaryOp EQ) update_list

(** [get_odd_elem] lst return only the odd elements of a given list*)
let get_odd_elem (lst : token list) : token list =
  List.filter (fun elt -> find elt lst mod 2 = 1) lst

(** [get_even_elem] lst return only the even elements of a given list*)
let get_even_elem (lst : token list) : token list =
  List.filter (fun elt -> find elt lst mod 2 = 0) lst

(** [get_update_cols update_list] return the list of columns to update.
    Precondition: the update_list is correctly formatted*)
let get_update_cols (update_list : token list) : string list =
  if not (check_update_list update_list) then raise (Malformed "TODO")
  else
    update_list |> remove_eq |> get_even_elem
    |> token_list_to_terminal_list |> terminal_to_string_list

(** [get_update_vals update_list] return the list of values to update
    for the correponding columns. Precondition: the update_list is
    correctly formatted*)
let get_update_vals (update_list : token list) : val_type list =
  if not (check_update_list update_list) then raise (Malformed "TODO")
  else
    let token_list = update_list |> remove_eq |> get_odd_elem in
    List.map
      (fun elt -> elt |> token_to_terminal |> terminal_to_val_type)
      token_list

let get_this_command (tokens : token list) : token list =
  let eoq_index = find (EndOfQuery EOQ) tokens in
  sublist 0 (eoq_index - 1) tokens

let get_other_commands (tokens : token list) : token list =
  let eoq_index = find (EndOfQuery EOQ) tokens in
  sublist (eoq_index + 1) (List.length tokens - 1) tokens

let rec string_formatter (lst : string list) : string list =
  List.map (fun elt -> elt |> trim_string) lst

let rec vals_formatter (lst : Database.val_type list) :
    Database.val_type list =
  match lst with
  | [] -> []
  | h :: t -> (
      match h with
      | String s -> String (trim_string s) :: vals_formatter t
      | Int i -> Int i :: vals_formatter t
      | Float f -> Float f :: vals_formatter t
      | _ -> t)

(* parse_where helpers *)

let token_to_expr_type = function
  | BinaryOp EQ -> EQ
  | BinaryOp GT -> GT
  | BinaryOp LT -> LT
  | BinaryOp GE -> GE
  | BinaryOp LE -> LE
  | BinaryOp NE -> NE
  | LogicOp AND -> AND
  | LogicOp OR -> OR
  | Terminal (String s) -> String s
  | Terminal (Int i) -> Int i
  | Terminal (Float f) -> Float f
  | _ -> raise (Malformed "token not expr_type")

let rec expression_or_helper
    (tokens : expr_type list)
    (acc : expr_type list) : expr_type list list =
  match tokens with
  | OR :: t -> [ List.rev acc ] @ expression_or_helper t []
  | [] -> [ List.rev acc ]
  | x :: xs -> expression_or_helper xs (x :: acc)

(** [expression_or tokens] seperate [tokens] by OR operator and return a
    list of conditions connected only by and. Cut [A;OR;B;OR;C] into
    [\[A\];\[B\];\[C\]] *)
let expressions_or (tokens : expr_type list) : expr_type list list =
  expression_or_helper tokens []

let and_condition_evaluater_helper
    (a : expr_type)
    (op : expr_type)
    (b : expr_type)
    (data : expr_type * expr_type) : bool =
  let data_a, data_b = data in
  match op with
  | EQ -> data_b = b
  | GT -> data_b > b
  | LT -> data_b < b
  | GE -> data_b >= b
  | LE -> data_b <= b
  | NE -> data_b <> b
  | _ -> raise (Malformed "condition not filtered right")

(** [and_conditino_evaluater a op b pair_data] evaluate a single
    condition with only one and [a op b] and see if [pair_data] have
    satisfy this condition. Return true if satisfied, false otherwise *)
let rec and_condition_evaluater
    a
    op
    b
    (pair_data : (expr_type * expr_type) list) =
  match pair_data with
  | [] -> raise (Malformed "data base type not found")
  | (data_a, data_b) :: t ->
      if data_a = a then
        and_condition_evaluater_helper a op b (data_a, data_b)
      else and_condition_evaluater a op b t

(** [evaluate_and_helper and_lst pair_data] evaluate a list of and
    conditions [and_lst] and see if [pair_data] satisfy this condition.
    Return true if satisfied, false otherwise *)
let rec evaluate_and_helper and_lst pair_data : bool =
  match and_lst with
  | [] -> true
  | AND :: t -> evaluate_and_helper t pair_data
  | a :: op :: b :: t ->
      and_condition_evaluater a op b pair_data
      && evaluate_and_helper t pair_data
  | _ -> raise (Malformed "invalid list of and conditions")

(** [evaluate_and or_lst pair_data] evaluate a list of conditions
    [or_lst] with or connected between each conditions that are only
    connected by and, and see if [pair_data] satisfy any of these
    conditions. True if yes and false if no *)
let rec evaluate_or or_lst pair_data : bool =
  match or_lst with
  | [] -> false
  | h :: t -> evaluate_and_helper h pair_data || evaluate_or t pair_data

(** [parse_where_helper tokens pair_data] evaluate conditions [tokens]
    and see if [pair_data] satisfy any of these conditions. True if yes
    and false if no *)
let parse_where_helper
    (tokens : expr_type list)
    (pair_data : token list * token list) : bool =
  let pair_data_a, pair_data_b = pair_data in
  let pair_data' =
    List.combine
      (List.map token_to_expr_type pair_data_a)
      (List.map token_to_expr_type pair_data_b)
  in
  let or_lst = expressions_or tokens in
  evaluate_or or_lst pair_data'

let print_condition = true

let rec print_function_helper exprs =
  match exprs with
  | AND :: t ->
      print_string "AND ";
      print_function_helper t
  | OR :: t ->
      print_string "OR ";
      print_function_helper t
  | EQ :: t ->
      print_string "= ";
      print_function_helper t
  | GT :: t ->
      print_string "> ";
      print_function_helper t
  | LT :: t ->
      print_string "< ";
      print_function_helper t
  | GE :: t ->
      print_string ">= ";
      print_function_helper t
  | LE :: t ->
      print_string "<= ";
      print_function_helper t
  | NE :: t ->
      print_string "!= ";
      print_function_helper t
  | String s :: t ->
      print_string s;
      print_string " ";
      print_function_helper t
  | Int i :: t ->
      print_int i;
      print_string " ";
      print_function_helper t
  | Float f :: t ->
      print_float f;
      print_string " ";
      print_function_helper t
  | [] -> print_string ""

let print_function exprs =
  print_string "Condition: ";
  print_function_helper exprs

(** see mli file for details discription *)
let parse_where (tokens : token list) =
  let exprs = List.map token_to_expr_type tokens in
  if print_condition then print_function exprs else print_string "";
  parse_where_helper exprs

(* end of parse_where *)

let parse_datatype token =
  match extract_name token with
  | "INTEGER" -> Database.Int
  | "INT" -> Database.Int
  | "FLOAT" -> Database.Float
  | "DOUBLE" -> Database.Float
  | "CHAR" -> Database.String
  | "TEXT" -> Database.String
  | "VARCHAR" -> Database.String
  | "BOOL" -> Database.Boolean
  | _ -> raise (Malformed "Not a valid datatype of column")

let rec parse_create tokens =
  let this_command = get_this_command tokens in
  let other_commands = get_other_commands tokens in
  try
    let name = extract_name (List.hd this_command) in
    let tail = List.tl this_command in
    let cols = tail |> get_even_elem |> List.map extract_name in
    let types = tail |> get_odd_elem |> List.map parse_datatype in
    if List.length cols = List.length types then (
      create name cols types;
      parse_query other_commands)
    else raise (Malformed "Not correct number of columns / types")
  with Failure _ -> raise (Malformed "Syntax in Create is malformed")

(* Parse Select Functions: *)

(** acc is accumulator, cols is token list of columns, from_lst is token
    list for parse_from, lst is the list containing parse_where and so
    on. *)
and get_where acc cols from_lst lst =
  match lst with
  | [] -> raise (Malformed "No condition after WHERE")
  | EndOfQuery EOQ :: t ->
      select
        (terminal_to_string from_lst)
        (parse_select_columns cols)
        (parse_where acc);
      parse_query t
  | h :: t -> get_where (h :: acc) cols from_lst t

and get_from acc cols lst =
  match lst with
  | [] -> raise (Malformed "No restrictions after FROM")
  | SubCommand Where :: t -> get_where [] cols acc t
  | EndOfQuery EOQ :: t ->
      select (terminal_to_string acc) (parse_select_columns cols)
        (fun _ -> true);
      parse_query t
  | Terminal h :: t -> get_from (h :: acc) cols t
  | _ -> raise (Malformed "Wrong Syntax in FROM")

and get_cols acc lst =
  match lst with
  | [] -> raise (Malformed "No FROM statement after SELECT")
  | SubCommand From :: t -> get_from [] acc t
  | Terminal h :: t -> get_cols (h :: acc) t
  | _ -> raise (Malformed "Wrong Syntax in SELECT")

and parse_select tokens =
  match tokens with
  | [] -> raise (Malformed "No column list after SELECT")
  | Terminal s :: t -> get_cols [] (Terminal s :: t)
  | _ -> raise (Malformed "Wrong Syntax in SELECT")

(** Parse Drop: *)
and parse_drop tokens =
  match tokens with
  | [] -> raise (Malformed "No table name after DROP")
  | Terminal s :: t ->
      let rec grouping acc lst =
        match lst with
        | [] -> raise (Malformed "Wrong Syntax in DROP")
        | EndOfQuery EOQ :: t ->
            drop (terminal_to_string acc);
            parse_query t
        | Terminal h :: t -> grouping (h :: acc) t
        | _ -> raise (Malformed "Wrong Syntax in DROP")
      in
      grouping [] (Terminal s :: t)
  | _ -> raise (Malformed "Wrong Syntax in DROP")

and parse_insert (tokens : token list) =
  let this_command = get_this_command tokens in
  let table =
    parse_table this_command (SubCommand Into) |> trim_string
  in
  let cols = this_command |> get_cols_list |> string_formatter in
  let vals = this_command |> get_vals_list |> vals_formatter in
  Controller.insert table cols vals;
  get_other_commands tokens |> parse_query

(**[parse_insert_test_version tokens] runs parse_insert but it is
   friendly for testing because it has a concrete output type instead of
   unit*)
and parse_insert_test_version (tokens : token list) :
    string * string list * val_type list =
  let this_command = get_this_command tokens in
  let table =
    parse_table this_command (SubCommand Into) |> trim_string
  in
  let cols = this_command |> get_cols_list |> string_formatter in
  let vals = this_command |> get_vals_list |> vals_formatter in
  (table, cols, vals)

and parse_delete tokens =
  let this_command = get_this_command tokens in
  let table = parse_table this_command (SubCommand From) in
  Controller.delete table
    (parse_where (this_command |> get_list_after_where));
  get_other_commands tokens |> parse_query

and parse_delete_test_version (tokens : token list) : string =
  let this_command = get_this_command tokens in
  let table = parse_table this_command (SubCommand From) in
  table

and parse_update tokens =
  let this_command = get_this_command tokens in
  let table =
    terminal_to_string [ List.nth this_command 0 |> token_to_terminal ]
    |> trim_string
  in
  Controller.update table
    (this_command |> get_update_list |> get_update_cols
   |> string_formatter)
    (this_command |> get_update_list |> get_update_vals
   |> vals_formatter)
    (parse_where (this_command |> get_list_after_where));
  get_other_commands tokens |> parse_query

and parse_update_test_version tokens :
    string * string list * val_type list =
  let this_command = get_this_command tokens in
  let table =
    terminal_to_string [ List.nth this_command 0 |> token_to_terminal ]
    |> trim_string
  in
  ( table,
    this_command |> get_update_list |> get_update_cols
    |> string_formatter,
    this_command |> get_update_list |> get_update_vals |> vals_formatter
  )

and parse_query tokens =
  match tokens with
  | [] -> ()
  | Command Create :: t -> parse_create t
  | Command Select :: t -> parse_select t
  | Command Drop :: t -> parse_drop t
  | Command Insert :: t -> parse_insert t
  | Command Delete :: t -> parse_delete t
  | Command Update :: t -> parse_update t
  | _ -> raise (Malformed "Not a valid Command")

let parse (input : string) =
  let tokens = tokenize input in
  if List.length tokens = 0 then raise Empty
  else if List.hd (List.rev tokens) <> EndOfQuery EOQ then
    raise
      (Malformed
         "No ';' after query, or no appropriate spacing between every \
          symbol")
  else parse_query tokens
