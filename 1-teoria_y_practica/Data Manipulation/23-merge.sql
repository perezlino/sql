-- ======================================================
-- ======================= MERGE ========================
-- ======================================================

USE TiendaBicicletas

-- No es necesario realizar en un MERGE las tres acciones de Insert, Update y Delete. Si no, puedo solo
-- realizar un Insert, o un Insert y un Update, por ejemplo.

/*
    Supongamos que tiene dos tablas, una de origen y otra de destino, y necesita actualizar la tabla de 
    destino basándose en los valores de la tabla de origen. Se dan tres casos:

    1 - INSERTAR: La tabla de origen tiene algunas filas que no existen en la tabla de destino. En este caso, 
                  debe insertar en la tabla de destino las filas que se encuentran en la tabla de origen.

    2 - ELIMINAR: La tabla de destino tiene algunas filas que no existen en la tabla de origen. En este caso, 
                  debe eliminar filas de la tabla de destino.

    3 - ACTUALIZAR: La tabla de origen tiene algunas filas con las mismas claves que las filas de la tabla de 
                    destino. Sin embargo, estas filas tienen valores diferentes en las columnas no clave. En 
                    este caso, es necesario actualizar las filas de la tabla de destino con los valores 
                    procedentes de la tabla de origen.


    Si utiliza las sentencias INSERT, UPDATE y DELETE de forma individual, tendrá que crear tres sentencias 
    distintas para actualizar los datos de la tabla de destino con las filas coincidentes de la tabla de origen.

    Sin embargo, SQL Server proporciona la sentencia MERGE, que permite realizar tres acciones al mismo tiempo. 
    A continuación se muestra la sintaxis de la sentencia MERGE:  

                                            MERGE target_table USING source_table
                                            ON merge_condition
                                            WHEN MATCHED
                                                THEN update_statement
                                            WHEN NOT MATCHED
                                                THEN insert_statement
                                            WHEN NOT MATCHED BY SOURCE
                                                THEN DELETE
    

    1 - En primer lugar, se especifica la tabla de destino y la tabla de origen en la cláusula MERGE.

    2 - En segundo lugar, "merge_condition" determina cómo se combinan las filas de la tabla de origen con las 
        filas de la tabla de destino. Es similar a la condición join de la cláusula join. Normalmente, para la 
        correspondencia se utilizan las columnas key, ya sea primary key o unique key.

    3 - En tercer lugar, la condición "merge_condition" da como resultado tres estados: MATCHED, NOT MATCHED y 
        NOT MATCHED BY SOURCE.

        - MATCHED: son las filas que coinciden con la "merge condition". Para las filas coincidentes, debe 
                   actualizar las columnas de filas de la tabla de destino con los valores de la tabla de origen.

        - NOT MATCHED: son las filas de la tabla de origen que no tienen ninguna fila coincidente en la tabla 
                       de destino. En este caso, debe añadir las filas de la tabla de origen a la tabla de destino. 
                       Tenga en cuenta que NOT MATCHED también se conoce como NOT MATCHED BY TARGET.

        - NOT MATCHED BY SOURCE: son las filas de la tabla de destino que no coinciden con ninguna fila de la tabla 
                                 de origen. Si desea sincronizar la tabla de destino con los datos de la tabla de 
                                 origen, deberá utilizar esta condición de coincidencia para eliminar filas de la 
                                 tabla de destino.


    Ejemplo de sentencia MERGE de SQL Server
    ========================================

    Supongamos que tenemos dos tablas Ventas.categoria y Ventas.categoria_staging que almacenan las ventas por 
    categoría de producto.  */

CREATE TABLE Ventas.categoria (
    categoria_id INT PRIMARY KEY,
    categoria_nombre VARCHAR(255) NOT NULL,
    importe DECIMAL(10 , 2)
);

INSERT INTO Ventas.categoria(categoria_id, categoria_nombre, importe)
VALUES(1,'Children Bicycles',15000),
    (2,'Comfort Bicycles',25000),
    (3,'Cruisers Bicycles',13000),
    (4,'Cyclocross Bicycles',10000);


CREATE TABLE Ventas.categoria_staging (
    categoria_id INT PRIMARY KEY,
    categoria_nombre VARCHAR(255) NOT NULL,
    importe DECIMAL(10 , 2)
);

INSERT INTO Ventas.categoria_staging(categoria_id, categoria_nombre, importe)
VALUES(1,'Children Bicycles',15000),
    (3,'Cruisers Bicycles',13000),
    (4,'Cyclocross Bicycles',20000),
    (5,'Electric Bikes',10000),
    (6,'Mountain Bikes',10000);


/*  Para actualizar los datos en Ventas.categoría (tabla de destino) con los valores de Ventas.categoría_staging 
    (tabla de origen), utilice la siguiente sentencia MERGE:  */

MERGE Ventas.categoria t 
    USING Ventas.categoria_staging s
ON (s.categoria_id = t.categoria_id)
WHEN MATCHED
    THEN UPDATE 
         SET t.categoria_nombre = s.categoria_nombre,
             t.importe = s.importe
WHEN NOT MATCHED BY TARGET 
    THEN INSERT (t.categoria_id, t.categoria_nombre, t.importe)
         VALUES (s.categoria_id, s.categoria_nombre, s.importe)
WHEN NOT MATCHED BY SOURCE 
    THEN DELETE

/* En este ejemplo, utilizamos los valores de las columnas categoria_id de ambas tablas como merge condition.

    - En primer lugar, las filas con id 1, 3, 4 de la tabla Ventas.categoria_staging coinciden con las filas de 
      la tabla de destino, por lo que la sentencia MERGE actualiza los valores de las columnas "categoria_nombre" 
      y "importe" de la tabla Ventas.categoria.

    - En segundo lugar, las filas con id 5 y 6 de la tabla Ventas.categoria_staging no existen en la tabla 
      Ventas.categoria, por lo que la sentencia MERGE inserta estas filas en la tabla de destino.

    - En tercer lugar, la fila con el id 2 de la tabla Ventas.categoria no existe en la tabla 
      Ventas.categoria_staging, por lo que la sentencia MERGE elimina esta fila.

   Como resultado del proceso de merge, los datos de la tabla Ventas.categoria están totalmente sincronizados con 
   los datos de la tabla Ventas.categoria_staging.