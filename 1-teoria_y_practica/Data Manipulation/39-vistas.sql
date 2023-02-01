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

-- ===========================
-- === ENCRIPTAR UNA VISTA ===
-- ===========================

-- Al momento de crear una vista podemos encriptarla y no poder visualizarla luego por medio de las
-- distintas formas que se presentan en el punto "VISUALIZAR EN UNA CONSULTA COMO ESTA COMPUESTA 
-- UNA VISTA".

-- Para ello solo agregamos 'WITH ENCRYPTION' antes del AS:

CREATE VIEW VentasPosicion(posicion, cantidad_por_posicion)
WITH ENCRYPTION AS
SELECT e.JobTitle, COUNT(so.SalesOrderID)
FROM HumanResources.Employee AS e
INNER JOIN Sales.SalesOrderHeader AS so
ON e.BusinessEntityID = so.SalesPersonID
GROUP BY e.JobTitle


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

-- ===================================
-- === INSERTAR FILAS EN UNA VISTA ===
-- ===================================

-- Se puede insertar filas a una Vista, siempre y cuando los campos utilizados en la inserción
-- impliquen una sola tabla. Esta tabla también se verá actualizada con este nuevo registro.

-- Por ejemplo, tenemos la siguiente Vista:

USE EJERCICIOS

CREATE VIEW dbo.ViewByDepartment
AS
SELECT D.Department, T.EmployeeNumber, T.DateOfTransaction, T.Amount AS TotalAmount
FROM tblDepartment AS D
LEFT JOIN tblEmployee AS E
ON E.Department = D.Department
LEFT JOIN tblTransaction AS T
ON E.EmployeeNumber = T.EmployeeNumber
WHERE T.EmployeeNumber BETWEEN 120 AND 139

-- Revisemos la vista

SELECT * FROM dbo.ViewDepartment
ORDER BY EmployeeNumber

-- Realizamos la siguiente inserción en la Vista. Estamos utilizando los campos de la tabla 
-- "tblTransaction".

INSERT INTO ViewDepartment(EmployeeNumber, DateOfTransaction, TotalAmount)
VALUES(132,'2015-07-07',999.99)

-- La vista insertará esta nueva fila también en la tabla padre, la tabla "tblTransaction"

SELECT * FROM tblTransaction
WHERE EmployeeNumber IN (132,142)

-- Pero si intentamos hacer una inserción que apunte a DOS TABLAS se nos devolverá un ERROR

INSERT INTO ViewDepartment(Department, EmployeeNumber, DateOfTransaction, TotalAmount)
VALUES('Customer Relations', 132,'2015-07-07',999.99)
/* Msg 4405, Level 16, State 1, Line 1
View or function 'ViewDepartment' is not updatable because the modification affects multiple base tables. */


-- ============================================================================================
-- ============================================================================================

/* =========================
   === WITH CHECK OPTION ===
   =========================

   - Esto lleva relación con la inserción o modificación de registros en una Vista.

   -  La Vista se crea con cierta condicion y el WITH CHECK OPTION se encarga de que la vista siempre cumpla 
      esa condicion cuando se intente insertar o modificar registros.

   Una Vista de ejemplo para ejemplificar lo comentado:  */

   -- Recordar que si se inserta un nuevo registro en la vista y esta apunta a una sola tabla, este  
   -- registro también se insertará en la tabla padre.

CREATE VIEW vista_ejemplo
AS
SELECT * FROM usuarios 
WHERE edad > 22
WITH CHECK OPTION

   -- Luego consultamos la Vista:  

SELECT * FROM vista_ejemplo 
ORDER BY edad

/*se va registrar porque cumple la condición de la edad*/
INSERT INTO vista_ejemplo VALUES ('jose','jos34','vfg340','registrado',24,'M') 


   -- Volvemos a consultar la Vista:

SELECT * FROM vista_ejemplo 
ORDER BY edad

/*NO se va registrar porque NO cumple la condición de la edad*/
INSERT INTO vista_ejemplo VALUES ('pamela','pan123','as35ac','registrado',20,'F') 


   -- Ahora si intentase actualizar un registro de esta tabla, por ejemplo, si se intentas cambiar la edad de 
   -- un usuario de 25 años a 4 años, por ejemplo, te marca error, porque no cumple la condicion edad > 22.


