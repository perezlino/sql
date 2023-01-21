-- ======================================================
-- ========================= OR =========================
-- ======================================================

/* El operador OR de SQL Server es un operador lógico que permite combinar dos expresiones 
   booleanas. Devuelve TRUE cuando cualquiera de las condiciones se evalúa como TRUE.

   A continuación se muestra la sintaxis del operador OR:

                       boolean_expression OR boolean_expression    
   
   En esta sintaxis, la expresión_booleana es cualquier expresión booleana válida que se evalúe 
   como verdadero, falso y desconocido.

   La siguiente tabla muestra el resultado del operador OR cuando se combinan TRUE, FALSE y UNKNOWN:

   |---------------|---------------|---------------|---------------|
   |               |     TRUE      |     FALSE     |    UNKNOWN    |
   |---------------|---------------|---------------|---------------|
   |     TRUE      |     TRUE      |     TRUE      |     TRUE      |  
   |     FALSE     |     TRUE      |     FALSE     |    UNKNOWN    |
   |    UNKNOWN    |     TRUE      |    UNKNOWN    |    UNKNOWN    | 
   |---------------|---------------|---------------|---------------|  */

USE AdventureWorks2019

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 1

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
    ProductSubcategoryID = 4 
OR 
    ListPrice > 1000
ORDER BY
    ListPrice DESC

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 2

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
    ProductSubcategoryID = 4 
OR 
    ListPrice > 1000
OR
    Name LIKE '%Mountain%'
ORDER BY
    ListPrice DESC

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 3

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
    ProductSubcategoryID = 1 
OR 
    ProductSubcategoryID = 2 
OR
    ProductSubcategoryID = 3 
ORDER BY
    ListPrice DESC

-- Obtenemos el mismo resultado utilizando el operador IN:

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
    ProductSubcategoryID IN (1,2,3)
ORDER BY
    ListPrice DESC