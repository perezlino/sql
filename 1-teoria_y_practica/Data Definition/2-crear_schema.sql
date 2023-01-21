-- ======================================================
-- ==================== CREAR SCHEMA ====================
-- ======================================================

/* ¿Qué es un esquema en SQL Server?
   =================================

   Un esquema es una colección de objetos de base de datos que incluye tablas, vistas, triggers, 
   procedimientos almacenados, índices, etc. Un esquema está asociado a un nombre de usuario que 
   se conoce como propietario del esquema, que es el propietario de los objetos de base de datos 
   relacionados lógicamente.

   Un esquema siempre pertenece a una base de datos. Por otra parte, una base de datos puede tener 
   uno o varios esquemas. Por ejemplo, en la base de datos de AdventureWorks2019, tenemos varios 
   esquemas: HumanResources, Person, Production, Purchasing y Sales. Un objeto dentro de un esquema 
   se califica utilizando el formato schema_name.object_name como Sales.SalesOrderHeader. Dos tablas 
   en dos esquemas pueden compartir el mismo nombre, por lo que puede tener HumanResources.Employee 
   y Sales.Employee.


   Esquemas incorporados en SQL Server (Built-in schemas in SQL Server)
   ====================================================================

   SQL Server nos proporciona algunos esquemas predefinidos que tienen los mismos nombres que los 
   usuarios y roles incorporados en la base de datos, por ejemplo: dbo, guest, sys e INFORMATION_SCHEMA.

   Tenga en cuenta que SQL Server reserva los esquemas sys e INFORMATION_SCHEMA para objetos de 
   sistema, por lo que no podrá crear ni soltar ningún objeto en estos esquemas.

   El esquema predeterminado para una base de datos recién creada es dbo, que pertenece a la cuenta de 
   usuario dbo. Por defecto, cuando se crea un nuevo usuario con el comando CREATE USER, el usuario 
   tomará dbo como su esquema por defecto.


   Visión general de la sentencia CREATE SCHEMA de SQL Server
   ==========================================================

   La sentencia CREATE SCHEMA permite crear un nuevo esquema en la base de datos actual.

   A continuación se ilustra la versión simplificada de la sentencia CREATE SCHEMA:

                                CREATE SCHEMA schema_name
                                    [AUTHORIZATION owner_name]

   En esta sintaxis:

   - En primer lugar, especifique el nombre del esquema que desea crear en la cláusula CREATE SCHEMA.
   - En segundo lugar, especifique el propietario del esquema después de la palabra clave AUTHORIZATION.


   Ejemplo de sentencia CREATE SCHEMA de SQL Server
   ================================================

   El siguiente ejemplo muestra cómo utilizar la sentencia CREATE SCHEMA para crear el esquema 
   customer_services:    */

CREATE SCHEMA customer_services
GO


/* Tenga en cuenta que el comando GO indica a SQL Server Management Studio que envíe las sentencias SQL 
   hasta la sentencia GO al servidor para su ejecución.

   Si desea listar todos los esquemas de la base de datos actual, puede consultar los esquemas desde 
   sys.schemas como se muestra en la siguiente consulta:    */

SELECT 
    s.name AS schema_name, 
    u.name AS schema_owner
FROM 
    sys.schemas s
INNER JOIN sys.sysusers u ON u.uid = s.principal_id
ORDER BY 
    s.name

/* Después de tener el esquema customer_services, puede crear objetos para el esquema. Por ejemplo, la 
   siguiente sentencia crea una nueva tabla llamada jobs en el esquema customer_services:   */

CREATE TABLE customer_services.jobs(
    job_id INT PRIMARY KEY IDENTITY,
    customer_id INT NOT NULL,
    description VARCHAR(200),
    created_at DATETIME2 NOT NULL
)