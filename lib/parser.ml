open Tokenizer
open Controller

exception Malformed
exception Empty

(** General Helpers within Parser *)
let rec terminal_to_string tokens =
  match tokens with
  | [] -> ""
  | Tokenizer.String s :: t -> s ^ " " ^ terminal_to_string t
  | Tokenizer.Int i :: t -> string_of_int i ^ " " ^ terminal_to_string t
  | Tokenizer.Float f :: t ->
      string_of_float f ^ " " ^ terminal_to_string t

let token_to_terminal t =
  match t with
  | Terminal terminal -> terminal
  | _ -> failwith "not a terminal"

let token_list_to_terminal_list l =
  List.map (fun x -> token_to_terminal x) l

let rec terminal_to_string_list (tokens : terminal list) : string list =
  match tokens with
  | [] -> []
  | Tokenizer.String s :: t -> s :: terminal_to_string_list t
  | Tokenizer.Int i :: t -> string_of_int i :: terminal_to_string_list t
  | Tokenizer.Float f :: t ->
      string_of_float f :: terminal_to_string_list t

(** [explode s] turn a string into a list of characters*)
let explode (s : string) : char list =
  List.init (String.length s) (String.get s)

(** [remove_char c s] remove any instances of the character in a string *)
let remove_char (c : char) (s : string) : string =
  let char_list = explode s in
  let filtered_list =
    List.filter (fun letter -> letter <> c) char_list
  in
  List.fold_left (fun acc h -> acc ^ String.make 1 h) "" filtered_list

(** [trim_stirng s] remove all the () and , in a string *)
let trim_string (s : string) =
  s |> remove_char '(' |> remove_char ')' |> remove_char ','
  |> remove_char '\''

let rec sublist i j l =
  match l with
  | [] -> failwith "empty list"
  | h :: t ->
      let tail = if j = 0 then [] else sublist (i - 1) (j - 1) t in
      if i > 0 then tail else h :: tail

(** [find elt lst] find the index of the first elt in the list*)
let rec find elt lst =
  match lst with
  | [] -> failwith "not found"
  | h :: t -> if h = elt then 0 else 1 + find elt t

(** [get_val_index tokens] get the index of the occurence token
    SubCommand Values in a tokens list *)
let rec get_val_index (tokens : token list) : int =
  find (SubCommand Values) tokens

(** [parse_table tokens sub_command] is a helper function that parses
    table name based on a sub_command keyword*)
let parse_table (tokens : token list) (sub_command : token) : string =
  match tokens with
  | [] -> ""
  | h :: t ->
      if h = sub_command then
        terminal_to_string [ List.nth t 0 |> token_to_terminal ]
      else raise Malformed

(** [get_list_after_where tokens] return the sublist of tokens after the
    where keyword*)
let get_list_after_where (tokens : token list) : token list =
  let where_index = find (SubCommand Where) tokens in
  sublist (where_index + 1) (List.length tokens - 1) tokens

(** [parse_cols col_tokens] return the list of columns to according to
    the tokens*)
let parse_cols (cols_tokens : terminal list) : string list =
  cols_tokens |> terminal_to_string_list

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

(**[get_vals_list tokens] only return the list of temrinals associated
   with values*)
let get_vals_list (tokens : token list) : token list =
  let val_index = get_val_index tokens in
  sublist (val_index + 1) (List.length tokens - 1) tokens

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
  if not (check_update_list update_list) then raise Malformed
  else
    update_list |> remove_eq |> get_odd_elem
    |> token_list_to_terminal_list |> terminal_to_string_list

(** [get_update_vals update_list] return the list of values to update
    for the correponding columns. Precondition: the update_list is
    correctly formatted*)
let get_update_vals (update_list : token list) : string list =
  if not (check_update_list update_list) then raise Malformed
  else
    update_list |> remove_eq |> get_even_elem
    |> token_list_to_terminal_list |> terminal_to_string_list

(** [get_this_command tokens] return the sublist up to everything before
    the first EOQ*)
let get_this_command (tokens : token list) : token list =
  let eoq_index = find (EndOfQuery EOQ) tokens in
  sublist 0 (eoq_index - 1) tokens

(** [get_other_commands tokens] return the sublist of everything after
    EOQ, to pass into parse_query*)
let get_other_commands (tokens : token list) : token list =
  let eoq_index = find (EndOfQuery EOQ) tokens in
  sublist (eoq_index + 1) (List.length tokens - 1) tokens

(* parse_where helpers *)

open ETree

