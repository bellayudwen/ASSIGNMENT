/*1.	What is a result set?
A ResultSet object maintains a cursor that points to the current row in the result set. The term "result set" refers to the row and column data contained in a ResultSet object
2.	What is the difference between Union and Union All?
Union is slower, can be used with cte, give unique result,will sort on first select statement
Union all is fater, can not use with cte, give duplicate result, won't sort on first select statement
3.	What are the other Set Operators SQL Server has?
Insersect: Takes the data from both result sets which are in common.
Except: Takes the data from first result set, but not the second (i.e. no matching to each other)

4.	What is the difference between Union and Join?
UNION in SQL is used to combine the result-set of two or more SELECT statements, It combines data into new rows, Number of columns selected from each table should be same.
JOIN combines data from many tables based on a matched condition between them. It combines data into new columns. Number of columns selected from each table may not be same.

5.	What is the difference between INNER JOIN and FULL JOIN?
Inner join returns only the matching rows between both the tables, non-matching rows are eliminated. Full Join or Full Outer Join returns all rows from both the tables (left & right tables), including non-matching rows from both the tables
6.	What is difference between left join and outer join
The main difference between these joins is the inclusion of non-matched rows. The LEFT JOIN includes all records from the left side and matched rows from the right table, whereas RIGHT JOIN returns all rows from the right side and unmatched rows from the left table.

7.	What is cross join?
A cross join is used when you wish to create a combination of every row from two tables.
8.	What is the difference between WHERE clause and HAVING clause?
A HAVING clause is like a WHERE clause, but applies only to groups as a whole (that is, to the rows in the result set representing groups), whereas the WHERE clause applies to individual rows. A query can contain both a WHERE clause and a HAVING clause

9.	Can there be multiple group by columns?
A GROUP BY clause can contain two or more columns—or, in other words, a grouping can consist of two or more columns
*/


--1.How many products can you find in the Production.Product table?
SELECT COUNT(ProductID) FROM Production.product

