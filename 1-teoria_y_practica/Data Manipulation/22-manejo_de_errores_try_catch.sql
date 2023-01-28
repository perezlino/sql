-- ======================================================
-- ====================== TRY CATCH =====================
-- ======================================================

/*  La construcción TRY CATCH le permite manejar excepciones en SQL Server. Para usar el 
    constructor TRY CATCH, primero se coloca un grupo de sentencias Transact-SQL que podrían 
    causar una excepción en un bloque BEGIN TRY...END TRY como sigue:

                                BEGIN TRY  
                                -- statements that may cause exceptions
                                END TRY  

    A continuación, utilice un bloque BEGIN CATCH...END CATCH inmediatamente después del bloque TRY:

                                BEGIN CATCH  
                                -- statements that handle exception
                                END CATCH  

    A continuación se ilustra una construcción TRY CATCH completa:

                                BEGIN TRY  
                                -- statements that may cause exceptions
                                END TRY 
                                BEGIN CATCH  
                                -- statements that handle exception
                                END CATCH  

    Si las sentencias entre el bloque TRY se completan sin error, las sentencias entre el bloque CATCH 
    no se ejecutarán. Sin embargo, si alguna sentencia dentro del bloque TRY causa una excepción, el 
    control se transfiere a las sentencias del bloque CATCH.

    ===================================================================================================

    ==================================
    === Funciones del bloque CATCH ===
    ==================================

    Dentro del bloque CATCH, puede utilizar las siguientes funciones para obtener información detallada 
    sobre el error producido:

    - ERROR_LINE() devuelve el número de línea en la que se ha producido la excepción.
    - ERROR_MESSAGE() devuelve el texto completo del mensaje de error generado.
    - ERROR_PROCEDURE() devuelve el nombre del stored procedure o trigger donde se produjo el error.
    - ERROR_NUMBER() devuelve el número del error que se ha producido.
    - ERROR_SEVERITY() devuelve el nivel de gravedad del error ocurrido.
    - ERROR_STATE() devuelve el número de estado del error producido.

    Tenga en cuenta que estas funciones sólo se utilizan en el bloque CATCH. Si las utiliza fuera del bloque 
    CATCH, todas estas funciones devolverán NULL.

    ===================================================================================================

    =========================================
    === Constructores TRY CATCH anidados ===
    =========================================

    Puede anidar constructores TRY CATCH dentro de otro constructor TRY CATCH. Sin embargo, tanto un bloque 
    TRY como un bloque CATCH pueden contener un TRY CATCH anidado, por ejemplo:

                                    BEGIN TRY
                                        --- statements that may cause exceptions
                                    END TRY
                                    BEGIN CATCH
                                        -- statements to handle exception
                                        BEGIN TRY
                                            --- nested TRY block
                                        END TRY
                                        BEGIN CATCH
                                            --- nested CATCH block
                                        END CATCH
                                    END CATCH

    ===================================================================================================

    ===========================================
    === Ejemplos de TRY CATCH de SQL Server ===
    ===========================================

    En primer lugar, cree un stored procedure llamado usp_divide que divida dos números:  */

    CREATE PROC usp_divide(
        @a decimal,
        @b decimal,
        @c decimal output
    ) AS
    BEGIN
        BEGIN TRY
            SET @c = @a / @b;
        END TRY
        BEGIN CATCH
            SELECT  
                ERROR_NUMBER() AS ErrorNumber,  
                ERROR_SEVERITY() AS ErrorSeverity,
                ERROR_STATE() AS ErrorState,  
                ERROR_PROCEDURE() AS ErrorProcedure,
                ERROR_LINE() AS ErrorLine,  
                ERROR_MESSAGE() AS ErrorMessage  
        END CATCH
    END
    GO

/*  En este stored procedure, colocamos la fórmula dentro del bloque TRY y llamamos a las funciones 
    ERROR_* del bloque CATCH, dentro del bloque CATCH.

    Segundo, llamamos al stored procedure usp_divide para dividir 10 entre 2:  */

    DECLARE @r decimal
    EXEC usp_divide 10, 2, @r output
    PRINT @r

--  o

    DECLARE @r decimal
    EXEC usp_divide 10, 2, @r output
    SELECT @r


-- Este es el resultado:  
-- 5

/*  Como no se produjo ninguna excepción en el bloque TRY, el stored procedure se completó en el bloque TRY.
    Tercero, intenta dividir 20 entre cero llamando al stored procedure usp_divide:  */

    DECLARE @r2 decimal
    EXEC usp_divide 10, 0, @r2 output
    PRINT @r2

