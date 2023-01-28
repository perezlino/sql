-- ======================================================
-- ===================== RAISERROR =====================
-- ======================================================

/*  La sentencia RAISERROR permite generar sus propios mensajes de error y devolverlos a la 
    aplicación con el mismo formato que un mensaje de error o advertencia del sistema generado 
    por el motor de base de datos de SQL Server. Además, la sentencia RAISERROR permite 
    establecer un id de mensaje (message id), un nivel de gravedad (level of severity) y un 
    estado (state) específicos para los mensajes de error.

    A continuación, se ilustra la sintaxis de la sentencia RAISERROR:

                        RAISERROR ( { message_id | message_text | @local_variable }  
                            { ,severity ,state }  
                            [ ,argument [ ,...n ] ] )  
                            [ WITH option [ ,...n ] ];


    Examinemos la sintaxis del RAISERROR para una mejor comprensión.

    ==========
    message_id
    ==========

    El message_id es un número de mensaje de error definido por el usuario almacenado en la vista de 
    catálogo sys.messages.

    Para añadir un nuevo número de mensaje de error definido por el usuario (new user-defined error 
    message number), se utiliza el stored procedure "sp_addmessage". Un número de mensaje de error 
    definido por el usuario debe ser superior a 50.000. Por defecto, la sentencia RAISERROR utiliza 
    el message_id 50.000 para lanzar un error.

    La siguiente sentencia añade un mensaje de error personalizado a la vista sys.messages:  */

    EXEC sp_addmessage 
        @msgnum = 50005, 
        @severity = 1, 
        @msgtext = 'A custom error message';

/*   Para verificar la inserción, se utiliza la siguiente consulta:  */

    SELECT    
        *
    FROM    
        sys.messages
    WHERE 
        message_id = 50005;

/*
    |------------|-------------|----------|-----------------|------------------------|
    | message_id | language_id | severity |	is_event_logged |          text          |
    |------------|-------------|----------|-----------------|------------------------|
    |    50005   |	   1033    |	 1    |	        0       | A custom error message |
    |------------|-------------|----------|-----------------|------------------------|

    Para utilizar este message_id, ejecute la sentencia RAISEERROR como se indica a continuación: */

    RAISERROR (50005,1,1)


--  Este es el resultado:

    A custom error message
    Msg 50005, Level 1, State 1


/*  Para eliminar un mensaje de sys.messages, se utiliza el stored procedure sp_dropmessage. Por ejemplo, 
    la siguiente sentencia elimina el id de mensaje 50005:  */

    EXEC sp_dropmessage 
        @msgnum = 50005;  

/*
    ===================================================================================================

    ============
    message_text
    ============

    "message_text" es un mensaje definido por el usuario con un formato similar al de la función printf de 
    la biblioteca estándar de C. El "message_text" puede tener hasta 2.047 caracteres, los 3 últimos 
    caracteres se reservan para elipsis (...). Si "message_text" contiene 2048 caracteres o más, se 
    truncará y se rellenará con una elipsis.

    Cuando se especifica "message_text", la sentencia RAISERROR utiliza message_id 50000 para lanzar el 
    mensaje de error.

    El siguiente ejemplo utiliza la sentencia RAISERROR para lanzar un error con un "message_text": */

    RAISERROR ('Se ha producido un error',1,1)


--  El resultado será el siguiente:

    Se ha producido un error.
    Msg 50000, Level 1, State 1


/*
    ===================================================================================================

    ========
    severity
    ========

    El nivel de severity (gravedad) es un número entero comprendido entre 0 y 25, y cada nivel representa 
    la gravedad del error.  */

    0–10 Informational messages
    11–18 Errors
    19–25 Fatal errors

/*
    ===================================================================================================

    =====
    state
    =====

    El state es un número entero de 0 a 255. Si genera el mismo error definido por el usuario en varias 
    ubicaciones, puede utilizar un número de state único para cada ubicación para que sea más fácil 
    encontrar qué sección del código está causando los errores. Para la mayoría de las implementaciones, 
    puede utilizar 1.

    WITH option

    La opción puede ser LOG, NOWAIT o SETERROR:

    - WITH LOG: registra el error en el log de errores y en el log de la aplicación para la instancia del 
                motor de base de datos SQL Server.

    - WITH NOWAIT: envía el mensaje de error al cliente inmediatamente.

    - WITH SETERROR: establece los valores ERROR_NUMBER y @@ERROR en message_id o 50000, independientemente 
                     del nivel de severidad (severity level).

/*
    ===================================================================================================

    Ejemplos de RAISERROR en SQL Server
    ===================================

    Veamos algunos ejemplos de uso de la sentencia RAISERROR para comprenderla mejor.


    A) RAISERROR con el bloque TRY CATCH
    ====================================

    En este ejemplo, usamos RAISERROR dentro de un bloque TRY para causar que la ejecución salte al bloque 
    CATCH asociado. Dentro del bloque CATCH, usamos el RAISERROR para devolver la información del error que 
    invocó al bloque CATCH.  */

    DECLARE 
        @ErrorMessage  NVARCHAR(4000), 
        @ErrorSeverity INT, 
        @ErrorState    INT;

    BEGIN TRY
        RAISERROR('Se ha producido un error en el bloque TRY.', 17, 1);
    END TRY
    BEGIN CATCH
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(), 
            @ErrorSeverity = ERROR_SEVERITY(), 
            @ErrorState = ERROR_STATE();

        -- devuelve el error dentro del bloque CATCH
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;


--   Este es el resultado:

    Msg 50000, Level 17, State 1, Line 16
    Se ha producido un error en el bloque TRY.



/*  B) Uso de la sentencia RAISERROR con un ejemplo de dynamic message text 
    =======================================================================

    El siguiente ejemplo muestra cómo usar una variable local para proporcionar el "message text" para 
    una sentencia RAISERROR:   */

    DECLARE @MessageText NVARCHAR(100);
    SET @MessageText = N'No se puede eliminar el pedido de cliente %s';

    RAISERROR(
        @MessageText, -- Message text
        16, -- severity
        1, -- state
        N'2001' -- primer argumento del message text
    );


--  El resultado es el siguiente:

    Msg 50000, Level 16, State 1, Line 5
    Cannot delete the sales order 2001


/*  Cuándo utilizar la sentencia RAISERROR
    ======================================

    La sentencia RAISERROR se utiliza en los siguientes escenarios:

    - Solucionar problemas de código Transact-SQL.
    - Devolver mensajes que contengan texto variable.
    - Examinar los valores de los datos.
    - Hacer que la ejecución salte de un bloque TRY al bloque CATCH asociado.
    - Devolver información de error desde el bloque CATCH a los callers, ya sea el calling batch o la aplicación.