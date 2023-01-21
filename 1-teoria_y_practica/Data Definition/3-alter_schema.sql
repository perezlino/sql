-- ======================================================
-- ==================== ALTER SCHEMA ====================
-- ======================================================

/* La sentencia ALTER SCHEMA permite transferir un securable de un esquema a otro dentro 
   de la misma base de datos.

   Tenga en cuenta que un securable es un recurso al que el sistema de autorización del motor 
   de base de datos controla el acceso. Por ejemplo, una tabla es un securable.

   A continuación se muestra la sintaxis de la sentencia ALTER SCHEMA:

                            ALTER SCHEMA target_schema_name   
                                TRANSFER [ entity_type :: ] securable_name

   En esta sintaxis:

   - "target_schema_name" es el nombre de un esquema de la base de datos actual, al que desea 
     mover el objeto. Tenga en cuenta que no puede ser SYS ni INFORMATION_SCHEMA.

   - El "entity_type" puede ser Object, Type o XML Schema Collection. Por defecto es Object. 
     entity_type representa la clase de la entidad cuyo propietario se está cambiando.

   - "object_name" es el nombre del securable que desea mover al target_schema_name.

   Si mueve un stored procedure, una función, una vista o un trigger, SQL Server no cambiará el 
   nombre de esquema de estos securables. Por lo tanto, se recomienda que elimine y vuelva a crear 
   estos objetos en el nuevo esquema en lugar de utilizar la sentencia ALTER SCHEMA para moverlos.

   Si mueve un object, por ejemplo, una tabla o un synonym, SQL Server no actualizará las referencias 
   de estos objetos automáticamente. Deberá modificar manualmente las referencias para que reflejen 
   el nuevo nombre del esquema. Por ejemplo, si mueve una tabla a la que se hace referencia en un 
   stored procedure, debe modificar el stored procedure para que refleje el nuevo nombre del esquema.


   Ejemplo de ALTER SCHEMA de SQL Server
   =====================================

   Primero, cree una nueva tabla llamada offices en el schema dbo:   */

CREATE TABLE dbo.offices
(
    office_id      INT
    PRIMARY KEY IDENTITY, 
    office_name    NVARCHAR(40) NOT NULL, 
    office_address NVARCHAR(255) NOT NULL, 
    phone          VARCHAR(20),
)

-- A continuación, inserte algunas filas en la tabla dob.offices:

INSERT INTO 
    dbo.offices(office_name, office_address)
VALUES
    ('Silicon Valley','400 North 1st Street, San Jose, CA 95130'),
    ('Sacramento','1070 River Dr., Sacramento, CA 95820')

-- A continuación, cree un stored procedure que busque la oficina por el office id:

CREATE PROC usp_get_office_by_id(
    @id INT
) AS
BEGIN
    SELECT 
        * 
    FROM 
        dbo.offices
    WHERE 
        office_id = @id
END


-- A continuación, transfiera esta tabla dbo.offices al [Sales] schema:

ALTER SCHEMA Sales TRANSFER OBJECT::dbo.offices


-- Si ejecuta el stored procedure usp_get_office_by_id, SQL Server emitirá un error:

Msg 208, Level 16, State 1, Procedure usp_get_office_by_id, Line 5 [Batch Start Line 30]
Invalid object name 'dbo.offices'.

-- Por último, modifique manualmente el stored procedure para reflejar el nuevo schema:

ALTER PROC usp_get_office_by_id(
    @id INT
) AS
BEGIN
    SELECT 
        * 
    FROM 
        Sales.offices
    WHERE 
        office_id = @id;
END