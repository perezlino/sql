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

 ALTER TABLE Sales.Events
 ADD CONSTRAINT pk_sales PRIMARY KEY (event_id) 

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

DROP TABLE Vendors;

CREATE TABLE Procurement.Vendors (
        vendor_id INT IDENTITY PRIMARY KEY,
        vendor_name VARCHAR(100) NOT NULL,
        group_id INT NOT NULL,
        CONSTRAINT fk_group FOREIGN KEY (group_id) 
        REFERENCES procurement.vendor_groups(group_id)
)

/* La tabla Vendor_groups se denomina ahora tabla padre y es la tabla a la que hace referencia la restricción 
   de foreign key. La tabla Vendors se denomina tabla hija y es la tabla a la que se aplica la restricción de 
   foreign key.

   En la sentencia anterior, la siguiente cláusula crea una restricción FOREIGN KEY denominada fk_group que 
   vincula el group_id de la tabla Vendors con el group_id de la tabla Vendor_groups:  */

   CONSTRAINT fk_group FOREIGN KEY (group_id) REFERENCES procurement.vendor_groups(group_id)


/* Sintaxis de la restricción FOREIGN KEY de SQL Server
   ====================================================

   La sintaxis general para crear una restricción FOREIGN KEY es la siguiente:   

                              CONSTRAINT fk_constraint_name 
                              FOREIGN KEY (column_1, column2,...)
                              REFERENCES parent_table_name(column1,column2,..)


   Examinemos esta sintaxis en detalle.

   En primer lugar, especifique el nombre de la restricción FOREIGN KEY después de la palabra clave CONSTRAINT. 
   El nombre de la restricción es opcional, por lo que es posible definir una restricción FOREIGN KEY de la 
   siguiente forma:

                              FOREIGN KEY (column_1, column2,...)
                              REFERENCES parent_table_name(column1,column2,..)

   
   En este caso, SQL Server generará automáticamente un nombre para la restricción FOREIGN KEY.

   En segundo lugar, especifique una lista de columnas de clave foránea separadas por comas y encerradas entre 
   paréntesis después de la palabra clave FOREIGN KEY.

   En tercer lugar, especifique el nombre de la tabla principal a la que hace referencia la clave foránea y una 
   lista de columnas separadas por comas que tenga un vínculo con la columna de la tabla secundaria.


   Ejemplo de restricción FOREIGN KEY de SQL Server
   ================================================

   En primer lugar, inserte algunas filas en la tabla Vendor_groups:  */

INSERT INTO Procurement.Vendor_groups(group_name)
VALUES('Third-Party Vendors'),
      ('Interco Vendors'),
      ('One-time Vendors')


-- En segundo lugar, inserte un nuevo vendor con un vendor group en la tabla Vendors:

INSERT INTO Procurement.Vendors(vendor_name, group_id)
VALUES('ABC Corp',1)

-- La sentencia ha funcionado como se esperaba.
-- En tercer lugar, intente insertar un nuevo vendor cuyo vendor group no exista en la tabla Vendor_groups:

INSERT INTO Procurement.Vendors(vendor_name, group_id)
VALUES('XYZ Corp',4)

-- SQL Server emitió el siguiente error:

The INSERT statement conflicted with the FOREIGN KEY constraint "fk_group". The conflict occurred in 
database "AdventureWorks2019", table "procurement.vendor_groups", column 'group_id'.


/* Acciones referenciales
   ======================

   La restricción de foreign key garantiza la integridad referencial. Esto significa que sólo se puede insertar 
   una fila en la tabla hija si existe una fila correspondiente en la tabla padre.

   Además, la restricción de foreign key permite definir las acciones referenciales cuando la fila de la tabla 
   principal se actualiza o se elimina de la siguiente manera:

                                    FOREIGN KEY (foreign_key_columns)
                                       REFERENCES parent_table(parent_key_columns)
                                       ON UPDATE action 
                                       ON DELETE action

   ON UPDATE y ON DELETE especifican qué acción se ejecutará cuando se actualice y se elimine una fila de la 
   tabla padre. Las acciones permitidas son las siguientes : NO ACTION, CASCADE, SET NULL y SET DEFAULT


      Acciones de borrado de filas en la tabla padre (Delete actions)
      ===============================================================

      Si elimina una o más filas de la tabla padre, puede establecer una de las siguientes acciones:

      ON DELETE NO ACTION: SQL Server genera un error y anula la acción de eliminación de la fila de la 
                           tabla principal.

      ON DELETE CASCADE: SQL Server elimina la fila de la tabla hija correspondiente a la fila eliminada de 
                         la tabla padre. Al borrar un dato en la tabla padre se realiza lo mismo en la tabla 
                         hija.

      ON DELETE SET NULL: SQL Server establece las filas de la tabla hija en NULL si se eliminan las filas 
                          correspondientes de la tabla padre. Para ejecutar esta acción, las columnas de la 
                          foreign key deben ser anulables. Al borrar un dato en la tabla padre se rellena con 
                          un NULL en la tabla hija.

      ON DELETE SET DEFAULT: SQL Server establece las filas de la tabla hija en sus valores por defecto si se 
                             eliminan las filas correspondientes de la tabla padre. Para ejecutar esta acción, 
                             las columnas de foreign key deben tener definiciones por defecto. El valor elegido 
                             como predeterminado (default) debe existir en la tabla principal. Tenga en cuenta 
                             que una columna anulable tiene un valor predeterminado de NULL si no se especifica 
                             ningún valor predeterminado.

      Por defecto, SQL Server aplica ON DELETE NO ACTION si no se especifica explícitamente ninguna acción.

      Un ejemplo:   */

