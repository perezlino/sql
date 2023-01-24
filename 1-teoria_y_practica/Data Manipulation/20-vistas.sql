-- ======================================================
-- ======================= VISTAS =======================
-- ======================================================

-- Sitios para complementar información:
-- https://www.w3resource.com/sql/creating-views/creating-view.php


-- =======================
-- === CREAR UNA VISTA ===
-- =======================

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

-- ===========================
-- === MODIFICAR UNA VISTA ===
-- ===========================

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

/* ==========================
   === ELIMINAR UNA VISTA ===
   ==========================

   Para eliminar una vista de una base de datos, utilice la sentencia DROP VIEW como se indica 
   a continuación:

                           DROP VIEW [IF EXISTS] schema_name.view_name
    

   En esta sintaxis, se especifica el nombre de la vista que se desea eliminar después de las 
   palabras clave DROP VIEW. Si la vista pertenece a un schema, también debe especificar 
   explícitamente el nombre del schema al que pertenece la vista.

   Si intenta eliminar una vista que no existe, SQL Server emitirá un error. La cláusula IF EXISTS 
   evita que se produzca un error al eliminar una vista que no existe.

   Para eliminar varias vistas, utilice la siguiente sintaxis:

                                    DROP VIEW [IF EXISTS] 
                                        schema_name.view_name1, 
                                        schema_name.view_name2,
                                        ...;

   En esta sintaxis, las vistas están separadas por comas.

   Tenga en cuenta que cuando se elimina una vista, SQL Server elimina todos los permisos de la vista.


   Ejemplo de eliminación de una vista
   ===================================  */

DROP VIEW IF EXISTS dbo.VentasPosicion

-- ============================================================================================
-- ============================================================================================

-- ============================
-- === ACTUALIZAR UNA VISTA ===
-- ============================

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

-- ================================================================
-- === VISUALIZAR EN UNA CONSULTA COMO ESTA COMPUESTA UNA VISTA ===
-- ================================================================

--De esta manera podemos ver como esta creada la vista (SQL Server)

SELECT definition
FROM sys.sql_modules
WHERE object_id = OBJECT_ID('dbo.VentasPosicion')


SELECT 
    OBJECT_DEFINITION(
        OBJECT_ID(
            'sales.staff_sales'
        )
    ) view_info;


-- ============================================================================================
-- ============================================================================================

-- =================================================
-- === 'CREATE VIEW IF NOT EXISTS' EN SQL SERVER ===
-- =================================================

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

-- ============================================================================================
-- ============================================================================================

/* ===========================
   === RENOMBRAR UNA VISTA === 
   ===========================

   Si desea renombrar una vista mediante programación, puede utilizar el stored procedure "sp_rename": */

   EXEC sp_rename 
    @objname = 'dbo.VentasPosicion',
    @newname = 'SalesPosition'

/* En esta sentencia:

   - Primero, pasa el nombre de la vista que quieres renombrar usando el parámetro @objname y el nuevo 
     nombre de la vista usando el parámetro @newname. Tenga en cuenta que en @objectname debe especificar 
     el nombre del esquema de la vista. Sin embargo, en el parámetro @newname no debe hacerlo.

   - En segundo lugar, ejecute la sentencia.

-- ============================================================================================
-- ============================================================================================

/* =======================
   === LISTANDO VISTAS === 
   =======================

   Para listar todas las vistas de una base de datos SQL Server, se consulta la vista de catálogo 
   sys.views o sys.objects. He aquí un ejemplo:  

   Listamos el nombre del schema y la vista: */

SELECT 
	OBJECT_SCHEMA_NAME(v.object_id) schema_name,
	v.name
FROM 
	sys.views as v

/* En este ejemplo, utilizamos la función OBJECT_SCHEMA_NAME() para obtener los nombres de los schemas 
   de las vistas. La siguiente consulta devuelve una lista de vistas a través de la vista sys.objects: */

SELECT 
	OBJECT_SCHEMA_NAME(o.object_id) schema_name,
	o.name
FROM
	sys.objects as o
WHERE
	o.type = 'V'


/* Creación de un stored procedure para mostrar vistas en la Base de Datos SQL Server
   ==================================================================================

   El siguiente procedimiento almacenado envuelve la consulta anterior para listar todas las vistas en la 
   Base de Datos SQL Server basado en la entrada del nombre del schema y el nombre de la vista:  */

CREATE PROC usp_list_views(
	@schema_name AS VARCHAR(MAX)  = NULL,
	@view_name AS VARCHAR(MAX) = NULL
)
AS
SELECT 
	OBJECT_SCHEMA_NAME(v.object_id) schema_name,
	v.name view_name
FROM 
	sys.views as v
WHERE 
	(@schema_name IS NULL OR 
	OBJECT_SCHEMA_NAME(v.object_id) LIKE '%' + @schema_name + '%') AND
	(@view_name IS NULL OR
	v.name LIKE '%' + @view_name + '%');

/* Por ejemplo, si desea conocer las vistas que contienen la palabra "sales", puede llamar al 
   stored procedure "usp_list_views":  */

EXEC usp_list_views @view_name = 'sales'