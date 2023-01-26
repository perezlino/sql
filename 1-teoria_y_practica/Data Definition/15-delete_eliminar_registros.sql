-- ======================================================
-- ================= ELIMINAR REGISTROS =================
-- ======================================================

/* Para eliminar completamente una o varias filas de una tabla, se utiliza la sentencia DELETE. 
   A continuación se ilustra su sintaxis:

                                DELETE [ TOP ( expression ) [ PERCENT ] ]  
                                FROM table_name
                                [WHERE search_condition]


   En primer lugar, especifique el nombre de la tabla de la que se van a eliminar las filas en la cláusula FROM.
 
   Por ejemplo, la siguiente sentencia borrará todas las filas de la tabla target_table: */

DELETE FROM target_table


-- En segundo lugar, para especificar el número o porcentaje de filas aleatorias que se eliminarán, se utiliza 
-- la cláusula TOP.

-- Por ejemplo, la siguiente sentencia DELETE elimina 10 filas aleatorias de la tabla target_table:

DELETE TOP 10 FROM target_table


-- Dado que la tabla almacena sus filas en un orden no especificado, no sabemos qué filas se eliminarán, pero 
-- sabemos con certeza que el número de filas que se eliminarán es 10.

-- Del mismo modo, puede eliminar el 10 por ciento de las filas aleatorias mediante la siguiente sentencia DELETE:

DELETE TOP 10 PERCENT FROM target_table


/* En tercer lugar, en la práctica, rara vez eliminará todas las filas de una tabla, sino sólo una o varias filas. 
   En este caso, debe especificar la condición_de_búsqueda (search_condition) en la cláusula WHERE para limitar 
   el número de filas que se eliminan.

   Se eliminarán las filas que hagan que la search_condition se evalúe como verdadera.

   La cláusula WHERE es opcional. Si la omite, la sentencia DELETE eliminará todas las filas de la tabla. */

-- ===============================================================================================================

   USE TiendaBicicletas  /*

   Ejemplos de sentencia DELETE de SQL Server
   ==========================================

   Vamos a crear una nueva tabla para la demostración.

   La siguiente sentencia crea una tabla llamada Produccion.producto_historia con los datos copiados de la tabla 
   Produccion.productos:  */

SELECT * 
INTO Produccion.producto_historia
FROM
    Produccion.productos

-- La siguiente consulta devuelve todas las filas de la tabla producto_historia:

SELECT * FROM Produccion.producto_historia

-- Como puede verse claramente en el resultado, tenemos 321 filas en total.

-- ===============================================================================================================

-- 1) Ejemplo de eliminación de un número de filas aleatorias 
-- ==========================================================

-- La siguiente sentencia DELETE elimina 21 filas aleatorias de la tabla producto_historia:

DELETE TOP (21)
FROM Produccion.producto_historia

-- Este es el mensaje emitido por el servidor SQL:

(21 rows affected)

-- Significa que se han eliminado 21 filas.

-- ===============================================================================================================

-- 2) Ejemplo de eliminación del porcentaje de filas aleatorias
-- ============================================================

-- La siguiente sentencia DELETE elimina el 5 por ciento de las filas aleatorias de la tabla producto_historia:

DELETE TOP (5) PERCENT
FROM Produccion.producto_historia

-- SQL Server emitió el siguiente mensaje indicando que se han eliminado 15 filas (300 x 5% = 15).

(15 rows affected)

-- ===============================================================================================================

-- 3) Ejemplo de eliminación de algunas filas con una condición 
-- ============================================================

-- La siguiente sentencia DELETE elimina todos los productos cuyo año de modelo es 2017:

DELETE 
FROM
    Produccion.producto_historia
WHERE
    ano_modelo = 2017

-- Este es el mensaje emitido por el servidor SQL:

(75 rows affected)

-- ===============================================================================================================

-- 4) Ejemplo de eliminación de todas las filas de una tabla
-- =========================================================

-- La siguiente sentencia DELETE elimina todas las filas de la tabla producto_historia:

DELETE FROM  Produccion.producto_historia

-- Tenga en cuenta que si desea eliminar todas las filas de una tabla grande, debe utilizar la sentencia 
-- TRUNCATE TABLE, que es más rápida y eficaz.


-- ===============================================================================================================
-- ===============================================================================================================

-- =====================
-- ==== DELETE JOIN ====
-- =====================

-- Eliminamos registros de acuerdo a datos que analizamos desde otras tablas. Esto lo podemos hacer con un JOIN.

USE EJERCICIOS

-- Utilizamos BEGIN TRAN y ROLLBACK TRAN para que el DELETE no se efectúe realmente. Si no, que solo se efectué
-- dentro de este batch.

-- En este ejemplo se eliminaran todos los registros de la tabla "tblTransaction" donde la columna "EmployeeMiddleName"
-- de la tabla "tblEmployee" sea NULO.

BEGIN TRAN
	DELETE tblTransaction  -----------> Debemos indicar junto al DELETE la tabla sobre la que se a generar el DELETE
	FROM tblTransaction AS T
	INNER JOIN tblEmployee AS E
	ON E.EmployeeNumber = T.EmployeeNumber
	WHERE E.EmployeeMiddleName IS NULL
	-- 1.565 ROWS
	SELECT * FROM tblTransaction AS T
	INNER JOIN tblEmployee AS E
	ON E.EmployeeNumber = T.EmployeeNumber
	GO
	-- 1.006 ROWS
	SELECT * FROM tblEmployee
	GO
	-- 1.819 ROWS
	SELECT * FROM tblTransaction
	GO
ROLLBACK TRAN

-- Podemos ver que dentro del batch, efectivamente eliminó registros solo para la tabla "tblTransaction"

-- Estas consultas nos muestran los registros de cada tabla sin haber realizado el DELETE.

	-- 2.247 ROWS
	SELECT * FROM tblTransaction AS T
	INNER JOIN tblEmployee AS E
	ON E.EmployeeNumber = T.EmployeeNumber

	-- 1.006 ROWS
	SELECT * FROM tblEmployee

	-- 2.501 ROWS
	SELECT * FROM tblTransaction