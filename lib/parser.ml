open Tokenizer

exception Malformed
exception Empty

let parse (input : string) = 
  let tokens = tokenize input in 
  if List.length tokens = 0 then raise Empty
  else if List.hd (List.rev tokens) <> (EndOfQuery EOQ) then raise Malformed
  else parse_query tokens



let parse_query tokens = 
  match tokens with
  | Command Create :: t -> parse_create t
  | Command Select :: t -> parse_select t
  | Command Drop :: t -> parse_drop t
  | Command Insert :: t -> parse_insert t
  | Command Delete :: t -> parse_delete t
  | Command Update :: t -> parse_update t
  | _ -> raise Malformed