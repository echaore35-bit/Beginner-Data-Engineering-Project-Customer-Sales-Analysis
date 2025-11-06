-- Create Table for Customers and SalesTransaction

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Age INT,
    Country VARCHAR(50),
    Email VARCHAR(100),
    SignupDate DATE
);

CREATE TABLE SalesTransactions (
    TransactionID INT PRIMARY KEY,
    CustomerID INT,
    Product VARCHAR(100),
    Category VARCHAR(50),
    Quantity INT,
    Price DECIMAL(10,2),
    TransactionDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Insert the csv data to tbe table s Customers and SalesTransaction
BULK INSERT Customers
FROM 'C:\Projects\report\customers.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ','
)

BULK INSERT SalesTransactions
FROM 'C:\Projects\report\sales_transactions.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ','
)
