open Tokenizer
open Controller

exception Malformed
exception Empty

(* Expression of (terminal,binary_op,terminal) *)
type expr = token * token * token

type data =
  | Int of int
  | Float of float
  | String of string

(** [terminal_to_string tokens_of_string] turns a list of terminal
    tokens that combine to represent a string, into a string, used for
    processing table names, column names, or string text. *)
let rec terminal_to_string tokens : string =
  match tokens with
  | [] -> ""
  | Tokenizer.String s :: t -> s ^ " " ^ terminal_to_string t
  | Tokenizer.Int i :: t -> string_of_int i ^ " " ^ terminal_to_string t
  | Tokenizer.Float f :: t ->
      string_of_float f ^ " " ^ terminal_to_string t

let parse_from tokens = failwith "Unimplemented"
let parse_where tokens = failwith "Unimplemented"

let rec parse_create tokens = (failwith "TODO!")

(** Parse Select Functions: *)
and parse_columns tokens = ["dadada "; "hahaha "]
(** acc is accumulator, cols is token list of columns, from_lst is token
    list for parse_from, lst is the list containing parse_where and so
    on. *)
and get_where acc cols from_lst lst =
  match lst with
  | [] -> raise Malformed
  | EndOfQuery EOQ :: t ->
      select (parse_columns cols) (parse_from from_lst)
        (parse_where acc);
      parse_query t
  | h :: t -> get_where (h :: acc) cols from_lst t

and get_from acc cols lst =
  match lst with
  | [] -> raise Malformed
  | SubCommand Where :: t -> get_where [] cols acc t
  | EndOfQuery EOQ :: t ->
      select (parse_columns cols) (parse_from acc) (fun _ -> true);
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

(** goal: parse the TAB LE, COLS - lst -, VALUES - lst- to feed into
    controller*)
(** [Command Insert; SubCommand Into; Terminal (String "Customers");
 Terminal (String "CustomerName,"); Terminal (String "ContactName,");
 Terminal (String "Address,"); Terminal (String "City,");
 Terminal (String "PostalCode,"); Terminal (String "Country");
 SubCommand Values; Terminal (String "'Cardinal','Tom");
 Terminal (String "B."); Terminal (String "Erichsen','Skagen");
 Terminal (String "21','Stavanger','4006','Norway';")] *)

and parse_insert (tokens : token list) = failwith "Unimplemented"
(* match tokens with | [] -> raise Empty | insert::into *)

and parse_delete tokens = failwith "Unimplemented"
and parse_update tokens = failwith "Unimplemented"

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

let parse (input : string) =
  let tokens = tokenize input in
  if List.length tokens = 0 then raise Empty
  else if List.hd (List.rev tokens) <> EndOfQuery EOQ then
    raise Malformed
  else parse_query tokens

let expression tokens : token list -> expr list =
  (* match tokens with | [] -> [] | x1 :: op :: x2 :: xs -> [] | _ ->
     failwith "wrong" *)
  failwith "Unimplemented"