CREATE TABLE Procurement.Vendors(
        vendor_id INT IDENTITY PRIMARY KEY,
        vendor_name VARCHAR(100) NOT NULL,
        group_id INT NOT NULL,
        CONSTRAINT fk_group FOREIGN KEY (group_id) 
        REFERENCES procurement.vendor_groups(group_id) ON DELETE CASCADE
)

/*    Acción de actualización de filas en la tabla padre (Update action)
      ==================================================================

      Si actualiza una o más filas en la tabla padre, puede establecer una de las siguientes acciones:

      ON UPDATE NO ACTION: SQL Server genera un error y anula la acción de actualización en la fila de la 
                           tabla principal.

      ON UPDATE CASCADE: SQL Server actualiza las filas correspondientes de la tabla secundaria cuando se 
                         actualizan las filas de la tabla principal. Al actualizar un dato en la tabla padre 
                         se realiza lo mismo en la tabla hija.

      ON UPDATE SET NULL: SQL Server establece las filas de la tabla hija en NULL cuando se actualiza la fila 
                          correspondiente de la tabla padre. Tenga en cuenta que las columnas de la foreign key 
                          deben ser anulables para que se ejecute esta acción. Al actualizar un dato en la tabla 
                          padre se rellena con un NULL en la tabla hija.

      ON UPDATE SET DEFAULT: SQL Server establece los valores por defecto para las filas de la tabla hija que 
                             tienen actualizadas las filas correspondientes de la tabla padre.

      Por defecto, SQL Server aplica ON DELETE NO ACTION si no se especifica explícitamente ninguna acción.


/* =============================================================================================================
   =============================================================================================================

   =============
   === CHECK ===
   =============

   La restricción CHECK permite especificar los valores de una columna que deben satisfacer una expresión 
   booleana.

   Por ejemplo, para exigir precios unitarios positivos, puede utilizar:   */

CREATE SCHEMA Test
GO

CREATE TABLE Test.Products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2) CHECK(unit_price > 0)
)

-- Como puede ver, la definición de la restricción CHECK viene después del tipo de datos. Consiste en la 
-- palabra clave CHECK seguida de una expresión lógica entre paréntesis:

CHECK(unit_price > 0)

-- También puede asignar a la restricción un nombre distinto utilizando la palabra clave CONSTRAINT del 
-- siguiente modo:

CREATE TABLE Test.Products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2) CONSTRAINT positive_price CHECK(unit_price > 0)
)

-- Los nombres explícitos ayudan a clasificar los mensajes de error y permiten hacer referencia a las 
-- restricciones cuando se desea modificarlas.

-- Si no especifica un nombre de restricción de esta forma, SQL Server genera automáticamente un nombre 
-- por usted.

-- Consulte la siguiente sentencia de inserción:

INSERT INTO Test.Products(product_name, unit_price)
VALUES ('Awesome Free Bike', 0)

-- SQL Server emitió el siguiente error:

The INSERT statement conflicted with the CHECK constraint "positive_price". The conflict occurred in 
database "AdventureWorks2019", table "test.products", column 'unit_price'.

-- El error se ha producido porque el precio unitario no es mayor que cero, tal y como se especifica en la 
-- restricción CHECK.

-- La siguiente sentencia funciona correctamente porque la expresión lógica definida en la restricción CHECK 
-- se evalúa como TRUE:

INSERT INTO Test.Products(product_name, unit_price)
VALUES ('Awesome Bike', 599)


