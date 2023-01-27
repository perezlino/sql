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
   |----------|---------------------------------------|-------------------------------------------| */

   USE TiendaBicicletas

/*

   Ejemplo de CREATE TRIGGER en SQL Server
   =======================================

   Veamos un ejemplo de creación de un nuevo trigger. Utilizaremos la tabla Produccion.productos de la base de 
   datos de ejemplo para la demostración.
   
   |--------------------|
   |Produccion.productos|
   |--------------------|
   |   * producto_id    |
   |   producto_nombre  |
   |      marca_id      |
   |    categoria_id    |
   |     ano modelo     |
   |   precio_catalogo  |
   |--------------------|
   
   1) Crear una tabla para registrar los cambios

   La siguiente sentencia crea una tabla llamada Produccion.AuditoriasProducto para registrar información cuando se 
   produce un evento INSERT o DELETE en la tabla Produccion.productos:  */

CREATE TABLE Produccion.AuditoriasProducto(
modificacion_id INT IDENTITY PRIMARY KEY,
producto_id INT NOT NULL,
producto_nombre VARCHAR(255) NOT NULL,
marca_id INT NOT NULL,
categoria_id INT NOT NULL,
ano_modelo SMALLINT NOT NULL,
precio_catalogo DEC(10,2) NOT NULL,
actualizado_a DATETIME NOT NULL,
operacion CHAR(3) NOT NULL,
CHECK(operacion = 'INS' or operacion='DEL')
)

/* La tabla Produccion.AuditoriasProducto tiene todas las columnas de la tabla Produccion.productos. Además, tiene 
   algunas columnas más para registrar los cambios, por ejemplo, actualizado_a, operacion y modificacion_id.


   2) Creación de un trigger DML AFTER

   En primer lugar, para crear un nuevo trigger, especifique el nombre del trigger y el schema al que pertenece 
   el trigger en la cláusula CREATE TRIGGER:   */

   CREATE TRIGGER Produccion.trg_auditoria_producto

/*
A continuación, especifique en la cláusula ON el nombre de la tabla que activará el trigger cuando se 
produzca un evento:  */

   ON Produccion.productos

/* A continuación, indique el evento o eventos que activarán el trigger en la cláusula AFTER: */

   AFTER INSERT, DELETE

-- El cuerpo del trigger comienza con la palabra clave AS:

   AS
   BEGIN

-- Después, dentro del cuerpo del trigger, se pone SET NOCOUNT a ON para suprimir el número de filas afectadas 
-- de los mensajes que se devuelven cada vez que se dispara el trigger.

  SET NOCOUNT ON

-- El trigger insertará una fila en la tabla Produccion.AuditoriasProducto cada vez que se inserte o elimine una 
-- fila de la tabla Produccion.productos. Los datos para la inserción se obtienen de las tablas INSERTED y 
-- DELETED mediante el operador UNION ALL:

INSERT INTO
    Produccion.AuditoriasProducto
        (
            producto_id,
            producto_nombre,
            marca_id,
            categoria_id,
            ano_modelo,
            precio_catalogo,
            actualizado_a,
            operacion
        )
SELECT
    i.producto_id,
    producto_nombre,
    marca_id,
    categoria_id,
    ano_modelo,
    i.precio_catalogo,
    GETDATE(),
    'INS'
FROM
    inserted AS i
UNION ALL
    SELECT
        d.producto_id,
        producto_nombre,
        marca_id,
        categoria_id,
        ano_modelo,
        d.precio_catalogo,
        GETDATE(),
        'DEL'
    FROM
        deleted AS d

-- A continuación se reúnen todas las partes:

CREATE TRIGGER Produccion.trg_auditoria_producto
ON Produccion.productos
AFTER INSERT, DELETE
AS
BEGIN
    SET NOCOUNT ON
    INSERT INTO Produccion.AuditoriasProducto(
        producto_id, 
        producto_nombre,
        marca_id,
        categoria_id,
        ano_modelo,
        precio_catalogo, 
        actualizado_a, 
        operacion
    )
    SELECT
        i.producto_id,
        producto_nombre,
        marca_id,
        categoria_id,
        ano_modelo,
        i.precio_catalogo,
        GETDATE(),
        'INS'
    FROM
        inserted i
    UNION ALL
    SELECT
        d.producto_id,
        producto_nombre,
        marca_id,
        categoria_id,
        ano_modelo,
        d.precio_catalogo,
        GETDATE(),
        'DEL'
    FROM
        deleted d
