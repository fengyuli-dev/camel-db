(* Test Plan

   This file contains the concatenated version of all tests of the
   system. There are four main parts in our test suites: expr, parser,
   the save function, and the tree structure. This main file uses the
   "include" keyword to organize the tests in one file for ease of
   execution, but the details of each test suite is left in separate
   files for organizational purposes. Below is a detailed plan of how
   each function of the data base is tested.

   1. Tokenizer The main purpose of the tokenizer is to convert the
   string literals entered by the user into defined token types. Since
   the tokenizer is an integral part of the parsing system (the tokens
   generated are passed to parser.ml), so the tokenizer tests are
   integrated into the parser tests in the second half of the
   `parser_test.ml`.

   2. Parser The main purpose of the parser is to parse the string
   entered by users, associate it with a specific CRUD operation,
   extracting useful information out of the user input and then calling
   the appropriate controller methods. We are both testing the parser
   using OUnit and manually.

   For OUnit testing (test/parser_test.ml), we focus on testing the
   parse_where method that is the most complicated. The parse_where
   method is responsible for parsing a condition, such as "COUNTRY =
   MEXICO and ID = 5". Parse_where will return a boolean value
   indicating whether the data passed in matches the cnodition. There is
   an internal small expr tree within the parse_where function so the
   tree is tested separately in `expr_test.ml`. In addition, in the
   `parser_test` file, we created token list of sample conditions, with
   nested and and or conditions, and passed in sample data. Our test
   cases examine whether the expected boolean value matches the one
   actually produced by the parse_where method. We passed all the OUnit
   test cases, showing that our system is able to process conditional
   statements. We deeveloped test cases using glass box, testing each
   combination of nested conditional statements based on the
   implementation. We also used black box testing, which we tested
   normal and edge case based on the functionality.

   The rest of the parser system is tested with print test in the first
   milestone when we left the controller methods as printing only. These
   commands are very simple and can be reflected through printing the
   fed input of the controller Since the parser calls the controller
   methods, we know that our parser is working when the correct
   controller command is called once we enter a command to parse in
   REPL. The testing procedure is part of the development process. Now,
   for the ease of usage, the print tests are deleted. Changes can be
   seen by calling the `select *` command.

   3. Tree Tree.ml is the data structure that supports the internal
   implementation of our database. The tree method is mostly tested
   using OUnit testing as it is a separable system from the other parts
   of the system. It is a good practice to know the tree is working
   properly before integrating it with the data base. In `tree_test.ml`
   we generated sample trees, and created test cases that examine
   whether the applying get, size, fold, delete, duplicate methods on
   our sample tree matches the expected outcomes. The details of how the
   tree evolves is very important for the data base, so we used glass
   box testing to test the most implrtant methods of tree.ml to make
   sure the tree behaves like we intended.

   4. Rep and Controller Rep.ml is the internal representation of our
   database, utilizing the methods in tree.ml to support the creation,
   insertion, deletion, updates, and drops of the database entries.
   Controller.ml contains methods that are called by parser methods.
   Moreover, controller supports the pretty printing of the current
   contents in the database, visually showing the effect of changes with
   each CRUD operations.

   Since the output of methods within Rep.ml and Controller.ml are best
   reflected through the pretty-printing of `SELECT` instead of through
   assertions, we tested the methods within these files manually. We
   enter commands, such as "UPDATE Persons SET PersonID = 999, LastName
   = 'Unknown' WHERE PersonID = 3 AND LastName = "Yennis" ;" into our
   REPL to change the database and observe the changes by observing the
   pretty printed table. We know that our CRUD operations work when the
   entry is correctly inserted, deleted, or updated. We kept a separate
   document that list all typical and edge cases that we need to deal
   with in our database. We made sure to generate various sample table
   and tested all CRUD operations and combined one operation with
   another to make sure the contents of the database is always correctly
   updated.Every time when a major new feature is finished, we test
   these through `make start` and test by extensive visual check.

   6. Save Save.ml is a module that controls the I/O of the database. It
   supports converting from a database to a file and converting vice
   versa. We tested this module with OUnit and manual testing.

   With OUnit testing, we hardcoded a database called test_db (by
   inserting entries into the tree). Then, we called save_file on tables
   in the test_db and made sure it correctly saves to a cvs file. Since
   it is much more convenient to click into the files to check if rows
   and columns are correct than asserting content within the csv files,
   we just called the save_file function instead of using assertions.
   For these test cases, we used black box testing by just calling the
   `save_file` function and observing if the output matches what we
   want. The implementation details does not matter for the system to
   work.

   With manual testing, we created sample databases and called the
   save_file functions on them, and observe a csv file being generated
   in the working directory with the contents that match the ones coded
   in the database.

   Overall, by using OUnit testing on seperable functionalities and
   manual testing with the REPL on integrated features, we guarantee
   that each part of our system is working correctly. *)

open OUnit2
open Camel_db.Tree
open Camel_db.Type
include Parser_test
include Save_test
include Tree_test
include Expr_test
