-- ======================================================
-- ============= TRABAJAR CON VALORES NULOS =============
-- ======================================================

/* No es posible utilizar operadores de comparación tradicionales (=) en las consultas. 
   De hecho, en los Estándares SQL, el uso de la cláusula WHERE como se muestra a continuación 
   hará que se devuelvan conjuntos de resultados vacíos.

                SELECT column_name1, column_name2, column_name3, ... , column_nameN
                FROM table_name
                WHERE column_nameN = NULL

/* Por esta razón, trabajar con los valores NULL puede ser un poco complicado y es necesario 
   utilizar ciertas funciones integradas que están personalizadas para manejar valores NULL. 
*/

-- ===============
-- === IS NULL ===
-- ===============

/* La condición IS NULL se usa para devolver filas que contienen los valores NULL en una columna 
   y su sintaxis es la siguiente:

                SELECT column_name1, column_name2, column_name3, ... , column_nameN
                FROM table_name
                WHERE column_nameN IS NULL
*/

-- La siguiente consulta recuperará las filas de la tabla Person que son valores de columna MiddleName 
-- iguales a NULL.
SELECT FirstName, LastName, MiddleName 
FROM Person.Person 
WHERE MiddleName IS NULL

-- ============================================================================================
-- ============================================================================================

-- ===================
-- === IS NOT NULL ===
-- ===================

/* La condición IS NOT NULL se utiliza para devolver las filas que contienen valores no NULL en una 
   columna. La siguiente consulta recuperará las filas de la tabla Person que son el valor de la columna 
   MiddleName no es igual a los valores NULL.
*/

SELECT FirstName, LastName, MiddleName 
FROM Person.Person 
WHERE MiddleName IS NOT NULL

-- ============================================================================================
-- ============================================================================================

-- ================
-- === ISNULL() ===
-- ================

/* ISNULL (): La función ISNULL () toma dos parámetros y nos permite reemplazar valores NULL con un 
              valor especificado.

                                    ISNULL (expression, replacement)

El parámetro de "expresión" indica la expresión a la cual queremos verificar valores NULL.
El parámetro de "reemplazo" indica el valor con el que queremos reemplazar los valores NULL.

Por ejemplo, en la siguiente consulta, la función ISNULL() reemplaza los valores NULL en la fila con 
el valor especificado.
*/

SELECT Title, 
       ISNULL(Title,'NewTitle') AS NewTitle, 
       FirstName, 
       LastName
FROM Person.Person 
WHERE BusinessEntityID = 74

-- ============================================================================================
-- ============================================================================================

-- ==================
-- === COALESCE() ===
-- ==================

/* COALESCE (): La función COALESCE () toma parámetros ilimitados y devuelve la primera expresión no 
                nula en una lista.

                                    COALESCE(val1, val2, ...., val_n)

En la siguiente consulta, la función COALESCE () devuelve 'Alfonso' porque es el primer valor no 
nulo de la lista.
*/
SELECT COALESCE(NULL, NULL, 'Alfonso', NULL, 'Best Articles') -- Alfonso

-- ============================================================================================

-- En este segundo ejemplo, la función COALESCE () devuelve la primera expresión no nula en la lista 
-- de columnas.

SELECT BusinessEntityID, 
       FirstName, 
       LastName, 
       Suffix, 
       Title,
       COALESCE(Title,Suffix,FirstName) AS NewValue
FROM Person.Person 
WHERE BusinessEntityID IN (5, 74)

