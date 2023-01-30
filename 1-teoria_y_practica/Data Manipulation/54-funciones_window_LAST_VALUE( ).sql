-- ======================================================
-- ==================== LAST_VALUE() ====================
-- ======================================================

/*  La función LAST_VALUE() es una función de ventana que devuelve el último valor de una 
    partición ordenada de un conjunto de resultados.

    A continuación se muestra la sintaxis de la función LAST_VALUE():

                        LAST_VALUE ( scalar_expression )  
                        OVER ( 
                            [PARTITION BY partition_expression, ... ]
                            ORDER BY sort_expression [ASC | DESC], ...
                        )    

    En esta sintaxis:

    scalar_expression
    =================

    "scalar_expression" es una expresión evaluada contra el valor de la última fila en una partición 
    ordenada del conjunto de resultados. "scalar_expression" puede ser una columna, subconsulta o 
    expresión evaluada a un único valor. No puede ser una función ventana.

    Cláusula PARTITION BY
    =====================

    La cláusula PARTITION BY distribuye las filas del conjunto de resultados en particiones a las que 
    se aplica la función LAST_VALUE(). Si omite la cláusula PARTITION BY, la función LAST_VALUE() 
    tratará todo el conjunto de resultados como una única partición.

    Cláusula ORDER BY
    =================

    La cláusula ORDER BY especifica el orden lógico de las filas de cada partición a las que se aplica 
    la función LAST_VALUE().

    cláusula rows_range
    ===================

    La cláusula rows_range_limita aún más las filas de una partición definiendo los puntos inicial y final.


    ========================================================================================================

    Ejemplos de la función LAST_VALUE()
    ===================================

    Utilizaremos la vista Ventas.v_categoria_volumen_ventas creada en el tutorial de la función FIRST_VALUE() 
    para demostrar cómo funciona la función LAST_VALUE().

    La siguiente consulta devuelve datos de la vista:  */

    SELECT 
        categoria_nombre,
        ano,
        cantidad
    FROM 
        Ventas.v_categoria_volumen_ventas
    ORDER BY 
        ano, 
        categoria_nombre, 
        cantidad
/*
|---------------------|-------|----------|
|  categoria_nombre	  |  ano  |	cantidad |
|---------------------|-------|----------|
|Children Bicycles	  |  2016 |    350   |   
|Comfort Bicycles	  |  2016 |    313   |   
|Cruisers Bicycles	  |  2016 |    924   |   
|Cyclocross Bicycles  |  2016 |    233   |   
|Electric Bikes	      |  2016 |    104   |   
|Mountain Bikes	      |  2016 |    739   |   
|Children Bicycles	  |  2017 |    589   |    
|Comfort Bicycles	  |  2017 |    373   |        
|Cruisers Bicycles	  |  2017 |    814   |  
|Cyclocross Bicycles  |  2017 |    128   |  
|Electric Bikes	      |  2017 |     98   |  
|Mountain Bikes	      |  2017 |    764   |  
|Road Bikes	          |  2017 |    333   |  
|Children Bicycles	  |  2018 |    240   |  
|Comfort Bicycles	  |  2018 |    127   |  
|Cruisers Bicycles	  |  2018 |    325   |  
|Cyclocross Bicycles  |  2018 |     33   |  
|Electric Bikes	      |  2018 |    113   |  
|Mountain Bikes	      |  2018 |    252   |  
|Road Bikes	          |  2018 |    226   |  
|---------------------|-------|----------|


    A) Uso de LAST_VALUE() en un ejemplo de conjunto de resultados
    --------------------------------------------------------------

    Este ejemplo utiliza la función LAST_VALUE() para devolver el nombre de la categoría con el mayor 
    volumen de ventas en 2016:  */

    SELECT 
        categoria_nombre,
        ano,
        cantidad,
        LAST_VALUE(categoria_nombre) OVER(ORDER BY cantidad 
                                        RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                                  ) mayor_volumen_ventas_A,
        LAST_VALUE(categoria_nombre) OVER(ORDER BY cantidad 
                                        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                                  ) mayor_volumen_ventas_B
    FROM 
        Ventas.v_categoria_volumen_ventas
    WHERE
        ano = 2016
