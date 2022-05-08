(** A module that controls the I/O of the database. *)

open Type

(** [save_file db table_name] save all current datas in table
    [table_name] in database [db] to a file. *)
val save_file : database -> string -> unit

(** [file_to_db db table_name] convert table [table_name] in csv format
    back into a table in database [db]. *)
val file_to_db : database -> string -> database