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

(** Inserts the given key-value pair into the tree. *)
val insert : int * 'a -> 'a tree -> 'a tree

(** Deletes the node with the given key from the tree. Returns the tree
    with the node with the given key removed. *)
val delete : int -> 'a tree -> 'a tree

(** Returns a list of the values in the tree, in order. *)
val inorder : 'a tree -> (int * 'a) list

(** Returns an empty tree. *)
val empty : unit -> 'a tree

(** Bottom-up fold on tree *)
val fold : ('q -> 'b -> 'a -> 'a) -> 'a -> 'b tree -> 'a