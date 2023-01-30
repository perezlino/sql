-- ========================================================
-- ========= WITH - Common table expression (CTE) =========
-- ========================================================

-- Sitios para complementar información:
-- https://learn.microsoft.com/es-es/sql/t-sql/queries/with-common-table-expression-transact-sql?view=sql-server-ver16

/*|-------------------------------------------------------------------------------------------|
  | TABLAS COMUNES: Una expresión de tabla común (CTE) es una expresión de tabla con nombre   |
  |                  soportada por Transact-SQL. Hay dos tipos de consultas que utilizan CTEs:|
  |                                                                                           |
  |                 - Consultas no recursivas                                                 |
  |                                                                                           |
  |                 - Consultas recursivas                                                    |
  |                                                                                           |
  |-------------------------------------------------------------------------------------------|*/

/* La sintaxis de la cláusula WITH en las consultas no recursivas es

           WITH cte_name (column_list) AS
		       (inner_query o CTE_query_definition)
		   outer_query  
*/

USE AdventureWorks2019

-- ============================================================================================
-- ============================================================================================

-- En el ejemplo siguiente se muestra el número total de pedidos de ventas al año para 
-- cada representante de ventas en Adventure Works Cycles.

-- Definir el nombre de la expresión CTE y la lista de columnas.
WITH Sales_CTE (SalesPersonID, SalesOrderID, SalesYear)
AS
-- Definir la consulta CTE.
(
    SELECT SalesPersonID, SalesOrderID, YEAR(OrderDate) AS SalesYear
    FROM Sales.SalesOrderHeader
    WHERE SalesPersonID IS NOT NULL
)
-- Definir la consulta externa que hace referencia al nombre del CTE.
SELECT SalesPersonID, COUNT(SalesOrderID) AS TotalSales, SalesYear
FROM Sales_CTE
GROUP BY SalesYear, SalesPersonID
ORDER BY SalesPersonID, SalesYear;

-- ============================================================================================
-- ============================================================================================

-- En el siguiente ejemplo se muestra el número medio de pedidos de venta correspondiente a todos 
-- los años para los representantes de ventas.

WITH Sales_CTE (SalesPersonID, NumberOfOrders)
AS
(
    SELECT SalesPersonID, COUNT(*)
    FROM Sales.SalesOrderHeader
    WHERE SalesPersonID IS NOT NULL
    GROUP BY SalesPersonID
)
SELECT AVG(NumberOfOrders) AS "Average Sales Per Person"
FROM Sales_CTE;

-- ============================================================================================
-- ============================================================================================

-- Uso de varias definiciones de CTE en una sola consulta

-- En el ejemplo siguiente se muestra cómo definir más de una CTE en una sola consulta. Observe que 
-- se usa una coma para separar las definiciones de consulta CTE. La función FORMAT, utilizada para 
-- mostrar las cantidades de moneda en un formato de moneda, está disponible en SQL Server 2012 y 
-- versiones posteriores.

WITH Sales_CTE (SalesPersonID, TotalSales, SalesYear)
AS
-- Definir la primera consulta CTE.
(
    SELECT SalesPersonID, SUM(TotalDue) AS TotalSales, YEAR(OrderDate) AS SalesYear
    FROM Sales.SalesOrderHeader
    WHERE SalesPersonID IS NOT NULL
       GROUP BY SalesPersonID, YEAR(OrderDate)

)
, -- Utilice una coma para separar varias definiciones de CTE.

-- Defina la segunda consulta CTE, que devuelve los datos de cuota de ventas por año para cada vendedor.
Sales_Quota_CTE (BusinessEntityID, SalesQuota, SalesQuotaYear)
AS
(
       SELECT BusinessEntityID, SUM(SalesQuota) AS SalesQuota, YEAR(QuotaDate) AS SalesQuotaYear
       FROM Sales.SalesPersonQuotaHistory
       GROUP BY BusinessEntityID, YEAR(QuotaDate)
)

-- Defina la consulta externa haciendo referencia a las columnas de ambos CTEs.
SELECT SalesPersonID
  , SalesYear
  , FORMAT(TotalSales,'C','en-us') AS TotalSales
  , SalesQuotaYear
  , FORMAT (SalesQuota,'C','en-us') AS SalesQuota
  , FORMAT (TotalSales -SalesQuota, 'C','en-us') AS Amt_Above_or_Below_Quota
FROM Sales_CTE
INNER JOIN Sales_Quota_CTE 
ON Sales_Quota_CTE.BusinessEntityID = Sales_CTE.SalesPersonID
AND Sales_CTE.SalesYear = Sales_Quota_CTE.SalesQuotaYear
ORDER BY SalesPersonID, SalesYear;

-- ============================================================================================
-- ============================================================================================

--CONSULTA NO RECURSIVA--

SELECT SalesOrderID
FROM Sales.SalesOrderHeader
WHERE TotalDue > (SELECT AVG(TotalDue) 
                  FROM Sales.SalesOrderHeader
                  WHERE YEAR(OrderDate) = '2011')

AND Freight > (SELECT AVG(Freight)
               FROM Sales.SalesOrderHeader
               WHERE YEAR(OrderDate) = '2011')/2.5

-- Utilizando WITH

WITH total_due(year_2011) 
AS
(
    SELECT AVG(TotalDue)
    FROM Sales.SalesOrderHeader
    WHERE YEAR(OrderDate) = '2011'
),

freight(freight_2011)
AS
(
    SELECT AVG(Freight)
    FROM Sales.SalesOrderHeader
    WHERE YEAR(OrderDate) = '2011'
)

SELECT SalesOrderID
FROM Sales.SalesOrderHeader
WHERE TotalDue > (SELECT year_2011  FROM total_due)
AND Freight > (SELECT freight_2011  FROM freight)/2.5