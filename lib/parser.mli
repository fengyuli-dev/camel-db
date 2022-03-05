open Tokenizer

(** Representation of dynamic adventure state. *)

val parse : token list -> unit
(** Partition the line into commands and get rid of ";" *)

val parse_query : token list -> unit
(** Parse one command, calls controller. *)

val parse_from : token list -> db
(** Parse from phrase, return the target database/table we are manipulating, used as parameter for calling controller methods. *)

val parse_where : token list -> fun
(** Parse the where clause and return the function that takes a record and returns a boolean. *)

val parse_expression : token list -> bool
(** Parse an expression and return a boolean value, used in WHERE (likely?)*)





 