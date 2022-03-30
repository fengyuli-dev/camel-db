open Tree
open Helper

exception Internal of string
exception WrongTableStructure
exception WrongDBStructure
exception WrongType
exception IllegalName
exception ColumnDNE
exception TableDNE

let debug = true
let default_int = 0

(* We're not using Stdlib.nan because Int doesn't have it. *)
let default_float = 0.
let default_string = "NaN"
let int_of_string s = if s = "NaN" then 0 else Stdlib.int_of_string s

let float_of_string s =
  if s = "NaN" then 0. else Stdlib.float_of_string s

type data_type =
  | Int
  | Float
  | String

type column = {
  field_name : string;
  data_type : data_type;
  data : string tree;
}

type table = {
  table_name : string;
  columns : column tree;
  num_rows : int;
}

type database = {
  database_name : string;
  tables : table tree;
  num_tables : int;
}

(** Dummy placeholder for single database implementation. *)
let parent_db =
  { database_name = "parent"; tables = empty; num_tables = 0 }

(* Helper functions. *)
let get_field_name { field_name; data } = field_name

(** [get_field_name_list table] is the list of field names. *)
let get_field_name_list table =
  let rec extract_list = function
    | [] -> []
    | h :: t -> get_field_name (snd h) :: extract_list t
  in
  extract_list (inorder table.columns)

(** [get_table_name table] is the name of the table. *)
let get_table_name { table_name } = table_name

let get_database_name { database_name } = database_name

(** [get_column_data column] is the list of data in provided column. *)
let get_column_data = function
  | { field_name; data } -> data

(** [create_empty_column f dt] is the constructor of a column. *)
let create_empty_column field_name data_type =
  if field_name = "" then raise IllegalName
  else { field_name; data_type; data = empty }

(** [create_empty_column f dt] is the constructor of a table. *)
let create_empty_table table_name =
  if table_name = "" then raise IllegalName
  else { table_name; columns = empty; num_rows = 0 }

(* let create_empty_database database_name = if database_name = "" then
   raise IllegalName else { database_name; tables = empty; num_tables =
   0 } *)

let get_row_num { table_name; columns; num_rows } = num_rows
let get_col_num table = size table.columns
let get_table_num db = db.num_tables

let rep_ok table =
  if not debug then table
  else if table.table_name = "" then raise IllegalName
  else if duplicate_in_list compare (get_field_name_list table) then
    raise IllegalName
  else
    let checker column = get_row_num table = size column.data in
    let original_col_length = size table.columns in
    let new_col_length =
      size (filter_based_on_value checker table.columns)
    in
    if original_col_length <> new_col_length then
      raise WrongTableStructure
    else table

(* Need to wrap this method for external use *)
let insert_column_internal table column =
  {
    table_name = table.table_name;
    columns =
      insert (generate_new_key table.columns, column) table.columns;
    num_rows = 0;
  }
  |> rep_ok

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
    {
      db with
      tables =
        insert (generate_new_key db.tables, rep_ok new_table) db.tables;
      num_tables = db.num_tables + 1;
    }

let tree_find (filter : 'a -> bool) (tree : 'a tree) =
  let filtered_tree = filter_based_on_value filter tree in
  if size filtered_tree = 1 then get 0 tree else raise Not_found

(** [get_one_cell column row_num] gets the cell in this column whose
    index matches the row_num*)
let get_one_cell (column : column) (row_num : int) : string =
  let data = get_column_data column in
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
  let col_names_list = get_field_name_list table in
  List.filter
    (fun row_num ->
      filtering_function
        (col_names_list, get_one_row db table_name row_num))
    row_num_list

(** return a new column that is the old column whose data tree only
    contain the rows of data that we want to keep.*)
let filter_some_row (old_column : column) (rows_to_keep : int list) :
    column =
  let old_data_tree = get_column_data old_column in
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
  rep_ok { old_table with columns = new_column_tree; num_rows = nr }

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
  rep_ok
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
    {
      db with
      tables =
        (let key =
           get_key
             (fun (table, index) -> table.table_name = table_name)
             db.tables
         in
         update key (rep_ok new_table) db.tables);
    }
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
  if size new_database.tables = size db.tables - 1 then new_database
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
  rep_ok new_table

