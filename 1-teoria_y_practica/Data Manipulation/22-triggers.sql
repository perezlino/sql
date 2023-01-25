-- ======================================================
-- ======================= TRIGGERS =====================
-- ======================================================

/* Es un tipo de procedimiento almacenado que se ejecuta automáticamente en respuesta a un evento en la
 base de datos.

  Caracteristicas:

  - Un trigger puede ser invocado en respuesta a un INSERT, UPDATE o DELETE
  - Un trigger puede ser invocado en respuesta a una sentencia ALTER, CREATE o DROP
  - Un trigger puede ser invocado en respuesta a un evento de login.   

-- ============================================================================================
-- ============================================================================================                    

-- ==================================
-- === FOR o AFTER (son lo mismo) ===
-- ==================================

  Introducción a la sentencia CREATE TRIGGER de SQL Server
  =========================================================

  La sentencia CREATE TRIGGER permite crear un nuevo disparador que se activa automáticamente cada vez 
  que se produce un evento como INSERT, DELETE o UPDATE en una tabla.

  A continuación se ilustra la sintaxis de la sentencia CREATE TRIGGER:

								CREATE TRIGGER [schema_name.]trigger_name
								ON table_name
								FOR o AFTER {[INSERT],[UPDATE],[DELETE]}
								[NOT FOR REPLICATION]
								AS
								{sql_statements}

  En esta sintaxis:

  - "schema_name" es el nombre del esquema al que pertenece el nuevo trigger. El nombre del esquema es opcional.
  - "trigger_name" es el nombre definido por el usuario para el nuevo trigger.
  - "table_name" es la tabla a la que se aplica el trigger.

  - El evento se indica en la cláusula AFTER. El evento puede ser INSERT, UPDATE o DELETE. Un trigger puede 
    dispararse en respuesta a una o más acciones sobre la tabla.

  - La opción NOT FOR REPLICATION indica a SQL Server que no dispare el trigger cuando se modifiquen los datos 
    como parte de un proceso de replicación.

  - "sql_statements" es uno o más Transact-SQL utilizados para llevar a cabo acciones una vez que se produce un 
    evento.


	Tablas "virtuales" para triggers: INSERTED y DELETED
	=====================================================

   SQL Server proporciona dos tablas virtuales que están disponibles específicamente para triggers llamadas 
   tablas INSERTED y DELETED. SQL Server utiliza estas tablas para capturar los datos de la fila modificada 
   antes y después de que se produzca el evento.

   La siguiente tabla muestra el contenido de las tablas INSERTED y DELETED antes y después de cada evento:

   |----------|---------------------------------------|-------------------------------------------|
   |Evento DML|        INSERTED table contiene        |           DELETED table contiene          |
   |----------|---------------------------------------|-------------------------------------------|
   |  INSERT  |            filas a insertar           |                  vacía                    |
   |  UPDATE  |nuevas filas modificadas por el update |filas existentes modificadas por el update |	
   |  DELETE  |                 vacía                 |             filas a eliminar              |
   |----------|---------------------------------------|-------------------------------------------| 


   Ejemplo de CREATE TRIGGER en SQL Server
   =======================================

   Veamos un ejemplo de creación de un nuevo trigger. Utilizaremos la tabla production.products de la base de 
   datos de ejemplo para la demostración.
   
   |-------------------|
   |production.products|
   |-------------------|
   |   * product_id    |
   |    product_name   |
   |      brand_id     |
   |    category_id    |
   |    model_year     |
   |    list_price     |
   |-------------------|
   
   1) Crear una tabla para registrar los cambios

   La siguiente sentencia crea una tabla llamada production.product_audits para registrar información cuando se 
   produce un evento INSERT o DELETE en la tabla production.products:  */

   CREATE TABLE production.product_audits(
    change_id INT IDENTITY PRIMARY KEY,
    product_id INT NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    brand_id INT NOT NULL,
    category_id INT NOT NULL,
    model_year SMALLINT NOT NULL,
    list_price DEC(10,2) NOT NULL,
    updated_at DATETIME NOT NULL,
    operation CHAR(3) NOT NULL,
    CHECK(operation = 'INS' or operation='DEL')
   )

