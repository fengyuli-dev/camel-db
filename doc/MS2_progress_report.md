# MS2 Progress Report

### Authors:
1. Li Fengyu (fl334)
2. Yolanda Wang (yw583)
3. Chuhan Ouyang (co232)
4. Emerald Liu (sl2322)

## Vision
The vision for our project is still what we had described in MS0, to create a database management system (DBS) that stores data and supports basic SQL queries. Our system supports users to create and drop tables, insert, and update an entry in the table, read input and create an output. To be specific, it supports CRUD (Create, Read, Update, Delete) operations such as SELECT…FROM…WHERE, CREATE, DROP, INSERT, UPDATE, DELETE. Detailed description of these operations can be found in "doc/grammar.md". We use REPL (Read-eval-print loop) to allow clients to interact with the DBS. We followed the plan for MS1 strictly that was written in MS0 besides one minor change that our data base will support one data table right now.

During our development, we found it beneficial to implement our own data structure (a binary search tree) and our own parser so that our implementation can be more customizable to our needs. We refrained from using a out-of-the-box data structure or a parser generator to demonstrate the novelty of our work.

## Summary of Progress
During this short sprint, we have been primarily working on the internal representation of the database as well as connecting it to the controller, a central piece of program that carries out all operations and communicate with the REPL. 

We figured out a way to implement the internal representation using a binary search tree, which we have developed during MS1. We add multiple functionalities to the tree including all high-order functional operations. We then constructed a database that supports multiple tables. We stored every piece of data in the binary search tree, which boosts our database's efficiency compared to a list implementation. We provide numerous ways to manipulate the "data tree" in the `rep` compilation unit, which is called in the controller and serves as the key of the database. 

We made a major change by adding a "Database" type and using it as the parent 

In the controller, we used the parameters from the parsed commands (passed in by Parser) to call functions inside "rep" that actually manipulate the tree based on the commands. This class handles the conversion of parameters and printing for the select function. 

We also implemented the feature to save current data to a csv file. The functions are written in "save.ml", which used a csv library. After parsing the command, controller can call function in save to save the specified table. (We don't have write from file feature yet, that will be in MS3.)


## Activity Breakdown
- Lee: Added some functionalities to the binary search tree. Designed the internal structure of the database and outlined the `rep` compilation unit. Implemented some functions in `rep` that operate on the data tree. Fixed many bugs. Approximate hours spend: 9
- Emerald: Implement file saving feature with csv that convert any table to csv files. Also implemented the naive reading feature from a file to convert it to a table (see "csv_files/csv1.ml"). Fix some parameter dependency to specify one data base. Approximate hours spend: 8
- Yolanda: Implement select function for internal Rep, implement pretty print, refactor out types and clean up code for the project, adjust parser and controller to fit the new functionality of multiple tables, fixed many bugs. Approximate hours spent: 9
- Chuhan: Implemented the internal representation's functions of inserting a new
row, updating a new row, deleting a new row. Extensively used the tree's functions.
Worked on pretty printing with Yolanda. Raised exceptions for illegal insertion, deletion, and updates of the database. Approximate hour spent: 9.  

## Productivity Analysis
Although the amount of work we assigned to ourselves is comparable to MS1, this sprint is somehow much shorter. Therefore, we got extra productive in order to build a running internal structure of the database. 
As a team, we were productive. During team meetings, we mainly focused on discussing the big ideas for project, specifically the interfaces for `rep`. Then, we worked individually to implement the functions that we are assigned to complete. We had a better idea of what helper functions can be extracted and implemented separately, thus avoiding code dupication. 

## Scope Grade
### Satisfactory : 45/45
The satisfactory scope has two task: constructing an internal representation of the database and implementing database operations inside it. We achieved that in the `rep` compilation unit. It has a well-designed tree-based structure as well as numerous methods that manipulate these trees to realize CRUD operations.

### Good : 40/40
1. Connect the command line interface and the parser to the database to demo database operations easier. We will have the command line to print out the actual representation of the data. This is also pretty print of our data to help users to visualize.
   
### Excellent ： 15/15
1. Achieve storing data in a file on the hard drive so data will be kept after accidental or regular shut down like a real data base managing system.
We successfully 

## Goals for the Next Sprint
The database is almost done. This is much faster than our expectation largely because of the insanely short duration of MS2. Little things are left for MS3. In MS3 we plan to accomplish the following:
### Satisfactory
1. Be able to not only save specified table to csv file but also read csv file to create table. The additional feature of converting valid csv file to create table.
2. Implement wildcard * (the same * in SQl that meaning all/everything) to our table commands.
### Good
Write tests for the full database that uses example csv files. Complete the testing for the untested parts in trees and other relevant compilation units.
### Excellent
Connect database file I/O with the REPL interface and test the whole
project by letting real people use it.
Implement extra commands as needed. 