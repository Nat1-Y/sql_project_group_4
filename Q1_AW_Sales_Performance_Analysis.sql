-- Q1 Sales Performance Analysis

-- A, Generate a report showcasting the total amount for
-- each product category over the past three years.
-- include a trend analysis to identify any significant
-- changes in sales volume.

WITH Sales AS
  (SELECT PPC.Name AS PRODUCT_CATEGORY,
          YEAR(SOH.OrderDate) AS SALES_YEAR,
          SUM(SOD.LineTotal) AS TOTAL_AMOUNT
   FROM Sales.SalesOrderHeader SOH
   INNER JOIN Sales.SalesOrderDetail SOD ON SOH.SalesOrderID = SOD.SalesOrderID
   INNER JOIN Production.Product PP ON PP.ProductID = SOD.ProductID
   INNER JOIN Production.ProductSubcategory PPS ON PPS.ProductSubcategoryID = PP.ProductSubcategoryID
   INNER JOIN Production.ProductCategory PPC ON PPC.ProductCategoryID = PPS.ProductCategoryID
   GROUP BY PPC.Name,
            YEAR(SOH.OrderDate))
SELECT PRODUCT_CATEGORY,
       SALES_YEAR,
       TOTAL_AMOUNT
FROM Sales
