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


--  Analyze Customer Purchase Behavior Patterns to identify high-value and high-risk customers. Clean and Join Data
WITH CustomerSummary AS (
    SELECT 
        c.CustomerID,
        CONCAT(c.FirstName, ' ', c.LastName) AS FullName,
        c.Country,
        MIN(t.TransactionDate) AS FirstPurchaseDate,
        MAX(t.TransactionDate) AS LatestPurchaseDate,
        COUNT(*) AS TotalTransactions,
        SUM(t.Quantity) AS TotalQuantity,
        SUM(t.Quantity * t.Price) AS TotalSpend
    FROM Customers c
    JOIN SalesTransactions t
        ON c.CustomerID = t.CustomerID
    GROUP BY c.CustomerID, CONCAT(c.FirstName, ' ', c.LastName), c.Country
),
SpendRank AS (
    SELECT
        *,
        AVG(TotalSpend) OVER () AS AvgTotalSpend -- window function required
    FROM CustomerSummary
)
SELECT
    CustomerID,
    FullName,
    Country,
    FirstPurchaseDate,
    LatestPurchaseDate,
    TotalTransactions,
    TotalQuantity,
    TotalSpend,
    ROUND(TotalSpend * 1.0 / TotalTransactions, 2) AS AvgSpendPerTransaction,
    DATEDIFF(MONTH, LatestPurchaseDate, GETDATE()) AS MonthsSinceLastPurchase,
    CASE
        WHEN TotalSpend >= AvgTotalSpend * 1.5 THEN 'High'
        WHEN TotalSpend >= AvgTotalSpend * 0.75 THEN 'Medium'
        ELSE 'Low'
    END AS ValueSegment
FROM SpendRank
ORDER BY TotalSpend DESC;
