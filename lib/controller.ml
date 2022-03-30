(** Representation of dynamic adventure state. *)
open Format

(*Useful functions:

  val print_as : int -> string -> unit

  pp_print_as ppf len s prints s in the current pretty-printing box. The
  pretty-printer formats s as if it were of length len.

  val open_tbox : unit -> unit

  This box prints lines separated into cells of fixed width. *)

let get_parent_db = "sadness"

let create table_name cols col_types =
  (* let updated_db = 
  let field_type_list = List.combine cols col_types in 
  create_table parent_db table_name field_type_list in *)
  print_endline ""

let select table_name cols filter_function =
  print_endline
    ("\nCalled the select function. \n\n Table: " ^ table_name
   ^ "\n Columns: " ^ String.concat " " cols);

  set_margin 10;
  printf "@[123456@[7@]89A@]@.";

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

let save table_name = failwith "not implemented."