/*
|---------------------|-------|----------|----------------------|----------------------|
|  categoria_nombre	  |  ano  |	cantidad |mayor_volumen_ventas_A|mayor_volumen_ventas_B|
|---------------------|-------|----------|----------------------|----------------------|
|Electric Bikes	      |  2016 |    104   |   Cruisers Bicycles	|   Cruisers Bicycles  |    
|Cyclocross Bicycles  |  2016 |    233   |   Cruisers Bicycles	|   Cruisers Bicycles  |     
|Comfort Bicycles     |  2016 |    313   |   Cruisers Bicycles	|   Cruisers Bicycles  |     
|Children Bicycles    |  2016 |    350   |   Cruisers Bicycles	|   Cruisers Bicycles  |     
|Mountain Bikes	      |  2016 |    739   |   Cruisers Bicycles	|   Cruisers Bicycles  |     
|Cruisers Bicycles    |  2016 |    924   |   Cruisers Bicycles	|   Cruisers Bicycles  |      
|---------------------|-------|----------|----------------------|----------------------|   


    En este ejemplo:

    - La cláusula PARTITION BY no se especificó, por lo que todo el conjunto de resultados se trató 
      como una única partición.

    - La cláusula ORDER BY ordenaba las filas de cada partición por cantidad (cantidad) de menor a mayor.

    - La cláusula RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING definía el marco de la 
      partición empezando por la primera fila y terminando en la última fila.


    B) Ejemplo de uso de LAST_VALUE() en particiones
    ------------------------------------------------

    El siguiente ejemplo utiliza la función LAST_VALUE() para devolver las categorías de productos con 
    los mayores volúmenes de ventas en 2016 y 2017.  */

    SELECT 
        categoria_nombre,
        ano,
        cantidad,
        LAST_VALUE(categoria_nombre) OVER(PARTITION BY ano ORDER BY cantidad 
                                        RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                                  ) mayor_volumen_ventas
    FROM 
        Ventas.v_categoria_volumen_ventas
    WHERE
        ano IN (2016,2017);
/*
|---------------------|-------|----------|----------------------|
|  categoria_nombre	  |  ano  |	cantidad | mayor_volumen_ventas |
|---------------------|-------|----------|----------------------|
|Electric Bikes	      |  2016 |    104   |   Cruisers Bicycles  |    
|Cyclocross Bicycles  |  2016 |    233   |   Cruisers Bicycles  | 
|Comfort Bicycles     |  2016 |    313   |   Cruisers Bicycles  |  
|Children Bicycles    |  2016 |    350   |   Cruisers Bicycles  | 
|Mountain Bikes	      |  2016 |    739   |   Cruisers Bicycles  | 
|Cruisers Bicycles    |  2016 |    924   |   Cruisers Bicycles  | 
|Electric Bikes	      |  2017 |     98   |   Cruisers Bicycles  |   
|Cyclocross Bicycles  |  2017 |    128   |   Cruisers Bicycles  |          
|Road Bikes		      |  2017 |    333   |   Cruisers Bicycles  |   
|Comfort Bicycles     |  2017 |    373   |   Cruisers Bicycles  |   
|Children Bicycles    |  2017 |    589   |   Cruisers Bicycles  |   
|Mountain Bikes	      |  2017 |    764   |   Cruisers Bicycles  |   
|Cruisers Bicycles    |  2017 |    814   |   Cruisers Bicycles  | 
|---------------------|-------|----------|----------------------|

    En este ejemplo:

    - La cláusula PARTITION BY distribuyó las filas por año en dos particiones, una para 2016 y otra 
      para 2017.

    - La cláusula ORDER BY ordenó las filas de cada partición por cantidad (cantidad) de menor a mayor.

    - La cláusula RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING define el marco que comienza 
      en la primera fila y termina en la última fila de la partición.

    La función LAST_VALUE() se aplicó a cada partición por separado. Para la primera partición, devolvió 
    Bicicletas eléctricas y para la segunda partición devolvió Bicicletas confortables porque estas 
    categorías eran las últimas filas de cada partición.


    =======================================================================================================

    Ejemplo 1 */

    USE EJERCICIOS

    SELECT * FROM tblAttendance

    SELECT 
        *,
        FIRST_VALUE(NumberAttendance) OVER(PARTITION BY EmployeeNumber ORDER BY AttendanceMonth
                                            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS first_month,
        LAST_VALUE(NumberAttendance) OVER(PARTITION BY EmployeeNumber ORDER BY AttendanceMonth
                                            ROWS BETWEEN UNBOUNDED PRECEDING AND 2 FOLLOWING) AS last_month
    FROM tblAttendance
/*
|----------------|-----------------|--------------------|-------------|------------|
| EmployeeNumber | AttendanceMonth |  NumberAttendance  | first_month |	last_month |
|----------------|-----------------|--------------------|-------------|------------|
|       123	     |   2014-01-01	   |         14	        |     14      |  	23     | 
|       123	     |   2014-02-01	   |         12	        |     14      |  	21     | 
|       123	     |   2014-03-01	   |         23	        |     14      |  	23     | 
|       123	     |   2014-04-01	   |         21	        |     12      |  	14     | 
|       123	     |   2014-05-01	   |         23         |     23      |  	11     | 
|       123	     |   2014-06-01	   |         14	        |     21      |  	15     | 
|       123	     |   2014-07-01	   |         11	        |     23      |  	14     | 
|       123	     |   2014-08-01	   |         15	        |     14      |  	20     | 
|       123	     |   2014-09-01	   |         14	        |     11      |  	24     | 
|       123	     |   2014-10-01	   |         20	        |     15      |  	14     | 
|  ............  |  ............   |   ..............   |  .........  |  ......... |
|  ............  |  ............   |   ..............   |  .........  |  ......... |
|----------------|-----------------|--------------------|-------------|------------|