/* La restricción CHECK de SQL Server y NULL
   =========================================

   Las restricciones CHECK rechazan valores que hacen que la expresión booleana se evalúe como FALSE.

   Dado que NULL se evalúa como UNKNOWN, se puede utilizar en la expresión para omitir una restricción.

   Por ejemplo, puede insertar un producto cuyo precio unitario sea NULL como se muestra en la siguiente 
   consulta:  */

INSERT INTO Test.Products(product_name, unit_price)
VALUES ('Another Awesome Bike', NULL)

-- Este es el resultado:

(1 row affected)

/* SQL Server insertó NULL en la columna unit_price y no devolvió ningún error.

   Para solucionarlo, debe utilizar una restricción NOT NULL para la columna unit_price.


   Restricción CHECK referida a varias columnas
   ============================================

   Una restricción CHECK puede hacer referencia a varias columnas. Por ejemplo, almacena un precio normal y 
   un precio con descuento en la tabla Test.Products y desea asegurarse de que el precio con descuento sea 
   siempre inferior al precio normal:   */

CREATE TABLE Test.Products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2) CHECK(unit_price > 0),
    discounted_price DEC(10,2) CHECK(discounted_price > 0),
    CHECK(discounted_price < unit_price)
)

/* Las dos primeras restricciones para unit_price y discounted_price deberían resultarle familiares.

   La tercera restricción utiliza una nueva sintaxis que no está asociada a una columna concreta. En su lugar, 
   aparece como un elemento de línea independiente en la lista de columnas separadas por comas.

   Las dos primeras restricciones de columna son restricciones de columna, mientras que la tercera es una 
   restricción de tabla.

   Tenga en cuenta que puede escribir restricciones de columna como restricciones de tabla. Sin embargo, no 
   puede escribir restricciones de tabla como restricciones de columna. Por ejemplo, puede reescribir la 
   sentencia anterior de la siguiente manera:   */
 
CREATE TABLE Test.Products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2),
    discounted_price DEC(10,2),
    CHECK(unit_price > 0),
    CHECK(discounted_price > 0),
    CHECK(discounted_price > unit_price)
)

-- o incluso:

CREATE TABLE Test.Products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2),
    discounted_price DEC(10,2),
    CHECK(unit_price > 0),
    CHECK(discounted_price > 0 AND discounted_price > unit_price)
)

-- También puede asignar un nombre a una restricción de tabla del mismo modo que a una restricción de columna:

CREATE TABLE Test.Products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2),
    discounted_price DEC(10,2),
    CHECK(unit_price > 0),
    CHECK(discounted_price > 0),
    CONSTRAINT valid_prices CHECK(discounted_price > unit_price)
)


/* Añadir restricciones CHECK a una tabla existente
   ================================================

   Para añadir una restricción CHECK a una tabla existente, utilice la sentencia ALTER TABLE ADD CONSTRAINT.

   Supongamos que tiene la siguiente tabla Test.Products:   */

CREATE TABLE Test.Products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2) NOT NULL
)

-- Para añadir una restricción CHECK a la tabla Test.Products, utilice la siguiente sentencia:

ALTER TABLE Test.Products
ADD CONSTRAINT positive_price CHECK(unit_price > 0)

-- Para añadir una nueva columna con una restricción CHECK, utilice la siguiente sentencia:

ALTER TABLE Test.Products
ADD discounted_price DEC(10,2)
CHECK(discounted_price > 0)

-- Para añadir una restricción CHECK denominada valid_price, utilice la siguiente sentencia:

ALTER TABLE Test.Products
ADD CONSTRAINT valid_price 
CHECK(unit_price > discounted_price)


/* Eliminación de restricciones CHECK
   ==================================

   Para eliminar una restricción CHECK, utilice la sentencia ALTER TABLE DROP CONSTRAINT:

                                 ALTER TABLE table_name
                                 DROP CONSTRAINT constraint_name


   Si asigna un nombre específico a una restricción CHECK, puede hacer referencia al nombre en la sentencia.

   Sin embargo, en caso de que no haya asignado un nombre concreto a la restricción CHECK, deberá buscarla 
   mediante la siguiente sentencia:

                                 EXEC sp_help 'table_name'


   Por ejemplo:  */

EXEC sp_help 'Test.Products'


-- La siguiente sentencia elimina la restricción positive_price:

ALTER TABLE Test.Products
DROP CONSTRAINT positive_price


/* Desactivación de las restricciones CHECK para inserción o actualización
   =======================================================================

   Para desactivar una restricción CHECK para insertar o actualizar, utilice la siguiente sentencia:

                                 ALTER TABLE table_name
                                 NOCHECK CONSTRAINT constraint_name


   La siguiente sentencia desactiva la restricción valid_price:  */

