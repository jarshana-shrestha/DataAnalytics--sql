
/* create an e-commerce database*/
CREATE DATABASE EcommerceDB;
SHOW DATABASES;
USE EcommerceDB;

# Customers table
CREATE TABLE Customers (
customer_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(100),
email VARCHAR(100) UNIQUE,
city VARCHAR(100)
);

SHOW TABLES;

# Set sql_safe_updates =0; (esle chai safe mode deactivate huncha)
# ALTER Table Customers auto_increment = 0; (delete garyo bhani back to 0 bata start huncha numbering)

# Orders table
CREATE TABLE Orders (
order_id INT PRIMARY KEY AUTO_INCREMENT,
customer_id INT,
order_date DATE, 
total_amount DECIMAL(10,2),
FOREIGN KEY(customer_id) REFERENCES CUSTOMERS(customer_id)
);

Select * FROM Products;
# Products table
CREATE TABLE Products (
product_id INT PRIMARY KEY AUTO_INCREMENT,
product_name VARCHAR(100),
category VARCHAR(50),
price DECIMAL(10,2)
);

# Order Items Table
CREATE TABLE Order_items (
item_id INT PRIMARY KEY AUTO_INCREMENT,
order_id INT,
product_id INT,
quantity INT,
price DECIMAL(10,2),
FOREIGN KEY(order_id) REFERENCES Orders(order_id),
FOREIGN KEY(product_id) REFERENCES Products(product_id)
);

#Step 2 - insert sample Data

# Customers table
INSERT INTO Customers (name,email,city) VALUES
("Jarshana", "j.sh@gmail.com","Bhaktapur"),
("Alex", "alex@gmail.com", "Kathmandu"),
("Ben", "ben@gmail.com","Medford"),
("Christina", "christina@gmail.com","Lalitpur"),
("Diana", "diana@gmail.com","Boston");

Select * FROM Customers;


# Products Table
Insert INTO Products (product_name, category, price) Values
('Laptop', 'Electronics', 800.00),
('Keyboard', 'Electronics', 60.00),
('Mouse', 'Electronics', 20.00),
('Ipad', 'Electronics', 1000.00),
('Iphone', 'Electronics', 1200.00);

#Orders Table
Insert INTO Orders (customer_id, order_date, total_amount) VALUES
(1, '2025-03-19', 800.00),
(2, '2025-01-20', 1000.00),
(3, '2025-02-25', 700.00),
(4, '2025-01-08', 499.99),
(5, '2025-03-13', 575.50);
Select * FROM Orders;

# Order_items
INSERT INTO Order_items (order_id, product_id, quantity, price) VALUES 
(1, 1, 1, 800.00),
(3, 2, 2, 700.00),
(3, 4, 1, 40.00),
(4, 2, 1, 700.00),
(5, 3, 1, 25.00);
Select * FROM Order_items;

# Step 3 - Advanced SQL  Queries
# Joins
SELECT * FROM Customers;
SELECT * FROM Orders;

INSERT INTO Customers (name, email,city) values
("Fiona", "fiona@gmail.com", "Chelsea");

# Inner Join
SELECT 
Customers.Customer_id, 
Customers.name, 
Orders.order_id,
Orders.order_date
From Customers
INNER JOIN Orders ON Customers.customer_id = Orders.customer_id;

#Left Join
Select Customers.Customer_id, Customers.name, Orders.order_id
From Customers
LEFT JOIN Orders ON Customers.customer_id = Orders.customer_id;

#Right Join
Select Customers.Customer_id, Customers.name, Orders.order_id
From Customers
Right JOIN Orders ON Customers.customer_id = Orders.customer_id;

#Full Join
Select Customers.Customer_id, Customers.name, Orders.order_id
From Customers
LEFT JOIN Orders ON Customers.customer_id = Orders.customer_id
UNION
Select Customers.Customer_id, Customers.name, Orders.order_id
From Customers
Right JOIN Orders ON Customers.customer_id = Orders.customer_id;


# Cross Join
SELECT Customers.name, Customers.customer_id, 
Orders.order_id, ORDERS.total_amount
FROM Customers
CROSS JOIN Orders;


Insert INTO Orders (customer_id, order_date, total_amount) VALUES
(3, '2025-03-19', 5000.00),
(5, '2025-01-20', 150.50),
(1, '2025-02-25', 699.99);


# Subqueries
# A subquery is a query inside another query.
/* Used to:
- Filetr rows based on a condition
- Acts as a virtual table or column
- Return calculated or aggregated values.
*/

/* Types:
- Scalar subquery -> return a single values
- Row subquery -> return a single row ([multiple columns)
- Table subquery-> return a multiple row
- Correlated subquery-> depend on outer query row by row
*/

show databases;
use EcommerceDB;
SELECT * from customers;
SELECT * from orders;

# Scalar Subquery -> Get customers who spent more than the average order 
/*
-select and print name and email of customers from customers table
- Subquery SUM(total_amount)> Avg (tota_amount)-> Print details
- Average amount spend by customers to orders
(825+1400+740)/3
*/

Select customer_id, name, email
From Customers
Where customer_id in(
	Select customer_id
	From Orders
	Group by customer_id
	Having SUM (total_amount)>(
Select ang(total_amount) from Orders));

# Correlated subqueries
/*
Find customers who have placed more than 1 order
*/

Select name
FROM customers c
WHERE (
	SELECT Count(*)
    FROM orders o
    Where o.customer_id = c.customer_id)>1;
    
Select count(*)
from orders;

# find the total amount spent by each customer and display their name along with their total spending
SELECT c.name, order_summary.total_spent
FROM Customers c
JOIN (
    SELECT customer_id, SUM(total_amount) AS total_spent
    FROM Orders
    GROUP BY customer_id
) AS order_summary 
ON c.customer_id = order_summary.customer_id;

/* 
- Perform calculation across a set of rows that are related to current

ROWNUMBER () Assigns a unique number to each row
RANK() gives ranking with gaps or ties
DENSE_RANK() gives ranking without gaps
*/


SELECT customer_id, sum (total_Amount)
FROM orders
Group by customer_id;

# Rank Customers by Spending
/* 
- Calculate total_spent by customers
- Arrange [Rank them over Orver BY sum(total amount)] them in desending order
- Print*/

SELECT c.name,
sum(o.total_amount) AS total_spent,
RANK () OVER (ORDER BY SUM(o.total_amount) DESC) AS Valued_Customer
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
Group by c.name;