END


-- 3) Prueba del trigger

-- La siguiente sentencia inserta una nueva fila en la tabla Produccion.productos:

INSERT INTO Produccion.productos(
    producto_nombre, 
    marca_id, 
    categoria_id, 
    ano_modelo, 
    precio_catalogo
)
VALUES (
    'Test product',
    1,
    1,
    2018,
    599
)

-- Debido al evento INSERT, se disparó el trigger Produccion.trg_auditoria_producto de la tabla Produccion.productos.
-- Examinemos el contenido de la tabla Produccion.AuditoriasProducto:

SELECT * 
FROM Produccion.AuditoriasProducto

-- |---------------|-----------|---------------|--------|------------|----------|---------------|------------------------|---------|
-- |modificacion_id|producto_id|producto_nombre|marca_id|categoria_id|ano_modelo|precio_catalogo|      actualizado_a     |operation|
-- |---------------|-----------|---------------|--------|------------|----------|---------------|------------------------|---------|
-- |       1       |    322    | Test product  |   1    |      1     |   2018   |     599.00    |2023-01-24 23:17:30.833 |   INS   |
-- |---------------|-----------|---------------|--------|------------|----------|---------------|------------------------|---------|

-- La siguiente sentencia elimina una fila de la tabla Produccion.productos:

DELETE FROM Produccion.productos
WHERE producto_id = 322

-- Como era de esperar, el trigger se disparó e insertó la fila eliminada en la tabla Produccion.AuditoriasProducto:

-- |---------------|-----------|---------------|--------|------------|----------|---------------|------------------------|---------|
-- |modificacion_id|producto_id|producto_nombre|marca_id|categoria_id|ano_modelo|precio_catalogo|      actualizado_a     |operation|
-- |---------------|-----------|---------------|--------|------------|----------|---------------|------------------------|---------|
-- |       1       |    322    | Test product  |   1    |      1     |   2018   |     599.00    |2023-01-24 23:17:30.833 |   INS   |
-- |       2       |    322    | Test product  |   1    |      1     |   2018   |     599.00    |2023-01-24 23:28:15.530 |   DEL   |
-- |---------------|-----------|---------------|--------|------------|----------|---------------|------------------------|---------|

/*

   ============================================================================================
   ============================================================================================                    

   ==================
   === INSTEAD OF ===
   ==================

   - El ejemplo que se creo basicamente es similar al anterior, solo que en este caso el trigger se
     activará cuando se inserte un registro en una VISTA, cosa que nos permite INSTEAD OF sobre AFTER
     que solo actua sobre TABLAS.

   Un trigger INSTEAD OF es un trigger que permite omitir una sentencia INSERT, DELETE o UPDATE en una 
   tabla o "vista" y ejecutar en su lugar otras sentencias definidas en el trigger. La operación real de 
   inserción, eliminación o actualización no se produce en absoluto.

   En otras palabras, un trigger INSTEAD OF omite una sentencia DML y ejecuta otras sentencias.


   Sintaxis del trigger INSTEAD OF de SQL Server
   =============================================

   A continuación, se ilustra la sintaxis para crear un trigger INSTEAD OF:

                                CREATE TRIGGER [schema_name.] trigger_name
                                ON {table_name | view_name }
                                INSTEAD OF {[INSERT] [,] [UPDATE] [,] [DELETE] }
                                AS
                                {sql_statements}


   En esta sintaxis:

   - En primer lugar, especifique el nombre del trigger y, opcionalmente, el nombre del schema al que pertenece 
     el trigger en la cláusula CREATE TRIGGER.

   - Segundo, especifique el nombre de la tabla o vista a la que se asocia el trigger.

   - Tercero, especifique un evento como INSERT, DELETE o UPDATE que el trigger disparará en la cláusula INSTEAD OF. 
     El trigger puede ser llamado para responder a uno o múltiples eventos.

   - Cuarto, coloque el cuerpo del trigger después de la palabra clave AS. El cuerpo de un trigger puede consistir 
     en una o más sentencias Transact-SQL.


   Ejemplo de trigger INSTEAD OF de SQL Server
   ===========================================

   Un ejemplo típico de uso de un trigger INSTEAD OF es la anulación de una operación de inserción, actualización 
   o eliminación en una vista.

   Supongamos que una aplicación necesita insertar nuevas marcas en la tabla Produccion.marcas. Sin embargo, las 
   nuevas marcas deben almacenarse en otra tabla llamada Produccion.marcas_aprobaciones para su aprobación antes 
   de insertarlas en la tabla Produccion.marcas.

   Para ello, cree una vista denominada Produccion.v_marcas para que la aplicación inserte las nuevas marcas. Si 
   se insertan marcas en la vista, se disparará un trigger INSTEAD OF para insertar marcas en la tabla 
   Produccion.marcas_aprobaciones. */

   USE TiendaBicicletas

