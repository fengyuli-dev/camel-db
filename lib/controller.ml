(** Representation of dynamic adventure state. *)

type table = None
type record = None
type data_type = None

let create table_name cols col_types =
  print_endline ("Created " ^ table_name);
  ()

let select table_name cols filter_function =
  print_endline ("Selected " ^ table_name);
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

let select table_name cols filter_function =
  print_endline ("Selected " ^ table_name);
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
