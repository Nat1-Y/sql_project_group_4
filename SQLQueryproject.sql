/*
2.Customer Segmentation:
Segment customers based on their purchase behavior and demographics. 
Use SQL to extract relevant customer data such as age, gender, purchase frequency, and total spend.
Write SQL queries to join customer data tables and calculate metrics like purchase frequency and total spend for each customer.
 */
 SELECT
   c.CustomerID,
   p.PersonType,
   p.Title, 
   p.FirstName,
   p.LastName,
   ca.EmailAddress,
   DATEDIFF(YEAR, p.ModifiedDate, GETDATE()) AS Age,
   p.PersonType,
   cp.PurchaseFrequency,
   cp.TotalSpend
FROM Sales.Customer c
JOIN Person.Person p
  ON c.PersonID = p.BusinessEntityID
JOIN (
  SELECT 
     CustomerID,
     COUNT(*) AS PurchaseFrequency,
     SUM(soh.TotalDue) AS TotalSpend
  FROM Sales.SalesOrderHeader soh
  GROUP BY CustomerID
) cp
  ON c.CustomerID = cp.CustomerID  
JOIN Person.EmailAddress ca
  ON c.PersonID = ca.BusinessEntityID
/*
5.supplier Analysis:
Assess the performance of suppliers based on their delivery times and product quality. 
Extract data on lead times, on-time delivery rates, and return rates from the database.
Write SQL queries to retrieve supplier performance metrics from tables containing information on purchases, deliveries, and returns.
*/
SELECT
   v.Name,
   AVG(pv.AverageLeadTime) AS Avg_Lead_Time
FROM Purchasing.Vendor v
JOIN Purchasing.ProductVendor pv
   ON v.BusinessEntityID = pv.BusinessEntityID  
GROUP BY v.Name

SELECT
   v.Name,
   COUNT(CASE WHEN pod.ModifiedDate <= pod.DueDate THEN 1 END)*100.0 / COUNT(pod.PurchaseOrderID) AS On_Time_Delivery_Rate
FROM Purchasing.Vendor v
JOIN Purchasing.PurchaseOrderHeader poh
   ON v.BusinessEntityID = poh.VendorID
JOIN Purchasing.PurchaseOrderDetail pod
   ON poh.PurchaseOrderID = pod.PurchaseOrderID
GROUP BY v.Name;

SELECT 
   v.Name,
   SUM(pod.ReceivedQty - pod.StockedQty) * 100.0 / SUM(pod.ReceivedQty) AS Return_Rate
FROM Purchasing.Vendor v
JOIN Purchasing.PurchaseOrderHeader poh
  ON v.BusinessEntityID = poh.VendorID  
JOIN Purchasing.PurchaseOrderDetail pod
  ON poh.PurchaseOrderID = pod.PurchaseOrderID
GROUP BY v.Name
/*
8.Customer Retention Analysis:
Analyze customer retention rates by calculating the percentage of customers who make repeat purchases within a specified time period. Use SQL to extract data on customer transactions and dates.
Write SQL queries to identify repeat customers and calculate retention rates based on their purchase history and transaction dates.
*/
SELECT 
  CustomerID,
  COUNT(DISTINCT OrderDate) AS NumPurchases
FROM Sales.SalesOrderHeader
WHERE OrderDate > DATEADD(MONTH, -6, GETDATE())
GROUP BY CustomerID
HAVING COUNT(DISTINCT OrderDate) > 1

SELECT
  COUNT(DISTINCT CustomerID) * 100.0 / 
  (SELECT COUNT(DISTINCT CustomerID) FROM Sales.SalesOrderHeader)
  AS RetentionRate6Months
FROM
  (SELECT CustomerID
   FROM Sales.SalesOrderHeader
   WHERE OrderDate > DATEADD(MONTH, -6, GETDATE())
   GROUP BY CustomerID
   HAVING COUNT(DISTINCT OrderDate) > 1
  ) AS Repeats

  SELECT
  COUNT(DISTINCT CustomerID) * 100.0 /
  (SELECT COUNT(DISTINCT CustomerID) FROM Sales.SalesOrderHeader)
  AS RetentionRate12Months  
FROM 
  (SELECT CustomerID
   FROM Sales.SalesOrderHeader
   WHERE OrderDate > DATEADD(MONTH, -12, GETDATE()) 
   GROUP BY CustomerID
   HAVING COUNT(DISTINCT OrderDate) > 1
  ) AS Repeats