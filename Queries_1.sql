USE Assignment_1

-- Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50) ,
    Email VARCHAR(100) ,
    Phone VARCHAR(15),
    Address VARCHAR(255)
);

-- Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY ,
    ProductName VARCHAR(100) ,
    Description VARCHAR(255),
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
