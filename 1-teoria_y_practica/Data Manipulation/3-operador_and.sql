-- ======================================================
-- ======================== AND =========================
-- ======================================================

/* AND es un operador lógico que permite combinar dos expresiones booleanas. Sólo 
   devuelve TRUE cuando ambas expresiones se evalúan como TRUE.

   A continuación se ilustra la sintaxis del operador AND:

                        boolean_expression AND boolean_expression   

   La expresión_booleana es cualquier expresión booleana válida que se evalúe como 
   TRUE, FALSE y UNKNOWN.

   La siguiente tabla muestra el resultado cuando se combinan los valores TRUE, FALSE 
   y UNKNOWN utilizando el operador AND:
   
   |---------------|---------------|---------------|---------------|
   |               |     TRUE      |     FALSE     |    UNKNOWN    |
   |---------------|---------------|---------------|---------------|
   |     TRUE      |     TRUE      |     FALSE     |    UNKNOWN    |  
   |     FALSE     |     FALSE     |     FALSE     |     FALSE     |
   |    UNKNOWN    |    UNKNOWN    |     FALSE     |    UNKNOWN    | 
   |---------------|---------------|---------------|---------------|  */

     USE AdventureWorks2019

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 1

SELECT
    ProductID,
    Name,
    ProductNumber,
    Color,
    YEAR(SellStartDate) AS SellStart,
    ListPrice
FROM
    Production.Product
WHERE
    ProductSubcategoryID = 4 
AND 
    ListPrice > 100
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
    YEAR(SellStartDate) AS SellStart,
    ListPrice
FROM
    Production.Product
WHERE
    ProductSubcategoryID = 4 
AND 
    ListPrice > 100 
AND 
    ProductModelID = 55
ORDER BY
    ListPrice DESC

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 3

-- En este ejemplo, hemos utilizado los operadores OR y AND en la condición. Como siempre, SQL Server 
-- evaluó primero el operador AND. Por lo tanto, la consulta recuperó los productos cuyo ProductModelID 
-- es 55 y el ListPrice es superior a 200 o aquellos cuyo ProductModelID es 54.

SELECT
    ProductID,
    Name,
    ProductNumber,
    Color,
    YEAR(SellStartDate) AS SellStart,
    ListPrice
FROM
    Production.Product
WHERE
    ProductModelID = 54
OR
    ProductModelID = 55
AND 
    ListPrice > 200    
ORDER BY
    ListPrice DESC

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 4

-- Para obtener el producto cuyo ProductModelID es 54 o 55 y el ListPrice es superior a 200, se 
-- utilizan los paréntesis de la siguiente manera:

SELECT
    ProductID,
    Name,
    ProductNumber,
    Color,
    YEAR(SellStartDate) AS SellStart,
    ListPrice
FROM
    Production.Product
WHERE
    (ProductModelID = 54 OR ProductModelID = 55)
AND 
    ListPrice > 200    
ORDER BY
    ListPrice DESC

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 5

-- Para obtener el producto cuyo ProductSubcategoryID es 4 y su nombre contiene la cadena 'Handlebars' 
-- o el ListPrice es superior a 2000 y su color es 'Black':

SELECT
    ProductID,
    Name,
    ProductSubcategoryID,
    Color,
    YEAR(SellStartDate) AS SellStart,
    ListPrice
FROM
    Production.Product
WHERE
    ProductSubcategoryID = 4 AND Name LIKE '%Handlebars%'
OR 
    ListPrice > 2000 AND Color = 'Black'
ORDER BY
    ListPrice DESC

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 5

-- Para obtener el producto cuyo ProductSubcategoryID es 4 y su nombre contiene la cadena 'Handlebars' 
-- o el ListPrice es superior a 2000 y su color es 'Black':

-- Se ejecuta 1ero el paréntesis más interno, luego el externo y luego el AND

SELECT
    ProductID,
    Name,
    ProductSubcategoryID,
    Color,
    YEAR(SellStartDate) AS SellStart,
    ListPrice
FROM
    Production.Product
WHERE
    ((ProductSubcategoryID = 4 AND Name LIKE '%Handlebars%')
    OR ListPrice > 2000) 
AND 
    Color = 'Black'
ORDER BY
    ListPrice DESC