/*2.Write a query that retrieves the number of products in the Production.
Product table that are included in a subcategory. 
The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory
*/
SELECT COUNT(productID) FROM Production.Product WHERE ProductSubcategoryID IS NOT NULL
--3.How many Products reside in each SubCategory? Write a query to display the results with the following titles.
SELECT ProductSubcategoryID, COUNT(productID) as CountedProducts FROM Production.Product 
GROUP BY ProductSubcategoryID
--4.How many products that do not have a product subcategory. 
SELECT COUNT(productID) FROM Production.Product WHERE ProductSubcategoryID IS NULL
--5.Write a query to list the summary of products in the Production.ProductInventory table.
SELECT LocationID, COUNT(ProductID) AS CountedProduct FROM  Production.ProductInventory 
GROUP BY LocationID
--6.Write a query to list the summary of products in the Production.ProductInventory table and 
--LocationID set to 40 and limit the result to include just summarized quantities less than 100.
SELECT ProductID, COUNT(*) AS TheSum  FROM  Production.ProductInventory 
WHERE LocationID = 40 
GROUP BY ProductID
HAVING COUNT(*) < 100
--7.Write a query to list the summary of products with the shelf information in the Production.ProductInventory
--table and LocationID set to 40 and limit the result to include just summarized quantities less than 100
SELECT Shelf, ProductID, COUNT(*) AS TheSum FROM Production.ProductInventory 
WHERE LocationID = 40 
GROUP BY Shelf, ProductID  --must be in group by or having clause
HAVING COUNT(*) < 100
--8.Write the query to list the average quantity for products where column LocationID 
--has the value of 10 from the table Production.ProductInventory table.
SELECT ProductID, AVG(quantity) AS Average  FROM  Production.ProductInventory 
WHERE LocationID = 10
GROUP BY ProductID
--9.Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
SELECT ProductID, Shelf, AVG(quantity) AS TheAvg FROM Production.ProductInventory
GROUP BY ProductID, Shelf
--10.Write query  to see the average quantity  of  products by shelf excluding rows that has 
--the value of N/A in the column Shelf from the table Production.ProductInventory
SELECT ProductID, Shelf, AVG(quantity) AS TheAvg FROM Production.ProductInventory
WHERE Shelf != 'N/A'
GROUP BY ProductID, Shelf
--11.List the members (rows) and average list price in the Production.Product table. This should be 
--grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.
SELECT Color, Class, COUNT(*) AS TheCount, AVG(listprice) AS AvgPrice FROM Production.Product
WHERE Color is not NULL and Class is not NULL
GROUP BY Color, Class
--12.Write a query that lists the country and province names from person. CountryRegion and 
--person. StateProvince tables. Join them and produce a result set similar to the following. 
SELECT c.Name AS Country, s.Name AS Province FROM person.CountryRegion AS C
INNER JOIN person.StateProvince AS S ON c.CountryRegionCode = s.CountryRegionCode
--13.Write a query that lists the country and province names from person. CountryRegion and person. 
--StateProvince tables and list the countries filter them by Germany and Canada. Join them 
--and produce a result set similar to the following.
SELECT c.Name AS Country, s.Name AS Province FROM person.CountryRegion AS C
INNER JOIN person.StateProvince AS S ON c.CountryRegionCode = s.CountryRegionCode
WHERE c.Name IN ('Germany', 'Canada')
--14.List all Products that has been sold at least once in last 25 years.
SELECT od.ProductID FROM dbo.[Order Details] AS od
INNER JOIN dbo.orders AS o ON o.orderid = od.orderid
WHERE o.orderdate > '1975-04-01' 
--15.List top 5 locations (Zip Code) where the products sold most.
SELECT TOP 5 od.Shippostalcode FROM dbo.orders AS od
INNER JOIN dbo.orders AS o ON o.orderid = od.orderid
GROUP BY od.Shippostalcode
ORDER BY COUNT(od.orderid)
--16.List top 5 locations (Zip Code) where the products sold most in last 20 years.
SELECT TOP 5 od.Shippostalcode FROM dbo.orders AS od
INNER JOIN dbo.orders AS o ON o.orderid = od.orderid
WHERE o.orderdate > '1980-04-01' 
GROUP BY od.Shippostalcode
ORDER BY COUNT(od.orderid)
--17.List all city names and number of customers in that city.     
SELECT city, COUNT(*) AS Countcustomer FROM dbo.customers 
GROUP BY city
--18.List city names which have more than 10 customers, and number of customers in that city 
SELECT city, COUNT(*) AS Countcustomer FROM dbo.customers 
GROUP BY city
HAVING COUNT(*) > 10
--19.List the names of customers who placed orders after 1/1/98 with order date.
SELECT c.Contactname, o.orderdate FROM dbo.customers c
INNER JOIN dbo.orders AS o ON o.customerid = c.customerid
WHERE o.orderdate > '1998-01-01'
--20.List the names of all customers with most recent order dates 
SELECT  MAX(o.orderdate), c.contactname FROM dbo.customers c
INNER JOIN dbo.orders o ON c.customerid = o.customerid
GROUP BY c.contactname
--21.Display the names of all customers along with the  count of products they bought
SELECT c.contactname, SUM(od.quantity) AS total FROM dbo.customers c
INNER JOIN dbo.orders o on o.customerid = c.customerid
INNER JOIN dbo.[Order Details] od ON od.orderid = o.orderid
GROUP BY c.contactname

--22.Display the customer ids who bought more than 100 Products with count of products.
SELECT c.customerid FROM dbo.customers c 
INNER JOIN dbo.orders o ON o.customerid = c.customerid
INNER JOIN dbo.[Order Details] od ON od.orderid = o.orderid
GROUP BY c.customerid
HAVING SUM(od.quantity) > 100
--23.List all of the possible ways that suppliers can ship their products. Display the results as below
SELECT s.companyname as 'Supplier Company Name', sh.companyname as 'Shipping Company Name'   
FROM dbo.shippers sh
CROSS JOIN dbo.suppliers s 
--24.Display the products order each day. Show Order date and Product Name.
SELECT p.productname, o.orderdate FROM dbo.orders o 
INNER JOIN dbo.[Order Details] od ON o.orderid = od.orderid
INNER JOIN dbo.products p ON p.productid = od.productid
--25.Displays pairs of employees who have the same job title.
SELECT e.title, e.employeeid FROM dbo.employees e
INNER JOIN dbo.employees m ON m.title = e.title
GROUP BY e.title, e.employeeid
--26.Display all the Managers who have more than 2 employees reporting to them.
SELECT e.employeeid  FROM dbo.employees e
WHERE e.ReportsTo > 2 and e.title = 'sales manager'
--27.Display the customers and suppliers by city. The results should have the following columns
--City 
--Name 
--Contact Name,
--Type (Customer or Supplier)
SELECT city, contactname FROM dbo.customers 
UNION ALL
SELECT city, contactname FROM dbo.suppliers
--28.
SELECT f1.t1, f2.t2 FROM f1 f1 INNDER JOIN f2 f2 ON f1.t1 = f2.t2
--show 2,3
--29.
SELECT f1.t1, f2.t2 FROM f1 f1 LEFT JOIN f2 f2 ON f1.t1 = f2.t2
--show 1,2,3