(** [select table fields filter] returns a new table with only selected
    columns and rows. Note: do not replace the original table with this
    new table in controller.*)
let select
    (db : database)
    (table_name : string)
    (field_list : string list)
    (filtering_function : string list * string list -> bool) =
  let target_table =
    try tree_find (fun table -> table.table_name = table_name) db.tables
    with Not_found -> raise TableDNE
  in
  let new_table =
    select_column
      (filter_table_rows db target_table.table_name filtering_function)
      field_list
  in
  rep_ok new_table

(** return the default value of the data type*)
let default_of_data_type data_type =
  match data_type with
  | Int -> string_of_int default_int
  | Float -> string_of_float default_float
  | String -> default_string

(** insert the default value into a designated column*)
let insert_default_into_column (old_column : column) : column =
  let data_type = old_column.data_type in
  let old_data = old_column.data in
  let new_row = generate_new_key old_data in
  let new_data =
    insert (new_row, default_of_data_type data_type) old_data
  in
  { old_column with data = new_data }

(** return the new table generated by inserting default value in every
    column*)
let insert_default_in_every_column (old_table : table) =
  get_new_table
    (old_table : table)
    insert_default_into_column old_table.num_rows

(** update the data in the specified column and row number with
    [new_data]*)
let update_data_in_column
    (column : column)
    (new_data : string)
    (row_num : int) : column =
  let data = column.data in
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
  { table with columns = new_column_tree }

(** get the row numbers to update, for each column, these row numbers
    need to to be filled with the new value*)
let rec update_row
    (db : database)
    table_name
    fieldname_type_value_list
    filtering_function =
  try
    let new_table =
      (let table =
         tree_find
           (fun table -> table.table_name = table_name)
           db.tables
       in
       let col_tree = table.columns in
       let rows_to_keep =
         get_row_numbers_to_keep db filtering_function table.table_name
       in
       match fieldname_type_value_list with
       | [] -> table
       | (column_name, col_type, data) :: t ->
           let col_key =
             get_key
               (fun (col, index) -> col.field_name = column_name)
               col_tree
           in
           let column = get col_key col_tree in
           let new_column = update_all_rows column data rows_to_keep in
           update_column_in_table col_key new_column table)
      |> rep_ok
    in
    {
      db with
      tables =
        (let key =
           get_key
             (fun (table, index) -> table.table_name = table_name)
             db.tables
         in
         update key (rep_ok new_table) db.tables);
    }
  with NotFound -> raise ColumnDNE

let rec update_one_row_only
    table
    (fieldname_type_value_list : (string * data_type * string) list)
    new_row_index =
  let col_tree = table.columns in
  let rows_to_keep = [ new_row_index ] in
  match fieldname_type_value_list with
  | [] -> table
  | (column_name, col_type, data) :: t ->
      let col_key =
        get_key
          (fun (col, index) -> col.field_name = column_name)
          col_tree
      in
      let column = get col_key col_tree in
      let new_column = update_all_rows column data rows_to_keep in
      update_column_in_table col_key new_column table

let insert_row
    (db : database)
    (table_name : string)
    (fieldname_type_value_list : (string * data_type * string) list) =
  try
    let new_table =
      let key =
        get_key
          (fun (table, index) -> table.table_name = table_name)
          db.tables
      in
      let table = get key db.tables in
      let new_row_index = get_row_num table + 1 in
      let table_with_default_inserted =
        insert_default_in_every_column table
      in
      update_one_row_only table_with_default_inserted
        fieldname_type_value_list new_row_index
    in
    let final_table =
      { new_table with num_rows = new_table.num_rows + 1 }
    in
    {
      db with
      tables =
        (let key =
           get_key
             (fun (table, index) -> table.table_name = table_name)
             db.tables
         in
         update key (rep_ok final_table) db.tables);
    }
  with NotFound -> raise ColumnDNE

open Format

let pretty_print table =
  Format.printf "@[Table: %s@] \n %d columns * %d entries\n"
    (get_table_name table) (get_col_num table) (get_row_num table)

(* TODO: fix type of fieldname_type_value_list *)
