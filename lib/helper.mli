(** Prints a list of elements, separated by spaces. *)
val print_list : ('a -> string) -> 'a list -> unit

(** Prints a list of elements, separated by newlines. *)
val print_list_newline : ('a -> string) -> 'a list -> unit

(** Convert a key-value pair to a string *)
val key_value_pair_to_string : ('a -> string) -> int * 'a -> string

(** Return a sublist of the input only including elements at indices b to e,
  inclusive*)
val sublist: int -> int -> 'a list -> 'a list
