open Tree
open Type
open Helper

exception Internal of string
exception WrongTableStructure
exception WrongDBStructure
exception WrongType
exception IllegalName
exception ColumnDNE
exception TableDNE
exception Duplicate

let debug = false
let default_int = 0

(* We're not using Stdlib.nan because Int doesn't have it. *)
let default_float = 0.
let default_string = "NaN"
let int_of_string s = if s = "NaN" then 0 else Stdlib.int_of_string s

let float_of_string s =
  if s = "NaN" then 0. else Stdlib.float_of_string s

let tree_find (filter : 'a -> bool) (tree : 'a tree) =
  let filtered_tree = filter_based_on_value filter tree in
  if size filtered_tree = 1 then get 0 (update_key filtered_tree)
  else if size filtered_tree = 0 then raise Not_found
  else (
    if debug then print_endline "more than one element found." else ();
    raise Duplicate)

(** Dummy placeholder for single database implementation. *)
let parent_db =
  { database_name = "parent"; tables = empty; num_tables = 0 }

(* Helper functions. *)
let get_field_name { field_name } = field_name
let get_data_type { data_type } = data_type

(** [get_field_name_list_internal table] is the assoc list of field
    names and datatypes. *)
let get_field_name_list_internal table =
  let rec extract_list = function
    | [] -> []
    | h :: t ->
        (get_field_name (snd h), get_data_type (snd h))
        :: extract_list t
  in
  extract_list (inorder table.columns)

(** [get_tablename_list_internal db] is the string list of table names
    of a given [database]. *)
let get_tablename_list_internal database =
  let rec extract_list = function
    | [] -> []
    | (_, { table_name }) :: t -> table_name :: extract_list t
  in
  extract_list (inorder database.tables)

let get_field_name_list database table_name =
  try
    let table =
      tree_find (fun x -> x.table_name = table_name) database.tables
    in
    get_field_name_list_internal table
  with Not_found -> raise TableDNE

(** [get_table_name_internal table] is the name of the table. *)
let get_table_name_internal { table_name } = table_name

let get_database_name_internal { database_name } = database_name

(** [get_column_data_internal column] is the list of data in provided
    column. *)
let get_column_data_internal = function { field_name; data } -> data

let get_column_data database table_name field_name =
  let table =
    tree_find (fun x -> x.table_name = table_name) database.tables
  in
  let column =
    tree_find (fun x -> x.field_name = field_name) table.columns
  in
  let data = get_column_data_internal column in
  to_value_list data

let get_row_num { table_name; columns; num_rows } = num_rows
let get_col_num table = size table.columns
let get_table_num db = db.num_tables

(** [get_one_cell column row_num] gets the cell in this column whose
    index matches the row_num*)
let get_one_cell (column : column) (row_num : int) : string =
  let data = get_column_data_internal column in
  get row_num data

(** [get_one_row table_name row_num] is the data in this row as a list,
    organized in the same order as the order of columns*)
let get_one_row (db : database) (table_name : string) (row_num : int) :
    string list =
  let table =
    tree_find (fun table -> table.table_name = table_name) db.tables
  in
  let all_index_and_columns = inorder table.columns in
  let all_columns = List.map (fun x -> snd x) all_index_and_columns in
  List.map (fun col -> get_one_cell col row_num) all_columns

(** [get_list_of_row_numbers table] is a list [0,1,2...(num_rows - 1)].
    This would be helpful for iterating through all the rows*)
let get_list_of_row_numbers (table : table) : int list =
  let num_rows = get_row_num table in
  range num_rows

open Format

let get_all_rows table =
  try
    let num_rows = table.num_rows in
    let row_list = range num_rows in
    List.map
      (fun row ->
        "| "
        ^ String.concat " | "
            (let all_columns =
               List.map (fun x -> snd x) (inorder table.columns)
             in
             List.map (fun col -> get_one_cell col row) all_columns)
        ^ " |")
      row_list
  with Not_found -> raise TableDNE

let string_of_data_type (dt : data_type) =
  match dt with String -> "String" | Int -> "Int" | Float -> "Float"

let pretty_print_fields table =
  let pair_list = List.split (get_field_name_list_internal table) in
  "| "
  ^ String.concat " | " (fst pair_list)
  ^ " |" ^ "\n| "
  ^ String.concat " | "
      (List.map (fun x -> string_of_data_type x) (snd pair_list))
  ^ " |"

