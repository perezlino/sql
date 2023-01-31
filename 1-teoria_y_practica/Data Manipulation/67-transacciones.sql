-- ======================================================
-- ==================== TRANSACCIONES ===================
-- ======================================================

/*	Una transacción es una única unidad de trabajo que suele contener varias sentencias T-SQL.

	Si una transacción se realiza correctamente, los cambios se registran (are committed) en la base 
	de datos. Sin embargo, si una transacción tiene un error, los cambios tienen que ser revertidos 
	(rolled back).

	Cuando se ejecuta una única sentencia, como INSERT, UPDATE y DELETE, SQL Server utiliza la transacción 
	autocommit. En este caso, cada sentencia es una transacción.

	Para iniciar una transacción explícitamente, utilice primero la sentencia BEGIN TRANSACTION o 
	BEGIN TRAN:

											BEGIN TRANSACTION


	A continuación, ejecute una o varias sentencias, incluidas INSERT, UPDATE y DELETE.

	Por último, confirme la transacción mediante la sentencia COMMIT:

												COMMIT


	O deshacer la transacción utilizando la sentencia ROLLBACK:

												ROLLBACK


	Esta es la secuencia de sentencias para iniciar una transacción explícitamente y confirmarla:

											-- iniciar (begin) una transacción
											BEGIN TRANSACTION;

											-- otras sentencias

											-- confirmar (commit) la transacción
											COMMIT;


	Ejemplo de transacción
	======================
*/
	USE TiendaBicicletas
/*
	Crearemos dos tablas: facturas y factura_items para la demostración:  */

	CREATE TABLE facturas (
	id int IDENTITY PRIMARY KEY,
	cliente_id int NOT NULL,
	total decimal(10, 2) NOT NULL DEFAULT 0 CHECK (total >= 0)
	);

	CREATE TABLE factura_items (
	id int,
	factura_id int NOT NULL,
	nombre_item varchar(100) NOT NULL,
	monto decimal(10, 2) NOT NULL CHECK (monto >= 0),
	impuesto decimal(4, 2) NOT NULL CHECK (impuesto >= 0),
	PRIMARY KEY (id, factura_id),
	FOREIGN KEY (factura_id) REFERENCES facturas (id)
		ON UPDATE CASCADE
		ON DELETE CASCADE
	)
/*

	La tabla facturas almacena la cabecera de la factura, mientras que la tabla factura_items almacena 
	las partidas (line items). El campo total de la tabla facturas se calcula a partir de las partidas 
	(line items).

	El siguiente ejemplo utiliza las sentencias BEGIN TRANSACTION y COMMIT para crear una transacción:  */

	BEGIN TRANSACTION

	INSERT INTO facturas (cliente_id, total)
	VALUES (100, 0);

	INSERT INTO factura_items (id, factura_id, nombre_item, monto, impuesto)
	VALUES (10, 1, 'Keyboard', 70, 0.08),
		(20, 1, 'Mouse', 50, 0.08);

	UPDATE facturas
	SET total = (SELECT SUM(monto * (1 + impuesto))
	FROM factura_items
	WHERE factura_id = 1);

	COMMIT TRANSACTION
/*

	=========================================================================================================

	En este ejemplo:

	En primer lugar, inicie una transacción explícitamente mediante la sentencia BEGIN TRANSACTION:  */

	BEGIN TRANSACTION

/*	A continuación, inserte una fila en la tabla de facturas y devuelva el id de la factura:  */

	DECLARE @factura TABLE (
	id int
	)

	DECLARE @factura_id int

	INSERT INTO facturas (cliente_id, total)
	OUTPUT inserted.id 
	INTO @factura
	VALUES (100, 0);

	SELECT
	@factura_id = id
	FROM @factura

	ROLLBACK TRAN

/*	A continuación, inserte dos filas en la tabla factura_items:  */

	INSERT INTO factura_items (id, factura_id, nombre_item, monto, impuesto)
	VALUES (10, @factura_id, 'Keyboard', 70, 0.08),
		(20, @factura_id, 'Mouse', 50, 0.08);

/*	A continuación, calcule el total utilizando la tabla factura_items y actualícelo en la tabla 
	facturas:  */

	UPDATE facturas
	SET total = (
		SELECT SUM(monto * (1 + impuesto))
		FROM factura_items
		WHERE factura_id = @factura_id
	)
	
/*	Por último, confirme la transacción mediante la sentencia COMMIT:  */

	COMMIT

