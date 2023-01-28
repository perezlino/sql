-- ======================================================
-- ======================== THROW =======================
-- ======================================================

/*  La sentencia THROW lanza una excepción y transfiere la ejecución a un bloque CATCH de 
    un constructor TRY CATCH.

    A continuación, se ilustra la sintaxis de la sentencia THROW:

                                THROW [ error_number ,  
                                        message ,  
                                        state ];

    En esta sintaxis:

    error_number
    ============

    "error_number" es un número entero que representa la excepción. "error_number" debe ser mayor que 
    50.000 y menor o igual que 2.147.483.647.

    message
    =======

    "message" es una cadena de tipo NVARCHAR(2048) que describe la excepción.

    state
    =====

    "state" es un TINYINT con un valor entre 0 y 255. "state" indica el estado asociado al 'message'.


    ===================================================================================================

    Si no especifica ningún parámetro para la sentencia THROW, debe colocar la sentencia THROW dentro de 
    un bloque CATCH:

                                        BEGIN TRY
                                            -- statements that may cause errors
                                        END TRY
                                        BEGIN CATCH
                                            -- statement to handle errors 
                                            THROW;   
                                        END CATCH


    En este caso, la sentencia THROW lanza el error que fue capturado por el bloque CATCH.

    Tenga en cuenta que la sentencia que precede a la sentencia THROW debe terminar con un punto y coma (;).


    ===================================================================================================

    ===========================
    === THROW vs. RAISERROR ===
    ===========================

    La siguiente tabla ilustra la diferencia entre las sentencias THROW y RAISERROR:

    |--------------------------------------------------|---------------------------------------------------|
    |                     RAISERROR                    |                      THROW                        |
    |--------------------------------------------------|---------------------------------------------------|
    | El "message_id" que pases a RAISERROR debe estar | El parámetro "error_number" no tiene que estar    |
    | definido en la vista sys.messages.	           | definido en la vista sys.messages.                |
    |--------------------------------------------------|---------------------------------------------------|
    | El parámetro "message" puede contener estilos de | El parámetro "message" no acepta estilos de       |
    | formato printf como %s y %d.                     | formato printf. Utilice la función FORMATMESSAGE()| 
    |                                                  | para sustituir los parámetros.                    |
    |--------------------------------------------------|---------------------------------------------------|
    | El parámetro "severity" indica la gravedad de la | La gravedad de la excepción (severity of the      |
    | excepción.	                                   | exception) siempre se establece en 16.            |
    |--------------------------------------------------|---------------------------------------------------|


    ===================================================================================================

    ============================================
    Ejemplos de la sentencia THROW de SQL Server
    ============================================

    Veamos algunos ejemplos de uso de la sentencia THROW para entenderla mejor.


    A) Uso de la sentencia THROW para lanzar una excepción
    ------------------------------------------------------

    El siguiente ejemplo usa la sentencia THROW para lanzar una excepción: */

    THROW 50005, N'Ha ocurrido un error', 1;


--  Este es el resultado:

    Msg 50005, Level 16, State 1, Line 1
    An error occurred


--  B) Uso de la sentencia THROW para volver a lanzar una excepción
    ---------------------------------------------------------------

--  En primer lugar, cree una nueva tabla t1 para la demostración:

    CREATE TABLE t1(
        id int primary key
    );
    GO

--  A continuación, utilice la sentencia THROW sin argumentos en el bloque CATCH para volver a 
--  lanzar el error capturado:

    BEGIN TRY
        INSERT INTO t1(id) VALUES(1);
        -- causa error
        INSERT INTO t1(id) VALUES(1);
    END TRY
    BEGIN CATCH
        PRINT('Volver a lanzar el error detectado');
        THROW;
    END CATCH

--  Este es el resultado:

    (1 row affected)

    (0 rows affected)
    Volver a lanzar el error detectado
    Msg 2627, Level 14, State 1, Line 10
    Violation of PRIMARY KEY constraint 'PK__t1__3213E83F906A55AA'. Cannot insert duplicate key in object 'dbo.t1'. 
    The duplicate key value is (1).


/*  En este ejemplo, la primera sentencia INSERT tuvo éxito. Sin embargo, la segunda falla debido a la 
    restricción de clave primaria. Por lo tanto, el error fue capturado por el bloque CATCH fue levantado 
    de nuevo por la sentencia THROW.


    C) Uso de la sentencia THROW para volver a lanzar una excepción
    ---------------------------------------------------------------

    A diferencia de la sentencia RAISERROR, la sentencia THROW no permite sustituir parámetros en el 
    "message text". Por lo tanto, para imitar esta función, se utiliza la función FORMATMESSAGE().

    La siguiente sentencia añade un mensaje personalizado a la vista de catálogo sys.messages:  */

    EXEC sys.sp_addmessage 
        @msgnum = 50010, 
        @severity = 16, 
        @msgtext =
        N'El número de pedido %s no se puede eliminar porque no existe.', 
        @lang = 'us_english';   
    GO


--  Esta sentencia utiliza el "message_id" 50010 y sustituye el marcador de posición %s por un order id '1001':

    DECLARE @MessageText NVARCHAR(2048);
    SET @MessageText =  FORMATMESSAGE(50010, N'1001');   

    THROW 50010, @MessageText, 1; 

--  Este es el resultado:

    Msg 50010, Level 16, State 1, Line 8
    The order number 1001 cannot be deleted because it does not exist.