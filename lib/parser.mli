(** The parser of the database. It analyzes and executes commands based
    on the ouput of the tokenizer. *)

open Type

(** Exception raised when the command if malformed. *)
exception Malformed of string

(** Exception raised when the command is empty. *)
exception Empty

(** [parse input] partition the line into commands and get rid of ";". *)
val parse : database -> string -> database

(** [parse_query input] parse one command, and call the appropriate
    parse function based on what type of command it is. *)
val parse_query : database -> token list -> database

(** [parse_create input] parse a create database command to send to
    controller_create to create a table. *)
val parse_create : database -> token list -> database

(** [parse_insert input] parse an insert databse command to send to
    controller_insert to insert a new row into an existing table. *)
val parse_insert : database -> token list -> database

(** [parse_insert_test_version tokens] runs parse_insert but it is
    friendly for testing because it has a concrete output type instead
    of unit. *)
val parse_insert_test_version :
  database -> token list -> string * string list * terminal list

(** [parse_delete_test_version input] parse an delete databse command to
    send to controller_insert to insert a new row into an existing
    table. *)
val parse_delete : database -> token list -> database

(** [parse_delete_test_version input] parse an delete databse command to
    send to controller_insert to insert a new row into an existing
    table. *)
val parse_delete_test_version : database -> token list -> string

(** [parse_update tokens] parses an update database command to send to
    controller_update to update rows in an existing dataabase. *)
val parse_update : database -> token list -> database

(** [parse_update_test_version tokens] runs parse_update but it is
    friendly for testing because it has a concrete output type instead
    of unit. *)
val parse_update_test_version :
  database -> token list -> string * string list * terminal list

(** [parse_select input] parses a select command which calls parse_from
    and parse_where. *)
val parse_select : database -> token list -> database

(** [parse_drop input] parses a drop command and tell controller to drop
    either an entire database or entire table. *)
val parse_drop : database -> token list -> database

(** [parse_where tokens] is a partial function that takes condition
    expression and a pair_data. Return true if data satisfy condition
    [tokens] and false otherwise. Requires condition expression to be
    token type but each must be one of expr type, and pair_data must
    have data with same length, column value must be in String and data
    value must be in the corrisponidng String or Int or Float. *)
val parse_where : token list -> string list * string list -> bool

(** [parse_save tokens] saves proposed table as csv files in
    csv_example. *)
val parse_save : database -> token list -> database

(** exposed helper to test, starting below, comment out when deploy. *)
val expressions_or : expr_type list -> expr_type list list

(** Evaluate [and] relationships. *)
val and_condition_evaluater :
  expr_type ->
  expr_type ->
  expr_type ->
  (expr_type * expr_type) list ->
  bool

(** Evaluate [or] relationships. *)
val evaluate_or :
  expr_type list list -> (expr_type * expr_type) list -> bool