-- ======================================================
-- ================== VARIABLES DE TABLA ================
-- ======================================================

/* Qué son las variables de tabla
   ==============================

Las variables de tabla son tipos de variables que permiten guardar filas de datos, similares a 
las tablas temporales.

================================================================================================
================================
Cómo declarar variables de tabla
================================

Para declarar una variable de tabla, se utiliza la sentencia DECLARE como se indica a continuación:

                            DECLARE @table_variable_name TABLE (
                                column_list
                            )

En esta sintaxis, se especifica el nombre de la variable de tabla entre las palabras clave DECLARE 
y TABLE. El nombre de las variables de tabla debe empezar por el símbolo @.

Después de la palabra clave TABLE, se define la estructura de la variable de tabla, que es similar a 
la estructura de una tabla normal que incluye definiciones de columna, tipo de datos, tamaño, 
restricción opcional, etc.

================================================================================================
====================================
El alcance de las variables de tabla
====================================

Al igual que las variables locales, las variables de tabla pierden su alcance al final del batch.

Si define una variable de tabla en un stored procedure o función definida por el usuario, la 
variable de tabla dejará de existir tras la salida del stored procedure o función definida por 
el usuario.

*/

-- Ejemplo de variable de tabla

-- Por ejemplo, la siguiente sentencia declara una variable de tabla denominada @product_table que 
-- consta de tres columnas: product_name, brand_id y list_price:

DECLARE @product_table TABLE (
    product_name VARCHAR(MAX) NOT NULL,
    brand_id INT NOT NULL,
    list_price DEC(11,2) NOT NULL
)

-- ================================================================================================
-- ============================================
-- Inserción de datos en las variables de tabla
-- ============================================

-- Una vez declarada, la variable de tabla está vacía. Puede insertar filas en las variables de tabla 
-- utilizando la sentencia INSERT:

INSERT INTO @product_table
SELECT
    product_name,
    brand_id,
    list_price
FROM
    production.products
WHERE
    category_id = 1

-- ================================================================================================
-- ==============================================
-- Consulta de datos de las variables de la tabla
-- ==============================================

-- De forma similar a una tabla temporal, puede consultar los datos de las variables de la tabla 
-- utilizando la sentencia SELECT:

SELECT *
FROM @product_table

-- Tenga en cuenta que debe ejecutar todo el batch o se producirá un error:

DECLARE @product_table TABLE (
    product_name VARCHAR(MAX) NOT NULL,
    brand_id INT NOT NULL,
    list_price DEC(11,2) NOT NULL
);

INSERT INTO @product_table
SELECT product_name,
       brand_id,
       list_price
FROM production.products
WHERE category_id = 1;

SELECT *
FROM @product_table

/* ================================================================================================
   =======================================
   Restricciones de las variables de tabla
   =======================================

En primer lugar, tienes que definir la estructura de la variable de tabla durante la declaración. A 
diferencia de una tabla normal o temporal, no se puede modificar la estructura de las variables de 
tabla una vez declaradas.

En segundo lugar, las estadísticas ayudan al optimizador de consultas a elaborar un buen plan de 
ejecución de la consulta. Por desgracia, las variables de tabla no contienen estadísticas. Por lo 
tanto, debe utilizar las variables de tabla para contener un número reducido de filas.

En tercer lugar, no puede utilizar la variable de tabla como parámetro de entrada o salida como otros 
tipos de datos. Sin embargo, puede devolver una variable de tabla desde una función definida por el 
usuario.

En cuarto lugar, no se pueden crear non-clustered indexes para variables de tabla. Sin embargo, a 
partir de SQL Server 2014, las variables de tabla optimizadas para memoria están disponibles con la 
introducción del nuevo OLTP en memoria que permite añadir non-clustered indexes como parte de la 
declaración de la variable de tabla.

En quinto lugar, si se utiliza una variable de tabla con un JOIN, es necesario asignar un alias a 
la tabla para ejecutar la consulta. Por ejemplo:  */

SELECT brand_name,
       product_name,
       list_price
FROM brands b
INNER JOIN @product_table pt 
ON p.brand_id = pt.brand_id

/* ================================================================================================
   =====================================
   Rendimiento de las variables de tabla
   =====================================

El uso de variables de tabla en un stored procedure produce menos recompilaciones que el uso de una 
tabla temporal.

Además, una variable de tabla utiliza menos recursos que una tabla temporal con menos sobrecarga de 
bloqueo y logging.

De forma similar a la tabla temporal, las variables de tabla viven en la base de datos tempdb, no en 
la memoria.

================================================================================================
===============================================================
Uso de variables de tabla en funciones definidas por el usuario
===============================================================

La siguiente función definida por el usuario llamada ufnSplit() que devuelve una variable de tabla.  */

CREATE OR ALTER FUNCTION udfSplit(
    @string VARCHAR(MAX), 
    @delimiter VARCHAR(50) = ' ')
RETURNS @parts TABLE
(    
idx INT IDENTITY PRIMARY KEY,
val VARCHAR(MAX)   
)
AS
BEGIN

DECLARE @index INT = -1;

WHILE (LEN(@string) > 0) 
BEGIN 
    SET @index = CHARINDEX(@delimiter , @string)
    
    IF (@index = 0) AND (LEN(@string) > 0)  
    BEGIN  
        INSERT INTO @parts 
        VALUES (@string)
        BREAK  
    END 

    IF (@index > 1)  
    BEGIN  
        INSERT INTO @parts 
        VALUES (LEFT(@string, @index - 1));

        SET @string = RIGHT(@string, (LEN(@string) - @index))  
    END 
    ELSE
    SET @string = RIGHT(@string, (LEN(@string) - @index))
    END
RETURN
END

-- La siguiente sentencia llama a la función udfSplit():

SELECT * 
FROM udfSplit('foo,bar,baz',',')

-- Esta es la salida:

-- |idx|val|
-- | 1 |foo|
-- | 2 |bar|
-- | 3 |baz| 