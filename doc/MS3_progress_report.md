# MS3 Progress Report

## Authors

1. Fengyu Li (fl334)
2. Yolanda Wang (yw583)
3. Chuhan Ouyang (co232)
4. Emerald Liu (sl2322)

## Vision

The vision for our project is still what we had described in MS0, to create a database management system (DBS) that stores data and supports basic SQL queries. Our system supports users to create and drop tables, insert, and update an entry in the table, read input and create an output. To be specific, it supports CRUD (Create, Read, Update, Delete) operations such as SELECT…FROM…WHERE, CREATE, DROP, INSERT, UPDATE, DELETE. Detailed description of these operations can be found in "doc/grammar.md". We use REPL (Read-eval-print loop) to allow clients to interact with the DBS. We followed the plan for MS1 strictly that was written in MS0 besides one minor change that our data base will support one data table right now.

During our development, we found it beneficial to implement our own data structure (a binary search tree) and our own parser so that our implementation can be more customizable to our needs. We refrained from using a out-of-the-box data structure or a parser generator to demonstrate the novelty of our work.


## Summary of Progress

During this last sprint, we focused on bug fixing while also introducing new features to our database. We also wrote more test suites to test our implementation.

We support a new feature of reading a csv file and processing it, turning it into a database that can then be manipulated using our SQL commands. This complements our existing feature of outputting as a csv file. We also enhanced our SELECT command by allowing wildcard symbols in the select queries. In this way, our SELECT would support most functionalities in the original SQL standard protocol by allowing filters, wildcards, and field queries. The support of wildcards, SELECT *, is a new feature we added. Additionally, we rewrote the pretty print method of the database. The REPL output that displays the content of the database is now much more organized and legible.

Besides these features, we implemented test suites for each major parts of our program. Details about our test scheme is available in `test/main.ml`.

Lastly, we fixed numerous bugs in our program. The internal representation was coded in a hurry because of MS2’s relatively short time span. Our program is now more robust and usable. We also improved our code quality by closely examining each file.

Our final eventual deliverable should contain about 2400 loc.

## Activity Breakdown

- Fengyu: Collaborate in debugging, organize documentation of the whole project and make sure make docs works fine, Approximate hours spend: 8
- Emerald: Implement the additional feature of converting valid database files to data base. Also added more documentation for different features and files. Approximate hours spend: 8
- Yolanda: Refactor testing to fit the make test criteria, organize test plan. Approximate hours spent: 9
- Chuhan: Refactor long code and clean up coding style, organize test plan, make pretty print prettier, debug edge cases of rep.ml, implement "select all" function. Approximate hour spent: 9

## Productivity Analysis

Our work allotted is actually not as much because the majority of the implementation is done in MS2 and only some small additional features, documentation, and debugging are left for MS3. We mainly focused on these tasks and peer-reviewed our code in order to debug and refactor.
As a team, we were productive. During team meetings, we mainly focused on discussing the unresolved bugs and potential new features for the project. We worked individually to implement the functions that we are assigned to complete and the bugs that we introduced in the two earlier sprints. To improve code quality, we reviewed each other’s work and made revisions.

## Scope Grade

### Satisfactory

1. Be able to not only save specified table to csv file but also read csv file to create table. The additional feature of converting valid csv file to create table. This is implemented successfully with the same csv library. We can now read any valid database csv file and convert it to a database. 

2. Implement wildcard * (the same * in SQl that meaning all/everything) to our table commands.


### Good
1. Write tests for the full database that uses example csv files. Complete the testing for the untested parts in trees and other relevant compilation units.


### Excellent
1. Connect database file I/O with the REPL interface and test the whole project by letting real people use it.

2. Implement extra commands as needed. 
