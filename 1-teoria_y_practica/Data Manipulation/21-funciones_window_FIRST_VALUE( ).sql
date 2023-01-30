-- ======================================================
-- =================== FIRST_VALUE() ====================
-- ======================================================

/*  La función FIRST_VALUE() es una función de ventana que devuelve el primer valor de 
    una partición ordenada de un conjunto de resultados.

    A continuación se muestra la sintaxis de la función FIRST_VALUE():

                            FIRST_VALUE ( scalar_expression )  
                            OVER ( 
                                [PARTITION BY partition_expression, ... ]
                                ORDER BY sort_expression [ASC | DESC], ...
                            )


    En esta sintaxis

    scalar_expression
    =================

    "scalar_expression" es una expresión evaluada contra el valor de la primera fila de la partición 
    ordenada de un conjunto de resultados. "scalar_expression" puede ser una columna, subconsulta o 
    expresión que se evalúe a un único valor. No puede ser una función ventana.

    Cláusula PARTITION BY
    =====================

    La cláusula PARTITION BY distribuye las filas del conjunto de resultados en particiones a las que 
    se aplica la función FIRST_VALUE(). Si omite la cláusula PARTITION BY, la función FIRST_VALUE() 
    tratará todo el conjunto de resultados como una única partición.

    Cláusula ORDER BY
    =================

    La cláusula ORDER BY especifica el orden lógico de las filas de cada partición a las que se aplica 
    la función FIRST_VALUE().

    cláusula rows_range
    ===================

    La cláusula rows_range_limita aún más las filas de la partición definiendo los puntos inicial y final.


    ======================================================================================================

    Ejemplos de la función FIRST_VALUE()
    ====================================  */

    USE TiendaBicicletas

/*  La siguiente secuencia crea una nueva vista denominada Ventas.v_categoria_volumen_ventas que devuelve 
    el número de productos vendidos por categoría de producto y año.  */

    CREATE VIEW 
        Ventas.v_categoria_volumen_ventas 
    AS
    SELECT 
        c.categoria_nombre, 
        YEAR(o.fecha_pedido) ano, 
        SUM(i.cantidad) cantidad
    FROM 
        Ventas.pedidos o
    INNER JOIN Ventas.items_pedidos i 
        ON i.pedido_id = o.pedido_id
    INNER JOIN Produccion.productos p 
        ON p.producto_id = i.producto_id
    INNER JOIN Produccion.categorias c 
        ON c.categoria_id = p.categoria_id
    GROUP BY 
        c.categoria_nombre, 
        YEAR(o.fecha_pedido);


-- Estos son los datos de la vista:

    SELECT 
        *
    FROM 
        Ventas.v_categoria_volumen_ventas
    ORDER BY 
        ano, 
        categoria_nombre, 
        cantidad;

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


/*  A) Uso de FIRST_VALUE() en un ejemplo de conjunto de resultados
    ---------------------------------------------------------------

    Este ejemplo utiliza la función FIRST_VALUE() para devolver el nombre de la categoría con el menor 
    volumen de ventas en 2017:  */

    SELECT 
        categoria_nombre,
        ano,
        cantidad,
        FIRST_VALUE(categoria_nombre) OVER(ORDER BY cantidad) menor_volumen_ventas
    FROM 
        Ventas.v_categoria_volumen_ventas
    WHERE
        ano = 2017;
/*
|---------------------|-------|----------|----------------------|
|  categoria_nombre	  |  ano  |	cantidad | menor_volumen_ventas |
|---------------------|-------|----------|----------------------|
|Electric Bikes	      |  2017 |     98   |   Electric Bikes	    |    
|Cyclocross Bicycles  |  2017 |    128   |   Electric Bikes	    |         
|Road Bikes		      |  2017 |    333   |   Electric Bikes	    |   
|Comfort Bicycles     |  2017 |    373   |   Electric Bikes	    |   
|Children Bicycles    |  2017 |    589   |   Electric Bikes	    |   
|Mountain Bikes	      |  2017 |    764   |   Electric Bikes	    |   
|Cruisers Bicycles    |  2017 |    814   |   Electric Bikes	    |   
|---------------------|-------|----------|----------------------|

/*  En este ejemplo:

    La cláusula PARTITION BY no se especificó, por lo que todo el conjunto de resultados se trató como una 
    única partición.

    La cláusula ORDER BY ordenó las filas de cada partición por cantidad (cantidad) de menor a mayor.


    B) Ejemplo de uso de FIRST_VALUE() sobre particiones
    ----------------------------------------------------

    El siguiente ejemplo utiliza la función FIRST_VALUE() para devolver las categorías de productos con los 
    volúmenes de ventas más bajos en 2016 y 2017.   */

    SELECT 
        categoria_nombre,
        ano,
        cantidad,
        FIRST_VALUE(categoria_nombre) OVER(PARTITION BY ano ORDER BY cantidad) menor_volumen_ventas
    FROM 
        Ventas.v_categoria_volumen_ventas
    WHERE
        ano BETWEEN 2016 AND 2017
/*
|---------------------|-------|----------|----------------------|
|  categoria_nombre	  |  ano  |	cantidad | menor_volumen_ventas |
|---------------------|-------|----------|----------------------|
|Electric Bikes	      |  2016 |    104   |   Electric Bikes	    |    
|Cyclocross Bicycles  |  2016 |    233   |   Electric Bikes	    |  
|Comfort Bicycles     |  2016 |    313   |   Electric Bikes	    |   
|Children Bicycles    |  2016 |    350   |   Electric Bikes	    | 
|Mountain Bikes	      |  2016 |    739   |   Electric Bikes	    | 
|Cruisers Bicycles    |  2016 |    924   |   Electric Bikes	    |  
|Electric Bikes	      |  2017 |     98   |   Electric Bikes	    |    
|Cyclocross Bicycles  |  2017 |    128   |   Electric Bikes	    |         
|Road Bikes		      |  2017 |    333   |   Electric Bikes	    |   
|Comfort Bicycles     |  2017 |    373   |   Electric Bikes	    |   
|Children Bicycles    |  2017 |    589   |   Electric Bikes	    |   
|Mountain Bikes	      |  2017 |    764   |   Electric Bikes	    |   
|Cruisers Bicycles    |  2017 |    814   |   Electric Bikes	    |   
|---------------------|-------|----------|----------------------|


/*  En este ejemplo:

    - La cláusula PARTITION BY distribuyó las filas por año en dos particiones, una para 2016 y otra 
      para 2017.

    - La cláusula ORDER BY ordenó las filas de cada partición por cantidad (cantidad) de menor a mayor.

    - La función FIRST_VALUE() se aplica a cada partición por separado. Para la primera partición, devolvió 
      "Electric Bikes" y para la segunda partición devolvió "Electric Bikes" porque estas categorías 
      eran las primeras filas de cada partición.  

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