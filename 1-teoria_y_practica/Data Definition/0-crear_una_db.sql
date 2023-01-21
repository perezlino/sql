-- ======================================================
-- ============== CREAR UNA BASE DE DATOS ===============
-- ======================================================

/* La sentencia CREATE DATABASE crea una nueva base de datos. A continuación se muestra 
   la sintaxis mínima de la sentencia CREATE DATABASE:

                            CREATE DATABASE database_name

   En esta sintaxis, se especifica el nombre de la base de datos después de la palabra 
   clave CREATE DATABASE.

   El nombre de la base de datos debe ser único dentro de una instancia de SQL Server. 
   También debe cumplir las reglas del identificador de SQL Server. Normalmente, el nombre 
   de la base de datos tiene un máximo de 128 caracteres.

   La siguiente sentencia crea una nueva base de datos llamada TestDb:   */

   CREATE DATABASE TestDb


-- Esta sentencia enumera todas las bases de datos del servidor SQL
-- ================================================================

SELECT 
    name
FROM 
    master.sys.databases
ORDER BY 
    name

-- O puede ejecutar el stored procedure sp_databases
-- =================================================

EXEC sp_databases