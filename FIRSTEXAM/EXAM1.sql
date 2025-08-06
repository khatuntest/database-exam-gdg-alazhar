USE  Library

/*
1. Write a query that displays Full name of an employee who has more than
3 letters in his/her First Name.{2 Point}*/
SELECT CONCAT(e.Fname ,' ', e.Lname) AS 'FULL NAME'
FROM Employee e
WHERE LEN(Fname) > 3
/*
2. Write a query to display the total number of Programming books
available in the library with alias name ‘NO OF PROGRAMMING
BOOKS’ {2 Point}*/
SELECT * FROM Category
SELECT * FROM Book
SELECT COUNT(*) AS 'NO OF PROGRAMMING'
FROM Category C INNER JOIN BOOK B
ON B.Cat_id = C.Id 
WHERE C.Cat_name = 'programming' 

/*
3. Write a query to display the number of books published by
(HarperCollins) with the alias name 'NO_OF_BOOKS'. {2 Point}*/
SELECT * FROM Publisher
SELECT * FROM BOOK
SELECT COUNT(*) AS 'NO OF BOOKS'
FROM Publisher P INNER JOIN BOOK B
ON P.Id = B.Publisher_id 
WHERE P.Name = 'HarperCollins'

/*
4. Write a query to display the User SSN and name, date of borrowing and
due date of the User whose due date is before July 2022. {2 Point}*/
SELECT * FROM Borrowing
SELECT * FROM Users
SELECT DISTINCT  U.SSN , U.User_Name , B.Borrow_date , B.Due_date
FROM Users U INNER JOIN Borrowing B
ON B.User_ssn = U.SSN 
WHERE B.Due_date < '2022-07-1'
/*
5. Write a query to display book title, author name and display in the
following format,
' [Book Title] is written by [Author Name]. {3 Points}*/
SELECT * FROM BOOK
SELECT * FROM Author
SELECT * FROM Book_Author
SELECT CONCAT (B.Title,' is written by ', A.Name) AS 'Description'
FROM BOOK B INNER JOIN Book_Author BA 
ON B.Id = BA.Book_id  
INNER JOIN Author A 
ON A.Id = BA.Author_id
/*
6. Write a query to display the name of users who have letter 'A' in their
names. {2 Point}*/
SELECT U.User_Name
FROM Users U
WHERE User_Name LIKE '%A%'
/*
7. Write a query that display user SSN who makes the most borrowing{2
Points}*/
SELECT TOP 1 B.User_ssn
FROM Borrowing B
GROUP BY B.User_ssn
ORDER BY COUNT(*) DESC
/*
8. Write a query that displays the total amount of money that each user paid
for borrowing books. {2 Points}*/
SELECT B.User_ssn,SUM (B.Amount) AS 'Total Amount'
FROM Borrowing B
GROUP BY B.User_ssn
/*
9. write a query that displays the category which has the book that has the
minimum amount of money for borrowing. {2 Points}*/
SELECT TOP 1 C.Cat_name , MIN(BW.Amount) AS 'Min AmounT'
FROM Borrowing BW INNER JOIN Book B
ON BW.Book_id = B.Id INNER JOIN Category C 
ON B.Cat_id = C.Id
GROUP BY C.Cat_name
ORDER BY MIN(BW.Amount) 
/*
10.write a query that displays the email of an employee if it's not found, 
display address if it's not found, display date of birthday. {2 Point}*/
SELECT COALESCE (
         CONVERT(VARCHAR(100) , E.Email),
		 CONVERT(VARCHAR(100) , E.Address), 
		 CONVERT(VARCHAR(100) , E.DOB)
		 )AS 'Contact Information'
FROM Employee E
/*
11. Write a query to list the category and number of books in each category
with the alias name 'Count Of Books'. {2 Point}*/
SELECT C.Cat_name , COUNT(B.Cat_id) AS 'Count Of Books'
FROM Category C INNER JOIN Book B
ON C.Id = B.Cat_id
GROUP BY C.Cat_name
/*
12. Write a query that display books id which is not found in floor num = 1
and shelf-code = A1.{2 Points}*/
SELECT * FROM Floor
SELECT * FROM Book
SELECT B.Id
FROM Floor F
INNER JOIN Shelf S ON S.Floor_num = F.Number 
INNER JOIN BOOK B ON B.Shelf_code = S.Code
WHERE NOT (F.Number = 1 AND S.Code = 'A1')
/*
13.Write a query that displays the floor number , Number of Blocks and
number of employees working on that floor.{2 Points}*/
SELECT * FROM Employee
SELECT F.Number , F.Num_blocks , COUNT(E.Floor_no) AS 'Count Employees'
FROM Floor F INNER JOIN Employee E
ON F.Number = E.Floor_no
GROUP BY F.Number , F.Num_blocks
/*
14.Display Book Title and User Name to designate Borrowing that occurred
within the period ‘3/1/2022’ and ‘10/1/2022’.{2 Points}*/
SELECT B.Title , U.User_Name
FROM Borrowing BW JOIN Book B
ON B.Id = BW.Book_id JOIN Users U
ON U.SSN = BW.User_ssn
WHERE BW.Borrow_date BETWEEN '2022-03-01' AND '2022-10-01'