-- ============================================================================================
/*

1.- COALESCE(float,int) --> Si el primer valor tiene un tipo de dato definido y el segundo también 
                            el resultado tendrá el tipo de dato con mayor prioridad. En este caso 
					        devolvería el resultado con el tipo de dato float.

Orden de tipos de datos según prioridad:

sql_variant
xml
datetimeoffset
datetime2
datetime
smalldatetime
date
time
float
real
decimal
money
smallmoney
bigint
int
smallint
tinyint
bit
ntext
text
image
timestamp
uniqueidentifier
nvarchar (including nvarchar(max) )
nchar
varchar (including varchar(max) )
char
varbinary (including varbinary(max) )
binary (lowest)                                                                       

2.- COALESCE(NULL,NULL) --> Si el primer valor tiene un tipo NULL y el segundo parámetro también,
                            el resultado devolverá un ERROR.


COALESCE(float,int) --> Si el primer valor tiene un tipo de dato definido, el resultado tendrá
                      este tipo de dato

COALESCE(NULL,int) --> Si el primer valor tiene un tipo NULL, el resultado tendrá el tipo de dato
                     del segundo parámetro (aunque este también sea nulo)

COALESCE(NULL,NULL) --> Si el primer valor tiene un tipo NULL y el segundo parámetro también,
                      el resultado tendrá el tipo de dato INTEGER. 

COALESCE(int=NULL,VARCHAR) --> Si el primero valor es un tipo de dato INT pero es un valor NULL y 
                             el segundo parámetro es VARCHAR, se devolverá el valor del segundo
                             parámetro pero con el tipo de dato INT, dado que tiene mayor prioridad.
                             En este caso, si el VARCHAR es una cadena, devolverá un ERROR.
*/

DECLARE @ValorNulo INT = NULL,
		@Valor1    INT = 0,
		@Valor2    INT = 10,
		@Valor3    FLOAT = 10.5,
		@Valor4    NVARCHAR = 'A1B2',
		@Fecha     DATETIME = GETDATE()

-- INT(NULL) & INT 
SELECT COALESCE(@ValorNulo, @Valor2) AS [COALESCE]


DECLARE @ValorNulo INT = NULL,
		@Valor1    INT = 0,
		@Valor2    INT = 10,
		@Valor3    FLOAT = 10.5,
		@Valor4    NVARCHAR = 'A1B2',
		@Fecha     DATETIME = GETDATE()

-- INT(NULL) & FLOAT & DATETIME 
SELECT COALESCE(@ValorNulo, @Valor3) AS [COALESCE],
	   COALESCE(@ValorNulo, @Valor3, @Fecha) AS [COALESCE]


DECLARE @ValorNulo INT = NULL,
		@Valor1    INT = 0,
		@Valor2    INT = 10,
		@Valor3    FLOAT = 10.5,
		@Valor4    NVARCHAR = 'A1B2',
		@Fecha     DATETIME = GETDATE()

-- INT(NULL) & NVARCHAR
SELECT COALESCE(@ValorNulo, @Valor4) AS [COALESCE]


DECLARE @ValorNulo INT = NULL,
		@Valor1    INT = 0,
		@Valor2    INT = 10,
		@Valor3    FLOAT = 10.5,
		@Valor4    NVARCHAR = 'A1B2',
		@Fecha     DATETIME = GETDATE()

-- NULL & NULL
SELECT COALESCE(NULL, NULL) AS [COALESCE] 

-- ============================================================================================
-- ============================================================================================

-- ¿Cómo contar valores SQL NULL en una columna?

-- La función COUNT () se utiliza para obtener el número total de filas en el conjunto de resultados. 
-- Cuando usamos esta función con el signo de estrella, cuenta todas las filas de la tabla 
-- independientemente de los valores NULL. Por ejemplo, cuando contamos la tabla Person a través de 
-- la siguiente consulta, devolverá 19972.

               SELECT COUNT(*) AS [Total Number of Rows] FROM Person.Person

-- Por otro lado, cuando usamos la función COUNT() con un nombre de columna, solo cuenta los valores 
-- no NULL en esa columna.

               SELECT COUNT(Title) AS [Total Number of Title] FROM Person.Person

-- Hacerlo de esta manera nos devolverá un resultado erroneo.
               SELECT COUNT(Title) FROM Person.Person WHERE Title IS NULL

-- Para contar los valores NULL de una columna, podemos usar la siguiente consulta.
SELECT SUM(CASE WHEN Title IS NULL THEN 1 ELSE 0 END) AS [Number Of Null Values],
       COUNT(Title) AS [Number Of Non-Null Values]
FROM Person.Person

-- ============================================================================================
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