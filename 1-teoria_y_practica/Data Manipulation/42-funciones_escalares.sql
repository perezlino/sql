-- ======================================================
-- =================== FUNCIÓN ESCALAR ==================
-- ======================================================

/* 	Es un objeto que almacena un conjunto de instrucciones que desempeñan una tarea especifica y que
	se ejecutan en bloques.

	Caracteristicas:

	- Puede aceptar o no parámetros y retornan un valor único o una tabla
	- No se pueden usar para Insertar, Actualizar o Eliminar registros en una tabla.
	- Almacena una lógica que se puede ejecutar dentro de una sentencia SQL

	Dos tipos de funciones:

	- Escalar: Retorna un solo valor como resultado de todas las operaciones de la función
	- De tabla: Retorna una tabla como resultado de todas las operaciones de la función (no se utilizan mucho)

	Diferencia entre un SP y Función:

		1. De una Función no puedo llamar a un SP. Mientras que de un SP si puedo llamar a una función
		2. Los SP no trabajan con la palabra "RETURN"       


	=======================
	=== FUNCIÓN ESCALAR ===
	=======================


	Qué son las funciones escalares
	===============================

	La función escalar de SQL Server toma uno o más parámetros y devuelve un único valor. Las funciones escalares 
	le ayudan a simplificar su código. Por ejemplo, puede tener un cálculo complejo que aparezca en muchas 
	consultas. En lugar de incluir la fórmula en cada consulta, puede crear una función escalar que encapsule la 
	fórmula y la utilice en cada consulta.


	Creación de una función escalar
	===============================  */

	USE TiendaBicicletas

/*	Para crear una función escalar, utilice la sentencia CREATE FUNCTION como se indica a continuación:

							CREATE FUNCTION [schema_name.]function_name (parameter_list)
							RETURNS data_type AS
							BEGIN
								statements
								RETURN value
							END

	En esta sintaxis:

	- En primer lugar, especifique el nombre de la función después de las palabras clave CREATE FUNCTION. 
	El nombre del esquema es opcional. Si no lo especifica explícitamente, SQL Server utiliza dbo por defecto.

	- En segundo lugar, especifique una lista de parámetros entre paréntesis después del nombre de la función.

	- En tercer lugar, especifique el tipo de datos del valor devuelto en la sentencia RETURNS.

	- Por último, incluya una sentencia RETURN para devolver un valor dentro del cuerpo de la función.

	- El siguiente ejemplo crea una función que calcula las ventas netas basándose en la cantidad, el precio de 
	catalogo y el descuento:   */

	CREATE FUNCTION Ventas.udfVentasNetas(
		@cantidad INT,
		@precio_catalogo DEC(10,2),
		@descuento DEC(4,2)
	)
	RETURNS DEC(10,2)
	AS 
	BEGIN
		RETURN @cantidad * @precio_catalogo * (1 - @descuento)
	END


/*	Llamada a una función escalar
	=============================

	Una función escalar se llama como una función incorporada. Por ejemplo, la siguiente sentencia muestra cómo 
	llamar a la función udfNetSale:  */

	SELECT Ventas.udfVentasNetas(10,100,0.1) ventas_netas
/*
	|------------|
	|ventas_netas|
	|------------|
	|   900.00   |
	|------------|


	El siguiente ejemplo ilustra cómo utilizar la función Ventas.udfVentasNetas para obtener las ventas netas de los 
	pedidos de cliente de la tabla order_items:  */

	SELECT 
		pedido_id, 
		SUM(Ventas.udfVentasNetas(cantidad, precio_catalogo, descuento)) net_amount
	FROM 
		Ventas.items_pedidos
	GROUP BY 
		pedido_id
	ORDER BY
		net_amount DESC
