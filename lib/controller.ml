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

(*Button for print test. *)
let debug = true
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
  try
    let new_db =
      create_table db table_name (List.combine cols data_types)
    in
    if debug then
      print_endline
        (pretty_print new_db
           (select new_db table_name cols (fun (_, _) -> true)))
    else ();
    new_db
  with IllegalName ->
    print_endline
      (table_name
     ^ "is already a table in the current database. Please reenter.");
    db

let insert (db : database) table_name cols value_list =
  try
    insert_row db table_name
      (List.combine cols (terminal_list_to_string_list value_list))
  with ColumnDNE ->
    print_endline
      "Some columns of the insertion attempt is not in the table.";
    db

let select (db : database) table_name cols filter_function =
  try
    let table = select db table_name cols filter_function in
    print_endline (pretty_print db table)
  with
  | TableDNE ->
      print_endline
        (table_name
       ^ " in the select attempt is not in the current database.")
  | ColumnDNE ->
      print_endline
        "Some columns of the insertion attempt is not in the table."

let delete (db : database) table_name filtering_function =
  try delete_row db table_name filtering_function
  with TableDNE ->
    print_endline
      "The table in the delete attempt is not in the current database.";
    db

let update (db : database) table_name cols values filtering_function =
  try
    update_row db table_name
      (List.combine cols (terminal_list_to_string_list values))
      filtering_function
  with ColumnDNE ->
    print_endline
      "Some columns of the update attempt is not in the table.";
    db

let drop (db : database) table_name =
  try drop_table db table_name
  with TableDNE ->
    print_endline
      "The table in the drop attempt is not in the current database.";
    db

let save (db : database) table_name =
  try Save.save_file db table_name
  with TableDNE ->
    print_endline
      "The table in the save attempt is not in the current database."