/* La siguiente imagen muestra la salida:

|--------------|---------------|------------|----------------|-----------|------------------------------------|
|  ErrorNumber | ErrorSeverity | ErrorState | ErrorProcedure | ErrorLine |           ErrorMessage             |
|--------------|---------------|------------|----------------|-----------|------------------------------------|
|     8134     |	   16      |	  1     |	usp_divide   |	   8     |	Divide by zero error encountered. |
|--------------|---------------|------------|----------------|-----------|------------------------------------|


    Debido al error de división por cero que fue causado por la fórmula, el control fue pasado a la sentencia 
    dentro del bloque CATCH que devolvió la información detallada del error.


    ===================================================================================================
    ===================================================================================================

    ===================================
    === TRY CATCH con transacciones ===
    ===================================

    Dentro de un bloque CATCH, puedes probar el estado de las transacciones usando la función XACT_STATE().

    - Si la función XACT_STATE() devuelve -1, significa que hay pendiente una transacción no procesable 
      (uncommittable), deberías emitir una sentencia ROLLBACK TRANSACTION.

    - En caso de que la función XACT_STATE() devuelva 1, significa que hay pendiente una transacción procesable 
      (committable). En este caso, puede emitir una sentencia COMMIT TRANSACTION.

    - Si la función XACT_STATE() devuelve 0, significa que no hay ninguna transacción pendiente, por lo tanto, 
      no es necesario realizar ninguna acción.

    Es una buena práctica probar el estado de la transacción antes de emitir una sentencia COMMIT TRANSACTION o 
    ROLLBACK TRANSACTION en un bloque CATCH para asegurar la consistencia.


    Ejemplo de uso de TRY CATCH con transacciones
    =============================================

    En primer lugar, cree dos nuevas tablas Ventas.personas y Ventas.operaciones para la demostración:  */

CREATE TABLE Ventas.personas
(
    persona_id  INT PRIMARY KEY IDENTITY, 
    nombre NVARCHAR(100) NOT NULL, 
    apellido  NVARCHAR(100) NOT NULL
);

CREATE TABLE Ventas.operaciones
(
    operacion_id INT PRIMARY KEY IDENTITY, 
    persona_id INT NOT NULL, 
    operacion_comentario NVARCHAR(100), 
    FOREIGN KEY(persona_id) REFERENCES Ventas.personas(
    persona_id)
);

insert into 
    Ventas.personas(nombre, apellido)
values
    ('John','Doe'),
    ('Jane','Doe');

insert into 
    Ventas.operaciones(persona_id, operacion_comentario)
values
    (1,'Deal for John Doe')

--  A continuación, cree un nuevo stored procedure llamado usp_report_error que será utilizado en un 
--  bloque CATCH para reportar la información detallada de un error:

CREATE PROC usp_report_error
AS
    SELECT   
        ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        ,ERROR_LINE () AS ErrorLine  
        ,ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_MESSAGE() AS ErrorMessage;  
GO

/*  A continuación, desarrolle un nuevo stored procedure que elimine una fila de la tabla Ventas.personas: */

CREATE PROC usp_delete_person(
    @persona_id INT
) AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        -- borrar a la persona
        DELETE FROM Ventas.personas 
        WHERE persona_id = @persona_id;
        -- si DELETE tiene éxito, confirmar la transacción
        COMMIT TRANSACTION;  
    END TRY
    BEGIN CATCH
        -- informar la excepción
        EXEC usp_report_error;
        
        -- Comprobar si la transacción no se puede procesar (uncommittable).  
        IF (XACT_STATE()) = -1  
        BEGIN  
            PRINT  N'The transaction is in an uncommittable state.' +  
                    'Rolling back transaction.'  
            ROLLBACK TRANSACTION;  
        END;  
        
        -- Comprobar si la transacción es procesable (committable).  
        IF (XACT_STATE()) = 1  
        BEGIN  
            PRINT N'The transaction is committable.' +  
                'Committing transaction.'  
            COMMIT TRANSACTION;     
        END;  
    END CATCH
END;
GO


/*  En este stored procedure, utilizamos la función XACT_STATE() para comprobar el estado de la transacción 
    antes de realizar COMMIT TRANSACTION o ROLLBACK TRANSACTION dentro del bloque CATCH.

    Después de eso, llame al usp_delete_person stored procedure para borrar el id de persona 2:  */

EXEC usp_delete_person 2


/*  No se ha producido ninguna excepción.

    Por último, llame al stored procedure usp_delete_person para eliminar el id de persona 1:   */

EXEC usp_delete_person 1


