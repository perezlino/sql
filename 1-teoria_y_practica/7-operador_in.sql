-- ======================================================
-- ======================== IN ==========================
-- ======================================================

/* El operador IN es un operador lógico que permite comprobar si un valor especificado 
   coincide con cualquier valor de una lista.

   A continuación se muestra la sintaxis del operador IN de SQL Server:

                        column | expression IN ( v1, v2, v3, ...)

   En esta sintaxis:

   - En primer lugar, especifique la columna o expresión que desea comprobar.

   - En segundo lugar, especifique una lista de valores a comprobar. Todos los valores deben 
     tener el mismo tipo que el de la columna o expresión.

   - Si un valor de la columna o de la expresión es igual a cualquier valor de la lista, el 
     resultado del operador IN es TRUE.

   El operador IN es equivalente a varios operadores OR, por lo que los siguientes predicados 
   son equivalentes:

                        column IN (v1, v2, v3)

                        column = v1 OR column = v2 OR column = v3


   Para negar el operador IN, se utiliza el operador NOT IN como se indica a continuación:

                        column | expression NOT IN ( v1, v2, v3, ...)


   El resultado del operador NOT IN es TRUE si la columna o expresión no es igual a ningún 
   valor de la lista.

   Además de una lista de valores, puede utilizar una subconsulta que devuelva una lista de valores 
   con el operador IN, como se muestra a continuación:

                        column | expression IN (subquery)
    
   En esta sintaxis, la subconsulta es una sentencia SELECT que devuelve una lista de valores de una 
   única columna. Tenga en cuenta que si una lista contiene NULL, el resultado de IN o NOT IN será UNKNOWN. */

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
    ProductSubcategoryID IN (1,2,3)
ORDER BY
    ListPrice DESC

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 2

-- Para encontrar los productos cuyos ProductSubcategoryID no corresponden a los indicados anteriormente, 
-- se utiliza el operador NOT IN como se muestra en la siguiente consulta:

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
    ProductSubcategoryID NOT IN (1,2,3)
ORDER BY
    ListPrice DESC

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 3

-- La podemos utilizar sobre una subconsulta, como se muestra en la siguiente consulta:

SELECT
    CustomerID,
    StoreID,
    TerritoryID
FROM
    Sales.Customer
WHERE
    PersonID IN (
        SELECT
            BusinessEntityID
        FROM
            Person.Person
        WHERE
            FirstName = 'Ken'
    )
ORDER BY
    CustomerID