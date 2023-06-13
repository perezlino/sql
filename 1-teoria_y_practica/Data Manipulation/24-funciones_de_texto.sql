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

SELECT OrderDate, FORMAT(OrderDate,'yyyyMM') año_mes
FROM Sales.SalesOrderHeader

-- FORMAT con cadenas de formato personalizado

DECLARE @num INT = 123456789
SELECT FORMAT(@num,'###-##-####') AS 'Numero_personalizado'

-- FORMAT con tipos de datos de tiempo
-- FORMAT devuelve NULL en estos casos porque . y : no incluyen caracteres de escape.
SELECT FORMAT(CAST('07:35' AS TIME), N'hh.mm');   --> returns NULL  
SELECT FORMAT(CAST('07:35' AS TIME), N'hh:mm');   --> returns NULL

-- FORMAT devuelve una cadena con formato porque . y : incluyen caracteres de escape.
SELECT FORMAT(CAST('07:35' AS TIME), N'hh\.mm');  --> returns 07.35  
SELECT FORMAT(CAST('07:35' AS TIME), N'hh\:mm');  --> returns 07:35

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

SELECT REPLICATE('NO',5) AS Replicate
/*
|-----------|
| Replicate |
|-----------|
|NONONONONO |
|-----------| */

SELECT REPLICATE('*',10) AS Replicate
/*
|-----------|
| Replicate |
|-----------|
|********** |
|-----------| */

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

-- Concatenación ante la existencia de un NULL sin utilizar la función CONCAT

DECLARE @firstname AS VARCHAR(20)
DECLARE @middlename AS VARCHAR(20)
DECLARE @lastname AS VARCHAR(20)

SET @firstname = 'Alfonso'
SET @lastname = 'Perez'

SELECT @firstname + IIF(@middlename IS NULL, '', ' ' + @middlename) + ' ' + @lastname AS Nombre_completo

SELECT @firstname + CASE 
                     WHEN @middlename IS NULL THEN '' 
                     ELSE ' ' + @middlename 
                    END 
                  + ' ' + @lastname AS Nombre_completo

SELECT @firstname + ' ' + COALESCE(@middlename,'') + ' ' + @lastname AS Nombre_completo

-- ============================================================================================

-- Concatenación de strings con números

SELECT 'Mi numero es: ' + CONVERT(VARCHAR(20), 350000)

SELECT 'Mi numero es: ' + CAST(350000 AS VARCHAR(20))

SELECT 'Mi salario es: $' + CONVERT(VARCHAR(20), 350000.20)

SELECT 'Mi salario es: ' + FORMAT(350000, 'C', 'en-us')

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

-- ============================================================================================
-- ============================================================================================

-- ============
-- === LEFT ===
-- ============

/* La función LEFT() extrae un número determinado de caracteres de la parte izquierda de una cadena 
   suministrada. Por ejemplo, LEFT('SQL Server', 3) devuelve SQL.

   La sintaxis de la función LEFT() es la siguiente:

                        LEFT ( input_string , number_of_characters )  

   En esta sintaxis:

   El input_string puede ser una cadena literal, variable o columna. El tipo de datos del resultado 
   del input_string puede ser cualquier tipo de datos, excepto TEXT o NTEXT, que se convierte implícitamente 
   a VARCHAR o NVARCHAR.

   El number_of_characters es un entero positivo que especifica el número de caracteres de la input_string 
   que se devolverán.

   La función LEFT() devuelve un valor de VARCHAR cuando el input_string es un tipo de datos de caracteres 
   no Unicode o NVARCHAR si el input_string es un tipo de datos de caracteres Unicode.


   Ejemplos de la función LEFT() de SQL Server
   ===========================================

   Veamos algunos ejemplos de uso de la función LEFT() para entenderla mejor.

   A) Uso de la función LEFT() con una cadena de caracteres literal
   ================================================================

   La siguiente sentencia utiliza LEFT() para devolver los tres caracteres situados más a la izquierda de la 
   cadena de caracteres SQL Server:  */

SELECT LEFT('SQL Server',3) Result_string
   
-- Este es el resultado:

   Result_string
   -------------
   SQL

   (1 row affected)


