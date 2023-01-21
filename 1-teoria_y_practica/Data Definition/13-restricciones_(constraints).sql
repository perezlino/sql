-- ======================================================
-- ==================== RESTRICCIONES ===================
-- ======================================================

/* ===================
   === PRIMARY KEY ===
   ===================

   Una clave primaria es una columna o un grupo de columnas que identifica de forma exclusiva 
   cada fila de una tabla. La clave primaria de una tabla se crea mediante la restricción 
   PRIMARY KEY.

   Si la clave primaria consta de una sola columna, puede definir el uso de la restricción 
   PRIMARY KEY como una restricción de columna:  

                              CREATE TABLE table_name (
                                 pk_column data_type PRIMARY KEY,
                                 ...
                              );

   En caso de que la clave primaria tenga dos o más columnas, debe utilizar la restricción 
   PRIMARY KEY como restricción de tabla:

                              CREATE TABLE table_name (
                                 pk_column_1 data_type,
                                 pk_column_2 data type,
                                 ...
                                 PRIMARY KEY (pk_column_1, pk_column_2)
                              )

   Cada tabla sólo puede contener una clave primaria. Todas las columnas que participan en la clave 
   primaria deben definirse como NOT NULL. SQL Server establece automáticamente la restricción NOT NULL 
   para todas las columnas de clave primaria si no se especifica la restricción NOT NULL para estas 
   columnas.

   SQL Server también crea automáticamente un unique clustered index (o un non-clustered index si se 
   especifica como tal) cuando se crea una clave primaria.


   Ejemplos de restricciones PRIMARY KEY de SQL Server
   ===================================================

   El siguiente ejemplo crea una tabla con una clave primaria que consta de una columna:   */

CREATE TABLE Sales.Activities(
    activity_id INT PRIMARY KEY IDENTITY,
    activity_name VARCHAR (255) NOT NULL,
    activity_date DATE NOT NULL
)

CREATE TABLE Sales.Activities(
   -- Aqui utilizando CONSTRAINT nos permite dar un nombre a la primary key, que se usará internamente
    activity_id INT CONSTRAINT prim_activity PRIMARY KEY IDENTITY, 
    activity_name VARCHAR (255) NOT NULL,
    activity_date DATE NOT NULL
)

CREATE TABLE Sales.Activities(
    activity_id INT IDENTITY,
    activity_name VARCHAR (255) NOT NULL,
    activity_date DATE NOT NULL
    CONSTRAINT prim_activity PRIMARY KEY (activity_id)
)

/* En esta tabla Sales.Activities, la columna activity_id es la columna de clave primaria. Esto  
   significa que la columna activity_id contiene valores únicos.

   La propiedad IDENTITY se utiliza para que la columna activity_id genere automáticamente valores 
   enteros únicos.

   La siguiente sentencia crea una nueva tabla llamada Sales.Participants cuya clave primaria consta 
   de dos columnas:   */

CREATE TABLE Sales.Participants(
    activity_id int,
    customer_id int,
    PRIMARY KEY(activity_id, customer_id)
)

CREATE TABLE Sales.Participants(
    activity_id int,
    customer_id int
    CONSTRAINT prim_activity PRIMARY KEY (activity_id, customer_id)
)

/* En este ejemplo, los valores de las columnas activity_id o customer_id pueden estar duplicados, 
   pero cada combinación de valores de ambas columnas debe ser única.

   Normalmente, una tabla siempre tiene una clave primaria definida en el momento de su creación. Sin 
   embargo, a veces, una tabla existente puede no tener una clave primaria definida. En este caso, puede 
   añadir una clave primaria a la tabla mediante la sentencia ALTER TABLE. Considere el siguiente ejemplo:

   La siguiente sentencia crea una tabla sin clave primaria:   */

CREATE TABLE Sales.Events(
    event_id INT NOT NULL,
    event_name VARCHAR(255),
    start_date DATE NOT NULL,
    duration DEC(5,2)
)

-- Para hacer que la columna event_id sea la clave primaria, utilice la siguiente sentencia ALTER TABLE:

ALTER TABLE Sales.Events 
ADD PRIMARY KEY(event_id)

-- Tenga en cuenta que si la tabla Sales.Events ya tiene datos, antes de promover la columna event_id como 
-- clave primaria, debe asegurarse de que los valores de event_id son únicos.


/* =============================================================================================================
   =============================================================================================================

   ===================
   === FOREIGN KEY ===
   ===================

   Considere las siguientes tablas Vendor_groups y Vendors:  */

CREATE TABLE Procurement.Vendor_groups(
    group_id INT IDENTITY PRIMARY KEY,
    group_name VARCHAR (100) NOT NULL
)

CREATE TABLE Procurement.Vendors(
        vendor_id INT IDENTITY PRIMARY KEY,
        vendor_name VARCHAR(100) NOT NULL,
        group_id INT NOT NULL
)

/* Cada vendedor pertenece a un grupo de vendedores y cada grupo de vendedores puede tener cero o más vendedores. 
   La relación entre las tablas vendor_groups y vendors es de uno a muchos.

   Para cada fila de la tabla vendors, siempre se puede encontrar una fila correspondiente en la tabla 
   vendor_groups.

   Sin embargo, con la configuración actual de las tablas, puede insertar una fila en la tabla vendors sin que 
   exista una fila correspondiente en la tabla vendor_groups. Del mismo modo, también puede eliminar una fila de 
   la tabla vendor_groups sin actualizar o eliminar las filas correspondientes de la tabla vendors, lo que da lugar 
   a filas huérfanas en la tabla vendors.

   Para reforzar el vínculo entre los datos de las tablas vendor_groups y vendors, debe establecer una foreign key 
   en la tabla vendors.

   Una foreign key es una columna o un grupo de columnas de una tabla que identifica de forma exclusiva una fila 
   de otra tabla (o de la misma tabla en caso de autorreferencia).

   Para crear una foreign key, se utiliza la restricción FOREIGN KEY.

   Las siguientes sentencias eliminan la tabla vendors y la vuelven a crear con una restricción FOREIGN KEY: */

DROP TABLE vendors;

CREATE TABLE procurement.vendors (
        vendor_id INT IDENTITY PRIMARY KEY,
        vendor_name VARCHAR(100) NOT NULL,
        group_id INT NOT NULL,
        CONSTRAINT fk_group FOREIGN KEY (group_id) 
        REFERENCES procurement.vendor_groups(group_id)
)



