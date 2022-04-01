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

CREATE Persons (PersonID INT, LastName TEXT, FirstName TEXT, Address TEXT, City TEXT)

CREATE Animals (Species TEXT, Age INT, Home TEXT) ;

CREATE God (Sad INT, Fengyu TEXT) ; INSERT INTO Customers (Name) VALUES ('Cardinal') ; DELETE FROM Sauce WHERE CustomerID = 1 ;

SELECT Species FROM Animals ;