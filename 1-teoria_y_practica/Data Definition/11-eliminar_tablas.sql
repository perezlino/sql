-- ======================================================
-- ================== ELIMINAR TABLAS ===================
-- ======================================================

/* A veces, se desea eliminar una tabla que ya no se utiliza. Para ello, utilice la siguiente 
   sentencia DROP TABLE:

                 DROP TABLE [IF EXISTS]  [database_name.][schema_name.]table_name


   En esta sintaxis:

   - En primer lugar, especifique el nombre de la tabla que desea eliminar.

   - En segundo lugar, especifique el nombre de la base de datos en la que se creó la tabla y el 
     nombre del schema al que pertenece la tabla. El nombre de la base de datos es opcional. Si lo 
     omite, la sentencia DROP TABLE eliminará la tabla en la base de datos conectada en ese momento.

   - En tercer lugar, utilice la cláusula IF EXISTS para eliminar la tabla sólo si existe. La cláusula 
     IF EXISTS se admite desde SQL Server 2016 13.x. Si elimina una tabla que no existe, obtendrá un error. 
     La cláusula IF EXISTS elimina condicionalmente la tabla si ya existe.

   Cuando SQL Server elimina una tabla, también elimina todos los datos, triggers, restricciones, permisos 
   de esa tabla. Además, SQL Server no elimina explícitamente las vistas y los stored procedures que hacen 
   referencia a la tabla eliminada. Por lo tanto, para eliminar explícitamente estos objetos dependientes, 
   debe utilizar las sentencias DROP VIEW y DROP PROCEDURE.

   SQL Server permite eliminar varias tablas a la vez mediante una única sentencia DROP TABLE, como se indica 
   a continuación:

                        DROP TABLE [database_name.][schema_name.]table_name_1,
                                [schema_name.]table_name_2, …
                                [schema_name.]table_name_n


   Ejemplos de DROP TABLE en SQL Server
   ====================================

   Veamos algunos ejemplos de uso de la sentencia DROP TABLE de SQL Server.


   A) Eliminar una tabla que no existe
   ===================================

   La siguiente sentencia elimina una tabla llamada "Revenues" en el sales schema:  */

DROP TABLE IF EXISTS Sales.Revenues

/* En este ejemplo, la tabla Revenues no existe. Como utiliza la cláusula IF EXISTS, la sentencia se ejecuta 
   correctamente sin que se elimine ninguna tabla.


   B) Ejemplo de eliminación de una única tabla
   ============================================

   La siguiente sentencia crea una nueva tabla llamada Delivery en el sales schema:   */

CREATE TABLE Sales.Delivery(
    delivery_id INT PRIMARY KEY,
    delivery_note VARCHAR (255) NOT NULL,
    delivery_date DATE NOT NULL
)

-- Para eliminar la tabla Delivery, utilice la siguiente sentencia:

DROP TABLE Sales.Delivery


-- C) Ejemplo de eliminación de una tabla con una restricción foreign key
-- ======================================================================

-- La siguiente sentencia crea dos nuevas tablas denominadas Supplier_groups y Suppliers en el schema 
-- Procurement:

CREATE SCHEMA Procurement
GO

CREATE TABLE Procurement.Supplier_groups(
    group_id INT IDENTITY PRIMARY KEY,
    group_name VARCHAR (50) NOT NULL
)

CREATE TABLE Procurement.Suppliers(
    supplier_id INT IDENTITY PRIMARY KEY,
    supplier_name VARCHAR (50) NOT NULL,
    group_id INT NOT NULL,
    FOREIGN KEY (group_id) REFERENCES procurement.supplier_groups (group_id)
)

-- Intentemos eliminar la tabla Supplier_groups:

DROP TABLE procurement.supplier_groups

-- SQL Server emitió el siguiente error:

Could not drop object 'procurement.supplier_groups' because it is referenced by a FOREIGN KEY constraint.

/* SQL Server no permite eliminar una tabla a la que hace referencia una restricción foreign. Para eliminar 
   esta tabla, primero debe eliminar la restricción foreign key a la que hace referencia o la tabla a la que 
   hace referencia. En este caso, debe eliminar primero la restricción foreign key de la tabla Suppliers o la 
   tabla Suppliers antes de eliminar la tabla Supplier_groups.   */

DROP TABLE Procurement.Supplier_groups
DROP TABLE Procurement.Suppliers

-- Si utiliza una única sentencia DROP TABLE para eliminar ambas tablas, la tabla de referencia debe aparecer 
-- en primer lugar, como se muestra en la consulta siguiente:

DROP TABLE Procurement.Suppliers, Procurement.Supplier_groups