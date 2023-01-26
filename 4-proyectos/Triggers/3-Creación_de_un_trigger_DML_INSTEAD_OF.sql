-- ======================================================
-- ============== CREACIÓN TRIGGER DML AFTER ============
-- ======================================================
/*

   Supongamos que una aplicación necesita insertar nuevas marcas en la tabla Produccion.marcas. Sin embargo, las 
   nuevas marcas deben almacenarse en otra tabla llamada Produccion.marcas_aprobaciones para su aprobación antes 
   de insertarlas en la tabla Produccion.marcas.

   Para ello, cree una vista denominada Produccion.v_marcas para que la aplicación inserte las nuevas marcas. Si 
   se insertan marcas en la vista, se disparará un trigger INSTEAD OF para insertar marcas en la tabla 
   Produccion.marcas_aprobaciones.


 1) Creación tabla para almacenar marcas pendientes de aprobación
 ================================================================

   La siguiente sentencia crea una nueva tabla llamada Produccion.marcas_aprobaciones para almacenar las marcas 
   pendientes de aprobación:  */

CREATE TABLE Produccion.marcas_aprobaciones(
    marca_id INT IDENTITY PRIMARY KEY,
    marca_nombre VARCHAR(255) NOT NULL
)

/*
 2) Creación de la vista que almacenará de manera previa las marcas a aprobar
 ==============================================================================

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


/*  Ahora, entender algo, si intentaramos ingresar un registro antes de crear el trigger no podriamos, dado que
    estamos utilizando el campo "marca_nombre" que pertenece a 2 TABLAS. Y como sabemos, para insertar un 
    registro en una Vista, esta debe estar apuntando a una sola tabla (o a aquellos campos de una sola tabla, si
    estuvieramos utilizando Joins). A continuación muestro el error que se genera:  */

INSERT INTO Produccion.v_marcas(marca_nombre)
VALUES('Vans')
/* Msg 4406, Level 16, State 1, Line 30
   Update or insert of view or function 'Produccion.v_marcas' failed because it contains a derived or 
   constant field.  */

/* Es aqui donde actua el Trigger INSTEAD OF (En lugar de), que en lugar de hacer el registro en la Vista, 
   modifica la conducta y no lo realiza, y hace ese registro directamente en la tabla "Produccion.marcas_aprobaciones".

/* Es por ese motivo, que al visualizar la vista despues de haber realizado la inserción del registro y de nuevos
   registros, siempre el "estado_aprobacion" será "Aprobación pendiente", dado que las inserciones se van registrando
   directamente en la tabla "Produccion.marcas_aprobaciones" y es desde ahi que la Vista recupera esta información,
   y para las marcas que se encuentran en esta tabla toman el valor de "Aprobación pendiente".


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


/*
    Esta sentencia INSERT disparó el trigger INSTEAD OF para insertar una nueva fila en la tabla 
    Produccion.marcas_aprobaciones.

    Si consulta los datos de la tabla Produccion.v_marcas, verá que aparece una nueva fila:  */

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