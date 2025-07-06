------------------------ Exam 01 - Part 02 ------------------------
---------------------------------------------------------

-- 1. write a query that displays Full name of a employee who has more than 3 letters in his/her First Name.
-- (1 point)

select CONCAT_WS(' ',e.Fname,e.Lname)[full name]
from Employee e
where LEN(e.Fname)>3
---------------------------------------------------------------------------------------------------

-- 2. Write a query to display the total number of Programming books available in the library with alias name ‘’
-- (1 point)

select COUNT(*)[NO_OF_PROGRAMMING_BOOKS]
from Book b , Category cat
where b.Cat_id=cat.Id and cat.Cat_name='programming'



---------------------------------------------------------------------------------------------------
-- 3. Write a query to display the number of books published 
--by () with the alias name ''.
-- (1 point)

select COUNT(*)[NO_OF_BOOKS]
from Book b , Publisher p
where b.Publisher_id=p.Id and p.Name='HarperCollins'




---------------------------------------------------------------------------------------------------
-- 4. Write a query to display the User SSN and name, date of borrowing 
--    and due date of the User whose due date is before July 2022.
-- (1 point)

select u.SSN,u.User_Name,b.Borrow_date,b.Due_date
from Users u ,Borrowing b
where u.SSN=b.User_ssn and b.Due_date<'7/01/2022'


---------------------------------------------------------------------------------------------------
-- 5. Write a query to display book title, author name and display in the following format.
--    ' [Book Title] is written by [Author Name]
-- (2 point)

select CONCAT_WS('   ',b.Title,'is written by',a.Name)
from Book b ,Author a,Book_Author ba
where ba.Book_id=b.Id and ba.Author_id=a.Id



---------------------------------------------------------------------------------------------------
-- 6. Write a query to display the name of users who have letter 'A' in their names.
-- (1 point)

select u.User_Name
from Users u
where u.User_Name like '%a%'

---------------------------------------------------------------------------------------------------
-- 7. Write a query that dispaly user SSN who makes the most borrowing 
-- (2 point)

select top(1) *
from (select b.User_ssn,count(b.User_ssn)[times]
from Borrowing b
group by b.User_ssn) as table01
order by table01.times desc



-----------------------------------------------------------------------------------------------------------
-- 8. Write a query that displays the total amount of money that each user paid for borrowing books.
-- (2 point)

Select U.User_Name ,U.SSN , SUM(B.Amount)
From Users U ,Borrowing B
Where U.SSN = B.User_ssn
Group By U.User_Name , U.SSN

-----------------------------------------------------------------------------------------------------------
-- 9. write a query that displays the category which has the book that has the minimum amount of money for borrowing.
-- (2 point)

select top(1) b.Id[bokID],b.Title,c.Id,c.Cat_name,br.Book_id,br.Amount
from Category c, Borrowing br, Book b
where br.Book_id=b.Id and c.Id =b.Cat_id 
order by br.Amount


-----------------------------------------------------------------------------------------------------------
-- 10. write a query that displays the email of an employee if it's not found, display address if it's not found, display date of birthday.
-- (1 point)

Select coalesce(Email , Address , Convert(Varchar(10) , DOB)) 
From Employee



-----------------------------------------------------------------------------------------------------------
-- 11. Write a query to list the category and number of books in each category with alias name 'Count Of Books'.
-- (1 point)

select c.Id,c.Cat_name , count(b.Id)[count book]
from Category c,book b
where b.Cat_id=c.Id 
group by c.Cat_name,c.Id


-----------------------------------------------------------------------------------------------------------
-- 12.  Write a query that display books id which is not found in floor num = 1 and shelf-code = A1
-- (2 point)


Select B.Id
From Book B
Where B.Id not in
(Select B.Id
From Book B , Shelf S
Where S.Code = B.Shelf_code
and S.Floor_num = 1 and S.Code = 'A1')




-----------------------------------------------------------------------------------------------------------
-- 13. Write a query that displays the floor number , Number of Blocks and number of employees working on that floor.
-- (2 point)

