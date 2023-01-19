-- ======================================================
-- ======================== NOT =========================
-- ======================================================

-- Negación

-- Ejemplo 1

-- Todos los productos que NO tengan la Subcategoria de producto 1, 2, 3 o 4.

SELECT
    ProductID,
    Name,
    ProductSubcategoryID,
    Color,
    YEAR(SellStartDate) AS SellStart,
    ListPrice
FROM
    Production.Product
WHERE NOT
    ProductSubcategoryID IN (1,2,3,4) 
ORDER BY
    ListPrice DESC