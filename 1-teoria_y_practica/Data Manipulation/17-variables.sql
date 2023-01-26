-- ======================================================
-- ================== VARIABLES LOCALES =================
-- ======================================================

/*
|------------------------------------------------------------------------------------------------|
|  Todas las variables locales de un batch deben definirse mediante la sentencia DECLARE. (Para  |
|  la definición de cada variable contiene su nombre y el tipo de datos correspondiente. Las     |
|  variables se referencian siempre en un batch utilizando el prefijo @. La asignación de un     |
|  valor a una variable local se realiza:                                                        |
|                                                                                                |
| - Utilizando la forma especial de la sentencia SELECT                                          |
| - Utilizando la sentencia SET                                                                  |
| - Directamente en la sentencia DECLARE utilizando el signo = (por ejemplo,                     |
|   @extra_budget MONEY = 1500)                                                                  |
|------------------------------------------------------------------------------------------------|

Qué es una variable
===================

Una variable es un objeto que contiene un único valor de un tipo específico, por ejemplo, un número
entero, una fecha o una cadena de caracteres variable.

Normalmente utilizamos variables en los siguientes casos:

- Como contador de bucle para contar el número de veces que se realiza un bucle.
- Para mantener un valor que será probado por una sentencia de control de flujo como WHILE.
- Para almacenar el valor devuelto por un stored procedure o una función.

*/

-- ================================================================================================
-- =====================
-- Declarar una variable
-- =====================

-- Para declarar una variable, se utiliza la sentencia DECLARE. Por ejemplo, la siguiente sentencia 
-- declara una variable llamada @model_year:

DECLARE @model_year SMALLINT

-- La sentencia DECLARE inicializa una variable asignándole un nombre y un tipo de datos. El nombre de la 
-- variable debe comenzar con el signo @. En este ejemplo, el tipo de datos de la variable @model_year es 
-- SMALLINT.

-- Por defecto, cuando se declara una variable, su valor es NULL.

-- Entre el nombre de la variable y el tipo de datos, puede utilizar la palabra clave opcional AS como se 
-- indica a continuación:

DECLARE @model_year AS SMALLINT

-- Para declarar varias variables, sepárelas mediante comas:

DECLARE @model_year SMALLINT, 
        @product_name VARCHAR(MAX)

-- ================================================================================================
-- ===============================
-- Asignar un valor a una variable
-- ===============================

-- Para asignar un valor a una variable, utilice la sentencia SET. Por ejemplo, la siguiente sentencia 
-- asigna 2018 a la variable @model_year:

SET @model_year = 2018

-- ================================================================================================
-- ================================
-- Uso de variables en una consulta
-- ================================

-- La siguiente sentencia SELECT utiliza la variable @model_year en la cláusula WHERE para encontrar 
-- los productos de un año de modelo específico:

SELECT
    product_name,
    model_year,
    list_price 
FROM 
    production.products
WHERE 
    model_year = @model_year
ORDER BY
    product_name

-- Ahora, puedes juntar todo y ejecutar el siguiente bloque de código para obtener una lista de 
-- productos cuyo año modelo es 2018:

DECLARE @model_year SMALLINT

SET @model_year = 2018;

SELECT
    product_name,
    model_year,
    list_price 
FROM 
    production.products
WHERE 
    model_year = @model_year
ORDER BY
    product_name

-- ================================================================================================
-- ======================================================
-- Almacenar el resultado de una consulta en una variable
-- ======================================================

-- Los siguientes pasos describen cómo almacenar el resultado de la consulta en una variable.

-- En primer lugar, declare una variable llamada @product_count con el tipo de datos integer:

DECLARE @product_count INT

-- En segundo lugar, utilice la sentencia SET para asignar el conjunto de resultados de la 
-- consulta a la variable:

SET @product_count = (
    SELECT 
        COUNT(*) 
    FROM 
        production.products 
)

-- En tercer lugar, muestra el contenido de la variable @product_count:

SELECT @product_count

-- También puede utilizar la sentencia PRINT para imprimir el contenido de una variable:

PRINT @product_count

-- o

PRINT 'The number of products is ' + CAST(@product_count AS VARCHAR(MAX))

-- Para ocultar el número de filas afectadas por los mensajes, utilice la siguiente sentencia:

SET NOCOUNT ON

-- ================================================================================================
-- =====================================
-- Selección de un registro en variables
-- =====================================

-- Los siguientes pasos ilustran cómo declarar dos variables, asignarles un registro y mostrar el 
-- contenido de las variables:

-- Primero, declare variables que contengan el nombre del producto y el precio de lista:

DECLARE @producto_nombre VARCHAR(MAX),
        @precio_catalogo DECIMAL(10,2)

-- En segundo lugar, asigne los nombres de las columnas a las variables correspondientes:

SELECT @producto_nombre = producto_nombre,
       @precio_catalogo = precio_catalogo
FROM
    Produccion.productos

-- En tercer lugar, emite el contenido de las variables:

SELECT @producto_nombre AS product_name, 
       @precio_catalogo AS list_price

-- Este es el resultado que obtenemos:

-- |-------------------------------------|-------------------|
-- |             producto_nombre         |  precio_catalogo  | 
-- |-------------------------------------|-------------------|
-- | Trek Checkpoint ALR Frameset - 2019 | 	    3199.99      |
-- |-------------------------------------|-------------------|

-- Pero porque devolvió ese registro y no otro? Porque si le asignamos a variables, columnas de 
-- una tabla SIEMPRE nos devolverá el ÚLTIMO registro, a menos, que la consulta nos devuelva un
-- único registro, en ese caso, devovlerá ese registro. A continuación veamos los registros de la
-- tabla "Produccion.productos": */

SELECT producto_id,
       producto_nombre,
       precio_catalogo
FROM
    Produccion.productos

-- Este es el resultado que obtenemos:

-- |-------------|-------------------------------------|-------------------|
-- | producto_id |             producto_nombre         |  precio_catalogo  | 
-- |-------------|-------------------------------------|-------------------|
-- |      1	     |           Trek 820 - 2016	       |       379.99      |
-- |      2	     |  Ritchey Timberwolf Frameset - 2016 |       749.99      |
-- |      3	     |   Surly Wednesday Frameset - 2016   |	   999.99      |
-- |      4	     |      Trek Fuel EX 8 29 - 2016	   |      2899.99      |
-- |      5	     |    Heller Shagamaw Frame - 2016     |	  1320.99      |
-- |    .....    |          .....................      |     .........     |
-- |    .....    |          .....................      |     .........     |
-- |     321     | Trek Checkpoint ALR Frameset - 2019 |	   3199.99     | <------------- ÚLTIMO REGISTRO
-- |-------------|-------------------------------------|-------------------|


-- Ejemplo 2:  */

DECLARE @producto_nombre VARCHAR(MAX),
        @precio_catalogo DECIMAL(10,2)


SELECT @producto_nombre = producto_nombre,
       @precio_catalogo = precio_catalogo
FROM
    Produccion.productos

WHERE
    precio_catalogo > 7000

-- En tercer lugar, emite el contenido de las variables:

SELECT @producto_nombre AS product_name, 
       @precio_catalogo AS list_price

-- Este es el resultado que obtenemos:

-- |-------------------------------------|-------------------|
-- |             producto_nombre         |  precio_catalogo  | 
-- |-------------------------------------|-------------------|
-- |     Trek Domane SLR 9 Disc - 2018   |   	11999.99     |
-- |-------------------------------------|-------------------|

-- Ahora si visualizamos la consulta:

SELECT producto_id,
       producto_nombre,
       precio_catalogo
FROM
    Produccion.productos
WHERE   
    precio_catalogo > 7000

-- |-------------|---------------------------------------|-------------------|
-- | producto_id |             producto_nombre           |  precio_catalogo  | 
-- |-------------|---------------------------------------|-------------------|
-- |     149	 |     Trek Domane SLR 8 Disc - 2018	 |      7499.99      |
-- |     155     |     Trek Domane SLR 9 Disc - 2018	 |      11999.99     |  <------------- ÚLTIMO REGISTRO
-- |-------------|---------------------------------------|-------------------|


-- ================================================================================================
-- ================================
-- Acumular valores en una variable
-- ================================

-- El siguiente stored procedure toma un parámetro y devuelve una lista de productos en forma de cadena:

CREATE PROC uspGetProductList(@model_year SMALLINT)
AS 
BEGIN
    DECLARE @product_list VARCHAR(MAX)
    SET @product_list = ''

    SELECT @product_list = @product_list + product_name  + CHAR(10)
    FROM production.products
    WHERE model_year = @model_year
    ORDER BY product_name

    PRINT @product_list
END

/* En este stored procedure:

- Primero, declaramos una variable llamada @product_list con tipo de cadena de caracteres variable (VARCHAR) 
  y establecemos su valor en blanco.

- Segundo, seleccionamos la lista de nombres de productos de la tabla products basándonos en la entrada 
  @model_year. En la lista de selección, acumulamos los nombres de los productos a la variable @product_list. 
  Observe que CHAR(10) devuelve el carácter de salto de línea.

- En tercer lugar, utilizamos la sentencia PRINT para imprimir la lista de productos.

La siguiente sentencia ejecuta el procedimiento almacenado uspGetProductList:  */

EXEC uspGetProductList 2018

-- ============================================================================================
-- ============================================================================================

USE AdventureWorks2019

--- Ejemplo 1

DECLARE @cantidad INT
SET @cantidad = (SELECT COUNT(*) 
                 FROM Person.Address)

SELECT @cantidad AS cantidad

-- ============================================================================================
-- ============================================================================================

--- Ejemplo 2

DECLARE @Cant INT = 5

SELECT @Cant AS cantidad

-- ============================================================================================
-- ============================================================================================

--- Ejemplo 3 ---

DECLARE @fecha DATE
SET @fecha = (SELECT GETDATE())

SELECT @fecha AS fecha_actual

-- ============================================================================================
-- ============================================================================================

--- Ejemplo 4

DECLARE @date DATE
SELECT @date = GETDATE()

SELECT @date AS fecha_actual

-- ============================================================================================
-- ============================================================================================