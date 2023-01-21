-- ======================================================
-- ================ INSERTAR REGISTROS ==================
-- ======================================================
/*
   |-----------------------------------------------------------------------------------------------|
   | La inserción de valores en algunas (pero no todas) de las columnas de una tabla suele         |
   | requerir la especificación explícita de las columnas correspondientes. Las columnas omitidas  |
   | deben ser anulables o tener un valor DEFAULT.                                                 |
   |-----------------------------------------------------------------------------------------------|

   |-----------------------------------------------------------------------------------------------|
   | El orden de los nombres de las columnas en la cláusula VALUE de la sentencia INSERT puede ser |
   |  diferente del orden original de esas columnas, que se determina en la sentencia CREATE TABLE.|                                               |
   |-----------------------------------------------------------------------------------------------|


   Para añadir una o varias filas a una tabla, se utiliza la sentencia INSERT. A continuación se 
   ilustra la forma más básica de la sentencia INSERT:

                                INSERT INTO table_name (column_list)
                                VALUES (value_list)

   Examinemos esta sintaxis con más detalle.

   - En primer lugar, especifique el nombre de la tabla que desea insertar. Normalmente, se hace 
     referencia al nombre de la tabla por el nombre del schema, por ejemplo, Production.Product, donde 
     Production es el nombre del schema y Product es el nombre de la tabla.

   - En segundo lugar, especifique una lista de una o varias columnas en las que desee insertar datos. 
     Debe encerrar la lista de columnas entre paréntesis y separar las columnas mediante comas.

     Si una columna de una tabla no aparece en la lista de columnas, SQL Server debe poder proporcionar un 
     valor para la inserción o no se podrá insertar la fila.

     SQL Server utiliza automáticamente el siguiente valor para la columna que está disponible en la tabla, 
     pero no aparece en la lista de columnas de la sentencia INSERT:

        - El siguiente valor incremental si la columna tiene una propiedad IDENTITY.
        - El valor por defecto si la columna tiene especificado un valor por defecto.
        - El valor timestamp actual si el tipo de datos de la columna es un tipo de datos timestamp.
        - El valor NULL si la columna es anulable.
        - El valor calculado si la columna es una columna computada.

   - En tercer lugar, se proporciona una lista de valores que se insertarán en la cláusula VALUES. Cada 
     columna de la lista de columnas debe tener un valor correspondiente en la lista de valores. Además, 
     debe encerrar la lista de valores entre paréntesis.


   Ejemplos de sentencias INSERT de SQL Server
   ===========================================

   Vamos a crear una nueva tabla llamada "Promotions" para la demostración:  */

CREATE TABLE Sales.Promotions(
    promotion_id INT PRIMARY KEY IDENTITY (1, 1),
    promotion_name VARCHAR (255) NOT NULL,
    discount NUMERIC (3, 2) DEFAULT 0,
    start_date DATE NOT NULL,
    expired_date DATE NOT NULL
)

/* En esta sentencia, creamos una nueva tabla llamada Promotions en el schema de Sales. La tabla Promotions 
   tiene cinco columnas que incluyen el número de identificación de la promoción, el nombre, el descuento, la 
   fecha de inicio y la fecha de caducidad.

   El número de identificación de la promoción es una columna de identidad, por lo que su valor es rellenado 
   automáticamente por SQL Server cuando se añade una nueva fila a la tabla.


   1) Ejemplo básico de INSERT
   ===========================

   La siguiente sentencia inserta una nueva fila en la tabla Promotions:   */

INSERT INTO Sales.Promotions(
    promotion_name,
    discount,
    start_date,
    expired_date
)
VALUES ('2018 Summer Promotion', 0.15, '20180601', '20180901')

-- En este ejemplo, hemos especificado valores para cuatro columnas de la tabla Promotions. No especificamos un 
-- valor para la columna promotion_id porque SQL Server proporciona el valor de esta columna automáticamente.


