Employee Performance Evaluation:

Evaluate the performance of sales employees by analyzing their sales activities. Calculate
metrics such as total sales amount, number of deals closed, and average deal size for each
employee.

Write SQL queries to aggregate sales data by employee, calculating performance metrics based
on sales transactions.


SELECT Q1.EmployeeKey,
       Q1.FULL_NAME,
       sum(Q1.SalesAmount) AS TOTAL_SALES,
	   count(Q1.SalesOrderNumber) AS NUMBER_ORDERS,
	   sum(Q1.SalesAmount) / count(Q1.SalesOrderNumber) AS AVERAGE_DEAL_SIZE
FROM
  (SELECT DE.EmployeeKey,
          FirstName + '' + LastName AS FULL_NAME,
          SalesAmount,
		  SalesOrderNumber
   FROM DimEmployee DE
   INNER JOIN FactResellerSales FRS ON DE.EmployeeKey = FRS.EmployeeKey) Q1
GROUP BY Q1.EmployeeKey,
         Q1.FULL_NAME
ORDER BY
		AVERAGE_DEAL_SIZE DESC
