open Tokenizer

exception Malformed
exception Empty

let parse tokens = 
  if List.length tokens = 0 then raise Empty
  else if List.hd (List.rev tokens) <> (EndOfQuery EOQ) then raise Malformed
  else match tokens with
  | [] -> whatever
  | h :: t -> parse_token h



let parse_query token = 
  match token with
  | Command Create -> parse_create 
  | Command Select ->
  | Command Drop ->
  | Command Insert ->
  | Command Delete ->
  | Command Update ->
  | _ -> raise Malformed
