-- ======================================================
-- ================= FUNCIONES DE TEXTO =================
-- ======================================================

-- =======================
-- === SUBSTRING y LEN ===
-- =======================

SELECT
SalesOrderID,
PurchaseOrderNumber,
LEN(PurchaseOrderNumber),
SUBSTRING(PurchaseOrderNumber,1,2),
SUBSTRING(PurchaseOrderNumber,3,LEN(PurchaseOrderNumber))
FROM Sales.SalesOrderHeader

-- ============================================================================================
-- ============================================================================================

-- ==============
-- === FORMAT ===
-- ==============

-- Nos trae el formato de fecha en TIPO TEXTO

SELECT OrderDate, FORMAT(OrderDate,'MM/yyyy') año_mes
FROM Sales.SalesOrderHeader

SELECT OrderDate, FORMAT(OrderDate,'dd-MM-yyyy') fecha_modificada
FROM Sales.SalesOrderHeader

SELECT OrderDate, FORMAT(OrderDate,'yyyy/MM') año_mes
FROM Sales.SalesOrderHeader

-- FORMAT con cadenas de formato personalizado

DECLARE @num INT = 123456789
SELECT FORMAT(@num,'###-##-####') AS 'Numero_personalizado'

-- FORMAT con tipos de datos de tiempo
-- FORMAT devuelve NULL en estos casos porque . y : no incluyen caracteres de escape.
SELECT FORMAT(CAST('07:35' AS TIME), N'hh.mm');   --> returns NULL  
SELECT FORMAT(CAST('07:35' AS TIME), N'hh:mm');   --> returns NULL

-- FORMAT devuelve una cadena con formato porque . y : incluyen caracteres de escape.
SELECT FORMAT(cast('07:35' AS TIME), N'hh\.mm');  --> returns 07.35  
SELECT FORMAT(cast('07:35' AS TIME), N'hh\:mm');  --> returns 07:35

-- FORMAT devuelve la hora actual con el formato AM o PM especificado.
SELECT FORMAT(SYSDATETIME(), N'hh:mm tt'); -- returns 03:46 PM
SELECT FORMAT(SYSDATETIME(), N'hh:mm t'); -- returns 03:46 P

-- FORMAT devuelve el tiempo especificado en formato AM.
select FORMAT(CAST('2018-01-01 01:00' AS datetime2), N'hh:mm tt') -- returns 01:00 AM
select FORMAT(CAST('2018-01-01 01:00' AS datetime2), N'hh:mm t')  -- returns 01:00 A

-- FORMAT devuelve el tiempo especificado en formato PM.
select FORMAT(CAST('2018-01-01 14:00' AS datetime2), N'hh:mm tt') -- returns 02:00 PM
select FORMAT(CAST('2018-01-01 14:00' AS datetime2), N'hh:mm t') -- returns 02:00 P

-- FORMAT devuelve el tiempo especificado en formato 24h.
select FORMAT(CAST('2018-01-01 14:00' AS datetime2), N'HH:mm') -- returns 14:00

-- ============================================================================================
-- ============================================================================================

-- ===========================
-- === TRIM, LTRIM y RTRIM ===
-- ===========================

/* TRIM: Elimina los espacios en blanco en ambos lados
   LTRIM: Elimina los espacios en blanco del lado izquierdo
   RTRIM: Elimina los espacios en blanco del lado derecho
*/
 
SELECT '     A     '
SELECT TRIM('     A     ')
SELECT LTRIM('     A     ')
SELECT RTRIM('     A     ')

-- ============================================================================================
-- ============================================================================================

-- ===============
-- === REPLACE ===
-- ===============

/* Reemplaza todas las incidencias de una expresión de tipo caracter por otra de igual tipo
   dentro de otra cadena. Es CaseSensitive.
*/

-- El siguiente ejemplo reemplaza la cadena "CD" de "ABCDEFG" por "55".
SELECT REPLACE('ABCDEFG','CD','55') -- AB55EFG

-- El siguiente ejemplo reemplaza la cadena "Dos" de "UnoDosTres" por 2.
SELECT REPLACE('UnoDosTres','Dos',2) -- Uno2Tres

-- El siguiente ejemplo reemplaza la cadena "Dos" de "UnoDosTres" por "2".
SELECT REPLACE('UnoDosTres','Dos','2')

