-- ======================================================
-- ================== TABLAS TEMPORALES =================
-- ======================================================

-- Una tabla temporal sql server, como sugiere el nombre, es una tabla de base de datos 
-- que existe temporalmente en el servidor. Una tabla temporal almacena un subconjunto de
-- datos de una tabla normal durante un cierto período de tiempo.

USE AdventureWorks2019

--- Ejemplo 1 
SELECT P.ProductID, 
       P.Name AS Producto,
       P.ProductSubcategoryID AS SubcategoriaProducto
INTO #Prueba
FROM Production.Product P
WHERE P.Name LIKE 'S%' OR P.Name LIKE 'H%'

SELECT * FROM #Prueba

--Ahora podemos reutilizar esta tabla temporal

SELECT P.ProductID 'ProductID',
       P.Producto,
       PS.Name 'Subcategoria',
       P.SubcategoriaProducto,
       PS.ProductSubcategoryID 'SubcategoriaID'
FROM #Prueba P 
INNER JOIN Production.ProductSubcategory PS
ON P.SubcategoriaProducto = PS.ProductSubcategoryID

--Para eliminar tabla temporal
DROP TABLE #Prueba

--La TABLA TEMPORAL funcionara solo en la Query en donde fue creada, si abrimos otra Query no
--se cargará. En ese caso, tendriamos que modificar la tabla temporal local a tabla temporal global
--anteponiendo un # más en su nombre.

SELECT P.ProductID,
       P.Name Producto,
       P.ProductSubcategoryID 'SubcategoriaProducto'
INTO ##Prueba
FROM Production.Product P
WHERE P.Name LIKE 'S%' 
OR P.Name LIKE 'H%'

-- ============================================================================================
-- ============================================================================================

--- Ejemplo 2 
SELECT P.FirstName,
       P.LastName,
       T.Name 'Tipo teléfono',
       COUNT(F.PhoneNumber) AS 'Cantidad'
FROM Person.Person P 
INNER JOIN Person.PersonPhone F
ON F.BusinessEntityID = P.BusinessEntityID 
INNER JOIN Person.PhoneNumberType T
ON T.PhoneNumberTypeID = F.PhoneNumberTypeID
WHERE P.FirstName = 'Elijah'
GROUP BY P.FirstName, P.LastName

--Creamos las tablas temporales
SELECT P.FirstName,
       P.LastName,
       P.BusinessEntityID 'ID'
INTO #Person
FROM Person.Person P
WHERE P.FirstName = 'Elijah'

SELECT F.BusinessEntityID 'ID',
       T.Name 'Tipo teléfono',
       COUNT(F.PhoneNumber) 'Cantidad'
INTO #PersonPhone
FROM Person.PersonPhone F 
INNER JOIN Person.PhoneNumberType T
ON T.PhoneNumberTypeID = F.PhoneNumberTypeID
GROUP BY F.BusinessEntityID,T.Name

--Reutilizamos las tablas temporales
SELECT P.FirstName,
       P.LastName,
       PP.[Tipo teléfono],
       PP.Cantidad
FROM #Person P 
INNER JOIN #PersonPhone PP
ON PP.ID = P.ID

-- ============================================================================================
-- ============================================================================================

--- Ejemplo 3

-- Obtener la lista de Clientes cuya cantidad de ordenes generadas sea mayor que 5. Muestre el 
-- nombre y apellido (concatenados), el tipo persona y la cantidad de las órdenes. Utilizaremos
-- las tablas Person.Person, Sales.Customer, Sales.SalesOrderHeader.

-- Mostraremos 3 formas de hacer esta consulta.

-- Forma 1
SELECT CONCAT(P.FirstName,' ',P.LastName) AS 'Nombre y Apellido',
       P.PersonType,
       COUNT(SO.SalesOrderID) AS 'Cantidad Ordenes'
FROM Person.Person P 
INNER JOIN Sales.Customer C
ON C.CustomerID = P.BusinessEntityID
INNER JOIN Sales.SalesOrderHeader SO
ON SO.CustomerID = C.CustomerID
GROUP BY CONCAT(P.FirstName,' ',P.LastName), P.PersonType
HAVING COUNT(SO.SalesOrderID) > 5
ORDER BY COUNT(SO.SalesOrderID) DESC

-- Forma 2
SELECT nombre_y_apellido, 
       tipo_persona, 
       COUNT(tabla_derivada.SalesOrderID) AS cantidad_ordenes
FROM (SELECT CONCAT(FirstName, ' ', LastName) AS nombre_y_apellido,
             PersonType AS tipo_persona,
             SalesOrderID
             FROM Person.Person P
             INNER JOIN Sales.Customer C
             ON C.CustomerID = P.BusinessEntityID
             INNER JOIN Sales.SalesOrderHeader SO
             ON SO.CustomerID = C.CustomerID) AS tabla_derivada 
GROUP BY nombre_y_apellido, tipo_persona
HAVING COUNT(tabla_derivada.SalesOrderID) > 5
ORDER BY cantidad_ordenes DESC

-- Forma 3 (utilizando tablas temporales)
--Crear las tablas temporales
SELECT P.BusinessEntityID 'ID',
       CONCAT(P.FirstName,' ',P.LastName) AS 'Nombre y Apellido',
       P.PersonType
INTO #Person2
FROM Person.Person P

SELECT C.CustomerID,
       SO.SalesOrderID
INTO #Customer
FROM Sales.Customer C
INNER JOIN Sales.SalesOrderHeader SO
ON SO.CustomerID = C.CustomerID

SELECT P.[Nombre y Apellido],
       P.PersonType,
       COUNT(C.SalesOrderID) AS 'Cantidad'
FROM #Person2 P 
INNER JOIN #Customer C
ON C.CustomerID = P.ID
GROUP BY P.[Nombre y Apellido], P.PersonType
HAVING COUNT(C.SalesOrderID) > 5

-- ============================================================================================
-- ============================================================================================

--- Ejemplo 4 ---
DECLARE @nombre VARCHAR(50) = 'NORTHEAST'
DECLARE @nombre1 VARCHAR(50) = 'CENTRAL'

SELECT CONCAT(P.FirstName,' ',P.MiddleName,'',P.LastName) AS 'Nombre y Apellido',
       SP.BusinessEntityID,
       SP.SalesYTD,
       ST.TerritoryID AS 'Territory'
FROM Sales.SalesPerson SP 
LEFT JOIN Sales.SalesTerritory ST
ON ST.TerritoryID = SP.TerritoryID
INNER JOIN Person.Person P
ON P.BusinessEntityID = SP.BusinessEntityID
WHERE ST.Name IN (@nombre,@nombre1)

-- Creamos la misma consulta utilizando tablas temporales
DECLARE @nombre2 VARCHAR(50) = 'NORTHEAST'
DECLARE @nombre3 VARCHAR(50) = 'CENTRAL'

SELECT SP.BusinessEntityID AS 'ID',
       SP.SalesYTD,
       ST.Name AS 'Nombre'
INTO #Territory
FROM Sales.SalesPerson SP 
LEFT JOIN Sales.SalesTerritory ST
ON ST.TerritoryID = SP.TerritoryID
WHERE ST.Name IN (@nombre2,@nombre3)

SELECT P.BusinessEntityID AS 'ID',
       CONCAT(P.FirstName,' ',P.MiddleName,'',P.LastName) AS 'Nombre y Apellido'
INTO #Person3
FROM Person.Person P

SELECT P.[Nombre y Apellido],
       T.ID,
       T.SalesYTD,
       T.Nombre
FROM #Territory T
INNER JOIN #Person3 P
ON P.ID = T.ID