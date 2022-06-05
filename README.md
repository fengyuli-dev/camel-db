# CamelDB SQL Database
CS 3110 Final Project  
[Chuhan Ouyang](), [Yolanda Wang](), [Emerald Liu](https://github.com/emerisly), [Fengyu Li]()

## Project Description  
In this project, we create a database management system (DBS) that stores data and supports basic SQL queries in OCaml.  
Our system supports users to create and drop tables, insert, and update an entry in the table, read input and create an output.  
To be specific, it supports CRUD (Create, Read, Update, Delete) operations such as SELECT…FROM…WHERE, CREATE, DROP, INSERT, UPDATE, DELETE.  
Detailed description of these operations can be found in "grammar.md". We use REPL (Read-eval-print loop) to allow clients to interact with the DBS.

## Operations we support  

Note that curly braces are not part of the grammar. Colons are for type annotations. *Italics* are types.

query —> create | select | drop | insert | delete | update  
type —> DATABASE | TABLE  
create —> CREATE type {db/table_name : *string*} (schema)  
​	schema —> field_definition {, field_definition}*  
​	field_definition —> {field_name : *string*} datatype | {field_name : *string*} datatype {default : *datatype*}  
​	datatype —> *int* | *float* | *string*  
drop —> DROP {table_name : *string*}  
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

## Install Instructions

Please follow [this guide](https://cs3110.github.io/textbook/chapters/preface/install.html) to install OCaml and setup OPAM.

After that, install required dependencies by `opam install <package>`.

### Dependencies:

1.   `ANSITerminal`
2.   `csv`
3.   `csvtool`

### Run the REPL

Our program provides an REPL interface for the user to interact with. Run `make start` at project root directory to launch it.

### SQL Grammar

Currently, we haven't developed a help page yet. If you're not familiar with SQL grammar, please check the grammar.md file in the same directory as this file. Our program is built primarily upon the grammar defined in that file. If you're not familiar with context-free grammar, you can study [this tutorial](https://www.cs.cornell.edu/courses/cs2112/2021fa/lectures/lecture.html?id=parsing).


#### Customized Grammar:
The condition expression following WHERE phase can only use AND, OR to connect expression. All condition expression can be represented via AND and OR. NOT and parentheses is not supported. For example, a valid condition can be "Country" = "Mexico" AND "Population" > 1000 OR "LandSize" > 10000, an invalid condition can be NOT "Country" = "Mexico".

Especially note that all symbols should be separated with spaces, including the ";" at the end. Here is an example for inspiration: 

" CREATE Persons (PersonID INT, LastName TEXT, FirstName TEXT, Address TEXT, City TEXT) ; "



## Sample Usage  
#### CREATE table  
CREATE Persons PersonID INTEGER, LastName VARCHAR, FirstName VARCHAR, Address VARCHAR, City VARCHAR ; 

#### INSERT (two times)  
INSERT INTO Persons PersonID, LastName, FirstName, Address, City VALUES  9, "Du", "Chuhan", "Risley", "Moon" ; INSERT INTO Persons PersonID, LastName, FirstName VALUES  20, "Li", "Fengyu"  ; INSERT INTO Persons PersonID, LastName, FirstName VALUES  23, "Liu",  "Emerald" ; INSERT INTO Persons PersonID, LastName, FirstName VALUES  93,  "Wang", "Yolanda" ;  
SELECT * FROM Persons ; 

#### Delete  
DELETE FROM Persons WHERE PersonID = 23 ;  
DELETE FROM Persons WHERE FirstName = "Chuhan" OR LastName = "Li" ;  
DELETE FROM Persons WHERE FirstName = "Zhajjjng" ; //fail

#### DROP  
DROP Persons ;

#### Helper Command  
CREATE Persons PersonID INTEGER, LastName VARCHAR, FirstName VARCHAR, Address VARCHAR, City VARCHAR ; INSERT INTO Persons PersonID, LastName, FirstName, Address, City VALUES  9, "Du", "Chuhan", "Risley", "Moon" ; INSERT INTO Persons PersonID, LastName, FirstName VALUES  20, "Li", "Fengyu"  ; INSERT INTO Persons PersonID, LastName, FirstName VALUES  23, "Liu",  "Emerald"  ; INSERT INTO Persons PersonID, LastName, FirstName VALUES  93,  "Wang", "Yolanda" ; SELECT * FROM Persons ;


#### UPDATE  
UPDATE Persons SET PersonID = 999, LastName = Unknown WHERE PersonID = 23 AND LastName = "Liu" ; SELECT * FROM Persons ;

#### SELECT  
SELECT PersonID, FirstName, LastName FROM Persons ;  
SELECT PersonID, FirstName, LastName FROM Persons WHERE PersonID = 20 OR FirstName = "Chuhan" ;

#### SAVE  
SAVE Persons ;


#### READ
READ Persons ;  
INSERT INTO Persons PersonID, LastName, FirstName, Address, City VALUES  100, New, Person, Happy, Hercules ;  
UPDATE Persons SET PersonID = 999, LastName = Unknown WHERE PersonID = 23 AND LastName = Emerald ;  


