-- Display both tables
SELECT * FROM Customers
SELECT * FROM SalesTransactions

-- List all customers who have never made a purchase.
SELECT c.*
FROM Customers c
LEFT JOIN SalesTransactions t
    ON c.CustomerID = t.CustomerID
WHERE t.CustomerID IS NULL;

-- Show the top 10 products by total revenue generated.
SELECT TOP 10 
	Product,
	SUM(Quantity * Price) AS TotalRevenue
FROM SalesTransactions
GROUP BY Product
ORDER BY TotalRevenue DESC;

-- For each customer, show their first purchase date and total lifetime spend.

SELECT
	CustomerID,
	MIN(TransactionDate) AS FirstPurchase,
	SUM(Quantity * Price) TotalSpend
FROM SalesTransactions
GROUP BY CustomerID

-- Determine which country has the highest average transaction value.

SELECT 
	c.Country,
	AVG(Quantity * Price) AS AvgRevenue
FROM Customers c
LEFT JOIN SalesTransactions t
ON  c.CustomerID = t.CustomerID
GROUP BY c.Country

-- Monthly revenue trend
SELECT
    FORMAT(t.TransactionDate, 'yyyy-MM') AS Month,
    SUM(t.Quantity * t.Price) AS TotalRevenue
FROM SalesTransactions t
GROUP BY FORMAT(t.TransactionDate, 'yyyy-MM')
ORDER BY Month;


