-- ======================================================
-- ======================= VISTAS =======================
-- ======================================================

-- Sitios para complementar información:
-- https://www.w3resource.com/sql/creating-views/creating-view.php


/* Crea una tabla virtual cuyo contenido (columnas y filas) está definido por una consulta. 
   Utilice esta sentencia para crear una vista de los datos de una o varias tablas de la base 
   de datos */

   -- Sintaxis  
  
    -- CREATE VIEW [ schema_name . ] view_name [  ( column_name [ ,...n ] ) ]   
    -- AS <select_statement>   
    -- [;]  
  
    -- <select_statement> ::=  
    --     [ WITH <common_table_expression> [ ,...n ] ]  
    --     SELECT <select_criteria>

-- Creación de vistas utilizando 'CREATE VIEW'

CREATE VIEW VentasPosicion(posicion, cantidad_por_posicion)
AS
SELECT e.JobTitle, COUNT(so.SalesOrderID)
FROM HumanResources.Employee AS e
INNER JOIN Sales.SalesOrderHeader AS so
ON e.BusinessEntityID = so.SalesPersonID
GROUP BY e.JobTitle


CREATE VIEW VentasEmpleados(nombre, posicion, cantidad_por_empleado)
AS
SELECT pp.FirstName + ' ' + pp.LastName, e.JobTitle, COUNT(so.SalesOrderID) 
FROM HumanResources.Employee AS e
INNER JOIN Sales.SalesOrderHeader AS so
ON e.BusinessEntityID = so.SalesPersonID
INNER JOIN Person.Person AS pp
ON so.SalesPersonID = pp.BusinessEntityID
GROUP BY pp.FirstName, pp.LastName, e.JobTitle


SELECT * FROM VentasPosicion vp
INNER JOIN VentasEmpleados ve
ON vp.Posicion = ve.Posicion

-- ============================================================================================
-- ============================================================================================

-- Modificar una Vista, donde le agregamos una columna más. Utilizamos 'ALTER VIEW'.

ALTER VIEW VentasPosicion
AS
SELECT e.BusinessEntityID, e.JobTitle AS Posicion, 
       COUNT(so.SalesOrderID) AS Cantidad_por_posicion
FROM HumanResources.Employee AS e
INNER JOIN Sales.SalesOrderHeader AS so
ON e.BusinessEntityID = so.SalesPersonID
GROUP BY e.BusinessEntityID, e.JobTitle

-- ============================================================================================
-- ============================================================================================

--Eliminar una Vista

DROP VIEW VentasPosicion

-- ============================================================================================
-- ============================================================================================

--Actualizar una Vista

-- 1. La vista se define en base a una y solo una tabla.
-- 2. La vista debe incluir la PRIMARY KEY de la tabla en base a la cual se ha creado la vista.
-- 3. La vista no debe tener ningún campo hecho de funciones agregadas.
-- 4. La vista no debe tener ninguna cláusula DISTINCT en su definición.
-- 5. La vista no debe tener ninguna cláusula GROUP BY o HAVING en su definición.
-- 6. La vista no debe tener ninguna SUBCONSULTA en sus definiciones.
-- 7. Si la vista que desea actualizar se basa en otra vista, la última debería ser actualizable.
-- 8. Cualquiera de los campos de salida seleccionados (de la vista) no debe utilizar constantes, 
--    cadenas o expresiones de valor.

-- Información complementaria:
-- https://www.w3resource.com/sql/update-views/sql-update-views.php

-- ============================================================================================
-- ============================================================================================

--De esta manera podemos ver como esta creada la vista (SQL Server)

SELECT definition
FROM sys.sql_modules
WHERE object_id = OBJECT_ID('dbo.VentasPosicion')

-- ============================================================================================
-- ============================================================================================

-- Esta es una forma similar de crear un 'CREATE VIEW IF NOT EXISTS' (SQL Server)

IF OBJECT_ID('dbo.VentasPosicion') IS NULL
BEGIN   
    EXECUTE(CREATE VIEW VentasPosicion(posicion, cantidad_por_posicion)
            AS
            SELECT e.JobTitle, COUNT(so.SalesOrderID)
            FROM HumanResources.Employee AS e
            INNER JOIN Sales.SalesOrderHeader AS so
            ON e.BusinessEntityID = so.SalesPersonID
            GROUP BY e.JobTitle)
END