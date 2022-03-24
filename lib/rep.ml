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

let get_field_name = function
  | { field_name; data } -> field_name

let get_field_name_list table =
  let rec extract_list = function
    | [] -> []
    | h :: t -> get_field_name (snd h) :: extract_list t
  in
  extract_list (inorder table.columns)

let get_table_name = function
  | { table_name; columns } -> table_name

(* Index column is always the first column *)
let get_index_column_data table =
  match get 0 table.columns with
  | { field_name; data } ->
      if field_name <> "index" then
        raise (Internal "Index column not at index 0 in column tree")
      else data

let get_column_data = function
  | { field_name; data } -> data

let create_empty_column field_name data_type =
  if field_name = "" then raise IllegalName
  else { field_name; data_type; data = empty }

let create_empty_table table_name =
  if table_name = "" then raise IllegalName
  else
    {
      table_name;
      columns = insert (generate_new_key empty, index_column) empty;
    }

let check_table_integrity table =
  if table.table_name = "" then raise IllegalName
  else if duplicate_in_list compare (get_field_name_list table) then
    raise IllegalName
  else
    let num_entries = size (get_index_column_data table) in
    let checker column = num_entries = size column.data in

    let original_length = size table.columns in
    let new_length = size (filter checker table.columns) in
    if original_length <> new_length then raise WrongTableStructure
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
