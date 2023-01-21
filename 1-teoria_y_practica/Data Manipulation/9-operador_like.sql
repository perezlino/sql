-- ======================================================
-- ======================= LIKE =========================
-- ======================================================

/* El operador LIKE de SQL Server es un operador lógico que determina si una cadena de 
   caracteres coincide con un patrón especificado. Un patrón puede incluir caracteres 
   regulares y caracteres comodín. El operador LIKE se utiliza en la cláusula WHERE de 
   las sentencias SELECT, UPDATE y DELETE para filtrar filas basándose en la coincidencia 
   de patrones.

   A continuación se ilustra la sintaxis del operador LIKE de SQL Server:

                column | expression LIKE pattern [ESCAPE escape_character]


   Patrón
   ======

   El patrón es una secuencia de caracteres que se busca en la columna o expresión. Puede 
   incluir los siguientes caracteres comodín válidos:

   - El comodín de porcentaje (%): cualquier cadena de cero o más caracteres.
   - El carácter comodín de subrayado (_): cualquier carácter.
   - El comodín [lista de caracteres]: cualquier carácter dentro del conjunto especificado.
   - El [carácter-carácter]: cualquier carácter dentro del rango especificado.
   - El [^]: cualquier carácter individual que no esté dentro de una lista o un rango.

   Los caracteres comodín hacen que el operador LIKE sea más flexible que los operadores de 
   comparación de cadenas iguales (=) y no iguales (!=).


   Carácter de escape
   ==================

   El carácter de escape indica al operador LIKE que trate los caracteres comodín como caracteres 
   normales. El carácter de escape no tiene valor por defecto y debe evaluarse con un solo carácter.

   El operador LIKE devuelve TRUE si la columna o expresión coincide con el patrón especificado.

   Para negar el resultado del operador LIKE, utilice el operador NOT de la siguiente manera:

            column | expression NOT LIKE pattern [ESCAPE escape_character] */


USE AdventureWorks2019

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 1 : Ejemplos de comodines % (porcentaje)

-- El siguiente ejemplo busca los clientes cuyo apellido empieza por la letra z:

SELECT
    BusinessEntityID,
    FirstName,
    LastName,
    PersonType
FROM
    Person.Person
WHERE
    LastName LIKE 'Z%' -- Puedo escribir la letra en minúsculas también
ORDER BY
    FirstName

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 2 : Ejemplos de comodines % (porcentaje)

-- El siguiente ejemplo devuelve los clientes cuyo apellido termina con la cadena 'er':

SELECT
    BusinessEntityID,
    FirstName,
    LastName,
    PersonType
FROM
    Person.Person
WHERE
    LastName LIKE '%er' -- Puedo escribir la letra en minúsculas también
ORDER BY
    FirstName

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 3 : Ejemplos de comodines % (porcentaje)

-- La siguiente sentencia recupera los clientes cuyo apellido empieza por la letra t y acaba por 
-- la letra s:

SELECT
    BusinessEntityID,
    FirstName,
    LastName,
    PersonType
FROM
    Person.Person
WHERE
    LastName LIKE 't%s' -- Puedo escribir la letra en minúsculas también
ORDER BY
    FirstName

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 4 : Ejemplos de comodines % (porcentaje)

-- La siguiente sentencia recupera los clientes cuyo apellido tenga una "o" y una "d" 

SELECT
    BusinessEntityID,
    FirstName,
    LastName,
    PersonType
FROM
    Person.Person
WHERE
    LastName LIKE '%o%' AND LastName LIKE '%d%' -- Puedo escribir la letra en minúsculas también
ORDER BY
    FirstName

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 5 : Ejemplo de comodín _ (guión bajo)

-- El guión bajo representa un único carácter. Por ejemplo, la siguiente sentencia devuelve los 
-- clientes en los que el segundo carácter del apellido es la letra u:

SELECT
    BusinessEntityID,
    FirstName,
    LastName,
    PersonType
FROM
    Person.Person
WHERE
    LastName LIKE '_u%'
