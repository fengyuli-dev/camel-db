open Tokenizer

(** Representation of dynamic adventure state. *)

(** Partition the line into commands and get rid of ";" *)
val parse : string -> unit

(** Parse one command, calls parse create, insert, delete, update, which
    then calls te controller. *)
val parse_query : token list -> unit

(** 这一波是叫controller functions的兄弟们， the last ones that return units*)

(** [parse_create input] parse a create data base command to send to
    controller_create to create a table. *)
val parse_create : token list -> unit

(** Parse an insert command (make sure to cosume "INTO" because
    tokenizer does not handle that) *)
val parse_insert : token list -> unit

(** Parse delete command, calls controller.delete. *)
val parse_delete : token list -> unit

(** Parse update command and call controller.update *)
val parse_update : token list -> unit

(** Parse select command which calls parse_from and parse_where. *)
val parse_select : token list -> unit

(** [parse_drop input] Parse drop command and tell controller to drop
    either an entire database or entire table. *)
val parse_drop : token list -> unit

(** 这一波return the parameters of controllers, the functions above will
    call the functions below. *)

(** [parse_where expression type_row_pair] parse where clause
    [expression] to a true or false [bool] whether the row data satisfy
    the specified in the where clause, true if row satisfy the condition
    and false otherwise. Requires: where clause [expression] does not
    contain parentheses *)
    
val parse_where : token list -> (ETree.expr_type * ETree.expr_type) list -> bool

(** exposed helper below *)
val expressions_or : ETree.expr_type list -> ETree.expr_type list list

val and_condition_evaluater :
  ETree.expr_type ->
  ETree.expr_type ->
  ETree.expr_type ->
  (ETree.expr_type * ETree.expr_type) list ->
  bool

(* end exposed helper *)

(** We might need a syntax tree for the expressions, it will be
    represented by helper functions within parse_where. *)