let pretty_print table =
  Format.sprintf "\n @[Table: %s@] \n %d columns * %d entries\n"
    (get_table_name_internal table)
    (get_col_num table) (get_row_num table)
  ^ "\n"
  ^ pretty_print_fields table
  ^ "\n"
  ^ String.concat "\n" (get_all_rows table)

(** [create_empty_column f dt] is the constructor of a column. *)
let create_empty_column field_name data_type =
  if field_name = "" then raise IllegalName
  else { field_name; data_type; data = empty }

(** [create_empty_column f dt] is the constructor of a table. *)
let create_empty_table table_name =
  if table_name = "" then raise IllegalName
  else { table_name; columns = empty; num_rows = 0 }

let create_empty_database database_name =
  if database_name = "" then raise IllegalName
  else { database_name; tables = empty; num_tables = 0 }

(* verifies if table is in valid structure, used in every action that
   creates a table. *)
let rep_ok_tb table =
  if not debug then table
  else if table.table_name = "" then raise IllegalName
  else if duplicate_in_list compare (get_field_name_list_internal table)
  then raise IllegalName
  else
    let checker column = get_row_num table = size column.data in
    let original_col_length = size table.columns in
    let new_col_length =
      size (filter_based_on_value checker table.columns)
    in
    if original_col_length <> new_col_length then
      raise WrongTableStructure
    else table

let rep_ok_db database =
  if not debug then database
  else if database.database_name = "" then raise IllegalName
  else if
    duplicate_in_list compare (get_tablename_list_internal database)
  then raise IllegalName
  else database

let insert_column_internal table column =
  {
    table_name = table.table_name;
    columns =
      insert (generate_new_key table.columns, column) table.columns;
    num_rows = 0;
  }
  |> rep_ok_tb

let create_table db table_name field_name_type_alist =
  if
    duplicate_in_list
      (fun x y -> compare (fst x) (fst y))
      field_name_type_alist
  then raise IllegalName
  else
    let empty_table = create_empty_table table_name in
    let empty_columns =
      List.map
        (fun x -> create_empty_column (fst x) (snd x))
        field_name_type_alist
    in
    let new_table =
      List.fold_left
        (fun x y -> insert_column_internal x y)
        empty_table empty_columns
    in
    let new_db =
      {
        db with
        tables =
          insert
            (generate_new_key db.tables, rep_ok_tb new_table)
            db.tables;
        num_tables = db.num_tables + 1;
      }
    in
    rep_ok_db new_db

(* Core functions and specific helpers. *)

(** return a list of row numbers that needs to be kept in the new table*)
let get_row_numbers_to_keep
    (db : database)
    (filtering_function : string list * string list -> bool)
    (table_name : string) : int list =
  let table =
    tree_find (fun table -> table.table_name = table_name) db.tables
  in
  let row_num_list = get_list_of_row_numbers table in
  let col_names_list =
    fst (List.split (get_field_name_list_internal table))
  in
  List.filter
    (fun row_num ->
      filtering_function
        (col_names_list, get_one_row db table_name row_num))
    row_num_list

(** return a new column that is the old column whose data tree only
    contain the rows of data that we want to keep.*)
let filter_some_row (old_column : column) (rows_to_keep : int list) :
    column =
  let old_data_tree = get_column_data_internal old_column in
  let new_data_tree =
    filter_based_on_key
      (fun row_num ->
        List.exists (fun elt -> elt = row_num) rows_to_keep)
      old_data_tree
  in
  let updated_data_tree = update_key new_data_tree in
  { old_column with data = updated_data_tree }

(** return a new table with the function f applied to each column *)
let get_new_table (old_table : table) (f : column -> column) (nr : int)
    : table =
  let old_column_tree = old_table.columns in
  let new_column_tree = map f old_column_tree in
  rep_ok_tb { old_table with columns = new_column_tree; num_rows = nr }

(** [filter_table_rows] is the old function [delete_row_internal],
    renamed for helper function clarity. It takes table type as input
    instead of taking string as input for table_name*)
let filter_table_rows
    (db : database)
    (table_name : string)
    (filtering_function : string list * string list -> bool) : table =
  let table =
    tree_find (fun table -> table.table_name = table_name) db.tables
  in
  let rows_to_keep =
    get_row_numbers_to_keep db filtering_function table_name
  in
  rep_ok_tb
    (get_new_table table
       (fun column -> filter_some_row column rows_to_keep)
       (List.length rows_to_keep))

let negate_filtering_function
    (filtering_function : string list * string list -> bool)
    (pair_list : string list * string list) =
  not (filtering_function pair_list)

