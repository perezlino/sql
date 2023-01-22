-- ======================================================
-- ==================== TRANSACCIONES ===================
-- ======================================================

/* Una transacción es una unidad única de trabajo que se ejecuta de manera independiente. Ejemplo:
   Las sentencias INSERT,UPDATE,DELETE entre otras.

  Caracteristicas:

  - Si una transaccion tiene éxito, todas las modificaciones que esta realiza se confirman y se almacenan
    de manera permanente en la BD.
 
  - Si una transacción encuentra errores y debe cancelarse o revertirse, se borran todas las modificaciones
    de los datos.

	NOTA: Cada sentencia es independiente, los errores en una no afectan a la otra, ni detienen la ejecución
	      de las demás.

    








  Tipos de transacción:

  - CONFIRMACIÓN AUTOMÁTICA: 

  --La tabla existe, la sentencia se ejecuta sin problemas y se guarda en la base de datos inmediatamente:
    
	UPDATE Shippers
	SET CompanyName = 'Asesoria BI'
	WHERE ShipperID = 20

  --Lo anterior es equivalente a esto: SQL encapsula de manera automática nuestra transacción para que se
  --almacene de manera permanente en la base de datos una vez sea ejecutada.

    BEGIN TRANSACTION
	UPDATE Shippers
	SET CompanyName = 'Asesoria BI'
	WHERE ShipperID = 20
	COMMIT TRANSACTION;

	TRANSACCIÓN IMPLICITA:

	--Se inicia implicitamente una nueva transaccion cuando se ha completado lo anterior, pero cada transaccion
	--se completa explicitamente con una instruccion COMMIT o ROLLBACK

	USE ADDC
	GO

	SET IMPLICIT_TRANSACTIONS ON; -- Se carga esta sentencia primero

	UPDATE Transportista
	SET Nombre = 'Prueba'
	WHERE TransportistaID = 20 -- Luego, al cargar esta actualizacion no se carga en la base de datos, sino,
	                           -- solo se cargan para esta Query, si abrimos una nueva Query y ejecutamos la 
							   -- tabla "Transportista" vamos a ver que la consulta no va a cargar, dado que
							   -- se ha generado un "log" o "blocking" que estará bloqueando la carga. 
							   -- Debemos utilizar ROLLBACK o COMMIT para que continue o retroceda la carga.


	TRANSACCIÓN EXPLICITA:

	--Es aquella donde se define de manera explicita el inicio y el fin de la transaccion a traves de las 
	--sentencias BEGIN TRANSACTION y COMMIT TRANSACTION (cuando finaliza sin errores) o ROLLBACK TRANSACTION
	--(cuando se presenta algun error)

 --------------------
/* Primer Ejemplo */
--------------------

--- Vamos a utilizar una transacción en un bloque. Si una sentencia es correcta y otra es incorrecta, no 
--- se carga nada.
SET IMPLICIT_TRANSACTIONS OFF; -- Se carga esta sentencia primero

BEGIN TRANSACTION
	UPDATE Transportista
	SET Nombre = 'Transportista'
	WHERE TransportistaID = 20

	UPDATE Transportista
	SET Nombre = 'Transport'
	WHERE TransportistaID = XX
COMMIT TRANSACTION

---

BEGIN TRANSACTION
	UPDATE Transportista
	SET Nombre = 'Transportista'
	WHERE TransportistaID = 20
 ROLLBACK TRANSACTION           --- Aunque este correcta la sentencia con el ROLLBACK no se ejecutara
                                --- ni se cargara.El ROLLBACK cancelara todo.

 --------------------
/* Segundo Ejemplo */
--------------------

BEGIN TRY
	BEGIN TRANSACTION
		SET NOCOUNT ON
		UPDATE Transportista
		SET Nombre_empresa = 'Transportista'
		WHERE TransportistaID = 5

		UPDATE Transportista
		SET Nombre_empresa = 'Transport'
		WHERE TransportistaID = 'XX'
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION; --ROLLBACK puede ir aca o debajo de los PRINTS
	PRINT '*******************************************************'
	PRINT '*** ERRORES EN LAS TRANSACCIONES SE APLICÓ ROLLBACK ***'
	PRINT '*******************************************************'
END CATCH
