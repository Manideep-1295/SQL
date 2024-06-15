USE Assignment_1

-- Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(20),
    LastName VARCHAR(20) ,
    Email VARCHAR(30) ,
    Phone VARCHAR(12),
    Address VARCHAR(100)
);

-- Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY ,
    ProductName VARCHAR(30) ,
    Description VARCHAR(100),
    Price DECIMAL(10, 2) 
);

-- Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY ,
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    OrderDate DATETIME ,
    TotalAmount DECIMAL(10, 2) 
);

-- OrderDetails Table
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY ,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT 
);

-- Inventory Table
CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY ,
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    QuantityInStock INT ,
    LastStockUpdate DATETIME 
);



-- Insert records into Customers table
INSERT INTO Customers (CustomerID, FirstName, LastName, Email, Phone, Address)
VALUES
(1, 'John', 'Doe', 'john.doe@example.com', '1234567890', '123 Main St'),
(2, 'Jane', 'Smith', 'jane.smith@example.com', '0987654321', '456 Elm St'),
(3, 'Jim', 'Brown', 'jim.brown@example.com', '5551234567', '789 Oak St');

-- Insert records into Products table
INSERT INTO Products (ProductID, ProductName, Description, Price)
VALUES
(1, 'Laptop', '15 inch gaming laptop', 1200.00),
(2, 'Smartphone', 'Latest model smartphone', 800.00),
(3, 'Headphones', 'Noise cancelling headphones', 150.00);

-- Insert records into Orders table
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount)
VALUES
(1, 1, '2024-06-10', 1350.00),
(2, 2, '2024-06-11', 800.00),
(3, 3, '2024-06-12', 1200.00);

-- Insert records into OrderDetails table
INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity)
VALUES
(1, 1, 1, 1), -- Order 1: 1 Laptop
(2, 1, 3, 1), -- Order 1: 1 Headphones
(3, 2, 2, 1), -- Order 2: 1 Smartphone
(4, 3, 1, 1); -- Order 3: 1 Laptop

-- Insert records into Inventory table
INSERT INTO Inventory (InventoryID, ProductID, QuantityInStock, LastStockUpdate)
VALUES
(1, 1, 50, '2024-06-01'), -- 50 Laptops in stock
(2, 2, 30, '2024-06-01'), -- 30 Smartphones in stock
(3, 3, 100, '2024-06-01'); -- 100 Headphones in stock


-- Displaying all tables
 SELECT * FROM Customers
 SELECT * FROM Products
 SELECT * FROM OrderDetails
 SELECT * FROM Orders
 SELECT * FROM Inventory

-- 1. Write an SQL query to retrieve the names and emails of all customers.

SELECT CONCAT(FirstName,' ',LastName) AS Name,  Email   
FROM Customers
-- 2. Write an SQL query to list all orders with their order dates and corresponding customer names.
SELECT CONCAT(c.FirstName,' ',c.LastName) AS CustomerName,o.OrderID,o.OrderDate FROM orders o
JOIN Customers c
ON o.CustomerID = c.CustomerID
-- 3. Write an SQL query to insert a new customer record into the "Customers" table. Include customer information such as name, email, and address.
INSERT INTO Customers(CustomerID,FirstName,LastName,Email,Phone,Address) VALUES 
(4,'Jack','Daniel','jack.daniel@example.com',9512346785,'147 Down Town')

SELECT * FROM Customers
-- 4. Write an SQL query to update the prices of all electronic gadgets in the "Products" table by increasing them by 10%.
UPDATE Products
SET Price = Price + (Price * 0.1)

SELECT * FROM Products
-- 5. Write an SQL query to delete a specific order and its associated order details from the "Orders" and "OrderDetails" tables. Allow users to input the order ID as a parameter.
SELECT * FROM Orders
SELECT * FROM OrderDetails

