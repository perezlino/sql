-- ======================================================
-- ================= ALIAS PARA COLUMNAS=================
-- ======================================================

USE AdventureWorks2019

-- Dar un alias a un campo seleccionado
SELECT Name AS Nombre_Producto FROM Production.Product

--Requiere comillas dobles o corchetes si el nombre del alias contiene espacios
SELECT Name AS "Nombre Producto" FROM Production.Product
SELECT Name AS [Nombre Producto] FROM Production.Product

--Podemos generar un alias sin necesidad de utilizar el comando "AS"
SELECT Name Nombre_Producto FROM Production.Product
SELECT Name "Nombre Producto" FROM Production.Product
SELECT Name [Nombre Producto] FROM Production.Product

-- Podemos visualizar más de 1 vez un mismo campo
SELECT Name AS Nombre_Producto, Name AS NombreProducto, Name FROM Production.Product