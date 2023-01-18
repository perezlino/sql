-- ======================================================
-- ======================= TRIGGERS =====================
-- ======================================================

/* Es un tipo de procedimiento almacenado que se ejecuta automáticamente en respuesta a un evento en la
 base de datos.

  Caracteristicas:

  - Un trigger puede ser invocado en respuesta a un INSERT, UPDATE o DELETE
  - Un trigger puede ser invocado en respuesta a una sentencia ALTER, CREATE o DROP
  - Un trigger puede ser invocado en respuesta  a un evento de login.                        */

 --------------------
/* Primer Ejemplo */
--------------------

--- Vamos a comenzar creando dos tablas
USE ADDC
GO

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

--Cuando yo inserte datos en la tabla "Personas" este Trigger se va a activar
CREATE OR ALTER TRIGGER tr_InsertarPersonas
ON Personas
FOR INSERT 
AS
BEGIN
		SET NOCOUNT ON; --Para esconder los mensajes
		INSERT INTO PersonasT
		SELECT TOP 1 P.Nombre, P.Apellido,
		dbo.FN_Concatenar(P.Nombre, P.Apellido, ' '), 
		dbo.FN_Correo(P.Nombre, P.Apellido),
		dbo.FN_Edad(P.FechaNacimiento),
		GETDATE()
		FROM Personas P
		ORDER BY P.Id DESC
END;

INSERT INTO Personas VALUES ('Andres', 'Espinoza', '1996-12-10')-- Cargamos esta insercion en la tabla  "Personas"
INSERT INTO Personas VALUES ('Alfonso', 'Perez', '1986-03-06')


SELECT * FROM PersonasT

 --------------------
/* Segundo Ejemplo */
--------------------
-- Crear un Log que permita identificar que usuario

USE ADDC
GO

--Cuando yo elimine datos en la tabla "Transportista" este Trigger se va a activar
CREATE OR ALTER TRIGGER log_transactions
ON Transportista
AFTER DELETE
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO Log_Activity(Usuario, Tabla, Descripcion, Fecha_edicion)
	VALUES (SYSTEM_USER, 'Transportista', 'Delete', GETDATE())

END;
--
DELETE FROM Transportista
WHERE TransportistaID > 3;

SELECT * FROM ADDC.dbo.Log_Activity;

/* DESHABILITANDO UN TRIGGER */
DISABLE TRIGGER log_transactions ON Transportista
 
 /* ELIMINANDO UN TRIGGER */
 DROP TRIGGER IF EXISTS Crear_respaldo

  --------------------
/* Tercer Ejemplo */
--------------------
 
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

  --------------------
/* Cuarto Ejemplo */
--------------------
 USE NORTHWNDD
 GO

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