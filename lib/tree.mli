(** Exception raised when trying to insert a node of the same key into
    the tree. *)
exception Duplicate

(** Exception raised when trying to access a key that does not exist in
    the tree. *)
exception NotFound

(** An implementation of a binary search tree data structure. *)
type 'a tree =
  | EmptyLeaf
  | Leaf of (int * 'a)
  | Node of (int * 'a * 'a tree * 'a tree)

(** Returns the value associated with the given key. *)
val get : int -> 'a tree -> 'a

(** Returns the number of nonempty nodes in this tree. *)
val size : 'a tree -> int

(** Inserts the given key-value pair into the tree. *)
val insert : int * 'a -> 'a tree -> 'a tree

(** Deletes the node with the given key from the tree. Returns the tree
    with the node with the given key removed. *)
val delete : int -> 'a tree -> 'a tree

(** Returns a list of the values in the tree, in order. *)
val inorder : 'a tree -> (int * 'a) list

(** An empty tree. *)
val empty : 'a tree

(** Bottom-up fold on tree *)
val fold : ('a -> 'b -> 'a -> 'a) -> 'a -> 'b tree -> 'a

(** Apply the map function on all values of the tree *)
val map : ('a -> 'b) -> 'a tree -> 'b tree

(* Filter on tree, where the filtering function takes into account of
   the value of the tree *)
val filter_based_on_value : ('a -> bool) -> 'a tree -> 'a tree

(* Filter on tree, where the filtering function takes into account of
   the key of the tree *)
val filter_based_on_key : (int -> bool) -> 'a tree -> 'a tree

(** Returns the next largest available key *)
val generate_new_key : 'a tree -> int

(** [get_key f tree] return the key in the tree whose node matches the
    filtering_function f's condition. Precondition: no more than one
    node in the tree would meet this condition.*)
val get_key : ('a * int -> bool) -> 'a tree -> int
