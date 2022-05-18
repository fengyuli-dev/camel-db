## CREATE table

CREATE Persons PersonID INTEGER, LastName VARCHAR, FirstName VARCHAR, Address VARCHAR, City VARCHAR ; 

## INSERT (two times)

INSERT INTO Persons PersonID, LastName, FirstName, Address, City VALUES  9, "Du", "Chuhan", "Risley", "Moon" ; INSERT INTO Persons PersonID, LastName, FirstName VALUES  20, "Li", "Fengyu"  ; INSERT INTO Persons PersonID, LastName, FirstName VALUES  23, "Liu",  "Emerald" ; INSERT INTO Persons PersonID, LastName, FirstName VALUES  93,  "Wang", "Yolanda" ; 

SELECT * FROM Persons ; 

## Delete 

DELETE FROM Persons WHERE PersonID = 23 ;

DELETE FROM Persons WHERE FirstName = "Chuhan" OR LastName = "Li" ;

DELETE FROM Persons WHERE FirstName = "Zhajjjng" ; //fail

## DROP

DROP Persons ;

## Helper Command

CREATE Persons PersonID INTEGER, LastName VARCHAR, FirstName VARCHAR, Address VARCHAR, City VARCHAR ; INSERT INTO Persons PersonID, LastName, FirstName, Address, City VALUES  9, "Du", "Chuhan", "Risley", "Moon" ; INSERT INTO Persons PersonID, LastName, FirstName VALUES  20, "Li", "Fengyu"  ; INSERT INTO Persons PersonID, LastName, FirstName VALUES  23, "Liu",  "Emerald"  ; INSERT INTO Persons PersonID, LastName, FirstName VALUES  93,  "Wang", "Yolanda" ; SELECT * FROM Persons ;



## UPDATE

UPDATE Persons SET PersonID = 999, LastName = Unknown WHERE PersonID = 23 AND LastName = "Liu" ; SELECT * FROM Persons ;

## SELECT

SELECT PersonID, FirstName, LastName FROM Persons ; 

SELECT PersonID, FirstName, LastName FROM Persons WHERE PersonID = 20 OR FirstName = "Chuhan" ;

## SAVE

SAVE Persons ;

## QUIT

## READ

READ Persons ;

INSERT INTO Persons PersonID, LastName, FirstName, Address, City VALUES  100, New, Person, Happy, Hercules ;
UPDATE Persons SET PersonID = 999, LastName = Unknown WHERE PersonID = 23 AND LastName = Emerald ;