## CREATE table

CREATE Persons PersonID INTEGER, LastName VARCHAR, FirstName VARCHAR, Address VARCHAR, City VARCHAR ; 

## INSERT (two times)

INSERT INTO Persons PersonID, LastName, FirstName, Address, City VALUES  9,  "Chuhan",  "Du", "Risley", "Moon" ; INSERT INTO Persons PersonID, LastName, FirstName VALUES  20,  "Fengyu",  "Li"  ; INSERT INTO Persons PersonID, LastName, FirstName VALUES  23,  "Emerald",  "Liu"  ; INSERT INTO Persons PersonID, LastName, FirstName VALUES  93,  "Yolanda",  "Wang" ; 

SELECT * FROM Persons ; 

## Delete 

DELETE FROM Persons WHERE PersonID = 23 ;

DELETE FROM Persons WHERE LastName = "Chuhan" OR FirstName = "Li" ;

DELETE FROM Persons WHERE FirstName = "Zhajjjng" ;



## DROP

DROP Persons ;

## Helper Command

CREATE Persons PersonID INTEGER, LastName VARCHAR, FirstName VARCHAR, Address VARCHAR, City VARCHAR ; INSERT INTO Persons PersonID, LastName, FirstName, Address, City VALUES  9,  "Chuhan",  "Du", "Risley", "Moon" ; INSERT INTO Persons PersonID, LastName, FirstName VALUES  20,  "Fengyu",  "Li"  ; INSERT INTO Persons PersonID, LastName, FirstName VALUES  23,  "Emerald",  "Liu"  ; INSERT INTO Persons PersonID, LastName, FirstName VALUES  93,  "Yolanda",  "Wang" ; SELECT * FROM Persons ;



## UPDATE

UPDATE Persons SET PersonID = 999, LastName = "Unknown" WHERE PersonID = 23 AND LastName = "Emerald" ; SELECT * FROM Persons ;

## SELECT

SELECT PersonID, FirstName, LastName FROM Persons ; 

SELECT PersonID, FirstName, LastName FROM Persons WHERE PersonID = 20 OR LastName = "Chuhan" ;

## SAVE