/* La tabla production.product_audits tiene todas las columnas de la tabla production.products. Además, tiene 
   algunas columnas más para registrar los cambios, por ejemplo, updated_at, operation y change_id.


   2) Creación de un trigger DML AFTER

   En primer lugar, para crear un nuevo trigger, especifique el nombre del trigger y el schema al que pertenece 
   el trigger en la cláusula CREATE TRIGGER:   */

   CREATE TRIGGER production.trg_product_audit

-- A continuación, especifique en la cláusula ON el nombre de la tabla que activará el trigger cuando se 
-- produzca un evento: 

   ON production.products

-- A continuación, indique el evento o eventos que activarán el trigger en la cláusula AFTER:

   AFTER INSERT, DELETE

-- El cuerpo del trigger comienza con la palabra clave AS:

   AS
   BEGIN

-- Después, dentro del cuerpo del trigger, se pone SET NOCOUNT a ON para suprimir el número de filas afectadas 
-- de los mensajes que se devuelven cada vez que se dispara el trigger.

  SET NOCOUNT ON

-- El trigger insertará una fila en la tabla production.product_audits cada vez que se inserte o elimine una 
-- fila de la tabla production.products. Los datos para la inserción se obtienen de las tablas INSERTED y 
-- DELETED mediante el operador UNION ALL:

INSERT INTO
    production.product_audits
        (
            product_id,
            product_name,
            brand_id,
            category_id,
            model_year,
            list_price,
            updated_at,
            operation
        )
SELECT
    i.product_id,
    product_name,
    brand_id,
    category_id,
    model_year,
    i.list_price,
    GETDATE(),
    'INS'
FROM
    inserted AS i
UNION ALL
    SELECT
        d.product_id,
        product_name,
        brand_id,
        category_id,
        model_year,
        d.list_price,
        getdate(),
        'DEL'
    FROM
        deleted AS d

-- A continuación se reúnen todas las partes:

CREATE TRIGGER production.trg_product_audit
ON production.products
AFTER INSERT, DELETE
AS
BEGIN
    SET NOCOUNT ON
    INSERT INTO production.product_audits(
        product_id, 
        product_name,
        brand_id,
        category_id,
        model_year,
        list_price, 
        updated_at, 
        operation
    )
    SELECT
        i.product_id,
        product_name,
        brand_id,
        category_id,
        model_year,
        i.list_price,
        GETDATE(),
        'INS'
    FROM
        inserted i
    UNION ALL
    SELECT
        d.product_id,
        product_name,
        brand_id,
        category_id,
        model_year,
        d.list_price,
        GETDATE(),
        'DEL'
    FROM
        deleted d
END


-- 3) Prueba del trigger

-- La siguiente sentencia inserta una nueva fila en la tabla production.products:

INSERT INTO production.products(
    product_name, 
    brand_id, 
    category_id, 
    model_year, 
    list_price
)
VALUES (
    'Test product',
    1,
    1,
    2018,
    599
)

-- Debido al evento INSERT, se disparó el trigger production.trg_product_audit de la tabla production.products.
-- Examinemos el contenido de la tabla production.product_audits:

SELECT * 
FROM production.product_audits

-- |---------|----------|------------|--------|-----------|----------|----------|------------------------|---------|
-- |change_id|product_id|product_name|brand_id|category_id|model_year|list_price|        updated_at      |operation|
-- |---------|----------|------------|--------|-----------|----------|----------|------------------------|---------|
-- |    1    |    322   |Test product|   1    |     1     |   2018   |  599.00  |2018-10-14 15:23:46.837 |   INS   |
-- |---------|----------|------------|--------|-----------|----------|----------|------------------------|---------|