ALTER TABLE Test.Products
NO CHECK CONSTRAINT valid_price


/* =============================================================================================================
   =============================================================================================================

   ==============
   === UNIQUE ===
   ==============

   Las restricciones UNIQUE de SQL Server permiten garantizar que los datos almacenados en una columna, o en un 
   grupo de columnas, son únicos entre las filas de una tabla.

   La siguiente sentencia crea una tabla cuyos datos en la columna email son únicos entre las filas de la tabla 
   hr.persons:   */

CREATE SCHEMA Hr
GO

CREATE TABLE Hr.Persons(
    person_id INT IDENTITY PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE
)

-- En esta sintaxis, la restricción UNIQUE se define como una restricción de columna. También puede definir la 
-- restricción UNIQUE como una restricción de tabla, de esta forma:

CREATE TABLE Hr.Persons(
    person_id INT IDENTITY PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    UNIQUE(email)
)

/* Detrás de las escenas, SQL Server crea automáticamente un índice UNIQUE para hacer cumplir la unicidad de los 
   datos almacenados en las columnas que participan en la restricción UNIQUE. Por lo tanto, si intenta insertar 
   una fila duplicada, SQL Server rechaza el cambio y devuelve un mensaje de error que indica que se ha infringido 
   la restricción UNIQUE.

   La siguiente sentencia inserta una nueva fila en la tabla Hr.Persons:  */

INSERT INTO Hr.Persons(first_name, last_name, email)
VALUES('John','Doe','j.doe@bike.stores')

-- La sentencia funciona como se espera. Sin embargo, la siguiente sentencia falla debido al email duplicado:

INSERT INTO Hr.Persons(first_name, last_name, email)
VALUES('Jane','Doe','j.doe@bike.stores')

-- SQL Server emitió el siguiente mensaje de error:

Violation of UNIQUE KEY constraint 'UQ__persons__AB6E616417240E4E'. Cannot insert duplicate key in object 'hr.persons'. 
The duplicate key value is (j.doe@bike.stores).

/* Si no especifica un nombre independiente para la restricción UNIQUE, SQL Server generará automáticamente 
   un nombre para ella. En este ejemplo, el nombre de la restricción es UQ__persons__AB6E616417240E4E, que no es 
   muy legible.

   Para asignar un nombre concreto a una restricción UNIQUE, utilice la palabra clave CONSTRAINT del siguiente 
   modo:   */

CREATE TABLE Hr.Persons(
    person_id INT IDENTITY PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    CONSTRAINT unique_email UNIQUE(email)
)

/* A continuación se indican las ventajas de asignar un nombre específico a una restricción UNIQUE:

   - Es más fácil clasificar el mensaje de error.
   - Puede hacer referencia al nombre de la restricción cuando desee modificarla.


   Restricción UNIQUE v/s restricción PRIMARY KEY
   ==============================================

   Aunque tanto la restricción UNIQUE como la PRIMARY KEY imponen la unicidad de los datos, debe utilizar la 
   restricción UNIQUE en lugar de la PRIMARY KEY cuando desee imponer la unicidad de una columna, o de un 
   grupo de columnas, que no sean las columnas de clave primaria.

   A diferencia de las restricciones PRIMARY KEY, las restricciones UNIQUE admiten NULL. Además, las 
   restricciones UNIQUE tratan los NULL como valores normales, por lo que sólo permiten un NULL por columna.

   La siguiente sentencia inserta una fila cuyo valor en la columna email es NULL:   */

INSERT INTO Hr.Persons(first_name, last_name)
VALUES('John','Smith')

-- Ahora, si intenta insertar un NULL más en la columna email, obtendrá un error:

INSERT INTO Hr.Persons(first_name, last_name)
VALUES('Lily','Bush')

-- Este es el resultado:

Violation of UNIQUE KEY constraint 'UQ__persons__AB6E616417240E4E'. Cannot insert duplicate key in 
object 'hr.persons'. The duplicate key value is (<NULL>).


/* Restricciones UNIQUE para un grupo de columnas
   ==============================================

   Para definir una restricción UNIQUE para un grupo de columnas, escríbala como una restricción de tabla con 
   los nombres de las columnas separados por comas de la siguiente forma:

                                    CREATE TABLE table_name (
                                       key_column data_type PRIMARY KEY,
                                       column1 data_type,
                                       column2 data_type,
                                       column3 data_type,
                                       ...,
                                       UNIQUE (column1,column2)
                                    )

   El siguiente ejemplo crea una restricción UNIQUE que consta de dos columnas person_id y skill_id:   */