/*

   1) Creación tabla para almacenar marcas pendientes de aprobación

   La siguiente sentencia crea una nueva tabla llamada Produccion.marcas_aprobaciones para almacenar las marcas 
   pendientes de aprobación:  */

CREATE TABLE Produccion.marcas_aprobaciones(
    marca_id INT IDENTITY PRIMARY KEY,
    marca_nombre VARCHAR(255) NOT NULL
)

/*
   2) Creación de la vista que alamacenará de manera previa las marcas a aprobar

   La siguiente sentencia crea una nueva vista llamada Produccion.v_marcas contra las tablas Produccion.marcas 
   y Produccion.marcas_aprobaciones:  */

CREATE VIEW Produccion.v_marcas 
AS
SELECT
    marca_nombre,
    'Aprobado' estado_aprobacion
FROM
    Produccion.marcas
UNION
SELECT
    marca_nombre,
    'Aprobación pendiente' estado_aprobacion
FROM
    Produccion.marcas_aprobaciones

-- Si creamos la Vista en el orden inverno es exactamente lo mismo

-- CREATE VIEW Produccion.v_marcas 
-- AS
-- SELECT
--     marca_nombre,
--     'Aprobación pendiente' estado_aprobacion
-- FROM
--     Produccion.marcas_aprobaciones
-- UNION
-- SELECT
--     marca_nombre,
--     'Aprobado' estado_aprobacion
-- FROM
--     Produccion.marcas

/*

   3) Creación de un trigger DML INSTEAD OF
   ========================================

   Una vez que se inserta una fila en la vista Produccion.v_marcas, tenemos que dirigirla a la tabla 
   Produccion.marcas_aprobaciones mediante el siguiente trigger INSTEAD OF:   */

CREATE TRIGGER Produccion.trg_v_marcas
ON Produccion.v_marcas
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON
    INSERT INTO Produccion.marcas_aprobaciones( 
        marca_nombre
    )
    SELECT i.marca_nombre
    FROM inserted i
    WHERE i.marca_nombre NOT IN (SELECT marca_nombre FROM Produccion.marcas)
END

/*
 
    4) Prueba del trigger
    =====================

    El trigger inserta la nueva marca en Produccion.marcas_aprobaciones si la marca no existe en Produccion.marcas.

    Insertemos una nueva marca en la vista Produccion.v_marcas:  */

INSERT INTO Produccion.v_marcas(marca_nombre)
VALUES('Vans')


--  Esta sentencia INSERT disparó el trigger INSTEAD OF para insertar una nueva fila en la tabla 
--  Produccion.marcas_aprobaciones.

--  Si consulta los datos de la tabla Produccion.v_marcas, verá que aparece una nueva fila:

SELECT
	marca_nombre,
	estado_aprobacion
FROM
	Produccion.v_marcas

/*
|--------------|--------------------|
| marca_nombre | estado_aprobacion  |
|--------------|--------------------|
|   Electra	   |      Aprobado      |
|     Haro	   |      Aprobado      |
|    Heller	   |      Aprobado      |
|  Pure Cycles |      Aprobado      |
|   Ritchey	   |      Aprobado      |
|   Strider	   |      Aprobado      |
| Sun Bicycles |      Aprobado      |
|    Surly	   |      Aprobado      |
|    Trek	   |      Aprobado      |
|    Vans	   |Aprobación pendiente|
|--------------|--------------------|


    La siguiente sentencia muestra el contenido de la tabla production.brand_approvals:  */

SELECT *
FROM Produccion.marcas_aprobaciones

/*
|----------|--------------|
| marca_id | marca_nombre |
|----------|--------------|
|    1	   |     Vans     |
|----------|--------------|


   ===================================================================================================

   ===================================================================================================
   Ejemplo 2: Se creará un TRIGGER ANIDADO utilizando un Trigger DML AFTER y un Trigger DML INSTEAD OF
   ===================================================================================================
   */

   USE EJERCICIOS