-- El siguiente ejemplo reemplaza la cadena "cde" de "abcdefghicde" por "xxx".
SELECT REPLACE('abcdefghicde','cde','xxx')

-- ============================================================================================
-- ============================================================================================

-- =================
-- === TRANSLATE ===
-- =================

-- Reemplaza una serie de coincidencias a buscar dentro de un valor tipo cadena

SELECT TRANSLATE('Tag1(Tag2){Tag3}','(){}','[]**') -- Tag1[Tag2]*Tag3*

--Esta es la comparación entre REPLACE y TRANSLATE
SELECT TRANSLATE('UNO DOS TRES','OS','XW') -- UNX DXW TREW
SELECT REPLACE(REPLACE('UNO DOS TRES','O','X'),'S','W') -- UNX DXW TREW

--Ejemplo TRANSLATE y REPLACE
SELECT TRANSLATE('abcdef','abc','xxx') AS Translated,
       REPLACE(REPLACE(REPLACE('abcdef','a','b'),'b','c'),'c','d') AS Replaced

-- | Translate: xxxdef | Replace: ddddef |

--Ejemplo TRANSLATE
SELECT TRANSLATE('AB','ABC','XXX') -- XX

-- ============================================================================================
-- ============================================================================================

-- =================
-- === REPLICATE ===
-- =================

/* Repite una cadena de acuerdo a una cantidad dada. Recibe como parámetros un valor alfanumérico
   y la cantidad de veces que queremos duplicar
*/

SELECT REPLICATE('NO',5)

-- ============================================================================================
-- ============================================================================================

-- ===============
-- === REVERSE ===
-- ===============

-- Retorna el reverso de una cadena de caracteres

SELECT REVERSE('Texto al revés')

-- ============================================================================================
-- ============================================================================================

-- =============
-- === SPACE ===
-- =============

-- Retorna una cantidad n de espacios

SELECT 'A' + SPACE(10) + 'B'

-- ============================================================================================
-- ============================================================================================

-- =================
-- === CHARINDEX ===
-- =================

/* Esta función busca una expresión de caracteres dentro de una segunda expresión de caracteres, 
   y devuelve la posición inicial de la primera expresión si se encuentra.
*/

-- Ejemplo 1
DECLARE @document VARCHAR(64)

SELECT @document = 'Reflectors are vital safety ' +  
                   'components of your bicycle.'
				   
SELECT CHARINDEX('bicycle', @document) --48

-- Ejemplo 2
SELECT SUBSTRING('Alfonso Pérez', 1, CHARINDEX(' ', 'Alfonso Pérez') ) --Alfonso

--Ejemplo 3--
DECLARE @Nombre VARCHAR(50) = 'Andres.Espinoza'
DECLARE @Pos INT = CHARINDEX('.', @Nombre) - 1
DECLARE @SubNombre VARCHAR(50) = SUBSTRING(@Nombre,1,@Pos)
SELECT @SubNombre -- Andres

-- ============================================================================================
-- ============================================================================================

-- ==============
-- === CONCAT ===
-- ==============

SELECT
P.FirstName,
P.LastName,
CONCAT(P.FirstName,' ',P.LastName)'Nombre Completo',
CONCAT_WS(' ',P.FirstName,P.LastName)'Nombre Completo',
P.FirstName + ' ' + P.LastName 'Nombre Completo'
FROM Person.Person P

-- Función de concatenación

SELECT CONCAT(FirstName, ' ', LastName) AS Nombre_completo
FROM Person.Person

-- ============================================================================================
-- ============================================================================================

-- =================
-- === CONCAT_WS ===
-- =================

-- Función de concatenación

SELECT CONCAT_WS(' ', FirstName, LastName) AS Nombre_completo
FROM Person.Person

-- ============================================================================================
-- ============================================================================================

-- =================
-- ===== UPPER =====
-- =================

-- Convertir a mayúsculas una cadena

SELECT UPPER(CONCAT_WS(' ', FirstName, LastName)) AS Nombre_completo
FROM Person.Person

-- ============================================================================================
-- ============================================================================================

-- =================
-- ===== LOWER =====
-- =================

-- Convertir a minúsculas una cadena

SELECT LOWER(CONCAT_WS(' ', FirstName, LastName)) AS Nombre_completo
FROM Person.Person