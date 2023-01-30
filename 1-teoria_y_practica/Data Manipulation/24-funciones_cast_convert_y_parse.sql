-- ======================================================
-- =========== FUNCIONES CAMBIO TIPO DE DATO ============
-- ======================================================

-- ============
-- === CAST ===
-- ============

/* CAST: es una función genérica que lo que hace es convertirnos un tipo de dato en 
         otro siempre y cuando sea del mismo género, es decir, de un decimal a un número 
		 entero (numérico). Este cambio es solo a nivel de la operación NO a nivel real.                                                                  */

-- La columna UnitPrice en un inicio estaba configurada como MONEY
SELECT UnitPrice,
       CAST(UnitPrice AS INT) AS UnitPrice_int
FROM Purchasing.PurchaseOrderDetail

-- ============================================================================================

-- Convertimos dos textos y los sumamos
SELECT CAST('5' AS INT) + CAST('5' AS INT)

-- ============================================================================================

-- En estos ejemplos se recupera el nombre de aquellos productos que tienen un 33 como primeros 
-- dígitos del precio y se convierte sus valores ListPrice en INT (era del tipo MONEY).
SELECT SUBSTRING(Name, 1, 30) AS ProductName,
    ListPrice
FROM Production.Product
WHERE CAST(ListPrice AS INT) LIKE '33%'

-- ============================================================================================

DECLARE @fecha AS DATETIME = '2015-06-25 01:02:03.456'

SELECT CAST(@fecha AS NVARCHAR(20)) AS fecha
-- Jun 25 2015  1:02AM

-- ============================================================================================

-- Utilizando FORMAT y CAST

DECLARE @fecha AS VARCHAR(30) = '2015-06-25 01:02:03.456'

SELECT FORMAT(CAST(@fecha AS DATETIME), 'D') AS fecha
-- Thursday, June 25, 2015

SELECT FORMAT(CAST(@fecha AS DATETIME), 'd') AS fecha
-- 6/25/2015

SELECT FORMAT(CAST(@fecha AS DATETIME), 'dd-MM-yyyy') AS fecha
-- 25-06-2015

-- ============================================================================================

-- Uso de CAST para concatenar
SELECT 'El list price es ' + CAST(ListPrice AS VARCHAR(12)) AS ListPrice
FROM Production.Product
WHERE ListPrice BETWEEN 350.00 AND 400.00

-- ============================================================================================

-- En este ejemplo se usa CAST en la lista SELECT para convertir la columna 'Name' en una columna 
-- de tipo char(10). 
SELECT DISTINCT CAST(Name AS CHAR(11)) AS Name,
       ListPrice
FROM Production.Product
WHERE Name LIKE 'Long-Sleeve Logo Jersey, M'

-- ============================================================================================

-- En este ejemplo se convierten los valores SalesYTD que tienen el tipo de dato 'money' al tipo 
-- de datos 'int' y, después, al tipo de datos char(20), de modo que la cláusula LIKE pueda usarlo.
SELECT p.FirstName,
    p.LastName,
    s.SalesYTD,
    s.BusinessEntityID
FROM Person.Person AS p
INNER JOIN Sales.SalesPerson AS s
    ON p.BusinessEntityID = s.BusinessEntityID
WHERE CAST(s.SalesYTD AS INT) LIKE '2%'

-- ============================================================================================
-- ============================================================================================

-- ===============
-- === CONVERT ===
-- ===============

-- CONVERT(TipoDato,NombreColumna,Estilo)

-- Podemos utilizar un MIN y un MAX en el mismo SELECT. También podemos convertir formatos de 
-- fechas que vienen con la hora, a formato solo de fechas y en el orden que necesitemos.

SELECT CustomerID, 
       TerritoryID,
       CONVERT(VARCHAR(10),MIN(OrderDate),105) AS primera_compra,
       CONVERT(VARCHAR(10),MAX(OrderDate),23) AS ultima_compra
FROM Sales.SalesOrderHeader
GROUP BY TerritoryID,CustomerID
ORDER BY TerritoryID,CustomerID

-- ============================================================================================

-- Convierto un tipo de datos DATETIME (traen la fecha y la hora) a DATE (solo la fecha)
SELECT 
OrderDate,
CONVERT(DATE,OrderDate) AS Fecha
FROM Sales.SalesOrderHeader

-- ============================================================================================

-- Extraigo la hora, conviertiendo el dato DATETIME a TIME
SELECT 
OrderDate,
CONVERT(TIME,OrderDate) AS Hora
FROM Sales.SalesOrderHeader

-- ============================================================================================

/* Convertimos la fecha al formato latinoamericano) */
SELECT 
OrderDate,
CONVERT(VARCHAR(10),OrderDate,103) AS Fecha
FROM Sales.SalesOrderHeader

-- ============================================================================================

DECLARE @fecha AS DATETIME = '2015-06-25 01:02:03.456'

SELECT CONVERT(NVARCHAR(20), @fecha) AS fecha
-- Jun 25 2015  1:02AM

-- ============================================================================================

DECLARE @fecha AS NVARCHAR(20) = 'Thursday, 25 June 2015'

SELECT CONVERT(DATE, @fecha) AS fecha
-- (vacio)

-- ============================================================================================
-- ============================================================================================

/* =============
   === PARSE ===
   =============

   Devuelve el resultado de una expresión, traducido al tipo de datos solicitado en SQL Server.

   Sintáxis:
   ========

                    PARSE ( string_value AS data_type [ USING culture ] )
    

   Argumentos:
   ==========

   "string_value": Valor nvarchar(4000) que representa el valor con formato que se va a analizar 
                   en el tipo de datos especificado. "string_value" debe ser una representación 
                   válida del tipo de datos solicitado; de lo contrario, PARSE produce un error.

   "data_type": Valor literal que representa el tipo de datos solicitado para el resultado.

   "culture": Cadena opcional que identifica la referencia cultural en la que se da formato a 
              string_value.

    Si no se proporciona el argumento culture, se usará el idioma de la sesión actual.


    Comentarios:
    ===========

    Los valores NULL que se pasan como argumentos a PARSE se tratan de dos maneras:

    Si se pasa una constante NULL, se produce un error. Un valor NULL no se puede analizar en otro tipo 
    de datos diferente teniendo en cuenta la referencia cultural.

    Si se pasa un parámetro con un valor NULL en tiempo de ejecución, se devuelve un valor NULL para evitar 
    que se cancele todo el lote.

    Use PARSE solo para convertir de tipos de cadena a tipos de fecha y hora y de número. Para las 
    conversiones de tipos generales, siga usando CAST o CONVERT. Tenga en cuenta que hay cierta sobrecarga 
    de rendimiento al analizar el valor de cadena.

    Ejemplo:  */

    SELECT PARSE('Monday, 13 December 2010' AS datetime2 USING 'en-US') AS resultado
    -- 2010-12-13 00:00:00.0000000

    SELECT PARSE('Thursday, 25 June 2015' AS DATE) AS resultado
    -- 2015-06-25

    SELECT PARSE('Jueves, 25 de junio de 2015' AS DATE USING 'es-ES') AS resultado
    -- 2015-06-25

    SELECT PARSE('€345,98' AS money USING 'de-DE') AS resultado
    -- 345,98