-- Creamos este trigger DML AFTER sobre la tabla "tblTransaction"
-- ¿Que es lo que hace? Al generarse un INSERT o DELETE sobre la tabla "tblTransaction" se activaran 
-- 2 consultas SELECT sobre las tablas 'inserted' y 'deleted' respectivamente.

CREATE TRIGGER tr_tblTransaction
ON tblTransaction
AFTER DELETE,INSERT
AS
BEGIN
	SET NOCOUNT ON
	SELECT * FROM inserted
	SELECT * FROM deleted
END
GO


-- Ya se creó esta vista. Ahora podemos revisar que contiene:

SELECT * FROM ViewByDepartment


-- Creamos este trigger DML INSTEAD OF sobre la vista "ViewByDepartment"

CREATE TRIGGER tr_ViewByDepartment
ON dbo.ViewByDepartment
-- INSTEAD OF (En lugar de). En este ejemplo, al momento de realizar un DELETE sobre la vista, se generará
-- una modificación a esta acción. El DELETE se activa de igual forma y quedará registrado en la tabla 'deleted',
-- lo que no se hará, es aplicarlo directo en la Vista.

INSTEAD OF DELETE 
AS
BEGIN
    SET NOCOUNT ON
	DECLARE @EmployeeNumber AS INT
	DECLARE @DateOfTransaction AS SMALLDATETIME
	DECLARE @Amount AS SMALLMONEY
    -- Esta consulta como tal no devolverá nada. Sin embargo, acá lo que se hace es lo siguiente: Sabemos que
    -- las variables cuando se les asigna una columna, capturan el último registro de esta (revisar los apuntes
    -- de VARIABLES). Por tanto, dado que el DELETE que se realizó sobre la Vista queda registrada de igual forma
    -- en la tabla 'deleted', estas variables capturan el último valor ingresado para cada una de estas columnas.
	SELECT @EmployeeNumber = EmployeeNumber, @DateOfTransaction = DateOfTransaction, @Amount = TotalAmount
	FROM deleted;
	
    -- Lo que hacemos aquí es generar un DELETE sobre la tabla "tblTransaction" utilizando los valores capturados
    -- por las variables. A su vez, al generar un DELETE sobre la tabla "tblTransaction", se activará el Trigger
    -- DML AFTER sobre esta tabla, que tenemos un poco más arriba.
	DELETE tblTransaction
	FROM tblTransaction AS T
	WHERE T.EmployeeNumber = @EmployeeNumber
	AND T.DateOfTransaction = @DateOfTransaction
	AND T.Amount = @Amount
END

BEGIN TRAN
	DELETE 
	FROM dbo.ViewByDepartment
	WHERE TotalAmount = -2.77
	AND EmployeeNumber = 132
ROLLBACK TRAN

/*
   ===================================================================================================

   ===================================================================================================
   Ejemplo 3: Se creará un Trigger DML INSTEAD OF que lidie con multiples registros eliminados
   ===================================================================================================
   */

USE EJERCICIOS

-- Ya se creó esta vista. Ahora podemos revisar que contiene:

SELECT * FROM ViewByDepartment


-- Creamos este trigger DML INSTEAD OF sobre la vista "ViewByDepartment"

CREATE TRIGGER tr_ViewByDepartment
ON dbo.ViewByDepartment
-- INSTEAD OF (En lugar de). En este ejemplo, al momento de realizar un DELETE sobre la vista, se generará
-- una modificación a esta acción. El DELETE se activa de igual forma y quedará registrado en la tabla 'deleted',
-- lo que no se hará, es aplicarlo directo en la Vista.

INSTEAD OF DELETE 
AS
BEGIN
    SET NOCOUNT ON
    SELECT *, 'A eliminar' FROM deleted
    DELETE tblTransaction 
    FROM tblTransaction AS T
    INNER JOIN deleted D
    ON T.EmployeeNumber = D.EmployeeNumber
    AND T.DateOfTransaction = D.DateOfTransaction
    AND T.Amount = D.TotalAmount
END 
GO

-- El BEGIN TRAN y ROLLBACK TRAN lo utilizo como modo prueba y no generar un DELETE real sobre la tabla.
BEGIN TRAN
    SELECT *, 'Antes de eliminar' FROM ViewByDepartment
    WHERE EmployeeNumber = 132;
    -- Este DELETE representa multiples registros
    DELETE FROM ViewByDepartment
    WHERE EmployeeNumber = 132;
    SELECT *, 'Despues de eliminar' FROM ViewByDepartment
    WHERE EmployeeNumber = 132;
ROLLBACK TRAN

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