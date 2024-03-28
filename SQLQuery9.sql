SELECT
    AVG(LeadTime) AS AverageLeadTime,
    AVG(TransitTime) AS AverageTransitTime,
    AVG(DeliveryTime) AS AverageDeliveryTime,
    MIN(LeadTime) AS MinimumLeadTime,
    MIN(TransitTime) AS MinimumTransitTime,
    MIN(DeliveryTime) AS MinimumDeliveryTime,
    MAX(LeadTime) AS MaximumLeadTime,
    MAX(TransitTime) AS MaximumTransitTime,
    MAX(DeliveryTime) AS MaximumDeliveryTime
FROM (
    SELECT
        o.SalesOrderID,
        o.OrderDate,
        o.[ShipDate],
        o.DueDate,
        DATEDIFF(DAY, o.OrderDate, o.[ShipDate]) AS LeadTime,
        DATEDIFF(DAY, o.[ShipDate], o.DueDate) AS TransitTime,
        DATEDIFF(DAY, o.OrderDate, o.DueDate) AS DeliveryTime
    FROM Sales.SalesOrderHeader AS o
) AS subquery;