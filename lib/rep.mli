open Tree

type column_data =
  | IntColumn of int tree
  | FloatColumn of float tree
  | StringColumn of string tree

type column = {
  name : string;
  data : column_data
}

type table = {
  name : string;
  data : column tree;
}