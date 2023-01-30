-- ======================================================
-- =================== DENSE_RANK() =====================
-- ======================================================

    USE TiendaBicicletas

/*  DENSE_RANK() es una función de ventana que asigna un ranking a cada fila dentro de una 
    partición de un conjunto de resultados. A diferencia de la función RANK(), la función 
    DENSE_RANK() devuelve valores de ranking consecutivos. Las filas de cada partición reciben 
    los mismos rankings si tienen los mismos valores.

    La sintaxis de la función DENSE_RANK() es la siguiente:

                            DENSE_RANK() OVER (
                                [PARTITION BY partition_expression, ... ]
                                ORDER BY sort_expression [ASC | DESC], ...
                            )

    La función DENSE_RANK() se aplica a las filas de cada partición definida por la cláusula PARTITION BY, 
    en un orden especificado, definido por la cláusula ORDER BY. Restablece el ranking cuando se cruza el 
    límite de la partición.

    La cláusula PARITION BY es opcional. Si se omite, la función tratará todo el conjunto de resultados como 
    una única partición.


    Ilustración de la función DENSE_RANK()
    --------------------------------------

    Las siguientes sentencias crean una nueva tabla llamada dense_rank_demo e insertan algunas filas en esa 
    tabla:  */

    CREATE TABLE Ventas.dense_rank_demo (
        v VARCHAR(10)
    );
        
    INSERT INTO Ventas.dense_rank_demo(v)
    VALUES('A'),('B'),('B'),('C'),('C'),('D'),('E');
        
    SELECT * FROM Ventas.dense_rank_demo;
/*
|---|
| v | 
|---|
| A |
| B |
| B |
| C |
| C |
| D |
| E |
|---| 

    La siguiente sentencia utiliza las funciones DENSE_RANK() y RANK() para asignar un ranking a cada fila del 
    conjunto de resultados:  */

    SELECT
        v,
        DENSE_RANK() OVER (ORDER BY v) my_dense_rank,
        RANK() OVER (ORDER BY v) my_rank
    FROM
        Ventas.dense_rank_demo;
/*
|---|---------------|---------|
| v | my_dense_rank | my_rank |
|---|---------------|---------|
| A |       1       |    1    |  
| B |       2       |    2    |  
| B |       2       |    2    |  
| C |       3       |    4    |  
| C |       3       |    4    |  
| D |       4       |    6    |  
| E |       5       |    7    |  
|---|---------------|---------| 

    ============================================================================================================0

    Ejemplos de la función DENSE_RANK()
    ===================================

    Utilizaremos la tabla Produccion.productos para demostrar la función DENSE_RANK():  */

    SELECT
        producto_id,
        producto_nombre,
        precio_catalogo,
        DENSE_RANK() OVER (ORDER BY precio_catalogo DESC) price_rank 
    FROM
        Produccion.productos;
/*
|-------------|-----------------------------------------|-----------------|------------|    
| producto_id |	           producto_nombre              | precio_catalogo |	price_rank |
|-------------|-----------------------------------------|-----------------|------------|  
|     155     |  Trek Domane SLR 9 Disc - 2018	        |    11999.99	  |      1     | 
|     149	  |  Trek Domane SLR 8 Disc - 2018	        |     7499.9      |      2     | 
|     156	  |  Trek Domane SL Frameset - 2018	        |     6499.99     |      3     | 
|     157	  |  Trek Domane SL Frameset Women's - 2018	|     6499.99     |      3     | 
|     169	  |  Trek Emonda SLR 8 - 2018	            |     6499.99     |      3     | 
|      51	  |  Trek Silque SLR 8 Women's - 2017	    |     6499.99     |      3     | 
|      50	  |  Trek Silque SLR 7 Women's - 2017	    |     5999.99     |      4     | 
|      56	  |  Trek Domane SLR 6 Disc - 2017	        |     5499.99     |      5     |
|     177	  |  Trek Domane SLR 6 Disc - 2018	        |     5499.99     |      5     | 
|     154	  |  Trek Domane SLR 6 Disc Women's - 2018	|     5499.99     |      5     | 
|  .........  | ......................................  |  .............. | .......... |
|  .........  | ......................................  |  .............. | .......... |
|-------------|-----------------------------------------|-----------------|------------|  


    Ejemplo de uso de DENSE_RANK() sobre particiones
    ================================================

    La siguiente sentencia ordena los productos de cada categoría por precio de catálogo. Devuelve sólo los 
    3 primeros productos de cada categoría por precio de catálogo.  */

    SELECT * FROM (
        SELECT
            producto_id,
            producto_nombre,
            categoria_id,
            precio_catalogo,
            DENSE_RANK () OVER (PARTITION BY categoria_id ORDER BY precio_catalogo DESC) price_rank 
        FROM
            Produccion.productos
    ) t
    WHERE price_rank < 3;
/*
|-------------|---------------------------------------------------|--------------|-----------------|------------------|
| producto_id |	                producto_nombre                   | categoria_id | precio_catalogo |	price_rank    |
|-------------|---------------------------------------------------|--------------|-----------------|------------------|  
|     98      |  Electra Straight 8 3i (20-inch) - Boy's - 2017	  |      1	     |       489.99	   |         1        |  
|    100	  |  Electra Townie 3i EQ (20-inch) - Boys' - 2017	  |      1	     |       489.99	   |         1        |  
|    280	  |  Trek Superfly 24 - 2017/2018	                  |      1	     |       489.99	   |         1        |  
|    266	  |  Trek Superfly 20 - 2018	                      |      1	     |       399.99	   |         2        |  
|    303	  |  Electra Townie Go! 8i - 2017/2018	              |      2	     |      2599.99	   |         1        | 
|    309	  |  Electra Townie Commute 27D - 2018	              |      2	     |       899.99	   |         2        |  
|    310	  |  Electra Townie Commute 27D Ladies - 2018	      |      2	     |       899.99	   |         2        |  
|    306	  |  Electra Townie Balloon 7i EQ Ladies' - 2017/2018 |	     2	     |       899.99	   |         2        |  
|    301	  |  Electra Townie Balloon 7i EQ - 2018	          |      2	     |       899.99	   |         2        |  
|    251	  |  Electra Townie Commute Go! - 2018	              |      3	     |      2999.99	   |         1        |
| ..........  |  ...............................................  |  ..........  |  .............  |  ............... |
| ..........  |  ...............................................  |  ..........  |  .............  |  ............... |
|-------------|---------------------------------------------------|--------------|-----------------|------------------|