ORDER BY
    FirstName

-- El patrón _u%

-- El primer carácter de subrayado ( _) coincide con cualquier carácter simple.
-- La segunda letra u coincide exactamente con la letra u
-- El tercer carácter % coincide con cualquier secuencia de caracteres

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 6 : Ejemplo de comodín _ (guión bajo)

-- Personas con un nombre de 4 digitos y que terminen en "ean"

SELECT
    BusinessEntityID,
    FirstName,
    LastName,
    PersonType
FROM
    Person.Person
WHERE
    FirstName LIKE '_ean'
ORDER BY
    BusinessEntityID

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 7 : Ejemplo de comodín _ (guión bajo)

-- Personas con un nombre de 4 caracteres y que luego del espacio contengan otros caracteres

SELECT
    BusinessEntityID,
    FirstName,
    LastName,
    PersonType
FROM
    Person.Person
WHERE
    FirstName LIKE '____ %'
ORDER BY
    BusinessEntityID

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 8 : Ejemplo de comodín [lista de caracteres].

-- Los corchetes con una lista de caracteres, por ejemplo [ABC], representan un único carácter 
-- que debe ser uno de los caracteres especificados en la lista.

-- Por ejemplo, la siguiente consulta devuelve los clientes en los que el primer carácter del 
-- apellido es Y o Z:

SELECT
    BusinessEntityID,
    FirstName,
    LastName,
    PersonType
FROM
    Person.Person
WHERE
    LastName LIKE '[YZ]%'
ORDER BY
    FirstName

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 9 : El ejemplo del comodín [caracter-caracter].

-- Los corchetes con un rango de caracteres, por ejemplo [A-C], representan un único caracter que 
-- debe estar dentro de un rango especificado.

-- Por ejemplo, la siguiente consulta busca los clientes en los que el primer caracter del apellido 
-- es la letra del rango de la A a la C:

SELECT
    BusinessEntityID,
    FirstName,
    LastName,
    PersonType
FROM
    Person.Person
WHERE
    LastName LIKE '[A-C]%'
ORDER BY
    FirstName

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 10 : El ejemplo del comodín [caracter-caracter].

-- Personas con un nombre de 4 caracteres que comiencen con letras en el rango C y P y terminen 
-- en "evin"

SELECT
    BusinessEntityID,
    FirstName,
    LastName,
    PersonType
FROM
    Person.Person
WHERE
    FirstName LIKE '[C-P]evin'
ORDER BY
    BusinessEntityID

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 10 : Ejemplo de comodín [^Lista o rango de caracteres].

-- El carácter ^ especifica la negación de un rango o una lista de caracteres. Este carácter 
-- sólo tiene este significado dentro de un par de corchetes

-- Los corchetes con un signo de intercalación (^) seguidos de un rango, por ejemplo, [^A-C] o una 
-- lista de caracteres, por ejemplo, [ABC], representan un único carácter que no se encuentra en el 
-- rango o la lista de caracteres especificados.

-- Por ejemplo, la siguiente consulta devuelve los clientes en los que el primer carácter del apellido 
-- no es una letra del rango de la A a la X:

SELECT
    BusinessEntityID,
    FirstName,
    LastName,
    PersonType
FROM
    Person.Person
WHERE
    LastName LIKE '[^A-X]%'
ORDER BY
    BusinessEntityID

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 11 : Ejemplo de comodín [^Lista o rango de caracteres].

SELECT
    BusinessEntityID,
    FirstName,
    LastName,
    PersonType
FROM
    Person.Person
WHERE
    LastName LIKE '[^AB]%'
ORDER BY
    LastName

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 12 : Ejemplo del operador NOT LIKE

-- El siguiente ejemplo utiliza el operador NOT LIKE para buscar clientes cuyo primer carácter del 
-- nombre no sea la letra A:

SELECT
    BusinessEntityID,
    FirstName,
    LastName,
    PersonType
FROM
    Person.Person
WHERE
    LastName NOT LIKE 'A%'
ORDER BY
    FirstName