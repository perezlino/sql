-- ======================================================
-- ====== ELIMINAR TODOS LOS REGISTROS DE UNA TABLA =====
-- ======================================================

/* |---------------------------------------------------------------------------------------------|
   |Nos permite eliminar por completo los registros de una tabla. Los elimina por completo y     |
   |resetea los valores que la tabla pueda tener campos identity, es decir, si yo tuviera        | 
   |registros agregados y hago un TRUNCATE, cuando siga agregando registros lo que voy a obtener |
   |es el primer campo identity con el valor inicial, si fuese 1 va a estar en 1, y si fuese el  |
   |que fuese va a arrancar de ese valor                                                         |
   |---------------------------------------------------------------------------------------------|

   TRUNCATE es similar a DELETE en cuanto a eliminar todas las filas de una tabla, sin embargo,
   DELETE no reinicia el identity y TRUNCATE si lo hace.

   ===============================================================================================

   A veces, se desea eliminar todas las filas de una tabla. En este caso, se suele utilizar la 
   sentencia DELETE sin cláusula WHERE.

   El siguiente ejemplo crea una nueva tabla denominada Customer_groups e inserta algunas filas en 
   la tabla:   */

CREATE TABLE Sales.Customer_groups(
    group_id INT PRIMARY KEY IDENTITY,
    group_name VARCHAR (50) NOT NULL
);

INSERT INTO Sales.Customer_groups(group_name)
VALUES
    ('Intercompany'),
    ('Third Party'),
    ('One time')

-- Para eliminar todas las filas de la tabla Customer_groups, utilice la sentencia DELETE como se 
-- indica a continuación:

DELETE FROM Sales.Customer_groups

/* Además de la sentencia DELETE FROM, puede utilizar la sentencia TRUNCATE TABLE para eliminar todas 
   las filas de una tabla.

   A continuación se ilustra la sintaxis de la sentencia TRUNCATE TABLE:

                        TRUNCATE TABLE [database_name.][schema_name.]table_name


   En esta sintaxis, en primer lugar, se especifica el nombre de la tabla de la que se desea eliminar 
   todas las filas. En segundo lugar, el nombre de la base de datos es el nombre de la base de datos 
   en la que se creó la tabla. El nombre de la base de datos es opcional. Si lo omite, la sentencia 
   borrará la tabla en la base de datos conectada en ese momento.

   Las siguientes sentencias insertan primero algunas filas en la tabla Customer_groups y luego borran 
   todas las filas de la misma utilizando la sentencia TRUNCATE TABLE:   */

INSERT INTO Sales.Customer_groups(group_name)
VALUES
    ('Intercompany'),
    ('Third Party'),
    ('One time');   

TRUNCATE TABLE Sales.Customer_groups


/* La sentencia TRUNCATE TABLE es similar a la sentencia DELETE sin cláusula WHERE. Sin embargo, la 
   sentencia TRUNCATE se ejecuta más rápido y utiliza menos recursos del sistema y del registro de 
   transacciones.

   ===============================================================================================

   TRUNCATE TABLE vs. DELETE
   =========================

   La sentencia TRUNCATE TABLE tiene las siguientes ventajas sobre la sentencia DELETE:

   1) Utiliza menos el transaction log
   -----------------------------------
   La sentencia DELETE elimina filas de una en una e inserta una entrada en el transaction log por 
   cada fila eliminada. Por otro lado, la sentencia TRUNCATE TABLE elimina los datos mediante la 
   desasignación de las páginas de datos utilizadas para almacenar los datos de la tabla e inserta 
   sólo las páginas desasignadas en los transaction logs.


   2) Utilizar menos bloqueos
   --------------------------
   Cuando la sentencia DELETE se ejecuta utilizando un bloqueo de fila, cada fila de la tabla se bloquea 
   para su eliminación. La sentencia TRUNCATE TABLE bloquea la tabla y las páginas, no cada fila.


   3) Reinicialización del Identity
   --------------------------------
   Si la tabla que se va a truncar tiene una columna de identidad, el contador de esa columna se restablece 
   al valor inicial cuando se eliminan datos mediante la sentencia TRUNCATE TABLE, pero no mediante la 
   sentencia DELETE.