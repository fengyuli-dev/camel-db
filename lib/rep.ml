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
    let new_col_length = size (filter checker table.columns) in
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

(* let drop_column table column_name = let new_table = { table_name =
   table.table_name; columns = delete } in if check_table_integrity
   new_table then new_table else raise WrongTableStructure *)

let drop_table table_name = failwith "TODO"

let select_rows table_name field_list filtering_function =
  failwith "TODO"

let insert_row table_name fieldname_type_value_list = failwith "TODO"
let delete_row table_name filtering_function = failwith "TODO"

let update_row table_name fieldname_type_value_list filtering_function =
  failwith "TODO"