-- 2) Insertar y devolver valores insertados
-- =========================================

-- Para capturar los valores insertados, se utiliza la cláusula OUTPUT. Por ejemplo, la siguiente sentencia inserta 
-- una nueva fila en la tabla Promotions y devuelve el valor insertado de la columna promotion_id:

INSERT INTO Sales.Promotions(
    promotion_name,
    discount,
    start_date,
    expired_date
) OUTPUT inserted.promotion_id
VALUES('2018 Fall Promotion', 0.15, '20181001', '20181101')

/* El resultado es el siguiente:

|--------------|
| promotion_id | 
|--------------|
|       2      |  
|--------------|

   Para capturar los valores insertados de varias columnas, especifique las columnas en la salida como se muestra 
   en la siguiente sentencia:  */

INSERT INTO Sales.Promotions(
    promotion_name,
    discount,
    start_date,
    expired_date
) OUTPUT inserted.promotion_id,
 inserted.promotion_name,
 inserted.discount,
 inserted.start_date,
 inserted.expired_date
VALUES('2018 Winter Promotion', 0.2, '20181201', '20190101')

/* El resultado es el siguiente:

|--------------|-----------------------|----------|------------|--------------|
| promotion_id |     promotion_name    | discount | start_date | expired_date |
|--------------|-----------------------|----------|------------|--------------|
|       3      | 2018 Winter Promotion |   0.15   | 2018-12-01 |  2019-01-01  |
|--------------|-----------------------|----------|------------|--------------|


   3) Insertar valores explícitos en la columna de identidad
   ==========================================================

   Normalmente, no se especifica un valor para la columna de identidad porque SQL Server proporcionará el 
   valor automáticamente.

   Sin embargo, en algunas situaciones, es posible que desee insertar un valor en la columna de identidad, 
   como la migración de datos (data migration).

   Consulte la siguiente sentencia INSERT:  */

INSERT INTO Sales.Promotions(
    promotion_id,
    promotion_name,
    discount,
    start_date,
    expired_date
) OUTPUT inserted.promotion_id
VALUES(4, '2019 Spring Promotion', 0.25, '20190201', '20190301')

/* SQL Server emitió el siguiente error:

Cannot insert explicit value for identity column in table 'promotions' when IDENTITY_INSERT is set to OFF.


   Para insertar un valor explícito para la columna de identidad, primero debe ejecutar la siguiente sentencia:

                                SET IDENTITY_INSERT table_name ON


   Para desactivar la inserción de identidad, se utiliza una sentencia similar:

                                SET IDENTITY_INSERT table_name OFF
    

   Ejecutemos las siguientes sentencias para insertar un valor para la columna de identidad en la tabla 
   Promotions:    */

SET IDENTITY_INSERT Sales.Promotions ON

INSERT INTO Sales.Promotions(
    promotion_id,
    promotion_name,
    discount,
    start_date,
    expired_date
)
VALUES(4, '2019 Spring Promotion', 0.25, '20190201', '20190301')

SET IDENTITY_INSERT Sales.Promotions OFF

-- En este ejemplo, primero activamos la inserción de identidad, luego insertamos una fila con un valor 
-- explícito para la columna de identidad y, por último, desactivamos la inserción de identidad.

-- A continuación se muestran los datos de la tabla Promotions después de la inserción:

SELECT * FROM Sales.Promotions

