-- ======================================================
-- ======================= SELECT =======================
-- ======================================================

/* Orden sintáctico de la cláusula SELECT--

SELECT select_list
	[INTO new_table]
	FROM table
	[WHERE search_condition]
	[GROUP BY group_by_condition]
	[HAVING search_condition]
	[ORDER BY order_expression [ASC|DESC]] */

USE AdventureWorks2019

----------------------------------------------------
-- A. Usar SELECT para recuperar filas y columnas --
----------------------------------------------------

-- Consulta 1
SELECT * 
FROM Production.Product

-- Consulta 2
SELECT *
FROM Production.Product
ORDER BY Name ASC

-- Consulta 3
SELECT p.*
FROM Production.Product AS p
ORDER BY Name DESC

-- Consulta 4
SELECT Name, ProductNumber, ListPrice AS Price
FROM Production.Product 
ORDER BY Name ASC

-- Consulta 5
-- En este ejemplo solo se devuelven las filas de Product que tienen una línea 
-- de productos de R y cuyo valor correspondiente a los días para fabricar es inferior a 4.
SELECT Name, ProductNumber, ListPrice AS Price
FROM Production.Product 
WHERE ProductLine = 'R' 
AND DaysToManufacture < 4
ORDER BY Name ASC

-- Consulta 6
-- Indicar el listado de los empleados del sexo masculino y que son solteros
SELECT * 
FROM HumanResources.Employee 
WHERE Gender  = 'M' 
AND MaritalStatus = 'S'
----------------------------------------------------------
-- B. Usar SELECT con encabezados de columna y cálculos --
----------------------------------------------------------
-- En los siguientes ejemplos se devuelven todas las filas de la tabla Product. En el primer 
-- ejemplo se devuelven las ventas totales y los descuentos de cada producto de cada orden de
-- compra (121.317 productos vendidos)

SELECT p.Name AS ProductName, 
NonDiscountSales = (OrderQty * UnitPrice),
Discounts = ((OrderQty * UnitPrice) * UnitPriceDiscount)
FROM Production.Product AS p 
INNER JOIN Sales.SalesOrderDetail AS sod
ON p.ProductID = sod.ProductID 
ORDER BY ProductName DESC

-- En el segundo ejemplo se calculan los beneficios totales de cada producto de cada orden de 
-- compra (121.317 productos vendidos)
SELECT 'Total income is', ((OrderQty * UnitPrice) * (1.0 - UnitPriceDiscount)), ' for ',
p.Name AS ProductName 
FROM Production.Product AS p 
INNER JOIN Sales.SalesOrderDetail AS sod
ON p.ProductID = sod.ProductID 
ORDER BY ProductName ASC

---------------------------------
-- C. Usar DISTINCT con SELECT --
---------------------------------
-- Obtenemos los nombres (unicos) de los distintos cargos
SELECT DISTINCT JobTitle
FROM HumanResources.Employee
ORDER BY JobTitle
