-- ======================================================
-- ====================== RANK() ========================
-- ======================================================

    USE TiendaBicicletas

/*  La función RANK() es una función de ventana que asigna un rango a cada fila dentro de 
    una partición de un conjunto de resultados.

    Las filas de una partición que tengan los mismos valores recibirán el mismo rango. El rango 
    de la primera fila de una partición es uno. La función RANK() suma el número de filas 
    empatadas al rango empatado para calcular el rango de la fila siguiente, por lo que los 
    rangos pueden no ser consecutivos.

    A continuación se muestra la sintaxis de la función RANK():

                            RANK() OVER (
                                [PARTITION BY partition_expression, ... ]
                                ORDER BY sort_expression [ASC | DESC], ...
                            )

    En esta sintaxis:

    - Primero, la cláusula PARTITION BY divide las filas del conjunto de resultados particiones a las 
      que se aplica la función.

    - En segundo lugar, la cláusula ORDER BY especifica el orden lógico de las filas de cada partición 
      a la que se aplica la función.

    La función RANK() es útil para informes top-N y bottom-N.


    Ilustración de RANK() en SQL Server
    -----------------------------------

    En primer lugar, cree una nueva tabla denominada Ventas.rank_demo que tenga una columna:  */

    CREATE TABLE Ventas.rank_demo (
        v VARCHAR(10)
    )

--  En segundo lugar, inserte algunas filas en la tabla Ventas.rank_demo:

    INSERT INTO Ventas.rank_demo(v)
    VALUES('A'),('B'),('B'),('C'),('C'),('D'),('E');

--  En tercer lugar, consulta los datos de la tabla Ventas.rank_demo:

    SELECT v FROM Ventas.rank_demo
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
|---| */

--  En cuarto lugar, utilice ROW_NUMBER() para asignar rankings a las filas del conjunto de resultados de 
--  la tabla Ventas.rank_demo:

    SELECT
        v,
        RANK() OVER(ORDER BY v) rank_no 
    FROM
        Ventas.rank_demo
/*
|---|---------|
| v | rank_no |
|---|---------|
| A |    1    |  
| B |    2    |  
| B |    2    |  
| C |    4    |  
| C |    4    |  
| D |    6    |  
| E |    7    |  
|---|---------| 


    Como se ve claramente en la salida, la segunda y tercera filas reciben el mismo rango porque tienen el 
    mismo valor B. La cuarta y quinta filas reciben el rango 4 porque la función RANK() se salta el rango 3 
    y ambas tienen también los mismos valores.


    ===========================================================================================================

    Ejemplos de la función RANK()
    =============================

    Utilizaremos la tabla Produccion.productos para demostrar la función RANK():  


    Ejemplo de uso de la función RANK() en un conjunto de resultados
    ----------------------------------------------------------------

    El siguiente ejemplo utiliza la función RANK() para asignar rankings a los productos según sus precios 
    de catálogo:  */

    SELECT
        producto_id,
        producto_nombre,
        precio_catalogo,
        RANK() OVER (ORDER BY precio_catalogo DESC) price_rank 
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
|      50	  |  Trek Silque SLR 7 Women's - 2017	    |     5999.99     |      7     | 
|      56	  |  Trek Domane SLR 6 Disc - 2017	        |     5499.99     |      8     |
|     177	  |  Trek Domane SLR 6 Disc - 2018	        |     5499.99     |      8     | 
|     154	  |  Trek Domane SLR 6 Disc Women's - 2018	|     5499.99     |      8     | 
|  .........  | ......................................  |  .............. | .......... |
|  .........  | ......................................  |  .............. | .......... |
|-------------|-----------------------------------------|-----------------|------------|  


/*  En este ejemplo, como omitimos la cláusula PARTITION BY, la función RANK() trató todo el conjunto de 
    resultados como una única partición.

    La función RANK() asigna un ranking a cada fila dentro del conjunto de resultados ordenados por precio 
    de catálogo de mayor a menor.


    Ejemplo de uso de la función RANK() en particiones
    --------------------------------------------------

    Este ejemplo utiliza la función RANK() para asignar un ranking a cada producto por precio de catálogo en 
    cada marca y devuelve los productos con un ranking menor o igual a tres:  */

    SELECT * FROM (
        SELECT
            producto_id,
            producto_nombre,
            marca_id,
            precio_catalogo,
            RANK() OVER (PARTITION BY marca_id ORDER BY precio_catalogo DESC) price_rank 
        FROM
            Produccion.productos
    ) t
    WHERE price_rank <= 3
/*
|-------------|--------------------------------------------|----------|-----------------|------------|    
| producto_id |	           producto_nombre                 | marca_id | precio_catalogo | price_rank |
|-------------|--------------------------------------------|----------|-----------------|------------|  
|     198	  |  Electra Townie Commute Go! - 2018	       |     1    |	    2999.99	    |    1       |
|     199	  |  Electra Townie Commute Go! Ladies' - 2018 |     1	  |     2999.99	    |    1       |
|     251	  |  Electra Townie Commute Go! - 2018	       |     1	  |     2999.99	    |    1       |
|     252	  |  Electra Townie Commute Go! Ladies' - 2018 |	 1	  |     2999.99	    |    1       |
|      41	  |  Haro Shift R3 - 2017	                   |     2	  |     1469.99	    |    1       |
|      46	  |  Haro SR 1.3 - 2017	                       |     2	  |     1409.99	    |    2       |
|      45	  |  Haro SR 1.2 - 2017	                       |     2	  |      869.99	    |    3       |
|     131	  |  Heller Bloodhound Trail - 2018	           |     3	  |     2599.00	    |    1       |
|     137	  |  Heller Shagamaw GX1 - 2018	               |     3	  |     2599.00	    |    1       |
|       5	  |  Heller Shagamaw Frame - 2016	           |     3	  |     1320.99	    |    3       |
| ........... |  ........................................  | ........ | ............... | .......... |
| ........... |  ........................................  | ........ | ............... | .......... |
|-------------|--------------------------------------------|----------|-----------------|------------|   

/*  En este ejemplo:

    - Primero, la cláusula PARTITION BY divide los productos en particiones por marca Id.

    - En segundo lugar, la cláusula ORDER BY ordena los productos de cada partición por precios de catálogo.

    - En tercer lugar, la consulta externa devuelve los productos cuyos valores de ranking son menores o iguales 
      que tres.

    La función RANK() se aplica a cada fila de cada partición y se reinicializa al cruzar el límite de la partición.