-- ============================================================================================
-- ============================================================================================

-- ================================================================
-- === VISUALIZAR EN UNA CONSULTA COMO ESTA COMPUESTA UNA VISTA ===
-- ================================================================

--De esta manera podemos ver como esta creada la vista (SQL Server)

-- Primera forma
SELECT definition
FROM sys.sql_modules
WHERE object_id = OBJECT_ID('dbo.VentasPosicion')

-- Segunda forma
SELECT 
    OBJECT_DEFINITION(
        OBJECT_ID(
            'dbo.VentasPosicion'
        )
    ) view_info;

-- Tercera forma
SELECT V.name, S.text
FROM sys.syscomments S
INNER JOIN sys.views V
ON V.object_id = S.id
WHERE V.name = 'VentasPosicion'


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


-- ============================================================================================
-- ============================================================================================

/* ====================
   === INDEXED VIEW ===
   ==================== 

   -- https://www.sqlservertutorial.net/sql-server-views/sql-server-indexed-view/


   -- No nos permite utilizar OUTER JOINS en la Vista. Pero si podemos utilizar INNER JOIN.


   Las vistas normales de SQL Server son las consultas guardadas que proporcionan algunas ventajas, como 
   la simplicidad de la consulta, la coherencia de la lógica empresarial y la seguridad. Sin embargo, no 
   mejoran el rendimiento de la consulta subyacente.

   A diferencia de las vistas normales, las vistas indexadas son vistas materializadas que almacenan datos 
   físicamente como una tabla, por lo que pueden proporcionar algunas ventajas de rendimiento si se utilizan 
   adecuadamente.

   Para crear una vista indexada, siga estos pasos:

   En primer lugar, cree una vista que utilice la opción WITH SCHEMABINDING, que vincula la vista al schema 
   de las tablas subyacentes.

   En segundo lugar, cree un unique clustered index en la vista. Esto materializa la vista.

   Debido a la opción WITH SCHEMABINDING, si desea cambiar la estructura de las tablas subyacentes que afectan 
   a la definición de la vista indexada, primero debe eliminar la vista indexada antes de aplicar los cambios.

   Además, SQL Server requiere que todas las referencias a objetos de una vista indexada incluyan la convención 
   de nomenclatura de dos partes es decir, schema.object, y que todos los objetos referenciados estén en la misma 
   base de datos.

   Cuando los datos de las tablas subyacentes cambian, los datos de la vista indexada también se actualizan 
   automáticamente. Esto provoca una sobrecarga de escritura para las tablas referenciadas. Esto significa que 
   cuando se escribe en la tabla subyacente, SQL Server también tiene que escribir en el índice de la vista. Por 
   lo tanto, sólo debe crear una vista indexada contra las tablas que tienen actualizaciones de datos poco 
   frecuentes.

   */

USE EJERCICIOS

CREATE VIEW dbo.ViewByDepartmentIndexed
WITH SCHEMABINDING AS  ---> Esta vista debe estar vinculada a un schema. Se debe utilizar esta linea.
SELECT D.Department, T.EmployeeNumber, T.DateOfTransaction, T.Amount AS TotalAmount
FROM dbo.tblDepartment AS D
INNER JOIN dbo.tblEmployee AS E
ON E.Department = D.Department
INNER JOIN dbo.tblTransaction AS T
ON E.EmployeeNumber = T.EmployeeNumber
WHERE T.EmployeeNumber BETWEEN 120 AND 139

CREATE UNIQUE CLUSTERED INDEX inx_ViewByDepartment ON dbo.ViewDepartment(EmployeeNumber)


/* Como se puede ver claramente en la salida, SQL Server tuvo que leer de tres tablas correspondientes antes de 
   devolver el conjunto de resultados, si utilizamos una vista normal. 

   Si añadimos un unique clustered index a la vista, esta sentencia materializa la vista, haciendo que tenga una 
   existencia física en la base de datos. Ahora, si consulta los datos de la vista, en lugar de leer los datos de 
   tres tablas, SQL Server leerá los datos directamente de la vista materializada. */