Select F.Number , F.Num_blocks , COUNT(E.Id) [Num Of Employees ]
From Floor F , Employee E
Where F.Number = E.Floor_no
Group By F.Number , F.Num_blocks


-----------------------------------------------------------------------------------------------------------
-- 14. Display Book Tittle and User Name to designate Borrowing 
--     that occurred within the period ‘3/1/2022’ and ‘10/1/2022’
-- (2 point)

Select B.Title , U.User_Name 
From Book B , Users U , Borrowing BR
Where  B.Id = BR.Book_id and U.SSN = BR.User_ssn 
and BR.Borrow_date Between '3/1/2022' and '10/1/2022'


-----------------------------------------------------------------------------------------------------------
-- 15. Display Employee Full Name and Name Of his/her Supervisor as Supervisor Name 
-- (2 point)

Select CONCAT(Emp.Fname , ' ' , Emp.Lname) [Employee Name] , Super.Fname
From Employee Emp , Employee Super
Where Super.Id = Emp.Super_id



-----------------------------------------------------------------------------------------------------------
-- 16. Select Employee name and his/her salary but if there is no salary display Employee bonus. 
-- (2 point)

Select CONCAT(Fname , ' ' , Lname) [Employee Name] , ISNULL(Salary , Bouns) as money
From Employee


-----------------------------------------------------------------------------------------------------------
-- 17. Display max and min salary for Employees 
-- (2 point)

Select MAX(Salary) [Max Salary] , MIN(Salary) [Min Salary]
From Employee


-----------------------------------------------------------------------------------------------------------
-- 18. Write a function that take Number and display if it is even or odd
-- (2 point)
GO
Create Function GetEvenOrOddNum (@Num int)
Returns Varchar(Max)
Begin
	Declare @Message Varchar(Max)
	if @Num % 2 = 0
		Select @Message =  'Even Number'
	Else
		Select @Message = 'Odd Number'

		Return @Message
End
Go

Select dbo.GetEvenOrOddNum(8)
-----------------------------------------------------------------------------------------------------------
-- 19. write a function that take category name and display Tittle of books in that category
-- (2 point)
go
create or alter function getBokTitleByCateg (@category varchar(50))
returns table
as
return(
	select b.Title,c.Cat_name from book b,Category c where b.Cat_id=c.Id and c.Cat_name=@category
)
go
select * from getBokTitleByCateg('programming')



---------------------------------------------------------------------------------------------------------------
-- 20. write a function that take phone of user and display Book Tittle , user-name, 
--     amount of money and due-date
-- (2 point)
go
create or alter function getUserNameMoneyBookByUserPhone(@phone varchar(12))
returns table 
as
return(
	select b.Title,u.User_Name,br.Amount,br.Due_date
	from Users u ,book b,Borrowing br,User_phones ph
	where u.SSN=br.User_ssn and br.Book_id=b.Id and ph.User_ssn=u.SSN and ph.Phone_num=@phone
)
go
select * from getUserNameMoneyBookByUserPhone('0123654122')

---------------------------------------------------------------------------------------------------
--  21. Write a function that take user name and check if it's duplicated 
--      return Message in the following format ([User Name] is Repeated [Count] times) 
--      if it's not duplicated display msg with this format [user name] is not duplicated,
--      if it's not Found Return [User Name] is Not Found
-- (2 point)

go
create or alter function checkUserNameDuplicate(@name varchar(50))
returns varchar(max)
begin
	declare @counter int
	declare @msg varchar(max)
	select @counter=(u.User_Name) from Users u where u.User_Name=@name
	if @counter>1
		select @msg=CONCAT_WS(' ',@name,'is repeated',@counter,'times')
	else if @counter = 1
		select @msg=CONCAT_WS(' ',@name,'is is not duplicated')
	else
		select @msg=CONCAT_WS(' ',@name,'is Not Found')
	return @msg
end
go
select dbo.checkUserNameDuplicate('ahmed')


---------------------------------------------------------------------------------------------
-- 22. Create a scalar function that takes date and Format to return Date With That Format.
-- (2 point)
go
create or alter function getDateByFormat (@InputDate datetime,@Format varchar(50))
returns varchar(100)
as
begin
    return FORMAT(@InputDate, @Format);
