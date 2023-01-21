-- ======================================================
-- ===================== BETWEEN ========================
-- ======================================================

/* El operador BETWEEN es un operador lógico que permite especificar un intervalo a 
   comprobar.

   A continuación se ilustra la sintaxis del operador BETWEEN:

            column | expression BETWEEN start_expression AND end_expression
   

   En esta sintaxis:

   - En primer lugar, especifique la columna o expresión que desea comprobar.

   - En segundo lugar, coloque la expresión_inicial y la expresión_final entre las palabras 
     clave BETWEEN y AND. La expresión_inicial, la expresión_final y la expresión a comprobar 
     deben tener el mismo tipo de datos.

   El operador BETWEEN devuelve TRUE si la expresión a comprobar es mayor o igual que el valor 
   de la expresión_inicial y menor o igual que el valor de la expresión_final.

   Puede utilizar mayor o igual que (>=) y menor o igual que (<=) para sustituir al operador 
   BETWEEN de la siguiente manera:

        column | expression <= end_expression AND column | expression >= start_expression  


   La condición que utiliza el operador BETWEEN es mucho más legible que la que utiliza los 
   operadores de comparación >=, <= y el operador lógico AND.

   Para negar el resultado del operador BETWEEN, se utiliza el operador NOT BETWEEN de la 
   siguiente manera: 

           column | expression NOT BETWEEN start_expression AND end_expresion


   NOT BETWEEN devuelve TRUE si el valor de la columna o expresión es menor que el valor de la 
   expresión_inicial y mayor que el valor de la expresión_final. Es equivalente a la siguiente 
   condición:

           column | expression < start_expression AND column | expression > end_expression
    
   
   Tenga en cuenta que si alguna de las entradas de BETWEEN o NOT BETWEEN es NULL, el resultado 
   será UNKNOWN.   */


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
    ListPrice,
    DaysToManufacture
FROM
    Production.Product
WHERE
    DaysToManufacture BETWEEN 2 AND 4
ORDER BY
    DaysToManufacture DESC

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 2

SELECT
    ProductID,
    Name,
    ProductNumber,
    Color,
    YEAR(SellStartDate) AS SellStart,
    ListPrice,
    DaysToManufacture
FROM
    Production.Product
WHERE
    DaysToManufacture NOT BETWEEN 2 AND 4
ORDER BY
    DaysToManufacture DESC

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 3

-- La fecha tiene el formato 'YYYYMMDD'

SELECT
    BusinessEntityID,
    JobTitle,
    BirthDate
FROM
    HumanResources.Employee
WHERE
    BirthDate BETWEEN '19690101' AND '19800101'
ORDER BY
    BirthDate DESC

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 4

-- La fecha tiene el formato 'YYYY-MM-DD'

SELECT
    BusinessEntityID,
    JobTitle,
    BirthDate
FROM
    HumanResources.Employee
WHERE
    BirthDate BETWEEN '1969-01-01' AND '1980-01-01'
ORDER BY
    BirthDate DESC