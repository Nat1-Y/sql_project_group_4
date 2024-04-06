 Sales Performance Analysis:

 Generate a report showcasing the total sales amount for each product category over the past
 three years. Include a trend analysis to identify any significant changes in sales volume.

 Write SQL queries to retrieve sales data from the AdventureWorks database, grouping by
 product category and aggregating sales amounts over time.

WITH SalesData AS (
    SELECT   
        PC.EnglishProductCategoryName AS PRODUCT_NAME,  
        DATEPART(YEAR, FRS.OrderDate) AS YEAR,
        SUM(FRS.SalesAmount) AS TOTAL_SALES,
        LAG(SUM(FRS.SalesAmount)) 
      OVER (PARTITION BY PC.EnglishProductCategoryName 
      ORDER BY DATEPART(YEAR, FRS.OrderDate)) AS PREVIOUS_YEAR_SALES
    FROM 
        DimProductCategory PC 
    INNER JOIN 
        DimProductSubcategory PSC ON PC.ProductCategoryKey = PSC.ProductCategoryKey
    INNER JOIN 
        DimProduct P ON PSC.ProductSubcategoryKey = P.ProductSubcategoryKey
    INNER JOIN 
        FactResellerSales FRS ON P.ProductKey = FRS.ProductKey
    WHERE 
        FRS.OrderDate BETWEEN '2011-01-01' AND '2013-12-31'
    GROUP BY 
        PC.EnglishProductCategoryName, DATEPART(YEAR, FRS.OrderDate)
)
SELECT 
    PRODUCT_NAME,
    YEAR,
    TOTAL_SALES,
    PREVIOUS_YEAR_SALES,
    YEAR_CHANGE = TOTAL_SALES - PREVIOUS_YEAR_SALES,
    Percent_Change = CASE WHEN Previous_Year_Sales <> 0 THEN (TOTAL_SALES - PREVIOUS_YEAR_SALES) / PREVIOUS_YEAR_SALES * 100 END
FROM 
    SalesData
ORDER BY 
    PRODUCT_NAME, YEAR;
