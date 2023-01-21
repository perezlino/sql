-- ======================================================
-- ==================== CREAR TABLA =====================
-- ======================================================

/* Las tablas se utilizan para almacenar datos en la base de datos. Las tablas tienen 
   un nombre único dentro de una base de datos y un schema. Cada tabla contiene una o 
   varias columnas. Y cada columna tiene un tipo de datos asociado que define el tipo de 
   datos que puede almacenar, por ejemplo, números, strings o datos temporales.

   Para crear una nueva tabla, se utiliza la sentencia CREATE TABLE de la siguiente manera:

                    CREATE TABLE [database_name.][schema_name.]table_name (
                        pk_column data_type PRIMARY KEY,
                        column_1 data_type NOT NULL,
                        column_2 data_type,
                        ...,
                        table_constraints
                    )

   En esta sintaxis:

   - En primer lugar, especifique el nombre de la base de datos en la que se crea la tabla. 
     "database_name" debe ser el nombre de una base de datos existente. Si no lo especifica, 
     el nombre de la base de datos será por defecto la base de datos actual.

   - En segundo lugar, especifique el schema al que pertenece la nueva tabla.

   - Tercero, especifique el nombre de la nueva tabla.

   - En cuarto lugar, cada tabla debe tener una clave primaria formada por una o varias columnas. 
     Normalmente, se enumeran primero las columnas de la clave primaria y después las demás columnas. 
     Si la clave primaria sólo contiene una columna, puede utilizar las palabras clave PRIMARY KEY 
     después del nombre de la columna. Si la clave primaria consta de dos o más columnas, debe 
     especificar la restricción PRIMARY KEY como restricción de tabla. Cada columna tiene un tipo de 
     datos asociado especificado tras su nombre en la sentencia. Una columna puede tener una o varias 
     restricciones de columna, como NOT NULL y UNIQUE.

   - En quinto lugar, una tabla puede tener algunas restricciones especificadas en la sección de 
     restricciones de la tabla, como FOREIGN KEY, PRIMARY KEY, UNIQUE y CHECK.

   Tenga en cuenta que CREATE TABLE es complejo y tiene más opciones que la sintaxis anterior. Le 
   presentaremos gradualmente cada una de las opciones individuales en los siguientes tutoriales.


   Ejemplo de SQL Server CREATE TABLE
   ==================================

   La siguiente sentencia crea una nueva tabla llamada Sales.Visits para realizar un seguimiento de las 
   visitas de los clientes a las tiendas:     */

CREATE TABLE Sales.Visits (
    visit_id INT PRIMARY KEY IDENTITY (1, 1),
    first_name VARCHAR (50) NOT NULL,
    last_name VARCHAR (50) NOT NULL,
    visited_at DATETIME,
    phone VARCHAR(20),
    store_id INT NOT NULL,
    FOREIGN KEY (store_id) REFERENCES Sales.Stores (store_id)
)

/* En este ejemplo:

   Como no especificamos explícitamente el nombre de la base de datos en la que se crea la tabla, la tabla 
   visitas se crea en la base de datos AdventureWorks2019. Para el schema, lo especificamos explícitamente, 
   por lo tanto, la tabla "visits" se crea en el schema "sales".

   La tabla "visits" contiene seis columnas:

   La columna "visit_id" es la columna de clave primaria de la tabla. El IDENTITY(1,1) indica a SQL Server 
   que genere automáticamente números enteros para la columna empezando por uno y aumentando en uno para 
   cada nueva fila.

   Las columnas "first_name" y "last_name" son columnas de cadena de caracteres de tipo VARCHAR. Estas 
   columnas pueden almacenar hasta 50 caracteres.

   La columna "visited_at" es una columna DATETIME que registra la fecha y hora en la que el cliente visita 
   la tienda.

   La columna "phone" es una columna de cadena de caracteres variables que acepta NULL.

   La columna "store_id" almacena los números de identificación que identifican la tienda que visitó el 
   cliente.

   Al final de la definición de la tabla hay una restricción FOREIGN KEY. Esta clave foránea garantiza que 
   los valores de la columna "store_id" de la tabla "visits" deben estar disponibles en la columna store_id 
   de la tabla stores. 