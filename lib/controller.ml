(** Representation of dynamic adventure state. *)
open Type

open Format
open Rep

(* Useful functions:

   val print_as : int -> string -> unit

   pp_print_as ppf len s prints s in the current pretty-printing box.
   The pretty-printer formats s as if it were of length len.

   val open_tbox : unit -> unit

   This box prints lines separated into cells of fixed width. *)

let parent_db = create_empty_database "parent"
let get_parent_db = parent_db

let terminal_to_string (terminal : terminal) =
  match terminal with
  | Int t -> string_of_int t
  | Float t -> string_of_float t
  | String t -> t

let terminal_list_to_string_list (tlist : terminal list) =
  List.map terminal_to_string tlist

let create
    (db : database)
    (table_name : string)
    (cols : string list)
    (data_types : data_type list) =
  create_table db table_name (List.combine cols data_types)

let insert (db : database) table_name cols value_list =
  insert_row db table_name
    (List.combine cols (terminal_list_to_string_list value_list))

let select (db : database) table_name cols filter_function =
  let table = select db table_name cols filter_function in
  print_endline (pretty_print db table)

let delete (db : database) table_name filtering_function =
  delete_row db table_name filtering_function

let update (db : database) table_name cols values filtering_function =
  update_row db table_name
    (List.combine cols (terminal_list_to_string_list values))
    filtering_function

let drop (db : database) table_name = drop_table db table_name
let save (db : database) table_name = Save.save_file db table_name
