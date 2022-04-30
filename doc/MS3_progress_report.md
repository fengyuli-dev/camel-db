# MS2 Progress Report

### Authors:

1. Li Fengyu (fl334)
2. Yolanda Wang (yw583)
3. Chuhan Ouyang (co232)
4. Emerald Liu (sl2322)

## Vision

The vision for our project is still what we had described in MS0, to create a database management system (DBS) that stores data and supports basic SQL queries. Our system supports users to create and drop tables, insert, and update an entry in the table, read input and create an output. To be specific, it supports CRUD (Create, Read, Update, Delete) operations such as SELECT…FROM…WHERE, CREATE, DROP, INSERT, UPDATE, DELETE. Detailed description of these operations can be found in "doc/grammar.md". We use REPL (Read-eval-print loop) to allow clients to interact with the DBS. We changed our work plan slighted (some additional feature and removed some other feature)
We implement our own data structure (a binary search tree) and our own parser so that our implementation can be more customizable to our needs. We refrained from using a out-of-the-box data structure or a parser generator to demonstrate the novelty of our work.

## Summary of Progress

## Activity Breakdown

- Lee: Approximate hours spend: 9
- Emerald: Approximate hours spend: 8
- Yolanda: Approximate hours spent: 9
- Chuhan: Approximate hour spent: 9

## Productivity Analysis

## Scope Grade

### Satisfactory : 45/45

1. Be able to not only save specified table to csv file but also read csv file to create table. The additional feature of converting valid csv file to create table.
2. Implement wildcard _ (the same _ in SQl that meaning all/everything) to our table commands.

### Good : 40/40

1. Write tests for the full database that uses example csv files. Complete the testing for the untested parts in trees and other relevant compilation units.

### Excellent ： 15/15

1. Connect database file I/O with the REPL interface and test the whole project by letting real people use it.