end
go
select dbo.getDateByFormat(GETDATE(),'yyyy-mm-dd')




---------------------------------------------------------------------------------------------
-- 23. Create a stored procedure to show the number of books per Category
-- (2 point)
go
create or alter proc sp_getBooksNumPerCategory
as
select c.Cat_name,COUNT(b.Id) from Book b , Category c where c.Id=b.Cat_id group by c.Cat_name
go
sp_getBooksNumPerCategory


---------------------------------------------------------------------------------------------
-- 24. Create a stored procedure that will be used in case there is an old manager 
--     who has left the floor and a new one becomes his replacement. 
--     The procedure should take 3 parameters (old Emp.id, new Emp.id and the floor number)
--     and it will be used to update floor table
-- (3 point)
go
create or alter proc sp_updateMngrsFloor(@oldEmpID int , @newEmpID int ,@floor int)
as
update Floor set MG_ID =@newEmpID where MG_ID=@oldEmpID and floor.Number=@floor
go
exec sp_updateMngrsFloor 2,5,1

---------------------------------------------------------------------------------------------
-- 25. Create a view AlexAndCairoEmp that displays employees data for employees who live in Alex or Cairo. 
-- (2 point)

Go
Create View AlexAndCairoEmp 
As
	Select *
	From Employee
	Where Address in ('Alex' , 'Cairo')

Go

Select * From AlexAndCairoEmp

---------------------------------------------------------------------------------------------
-- 26. create a view "V2" That displays number of books per shelf
-- (2 point)
Go
Create View V2
As
	Select B.Shelf_code  , COUNT(B.Id) [count]
	From Book B 
	Group By B.Shelf_code
Go

Select * From V2


---------------------------------------------------------------------------------------------
-- 27. create a view "V3" That display  the shelf code that have maximum number of 
--     books using the previous view "V2"
-- (2 point)
Go
Create View V3
As
	Select  v2.[Shelf_code]
	From V2
	Where v2.[count] = (Select MAX(v2.[count]) From V2)
Go

select * From V3
---------------------------------------------------------------------------------------------
-- 28. Create table named ‘ReturnedBooks’. Its Columns are 
--     (UserSSN,bookid ,DueDate ,ReturnDate, fees) then 
--     create A trigger that instead of inserting the data of 
--     returned book checks if the return date is the due date 
--     or not if not so the user must pay a fee and it will be 
--     20% of the amount that was paid before.
-- (3 point)
create table returnedBooks(userSSn int ,bookid int,dueDate date,returnDate date,fees money) 
go
create or alter trigger tr_CheckReturnDateCalcFees
on dbo.returnedBooks
instead of insert
as
	declare @userSSn int ,@bookid int,@dueDate date,@returnDate date,@fees int

	select @userSSn=i.userSSn,@bookid=i.bookid,@dueDate=i.dueDate,@returnDate=i.returnDate
	from inserted i
	select @fees=b.Amount*0.2 from Borrowing b where b.User_ssn=@userSSn and @bookid=b.Book_id 

	if @DueDate < @ReturnDate
		insert into ReturnedBooks
		Values(@UserSSN , @Bookid ,@DueDate , @ReturnDate , @Fees )
	Else
		insert into ReturnedBooks
		Values(@UserSSN , @Bookid ,@DueDate , @ReturnDate , 0 )
go

insert into ReturnedBooks
Values (1 , 3 , '2024-11-25' , GETDATE() , Null)

insert into ReturnedBooks
Values (2 , 3 , GETDATE() , GETDATE() , Null)

select * from returnedBooks


---------------------------------------------------------------------------------------------
-- 29. In the Floor table insert new Floor With Number of blocks 2 , 
--     employee with SSN = 20 as a manager for this Floor,
--     The start date for this manager is Now.

--    Do what is required if you know that : Mr.Omar Amr(SSN=5)  
--    moved to be the manager of the new Floor (id = 7), 
--    and they give Mr. Ali Mohamed(his SSN =12) His position 
-- (3 point)

