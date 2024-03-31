
-- Q4 

-- Part 1

SELECT 
    CONCAT(DE.FirstName, ' ', DE.LastName) AS Employee_Name,
    SUM(FIC.SalesAmount) AS Total_Sales_Amount,
    COUNT(FIC.SalesAmount) AS Number_of_Deals,
    SUM(FIC.SalesAmount) / COUNT(FIC.SalesAmount) AS Average_Deal_Size
FROM 
    FactInternetSales FIC
INNER JOIN 
    DimEmployee DE ON FIC.SalesTerritoryKey = DE.SalesTerritoryKey
GROUP BY 
    CONCAT(DE.FirstName, ' ', DE.LastName);
