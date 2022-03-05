val print_list : ('a -> string) -> 'a list -> string
(** Prints a list of elements, separated by spaces. *)

val print_list_newline : ('a -> string) -> 'a list -> string
(** Prints a list of elements, separated by newlines. *)

val key_value_pair_to_string : ('a -> string) -> int * 'a -> string
(** Convert a key-value pair to a string *)