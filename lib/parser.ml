open Tokenizer
open Controller

exception Malformed
exception Empty

(** General Helpers within Parser*)
let rec terminal_to_string tokens =
  match tokens with
  | [] -> ""
  | Tokenizer.String s :: t -> s ^ " " ^ terminal_to_string t
  | Tokenizer.Int i :: t -> string_of_int i ^ " " ^ terminal_to_string t
  | Tokenizer.Float f :: t ->
      string_of_float f ^ " " ^ terminal_to_string t


let token_to_terminal t = match t with
|Terminal terminal -> terminal
|_ -> failwith ("not a terminal")

let token_list_to_terminal_list l = List.map(fun x -> token_to_terminal x)l

(** return a string list for the data in the terminal list*)
let rec terminal_to_string_list (tokens: terminal list): string list =
  match tokens with
  | [] -> []
  | Tokenizer.String s :: t -> s :: terminal_to_string_list t
  | Tokenizer.Int i :: t -> string_of_int i :: terminal_to_string_list t
  | Tokenizer.Float f :: t ->
      string_of_float f :: terminal_to_string_list t

(** turn a string into a list of characters*)
let explode (s: string): char list = List.init (String.length s) (String.get s)      

(** remove any instances of the character in a string *)
let remove_char (c: char)(s: string): string = let char_list = explode s in 
    let filtered_list = List.filter(fun letter -> letter <> c)(char_list) 
  in List.fold_left (fun acc h -> acc ^ (String.make 1 h)) ("") (filtered_list)

(** remove all the () and , in a string *)
let trim_string (s: string) = s |> remove_char '(' |> remove_char ')' |> 
remove_char ',' |> remove_char '\''

let rec sublist i j l = 
  match l with
    [] -> failwith "empty list"
  | h :: t -> 
      let tail = if j = 0 then [] else sublist (i-1) (j-1) t in
      if i >0 then tail else h :: tail

(** get the index of the token SubCommand Values in a tokens list*)
let rec get_val_index (tokens: token list)(n: int): int = match tokens with
| [] -> 0
| h :: t -> if h == SubCommand Values then n else get_val_index t (n + 1)

let parse_table (tokens: token list)(sub_command: token): string = 
  match tokens with
  | [] -> ""
  (** first conver the token into a terminal, then convert to string*)
  | h :: t -> if (h = sub_command) then terminal_to_string 
    ([(List.nth t 0) |> token_to_terminal])
  else raise Malformed


(** input: the tokenized list after the table, return a list of columns*)
(** input: the tokenized list after the table, return a list of columns*)
let parse_cols (cols_tokens: terminal list): string list =
  cols_tokens |> terminal_to_string_list
 
(** return a list of values to insert into columns*)
let parse_vals (vals_tokens: terminal list): string list =
    vals_tokens |> terminal_to_string_list

(** only return the list of terminals associated with columns*)
let get_cols_list(tokens: token list): string list = let sub_list = 
  let val_index = (get_val_index tokens 0) in sublist 2 (val_index - 1) tokens
in terminal_to_string_list (token_list_to_terminal_list sub_list)
 
(** only return the list of temrinals associated with values*)
let get_vals_list(tokens: token list): token list =  let val_index = 
  (get_val_index tokens 0) in sublist (val_index + 1) 
  ((List.length tokens) - 1) tokens

let parse_from tokens = failwith "Unimplemented"
let parse_where tokens = failwith "Unimplemented"

let rec parse_create tokens = (failwith "TODO!")

(* Parse Select Functions: *)
and parse_columns tokens = ["dadada "; "hahaha "]
(** acc is accumulator, cols is token list of columns, from_lst is token
    list for parse_from, lst is the list containing parse_where and so
    on. *)
and get_where acc cols from_lst lst =
  match lst with
  | [] -> raise Malformed
  | EndOfQuery EOQ :: t ->
      select (parse_from from_lst) (parse_columns cols) 
        (parse_where acc);
      parse_query t
  | h :: t -> get_where (h :: acc) cols from_lst t

and get_from acc cols lst =
  match lst with
  | [] -> raise Malformed
  | SubCommand Where :: t -> get_where [] cols acc t
  | EndOfQuery EOQ :: t ->
      select (parse_from acc) (parse_columns cols) (fun _ -> true);
      parse_query t
  | h :: t -> get_from (h :: acc) cols t

and get_cols acc lst =
  match lst with
  | [] -> raise Malformed
  | SubCommand From :: t -> get_from [] acc t
  | h :: t -> get_cols (h :: acc) t

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

(** turns a terminal object into its actual data *)
(**  [SubCommand Into; Terminal (String "Customers");
   Terminal (String "(CustomerName,"); Terminal (String "ContactName,");
   Terminal (String "Address,"); Terminal (String "City,");
   Terminal (String "PostalCode,"); Terminal (String "Country)");
   SubCommand Values; Terminal (String "('Cardinal',");
   Terminal (String "'TomErichsen',"); Terminal (String "'Skagen21',");
   Terminal (String "'Stavanger',"); Terminal (String "4006,");
   Terminal (String "'Norway');")] -> insert ("Cusomters") 
   (["CustomerName; ContactName; Address; City; PostalCode; Country"]) 
   (["Cardinal"; "TE"; "Sk"' "ST"; 4006; "Norway"]) -> unit *)
and parse_insert (tokens: token list) = let table = parse_table(tokens)
(SubCommand Into) in 
let cols = get_cols_list(tokens) in let vals = get_vals_list(tokens) in
  Controller.insert(table)(cols)(vals)

(** TODO: figure out how to call parse_whre *)
and parse_delete tokens = let table = parse_table (tokens)(SubCommand From)
    in Controller.delete(table)(parse_where tokens)
  
and parse_update tokens = failwith "Unimplemented"


let parse (input : string) =
  let tokens = tokenize input in
  if List.length tokens = 0 then raise Empty
  else if List.hd (List.rev tokens) <> EndOfQuery EOQ then
    raise Malformed
  else parse_query tokens

  
open ETree

let rec expression_or_helper
    (tokens : expr_type list)
    (acc : expr_type list) : expr_type list list =
  match tokens with
  | OR :: t -> [ List.rev acc ] @ expression_or_helper t []
  | [] -> [ List.rev acc ]
  | x :: xs -> expression_or_helper xs (x :: acc)

(** Cut [A;OR;B;OR;C] into [\[A\];\[B\];\[C\]] *)
let expressions_or (tokens : expr_type list) : expr_type list list =
  expression_or_helper tokens []
  

(* let expression tokens : token list -> expr_tree = let or_lists =
   expressions_or tokens in match or_lists with | [] -> failwith "NO"

   let parse_where tokens pair_list : token list -> data * data list ->
   bool = let expr = expression tokens in *)