/*

	Resumen
	=======

	- Utilice la sentencia BEGIN TRANSACTION para iniciar una transacción explícitamente.
	- Utilice la sentencia COMMIT para confirmar la transacción y la sentencia ROLLBACK para revertirla.


	========================================================================================================
	========================================================================================================

	===================
	=== TRANSACCIÓN ===
	===================

	Una TRANSACCIÓN es una unidad única de trabajo que se ejecuta de manera independiente. 
	
		Ejemplo: Las sentencias INSERT,UPDATE,DELETE entre otras.

	Caracteristicas:
	---------------

	- Si una transaccion tiene éxito, todas las modificaciones que esta realiza se confirman y se almacenan
		de manera permanente en la BD.
	
	- Si una transacción encuentra errores y debe cancelarse o revertirse, se borran todas las modificaciones
		de los datos.

	NOTA: Cada sentencia es independiente, los errores en una no afectan a la otra, ni detienen la ejecución
		  de las demás.


	============================
	=== TIPOS DE TRANSACCIÓN ===
	============================

	Se inicia implicitamente una nueva transaccion cuando se ha completado la anterior, pero cada transaccion
	se completa explicitamente con una instruccion COMMIT o ROLLBACK


	TRANSACCIÓN IMPLICITA
	=====================

	Todas las operaciones que realizamos y ejecutamos son transacciones implicitas. */

	USE EJERCICIOS

--	A modo de ejemplo, si solo colocamos BEGIN TRAN:

	BEGIN TRANSACTION

	UPDATE tblEmployee
	SET EmployeeNumber = 122
	WHERE EmployeeNumber = 123 -- Al cargar esta actualizacion no se carga en la base de datos, sino,
	                           -- solo se cargan para esta Query, si abrimos una nueva Query y ejecutamos la 
							   -- tabla "tblEmployee" vamos a ver que la consulta no va a cargar, dado que
							   -- se ha generado un "bloqueo" o "blocking" que estará bloqueando la carga. 
							   -- Debemos utilizar ROLLBACK o COMMIT para que continue o retroceda la carga.


--	Sucede lo mismo al hacer lo siguiente, debemos indicar al final un ROLLBACK o COMMIT, para darle termino
--	a la transacción y eliminar el bloqueo. No se utiliza a menudo.

	SET IMPLICIT_TRANSACTIONS ON

	UPDATE tblEmployee
	SET EmployeeNumber = 122
	WHERE EmployeeNumber = 123

	SET IMPLICIT_TRANSACTIONS OFF  -- Apagar 
/*


	TRANSACCIÓN EXPLICITA
	=====================

	Es aquella donde se define de manera explicita el inicio y el fin de la transaccion a traves de las 
	sentencias BEGIN TRANSACTION y COMMIT TRANSACTION (cuando finaliza sin errores) o ROLLBACK TRANSACTION
	(cuando se presenta algun error)

	--------------------
	/* Primer Ejemplo */
	--------------------

/*	Vamos a utilizar una transacción en un bloque. Si una sentencia es correcta y otra es incorrecta, no 
	se carga nada.  */

	BEGIN TRANSACTION
		UPDATE tblEmployee
		SET EmployeeNumber = 122
		WHERE EmployeeNumber = 123

		UPDATE tblEmployee
		SET EmployeeNumber = 124
		WHERE EmployeeNumber = 125
	COMMIT TRANSACTION

---

	BEGIN TRANSACTION
		UPDATE tblEmployee
		SET EmployeeNumber = 122
		WHERE EmployeeNumber = 123
	ROLLBACK TRANSACTION           --- Aunque este correcta la sentencia con el ROLLBACK no se ejecutara
									--- ni se cargara.El ROLLBACK cancelara todo.

 --------------------
/* Segundo Ejemplo */
--------------------

BEGIN TRY
	BEGIN TRANSACTION
		SET NOCOUNT ON
		UPDATE tblEmployee
		SET EmployeeNumber = 122
		WHERE EmployeeNumber = 123

		UPDATE tblEmployee
		SET EmployeeNumber = 124
		WHERE EmployeeNumber = 125
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION; --ROLLBACK puede ir aca o debajo de los PRINTS
	PRINT '*******************************************************'
	PRINT '*** ERRORES EN LAS TRANSACCIONES SE APLICÓ ROLLBACK ***'
	PRINT '*******************************************************'
END CATCH