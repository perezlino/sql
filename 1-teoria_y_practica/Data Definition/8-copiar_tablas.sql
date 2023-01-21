-- ======================================================
-- =================== COPIAR TABLAS ====================
-- ======================================================

/* ==========================
   === INSERT INTO SELECT ===
   ==========================

   Para insertar datos de otras tablas en una tabla, se utiliza la siguiente sentencia 
   INSERT INTO SELECT de SQL Server:

                            INSERT  [ TOP ( expression ) [ PERCENT ] ] 
                            INTO target_table (column_list)
                            query

   En esta sintaxis, la sentencia inserta las filas devueltas por la consulta en la target_table 
   (tabla_destino).

   La consulta es cualquier sentencia SELECT válida que recupere datos de otras tablas. Debe devolver 
   los valores correspondientes a las columnas especificadas en column_list.

   La parte de la cláusula TOP es opcional. Permite especificar el número de filas devueltas por la 
   consulta que se insertarán en la tabla de destino. Si utiliza la opción PERCENT, la sentencia insertará 
   el porcentaje de filas en su lugar. Tenga en cuenta que es una buena práctica utilizar siempre la 
   cláusula TOP con la cláusula ORDER BY.


   Ejemplos de SQL Server INSERT INTO SELECT
   =========================================

   Vamos a crear una tabla llamada "addresses" para la demostración:   */

CREATE TABLE Sales.Addresses (
    address_id INT IDENTITY PRIMARY KEY,
    street VARCHAR (255) NOT NULL,
    city VARCHAR (50),
    state VARCHAR (25),
    zip_code VARCHAR (5)
)

-- 1) Insertar todas las filas de otra tabla ejemplo
-- =================================================

-- La siguiente sentencia inserta todas las direcciones de la tabla Customers en la tabla Addresses:

INSERT INTO Sales.Addresses (street, city, state, zip_code) 
SELECT
    street,
    city,
    state,
    zip_code
FROM
    Sales.Customers
ORDER BY
    first_name,
    last_name


-- 2) Ejemplo de inserción de filas de otra tabla
-- ==============================================

-- A veces, basta con insertar algunas filas de otra tabla en una tabla. En este caso, se limita el número 
-- de filas devueltas por la consulta utilizando condiciones en la cláusula WHERE.

-- La siguiente sentencia añade las direcciones de las tiendas situadas en Santa Cruz y Baldwin a la tabla 
-- Addresses:

INSERT INTO 
    Sales.Addresses (street, city, state, zip_code) 
SELECT
    street,
    city,
    state,
    zip_code
FROM
    Sales.Stores
WHERE
    city IN ('Santa Cruz', 'Baldwin')


-- 3) Insertar las TOP N primeras filas
-- ====================================

-- En primer lugar, utilice la siguiente sentencia para eliminar todas las filas de la tabla Addresses:

TRUNCATE TABLE Sales.Addresses

-- En segundo lugar, para insertar los 10 primeros clientes ordenados por sus nombres y apellidos, se utiliza 
-- la sentencia INSERT TOP INTO SELECT de la siguiente forma:

INSERT TOP (10) 
INTO Sales.Addresses (street, city, state, zip_code) 
SELECT
    street,
    city,
    state,
    zip_code
FROM
    Sales.Customers
ORDER BY
    first_name,
    last_name


-- 4) Insertar el top percent de filas
-- ===================================

-- En lugar de utilizar un número absoluto de filas, puede insertar un número porcentual de filas en una tabla.
-- En primer lugar, trunque todas las filas de la tabla Addresses:

TRUNCATE TABLE Sales.Addresses

-- En segundo lugar, inserte el 10% de las filas de la tabla Customers ordenadas por nombres y apellidos en la 
-- tabla Addresses:

INSERT TOP (10) PERCENT  
INTO Sales.Addresses (street, city, state, zip_code) 
SELECT
    street,
    city,
    state,
    zip_code
FROM
    Sales.Customers
ORDER BY
    first_name,
    last_name


-- =============================================================================================================
-- =============================================================================================================

/* ========================
   === SELECT INTO FROM ===
   ========================

   Copiamos todos los registros de una tabla en otra tabla utilizando la siguiente sintáxis:

                            SELECT (column_list)
                            INTO target_table
                            FROM source_table

   No hace falta crear la nueva tabla previamente. Primero, se selecciona que columnas se quiere copiar, luego
   indicar el nombre de la nueva tabla, que como indiqué, no se necesita crear previamente, esta misma consulta
   creará la nueva tabla. Y finalmente, indicamos la tabla desde donde se copiarán las columnas.

   Crearemos una nueva tabla utilizando solo una columna de la tabla Sales.Customer, la columna CustomerID. Y 
   llamaremos a la nueva tabla "CustomerID":   */

SELECT CustomerID
INTO Sales.CustomerID
FROM Sales.Customer


-- Si queremos podemos copiar una tabla en una base de datos distinta de la que estamos ubicados.
-- Debemos anteponer la base de datos cuando indiquemos nuestra nueva tabla:

SELECT CustomerID
INTO NuevaBaseDeDatos.Sales.CustomerID
FROM Sales.Customer


-- De la misma manera si estamos copiando una tabla desde otra base de datos:

SELECT CustomerID
INTO Sales.CustomerID
FROM NuevaBaseDeDatos.Sales.Customer

-- =============================================================================================================
-- =============================================================================================================

/* ============================================
   === COPIAR SOLO ENCABEZADOS DE UNA TABLA ===
   ============================================

   Copiaremos solo los encabezados de todas las columnas de la tabla Sales.Customer en una nueva tabla. No es
   necesario crear la nueva tabla previamente.  */

SELECT *
INTO Sales.Customer_encabezados
FROM Sales.Customer
WHERE 1=0

-- Otra forma

SELECT TOP(0)
INTO Sales.Customer_encabezados
FROM Sales.Customer