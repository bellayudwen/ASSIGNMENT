--1.	Lock tables Region, Territories, EmployeeTerritories and Employees. 
--Insert following information into the database. In case of an error, no changes should be made to DB.
--a.	A new region called “Middle Earth”;
insert into region (regionid, regiondescription) values (5,'Middle Earth')
--b.	A new territory called “Gondor”, belongs to region “Middle Earth”;
insert into territories values (00001,'Gondor', 5)
--c.	A new employee “Aragorn King” who's territory is “Gondor”.
insert into Employees(LastName,FirstName,Region) values ('King','Aragorn',5)
insert into EmployeeTerritories(EmployeeID,TerritoryID) values (10,00001)
--2.	Change territory “Gondor” to “Arnor”.
update Territories set TerritoryDescription = 'Arnor' where TerritoryDescription = 'Gondor'
--3.	Delete Region “Middle Earth”. (tip: remove referenced data first) (Caution: do not forget WHERE 
--or you will delete everything.) In case of an error, no changes should be made to DB. Unlock the tables mentioned in question 1.
delete from EmployeeTerritories where TerritoryID in (select TerritoryID from Territories where RegionID = 5)
delete from Territories where RegionID = 5
delete from Region where RegionDescription='Middle Earth'
--4.	Create a view named “view_product_order_[your_last_name]”, list all products and total ordered quantity for that product.
create view view_product_order_yu as
select p.productid, p.productname, sum(od.quantity) as 'total quantity' from products p
inner join [Order Details] od on p.productid = od.productid
group by p.productid, p.productname
--5.	Create a stored procedure “sp_product_order_quantity_[your_last_name]” that accept product id as an input and total 
--quantities of order as output parameter.
create proc sp_product_order_quantity_xu
@product_id int
@total_quantity float out
as
select p.productid, @total_quantity = count(od.orderid) from Products p
join [Order Details] od
on p.ProductID=od.ProductID
where p.productid = @productid
--group by p.ProductID
go
--6.	Create a stored procedure “sp_product_order_city_[your_last_name]” that accept product name as an input 
--and top 5 cities that ordered most that product combined with the total quantity of that product ordered from 
--that city as output.
create proc sp_product_order_city_yu
(@product_name varchar(50),
@order_city varchar(50) output)
as
begin
select @product_name=ss.productname from (select top 5 d.ProductID,
d.ProductName
from (select p.ProductID,p.ProductName,sum(od.quantity) t from Products p
inner join [Order Details] od
on p.ProductID = od.ProductID
group by p.ProductID, p.ProductName) as [d] Order by d.t desc) ss
left join(
select * from (select dd.productid, dd.city, rank() over(partition by
productid order by q desc) [rk] from
(select p.ProductID, c.city, sum(od.quantity) q from Customers c
join orders o on c.CustomerID= o.CustomerID
left join [Order Details] od on o.OrderID=od.OrderID
left join Products p on od.ProductID=p.ProductID
group by p.ProductID, c.City ) dd ) cc where cc.rk=1) x
on ss.productid= x.productid
where x.city =@order_city
end

--8. Create a trigger that when there are more than 100 employees in territory “Stevens
--Point”, move them back to Troy. (After test your code,) remove the trigger. Move those
--employees back to “Troy”, if any. Unlock the tables.
create trigger trg_ins_yu on territories
for update as
if exists(select e.employeeid, count(t.TerritoryDescription)from Territories t
join employeeterritories et on t.TerritoryID=et.TerritoryID
join Employees e on et.EmployeeID=e.EmployeeID
where t.TerritoryDescription= 'stevens point'
group by e.EmployeeID
having count(t.TerritoryDescription)>100)
begin
update Territories set TerritoryDescription= 'Tory' where
TerritoryDescription='stevens point'
End
--9.Create 2 new tables “people_your_last_name” “city_your_last_name”. City table has
--two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}. People has three records: {id:1,
--Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody
--Nelson, City:2}. Remove city of Seattle. If there was anyone from Seattle, put them into
--a new city “Madison”. Create a view “Packers_your_name” lists all people from Green
--Bay. If any error occurred, no changes should be made to DB. (after test) Drop both tables and view.
create table people_yu (id int,name char(20),cityid int)
create table city_yu (cityid int,city char(20))
insert into people_yu(id,name,cityid) values(1,'Aaron Rodgers',2)
insert into people_yu(id,name,cityid) values(2,'Russell Wilson',1)
insert into people_yu(id,name,cityid) values(3,'Jody Nelson',2)
insert into city_yu(cityid,city) values(1,'Settle')
insert into city_yu(cityid,city) values(2,'green Bay')
insert into city_yu(cityid,city) values(3,'madison')
update people_yu set cityid = 3 where cityid = 1
delete from city_yu where city = 'settle'
create view Packers_yu as
select p.id, p.name from people_yu p join city_yu c 
on p.cityid=c.cityid where c.city='Green bay'
begin tran
rollback
drop table people_yu
drop table city_yu
drop view Packers_yu
--10. Create a stored procedure “sp_birthday_employees_[you_last_name]” that creates a
--new table “birthday_employees_your_last_name” and fill it with all employees that
--have a birthday on Feb. (Make a screen shot) drop the table. Employee table should not be affected.
create proc sp_birthday_employees_yu as
begin
select employeeid,LastName,FirstName,Title,
TitleOfCourtesy,BirthDate,HireDate,Photo into birthday_employees_yu from
Employees
where month(BirthDate)=2
end
--11. Create a stored procedure named “sp_your_last_name_1” that returns all cites that
--have at least 2 customers who have bought no or only one kind of product. Create a
--stored procedure named “sp_your_last_name_2” that returns the same but using a different approach. (sub-query and no-sub-query).

create proc sp_yu as
select c.city, count(c.CustomerID) from Customers c
inner join (
select x.CustomerID, count(x.CustomerID) xx from (select distinct c.CustomerID,
p.ProductID from Products p
join [Order Details] od on p.ProductID=od.ProductID
join Orders o on od.OrderID=o.OrderID
join Customers c on o.CustomerID=c.CustomerID) x
group by x.CustomerID
having count(x.CustomerID)<2) s
on c.CustomerID= s.CustomerID
group by city
having count(c.CustomerID) >1

--14
select firstname +''+lastname+middlename+ '.' as fullname from table1
--15
declare @student varchar(20)
declare @marks int
set @student
set @marks= (select max(marks) from student where sex='F')
print @student
--16
declare @student varchar(20)
declare @marks int
set @student
set @marks= (select max(marks) from student order by sex)
print @student