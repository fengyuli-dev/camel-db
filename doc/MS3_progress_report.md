# MS3 Progress Report

## Authors

1. Fengyu Li (fl334)
2. Yolanda Wang (yw583)
3. Chuhan Ouyang (co232)
4. Emerald Liu (sl2322)

## Vision

The vision for our project is still what we had described in MS0, to create a database management system (DBS) that stores data and supports basic SQL queries. Our system supports users to create and drop tables, insert, and update an entry in the table, read input and create an output. To be specific, it supports CRUD (Create, Read, Update, Delete) operations such as SELECT…FROM…WHERE, CREATE, DROP, INSERT, UPDATE, DELETE. Detailed description of these operations can be found in "doc/grammar.md". We use REPL (Read-eval-print loop) to allow clients to interact with the DBS. We changed our work plan slighted (some additional feature and removed some other feature)
We implement our own data structure (a binary search tree) and our own parser so that our implementation can be more customizable to our needs. We refrained from using an out-of-the-box data structure or a parser generator to demonstrate the novelty of our work.

## Summary of Progress

During this last sprint, we focused on bug fixing while also introducing a few features to our database. We also wrote some test suites to test our implementation. We support a new feature of reading a csv file and processing it, turning it into a database that can then be manipulated using our SQL commands. This complements our existing feature of outputting as a csv file. We also enhanced our SELECT command by allowing wildcard symbols in the select queries. In this way, our SELECT would support most functionalities in the original SQL standard protocol by allowing filters, wildcards, and field queries. Additionally, we rewrote the pretty print method of the database. The REPL output that displays the content of the database is now much more organized and legible. 

Besides these features, we implemented

## Activity Breakdown

- Fengyu: Approximate hours spend: 7
- Emerald: Approximate hours spend: 8
- Yolanda: Approximate hours spent: 9
- Chuhan: Approximate hour spent: 9

## Productivity Analysis

## Scope Grade

### Satisfactory : 45/45

1. Be able to not only save specified table to csv file but also read csv file to create table. The additional feature of converting valid csv file to create table.
2. Implement wildcard _(the same_ in SQl that meaning all/everything) to our table commands.

### Good : 40/40

1. Write tests for the full database that uses example csv files. Complete the testing for the untested parts in trees and other relevant compilation units.

### Excellent ： 15/15

1. Connect database file I/O with the REPL interface and test the whole project by letting real people use it.
