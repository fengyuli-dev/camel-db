# UTOP Test

## Set up

open Camel_db 

open Type 

open Tokenizer 

open Controller 

open Rep

open Parser


# key functions: create, insert, select, delete, update, drop, save

let parent_db = Rep.create_empty_database "parent"

let single_col = ["cat"] 

let single_type : data_type list = [Int]



let cols = ["dog"; "cat"] 

let dts : data_type list = [Type.Int; Type.String]

# create stuff

let db = create parent_db "oneColTab" single_col single_type 

let db = create db "twoColTab" cols dts

# select stuff

let filter_all _ = true

let db = select db "twoColTab" cols filter_all

# Make Start Test Functions

CREATE Persons (PersonID INT, LastName TEXT, FirstName TEXT, Address TEXT, City TEXT) ; CREATE Animals (Species TEXT, Age INT, Home TEXT) ; 
CREATE God (Year INT, Name TEXT) ;

SELECT PersonID, LastName, FirstName, Address, City FROM Persons ;

 INSERT INTO Customers (Name) VALUES ('Cardinal') ; 
 INSERT INTO God (Year, Name) VALUES (5, hey) ;

CREATE Gods (Name TEXT, Yo TEXT) ; 
INSERT INTO Gods (Yo) VALUES (d) ;
INSERT INTO God Year VALUES 5 ;
INSERT INTO God


# Test: Insert empty columns generates all default values
INSERT INTO Persons VALUES ;

# Test: Insert values into some columns, other columns should have default values
INSERT INTO Persons PersonID VALUES 3 ;

# Test: Insert into all columns
INSERT INTO Persons PersonID, LastName, FirstName, Address, City, VALUES 6, "Wang", "Yoyo", 5, "Beijing" ;

# Test: Insert into a column a data with wrong type should generates error message
INSERT INTO Persons PersonID, LastName, FirstName, Address, City VALUES 5, "Li", "Yoyo", "5", "LosAngeles" ;

# Test: Malformed insert command raises error message
INSERT INTO Persons PersonID, LastName, FirstName, Address, City VALUES 5, "Li", "Yoyo", "LosAngeles" ;

# Creating a complete table using insert
CREATE Persons (PersonID INT, LastName TEXT, FirstName TEXT, Address INT, City TEXT) ;  
INSERT INTO Persons PersonID, LastName, FirstName, Address, City VALUES 1, "Zhang", "Yoyo", 5, "LosAngeles" ;
INSERT INTO Persons PersonID, LastName, FirstName, Address, City VALUES 2, "Zhang", "Lolo", 5, "LosAngeles" ;
INSERT INTO Persons PersonID, LastName, FirstName, Address, City VALUES 3, "Xiao", "Ryan", 3, "Ithaca" ;
INSERT INTO Persons PersonID, LastName, FirstName, Address, City VALUES 4, "Zhao", "Nana", 2, "Beijing" ;
INSERT INTO Persons PersonID, LastName, FirstName, Address, City VALUES 5, "Cheng", "Leo", 8, "Ithaca" ;


# UPDATE Test

# DELETE Test
CREATE Persons (PersonID INT, LastName TEXT, FirstName TEXT, Address INT, City TEXT) ;  

# Should only delete the Yoyo Zhang entry
DELETE FROM Persons WHERE PersonID = 1 ;  

# Only delete Leo Cheng
DELETE FROM Persons WHERE LastName = "Cheng" ;  

# Delete Yoyo Zhang and Lolo Zhang
DELETE FROM Persons WHERE Address = 5 ;  

# Delete Yoyo Zhang only
DELETE FROM Persons WHERE PersonID = 1 and LastName = "Zhang" ;  

# Update Tests

# Should change YoYo Zhang to City as Ithaca and ID as 6 and Address as 999
UPDATE Persons SET PersonID = 6, City = 'Ithaca', Address = 999 WHERE PersonID = 1 ;

UPDATE Persons SET PersonID = 99, City = 'Sadness', Address = 5, FirstName = "Ryan", WHERE City = "Ithaca" ;

open Camel_db;;
#use "lib/rep.ml";;
#use "test/csv.ml";;
let ftvl = [("Language", "Ruby"); ("Inventor", "Yolanda")];;
update_one_row_only programming_table ftvl 3;;

 DELETE FROM Sauce WHERE CustomerID = 1 ;

SELECT Species FROM Animals ;

CREATE God (Sad INT, Fengyu TEXT) ;
INSERT INTO God (Sad, Fengyu) VALUES (5, "9") ;
INSERT INTO God Sad VALUES 5 ;
INSERT INTO God VALUES ;



let db = parse parent_db "CREATE Persons (PersonID INT, LastName TEXT, FirstName TEXT, Address TEXT, City TEXT) ; CREATE Animals (Species TEXT, Age INT, Home TEXT) ; CREATE God (Year INT, Name TEXT) ;";;

let db = parse db "SELECT Species FROM Animals ;";;

select db "Animals" ["Species"] (fun _ -> true);;





- [ ] debug create: create 1 table, create 2 tables
- [x] debug select: select one column, select multiple columns, 
- [ ] debug select rows! parse where function and stuff
- [ ] debug insert: insert 1 row
- [ ] 