let token_to_expr_type = function
  | BinaryOp EQ -> EQ
  | BinaryOp GT -> GT
  | BinaryOp LT -> LT
  | BinaryOp GE -> GE
  | BinaryOp LE -> LE
  | BinaryOp NE -> NE
  | LogicOp AND -> AND
  | LogicOp OR -> OR
  | Terminal (String s) -> ETree.String s
  | Terminal (Int i) -> ETree.Int i
  | Terminal (Float f) -> ETree.Float f
  | _ -> raise Malformed

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
  | _ -> failwith "condition not filtered right"

(** [and_conditino_evaluater a op b pair_data] evaluate a single
    condition with only one and [a op b] and see if [pair_data] have
    satisfy this condition. Return true if satisfied, false otherwise *)
let rec and_condition_evaluater
    a
    op
    b
    (pair_data : (expr_type * expr_type) list) =
  match pair_data with
  | [] -> failwith "data base type not found"
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
  | _ -> failwith "invalid list of and conditions"

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

(** see mli file for discription *)
let parse_where (tokens : token list) =
  let exprs = List.map token_to_expr_type tokens in
  parse_where_helper exprs

(* end of parse_where *)

let rec parse_create tokens = failwith "TODO!"

(* Parse Select Functions: *)

(** [parse_columns tokens] convert list of tokens involving column names
    into a list of column names (with stripping). *)
and parse_columns tokens =
  tokens |> terminal_to_string
  |> String.split_on_char ','
  |> List.map String.trim

(** acc is accumulator, cols is token list of columns, from_lst is token
    list for parse_from, lst is the list containing parse_where and so
    on. *)
and get_where acc cols from_lst lst =
  match lst with
  | [] -> raise Malformed
  | EndOfQuery EOQ :: t ->
      select
        (terminal_to_string from_lst)
        (parse_columns cols) (parse_where acc);
      parse_query t
  | h :: t -> get_where (h :: acc) cols from_lst t

and get_from acc cols lst =
  match lst with
  | [] -> raise Malformed
  | SubCommand Where :: t -> get_where [] cols acc t
  | EndOfQuery EOQ :: t ->
      select (terminal_to_string acc) (parse_columns cols) (fun _ ->
          true);
      parse_query t
  | Terminal h :: t -> get_from (h :: acc) cols t
  | _ -> raise Malformed

and get_cols acc lst =
  match lst with
  | [] -> raise Malformed
  | SubCommand From :: t -> get_from [] acc t
  | Terminal h :: t -> get_cols (h :: acc) t
  | _ -> raise Malformed

and parse_select tokens =
  match tokens with
  | [] -> raise Malformed
  | Terminal s :: t -> get_cols [] (Terminal s :: t)
  | _ -> raise Malformed

(** Parse Drop: *)
and parse_drop tokens =
  match tokens with
  | [] -> raise Malformed
  | Terminal s :: t ->
      let rec grouping acc lst =
        match lst with
        | [] -> raise Malformed
        | EndOfQuery EOQ :: t ->
            drop (terminal_to_string acc);
            parse_query t
        | Terminal h :: t -> grouping (h :: acc) t
        | _ -> raise Malformed
      in
      grouping [] (Terminal s :: t)
  | _ -> raise Malformed

and parse_query tokens =
  match tokens with
  | [] -> ()
  | Command Create :: t -> parse_create t
  | Command Select :: t -> parse_select t
  | Command Drop :: t -> parse_drop t
  | Command Insert :: t -> parse_insert t
  | Command Delete :: t -> parse_delete t
  | Command Update :: t -> parse_update t
  | _ -> raise Malformed

and parse_insert (tokens : token list) =
  let this_command = get_this_command tokens in
  let table = parse_table this_command (SubCommand Into) in
  let cols = get_cols_list this_command in
  let vals = get_vals_list this_command in
  Controller.insert table cols vals;
  get_other_commands tokens |> parse_query

and parse_delete tokens =
  let this_command = get_this_command tokens in
  let table = parse_table this_command (SubCommand From) in
  Controller.delete table
    (parse_where (this_command |> get_list_after_where));
  get_other_commands tokens |> parse_query

and parse_update tokens =
  let this_command = get_this_command tokens in
  let table =
    terminal_to_string [ List.nth this_command 0 |> token_to_terminal ]
  in
  Controller.update table
    (this_command |> get_update_list |> get_update_cols)
    (this_command |> get_update_list |> get_update_cols)
    (parse_where (this_command |> get_list_after_where));
  get_other_commands tokens |> parse_query

let parse (input : string) =
  let tokens = tokenize input in
  if List.length tokens = 0 then raise Empty
  else if List.hd (List.rev tokens) <> EndOfQuery EOQ then
    raise Malformed
  else parse_query tokens