-- La siguiente sentencia elimina una fila de la tabla production.products:

DELETE FROM production.products
WHERE product_id = 322

-- Como era de esperar, el trigger se disparó e insertó la fila eliminada en la tabla production.product_audits:

-- |---------|----------|------------|--------|-----------|----------|----------|------------------------|---------|
-- |change_id|product_id|product_name|brand_id|category_id|model_year|list_price|        updated_at      |operation|
-- |---------|----------|------------|--------|-----------|----------|----------|------------------------|---------|
-- |    1    |    322   |Test product|   1    |     1     |   2018   |  599.00  |2018-10-14 15:23:46.837 |   INS   |
-- |    2    |    322   |Test product|   1    |     1     |   2018   |  599.00  |2018-10-14 15:26:34.050 |   DEL   |  
-- |---------|----------|------------|--------|-----------|----------|----------|------------------------|---------|

/*
   ============================================================================================
   ============================================================================================

   Introducción a las sentencias DROP TRIGGER de SQL Server
   ========================================================

   La secuencia DROP TRIGGER de SQL Server elimina uno o varios triggers de la base de datos. 
   A continuación, se ilustra la sintaxis de la secuencia DROP TRIGGER que elimina los 
   desencadenadores DML:

					DROP TRIGGER [ IF EXISTS ] [schema_name.]trigger_name [ ,...n ]

   En esta sintaxis:

   - IF EXISTS elimina condicionalmente el trigger sólo cuando ya existe.
   - "schema_name" es el nombre del schema al que pertenece el trigger DML.
   - "trigger_name" es el nombre del trigger que desea eliminar.

   Si desea eliminar varios trigger a la vez, deberá separarlos mediante comas. Para eliminar uno o 
   varios triggers DDL, utilice la siguiente forma de la sentencia DROP TRIGGER:

					DROP TRIGGER [ IF EXISTS ] trigger_name [ ,...n ]   
					ON { DATABASE | ALL SERVER };

   En esta sintaxis:

   - DATABASE indica que el alcance del trigger DDL se aplica a la base de datos actual.
   - ALL SERVER indica que el ámbito del trigger DDL se aplica al servidor actual.

   Para eliminar un trigger de evento LOGON, utilice la siguiente sintaxis:

					DROP TRIGGER [ IF EXISTS ] trigger_name [ ,...n ]   
					ON ALL SERVER;


   Ejemplos de DROP TRIGGER en SQL Server
   ======================================

   A) SQL Server DROP TRIGGER - ejemplo de eliminación de un trigger DML

   La siguiente sentencia elimina un trigger DML llamado sales.trg_member_insert:

   					DROP TRIGGER IF EXISTS sales.trg_member_insert;
	

	B) SQL Server DROP TRIGGER - ejemplo de eliminación de un trigger DDL

    La siguiente sentencia elimina el trigger trg_index_changes:

					DROP TRIGGER IF EXISTS trg_index_changes; */

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 1

-- Vamos a comenzar creando dos tablas
CREATE TABLE Personas(
	Id INT IDENTITY (1,1),
	Nombre VARCHAR(40),
	Apellido VARCHAR(40),
	FechaNacimiento DATE
)

CREATE TABLE PersonasT(
	Nombre VARCHAR(40),
	Apellido VARCHAR(40),
	NombreApellido VARCHAR(100),
	Correo VARCHAR(100),
	Edad INT,
	Load_Date DATE
)

-- Cuando yo inserte datos en la tabla "Personas" este Trigger se va a activar
CREATE OR ALTER TRIGGER tr_InsertarPersonas
ON Personas
FOR INSERT 
AS
BEGIN
		SET NOCOUNT ON; --Para esconder los mensajes
		INSERT INTO PersonasT
		SELECT TOP 1 P.Nombre, 
		             P.Apellido,
					 dbo.FN_Concatenar(P.Nombre, P.Apellido, ' '), 
					 dbo.FN_Correo(P.Nombre, P.Apellido),
					 dbo.FN_Edad(P.FechaNacimiento),
					 GETDATE()
		FROM Personas P
		ORDER BY P.Id DESC
