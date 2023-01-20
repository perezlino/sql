-- ======================================================
-- ===================== ORDER BY =======================
-- ======================================================

/*  NOTA: Las columnas de la cláusula ORDER BY no tienen por qué aparecer en la lista SELECT. 
          Sin embargo, las columnas ORDER BY deben aparecer en la lista SELECT si se especifica 
	      SELECT DISTINCT. Además, esta cláusula no puede hacer referencia a columnas de tablas que 
	      no aparezcan en la cláusula FROM.

    NOTA: Por lo general, puede ordenar por una columna que no esté en la lista SELECT, pero 
          para ello debe nombrar explícitamente la columna. Sin embargo, si se utiliza GROUP BY o 
	      DISTINCT en la consulta, no se puede ordenar por columnas que no estén en la lista SELECT.


    Cuando se utiliza la sentencia SELECT para consultar datos de una tabla, no se garantiza el orden de las 
    filas en el conjunto de resultados. Esto significa que SQL Server puede devolver un conjunto de resultados 
    con un orden de filas no especificado.

    La única forma de garantizar que las filas del conjunto de resultados estén ordenadas es utilizar la 
    cláusula ORDER BY. A continuación se ilustra la sintaxis de la cláusula ORDER BY:

                                        SELECT
                                            select_list
                                        FROM
                                            table_name
                                        ORDER BY 
                                            column_name | expression [ASC | DESC ]


    En esta sintaxis:

    column_name | expression
    ========================

    En primer lugar, especifique un nombre de columna o una expresión para ordenar el conjunto de resultados de 
    la consulta. Si especifica varias columnas, el conjunto de resultados se ordena por la primera columna y, a 
    continuación, ese conjunto de resultados ordenado se ordena por la segunda columna, y así sucesivamente.

    Las columnas que aparecen en la cláusula ORDER BY deben corresponder a cualquiera de las columnas de la lista 
    de selección o a las columnas definidas en la tabla especificada en la cláusula FROM.


    ASC | DESC
    ==========

    En segundo lugar, utilice ASC o DESC para especificar si los valores de la columna especificada deben ordenarse 
    de forma ascendente o descendente.

    El ASC ordena el resultado desde el valor más bajo al más alto, mientras que el DESC ordena el conjunto de 
    resultados desde el valor más alto al más bajo.

    Si no se especifica explícitamente ASC o DESC, SQL Server utiliza ASC como orden de clasificación predeterminado. 
    Además, SQL Server trata NULL como el valor más bajo.

    Al procesar la secuencia SELECT que tiene una cláusula ORDER BY, la cláusula ORDER BY es la última cláusula que 
    se procesa.

    ==============================================================================================================

    A) Ordenar un conjunto de resultados por una columna en orden ascendente

    La siguiente sentencia ordena la lista de personas por el nombre en orden ascendente:  */

SELECT
    FirstName,
    LastName
FROM
    Person.Person
ORDER BY
    FirstName

-- En este ejemplo, como no especificamos ASC ni DESC, la cláusula ORDER BY utilizó ASC por defecto.    

-- ==============================================================================================================

-- B) Ordenar un conjunto de resultados por una columna en orden descendente

-- La siguiente sentencia ordena la lista de personas por el nombre en orden descendente.

SELECT
    FirstName,
    LastName
FROM
    Person.Person
ORDER BY
    FirstName DESC

-- ==============================================================================================================

-- C) Ordenar un conjunto de resultados por varias columnas

-- La siguiente sentencia recupera el nombre, el apellido y el tipo de persona. Ordena la lista de personas 
-- primero por el tipo y luego por el nombre.

SELECT
    PersonType,
    FirstName,
    LastName
FROM
    Person.Person
ORDER BY
    PersonType,
    FirstName

-- ==============================================================================================================

-- D) Ordenar un conjunto de resultados por múltiples columnas y diferentes órdenes

-- La siguiente sentencia ordena las personas por el tipo en orden descendente y luego ordena el conjunto de 
-- resultados ordenado por el nombre en orden ascendente.

SELECT
    PersonType,
    FirstName,
    LastName
FROM
    Person.Person
ORDER BY
    PersonType DESC,
    FirstName ASC

-- ==============================================================================================================

-- E) Ordenar un conjunto de resultados por una columna que no aparece en la lista del SELECT

-- Es posible ordenar el conjunto de resultados por una columna que no aparece en la lista del SELECT. Por ejemplo, 
-- la siguiente sentencia ordena el cliente por el BusinessEntityID aunque la columna estado no aparezca en la 
-- lista del SELECT.

SELECT
    PersonType,
    FirstName,
    LastName
FROM
    Person.Person
ORDER BY
    BusinessEntityID

-- ==============================================================================================================

-- F) Ordenar un conjunto de resultados por una expresión

-- La función LEN() devuelve el número de caracteres de una cadena. La siguiente sentencia utiliza la función LEN() 
-- en la cláusula ORDER BY para recuperar una lista de personas ordenada por la longitud del primer nombre:

SELECT
    PersonType,
    FirstName,
    LastName
FROM
    Person.Person
ORDER BY
    LEN(FirstName) DESC

-- ==============================================================================================================

-- G) Ordenar por posiciones ordinales de columnas

-- SQL Server permite ordenar el conjunto de resultados en función de las posiciones ordinales de las columnas que 
-- aparecen en la lista del SELECT.

-- La siguiente sentencia ordena los clientes por nombre y apellidos. Pero en lugar de especificar los nombres de 
-- las columnas explícitamente, utiliza las posiciones ordinales de las columnas:

SELECT
    FirstName,
    LastName
FROM
    Person.Person
ORDER BY
    1,
    2

/* En este ejemplo, 1 significa la columna first_name, y 2 significa la columna last_name.

   Utilizar las posiciones ordinales de las columnas en la cláusula ORDER BY se considera una mala práctica de 
   programación por un par de razones:

 - Primero, las columnas en una tabla no tienen posiciones ordinales y necesitan ser referenciadas por nombre.

 - En segundo lugar, cuando se modifica la lista de SELECT, se puede olvidar hacer los cambios correspondientes 
   en la cláusula ORDER BY.

   Por lo tanto, es una buena práctica especificar siempre los nombres de las columnas explícitamente en la 
   cláusula ORDER BY.