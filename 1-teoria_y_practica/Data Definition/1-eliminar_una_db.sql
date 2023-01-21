-- ======================================================
-- ============ ELIMINAR UNA BASE DE DATOS ==============
-- ======================================================

/* Para eliminar una base de datos existente de una instancia de SQL Server, se utiliza 
   la sentencia DROP DATABASE.

   La sentencia DROP DATABASE permite eliminar una o varias bases de datos con la siguiente 
   sintaxis:

                                DROP DATABASE  [ IF EXISTS ]
                                    database_name 
                                    [,database_name2,...]

   En esta sintaxis, se especifica el nombre de la base de datos que se desea eliminar después 
   de las palabras clave DROP DATABASE. Si desea eliminar varias bases de datos con una única 
   sentencia, puede utilizar una lista de nombres de bases de datos separados por comas después 
   de la cláusula DROP DATABASE.

   La opción IF EXISTS está disponible desde SQL Server 2016 (13.x). Le permite eliminar 
   condicionalmente una base de datos solo si la base de datos ya existe. Si intenta eliminar una 
   base de datos que no existe sin especificar la opción IF EXISTS, SQL Server emitirá un error.

   Antes de eliminar una base de datos, debe asegurarse de los siguientes puntos importantes:

   - En primer lugar, la sentencia DROP DATABASE elimina la base de datos y también los archivos de 
     disco físico (physical disk files) utilizados por la base de datos. Por lo tanto, debe tener 
     una copia de seguridad de la base de datos por si desea restaurarla en el futuro.

   - En segundo lugar, no se puede eliminar una base de datos que se esté utilizando en ese momento.

   Si se intenta eliminar una base de datos en uso, se produce el siguiente error:

               "Cannot drop database "database_name" because it is currently in use.""

   
   El siguiente ejemplo utiliza la sentencia DROP DATABASE para eliminar la base de datos TestDb:  */

   DROP DATABASE IF EXISTS TestDb