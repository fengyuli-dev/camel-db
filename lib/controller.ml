(** Representation of dynamic adventure state. *)

type table = None
type record = None
type data_type = None

let create table_name cols col_types =
  print_endline ("Called the create function. \n Table: " ^ table_name ^ "\n Columns: ");
  print_endline (String.concat " " cols);
  print_endline ("\nTypes: " ^ String.concat " " (List.map Database.col_type_to_string col_types));
  ()

let select table_name cols filter_function =
  print_endline ("Called the select function. \n Table: " ^ table_name ^ "\n Columns: ");
  print_endline (String.concat " " cols);
  ()

let insert table_name cols value_list =
  print_endline ("Called the insert function. \n Table: " ^ table_name ^ "\n Columns: ");
  print_endline (String.concat " " cols ^ "\n Values: ");
  print_endline (String.concat " "  (List.map Database.val_type_to_string value_list));
  ()

let delete table_name filtering_function =
  print_endline ("Called the delete function. \n Table: " ^ table_name);
  ()

let update table_name cols values filtering_function =
  print_endline ("Called the update function. \n Table: " ^ table_name ^ "\n Columns: ");
  print_endline (String.concat " " cols ^ "\n Values: ");
  print_endline (String.concat " "  (List.map Database.val_type_to_string values));
  ()

let drop table_name =
  print_endline ("Called the drop function. \n Table: " ^ table_name);
  ()