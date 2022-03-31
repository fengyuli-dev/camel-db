(** Representation of dynamic adventure state. *)
open Type
open Format
open Rep

(* Useful functions:

   val print_as : int -> string -> unit

   pp_print_as ppf len s prints s in the current pretty-printing box. The
   pretty-printer formats s as if it were of length len.

   val open_tbox : unit -> unit

   This box prints lines separated into cells of fixed width. *)

let parent_db = create_empty_database "parent"
let get_parent_db = parent_db

let create (table_name : string) (cols : string list) (data_types : data_type list) =
  (* let updated_db = 
  let field_type_list = List.combine cols data_types in 
  create_table parent_db table_name field_type_list in *)
  print_endline ""

let select table_name cols filter_function =
  print_endline ""

let insert table_name cols value_list =
  print_endline ""

let delete table_name filtering_function =
  print_endline ""

let update table_name cols values filtering_function =
  print_endline ""

let drop table_name =
  print_endline ""

let save table_name = print_endline ""
