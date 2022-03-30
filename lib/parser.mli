
open Type
(** Representation of dynamic adventure state. *)

(** [parse input] partition the line into commands and get rid of ";" *)
val parse : string -> unit

(** [parse_query input] parse one command, and call the appropriate
    parse function based on what type of command it is*)
val parse_query : token list -> unit

(** [parse_create input] parse a create database command to send to
    controller_create to create a table. *)
val parse_create : token list -> unit

(** [parse_insert input] parse an insert databse command to send to
    controller_insert to insert a new row into an existing table*)
val parse_insert : token list -> unit

(**[parse_insert_test_version tokens] runs parse_insert but it is
   friendly for testing because it has a concrete output type instead of
   unit*)
val parse_insert_test_version :
  token list -> string * string list * val_type list

(** [parse_delete_test_version input] parse an delete databse command to
    send to controller_insert to insert a new row into an existing table*)
val parse_delete : token list -> unit

(** [parse_delete_test_version input] parse an delete databse command to
    send to controller_insert to insert a new row into an existing table*)
val parse_delete_test_version : token list -> string

(** [parse_update tokens] parses an update database command to send to
    controller_update to update rows in an existing dataabase*)
val parse_update : token list -> unit

(**[parse_update_test_version tokens] runs parse_update but it is
   friendly for testing because it has a concrete output type instead of
   unit*)
val parse_update_test_version :
  token list -> string * string list * val_type list

(** [parse_select input] parses a select command which calls parse_from
    and parse_where. *)
val parse_select : token list -> unit

(** [parse_drop input] parses a drop command and tell controller to drop
    either an entire database or entire table. *)
val parse_drop : token list -> unit

(** [parse_where tokens] is a partial function that takes condition
    expression and a pair_data. Return true if data satisfy condition
    [tokens] and false otherwise. Requires condition expression to be
    token type but each must be one of expr type, and pair_data must
    have data with same length, column value must be in String and data
    value must be in the corrisponidng String or Int or Float. *)
val parse_where : token list -> token list * token list -> bool

val parse_save : token list -> unit

(* exposed helper to test, starting below, comment out when deploy *)

val expressions_or : expr_type list -> expr_type list list

val and_condition_evaluater :
  expr_type ->
  expr_type ->
  expr_type ->
  (expr_type * expr_type) list ->
  bool

val evaluate_or :
  expr_type list list -> (expr_type * expr_type) list -> bool

(* end exposed helper *)