/*
15.Display Employee Full Name and Name Of his/her Supervisor as
Supervisor Name.{2 Points}*/
SELECT * FROM Employee
SELECT CONCAT(E.Fname,'  ' , E.Lname) AS 'Full Name' , CONCAT(SP.Fname,'  ',SP.Lname)AS 'Supervisor Name'
FROM Employee E INNER JOIN Employee SP
ON E.Super_id = SP.Id
/*
16.Select Employee name and his/her salary but if there is no salary display
Employee bonus. {2 Points}*/
SELECT * FROM Employee
SELECT CONCAT(E.Fname,'  ' , E.Lname) AS 'Full Name' , COALESCE(E.Salary,E.Bouns) AS 'Salary OR Bouns'
FROM Employee E
/*
17.Display max and min salary for Employees {2 Points}*/
SELECT MAX(E.Salary) AS 'Max Salary' , MIN(E.Salary)AS 'Min Salary'
FROM Employee E
/*
18.Write a function that take Number and display if it is even or odd {2 Points}*/
CREATE OR ALTER FUNCTION EvenOROdd(@NUM INT)
RETURNS VARCHAR(10)
BEGIN
   DECLARE @CHECK VARCHAR(10)
   IF @NUM % 2 = 0
      SET @CHECK = 'even'
   ELSE
       SET @CHECK = 'odd'
   RETURN @CHECK
END

SELECT dbo.EvenOROdd(7) AS 'RESULT'
/*
19.write a function that take category name and display Title of books in that
category {2 Points}*/
CREATE OR ALTER FUNCTION CATEGTOTITLE(@CAT_NAME VARCHAR(50))
RETURNS VARCHAR(50)
BEGIN
    DECLARE @TitleOFBooK VARCHAR(50)
	SELECT @TitleOFBooK = B.Title
	FROM Category C JOIN BOOK B 
	ON B.Cat_id = C.Id
	WHERE C.Cat_name = @CAT_NAME
	RETURN @TitleOFBook
END
SELECT * FROM Category
SELECT dbo.CATEGTOTITLE('programming') AS 'TITLE OF BOOK'
/*
20. write a function that takes the phone of the user and displays Book Title,
user-name, amount of money and due-date. {2 Points}*/
SELECT * FROM Borrowing
CREATE OR ALTER FUNCTION PhoneToUser(@Phone VARCHAR(11))
RETURNS TABLE 
AS RETURN (
         SELECT B.Title,U.User_Name,BW.Amount,BW.Due_date
		 FROM Book B JOIN Borrowing BW 
		 ON B.Id = BW.Book_id JOIN Users U ON BW.User_ssn = U.SSN
		 JOIN User_phones UP ON UP.User_ssn = U.SSN
		 WHERE UP.Phone_num = @Phone
)
SELECT * FROM User_phones
SELECT * FROM dbo.PhoneToUser('0123654122')

/*
21.Write a function that take user name and check if it's duplicated
return Message in the following format ([User Name] is Repeated [Count]
times) if it's not duplicated display msg with this format [user name] is
not duplicated,if it's not Found Return [User Name] is Not Found {2 Points}*/
CREATE OR ALTER FUNCTION CheckUserFrequency(@UserName VARCHAR(50))
RETURNS VARCHAR(200)
BEGIN
     DECLARE @FRQ INT , @ANS VARCHAR(200)
	 SELECT @FRQ = COUNT(U.User_Name)
	 FROM Users U
	 WHERE U.User_Name = @UserName

	 IF @FRQ = 0
	     SET @ANS = CONCAT(@UserName ,' is Not Found')
	 ELSE IF @FRQ > 1
	    SET @ANS = CONCAT (@UserNamE,' is Repeated ',@FRQ, ' times') 
     ELSE
	    SET @ANS = CONCAT(@UserName ,' is not duplicated') 
  RETURN @ANS    
END 

