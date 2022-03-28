open Tree
open Helper

exception Internal of string
exception WrongTableStructure
exception WrongType
exception IllegalName

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

let index_column =
  { field_name = "index"; data_type = Int; data = empty }

type table = {
  table_name : string;
  columns : column tree;
}

type database = {
  database_name : string;
  tables : table tree;
}

let get_field_name = function
  | { field_name; data } -> field_name

(** [get_field_name_list table] is the list of field names. *)
let get_field_name_list table =
  let rec extract_list = function
    | [] -> []
    | h :: t -> get_field_name (snd h) :: extract_list t
  in
  extract_list (inorder table.columns)

(** [get_table_name table] is the name of the table. *)
let get_table_name = function
  | { table_name; columns } -> table_name

let get_database_name = function
  | { database_name; tables } -> database_name

(** [get_index_column_data table] is the list of row indexes in the
    index column *)
let get_index_column_data table =
  match get 0 table.columns with
  | { field_name; data } ->
      if field_name <> "index" then
        raise (Internal "Index column not at index 0 in column tree")
      else data

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
  else
    {
      table_name;
      columns = insert (generate_new_key empty, index_column) empty;
    }

let create_empty_database database_name =
  if database_name = "" then raise IllegalName
  else { database_name; tables = empty }

let check_table_integrity table =
  if table.table_name = "" then raise IllegalName
  else if duplicate_in_list compare (get_field_name_list table) then
    raise IllegalName
  else
    let num_entries = size (get_index_column_data table) in
    let checker column = num_entries = size column.data in
    let original_col_length = size table.columns in
    let new_col_length =
      size (filter_based_on_value checker table.columns)
    in
    if original_col_length <> new_col_length then
      raise WrongTableStructure
    else ()

(* Need to wrap this method for external use *)
let insert_column_internal table column =
  let new_table =
    {
      table_name = table.table_name;
      columns =
        insert (generate_new_key table.columns, column) table.columns;
    }
  in
  check_table_integrity new_table;
  new_table

let create_table table_name field_name_type_alist =
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
    List.fold_left
      (fun x y -> insert_column_internal x y)
      empty_table empty_columns

(** let drop_column table column_name = let new_table = { table_name =
    table.table_name; columns = delete } in if check_table_integrity
    new_table then new_table else raise WrongTableStructure *)

(** [get_one_cell column row_num] gets the cell in this column whose
    index matches the row_num*)
let get_one_cell (column : column) (row_num : int) : string =
  let data = get_column_data column in
  get row_num data

(** [get_one_row table_name row_num] returns the data in this row as a
    list, organized in the same order as the order of columns*)
let get_one_row (table : table) (row_num : int) : string list =
  let all_index_and_columns = inorder table.columns in
  let all_columns = List.map (fun x -> snd x) all_index_and_columns in
  List.map (fun col -> get_one_cell col row_num) all_columns

let get_row_num (table : table) : int =
  size (get_index_column_data table)

(** return a list [0,1,2...(num_rows - 1)]. This would be helpful for
    iterating through all the rows*)
let get_list_of_row_numbers (table : table) : int list =
  let num_rows = get_row_num table in
  range num_rows

(** return a list of row numbers that needs to be kept in the new table*)
let get_row_numbers_to_keep
    (filtering_function : string list * string list -> bool)
    (table : table) : int list =
  let row_num_list = get_list_of_row_numbers table in
  let col_names_list = get_field_name_list table in
  List.filter
    (fun row_num ->
      filtering_function (col_names_list, get_one_row table row_num))
    row_num_list

(** return a new column that is the old column whose data tree only
    contain the rows of data that we want to keep.*)
let remove_some_row (old_column : column) (rows_to_keep : int list) :
    column =
  let old_data_tree = get_column_data old_column in
  let new_data_tree =
    filter_based_on_key
      (fun row_num ->
        List.exists (fun elt -> elt = row_num) rows_to_keep)
      old_data_tree
  in
  { old_column with data = new_data_tree }

(** return a new table with the function f applied to each column *)
let get_new_table (old_table : table) (f : column -> column) : table =
  let old_column_tree = old_table.columns in
  let new_column_tree = map f old_column_tree in
  { old_table with columns = new_column_tree }

(** delete_row_internal takes table type as input instead of taking
    string as input for table_name*)
let delete_row_internal
    (table : table)
    (filtering_function : string list * string list -> bool) : table =
  let rows_to_keep = get_row_numbers_to_keep filtering_function table in
  get_new_table table (fun column ->
      remove_some_row column rows_to_keep)

let delete_row table_name filtering_function = failwith "TODO"
let drop_table table_name = failwith "TODO"

let select_rows table_name field_list filtering_function =
  failwith "TODO"

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
let insert_default_in_evey_column (old_table : table) =
  get_new_table (old_table : table) insert_default_into_column

(** update the data in the specified column and row number with
    [new_data]*)
let update_data_in_column
    (column : column)
    (new_data : string)
    (row_num : int) : column =
  let data = column.data in
  let new_data_tree = update row_num new_data data in
  { column with data = new_data_tree }

(** only update the rows in the table that meet the filtering function
    condition*)
let update_relevant_rows
    (table : table)
    (fieldname_type_value_list : string * data_type * string list)
    (rows_to_update : int) : table =
  failwith "TODO"

let update_row_internal
    table_name
    fieldname_type_value_list
    filtering_function =
  failwith "TODO"

let update_row table_name fieldname_type_value_list filtering_function =
  failwith "TODO"

let insert_row_internal
    (table : table)
    (fieldname_type_value_list : string * data_type * string list) :
    table =
  let new_row_index = get_row_num table + 1 in
  let table_with_default_inserted =
    insert_default_in_evey_column table
  in
  update_relevant_rows table_with_default_inserted
    fieldname_type_value_list new_row_index

let insert_row table_name fieldname_type_value_list = failwith "TODO"