/* B) Utilización de la función LEFT() con una columna de la tabla
   ===============================================================

   El siguiente ejemplo devuelve los siete caracteres situados más a la izquierda de cada nombre de producto 
   de la tabla Production.Products:  */

SELECT 
    product_name,
    LEFT(product_name, 7) first_7_characters
FROM 
    Production.Products
ORDER BY 
    product_name

-- Se muestra la salida parcial:

-- |---------------------------|--------------------|
-- |        product_name       | first_7_characters |
-- |---------------------------|--------------------|
-- |Electra Amsterdam Fashion  |       Electra      |
-- |Electra Amsterdam Original |       Electra      |
-- |Electra Cruiser            |       Electra      |
-- |       ............        |     ...........    |
-- |---------------------------|--------------------|

/* C) Uso de la función LEFT() con la cláusula GROUP BY

   El siguiente ejemplo utiliza la función LEFT() para devolver un conjunto de iniciales del nombre del producto 
   y el número de cada producto para cada inicial:   */

SELECT
	LEFT(product_name, 1) initial,  
	COUNT(product_name) product_count
FROM 
	Production.Products
GROUP BY
	left(product_name, 1)
ORDER BY 
	initial

-- |---------|---------------|
-- | initial | product_count |
-- |---------|---------------|
-- |    E    |      118      |
-- |    H    |       13      |
-- |    P    |        3      |
-- |    R    |        1      |
-- |    S    |       51      |
-- |    T    |      135      |
-- |---------|---------------|


-- ============================================================================================
-- ============================================================================================

-- =============
-- === RIGHT ===
-- =============

/* La función RIGHT() extrae un número determinado de caracteres de la parte derecha de una cadena de 
   caracteres especificada. Por ejemplo, RIGHT('SQL Server', 6) devuelve Server.

   La sintaxis de la función RIGHT() es la siguiente:

                              RIGHT ( input_string , number_of_characters )  
   
   En esta sintaxis:

   El input_string puede ser una cadena literal, variable o columna. El resultado del input_string puede 
   estar en cualquier tipo de datos, excepto TEXT o NTEXT, que se convierte implícitamente a VARCHAR o 
   NVARCHAR.

   El number_of_characters es un entero positivo que especifica el número de caracteres de la input_string 
   que se devolverán.

   Tenga en cuenta que la función RIGHT() devuelve un valor de VARCHAR cuando la cadena de entrada es un 
   tipo de datos de caracteres no Unicode o NVARCHAR si la cadena de entrada es un tipo de datos de caracteres 
   Unicode.


   Ejemplos de la función RIGHT() de SQL Server
   ============================================

   La siguiente sentencia utiliza RIGHT() para devolver los tres caracteres situados más a la derecha de la 
   cadena de caracteres SQL Server:   */

SELECT RIGHT('SQL Server',6) Result_string

-- Este es el resultado:

Result_string
-------------
Server

(1 row affected)

-- El siguiente ejemplo devuelve los cuatro caracteres situados más a la derecha de cada nombre de producto de 
-- la tabla Production.Products de la base de datos de ejemplo:

SELECT 
    product_name,
    RIGHT(product_name, 4) last_4_characters
FROM 
    Production.Products
ORDER BY 
    product_name

-- Este es el resultado:

-- |--------------------------------|--------------------|
-- |          product_name          |  last_4_characters |
-- |--------------------------------|--------------------|
-- |Electra Amsterdam Fashion 2018  |        2018        |
-- |Electra Amsterdam Original 2019 |        2019        |
-- |Electra Cruiser 2020            |        2020        |
-- |            ............        |     ...........    |
-- |--------------------------------|--------------------|


-- ============================================================================================
-- ============================================================================================

-- ====================
-- === STRING_SPLIT ===
-- ====================

