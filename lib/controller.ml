(** Representation of dynamic adventure state. *)
open Format

type table = None
type record = None
type data_type = None

(*Useful functions:

val print_as : int -> string -> unit

pp_print_as ppf len s prints s in the current pretty-printing box. The pretty-printer formats s as if it were of length len.

  val open_tbox : unit -> unit

  This box prints lines separated into cells of fixed width.

*)

let formatter = Format.std_formatter
let pp_cell fmt cell = Format.fprintf fmt "%s" cell
let rec pp_list ?(sep="") pp_element fmt = function
  |[h] -> Format.fprintf fmt "%a" pp_element h
  |h::t ->
      Format.fprintf fmt "%a%s@,%a"
      pp_element h sep (pp_list ~sep pp_element) t
  |[] -> ()

let pp_hbox sep fmt lst = Format.fprintf fmt "@[<h>%a@]@." (pp_list ~sep:sep pp_cell) lst

let create table_name cols col_types =
  print_endline "";
  ()

let select table_name cols filter_function =
  print_endline
    ("\nCalled the select function. \n\n Table: " ^ table_name
   ^ "\n Columns: " ^ String.concat " " cols);

   set_margin 10; printf "@[123456@[7@]89A@]@.";

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