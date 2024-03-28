--Product Profitability Analysis:
--Calculate the profitability of each product by subtracting the cost of goods sold from the total
--revenue generated. Consider factors such as discounts and returns in your calculations.

WITH ProductProfitability AS (
    SELECT
        p.ProductID,
        p.Name AS ProductName,
        SUM(s.SubTotal * (1 - so.DiscountPct)) AS TotalRevenue,
        SUM(p.StandardCost * i.Quantity) AS CostOfGoodsSold,
        SUM(s.SubTotal * so.DiscountPct) AS TotalDiscounts,
        SUM(pod.[RejectedQty] * p.StandardCost) AS TotalReturns,
		SUM(pod.[ReceivedQty] * p.StandardCost) AS TotalREcived
    FROM Sales.SalesOrderHeader AS s
    JOIN Sales.SalesOrderDetail AS sd
        ON s.SalesOrderID = sd.SalesOrderID
		join Sales.SpecialOfferProduct as op
		on sd.SpecialOfferID = op.SpecialOfferID
		join sales.SpecialOffer so
		on op.SpecialOfferID = so.SpecialOfferID
    JOIN Production.Product AS p
        ON sd.ProductID = p.ProductID
		JOIN Production.ProductInventory AS i
        ON p.ProductID = i.ProductID
		join [Purchasing].[PurchaseOrderDetail] as pod
		on pod.ProductID = p.ProductID
   
    GROUP BY
        p.ProductID,
        p.Name
)
SELECT
    ProductID,
    ProductName,
    TotalRevenue,
    CostOfGoodsSold,
    TotalDiscounts,
    TotalReturns,
    TotalRevenue - CostOfGoodsSold - TotalDiscounts + TotalReturns AS Profitability
FROM ProductProfitability;
