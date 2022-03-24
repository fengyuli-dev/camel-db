open Tokenizer

(** Prints a list of elements, separated by spaces. *)
val print_list : ('a -> string) -> 'a list -> unit

(** Prints a list of elements, separated by newlines. *)
val print_list_newline : ('a -> string) -> 'a list -> unit

(** Convert a key-value pair to a string *)
val key_value_pair_to_string : ('a -> string) -> int * 'a -> string

(** Convert a list of tokens to a string *)
val pp_tokens : token list -> string

(** [get_list_after_where tokens] return the sublist of tokens after the
    where keyword*)
val get_list_after_where : token list -> token list

(** [get_this_command tokens] return the sublist up to everything before
    the first EOQ*)
val get_this_command : token list -> token list

(** [get_other_commands tokens] return the sublist of everything after
    EOQ, to pass into parse_query*)
val get_other_commands : token list -> token list

(** Check if a list contains duplicates *)
val duplicate_in_list : ('a -> 'a -> int) -> 'a list -> bool
