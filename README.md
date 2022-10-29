# CamelDB SQL Database
[Chuhan Ouyang](), [Yolanda Wang](), [Emerald Liu](https://github.com/emerisly), [Fengyu Li]() (equal contribution)

## Project Description  
In this project, we create a database management system (DBMS) that stores data and supports basic SQL queries in OCaml.  
Our system supports users to create and drop tables, insert, and update an entry in the table, read input and create an output.  
To be specific, it supports CRUD (Create, Read, Update, Delete) operations such as `SELECT…FROM…WHERE`, `CREATE`, `DROP`, `INSERT`, `UPDATE`, and `DELETE`.  
Detailed description of these operations and their syntax can be found in grammar.md. We provide an REPL (Read-eval-print loop) to allow clients to interact with the DBS. It can also easily adapt to provide outside APIs.

## Install Instructions

Please follow [this guide](https://cs3110.github.io/textbook/chapters/preface/install.html) to install OCaml and setup OPAM.

After that, install required dependencies by `opam install <package>`.

### Dependencies:

1.   `ANSITerminal`
2.   `csv`
3.   `csvtool`

### Run the REPL (Read-Evaluate-Print-Loop Frontend)

Our program provides an REPL interface for the user to interact with. Run `make start` at project root directory to launch it.

### SQL Grammar

Currently, we haven't developed a help page yet. If you're not familiar with SQL grammar, please check the grammar.md file in the same directory as this file. Our program is built primarily upon the grammar defined in that file. If you're not familiar with context-free grammar, you can study [this tutorial](https://www.cs.cornell.edu/courses/cs2112/2021fa/lectures/lecture.html?id=parsing).


#### Customized Grammar:
The condition expression following WHERE phase can only use AND, OR to connect expression. All condition expression can be represented via AND and OR. NOT and parentheses is not supported. For example, a valid condition can be "Country" = "Mexico" AND "Population" > 1000 OR "LandSize" > 10000, an invalid condition can be NOT "Country" = "Mexico".

Especially note that all symbols should be separated with spaces, including the ";" at the end. Here is an example for inspiration: 
```
" CREATE Persons (PersonID INT, LastName TEXT, FirstName TEXT, Address TEXT, City TEXT) ; "
```


## Sample Usage  
#### CREATE table  
```
CREATE Persons PersonID INTEGER, LastName VARCHAR, FirstName VARCHAR, Address VARCHAR, City VARCHAR ; 
```

#### INSERT (two times)  
```
INSERT INTO Persons PersonID, LastName, FirstName, Address, City VALUES  9, "Du", "Chuhan", "Risley", "Moon" ; INSERT INTO Persons PersonID, LastName, FirstName VALUES  20, "Li", "Fengyu"  ; INSERT INTO Persons PersonID, LastName, FirstName VALUES  23, "Liu",  "Emerald" ; INSERT INTO Persons PersonID, LastName, FirstName VALUES  93,  "Wang", "Yolanda" ;  
SELECT * FROM Persons ; 
```

#### Delete  
```
DELETE FROM Persons WHERE PersonID = 23 ;  
DELETE FROM Persons WHERE FirstName = "Chuhan" OR LastName = "Li" ;  
DELETE FROM Persons WHERE FirstName = "Zhajjjng" ; //fail
```

#### DROP  
```
DROP Persons ;
```

#### Helper Command 
```
CREATE Persons PersonID INTEGER, LastName VARCHAR, FirstName VARCHAR, Address VARCHAR, City VARCHAR ; INSERT INTO Persons PersonID, LastName, FirstName, Address, City VALUES  9, "Du", "Chuhan", "Risley", "Moon" ; INSERT INTO Persons PersonID, LastName, FirstName VALUES  20, "Li", "Fengyu"  ; INSERT INTO Persons PersonID, LastName, FirstName VALUES  23, "Liu",  "Emerald"  ; INSERT INTO Persons PersonID, LastName, FirstName VALUES  93,  "Wang", "Yolanda" ; SELECT * FROM Persons ;
```

#### UPDATE  
```
UPDATE Persons SET PersonID = 999, LastName = Unknown WHERE PersonID = 23 AND LastName = "Liu" ; SELECT * FROM Persons ;
```

#### SELECT  
```
SELECT PersonID, FirstName, LastName FROM Persons ;  
SELECT PersonID, FirstName, LastName FROM Persons WHERE PersonID = 20 OR FirstName = "Chuhan" ;
```

#### SAVE  
```
SAVE Persons ;
```

#### READ
```
READ Persons ;  
INSERT INTO Persons PersonID, LastName, FirstName, Address, City VALUES  100, New, Person, Happy, Hercules ;  
UPDATE Persons SET PersonID = 999, LastName = Unknown WHERE PersonID = 23 AND LastName = Emerald ; 
```