SELECT * FROM Users
SELECT dbo.CheckUserFrequency('Amr Ahmed') AS 'FREQUENCY OF USER'
/*
22.Create a scalar function that takes date and Format to return Date With
That Format. {2 Points}*/
CREATE OR ALTER FUNCTION FormatDATE(@DATE DATE , @CODE INT)
RETURNS VARCHAR(50)
BEGIN
     DECLARE @DATEFORMATE VARCHAR(50)
	 SET @DATEFORMATE = CONVERT(VARCHAR , @DATE , @CODE)
	 RETURN @DATEFORMATE 
END

SELECT dbo.FormatDATE('2025-04-14', 103) AS 'Formatted  Date'

--23.Create a stored procedure to show the number of books per Category.{2 Points}
CREATE OR ALTER PROC GET#OFBOOKSPERCATEGORY 
AS
BEGIN
     SELECT C.Cat_name , COUNT(B.Cat_id) AS 'COUNT OF BOOKS'
	 FROM Book B JOIN Category C
	 ON B.Cat_id = C.Id
	 GROUP BY C.Cat_name
END
EXEC GET#OFBOOKSPERCATEGORY
/*
24.Create a stored procedure that will be used in case there is an old manager
who has left the floor and a new one becomes his replacement. The
procedure should take 3 parameters (old Emp.id, new Emp.id and the
floor number) and it will be used to update the floor table. {3 Points}*/
SELECT * FROM Floor
CREATE OR ALTER PROCEDURE UpdateFloorTable 
         @OldEmpID INT , @NewEmpID INT , @FLOOR# INT 
AS
BEGIN
     UPDATE Floor 
	 SET MG_ID = @NewEmpID
	 WHERE MG_ID = @OldEmpID AND Number = @FLOOR#
END 
/*
25.Create a view AlexAndCairoEmp that displays Employee data for users
who live in Alex or Cairo. {2 Points}*/
SELECT * FROM Employee
CREATE OR ALTER VIEW AlexAndCairoEmp
AS
SELECT *
FROM Users U JOIN Employee E
ON U.Emp_id = E.Id
WHERE E.Address IN ('Cairo' , 'Alex')

SELECT * FROM AlexAndCairoEmp
--26.create a view "V2" That displays number of books per shelf {2 Points}
CREATE OR ALTER VIEW V2 
AS
SELECT S.Code ,COUNT (B.Shelf_code) AS 'NUMBER OF BOOKS PER SHELF'
FROM Book B JOIN Shelf S
ON B.Shelf_code = S.Code
GROUP BY S.Code

SELECT * FROM V2
/*
27.create a view "V3" That display the shelf code that have maximum
number of books using the previous view "V2" {2 Points}*/
CREATE OR ALTER VIEW V3 
AS
SELECT TOP 1 V.Code
	FROM V2 V
	ORDER BY V.[NUMBER OF BOOKS PER SHELF] DESC

SELECT * FROM V3

/*
28.Create a table named ‘ReturnedBooks’With the Following Structure :
[User SSN, Book Id, Due Date, Return Date,fees]
then create A trigger that instead of inserting the data of returned book
checks if the return date is the due date or not if not so the user must pay
a fee and it will be 20% of the amount that was paid before. {3 Points}*/
CREATE   TABLE ReturnedBooks(
    User_SSN INT ,
	BookID INT ,
	DueDate DATE ,
	ReturnDATE DATE ,
	Fees DECIMAL(6,2)
)

CREATE OR ALTER TRIGGER TRG
ON ReturnedBooks
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO ReturnedBooks (User_SSN, BookID, DueDate, ReturnDATE, Fees)
    SELECT 
        I.User_SSN,
        I.BookID,
        I.DueDate,
        I.ReturnDATE,
        CASE
            WHEN I.ReturnDATE > I.DueDate THEN B.Amount * 0.2
            ELSE 0
        END AS Fees
    FROM INSERTED I
    JOIN Borrowing B ON B.Book_id = I.BookID
END

INSERT INTO ReturnedBooks (User_SSN, BookID, DueDate, ReturnDATE, Fees)
VALUES (111, 1, '2025-04-10', '2025-04-10', 0)

/*
29.I) In the Floor table insert new Floor With Number of blocks 2 , employee
      with SSN = 20 as a manager for this Floor,The start date for this manager
      is Now. 
   II) Do what is required if you know that : Mr.Omar Amr(SSN=5)
       moved to be the manager of the new Floor (id = 6), and they give Mr. Ali
       Mohamed(his SSN =12) His position . {3 Points}*/
SELECT * FROM Floor

INSERT INTO Floor (Number, Num_blocks, MG_ID, Hiring_Date)
VALUES (7, 2, 20, GETDATE())

DECLARE @ID INT

SELECT @ID = F.Number
FROM Floor F
WHERE F.MG_ID = 5

