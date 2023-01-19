-- ======================================================
-- =========== FUNCIONES CAMBIO TIPO DE DATO ============
-- ======================================================

-- ============
-- === CAST ===
-- ============

/* CAST: es una función genérica que lo que hace es convertirnos un tipo de dato en 
         otro siempre y cuando sea del mismo género, es decir, de un decimal a un número 
		 entero (numérico). Este cambio es solo a nivel de la operación NO a nivel real.                                                                  */

-- La columna UnitPrice en un inicio estaba configurada como MONEY
SELECT UnitPrice,
       CAST(UnitPrice AS INT) AS UnitPrice_int
FROM Purchasing.PurchaseOrderDetail

-- ============================================================================================
-- ============================================================================================

-- Convertimos dos textos y los sumamos
SELECT CAST('5' AS INT) + CAST('5' AS INT)

-- ============================================================================================
-- ============================================================================================

-- En estos ejemplos se recupera el nombre de aquellos productos que tienen un 33 como primeros 
-- dígitos del precio y se convierte sus valores ListPrice en INT (era del tipo MONEY).
SELECT SUBSTRING(Name, 1, 30) AS ProductName,
    ListPrice
FROM Production.Product
WHERE CAST(ListPrice AS INT) LIKE '33%'

-- ============================================================================================
-- ============================================================================================

-- Uso de CAST para concatenar
SELECT 'El list price es ' + CAST(ListPrice AS VARCHAR(12)) AS ListPrice
FROM Production.Product
WHERE ListPrice BETWEEN 350.00 AND 400.00

-- ============================================================================================
-- ============================================================================================

-- En este ejemplo se usa CAST en la lista SELECT para convertir la columna 'Name' en una columna 
-- de tipo char(10). 
SELECT DISTINCT CAST(Name AS CHAR(11)) AS Name,
       ListPrice
FROM Production.Product
WHERE Name LIKE 'Long-Sleeve Logo Jersey, M'

-- ============================================================================================
-- ============================================================================================

-- En este ejemplo se convierten los valores SalesYTD que tienen el tipo de dato 'money' al tipo 
-- de datos 'int' y, después, al tipo de datos char(20), de modo que la cláusula LIKE pueda usarlo.
SELECT p.FirstName,
    p.LastName,
    s.SalesYTD,
    s.BusinessEntityID
FROM Person.Person AS p
INNER JOIN Sales.SalesPerson AS s
    ON p.BusinessEntityID = s.BusinessEntityID
WHERE CAST(s.SalesYTD AS INT) LIKE '2%'

-- ============================================================================================
-- ============================================================================================

-- ===============
-- === CONVERT ===
-- ===============

-- CONVERT(TipoDato,NombreColumna,Estilo)

-- Podemos utilizar un MIN y un MAX en el mismo SELECT. También podemos convertir formatos de 
-- fechas que vienen con la hora, a formato solo de fechas y en el orden que necesitemos.

SELECT CustomerID, 
       TerritoryID,
       CONVERT(VARCHAR(10),MIN(OrderDate),105) AS primera_compra,
       CONVERT(VARCHAR(10),MAX(OrderDate),23) AS ultima_compra
FROM Sales.SalesOrderHeader
GROUP BY TerritoryID,CustomerID
ORDER BY TerritoryID,CustomerID

-- Convierto un tipo de datos DATETIME (traen la fecha y la hora) a DATE (solo la fecha)
SELECT 
OrderDate,
CONVERT(DATE,OrderDate) AS Fecha
FROM Sales.SalesOrderHeader

-- Extraigo la hora, conviertiendo el dato DATETIME a TIME
SELECT 
OrderDate,
CONVERT(TIME,OrderDate) AS Hora
FROM Sales.SalesOrderHeader

/* Convertimos la fecha al formato latinoamericano) */
SELECT 
OrderDate,
CONVERT(VARCHAR(10),OrderDate,103) AS Fecha
FROM Sales.SalesOrderHeader