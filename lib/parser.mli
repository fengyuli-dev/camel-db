open Tokenizer

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

(** [parse_delete input] parses a delete database command to send to
    controller_delete to delete rows that satisfies a certain condition *)
val parse_delete : token list -> unit

(** [parse_update input] parses an update database command to send to
    controller.update to update rows that satisfies a certain condition *)
val parse_update : token list -> unit

(** [parse_select input] parses a select command which calls parse_from
    and parse_where. *)
val parse_select : token list -> unit

(** [parse_drop input] parses a drop command and tell controller to drop
    either an entire database or entire table. *)
val parse_drop : token list -> unit

(** [parse_where tokens] is a partial function that takes in data in
    form of pair_data and return a bool. True if data satisfy condition
    [tokens] and false otherwise *)
val parse_where : token list -> token list * token list -> bool

(* exposed helper to test, starting below, comment out when submit *)
val expressions_or : ETree.expr_type list -> ETree.expr_type list list

val and_condition_evaluater :
  ETree.expr_type ->
  ETree.expr_type ->
  ETree.expr_type ->
  (ETree.expr_type * ETree.expr_type) list ->
  bool

val evaluate_or :
  ETree.expr_type list list ->
  (ETree.expr_type * ETree.expr_type) list ->
  bool

(* end exposed helper *)