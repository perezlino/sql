-- ============================================================
-- ======================= SUBCONSULTAS =======================
-- ============================================================

/*|-----------------------------------------------------------------------------------------|
  | La consulta interna se evaluará primero, y la consulta externa recibe los valores de la |
  | consulta interna.                                                                       |  
  |-----------------------------------------------------------------------------------------| */

/*|-----------------------------------------------------------------------------------------|
  | NOTA: Una consulta interna también puede estar anidada en una sentencia INSERT, UPDATE o| 
  | DELETE.                                      
  |-----------------------------------------------------------------------------------------| */

/*|-----------------------------------------------------------------------------------------|
  | NOTA ¡No utilice los operadores ANY y ALL! Toda consulta que utilice ANY o ALL puede    |
  |  formularse mejor con la función EXISTS                                                 |
  |-----------------------------------------------------------------------------------------| */

-- ==============================
-- === CONSULTA AUTOCONTENIDA ===
-- ==============================

-- La subconsulta autocontenida que se utiliza con el operador =. Se puede utilizar cualquier 
-- operador de comparación, siempre que la consulta interna devuelva exactamente una fila.

--Obtener los productos donde su categoria sea igual a 'Bikes' --
SELECT ProductID, Name, ProductNumber
FROM Production.Product
WHERE ProductSubcategoryID IN 
	(SELECT ProductSubcategoryID FROM [Production].[ProductSubcategory] WHERE ProductCategoryID =
        (SELECT ProductCategoryID FROM [Production].[ProductCategory] WHERE Name = 'Bikes'))

/* Obtenga los números de los empleados y las fechas de ingreso de todos los empleados con fechas 
   de ingreso iguales a la fecha más antigua */
SELECT e.BusinessEntityID, CONCAT(p.FirstName, ' ', p.LastName) AS 'Nombre', e.HireDate
FROM [HumanResources].[Employee] e
INNER JOIN [Person].[Person] p
ON p.BusinessEntityID = e.BusinessEntityID
WHERE HireDate =
	(SELECT MIN(HireDate) FROM [HumanResources].[Employee])

-- Se desea traer aquellos nombres de productos (Production.Product) en donde el campo "Name"
-- de la tabla (Production.ProductModel) sea "Long-sleeve logo jersey"
SELECT 
ProductID, Name 
FROM Production.Product
WHERE Product.ProductModelID = 
	(SELECT ProductModelID FROM Production.ProductModel 
	     WHERE ProductModel.Name = 'Long-sleeve Logo Jersey')

--Obtener los detalles completos de todos los empleados que viven en la ciudad 'London'
SELECT *
FROM [HumanResources].[Employee]  
WHERE BusinessEntityID IN 
	(SELECT BusinessEntityID FROM [Person].[BusinessEntityAddress] WHERE AddressID IN 
        (SELECT AddressID FROM [Person].[Address] WHERE City = 'London'))

-- Buscar los nombres de los empleados que han vendido el producto con el número 'BK-M68B-42'
SELECT DISTINCT pp.LastName, pp.FirstName 
FROM Person.Person pp 
INNER JOIN HumanResources.Employee e
ON e.BusinessEntityID = pp.BusinessEntityID 
WHERE pp.BusinessEntityID IN 
                            (SELECT SalesPersonID FROM Sales.SalesOrderHeader
                              WHERE SalesOrderID IN 
                                                    (SELECT SalesOrderID FROM Sales.SalesOrderDetail
                                                      WHERE ProductID IN 
                                                                        (SELECT ProductID FROM Production.Product 
                                                                          WHERE ProductNumber = 'BK-M68B-42')))


-- ===============================
-- === CONSULTA CORRELACIONADA ===
-- ===============================

-- Una subconsulta correlacionada es una consulta que depende de la consulta externa para obtener 
-- sus valores. Se ejecuta varias veces, una vez por cada fila que la consulta externa pueda 
-- seleccionar.

------------
-- EXISTS --
------------

-- A pesar de ser similar al predicado IN, el predicado EXISTS tiene un enfoque ligeramente diferente. 
-- Está dedicado únicamente a determinar si la subconsulta arroja alguna fila o no. Si ésta arroja una 
-- o más filas, el predicado se evalúa como verdadero; de otra manera, el predicado se evalúa como falso. 
-- El predicado consiste de la palabra clave EXISTS y una subconsulta. 