Insert into Floor
Values (7 , 2 , 20 , GETDATE())

Update Floor
Set MG_ID = 12 
Where MG_ID = 5 

Update Floor
Set MG_ID = 5
Where Number = 7





---------------------------------------------------------------------------------------------
--30. Create view name (v_2006_check) that will display Manager id, 
--    the Floor Number where he/she works , Number of Blocks and the Hiring Date
--    which must be from the first of March and the end of may 2022.
--    this view will be used to insert data so make sure that the coming new 
--    data must match the condition then try to insert 2 new Floors and Mention What will happen 
-- (3 point)
go
create or alter view v_2006_check
with encryption 
as
select f.MG_ID,f.Number ,f.Num_blocks,f.Hiring_Date
from floor f
where f.Hiring_Date between '3-1-2022' and '5-31-2022'
With Check Option
go


Select * From  v_2006_check

insert into v_2006_check (MG_ID , Number , Num_blocks ,Hiring_Date)
Values (2 , 8 , 2 , '7-8-2023') --invalid

insert into v_2006_check (MG_ID , Number , Num_blocks ,Hiring_Date)
Values (2 , 8 , 2 , '4-8-2022')--Done




-------------------------------------------------------------------------------------------------
-- 31- Create a trigger to prevent anyone from Modifing or Delete or Insert in the Employee
--    table ( Display a message for user to tell him that he can’t take any action with this Table)
-- (3 point)
Go
Create or alter trigger PreventDMLEmployee
on Employee
Instead Of Insert , Update , Delete
As
	raiserror('u can’t take any action with this Table', 16, 1)
Go
set nocount on
Update Employee
Set Fname = 'ali'
Where Id = 1

-------------------------------------------------------------------------------------------------------------
--32- Testing Referential Integrity , Mention What Will Happen When
-- (5 point)
-- 1. Add a new User Phone Number with User_SSN = 50 in User_Phones Table

Insert into User_phones
Values (50 , 01013780915)
-- The INSERT statement conflicted with the FOREIGN KEY constraint "FK_User_phones_User". The conflict occurred in database "Library", table "dbo.Users", column 'SSN'.

-- 2. Modify the employee id 20 in the employee table to 21
DROP TRIGGER IF EXISTS dbo.PreventDMLEmployee


Update Employee
Set ID = 21
Where Id  = 20
--Cannot update identity column 'Id'.

-- 3. Delete the employee with id 1

Delete From Employee 
Where id = 1
--The DELETE statement conflicted with the REFERENCE constraint "FK_Borrowing_Employee". The conflict occurred in database "Library", table "dbo.Borrowing", column 'Emp_id'.
--u need cascade on delete or setnull

-- 4. Delete the employee with id 12
Delete From Employee 
Where id = 12
--The DELETE statement conflicted with the REFERENCE constraint "FK_Borrowing_Employee". The conflict occurred in database "Library", table "dbo.Borrowing", column 'Emp_id'.


-- 5. Create an index on column (Salary) that allows you to cluster 
--    the data in table Employee
Create Clustered index IXSalary
On Employee (Salary)
--Cannot create more than one clustered index on table 'Employee'. Drop the existing clustered index 'PK_Employee' before creating another.
--table has primary key can't make more than on clustered index
--------------------------------------------------------------------------------------------------------
-- 33- Try to Create Login With Your Name And give yourself access Only to Employee and Floor tables then 
--  allow this login to select and insert data into tables and deny Delete and update (Don't Forget To take screenshot to every step)
-- (5 point)
create schema per

alter schema per
transfer dbo.employee

alter schema per
transfer dbo.floor

create login ahmedBehairylogin with password = '123456'


create user ahmedBehairyuser for login ahmedBehairylogin

grant select, insert on per.employee to ahmedBehairyuser
grant select, insert on per.floor to ahmedBehairyuser

deny delete, update on per.employee to ahmedBehairyuser
deny delete, update on per.floor to ahmedBehairyuser

select * from per.Employee
select * from Floor


update  per.Employee set employee.Address='test3' where Employee.Id=1
update  Floor set floor.Number=5555 where Floor.Number=1



