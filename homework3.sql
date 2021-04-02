
--1.List all cities that have both Employees and Customers.
SELECT C.CITY FROM CUSTOMERS C INNER JOIN EMPLOYEES E ON C.CITY = E.CITY
--2.List all cities that have Customers but no Employee.
--a.Use sub-query
--b.Do not use sub-query
SELECT CITY FROM CUSTOMERS WHERE CITY NOT IN
(SELECT CITY FROM EMPLOYEES)
SELECT C.CITY FROM CUSTOMERS C LEFT OUTER JOIN EMPLOYEES E ON C.CITY = E.CITY
WHERE E.CITY IS NULL
--3.List all products and their total order quantities throughout all orders.
SELECT P.PRODUCTNAME, COUNT(OD.ORDERID) AS TOTALORDER FROM PRODUCTS P 
LEFT JOIN [Order Details] OD ON OD.PRODUCTID = P.PRODUCTID
GROUP BY P.PRODUCTNAME
--4.List all Customer Cities and total products ordered by that city.
SELECT C.CITY, COUNT(OD.QUANTITY) AS TOTALPRODUCT FROM CUSTOMERS C 
LEFT JOIN ORDERS O ON O.CUSTOMERID = C.CUSTOMERID
LEFT JOIN [Order Details] OD ON OD.ORDERID = O.ORDERID
GROUP BY C.CITY
--5.List all Customer Cities that have at least two customers.
--a.Use union
--b.Use sub-query and no union
SELECT CITY FROM CUSTOMERS WHERE CITY IN
(SELECT CITY FROM CUSTOMERS 
GROUP BY CITY
HAVING COUNT(CUSTOMERID) > 2)
--6.List all Customer Cities that have ordered at least two different kinds of products.
SELECT CITY FROM CUSTOMERS WHERE CITY IN 
(SELECT C.CITY FROM CUSTOMERS C INNER JOIN ORDERS O ON O.CUSTOMERID = C.CUSTOMERID
INNER JOIN [Order Details] OD ON OD.ORDERID = O.ORDERID
GROUP BY C.CITY
HAVING COUNT(OD.PRODUCTID) > 1)
--7.List all Customers who have ordered products, but have the ‘ship city’ on 
--the order different from their own customer cities.
SELECT CONTACTNAME FROM CUSTOMERS WHERE CITY IN
(SELECT C.CITY FROM CUSTOMERS C INNER JOIN ORDERS O ON O.CUSTOMERID = C.CUSTOMERID
WHERE C.CITY != O.SHIPCITY) 
--8.List 5 most popular products, their average price, and the customer city 
--that ordered most quantity of it.
SELECT DT.PRODUCTNAME, DT.AVGPRICE, C.CITY FROM CUSTOMERS C 
INNER JOIN
(SELECT TOP 5 P.PRODUCTNAME, AVG(P.UNITPRICE) AS AVGPRICE, O.CUSTOMERID FROM PRODUCTS P
INNER JOIN [Order Details] OD ON OD.PRODUCTID = P.PRODUCTID
INNER JOIN ORDERS O ON O.ORDERID = OD.ORDERID
GROUP BY P.PRODUCTNAME, O.CUSTOMERID 
ORDER BY SUM(OD.QUANTITY) DESC) DT
ON DT.CUSTOMERID = C.CUSTOMERID
--9.List all cities that have never ordered something but we have employees there.
--a.	Use sub-query
--b.	Do not use sub-query
SELECT CITY FROM EMPLOYEES WHERE CITY NOT IN
(SELECT C.CITY FROM CUSTOMERS C 
INNER JOIN ORDERS O ON O.CUSTOMERID = C.CUSTOMERID
INNER JOIN [Order Details] OD ON OD.ORDERID = O.ORDERID)
--10.	List one city, if exists, that is the city from where the employee sold 
--most orders (not the product quantity) is, and also the city of most total quantity 
--of products ordered from. (tip: join  sub-query)

