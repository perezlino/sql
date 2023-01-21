-- ======================================================
-- ================ MODIFICAR UNA TABLA =================
-- ======================================================

/* ===================================
   === AGREGAR COLUMNA A UNA TABLA ===
   ===================================

   NOTA: No hay forma de insertar una nueva columna en una posición concreta de la tabla. La columna, 
         que se añade mediante la cláusula ADD, se inserta siempre al final de la tabla.


   La siguiente sentencia ALTER TABLE ADD añade una nueva columna a una tabla:

                                ALTER TABLE table_name
                                ADD <column_name> <data_type> <column_constraint>


   En esta sentencia:

   - En primer lugar, especifique el nombre de la tabla en la que desea añadir la nueva columna.
   - En segundo lugar, especifique el nombre de la columna, su tipo de datos y la restricción, si procede.

   Si desea añadir varias columnas a la vez a una tabla mediante una única sentencia ALTER TABLE, utilice 
   la siguiente sintaxis:

                                ALTER TABLE table_name
                                ADD 
                                    <column_name_1> <data_type_1> <column_constraint_1>,
                                    <column_name_2> <data_type_2> <column_constraint_2>,
                                    ...,
                                    <column_name_n> <data_type_n> <column_constraint_n>

   En esta sintaxis, se especifica una lista separada por comas de columnas que se desea añadir a una tabla 
   después de la cláusula ADD.

   Tenga en cuenta que SQL Server no admite la sintaxis para añadir una columna a una tabla después de una 
   columna existente como hace MySQL.


   Ejemplos de columnas ALTER TABLE ADD de SQL Server
   ==================================================

   La siguiente sentencia crea una nueva tabla denominada Sales.Quotations:  */

CREATE TABLE Sales.Quotations (
    quotation_no INT IDENTITY PRIMARY KEY,
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL
)

-- Para añadir una nueva columna denominada description a la tabla Sales.Quotations, utilice la siguiente 
-- sentencia:

ALTER TABLE Sales.Quotations
ADD description VARCHAR (255) NOT NULL


-- La siguiente sentencia añade dos nuevas columnas denominadas amount y customer_name a la tabla 
-- Sales.Quotations:

ALTER TABLE Sales.Quotations
    ADD 
        amount DECIMAL (10, 2) NOT NULL,
        customer_name VARCHAR (50) NOT NULL


-- =============================================================================================================
-- =============================================================================================================

/* =======================================================
   === MODIFICACION DE LAS PROPIEDADES DE LAS COLUMNAS ===
   =======================================================

   SQL Server permite realizar los siguientes cambios en una columna existente de una tabla:

    - Modificar el tipo de datos
    - Modificar el tamaño
    - Añadir una restricción NOT NULL


   Modificar el tipo de datos de la columna
   ========================================

   Para modificar el tipo de datos de una columna, se utiliza la siguiente sentencia:

                            ALTER TABLE table_name 
                            ALTER COLUMN <column_name> <new_data_type(size)>

   El nuevo tipo de datos debe ser compatible con el antiguo, de lo contrario, obtendrá un error de conversión 
   en caso de que la columna tenga datos y falle la conversión.

   Vea el siguiente ejemplo.

   En primer lugar, cree una nueva tabla con una columna cuyo tipo de datos sea INT:  */

CREATE TABLE t1 (c INT)

-- En segundo lugar, inserte algunas filas en la tabla:

INSERT INTO t1
VALUES
    (1),
    (2),
    (3)

-- En segundo lugar, modifique el tipo de datos de la columna de INT a VARCHAR:

ALTER TABLE t1 
ALTER COLUMN c VARCHAR (2)

-- En tercer lugar, inserte una nueva fila con los datos de una cadena de caracteres:

INSERT INTO t1
VALUES ('@')

-- En cuarto lugar, modifique el tipo de datos de la columna de VARCHAR a INT:

ALTER TABLE t1 
ALTER COLUMN c INT

-- SQL Server emitió el siguiente error:

Conversion failed when converting the varchar value '@' to data type int.


-- Cambiar el tamaño de una columna
-- ================================

-- La siguiente sentencia crea una nueva tabla con una columna cuyo tipo de datos es VARCHAR(10):

CREATE TABLE t2 (c VARCHAR(10))

-- Insertemos algunos datos de ejemplo en la tabla t2:

INSERT INTO t2
VALUES
    ('SQL Server'),
    ('Modify'),
    ('Column')

-- Puedes aumentar el tamaño de la columna de la siguiente manera:

ALTER TABLE t2 
ALTER COLUMN c VARCHAR (50)

-- Sin embargo, cuando se reduce el tamaño de la columna, SQL Server comprueba los datos existentes 
-- para ver si puede convertir los datos basándose en el nuevo tamaño. Si la conversión falla, SQL Server 
-- finaliza la sentencia y emite un mensaje de error.

-- Por ejemplo, si reduce el tamaño de la columna c a 5 caracteres:

ALTER TABLE t2 
ALTER COLUMN c VARCHAR (5)

-- SQL Server emitió el siguiente error:

String or binary data would be truncated.


-- Añadir una restricción NOT NULL a una columna anulable
-- ======================================================

-- La siguiente sentencia crea una nueva tabla con una columna anulable:

CREATE TABLE t3 (c VARCHAR(50))

-- La siguiente sentencia inserta algunas filas en la tabla:

INSERT INTO t3
VALUES
    ('Nullable column'),
    (NULL)

-- Si desea añadir la restricción NOT NULL a la columna c, primero debe actualizar NULL a no nulo, por 
-- ejemplo:

UPDATE t3
SET c = ''
WHERE c IS NULL

-- Y luego añada la restricción NOT NULL:

