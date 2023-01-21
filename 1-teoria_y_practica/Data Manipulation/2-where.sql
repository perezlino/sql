-- ======================================================
-- ======================= WHERE ========================
-- ======================================================

/* Cuando se utiliza la sentencia SELECT para consultar datos de una tabla, se obtienen 
   todas las filas de esa tabla, lo cual es innecesario porque la aplicación sólo puede 
   procesar un conjunto de filas en ese momento.

   Para obtener las filas de la tabla que cumplen una o varias condiciones, se utiliza la 
   cláusula WHERE de la siguiente manera:

                                    SELECT
                                        select_list
                                    FROM
                                        table_name
                                    WHERE
                                        search_condition

  En la cláusula WHERE se especifica una condición de búsqueda para filtrar las filas 
  devueltas por la cláusula FROM. La cláusula WHERE sólo devuelve las filas que hacen que 
  la condición de búsqueda se evalúe como TRUE.

  La condición de búsqueda es una expresión lógica o una combinación de varias expresiones 
  lógicas. En SQL, una expresión lógica suele denominarse predicado.

  Tenga en cuenta que SQL Server utiliza la lógica de predicado de tres valores, en la que 
  una expresión lógica puede evaluarse como TRUE, FALSE o UNKNOWN. La cláusula WHERE no 
  devolverá ninguna fila que haga que el predicado se evalúe como FALSE o UNKNOWN.  */

  USE AdventureWorks2019

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 1

SELECT
    ProductID,
    Name,
    ProductNumber,
    Color,
    YEAR(SellStartDate) AS SellStart
FROM
    Production.Product
WHERE
    ProductID = 1
ORDER BY
    ListPrice DESC

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 2

SELECT
    ProductID,
    Name,
    ProductNumber,
    Color,
    YEAR(SellStartDate) AS SellStart
FROM
    Production.Product
WHERE
    ProductID = 1 AND YEAR(SellStartDate) = 2013
ORDER BY
    ListPrice DESC

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 3

SELECT
    ProductID,
    Name,
    ProductNumber,
    Color,
    YEAR(SellStartDate) AS SellStart
FROM
    Production.Product
WHERE
    ListPrice > 1000 AND YEAR(SellStartDate) = 2013
ORDER BY
    ListPrice DESC

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 4

SELECT
    ProductID,
    Name,
    ProductNumber,
    Color,
    YEAR(SellStartDate) AS SellStart
FROM
    Production.Product
WHERE
    ListPrice > 1000 OR YEAR(SellStartDate) = 2013
ORDER BY
    ListPrice DESC

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 5

SELECT
    ProductID,
    Name,
    ProductNumber,
    Color,
    YEAR(SellStartDate) AS SellStart
FROM
    Production.Product
WHERE
    ListPrice BETWEEN 500 AND 1000 -- BETWEEN toma ambos extremos
ORDER BY
    ListPrice DESC

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 6

SELECT
    ProductID,
    Name,
    ProductNumber,
    Color,
    YEAR(SellStartDate) AS SellStart
FROM
    Production.Product
WHERE
    ListPrice IN (1349.60, 1457.99, 3578.27)
ORDER BY
    ListPrice DESC

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 7

SELECT
    ProductID,
    Name,
    ProductNumber,
    Color,
    YEAR(SellStartDate) AS SellStart
FROM
    Production.Product
WHERE
    Name LIKE '%Headset%'
ORDER BY
    ListPrice DESC

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 8

SELECT
    ProductID,
    Name,
    ProductNumber,
    Color,
    YEAR(SellStartDate) AS SellStart
FROM
    Production.Product
WHERE
    ListPrice * 0.5 > 1000
ORDER BY
    ListPrice DESC