SELECT TOP 1 C.CITY AS 'TOP ORDER COUNT' FROM CUSTOMERS C 
INNER JOIN ORDERS O ON C.CUSTOMERID = O.CUSTOMERID
INNER JOIN [Order Details] OD ON OD.ORDERID = O.ORDERID
GROUP BY C.CITY
ORDER BY SUM(OD.QUANTITY) DESC
SELECT TOP 1 C.CITY AS 'TOP QUANTITY' FROM CUSTOMERS C
INNER JOIN ORDERS O ON C.CUSTOMERID = O.CUSTOMERID
GROUP BY C.CITY
ORDER BY COUNT(O.ORDERID) DESC
--11.
WITH CTE AS
(SELECT *,ROW_NUMBER() OVER (PARTITION BY NAME, SALARY, DEPARTMENT ORDER BY NAME, SALARY, DEPARTMENT) AS RN
FROM EMPLOYEES)
DELETE FROM CTE WHERE RN<>1
--13.Find departments that have maximum number of employees. (solution should consider scenario having more than 1 
--departments that have maximum number of employees). Result should only have - deptname, count of employees sorted
--by deptname.
SELECT * FROM
(SELECT DEPTNAME, COUNT(*), RANK() OVER (PARTITION BY DEPARTMENT ORDER BY COUNT(NAME)) RNK FROM EMPLOYEES)DT
 WHERE DT.RNK = 1
--14.Find top 3 employees (salary based) in every department. Result should have deptname, empid, salary sorted
--by deptname and then employee with high to low salary.
SELECT * FROM
(SELECT DEPTNAME, EMPLOYEEID, SALARY, DENSE_RANK() OVER (PARTITION BY DEPNAME ORDER BY SALARY DESC) RNK FROM EMPLOYEE) DT
WHERE RNK < 4
/*1.	In SQL Server, assuming you can find the result by using both joins and subqueries, which one would you prefer to use and why?
Subqueries can be used to return either a scalar (single) value or a row set; whereas, joins are used to return rows.
2.	What is CTE and when to use it?
the common table expression (CTE) is a temporary named result set that you can reference within a SELECT, INSERT, UPDATE, or DELETE statement. You can also use a CTE in a CREATE a view, as part of the view’s SELECT query
3.	What are Table Variables? What is their scope and where are they created in SQL Server?
The table variable is a special type of the local variable that helps to store data temporarily, similar to the temp table in SQL Server. In fact, the table variable provides all the properties of the local variable, but the local variables have some limitations, unlike temp or regular tables.
4.	What is the difference between DELETE and TRUNCATE? Which one will have better performance and why?
Truncate reseeds identity values, whereas delete doesn't.
Truncate removes all records and doesn't fire triggers.
Truncate is faster compared to delete as it makes less use of the transaction log.
Truncate is not possible when a table is referenced by a Foreign Key or tables are used in replication or with indexed views.
5.	What is Identity column? How does DELETE and TRUNCATE affect it?
When the DELETE statement is executed without WHERE clause it will delete all the rows. However, when a new record is inserted the identity value is increased from 11 to 12. It does not reset but keep on increasing.
When the TRUNCATE statement is executed it will remove all the rows. However, when a new record is inserted the identity value is increased from 11 (which is original value). TRUNCATE resets the identity value to the original seed value of the table.
6.	What is difference between “delete from table_name” and “truncate table table_name”?
When you use the DELETE statement, the database system logs the operations. And with some efforts, you can roll back the data that was deleted. However, when you use the TRUNCATE TABLE statement, you have no chance to roll back except you use it in a transaction that has not been committed.
To delete data from a table referenced by a foreign key constraint, you cannot use the TRUNCATE TABLE statement. In this case, you must use the DELETE statement instead.
The TRUNCATE TABLE statement does not fire the delete trigger if the table has the triggers associated with it.
The DELETE statement with a WHERE clause deletes partial data from a table while the TRUNCATE TABLE statement always removes all data from the table.
/*