# Create database to store
CREATE DATABASE RetailStore;
USE Retailstore;

# Create customer table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    City VARCHAR(50)
);

# Create product table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT
);

# Create orders
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    ProductID INT,
    Quantity INT,
    OrderDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

# Insert sample data
INSERT INTO Customers (FirstName, LastName, Email, City) VALUES
('Alice', 'S', 'alice@example.com', 'Boston'),
('Bob', 'J', 'bob@example.com', 'Chicago'),
('Cathy', 'B', 'cathy@example.com', 'New York');

INSERT INTO Products (ProductName, Category, Price, Stock) VALUES
('Wireless Mouse', 'Electronics', 25.99, 50),
('Bluetooth Speaker', 'Electronics', 45.50, 30),
('Notebook', 'Stationery', 2.99, 100);

INSERT INTO Orders (CustomerID, ProductID, Quantity, OrderDate) VALUES
(1, 1, 2, '2025-04-01'),
(2, 3, 5, '2025-04-02'),
(1, 2, 1, '2025-04-03');

# listing all the customer in Boston
SELECT * FROM Customers WHERE city = "Boston";

#  List all products with price above $10
SELECT ProductName, Price FROM Products WHERE Price > 10;

# Total items ordered by each customer
SELECT c.FirstName, c.LastName, SUM(o.Quantity) AS TotalItemsOrdered
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID;

# Order details with customer and product info
SELECT o.OrderID, c.FirstName, c.LastName, p.ProductName, o.Quantity, o.OrderDate
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON o.ProductID = p.ProductID;

# Revenue generated per product
SELECT 
    p.ProductName,
    SUM(o.Quantity * p.Price) AS TotalRevenue
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
GROUP BY p.ProductName;

# List customers who ordered “Notebook”
SELECT DISTINCT 
    c.FirstName, 
    c.LastName
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON o.ProductID = p.ProductID
WHERE p.ProductName = 'Notebook';

# all orders with customer name and product details
SELECT 
    o.OrderID,
    c.FirstName AS CustomerFirstName,
    c.LastName AS CustomerLastName,
    p.ProductName,
    o.Quantity,
    o.OrderDate
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON o.ProductID = p.ProductID;



