exception Duplicate
exception NotFound

type 'a tree =
  | EmptyLeaf
  | Leaf of (int * 'a)
  | Node of (int * 'a * 'a tree * 'a tree * int)

let is_empty = function
  | EmptyLeaf -> true
  | _ -> false

let rec height = function
  | EmptyLeaf -> 0
  | Leaf _ -> 1
  | Node (_, _, _, _, h) -> h

let rec get key = function
  | EmptyLeaf -> raise NotFound
  | Leaf (k, v) -> if k = key then v else raise NotFound
  | Node (k, v, l, r, _) ->
      if k = key then v else if k < key then get key r else get key l

let rec insert key value = function
  | EmptyLeaf -> raise NotFound
  | Leaf (k, v) ->
      if k = key then raise Duplicate
      else
        let new_leaf = Leaf (key, value) in
        if k < key then Node (k, v, EmptyLeaf, new_leaf, 2)
        else Node (k, v, new_leaf, EmptyLeaf, 1)
  | Node (k, v, l, r, h) ->
      if k = key then raise Duplicate
      else
        let new_leaf = Leaf (key, value) in
        if k < key then
          if is_empty r then Node (k, v, l, new_leaf, h)
          else insert key value r
        else if is_empty l then Node (k, v, new_leaf, r, h)
        else insert key value l

let rec get_min = function
  | EmptyLeaf -> raise NotFound
  | Leaf (_, v) -> v
  | Node (_, _, l, _, h) -> get_min l

let rec get_max = function
  | EmptyLeaf -> raise NotFound
  | Leaf (_, v) -> v
  | Node (_, _, _, r, h) -> get_min r

let empty () = EmptyLeaf
