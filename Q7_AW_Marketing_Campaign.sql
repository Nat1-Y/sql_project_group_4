Marketing Campaign Effectiveness:

Measure the effectiveness of marketing campaigns by analyzing sales data before and after
the campaigns. Calculate metrics such as sales lift, ROI, and customer acquisition cost.

Write SQL queries to extract sales data before and after specific marketing campaigns,
calculating performance metrics based on campaign periods and customer behavior.


SELECT DM.PromotionKey,
	   DM.EnglishPromotionName,
       DM.StartDate,
       DM.EndDate,
       COUNT(DISTINCT FRS.CustomerKey) AS CustomersAcquired,
       SUM(FRS.SalesAmount) AS TotalSales,
       (SUM(FRS.SalesAmount) - SUM(FRS.TotalProductCost)) / COUNT(DISTINCT FRS.CustomerKey) AS CustomerAcquisitionCost,
       (SUM(FRS.SalesAmount) - SUM(FRS.TotalProductCost)) / SUM(FRS.TotalProductCost) * 100 AS ROI
FROM DimPromotion DM
    JOIN FactInternetSales FRS
        ON DM.PromotionKey = FRS.PromotionKey

GROUP BY DM.PromotionKey,
         DM.EnglishPromotionName,
         DM.StartDate,
         DM.EndDate

Order by DM.PromotionKey