-- La función EXISTS toma una consulta interna como argumento y devuelve TRUE si la consulta interna 
-- devuelve una o más filas, y devuelve FALSE si devuelve cero filas.

SELECT DISTINCT Name
FROM Production.Product AS p 
WHERE EXISTS
    (SELECT *
     FROM Production.ProductModel AS pm 
     WHERE p.ProductModelID = pm.ProductModelID
           AND pm.Name LIKE 'Long-Sleeve Logo Jersey%')

-- Obtenemos lo mismo, pero ambas tienen distinto enfoque. En ambas ponemos como condición que tengan un 
-- mismo valor id en el campo 'ProductModelID' y además que el nombre del modelo comience con la cadena
-- 'Long-Sleeve Logo Jersey'

SELECT DISTINCT Name
FROM Production.Product AS p
WHERE ProductModelID IN
    (SELECT ProductModelID 
     FROM Production.ProductModel AS pm
     WHERE p.ProductModelID = pm.ProductModelID
        AND Name LIKE 'Long-Sleeve Logo Jersey%')

-- En el ejemplo siguiente se usa IN y se recupera una instancia del nombre y apellido de cada empleado cuya 
-- bonificación en la tabla SalesPerson sea de 5000.00 y cuyos números de identificación coincidan en las tablas 
-- Employee y SalesPerson.

SELECT DISTINCT p.LastName, p.FirstName 
FROM Person.Person AS p 
INNER JOIN HumanResources.Employee AS e
ON e.BusinessEntityID = p.BusinessEntityID 
WHERE 5000.00 IN
               (SELECT Bonus FROM Sales.SalesPerson AS sp
                  WHERE e.BusinessEntityID = sp.BusinessEntityID)

-- o podriamos trabajarlo con Subconsulta autocontenida. Obtenemos lo mismo. 

SELECT DISTINCT p.LastName, p.FirstName 
FROM Person.Person AS p 
INNER JOIN HumanResources.Employee AS e
ON e.BusinessEntityID = p.BusinessEntityID 
WHERE e.BusinessEntityID IN
               (SELECT BusinessEntityID FROM Sales.SalesPerson WHERE bonus = 5000.00)

-- Liste aquellos clientes que tengan al menos una orden realizada. Se utilizan las tablas Sales.Customer y 
-- Sales.SalesOrderHeader.
SELECT c.CustomerID
FROM Sales.Customer c
WHERE EXISTS 
            (SELECT CustomerID FROM Sales.SalesOrderHeader so
              WHERE so.CustomerID = c.CustomerID) 

-- Lista de clientes que no hayan realizado una orden de compra --
SELECT c.CustomerID
FROM Sales.Customer c
WHERE NOT EXISTS 
                (SELECT CustomerID FROM Sales.SalesOrderHeader so 
                  WHERE so.CustomerID = c.CustomerID)

-- Traemos la cantidad de trnasacciones por EmployeeNumber.
-- Este campo podriamos traerlo haciendo un INNER JOIN

USE EJERCICIOS

SELECT * FROM tblEmployee

SELECT EmployeeNumber, COUNT(1) 
FROM tblTransaction 
GROUP BY EmployeeNumber
ORDER BY EmployeeNumber

---------------------------------

-- Subconsulta

SELECT *, (SELECT COUNT(1) FROM tblTransaction T WHERE T.EmployeeNumber = E.EmployeeNumber) AS NumTransaction
FROM  tblEmployee AS E
ORDER BY EmployeeNumber

---------------------------------

-- Obtenemos el mismo resultado utilizando un INNER JOIN

SELECT E.*, COUNT(T.EmployeeNumber)
FROM tblEmployee E
INNER JOIN tblTransaction T
ON E.EmployeeNumber = T.EmployeeNumber
GROUP BY E.EmployeeNumber, E.EmployeeFirstName, E.EmployeeLastName,
         E.EmployeeMiddleName, E.EmployeeGovernmentID, E.DateOfBirth,
         E.Department