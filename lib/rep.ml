open Tree

exception IllegalName

let default_int = 0

(* We're not using Stdlib.nan because Int doesn't have it. *)
let default_float = 0.
let default_string = "NaN"

type column_data =
  | IntColumn of int tree
  | FloatColumn of float tree
  | StringColumn of string tree

type column = {
  field_name : string;
  data : column_data;
}

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

let create_empty_table table_name =
  if table_name = "" then raise IllegalName
  else { table_name; columns = empty }