/*
	|---------|----------|
	|pedido_id|net_amount|
	|---------|----------|
	|   1541  | 29147.02 |
	|    937  | 27050.71 |
	|   1506  | 25574.95 |
	|   1482  | 25364.43 |
	|   1364  | 24890.62 |
	|    930  | 24607.02 |
	|   ....  |   ....   |
	|---------|----------|


/*	Modificación de una función escalar
	===================================

	Para modificar una función escalar, utilice la palabra clave ALTER en lugar de CREATE. El resto de las 
	sentencias son las mismas:

								ALTER FUNCTION [schema_name.]function_name (parameter_list)
								RETURN data_type AS
								BEGIN
									statements
									RETURN value
								END

	Tenga en cuenta que puede utilizar la sentencia CREATE OR ALTER para crear una función definida por el 
	usuario si no existe o para modificar una función escalar existente:

								CREATE OR ALTER FUNCTION [schema_name.]function_name (parameter_list)
								RETURN data_type AS
								BEGIN
									statements
									RETURN value
								END


	Eliminación de una función escalar
	==================================

	Para eliminar una función escalar existente, utilice la sentencia DROP FUNCTION:

								DROP FUNCTION [schema_name.]function_name

	Por ejemplo, para eliminar la función Ventas.udfVentasNetas, utilice la siguiente sentencia:        */

	DROP FUNCTION Ventas.udfVentasNetas



	/* Notas sobre las funciones escalares de SQL Server
	=================================================

	Los siguientes son algunos puntos clave de las funciones escalares:

	- Las funciones escalares se pueden utilizar casi en cualquier parte de las sentencias T-SQL.
	- Las funciones escalares aceptan uno o más parámetros pero devuelven sólo un valor, por lo tanto, 
	  deben incluir una sentencia RETURN.
	- Las funciones escalares pueden utilizar lógica como bloques IF o bucles WHILE.
	- Las funciones escalares no pueden actualizar datos. Pueden acceder a los datos, pero no es una buena 
	  práctica.
	- Las funciones escalares pueden llamar a otras funciones. 

	============================================================================================
	============================================================================================

	Ejemplo 1  */

	CREATE FUNCTION calcularpromedio2 (
		@valor1 AS DECIMAL(10,2),
		@valor2 AS DECIMAL(10,2))
	RETURNS DECIMAL(10,2)
	AS
	BEGIN
		DECLARE @resultado DECIMAL(10,2)
		SET @resultado = (@valor1 + @valor2)/2
		RETURN @resultado
	END

	SELECT dbo.calcularpromedio2 (12,13) AS Promedio

	PRINT 'Promedio: ' + CAST(dbo.calcularpromedio2(12,13) AS VARCHAR(10))

/*	============================================================================================
	============================================================================================

	Ejemplo 2

	Implementar una función que devuelva una fecha ingresada del tipo '15-08-2015' en este formato 
	'15 de Agosto del 2015'  */

	USE AdventureWorks2019
	GO

	IF OBJECT_ID('fechaletras') IS NOT NULL
	BEGIN
		DROP FUNCTION fechaletras
	END
	GO

	CREATE FUNCTION fechaletras (@fecha AS DATE)
	RETURNS VARCHAR(20)
	AS
	BEGIN
		DECLARE @resultado VARCHAR(20)
		SET @resultado = CONCAT(DAY(@fecha),' de ',DATENAME(MONTH,@fecha),' del ',YEAR(@fecha))
		RETURN @resultado
	END

	SELECT dbo.fechaletras('2015-08-08') AS 'Fecha Actual'

/*	============================================================================================
	============================================================================================

	Ejemplo 3

	Utilizando la función recién creada modifico de manera visual la fecha de la columna 
	"Modified Date". Sin embargo, tenemos antes que modificar la función para que albergue
	una mayor cantidad de caracteres. Pasamos de 20 caract. a 30 caract.  */

	USE AdventureWorks2019

	SELECT CustomerID,dbo.fechaletras(ModifiedDate) FROM Sales.Customer

	ALTER FUNCTION fechaletras (@fecha AS DATE)
	RETURNS VARCHAR(30)
	AS
	BEGIN
		DECLARE @resultado VARCHAR(30)
		SET @resultado = CONCAT(DAY(@fecha),' de ',DATENAME(MONTH,@fecha),' del ',YEAR(@fecha))
		RETURN @resultado
	END