let delete_row
    (db : database)
    (table_name : string)
    (filtering_function : string list * string list -> bool) =
  try
    let old_table =
      tree_find (fun table -> table.table_name = table_name) db.tables
    in
    let negated = negate_filtering_function filtering_function in
    let new_table = filter_table_rows db old_table.table_name negated in
    let new_db =
      {
        db with
        tables =
          (let key =
             get_key
               (fun (table, index) -> table.table_name = table_name)
               db.tables
           in
           update key (rep_ok_tb new_table) db.tables);
      }
    in
    rep_ok_db new_db
  with Not_found -> raise TableDNE

let drop_table db table_name =
  let new_database =
    {
      db with
      tables =
        filter_based_on_value
          (fun x -> x.table_name <> table_name)
          db.tables;
      num_tables = db.num_tables - 1;
    }
  in
  if size new_database.tables = size db.tables - 1 then
    rep_ok_db new_database
  else raise TableDNE

(** filters selected columns of the table according to a field name
    list. *)
let select_column (table : table) (field_list : string list) : table =
  let new_table =
    let new_cols =
      filter_based_on_value
        (fun col ->
          List.exists (fun name -> name = col.field_name) field_list)
        table.columns
      (*go through columns and check if they are included*)
    in
    if List.length field_list = size new_cols then
      {
        table_name = "temp";
        columns = new_cols;
        num_rows = table.num_rows;
      }
    else raise ColumnDNE
  in
  rep_ok_tb new_table

(** [select table fields filter] returns a new table with only selected
    columns and rows. Note: do not replace the original table with this
    new table in controller.*)
let select
    (db : database)
    (table_name : string)
    (field_list : string list)
    (filtering_function : string list * string list -> bool) =
  let target_table =
    try
      let t =
        tree_find (fun table -> table.table_name = table_name) db.tables
      in
      if debug then (
        print_endline table_name;
        print_endline t.table_name;
        print_list (fun x -> fst x) (get_field_name_list_internal t);
        t)
      else t
    with Not_found -> raise TableDNE
  in
  let new_table =
    select_column
      (filter_table_rows db target_table.table_name filtering_function)
      field_list
  in
  rep_ok_tb new_table

(** return the default value of the data type*)
let default_of_data_type (data_type : data_type) =
  match data_type with
  | Int -> string_of_int default_int
  | Float -> string_of_float default_float
  | String -> default_string

(** insert the default value into a designated column*)
let insert_default_into_column (old_column : column) : column =
  let data_type = old_column.data_type in
  let old_data = old_column.data in
  let new_row = generate_new_key old_data in
  if debug then
    print_endline ("The new_row is: " ^ string_of_int new_row)
  else ();
  let new_data =
    insert (new_row, default_of_data_type data_type) old_data
  in
  { old_column with data = new_data }

(** return the new table generated by inserting default value in every
    column*)
let insert_default_in_every_column (old_table : table) =
  get_new_table
    (old_table : table)
    insert_default_into_column
    (old_table.num_rows + 1)

(** update the data in the specified column and row number with
    [new_data]*)
let update_data_in_column
    (column : column)
    (new_data : string)
    (row_num : int) : column =
  let data = column.data in
  if debug then (
    print_endline "The new data";
    print_endline new_data)
  else ();
  let new_data_tree = update row_num new_data data in
  { column with data = new_data_tree }

(** given a column, update all the rows needed to be updated*)
let rec update_all_rows
    (column : column)
    (new_data : string)
    (row_num : int list) : column =
  match row_num with
  | [] -> column
  | h :: t ->
      update_data_in_column
        (update_all_rows column new_data t)
        new_data h

(** update the column at the index in the table to a new column and
    return the new table*)
let update_column_in_table
    (col_key : int)
    (new_column : column)
    (table : table) =
  let old_column_tree = table.columns in
  let new_column_tree = update col_key new_column old_column_tree in
  if debug then (
    print_endline "Inside update column in table function: ";
    print_endline new_column.field_name;
    print_endline
      (pretty_print { table with columns = new_column_tree });
    print_endline "")
  else ();
  { table with columns = new_column_tree }

(* return true if data does not belong to this type*)
let wrong_type data (dp : data_type) =
  let num_int = int_of_string_opt data in
  let num_float = float_of_string_opt data in
  match dp with
  | Int ->
      if debug then print_endline "matched to int" else ();
      num_int = None
      (* if it cannot be converted to int then it has wrong type.*)
  | Float ->
      if debug then print_endline "matched to float" else ();
      num_float = None
      (* if it cannot be converted to float then it has wrong type.*)
  | String -> false

(** get the row numbers to update, for each column, these row numbers
    need to to be filled with the new value*)
