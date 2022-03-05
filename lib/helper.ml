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
