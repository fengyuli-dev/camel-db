exception Malformed
exception Empty

let parse tokens = 
  if List.length tokens = 0 then raise Empty
  else if List.hd (List.rev tokens) <> (EndOfQuery EOQ) then raise Malformed
  else (*parse*)