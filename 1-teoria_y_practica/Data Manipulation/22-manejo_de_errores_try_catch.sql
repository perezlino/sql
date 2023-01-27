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
    === Construcciones TRY CATCH anidadas ===
    =========================================

    Puede anidar construcciones TRY CATCH dentro de otra construcción TRY CATCH. Sin embargo, tanto un bloque 
    TRY como un bloque CATCH pueden contener un TRY CATCH anidado, por ejemplo:

    