open Tokenizer

exception Malformed
exception Empty

(* Expression of (terminal,binary_op,terminal) *)
type expr = token * token * token

let parse_create tokens = failwith "Unimplemented"
let parse_select tokens = failwith "Unimplemented"
let parse_drop tokens = failwith "Unimplemented"
let parse_insert tokens = failwith "Unimplemented"
let parse_delete tokens = failwith "Unimplemented"
let parse_update tokens = failwith "Unimplemented"

let parse_query tokens =
  match tokens with
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
  match tokens with
  | [] -> [] (* TODO *)
  | x1 :: op :: x2 :: xs -> []
  | _ -> failwith "wrong"
