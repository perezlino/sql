-- ======================================================
-- ================= COLUMNA IDENTITY ===================
-- ======================================================

/* Para crear una columna de identidad para una tabla, se utiliza la propiedad IDENTITY 
   de la siguiente manera:

                                IDENTITY[(seed,increment)]

   En esta sintaxis:

   - El "seed" es el valor de la primera fila cargada en la tabla.
   - El "increment" es el valor incremental añadido al valor de identidad de la fila anterior.

   El valor por defecto de la seed y el increment es 1, es decir, (1,1). Esto significa que la 
   primera fila cargada en la tabla tendrá el valor 1, la segunda fila tendrá el valor 2 y así 
   sucesivamente.

   Supongamos que desea que el valor de la columna de identidad de la primera fila sea 10 y el 
   valor incremental sea 10, utilice la siguiente sintaxis:   */

IDENTITY (10,10)

-- Tenga en cuenta que SQL Server sólo permite tener una columna de identidad por tabla.


-- Ejemplo de SQL Server IDENTITY
-- ==============================

-- Vamos a crear un nuevo schema llamado "hr" para practicar:

CREATE SCHEMA hr


-- La siguiente sentencia crea una nueva tabla utilizando la propiedad IDENTITY para la columna personal 
-- identification number:

CREATE TABLE hr.person (
    person_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender CHAR(1) NOT NULL
)


-- En primer lugar, inserte una nueva fila en la tabla person:

INSERT INTO hr.person(first_name, last_name, gender)
OUTPUT inserted.person_id
VALUES('John','Doe', 'M');


/* El resultado es el siguiente:

|-----------|------------|-----------|--------|
| person_id | first_name | last_name | gender |
|-----------|------------|-----------|--------|
|     1     |    John    |    Doe    |   M    |
|-----------|------------|-----------|--------|


   Como puede verse claramente en la salida, la primera fila se ha cargado con el valor uno en la columna 
   person_id.

   En segundo lugar, inserta otra fila en la tabla persona:  */

INSERT INTO hr.person(first_name, last_name, gender)
OUTPUT inserted.person_id
VALUES('Jane','Doe','F')

/* El resultado es el siguiente:

|-----------|------------|-----------|--------|
| person_id | first_name | last_name | gender |
|-----------|------------|-----------|--------|
|     1     |    John    |    Doe    |   M    |
|     2     |    Jane    |    Doe    |   F    |
|-----------|------------|-----------|--------|

   Como puede ver claramente en el resultado, la segunda fila tiene el valor dos en la columna person_id.


   Reutilización de valores de identidad
   =====================================

   SQL Server no reutiliza los valores de identidad. Si inserta una fila en la columna de identidad y la 
   sentencia de inserción falla o se revierte, el valor de identidad se pierde y no se generará de nuevo. 
   El resultado son huecos en la columna de identidad.

   Considere el siguiente ejemplo.

   En primer lugar, cree dos tablas más en el esquema "hr" denominadas "position" y "person_position":  */

CREATE TABLE hr. POSITION (
	position_id INT IDENTITY (1, 1) PRIMARY KEY,
	position_name VARCHAR (255) NOT NULL,

)

CREATE TABLE hr.person_position (
	person_id INT,
	position_id INT,
	PRIMARY KEY (person_id, position_id),
	FOREIGN KEY (person_id) REFERENCES hr.person (person_id),
	FOREIGN KEY (position_id) REFERENCES hr. POSITION (position_id)
)

-- En segundo lugar, inserte una nueva persona y asígnele un puesto (position) insertando una nueva fila 
-- en la tabla person_position:

BEGIN TRANSACTION
    BEGIN TRY
        -- insertar una nueva persona
        INSERT INTO hr.person(first_name,last_name, gender)
        VALUES('Joan','Smith','F');

        -- asignar un puesto (position) a la persona
        INSERT INTO hr.person_position(person_id, position_id)
        VALUES(@@IDENTITY, 1)
    END TRY
    BEGIN CATCH
         IF @@TRANCOUNT > 0  
            ROLLBACK TRANSACTION  
    END CATCH

    IF @@TRANCOUNT > 0  
        COMMIT TRANSACTION
GO

-- En este ejemplo, la primera sentencia de inserción se ejecutó correctamente. Sin embargo, la segunda falló 
-- debido a que no había ninguna posición con id uno en la tabla de posiciones. Debido al error, la transacción 
-- fue revertida.

-- Debido a que la primera sentencia INSERT consumió el valor de identidad tres y la transacción fue revertida, 
-- el siguiente valor de identidad será cuatro como se muestra en la siguiente sentencia:

INSERT INTO hr.person(first_name,last_name,gender)
OUTPUT inserted.person_id
VALUES('Peter','Drucker','F')

/* El resultado es el siguiente:

|-----------|------------|-----------|--------|
| person_id | first_name | last_name | gender |
|-----------|------------|-----------|--------|
|     1     |    John    |    Doe    |   M    |
|     2     |    Jane    |    Doe    |   F    |
|     4     |    Peter   |  Drucker  |   M    |
|-----------|------------|-----------|--------|


-- =======================================================================================================
-- =======================================================================================================

/* Algunas funciones y variables del sistema están relacionadas con la propiedad IDENTITY. El ejemplo 
   utiliza la variable $identity. Esta variable se refiere automáticamente a la columna con la propiedad 
   IDENTITY. */

SELECT $identity FROM Sales.SalesOrderHeader

-- =======================================================================================================
-- =======================================================================================================

/* Para conocer el valor inicial y el incremento de la columna con la propiedad IDENTITY, se pueden utilizar 
   las funciones IDENT_SEED e IDENT_INCR, respectivamente, de la siguiente manera */

SELECT IDENT_SEED('Sales.SalesOrderHeader') AS Valor_inicial,
	   IDENT_INCR('Sales.SalesOrderHeader') AS Valor_incremento

-- =======================================================================================================
-- =======================================================================================================

-- Explicación con un ejemplo para @@IDENTITY

-- Revisamos primero la tabla y si posee una columna identity
SELECT * FROM Production.Location 
-- Su último ID es 61
SELECT $identity FROM Production.Location


SELECT MAX(LocationID) FROM Production.Location  -- 61
GO  
INSERT INTO Production.Location (Name, CostRate, Availability, ModifiedDate)  
VALUES ('Damaged Goods', 5, 2.5, GETDATE())  
GO  
-- Es una función del sistema que devuelve el último valor de identidad insertado.
SELECT @@IDENTITY AS 'Identity'  -- 62
GO  
-- Mostrar el valor de LocationID de la fila recién insertada.  
SELECT MAX(LocationID) FROM Production.Location  -- 62
GO