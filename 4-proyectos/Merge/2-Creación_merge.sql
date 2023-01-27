-- ======================================================
-- =================== CREACIÓN MERGE ===================
-- ======================================================
/*

    Para este ejercicio se busca insertar aquellos registros que solo se encuentren en la tabla
    "Transaccion_staging" en la tabla "Transaccion". De igual manera, se busca actualizar
    los registros de la tabla "Transaccion", especificamente su campo "monto", al cual se le
    sumará cada monto donde el empleado_id y la fecha_transaccion sean iguales entre ambas
    tablas. Finalmente, añadiremos una nueva columna "comentario" a la tabla "Transaccion" que 
    indicará la acción que fue realizada. */

USE Transacciones   


/*
 1) Análisis de ambas tablas
 ===========================  */

 -- Analizamos la cantidad de registros que existen en la tabla Transaccion
SELECT *--COUNT(1) 
FROM dbo.Transaccion
-- Existen 16 registros


-- Analizamos la cantidad de registros que existen en la tabla Transaccion_staging
SELECT COUNT(1) 
FROM dbo.Transaccion_staging
-- Existen 29 registros


-- Analizamos la cantidad de registros unicos que existen en la tabla Transaccion_staging
SELECT COUNT(1) 
FROM (SELECT DISTINCT empleado_id, fecha_transaccion
	  FROM dbo.Transaccion_staging) AS x
-- Existen 20 registros únicos


-- Analizamos la cantidad de registros de transacciones de nuevos empleados que no 
-- existen en la tabla Transaccion y que se encuentran en la tabla Transaccion_staging
select DISTINCT empleado_id, fecha_transaccion
FROM Transaccion_staging S
WHERE NOT EXISTS (SELECT DISTINCT empleado_id FROM Transaccion T
					WHERE S.empleado_id = T.empleado_id)
-- Son 4 nuevos empleados que han realizado transacciones y los cuales no se encuentran
-- en la tabla Transaccion

-- |---------------|-------------------|
-- |  empleado_id  | fecha_transaccion |
-- |---------------|-------------------|
-- |      300      |2014-03-21 00:00:00|
-- |      445      |2016-02-05 00:00:00|
-- |      505      |2016-10-15 00:00:00|
-- |      603      |2015-07-01 00:00:00|
-- |---------------|-------------------|

-- Con esto dilucidamos que se insertaran 4 nuevos registros a la tabla Transaccion.


-- Analizamos la cantidad de registros iguales existen entre ambas tablas
SELECT COUNT(1)
FROM Transaccion T
INNER JOIN Transaccion_staging S
ON T.empleado_id = S.empleado_id
AND T.fecha_transaccion = S.fecha_transaccion
AND t.monto = S.monto
-- Existen 0 registros iguales entre ambas tablas


-- Analizamos si en la tabla Transaccion_staging existen más de una transacción diaria
-- para un mismo empleado
SELECT empleado_id, fecha_transaccion, COUNT(1) cuenta_registros
FROM dbo.Transaccion_staging
GROUP BY empleado_id, fecha_transaccion
HAVING COUNT(1) > 1
-- Existen 4 empleados con más de 1 transacción diaria

-- |--------------|-------------------|------------------|
-- |  empleado_id |	fecha_transaccion |	cuenta_registros |
-- |--------------|-------------------|------------------|
-- |     1010     |2014-04-18 00:00:00|	       2         |
-- |      766     |2014-12-24 00:00:00|	       5         |
-- |      987     |2015-09-14 00:00:00|	       3         |
-- |      804     |2015-10-07 00:00:00|	       2         |
-- |      445     |2016-02-05 00:00:00|	       2         |
-- |--------------|-------------------|------------------|

/*
 2) Creación sentencia MERGE
 ===========================  

    Utilizo BEGIN TRAN y ROLLBACK TRAN para evitar modificaciones reales en las tablas  */

BEGIN TRAN
    ALTER TABLE Transaccion
    ADD comentario VARCHAR(30) NULL
    GO
    MERGE INTO Transaccion AS T
    USING (SELECT empleado_id,fecha_transaccion, SUM(monto) AS monto
        FROM Transaccion_staging
        GROUP BY empleado_id,fecha_transaccion) AS S
    ON (T.empleado_id = S.empleado_id AND T.fecha_transaccion = S.fecha_transaccion)
    WHEN MATCHED THEN
        UPDATE SET T.monto = T.monto + S.monto, T.comentario = 'Registro actualizado'
    WHEN NOT MATCHED BY TARGET THEN
        INSERT (empleado_id, fecha_transaccion, monto, comentario)
        VALUES (S.empleado_id, S.fecha_transaccion, S.monto, 'Registro insertado')
    WHEN NOT MATCHED BY SOURCE THEN
        UPDATE SET comentario = 'Sin cambios'
    -- con OUTPUT podemos retornar lo realizado, y en este caso retornamos 'inserted' y 'deleted'
    -- para visualizar las modificaciones. Con $action obtenemos la acción realizada.
    OUTPUT inserted.*, deleted.*, $action AS accion;
ROLLBACK TRAN