UPDATE Floor
SET MG_ID = 5
WHERE Number = 6

UPDATE Floor
SET MG_ID = 12
WHERE Number = @ID

/*
30. 1- Create view name (v_2006_check) that will display Manager id, Floor
       Number where he/she works , Number of Blocks and the Hiring Date
       which must be from the first of March and the May of December
       2022.
	2- this view will be used to insert data so make sure that the coming
       new data must match the condition then try to insert this 2 rows and
       Mention What will happen {3 Point}
Employee_Id , Floor Number, Number of Blocks ,  Hiring Date
    2            6              2                7-8-2023
    4            7              1                4-8-2022*/
CREATE OR ALTER VIEW v_2006_check 
AS
SELECT F.MG_ID , F.Number , F.Num_blocks , F.Hiring_Date
FROM FLOOR F
WHERE F.Hiring_Date BETWEEN '2022-03-01' AND '2022-12-30'
WITH CHECK OPTION

SELECT * FROM Floor

INSERT INTO v_2006_check (MG_ID, Number, Num_blocks, Hiring_Date)
VALUES (5, 11, 2, '2023-08-07')  -- GIVE ME ERROR , BECAUSE CHECK OPTION 

INSERT INTO v_2006_check (MG_ID, Number, Num_blocks, Hiring_Date)
VALUES (4, 8, 1, '2022-08-04') -- THIS IS CORRECT

/*
31.Create a trigger to prevent anyone from Modifying or Delete or Insert in
the Employee table ( Display a message for user to tell him that he can’t
take any action with this Table) {3 Point}*/
CREATE OR ALTER TRIGGER TRG2 
ON EMPLOYEE
INSTEAD OF INSERT , UPDATE , DELETE 
AS 
BEGIN 
     PRINT 'You CANNOT INSERT, UPDATE, or DELETE any records from the EMPLOYEE table.'
END 

UPDATE EMPLOYEE 
SET Fname = 'NewName'
WHERE ID = 1

SELECT * FROM Employee
/*
32.Testing Referential Integrity , Mention What Will Happen When:

A. Add a new User Phone Number with User_SSN = 50 in
User_Phones Table {2 Point}*/
-- SSN = 50 IS NOT EXIST SO WILL MAKE ERROR 
-- If SSN 50 exists in User, this will succeed

--B. Modify the employee id 20 in the employee table to 21 {1 Point}
-- IF CONNECTED WITH ANOTHER TABLE WILL FAILED ELSE WILL WORK

--C. Delete the employee with id 1 {2 Point}
--If someone has Super_id = 1, or if Floor.MG_ID = 1, you'll get error ELSE WILL WORK.

--D. Delete the employee with id 12 {2 Point}
--SAME IDEA WITH PREVIOUS QUESTION , IF RELATED WILL FAILED ELSE WILL WORK

/*
E. Create an index on column (Salary) that allows you to cluster the
data in table Employee. {2 Point}*/
-- GIVE ME ERROR BECAUSE Employee.ID the primary key,
--it has a clustered index by default.

/*
33.
   1- Try to Create Login With Your Name And give yourself access Only to
      Employee and Floor tables 
   2- then allow this login to select and insert data into tables 
   3- and deny Delete and update (Don't Forget To take screenshot to every step) {5 Points}
*/
CREATE LOGIN MENNA WITH PASSWORD ='KHATUN'
CREATE USER MENNA FOR LOGIN MENNA

-- ALLOW MENNA TO SELECT AND INSERT
GRANT  SELECT , INSERT ON dbo.EMPLOYEE TO MENNA
GRANT  SELECT , INSERT ON dbo.FLOOR TO MENNA

-- ALLOW MENNA TO DENY UPDATE AND DELETE 
GRANT UPDATE , DELETE ON dbo.EMPLOYEE TO MENNA
GRANT UPDATE , DELETE ON dbo.FLOOR TO MENNA

------------------TEST-----------
SELECT * FROM dbo.Employee
SELECT * FROM dbo.Floor

INSERT INTO dbo.Employee (Fname, Lname, Phone, Email) 
VALUES ('Test', 'User', '1234567890', 'testuser@email.com')

INSERT INTO dbo.Floor (Number, Num_blocks, MG_ID, Hiring_Date)
VALUES (8, 3, 20, '2025-04-14')

UPDATE dbo.Employee SET Phone = '9876543210' WHERE Id = 10
UPDATE dbo.Floor SET Num_blocks = 5 WHERE Number = 8

DELETE FROM dbo.Employee WHERE Id = 10
DELETE FROM dbo.Floor WHERE Number = 8
