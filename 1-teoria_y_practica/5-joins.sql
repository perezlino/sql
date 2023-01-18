-- =====================================================
-- ======================= JOINS =======================
-- =====================================================

-- ==================
-- === INNER JOIN ===
-- ==================

-- Obtener los productos, subcategoria y categoria (295 filas)
SELECT p.ProductID 'ProductoID',p.Name 'Nombre',ps.Name 'Subcategoría',
       pc.Name 'Categoría'
FROM Production.Product p
INNER JOIN Production.ProductSubcategory ps
ON ps.ProductSubcategoryID = p.ProductSubcategoryID
INNER JOIN Production.ProductCategory pc
ON pc.ProductCategoryID = ps.ProductCategoryID

-- Mostrar a todos los empleados que se encuentran en el departamento de manufactura 
-- 'Manufacturing' y de aseguramiento de la calidad 'Quality Assurance'
SELECT e.BusinessEntityID, e.JobTitle, d.Name 'Departamento'
FROM HumanResources.Employee e 
INNER JOIN HumanResources.EmployeeDepartmentHistory h
ON e.BusinessEntityID = h.BusinessEntityID
INNER JOIN HumanResources.Department d
ON d.DepartmentID = h.DepartmentID
AND h.EndDate IS NULL -- Esto indica que sean trabajadores que AÚN pertenezcan a la empresa
and d.Name IN ('Quality Assurance', 'Production');

-- Empleados cuyo apellido comienze con la letra "S"
SELECT * 
FROM HumanResources.Employee e 
INNER JOIN Person.Person p 
ON e.BusinessEntityID = p.BusinessEntityID
AND p.LastName 
LIKE 'S%';

-- Los empleados que son del estado de Florida
SELECT e.BusinessEntityID, e.JobTitle, ps.Name 
FROM HumanResources.Employee e
INNER JOIN Person.Person pp
ON pp.BusinessEntityID = e.BusinessEntityID
INNER JOIN Person.BusinessEntityAddress pb
ON pb.BusinessEntityID = pp.BusinessEntityID
INNER JOIN Person.Address pa
ON pa.AddressID = pb.AddressID
INNER JOIN Person.StateProvince ps
ON ps.StateProvinceID = pa.StateProvinceID
AND ps.Name = 'New Jersey'

-- La suma de las ventas hechas por cada empleado, y agrupadas por año
SELECT pp.FirstName, sum(SalesQuota) AS total_vendido,
year(QuotaDate) AS año
FROM Sales.SalesPersonQuotaHistory qh
INNER JOIN Person.Person pp
ON qh.BusinessEntityID = pp.BusinessEntityID
GROUP BY pp.BusinessEntityID, year(QuotaDate), pp.FirstName
order by pp.BusinessEntityID;

-- La suma de las ventas hechas por cada empleado, y agrupadas por año
SELECT CONCAT(pp.FirstName,' ',pp.LastName) AS Nombre, SUM(SalesQuota) AS Total_vendido,
       YEAR(QuotaDate) AS Año
FROM Sales.SalesPersonQuotaHistory qh
INNER JOIN Person.Person pp
ON qh.BusinessEntityID = pp.BusinessEntityID
GROUP BY pp.BusinessEntityID, year(QuotaDate), CONCAT(pp.FirstName,' ',pp.LastName)
ORDER BY pp.BusinessEntityID

-- El producto que ha vendido más en cantidad
SELECT TOP 1 pp.ProductID, pp.Name, ss.ProductID, SUM(ss.OrderQty) AS Cantidad_vendida
FROM Production.Product pp
INNER JOIN Sales.SalesOrderDetail ss
ON pp.ProductID = ss.ProductID
GROUP BY ss.ProductID, pp.Name, pp.ProductID
ORDER BY SUM(ss.OrderQty) DESC

-- El producto que ha vendido menos en cantidad
SELECT TOP 1 pp.ProductID, pp.Name, ss.ProductID, SUM(ss.OrderQty) AS Cantidad_vendida
FROM Production.Product pp
INNER JOIN Sales.SalesOrderDetail ss
ON pp.ProductID = ss.ProductID
GROUP BY ss.ProductID, pp.Name, pp.ProductID
ORDER BY SUM(ss.OrderQty)

-- Listado de productos por n° de ventas (no por cantidad vendida, sino por cantidad de veces
-- vendido en distintas ordenes de venta) ordenando de mayor a menor
SELECT pp.ProductID, pp.Name,pp.ProductNumber, pp.ListPrice, COUNT(ss.ProductID) AS Veces_vendido
FROM Production.Product pp
INNER JOIN Sales.SalesOrderDetail ss
ON pp.ProductID = ss.ProductID
GROUP BY ss.ProductID, pp.Name, pp.ProductID,pp.ProductNumber, pp.ListPrice
ORDER BY COUNT(ss.ProductID) DESC

-- Las ventas por territorio
SELECT st.TerritoryID, st.Name, SUM(so.OrderQty * so.UnitPrice) AS Total_vendido
FROM Sales.SalesOrderHeader sh
INNER JOIN Sales.SalesOrderDetail so
ON sh.SalesOrderID = so.SalesOrderID
INNER JOIN Sales.SalesTerritory st
ON st.TerritoryID = sh.TerritoryID
GROUP BY st.TerritoryID, st.Name
ORDER BY SUM(so.OrderQty * so.UnitPrice) DESC

--Cantidad de ventas por posición (cargo)
SELECT e.JobTitle AS Posicion, COUNT(so.SalesOrderID) AS Cantidad_por_posicion
FROM HumanResources.Employee AS e
INNER JOIN Sales.SalesOrderHeader AS so
ON e.BusinessEntityID = so.SalesPersonID
GROUP BY e.JobTitle

--Cantidad de ventas por empleado
SELECT pp.FirstName + ' ' + pp.LastName AS Nombre, e.JobTitle AS Posicion,
       COUNT(so.SalesOrderID) AS Cantidad_por_empleado
FROM HumanResources.Employee AS e
INNER JOIN Sales.SalesOrderHeader AS so
ON e.BusinessEntityID = so.SalesPersonID
INNER JOIN Person.Person AS pp
ON so.SalesPersonID = pp.BusinessEntityID
GROUP BY pp.FirstName, pp.LastName, e.JobTitle

-- =================
-- === LEFT JOIN ===
-- =================

-- Obtener los productos, subcategoria y categoria (504 filas)
-- Me devolverá todos los productos, aunque estos no tengan un SubcategoryID asociado
SELECT p.ProductID 'ProductoID',p.Name 'Nombre',ps.Name 'Subcategoría',
       pc.Name 'Categoría'
FROM Production.Product p
LEFT JOIN Production.ProductSubcategory ps
ON ps.ProductSubcategoryID = p.ProductSubcategoryID
LEFT JOIN Production.ProductCategory pc
ON pc.ProductCategoryID = ps.ProductCategoryID

-- ==================
-- === RIGHT JOIN ===
-- ==================

-- Obtener los productos, subcategoria y categoria (295 filas)
-- Me devolverá todos los productos, aunque estos no tengan un SubcategoryID asociado
SELECT p.ProductID 'ProductoID',p.Name 'Nombre',ps.Name 'Subcategoría',
       pc.Name 'Categoría'
FROM Production.Product p
RIGHT JOIN Production.ProductSubcategory ps
ON ps.ProductSubcategoryID = p.ProductSubcategoryID
RIGHT JOIN Production.ProductCategory pc
ON pc.ProductCategoryID = ps.ProductCategoryID