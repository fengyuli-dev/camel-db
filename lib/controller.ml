(** Representation of dynamic adventure state. *)

type table = None
type record = None
type data_type = None

let create table_name cols col_types =
  print_endline ("Called the create function. \n Table: " ^ table_name ^ "\n Columns: \n");
  print_endline (String.concat " " cols);
  print_endline ("\nTypes: \n" ^ String.concat " " (List.map Database.col_type_to_string col_types));
  ()

let select table_name cols filter_function =
  print_endline ("Called the select function. \n Table: " ^ table_name ^ "\n Columns: \n");
  print_endline (String.concat " " cols);
  print_endline ("Filter Function: \n" ^ String.concat " " (List.map Database.col_type_to_string col_type));
  ()

let insert table_name cols value_list =
  print_endline ("Inserted " ^ table_name);
  ()

let delete table_name filtering_function =
  print_endline ("Deleted " ^ table_name);
  ()

let update table_name cols values filtering_function =
  print_endline ("Updated " ^ table_name);
  ()

let drop table_name =
  print_endline ("Dropped " ^ table_name);
  ()