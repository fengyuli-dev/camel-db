parser work distribution + plan finish date

Emerald - parse_where, parse_expression (small syntax tree)
  Finish date - 13th
Yolanda - parse, parse_query, parse_drop, parse_select，parse_from, parse_create
  Finish date - 13th
Chuhan - parse_insert, parse_delete, parse_update



MS2 work plan

1. Tree - Lee (tree) 
2. Controller - Yolanda (create, select) Chuhan (insert, delete, update, drop)
3. File system - Emerald


MS3 work plan

1. add FROMFILE function
   1. FROMFILE Programming

Horizontal:
1. parse first two lines
2. call this command: rep.ml 273 line - create_table db table_name field_name_type_alist
3. parse following lines in a loop:
4. call this command: rep.ml 704 line - insert_row (db : database) (table_name : string) (fieldname_type_value_list : (string * string) list) =
5. these stuff returns a database

Disadvantage: slower, Advantage: more convenient


If Save looks like this:

Language,Inventor,Year Invented
String,String,Int
Java, James Gosling, 1991
Python, Rossum, 1992
OCaml, Leroy, 1996

1. parse first two lines: "Language,Inventor,Year Invented", "String,String,Int"
2. create_table db "Programming" [("Language", String), ("Inventor", String), ("Year Invented", Int)]
3. insert_row db "Programming"(fieldname_type_value_list : [("Language","Java"), ("Inventor", "James Gosling"), ("Year Invented", "1991")])
4. ...

* Rewrite rep insert to get rid of column names.