Note that curly braces are not part of the grammar. Colons are for type annotations. *Italics* are types.

query —> create | select | drop | insert | delete | update

type —> DATABASE | TABLE

create —> CREATE type {db/table_name : *string*} (schema)

​	schema —> field_definition {, field_definition}*

​	field_definition —> {field_name : *string*} datatype | {field_name : *string*} datatype {default : *datatype*}

​	datatype —> *int* | *float* | *string*

drop —> DROP type {db/table_name : *string*}

select —> SELECT columns FROM {table_name : *string*}

​	| SELECT columns FROM {table_name : *string*} WHERE condition {logic_op condition}*

delete —> DELETE FROM {table_name : *string*} WHERE condition {logic_op condition}*

condition —> {field_name : *string*} binary_op {terminal : *datatype*}

binary_op —> = | > | < | >= | <= | !=

logic_op —> AND | OR

columns —> * | {field_name : *string*} {, field_name : *string*}*

insert —> INSERT INTO {table_name : *string*} (columns) VALUES (values)

​	values —> {value : *datatype*} {, value : *datatype*}*

update —> UPDATE {table_name : *string*} SET pairs WHERE condition {logic_op condition}*

​	pairs —> pair {, pair}*

​	pair  —> {field_name : *string*} = {terminal : *datatype*}



