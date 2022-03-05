open Tokenizer

(** Representation of dynamic adventure state. *)


(** Partition the line into commands and get rid of ";" *)
val parse : token list -> unit


(** Parse one command, calls parse create, insert, delete, update, 
which then calls te controller. *)
val parse_query : token list -> unit

(** 这一波是叫controller functions的兄弟们， the last ones that return units*)


(** [parse_create input] parse a create data base command to send 
to controller_create to create a table. Create table with input in syntax 
"CREATE TABLE table_name (data_catagory data_type *)". *)
val parse_create : token list -> unit


(** Parse an insert command  (make sure to cosume "INTO" because tokenizer 
does not handle that) *)
val parse_insert : token list -> unit


(** Parse delete command, calls controller.delete. *)
val parse_delete : token list -> unit


(** Parse update command and call controller.update *)
val parse_update : token list -> unit


(** Parse select command which calls parse_from and parse_where. *)
val parse_select : token list -> unit


(** [parse_drop input] Parse drop command and tell controller to drop either 
an entire database or entire table. *)
val parse_drop : token list -> unit


(** 这一波return the parameters of controllers, the functions above will call 
the functions below. *)


(** Parse the from phrase, return the target table we are manipulating, 
used as parameter for calling controller methods. *)
val parse_from : token list -> data_base


(** [parse_where input] parse the where clause and return the function that 
takes a row in the table repersented by record and returns a boolean. True
if the row match and False if the row does not *)
val parse_where : token list -> fun


(** [parse_expression input] parse input which is expression such as 
"Country = USA" or "AGE > 18" and return a boolean value, used in WHERE *)
val parse_expression : token list -> fun

(** We might need a syntax tree for the expressions. *)