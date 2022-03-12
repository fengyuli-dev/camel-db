(** Representation of dynamic adventure state. *)

type table = None
type record = None
type data_type = None

let create table_name col_name_col_type_list = failwith "Unimplemented"
let select columns table filter_function = failwith "Unimplemented"
let insert table_name cols value_list = failwith "Unimplemented"
let delete table_name filtering_function = failwith "Unimplemented"
let update cols values filtering_function = failwith "Unimplemented"
let drop table_name = failwith "Unimplemented"

