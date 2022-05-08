(** The tokenizer, or the lexer, that precedes the parser. *)

open Type

(** Convert the input string to a list of tokens of type [token]. *)
val tokenize : string -> token list