/* La función STRING_SPLIT() es una función con valor de tabla que divide una cadena en una tabla formada por filas 
   de subcadenas basadas en un separador especificado.

   A continuación se muestra la sintaxis de la función STRING_SPLIT():

                                 
                                 STRING_SPLIT ( input_string , separator )  


   En esta sintaxis

   - "input_string": es una expresión basada en caracteres que se evalúa a un string de NVARCHAR, VARCHAR, NCHAR o CHAR.

   - "separator": es un único carácter utilizado como separador para la división.

   La función STRING_SPLIT() devuelve una tabla de una sola columna, cuyo nombre de columna es "value". Esta tabla de 
   resultados contiene filas que son las subcadenas.

   Tenga en cuenta que los valores de la columna "value" pueden estar en cualquier orden. Para obtener el orden esperado, 
   debe añadir la cláusula ORDER BY a la sentencia SELECT:   


                                          ORDER BY value [ASC|DESC]


   Ejemplos de la función STRING_SPLIT() de SQL Server
   ====================================================

   Veamos algunos ejemplos de uso de la función STRING_SPLIT().

   A) Uso de la función STRING_SPLIT() para dividir una cadena de valores separados por comas
   ------------------------------------------------------------------------------------------
      Este ejemplo utiliza la función STRING_SPLIT() para analizar una lista de valores separados por comas:  */                                         

      SELECT 
         value  
      FROM 
         STRING_SPLIT('red,green,,blue', ',');

      
/*    Este es el resultado: 

      value
      ---------------
      red
      green

      blue

      (4 rows affected)


      La tercera fila está vacía porque la cadena de entrada contiene dos comas consecutivas (,,). Para obtener subcadenas 
      no vacías, añada una cláusula WHERE a la sentencia SELECT, como se muestra en la siguiente consulta:     */

      SELECT 
         value  
      FROM 
         STRING_SPLIT('red,green,,blue', ',')
      WHERE
         TRIM(value) <> '';


/*    Este es el resultado: 

      value
      ---------------
      red
      green
      blue

      (3 rows affected)      


   B) Uso de la función STRING_SPLIT() para dividir una cadena separada por comas en una columna
   ----------------------------------------------------------------------------------------------
      A veces, las tablas de las bases de datos no están normalizadas. Un ejemplo típico de esto es cuando una columna 
      puede almacenar múltiples valores separados por una coma (,).

      STRING_SPLIT() puede ayudar a normalizar los datos dividiendo estas columnas multivaluadas.

      Vamos a crear una tabla de ejemplo para la demostración.

      En primer lugar, cree una nueva tabla denominada "sales.contacts" que almacene información de contacto:  */

      CREATE TABLE sales.contacts (
         id INT PRIMARY KEY IDENTITY,
         first_name VARCHAR(100) NOT NULL,
         last_name VARCHAR(100) NOT NULL,
         phones VARCHAR(500)
      );

/*    En segundo lugar, inserte algunos contactos en la tabla sales.contacts:   */

      INSERT INTO 
         sales.contacts(first_name, last_name, phones)
      VALUES
         ('John','Doe','(408)-123-3456,(408)-123-3457'),
         ('Jane','Doe','(408)-987-4321,(408)-987-4322,(408)-987-4323');

/*    En tercer lugar, utilice la función STRING_SPLIT() para dividir los números de teléfono y CROSS APPLY para unirlos 
      con la tabla sales.contacts:   */

      SELECT 
         first_name, 
         last_name,
         value phone
      FROM 
         sales.contacts
         CROSS APPLY STRING_SPLIT(phones, ',');

/*    first_name	last_name	phone
      John	      Doe	      (408)-123-3456
      John	      Doe	      (408)-123-3457
      Jane	      Doe	      (408)-987-4321
      Jane	      Doe	      (408)-987-4322
      Jane	      Doe	      (408)-987-4323 


   C) Utilización de la función STRING_SPLIT() con una función de agregación
   -------------------------------------------------------------------------
      El siguiente ejemplo devuelve los contactos y el número de teléfonos de cada contacto:       */        

      SELECT 
         CONCAT_WS(' ',first_name,last_name) full_name,
         COUNT(value) number_of_phones
      FROM 
         sales.contacts
         CROSS APPLY STRING_SPLIT(phones, ',')
      GROUP BY 
         CONCAT_WS(' ',first_name,last_name);

/*    El resultado es el siguiente: 

      full_name	number_of_phones
      Jane Doe	   3
      John Doe	   2