ALTER TABLE t3 
ALTER COLUMN c VARCHAR (20) NOT NULL


-- =============================================================================================================
-- =============================================================================================================

/* =========================================
   === ELIMINAR UNA COLUMNA DE UNA TABLA ===
   =========================================

   A veces, es necesario eliminar una o varias columnas no utilizadas u obsoletas de una tabla. Para ello, 
   utilice la sentencia ALTER TABLE DROP COLUMN como se indica a continuación: 

                                            ALTER TABLE table_name
                                            DROP COLUMN column_name

   En esta sintaxis:

    - En primer lugar, especifique el nombre de la tabla de la que desea eliminar la columna.
    - En segundo lugar, especifique el nombre de la columna que desea eliminar.

   Si la columna que desea eliminar tiene una restricción CHECK, debe eliminar primero la restricción antes de 
   eliminar la columna. Además, SQL Server no permite eliminar una columna que tenga una restricción PRIMARY KEY 
   o FOREIGN KEY.

   Si desea eliminar varias columnas a la vez, utilice la siguiente sintaxis:

                                        ALTER TABLE table_name
                                        DROP COLUMN <column_name_1>, <column_name_2>,...


   En esta sintaxis, se especifican las columnas que se desean eliminar como una lista de columnas separadas por 
   comas en la cláusula DROP COLUMN.


   Ejemplos de ALTER TABLE DROP COLUMN de SQL Server
   =================================================

   Vamos a crear una nueva tabla llamada Sales.Price_lists para la demostración:   */

CREATE TABLE Sales.Price_lists(
    product_id int,
    valid_from DATE,
    price DEC(10,2) NOT NULL CONSTRAINT ck_positive_price CHECK(price >= 0),
    discount DEC(10,2) NOT NULL,
    surcharge DEC(10,2) NOT NULL,
    note VARCHAR(255),
    PRIMARY KEY(product_id, valid_from)
)

-- La siguiente sentencia elimina la columna "note" de la tabla "Price_lists":

ALTER TABLE sales.Price_lists
DROP COLUMN note

-- La columna "price" tiene una restricción CHECK, por lo tanto, no puede eliminarla. Si intenta ejecutar la 
-- siguiente sentencia, obtendrá un error:

ALTER TABLE sales.Price_lists
DROP COLUMN price

-- Este es el mensaje de error:

The object 'ck_positive_price' is dependent on column 'price'.

-- Para eliminar la columna "price", primero elimine su restricción CHECK:

ALTER TABLE sales.Price_lists
DROP CONSTRAINT ck_positive_price

-- Y, a continuación, elimine la columna "price":

ALTER TABLE sales.Price_lists
DROP COLUMN price

-- El siguiente ejemplo elimina dos columnas "discount" y "surcharge" a la vez:

ALTER TABLE sales.Price_lists
DROP COLUMN discount, surcharge


-- =============================================================================================================
-- =============================================================================================================

/* ===================================
   === CAMBIAR NOMBRE DE UNA TABLA ===
   ===================================

   SQL Server no tiene ninguna sentencia que renombre directamente una tabla. Sin embargo, le proporciona un 
   stored procedure llamado "sp_rename" que le permite cambiar el nombre de una tabla.

   A continuación, se muestra la sintaxis de uso del stored procedure "sp_rename" para cambiar el nombre de 
   una tabla:

                            EXEC sp_rename 'old_table_name', 'new_table_name'


   Tenga en cuenta que tanto el nombre antiguo como el nuevo de la tabla cuyo nombre se modifica deben ir entre 
   comillas simples.

   Veamos el siguiente ejemplo.

   En primer lugar, cree una nueva tabla denominada Sales.Contr para almacenar los datos de los contratos de 
   venta:    */

CREATE TABLE Sales.Contr(
    contract_no INT IDENTITY PRIMARY KEY,
    start_date DATE NOT NULL,
    expired_date DATE,
    customer_id INT,
    amount DECIMAL (10, 2)
)

-- En segundo lugar, utilice el stored procedure "sp_rename" para renombrar la tabla Sales.Contr a Contracts en 
-- el sales schema:

EXEC sp_rename 'Sales.Contr', 'Contracts'

-- SQL Server devuelve el siguiente mensaje:

Caution: Changing any part of an object name could break scripts and stored procedures.


-- =============================================================================================================
-- =============================================================================================================

/* =====================================
   === CAMBIAR NOMBRE DE UNA COLUMNA ===
   =====================================

   Vamos a crear una copia de la tabla Sales.Customer y cambiaremos el nombre de la columna "AccountNumber".
   La nueva tabla se llamará Sales.Customers y la columna se renombrará como "NumCuenta":   */

SELECT *
INTO Sales.Customers
FROM Sales.Customer

sp_RENAME 'Sales.Customers.AccountNumber', 'NumCuenta' , 'COLUMN'


-- =============================================================================================================
-- =============================================================================================================

/* ======================================================================
   === CAMBIO DE NOMBRE DE TABLAS Y OTROS OBJETOS DE LA BASE DE DATOS ===
   ======================================================================

   NOTA: El procedimiento de sistema "sp_rename" modifica el nombre de una tabla existente (y cualquier otro 
         objeto de base de datos existente, como bases de datos, vistas o procedimientos almacenados)

   NOTA: No utilice el procedimiento del sistema sp_rename, porque el cambio de los nombres de los objetos puede 
         influir en otros objetos de la base de datos que hacen referencia a ellos. Elimine el objeto y vuelva a 
         crearlo con el nuevo nombre.   */

 USE sample;
 EXEC sp_rename @objname = department, @newname = subdivision

 USE sample;
 EXEC sp_rename @objname = 'Sales.Customer', @newname = Cliente