/*
|-------------|---------------|------------|-----------|-------------------|---------------------------------------|
| ErrorNumber |	ErrorSeverity |	ErrorState | ErrorLine |   ErrorProcedure  |            ErrorMessage               |
|-------------|---------------|------------|-----------|-------------------|---------------------------------------|
|     547     |	      16      |	     0     |	 8     | usp_delete_person | The DELETE statement conflicted with  |
|             |               |            |           |                   | the REFERENCE constraint              |
|             |               |            |           |                   | "FK__operacion__perso__59063A47". The | 
|             |               |            |           |                   | conflict occurred in database         | 
|             |               |            |           |                   | "TiendaBicicletas", table             |
|             |               |            |           |                   | "Ventas.operaciones",                 |
|             |               |            |           |                   | column 'persona_id'.                  |
|-------------|---------------|------------|-----------|-------------------|---------------------------------------| 


    ===================================================================================================
    ===================================================================================================

    ================
    === EJEMPLOS ===
    ================ 
    */

    USE AdventureWorks2019

    -- GUID ---> NEWID() genera un ID
    SELECT NEWID() AS rowguid

    -- Revisamos la tabla Purchasing.ShipMethod
    SELECT * FROM Purchasing.ShipMethod

/*
|--------------|--------------------|----------|------------|-------------------------------------|-------------------------|
| ShipMethodID |	    Name	    | ShipBase |  ShipRate  |               rowguid	              |       ModifiedDate      |
|--------------|--------------------|----------|------------|-------------------------------------|-------------------------|
|      1       | XRQ - TRUCK GROUND	|   3,95   |    0,99	|6be756d9-d7be-4463-8f2c-ae60c710d606 |	2008-04-30 00:00:00.000 |
|      2	   | ZY - EXPRESS	    |   9,95   |	1,99	|3455079b-f773-4dc6-8f1e-2a58649c4ab8 |	2008-04-30 00:00:00.000 |
|      3	   | OVERSEAS - DELUXE	|   29,95  |	2,99	|22f4e461-28cf-4ace-a980-f686cf112ec8 |	2008-04-30 00:00:00.000 |
|      4	   | OVERNIGHT J-FAST	|   21,95  |	1,29	|107e8356-e7a8-463d-b60c-079fff467f3f |	2008-04-30 00:00:00.000 |
|      5	   | CARGO TRANSPORT 5	|   8,99   |	1,49	|b166019a-b134-4e76-b957-2b0490c610ed |	2008-04-30 00:00:00.000 |  
|--------------|--------------------|----------|------------|-------------------------------------|-------------------------|
*/

    -- Insertar en [ShipMethod]
    INSERT INTO Purchasing.ShipMethod (Name, ShipBase, ShipRate, rowguid, ModifiedDate)
    VALUES('OVERSEAS EXPRESS', NULL, 3.20, NEWID(),GETDATE())

    -- Implementación de un TRY... CATCH
    BEGIN TRY
        INSERT INTO Purchasing.ShipMethod (Name, ShipBase, ShipRate, rowguid, ModifiedDate)
        VALUES('OVERSEAS EXPRESS', NULL, 3.20, NEWID(),GETDATE())

        PRINT 'Se insertó correctamente el nuevo método de envío'

    END TRY
    BEGIN CATCH

        PRINT 'Error al insertar el nuevo método de envío'
        
    END CATCH


-- Si lo trabajamos dentro de un Stored Procedure:


    CREATE PROCEDURE uspInsertShipMethod
        @name			AS VARCHAR(50)
        ,@shipBase		AS MONEY
        ,@shipRate		AS MONEY
        ,@rowGuid		AS UNIQUEIDENTIFIER
        ,@modifiedDate	AS DATETIME
    AS
    BEGIN
        BEGIN TRY
        INSERT INTO Purchasing.ShipMethod (Name, ShipBase, ShipRate, rowguid, ModifiedDate)
        VALUES (@name, @shipBase, @shipRate, @rowGuid, @modifiedDate)

        Print 'Se insertó correctamente el nuevo método de envío'

        END TRY
        BEGIN CATCH
            Print 'Error al insertar el nuevo método de envío'	
        END CATCH
    END
    GO

-- Ejecutar SP para comprobar funcionalidad de TRY... CATCH.

DECLARE @id			AS UNIQUEIDENTIFIER 
		,@date		AS DATETIME

SELECT @id = NEWID(), @date = GETDATE()

EXEC dbo.uspInsertShipMethod 'OVERSEAS EXPRESS', NULL, 3.20, @id, @date