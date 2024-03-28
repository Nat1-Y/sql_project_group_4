--Inventory Management:
--Analyze the inventory turnover rate for each product. Calculate the ratio of cost of goods sold 
--to average inventory value for the past year.


WITH InventoryTurnover AS (
    SELECT
        p.ProductID,
        p.Name AS ProductName,
        SUM(s.SubTotal) AS TotalSales,
        SUM(p.StandardCost * i.Quantity) AS AverageInventoryValue
    FROM Sales.SalesOrderHeader AS s
    JOIN Sales.SalesOrderDetail AS sd
        ON s.SalesOrderID = sd.SalesOrderID
    JOIN Production.Product AS p
        ON sd.ProductID = p.ProductID
    JOIN Production.ProductInventory AS i
        ON p.ProductID = i.ProductID
    WHERE
        s.OrderDate >= DATEADD(YEAR, -10, GETDATE()) 
    GROUP BY
        p.ProductID,
        p.Name
)
SELECT
    ProductID,
    ProductName,
    TotalSales,
    AverageInventoryValue,
     CASE
        WHEN AverageInventoryValue = 0 THEN NULL  -- Handle the division by zero error
        ELSE TotalSales / AverageInventoryValue
    END AS InventoryTurnoverRate
FROM InventoryTurnover;

--Write SQL queries to calculate inventory turnover metrics using data on sales, purchases, 
--and inventory levels from the AdventureWorks database


WITH InventoryTurnover AS (
    SELECT
        p.ProductID,
        p.Name AS ProductName,
        SUM(s.SubTotal) AS TotalSales,
        SUM(p.StandardCost * i.Quantity) AS AverageInventoryValue
    FROM Sales.SalesOrderHeader AS s
    JOIN Sales.SalesOrderDetail AS sd
        ON s.SalesOrderID = sd.SalesOrderID
    JOIN Production.Product AS p
        ON sd.ProductID = p.ProductID
    JOIN Production.ProductInventory AS i
        ON p.ProductID = i.ProductID
    WHERE
        s.OrderDate >= DATEADD(YEAR, -10, GETDATE()) And i.Quantity != 0
    GROUP BY
        p.ProductID,
        p.Name
)
SELECT
    ProductID,
    ProductName,
    TotalSales,
    AverageInventoryValue,
    ISNULL(TotalSales / AverageInventoryValue, 0) AS InventoryTurnoverRate,
    ISNULL((365 * AverageInventoryValue) / TotalSales, 0) AS DaysSalesOfInventory,
    ISNULL(365 / (TotalSales / AverageInventoryValue), 0) AS InventoryTurnoverInDays
FROM InventoryTurnover;