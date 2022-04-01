# UTOP Test

## Set up

open Camel_db 

open Type 

open Tokenizer 

open Controller 

open Rep

open Parser



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
CREATE God (Sad INT, Fengyu TEXT) ;

SELECT PersonID, LastName, FirstName, Address, City FROM Persons ;

 INSERT INTO Customers (Name) VALUES ('Cardinal') ; 
 INSERT INTO God (Sad, Fengyu) VALUES (5, hey) ;

CREATE Gods (Fengyu TEXT, Yo TEXT) ; 
INSERT INTO Gods (Yo) VALUES (d) ;
INSERT INTO God Sad VALUES 5 ;
INSERT INTO God

open Camel_db;;
#use "lib/rep.ml";;
#use "test/csv.ml";;
let ftvl = [("Language", "Ruby"); ("Inventor", "Yolanda")];;
update_one_row_only programming_table ftvl 3;;

 DELETE FROM Sauce WHERE CustomerID = 1 ;

SELECT Species FROM Animals ;



let db = parse parent_db "CREATE Animals (Species TEXT, Age INT, Home TEXT) ;";;

let db = parse db "SELECT Species FROM Animals ;";;

select db "Animals" ["Species"] (fun _ -> true);;





- [ ] debug create: create 1 table, create 2 tables
- [x] debug select: select one column, select multiple columns, 
- [ ] debug select rows! parse where function and stuff
- [ ] debug insert: insert 1 row
- [ ] 

