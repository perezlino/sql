-- ======================================================
-- ================= CONSULTAS DINÁMICAS ================
-- ======================================================

/* Ejemplos */


USE AdventureWorks2019

SELECT * FROM Person.Person

--PRIMERA FORMA

DECLARE @varTabla VARCHAR(30)
SET @varTabla = 'Person.Person'

SELECT @varTabla --Mostrar el nombre de esa variable

--SELECT * FROM @varTabla -- Forma errónea

EXEC ('SELECT * FROM ' + @varTabla)     

--SEGUNDA FORMA

DECLARE @varTabla2 VARCHAR(30)
SET @varTabla2 = 'SELECT * FROM Person.Person' 
EXEC (@varTabla2)


--EJERCICIO 1: Utilizar una variable para reemplazar una tabla--

DECLARE @consultaSQL NVARCHAR(4000) = ''
DECLARE @tabla VARCHAR(20) = 'Person'

SET @consultaSQL = ('SELECT * FROM [Person].' + @tabla)
EXEC (@consultaSQL)

--EJERCICIO 2: Utilizar una variable para reemplazar un campo--

DECLARE @consultaSQL2 NVARCHAR(4000) = ''
DECLARE @tabla2 VARCHAR(20) = 'Person'
DECLARE @campo VARCHAR(20) = 'FirstName'

SET @consultaSQL2 = ('SELECT ' + @campo + ' FROM [Person].' + @tabla2)
EXEC (@consultaSQL2)

--EJERCICIO 3: Insertar en una tabla los resultados--

DECLARE @consultaSQL3 NVARCHAR(4000) = ''
DECLARE @tabla3 VARCHAR(20) = 'Person'
DECLARE @campo2 VARCHAR(20) = 'FirstName'
DECLARE @tablaResultado AS TABLE (Nombre VARCHAR(100))

SET @consultaSQL3 = ('SELECT ' + @campo2 + ' FROM [Person].' + @tabla3)

INSERT INTO @tablaResultado (Nombre)

EXEC (@consultaSQL3)

SELECT * FROM @tablaResultado

--EJERCICIO 4--

/* Mostrar la cantidad de personas que realizan la compra con alguna tarjeta de crédito,
agrupados por el nombre de Tipo de Persona (PersonType) y Tipo de Tarjeta (CardType).

Nota: Considerar el siguiente cuadro para sacar el nombre tipo persona, a partir del campo
PersonType.

BBDD: AdventureWorks2019
Tablas: Person.Person, Sales.PersonCreditCard, Sales.CreditCard
Campos: BusinessEntityID, CreditCardID, PersonType, CardType
*/

SELECT * FROM Person.Person
SELECT * FROM Sales.PersonCreditCard
SELECT * FROM Sales.CreditCard

--FORMA NORMAL --

SELECT PersonType, CardType, COUNT(PP.BusinessEntityID) 'Cantidad personas'
FROM Person.Person PP
INNER JOIN Sales.PersonCreditCard SPCC
ON PP.BusinessEntityID = SPCC.BusinessEntityID
INNER JOIN Sales.CreditCard SCC
ON SPCC.CreditCardID = SCC.CreditCardID
GROUP BY PersonType, CardType
ORDER BY [Cantidad personas]


SELECT 
	CASE PersonType
		WHEN 'SC' THEN 'Cliente Tienda'
		WHEN 'IN' THEN 'Cliente Individual'
		WHEN 'SP' THEN 'Vendedor'
		WHEN 'EM' THEN 'Empleado'
		WHEN 'VC' THEN 'Proveedor'
		WHEN 'GC' THEN 'Contacto General'
	END Nombre_Tipo_Persona,
	CardType,
	COUNT(PP.BusinessEntityID) 'Cantidad personas'
FROM Person.Person PP
INNER JOIN Sales.PersonCreditCard SPCC
ON PP.BusinessEntityID = SPCC.BusinessEntityID
INNER JOIN Sales.CreditCard SCC
ON SPCC.CreditCardID = SCC.CreditCardID
GROUP BY PersonType, CardType
ORDER BY [Cantidad personas]

--FORMA DINÁMICA--

--Declaro la variable
DECLARE @varQuery VARCHAR(MAX)

--Guardamos el script dentro de la variable
SET @varQuery = 
'SELECT 
	CASE PersonType
		WHEN ''SC'' THEN ''Cliente Tienda''
		WHEN ''IN'' THEN ''Cliente Individual''
		WHEN ''SP'' THEN ''Vendedor''
		WHEN ''EM'' THEN ''Empleado''
		WHEN ''VC'' THEN ''Proveedor''
		WHEN ''GC'' THEN ''Contacto General''
	END Nombre_Tipo_Persona,
	CardType,
	COUNT(PP.BusinessEntityID) ''Cantidad personas''
FROM Person.Person PP
INNER JOIN Sales.PersonCreditCard SPCC
ON PP.BusinessEntityID = SPCC.BusinessEntityID
INNER JOIN Sales.CreditCard SCC
ON SPCC.CreditCardID = SCC.CreditCardID
GROUP BY PersonType, CardType
ORDER BY [Cantidad personas]'

--
EXEC (@varQuery)

--EJERCICIO 5: Creación de Backups de manera dinámica--

SELECT ROW_NUMBER()OVER(ORDER BY database_id) 'Item',
       name,
	   database_id
INTO #T_Temp
FROM sys.databases
WHERE database_id > 4

--Declarando las variables--
DECLARE @cont INT = 1
DECLARE @varlimit INT
DECLARE @varBBDD VARCHAR(30) = ''
DECLARE @varQuery2 VARCHAR(MAX) = ''

--Guardando el limite de la cantidad de BBDDs
SELECT @varlimit = MAX(Item) FROM #T_Temp

WHILE @cont <= @varlimit
	BEGIN
		SELECT @varBBDD = name FROM #T_Temp
		WHERE Item = @cont

		SET @varQuery2 = 
			'Backup Database ' + @varBBDD + 
			' to disk = ''C:\Users\Alfonso\Downloads\Backups\Backup_' + @varBBDD + '.bak''
			 WITH
			 NAME = ''Backup Full'', DESCRIPTION = ''Guardado de BBDD Completa'''
			
		EXEC (@varQuery2)
		SET @cont = @cont + 1
	END