CREATE TABLE Hr.Person_skills(
    id INT IDENTITY PRIMARY KEY,
    person_id int,
    skill_id int,
    updated_at DATETIME,
    UNIQUE (person_id, skill_id)
)


/* Adición de restricciones UNIQUE a columnas existentes
   =====================================================

   Cuando se añade una restricción UNIQUE a una columna existente o a un grupo de columnas de una tabla, 
   SQL Server examina primero los datos existentes en estas columnas para asegurarse de que todos los 
   valores son únicos. Si SQL Server encuentra valores duplicados, devuelve un error y no añade la 
   restricción UNIQUE.

   A continuación se muestra la sintaxis para añadir una restricción UNIQUE a una tabla:

                                       ALTER TABLE table_name
                                       ADD CONSTRAINT constraint_name 
                                       UNIQUE(column1, column2,...)


   Suponga que tiene la siguiente tabla Hr.Persons:   */

CREATE TABLE Hr.Persons(
    person_id INT IDENTITY PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(20),
)

-- La siguiente sentencia añade una restricción UNIQUE a la columna email:

ALTER TABLE Hr.Persons
ADD CONSTRAINT unique_email UNIQUE(email)

-- Del mismo modo, la siguiente sentencia añade una restricción UNIQUE a la columna phone:

ALTER TABLE Hr.Persons
ADD CONSTRAINT unique_phone UNIQUE(phone)


/* Eliminación de restricciones UNIQUE
   ===================================

   Para definir una restricción UNIQUE, utilice la sentencia ALTER TABLE DROP CONSTRAINT como se indica a 
   continuación:

                                    ALTER TABLE table_name
                                    DROP CONSTRAINT constraint_name

-- La siguiente sentencia elimina la restricción unique_phone de la tabla Hr.Person:  */

ALTER TABLE Hr.Persons
DROP CONSTRAINT unique_phone


/* Modificar restricciones UNIQUE
   ==============================

   SQL Server no dispone de ninguna sentencia directa para modificar una restricción UNIQUE, por lo tanto, 
   es necesario eliminar primero la restricción y volver a crearla si se desea cambiar la restricción.



/* =============================================================================================================
   =============================================================================================================

   ================
   === NOT NULL ===
   ================

   Las restricciones NOT NULL de SQL Server simplemente especifican que una columna no debe asumir el 
   valor NULL.

   El siguiente ejemplo crea una tabla con restricciones NOT NULL para las columnas: first_name, last_name 
   y email:  */

CREATE SCHEMA Hr
GO

CREATE TABLE Hr.Persons(
    person_id INT IDENTITY PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20)
)

/* Tenga en cuenta que las restricciones NOT NULL siempre se escriben como restricciones de columna.

   Por defecto, si no se especifica la restricción NOT NULL, SQL Server permitirá que la columna acepte NULL. 
   En este ejemplo, la columna teléfono puede aceptar NULL.


   Añadir la restricción NOT NULL a una columna existente
   ======================================================

   Para añadir la restricción NOT NULL a una columna existente, siga estos pasos:

   En primer lugar, actualice la tabla para que no haya NULL en la columna:

                                       UPDATE table_name
                                       SET column_name = <value>
                                       WHERE column_name IS NULL

   En segundo lugar, modifique la tabla para cambiar la propiedad de la columna:

                                    ALTER TABLE table_name
                                    ALTER COLUMN column_name data_type NOT NULL

   Por ejemplo, para añadir la restricción NOT NULL a la columna phone de la tabla Hr.Persons, utilice las 
   siguientes sentencias:

   En primer lugar, si una persona no tiene número de teléfono, actualice el número de teléfono al número de 
   teléfono de la empresa, por ejemplo, (408) 123 4567:  */

UPDATE Hr.Persons
SET phone = "(408) 123 4567"
WHERE phone IS NULL

-- En segundo lugar, modifica la propiedad de la columna phone:

ALTER TABLE Hr.Persons
ALTER COLUMN phone VARCHAR(20) NOT NULL


/* Eliminación de la restricción NOT NULL
   ======================================

   Para eliminar la restricción NOT NULL de una columna, utilice la sentencia ALTER TABLE ALTER COLUMN como 
   se indica a continuación:

                                    ALTER TABLE table_name
                                    ALTER COLUMN column_name data_type NULL

   Por ejemplo, para eliminar la restricción NOT NULL de la columna phone, utilice la siguiente sentencia:  */

ALTER TABLE Hr.Persons
ALTER COLUMN phone VARCHAR(20) NULL