Test Plan

Below is an documentation of how each part of the system is tested.

1. Tokenizer
The main purpose of the tokenizer is to convert the string literals entered by
the user into defined token types. Since the tokenizer is an integral part of the
parsing system (the tokens generated are passed to parser.ml), the tokenizer
is tested with the parser tests. 

2. Parser
The main purpose of the parser is to parse the string entered by users, associate
it with a specific CRUD operation, extracting useful information out of the
user input and then calling the appropriate controller methods. We are both 
testing the parser using OUnit and manually.

For OUnit testing (test/parser_test.ml), we focus on testing the parse_where
method. The parse_where method is responsible for parsing a condition,
such as "COUNTRY = MEXICO and ID = 5". Parse_where will return a boolean value
indicating whether the data passed in matches the condition. Therefore, we
created token list of sample conditions, with nested and and or conditions,
and passed in sample data. Our test cases examine whether the expected boolean
value matches the one actually produced by the parse_where method. We passed
all the OUnit test cases, showing that our system is able to process conditional
statements. We developed test cases using glass box, testing each combination 
of nested conditional statements.

The rest of the parser system is tested manually. Since the parser calls the 
controller methods, we know that our parser is working when the correct
controller command is called once we enter a command to parse in REPL. 

3. Tree
Tree.ml is the data structure that supports the internal implementation of our
database. The tree method is mostly tested using OUnit testing. We generated sample trees. Then, we created test cases that examine whether the applying get, size, fold, delete, duplicate methods on our sample tree matches the expected outcomes. We passed all the test cases, so our implementation of the tree
is successful. We used glass box testing to test the most important methods
of tree.ml.

4. Rep and Controller.
Rep.ml is the internal representation of our database, utilizing the methods
in tree.ml to support the creation, insertion, deletion, updates, and drops
of the database entries. Controller.ml contains methods that are called by
parser methods. Moreover, controller supports the pretty printing of the current
contents in the database, visually showing the effect of changes with each
CRUD operations.

Rep.ml and Controller.ml are tested together manually. We enter commands, such as
"UPDATE Persons SET PersonID = 999, LastName = 'Unknown' WHERE PersonID = 3 AND LastName = "Yennis" ;" into our REPL to change the database and observe the 
changes by observing the pretty printed table. We know that our CRUD operations
work when the entry is correctly inserted, deleted, or updated. We make
sure to generate various sample table and tested all CRUD operations and combined one operation with another to make sure the contents of the database is always correctly updated.


6. Save
Save.ml is a module that controls the I/O and save to hard-drive of the database. It supports saving the table in a database to a file as well as reading the file back into the database. The files are saved in csv format. We tested this module with OUnit and manual testing.

With OUnit testing, we hardcoded a database called test_db (by inserting entries into the tree). Then, we called save_file on the test_db and made sure it correctly saves to a cvs file. For these test
cases, we used glass box testing since we see what each line of the save_file function does and we also used black box testing and compared saved database file to our expected file output.

With manual testing, we created sample databases and called the save_file functions on them, and observe a csv file being generated in the working directory with the contents that match the ones coded in the
database. 

Overall, by combining OUnit testing and manual testing with the REPL, we guarantee that each part of our system is working correctly.