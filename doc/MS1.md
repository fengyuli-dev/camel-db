# MS1 Progress Report

Authors:

1.   pupil 1
2.   pupil 2
3.   pupil 3

##### Vision
The vision for our project has not changed signifiantly since MS0. Our vision is still to create a database management system (DBS) that stores data and supports basic SQL queries. Our system supports clients to read input and create an output, create and drop tables, insert, and update an entry in the table, support SELECT….FROM….WHERE queries, and we will use REPL that to allow clients to interact with the DBS.


##### Summary of Progress
During this sprint, we first set up our poject with dune and makefile, so we can build our project with "dune build" as we do in the programming assignments (see dune, dune-project, dune-workspace, and Makefile). Then, we worked on implementing the following 5 functionalities. First, we defined the legal grammar and outline the token types for the SQL commands that we support (see Grammar.md). Then, we implemented a tokenizer that turns a string that the user enters into a list of tokens. We also define the various subtypes for a token, such as a command type, binary operator, or a terminal type (see tokenizer.ml).
We also defined the interfaces for our parser, which parses sql commands, and our controller, which reads the parsed sql commands and start manipulating the databse (see parser.mli and controller.mli)

After that, we implemented the parser, creating individual functions to due with each of the sql CRUD operations (see parser.ml), and we also created a test suite for our parser (see test/main.ml). We realize that to parse conditional expressions in SQL commands, we need a tree, so we implemneted an expression tree (see Etree.ml). We created a test suite for the expression tree (see test/expr.ml). We also implemented the data structure that provides indexing for the database as a tree. It supports basic operations such as find, insert, and delete (see tree.ml) We created test suite for the tree (see test/tree.ml)


##### Activity Breakdown
- Lee
- Emerald
- Yolanda
- Chuhan: Chuhan contributes to discussion of the interfaces for contrller and parser. Chuhan implemented the parsing functions for insert, delete, and update, and added tests for these functions. Chuhan worked for 8 hours.

##### Productivity Analysis
As a team, we were productive. During team meetings, we mainly focused on discussing the big ideas for project, specifically the interfaces for parsers, controller, tokens and the implementation for our tree. Then, we worked individually to implement the functions that we are assigned to complete. We accompolished what we planned and our estimates were accurate.

##### Scope Grade

##### Goals for the Next Sprint
