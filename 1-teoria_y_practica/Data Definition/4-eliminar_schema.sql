-- ======================================================
-- ================== ELIMINAR SCHEMA ===================
-- ======================================================

/* La sentencia DROP SCHEMA permite eliminar un schema de una base de datos. A continuación, 
   se muestra la sintaxis de la sentencia DROP SCHEMA:

                           DROP SCHEMA [IF EXISTS] schema_name


   En esta sintaxis:

   - En primer lugar, especifique el nombre del schema que desea eliminar. Si el schema contiene 
     algún objeto, la sentencia fallará. Por lo tanto, debe eliminar todos los objetos del schema 
     antes de eliminar el schema.

   - En segundo lugar, utilice la opción IF EXISTS para eliminar condicionalmente el schema sólo si 
     existe. Si se intenta eliminar un schema que no existe sin la opción IF EXISTS, se producirá un 
     error.


   Ejemplo de sentencia DROP SCHEMA de SQL Server
   ==============================================

   En primer lugar, cree un nuevo schema denominado logistics:   */

CREATE SCHEMA logistics
GO

-- A continuación, cree una nueva tabla denominada "deliveries" dentro del schema logistics:

CREATE TABLE logistics.deliveries
(
    order_id        INT
    PRIMARY KEY, 
    delivery_date   DATE NOT NULL, 
    delivery_status TINYINT NOT NULL
)

-- A continuación, elimine el schema logistics:

DROP SCHEMA logistics

-- SQL Server emitió el siguiente error porque el schema no está vacío:

Msg 3729, Level 16, State 1, Line 1
Cannot drop schema 'logistics' because it is being referenced by object 'deliveries'.

-- A continuación, elimine la tabla logistics.deliveries:

DROP TABLE logistics.deliveries

-- Por último, vuelva a ejecutar DROP SCHEMA para eliminar el schema logistics:

DROP SCHEMA IF EXISTS logistics

-- Ahora verá que el schema logistics se ha eliminado de la base de datos.