/*	============================================================================================
	============================================================================================

	Ejemplo 4  */

	CREATE FUNCTION calculocobroextra (@extprecio DECIMAL(9,2))
	RETURNS DECIMAL(9,2)
	AS
	BEGIN
		RETURN @extprecio * 0.19
	END

	SELECT idtarifa, 
		clase, 
		precio, 
		'0.19' AS Impuesto, 
		dbo.calculocobroextra(precio) AS Total
	FROM TARIFA

/*	============================================================================================
	============================================================================================

	Ejemplo 5

	Utilizando el ejemplo anterior:

	Que pasaria si tengo más lógica con respecto al precio y al % de Impuesto:

			1 a 20 ==> 18%
			21 a 50 ==> 20%
			51 a 100 ==> 22%
			101 a más ==> 25%
*/

	ALTER FUNCTION calculocobroextra (@extprecio DECIMAL(9,2))
	RETURNS DECIMAL(9,2)
	AS
	BEGIN
		DECLARE @result DECIMAL(9,2)
		SET @result =
			CASE 
				WHEN @extprecio BETWEEN 1 AND 20 THEN (@extprecio * 0.18)
				WHEN @extprecio BETWEEN 21 AND 50 THEN (@extprecio * 0.20)
				WHEN @extprecio BETWEEN 51 AND 100 THEN (@extprecio * 0.22)
				ELSE @extprecio * 0.25
			END
		RETURN @result
	END


	SELECT idtarifa,
		clase,
		precio,
		dbo.calculocobroextra(precio) AS Total
	FROM TARIFA

/*	============================================================================================
	============================================================================================

	Ejemplo 6  */

	CREATE OR ALTER FUNCTION FN_Edad (@FecNac DATE)
	RETURNS INT
	AS
	BEGIN
		RETURN DATEDIFF(YEAR, @FecNac, GETDATE())
	END

	SELECT dbo.FN_Edad ('1996-12-10')

/*	============================================================================================
	============================================================================================

	Ejemplo 7

	Crear una función donde me concatene 3 palabras @param1 -> nombre, @param2 -> apellido, @param3 -> sep 
*/

	CREATE FUNCTION FN_Concatenar(@param1 VARCHAR(50), @param2 VARCHAR(75), @param3 VARCHAR(5))
	RETURNS VARCHAR(200)
	AS
	BEGIN
		RETURN @param1 + @param3 + @param2
	END

	SELECT dbo.FN_Concatenar('Alfonso','Pérez',' ')

/*	============================================================================================
	============================================================================================

	Ejemplo 8 */

	CREATE OR ALTER FUNCTION FN_Primeroscaracteres(@Nombre VARCHAR(100), @Sep VARCHAR(5))
	RETURNS VARCHAR(100)
	AS
	BEGIN
		DECLARE @Pos INT = CHARINDEX(@Sep, @Nombre) - 1
		DECLARE @SubNombre VARCHAR(50) = SUBSTRING(@Nombre, 1, @Pos)
		RETURN @SubNombre
	END

	SELECT dbo.FN_Primeroscaracteres ('Andres.Espinoza','.')

	SELECT LEN(dbo.FN_Primeroscaracteres ('Andres.Espinoza','.')) AS 'Cantidad'

/*	============================================================================================
	============================================================================================

	Ejemplo 9  */

	CREATE OR ALTER FUNCTION FN_Correo(@Nombre VARCHAR(50), @Apellido VARCHAR(50))
	RETURNS VARCHAR(MAX)
	AS
	BEGIN
		DECLARE @SubNombre VARCHAR(5);
		DECLARE @SubApellido VARCHAR(5);
		DECLARE @Union VARCHAR(100);
		
		SET @SubNombre = SUBSTRING(@Nombre,1,3)
		SET @SubApellido = SUBSTRING(@Apellido,1,3)
		SET @Union = dbo.FN_Concatenar(@SubNombre,@SubApellido,'.') + '@gmail.com'

		RETURN LOWER(@Union)

	END;

	SELECT dbo.FN_Correo ('Alfonso','Perez')