let rec update_row
    (db : database)
    table_name
    (fieldname_type_value_list : (string * string) list)
    filtering_function =
  try
    let new_table =
      let table =
        tree_find (fun table -> table.table_name = table_name) db.tables
      in
      let col_tree = table.columns in
      let rows_to_keep =
        get_row_numbers_to_keep db filtering_function table.table_name
      in
      let rec helper lst =
        match lst with
        | [] -> table
        | (column_name, data) :: t ->
            let col_key =
              try
                get_key_col
                  (fun (col, index) -> col.field_name = column_name)
                  col_tree
              with NotFound -> raise (Failure "raised at get_key")
            in
            let column = get col_key col_tree in
            let col_type = column.data_type in
            if wrong_type data col_type then raise WrongType
            else
              let new_column =
                update_all_rows column data rows_to_keep
              in
              let t =
                update_column_in_table col_key new_column (helper t)
              in
              t
      in
      helper fieldname_type_value_list
    in
    let new_db =
      {
        db with
        tables =
          (let key =
             get_key
               (fun (table, index) -> table.table_name = table_name)
               db.tables
           in
           update key (rep_ok_tb new_table) db.tables);
      }
    in
    rep_ok_db new_db
  with
  | NotFound -> raise ColumnDNE
  | Not_found -> raise TableDNE

let rec update_one_row_only
    table
    (fieldname_type_value_list : (string * string) list)
    new_row_index =
  if debug then print_endline (pretty_print table) else ();
  let col_tree = table.columns in
  let rows_to_keep = [ new_row_index ] in
  let new_table =
    let rec helper lst =
      if debug then (
        print_endline
          ("size of the lst parameter."
          ^ string_of_int (List.length lst));
        print_string (string_of_int (List.length lst)))
      else ();
      match lst with
      | [] ->
          if debug then (
            print_string "reached base case yay";
            print_endline (pretty_print table))
          else ();
          table
      | (column_name, data) :: t ->
          if debug then (
            print_endline
              ("size of the t parameter."
              ^ string_of_int (List.length t));
            print_endline "THe current recursive cols are: ";
            print_list (fun (col_name, data) -> col_name ^ " " ^ data) t)
          else ();
          let col_key =
            try
              get_key_col
                (fun (col, index) -> col.field_name = column_name)
                col_tree
            with NotFound ->
              if debug then (
                print_endline column_name;
                print_endline data)
              else ();
              raise (Failure "raised at get_key")
          in
          if debug then
            print_endline
              ("The current col_key is: " ^ string_of_int col_key)
          else ();
          let column =
            try get col_key col_tree
            with NotFound ->
              raise (Failure "raised at get col_key ...")
          in
          let col_type = column.data_type in
          if wrong_type data col_type then raise WrongType
          else
            let new_column = update_all_rows column data rows_to_keep in
            if debug then (
              print_endline ("New Column: " ^ new_column.field_name);
              print_list (fun (k, v) -> v) (inorder new_column.data))
            else ();
            let t =
              update_column_in_table col_key new_column (helper t)
            in
            if debug then (
              print_endline
                ("The current table with " ^ string_of_int col_key
               ^ " updated is: ");
              print_endline (pretty_print t);
              t)
            else t
    in
    if debug then (
      print_endline "list passed in";
      print_string
        (string_of_int (List.length fieldname_type_value_list)))
    else ();
    helper fieldname_type_value_list
  in
  rep_ok_tb new_table

let insert_row
    (db : database)
    (table_name : string)
    (fieldname_type_value_list : (string * string) list) =
  if debug then print_endline "The insert_row function is called."
  else ();
  try
    let key =
      get_key
        (fun (table, index) -> table.table_name = table_name)
        db.tables
    in
    let table = get key db.tables in
    let new_row_index = get_row_num table in
    if debug then
      print_endline ("New row index is: " ^ string_of_int new_row_index)
    else ();
    let table_with_default_inserted =
      insert_default_in_every_column table
    in
    let new_table =
      update_one_row_only table_with_default_inserted
        fieldname_type_value_list new_row_index
    in
    let final_table =
      { new_table with num_rows = new_table.num_rows }
    in
    if debug then print_endline (pretty_print final_table) else ();
    let new_db =
      {
        db with
        tables =
          (let key =
             get_key
               (fun (table, index) -> table.table_name = table_name)
               db.tables
           in
           update key (rep_ok_tb final_table) db.tables);
      }
    in
    rep_ok_db new_db
  with NotFound -> raise ColumnDNE