END

INSERT INTO Personas VALUES ('Andres', 'Espinoza', '1996-12-10') -- Cargamos esta insercion en la tabla  "Personas"
INSERT INTO Personas VALUES ('Alfonso', 'Perez', '1986-03-06')


SELECT * FROM PersonasT

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 2

-- Crear un Log que permita identificar un usuario
-- Cuando yo elimine datos en la tabla "Transportista" este Trigger se va a activar

CREATE OR ALTER TRIGGER log_transactions
ON Transportista
AFTER DELETE
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO Log_Activity(Usuario, Tabla, Descripcion, Fecha_edicion)
	VALUES (SYSTEM_USER, 'Transportista', 'Delete', GETDATE())

END
--
DELETE FROM Transportista
WHERE TransportistaID > 3

SELECT * FROM Log_Activity

-- ============================================================================================

/* DESHABILITANDO UN TRIGGER */
DISABLE TRIGGER log_transactions ON Transportista
 
 /* ELIMINANDO UN TRIGGER */
 DROP TRIGGER IF EXISTS log_transactions

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 3
 
--Vamos a crear una tabla
CREATE TABLE PersonasU(
Nombre VARCHAR(40),
Apellido VARCHAR(40),
FechaNacimiento DATE,
FechaModificacion DATE,
ActionPeformed VARCHAR(50)
)

CREATE OR ALTER TRIGGER tr_UpdatePersonas 
ON Personas
AFTER UPDATE 
AS 
DECLARE @Nombre VARCHAR(50), 
        @Apellido VARCHAR(50),
        @FechaNacimiento DATE,
	    @ActionPeformed VARCHAR(50)

--Aca podemos utilizar SET o SELECT, van a cumplir la misma función. Aqui lo que se hace es dar el valor a
--la variable, con el valor que se va a utilizar para actualizar. Se utiliza "INSERTED" para indicar este
--proceso.

SELECT @Nombre = ins.Nombre FROM INSERTED ins;
SELECT @Apellido = ins.Apellido FROM INSERTED ins;
SELECT @FechaNacimiento = ins.FechaNacimiento FROM INSERTED ins;

IF UPDATE(FechaNacimiento)
BEGIN
     SET @ActionPeformed = 'Updated Fecha Nacimiento'
END

IF UPDATE(Nombre)
BEGIN
      SET @ActionPeformed = 'Updated Nombre'
END

INSERT INTO PersonasU VALUES (@Nombre, @Apellido, @FechaNacimiento, GETDATE(), @ActionPeformed)

PRINT 'We Successfully Fired the Second AFTER UPDATE Triggers in SQL Server.'
GO

SELECT * FROM Personas

UPDATE Personas
SET FechaNacimiento = '1990-01-01'
WHERE Id = 2

SELECT * FROM PersonasU

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 4

SELECT * FROM ADDC.dbo.Transportista;

SELECT * FROM Shippers

CREATE OR ALTER TRIGGER TR_respaldoTransportista
ON Shippers
AFTER INSERT --Tambien puede ser FOR INSERT cumplen la misma función
AS
BEGIN
INSERT INTO ADDC.dbo.Transportista
SELECT TOP (1) *
FROM Shippers
ORDER BY ShipperID DESC   -- Voy a traer siempre el útlimo registro con TOP 1 y ORDER BY DESC
END

INSERT INTO Shippers (CompanyName,Phone)
VALUES ('Asesoria BI','(569)30375660')

INSERT INTO Shippers (CompanyName,Phone)
VALUES ('Datawalt','(569)64025330')