/* El resultado es el siguiente:

|--------------|-----------------------|----------|------------|--------------|
| promotion_id |     promotion_name    | discount | start_date | expired_date |
|--------------|-----------------------|----------|------------|--------------|
|       1      | 2018 Summer Promotion |   0.15   | 2018-06-01 |  2018-09-01  |
|       2      | 2018 Fall Promotion   |   0.15   | 2018-10-01 |  2018-11-01  |
|       3      | 2018 Winter Promotion |   0.15   | 2018-12-01 |  2019-01-01  |
|       4      | 2018 Spring Promotion |   0.25   | 2019-02-01 |  2019-03-01  |
|--------------|-----------------------|----------|------------|--------------|


/* =======================================================================================================
   =======================================================================================================

   Insertar múltiples registros
   ============================

   Para añadir varias filas a la vez a una tabla, utilice la siguiente forma de la sentencia INSERT:

                                    INSERT INTO table_name (column_list)
                                    VALUES
                                        (value_list_1),
                                        (value_list_2),
                                        ...
                                        (value_list_n);

   En esta sintaxis, en lugar de utilizar una única lista de valores, se utilizan varias listas de valores 
   separadas por comas para la inserción.

   El número de filas que se pueden insertar a la vez es de 1.000 filas utilizando esta forma de la sentencia 
   INSERT. Si desea insertar más filas, puede utilizar varias sentencias INSERT, BULK INSERT o una tabla 
   derivada.

   Tenga en cuenta que esta sintaxis INSERT de varias filas sólo se admite en SQL Server 2008 o posterior.

   Para insertar varias filas devueltas por una secuencia SELECT, se utiliza la secuencia INSERT INTO SELECT.


   SQL Server INSERT para insertar varias filas - ejemplos
   ========================================================

   Utilizaremos la tabla Sales.Promotions creada anteriormente para la demostración.

   1) Ejemplo de inserción de varias filas

   La siguiente sentencia inserta múltiples filas en la tabla Sales.Promotions:   */

INSERT INTO Sales.Promotions(
    promotion_name,
    discount,
    start_date,
    expired_date
)
VALUES('2019 Summer Promotion', 0.15, '20190601', '20190901'),
      ('2019 Fall Promotion', 0.20, '20191001', '20191101'),
      ('2019 Winter Promotion', 0.25, '20191201', '20200101')

-- Verifiquemos la inserción ejecutando la siguiente consulta:

SELECT * FROM Sales.Promotions

/* El resultado es el siguiente:

|--------------|-----------------------|----------|------------|--------------|
| promotion_id |     promotion_name    | discount | start_date | expired_date |
|--------------|-----------------------|----------|------------|--------------|
|       1      | 2018 Summer Promotion |   0.15   | 2018-06-01 |  2018-09-01  |
|       2      | 2018 Fall Promotion   |   0.15   | 2018-10-01 |  2018-11-01  |
|       3      | 2018 Winter Promotion |   0.15   | 2018-12-01 |  2019-01-01  |
|       4      | 2018 Spring Promotion |   0.25   | 2019-02-01 |  2019-03-01  |
|       5      | 2019 Summer Promotion |   0.15   | 2019-06-01 |  2019-09-01  |
|       6      | 2019 Fall Promotion   |   0.20   | 2019-10-01 |  2019-11-01  |
|       7      | 2019 Winter Promotion |   0.25   | 2019-12-01 |  2020-01-01  |
|--------------|-----------------------|----------|------------|--------------|

   2) Ejemplo de inserción de varias filas y devolución de la lista de identidades insertada

   Este ejemplo inserta tres filas en la tabla Sales.Promotions y devuelve la lista de identidades 
   de promoción:   */

INSERT INTO 
	Sales.Promotions( 
		promotion_name, discount, start_date, expired_date
	)
OUTPUT inserted.promotion_id
VALUES
	('2020 Summer Promotion',0.25,'20200601','20200901'),
	('2020 Fall Promotion',0.10,'20201001','20201101'),
	('2020 Winter Promotion', 0.25,'20201201','20210101');

/* El resultado es el siguiente:

|--------------|
| promotion_id | 
|--------------|
|       8      |  
|       9      | 
|      10      | 
|--------------|

   En este ejemplo, hemos añadido la cláusula OUTPUT con la columna que queremos devolver utilizando la 
   sintaxis inserted.nombre_columna. 