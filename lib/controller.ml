(** Representation of dynamic adventure state. *)

type table = None
type record = None
type data_type = None

let pretty_print table =
  Printf.printf "Table %s has %d columns and %d valid entries\n"
    (Rep.get_table_name table)
    (Rep.get_col_num table) (Rep.get_row_num table)

let create table_name cols col_types =
  print_endline
    ("\nCalled the create function. \n\n Table: " ^ table_name
   ^ "\n Columns: " ^ String.concat " " cols);
  print_endline
    ("Types: "
    ^ String.concat " " (List.map Database.col_type_to_string col_types)
    );
  print_endline "";
  ()

let select table_name cols filter_function =
  print_endline
    ("\nCalled the select function. \n\n Table: " ^ table_name
   ^ "\n Columns: " ^ String.concat " " cols);
  ()

let insert table_name cols value_list =
  print_endline
    ("\nCalled the insert function. \n\n Table: " ^ table_name
   ^ "\n Columns: " ^ String.concat " " cols);
  print_endline "Values: ";
  print_endline
    (String.concat " "
       (List.map Database.val_type_to_string value_list));
  ()

let delete table_name filtering_function =
  print_endline
    ("\nCalled the delete function. \n\n Table: " ^ table_name);
  ()

let update table_name cols values filtering_function =
  print_endline
    ("\nCalled the update function. \n\n Table: " ^ table_name
   ^ "\n Columns: " ^ String.concat " " cols);
  print_endline "Values: ";
  print_endline
    (String.concat " " (List.map Database.val_type_to_string values));
  ()

let drop table_name =
  print_endline ("Called the drop function. \n\n Table: " ^ table_name);
  ()