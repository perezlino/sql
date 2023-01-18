-- ======================================================
-- ================== STORED PROCEDURES =================
-- ======================================================

 ---------------------------------------------------------- 
/* Primer Ejemplo: Declaración de Variables - Parámetros */
----------------------------------------------------------

/* 1.- Se crea el Stored Procedure y se ejecuta
   2.- Se genera el EXEC para ejecutar el SP y luego se ejecuta
   3.- Realizamos una consulta para revisar si se cargaron o no los datos por medio del SP */

USE Registro
GO
CREATE PROCEDURE pr_insertarpersona (@idPersona VARCHAR(5),@nombre VARCHAR(20),
                                     @apellido VARCHAR(20),@edad TINYINT)
AS
BEGIN
		INSERT INTO Personas (IdPersona,Nombre,Apellido,Edad)
			VALUES (@idPersona,@nombre,@apellido,@edad)
END


EXEC pr_insertarpersona 'A06','Alfonso','Pérez',35

USE Registro
GO
SELECT * FROM Personas

 --------------------
/* Segundo Ejemplo */
--------------------
USE Registro
GO
CREATE PROCEDURE pr_buscarpersona (@nombre VARCHAR(20))
                                     
AS
BEGIN
		SELECT IdPersona,Nombre,Apellido,Edad FROM Personas 
		WHERE Nombre LIKE '%' + @nombre + '%'
END


EXEC pr_buscarpersona 'Alfonso'

 --------------------
/* Tercer Ejemplo */
--------------------

USE Registro

CREATE PROCEDURE calcularPromedio (@n1 DECIMAL(4,2),@n2 DECIMAL(4,2),@resu DECIMAL(4,2) OUTPUT)

AS
BEGIN
		SELECT @resu = (@n1 + @n2)/2
END

DECLARE @variableResultado DECIMAL (4,2)

EXEC calcularPromedio 5,6,@variableResultado OUTPUT

SELECT @variableResultado as Promedio

 --------------------
/* Cuarto Ejemplo */
--------------------

/* 1.- Se crea el Stored Procedure y se ejecuta
   2.- Se genera el EXEC para ejecutar el SP y luego se ejecuta
   3.- Realizamos una consulta para revisar si se cargaron o no los datos por medio del SP */

USE Registro

CREATE PROC restarEdad (@idPersona VARCHAR(5),@edad TINYINT)

AS
BEGIN
		UPDATE Personas 
		SET Edad = Edad - @edad
		WHERE IdPersona = @idPersona
END

EXEC restarEdad 'A06',2

SELECT * FROM Personas

/* PARA TRAER EL CODIGO DE EL SP utilizamos SP_HELPTEXT */

SP_HELPTEXT restarEdad

/* PARA EDITAR UN SP utilizamos ALTER PROCEDURE y para eliminarlo DROP PROCEDURE */

ALTER PROCEDURE restarEdad
..
..
..
..
..

/* Utilizamos el SP del "Segundo Ejemplo" para llamar a WITH RESULTS SETS con el cual podemos
    modificar el titulo de la columna y el tipo de datos */

EXEC pr_buscarpersona 'Alfonso'
WITH RESULT SETS
(([PersonId] VARCHAR(5) NOT NULL,
  [Name] VARCHAR(20) NOT NULL,
  [LastName] VARCHAR(20) NOT NULL,
  [Age] TINYINT NOT NULL))

 --------------------
/* Quinto Ejemplo */
--------------------
USE NORTHWNDD
GO

CREATE PROCEDURE SP_Orders
AS
	BEGIN
		SELECT OrderID,CustomerID,OrderDate,ShipAddress
		FROM dbo.Orders
	END

EXEC SP_Orders

 --------------------
/* Sexto Ejemplo */
--------------------

USE sample

CREATE TABLE empleados
(id INTEGER NOT NULL,
 nombre VARCHAR(20) NOT NULL,
 genero VARCHAR(20) NOT NULL,
 salario INTEGER NOT NULL)

INSERT INTO empleados VALUES (1, 'Ilka Braganca', 'Female',77610);
INSERT INTO empleados VALUES (2, 'Corene Alliband', 'Female',56320);
INSERT INTO empleados VALUES (3, 'Alphonse Jordison', 'Female', 26870);
INSERT INTO empleados VALUES (4, 'Trey Stops', 'Female', 22110);
INSERT INTO empleados VALUES (5, 'Harley Stork', 'Female', 29810);
INSERT INTO empleados VALUES (6, 'Sumner Gregoraci', 'Male', 67600);
INSERT INTO empleados VALUES (7, 'Bron Pavlovsky', 'Female', 79440);
INSERT INTO empleados VALUES (8, 'Gray Rosin', 'Female', 42870);
INSERT INTO empleados VALUES (9, 'Giles McMenamy', 'Male', 21020);
INSERT INTO empleados VALUES (10, 'Verna Oboy', 'Male', 44640);

SELECT * FROM empleados

ALTER PROCEDURE FindEmpCount (
    @salary INT,
    @emp_count INT OUTPUT) 
AS
BEGIN
    SELECT * FROM empleados
    WHERE salario > @salary;

    SELECT @emp_count = @@ROWCOUNT;
END;


DECLARE @count INT;

EXEC FindEmpCount 60000, @count OUTPUT;

SELECT @count as Number_employees

 --------------------
/* Séptimo Ejemplo */
--------------------
USE sample

CREATE PROCEDURE test (
	@a datetime OUT, 
	@b datetime OUT)
AS
BEGIN
	SELECT @a = GETDATE() --using SELECT to assign value
	SET @b = GETDATE()    --using SET to assign value
END

DECLARE @x datetime,
		@y datetime

EXEC test @x OUT, @y OUT

SELECT @x AS 'Using SELECT', 
       @y AS 'Using SET'

 --------------------
/* Octavo Ejemplo */
--------------------
CREATE PROCEDURE FindEmpCounts (
   @zero_count INT = 0 OUTPUT) 
AS
BEGIN
    DECLARE @v INT --variable to store count of rows returned
    SELECT nombre FROM empleados
    WHERE nombre LIKE 'z%';
    SELECT @v = @@ROWCOUNT --saving row count in a varible

	IF @v >= 1
	   BEGIN
	      SELECT @v AS 'Number of Employees';
	   END
	ELSE
	   BEGIN
	      SELECT @zero_count AS 'Number of Employees';
	   END
END

EXEC FindEmpCounts

 --------------------
/* Noveno Ejemplo */
--------------------
USE sample

CREATE PROCEDURE EmployeeGender
	@name VARCHAR(50),
	@gender VARCHAR(50) OUTPUT
AS
BEGIN
	SELECT @gender = [genero] FROM empleados 
	WHERE nombre = @name
END

DECLARE	@emp_gender VARCHAR(50) 
EXEC  EmployeeGender 'Gray Rosin', @emp_gender OUTPUT

PRINT 'The Gender of this employee is ' + @emp_gender