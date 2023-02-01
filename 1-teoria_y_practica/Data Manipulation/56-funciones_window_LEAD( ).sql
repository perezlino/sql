-- ======================================================
-- ======================= LEAD() =======================
-- ======================================================

/*  SQL Server LEAD() es una función de ventana que proporciona acceso a una fila en un 
    desplazamiento físico especificado que sigue a la fila actual.

    Por ejemplo, utilizando la función LEAD(), desde la fila actual se puede acceder a los 
    datos de la fila siguiente, o a la fila que sigue a la siguiente, y así sucesivamente.

    La función LEAD() puede ser muy útil para comparar el valor de la fila actual con el valor 
    de la fila siguiente.

    A continuación se muestra la sintaxis de la función LEAD():

                        LEAD(return_value ,offset [,default]) 
                        OVER (
                            [PARTITION BY partition_expression, ... ]
                            ORDER BY sort_expression [ASC | DESC], ...
                        )

    En esta sintaxis:

    return_value
    ============

    El valor de retorno (return_value) de la siguiente fila basado en un desplazamiento especificado 
    (specified offset). El valor de retorno debe evaluarse a un único valor y no puede ser otra función 
    de ventana.

    offset
    ======

    "offset" es el número de filas hacia delante desde la fila actual desde la que acceder a los datos. 
    El "offset" puede ser una expresión, subconsulta o columna que se evalúe como un número entero 
    positivo.

    El valor por defecto de offset es 1 si no se especifica explícitamente.

    default
    =======

    La función devuelve "default" si offset va más allá del ámbito de la partición. Si no se especifica, 
    devuelve NULL.

    Cláusula PARTITION BY
    =====================

    La cláusula PARTITION BY distribuye las filas del conjunto de resultados en particiones a las que se 
    aplica la función LEAD().

    Si no se especifica la cláusula PARTITION BY, la función trata todo el conjunto de resultados como una 
    única partición.

    Cláusula ORDER BY
    =================

    La cláusula ORDER BY especifica el orden lógico de las filas en cada partición a la que se aplica la 
    función LEAD().


    =======================================================================================================

    Ejemplos de la función LEAD()
    =============================

    Vamos a crear una nueva vista denominada Ventas.marcas_ventas_netas para la demostración: */

    CREATE VIEW Ventas.marcas_ventas_netas
    AS
        SELECT 
            c.marca_nombre, 
            MONTH(o.fecha_pedido) mes, 
            YEAR(o.fecha_pedido) ano, 
            CONVERT(DEC(10, 0), SUM((i.precio_catalogo * i.cantidad) * (1 - i.descuento))) AS ventas_netas
        FROM Ventas.pedidos AS o
            INNER JOIN Ventas.items_pedidos AS i ON i.pedido_id = o.pedido_id
            INNER JOIN Produccion.productos AS p ON p.producto_id = i.producto_id
            INNER JOIN Produccion.marcas AS c ON c.marca_id = p.marca_id
        GROUP BY c.marca_nombre, 
                MONTH(o.fecha_pedido), 
                YEAR(o.fecha_pedido);
    
--  La siguiente consulta devuelve los datos de la vista Ventas.marcas_ventas_netas:

    SELECT 
        *
    FROM 
        Ventas.marcas_ventas_netas
    ORDER BY 
        ano, 
        mes, 
        marca_nombre, 
        ventas_netas;
/*
|------------|-----|-----|--------------|
|marca_nombre| mes | ano | ventas_netas |
|------------|-----|-----|--------------|
|Electra	 |  1  | 2016|	 42001      |
|Heller	     |  1  | 2016|	  9379      |
|Pure Cycles |	1  | 2016|	  8628      |
|Ritchey	 |  1  | 2016|	  3150      |
|Surly	     |  1  | 2016|	 37673      |
|Trek	     |  1  | 2016|	114316      |
|Electra	 |  2  | 2016|	 50107      |
|Heller	     |  2  | 2016|	  8032      |
|Pure Cycles |	2  | 2016|	  9843      |
|Ritchey	 |  2  | 2016|	  3172      |
|Surly	     |  2  | 2016|	 31378      |
|Trek	     |  2  | 2016|	 53580      |
|Electra	 |  3  | 2016|	 44495      |
|Heller	     |  3  | 2016|	  9194      |
|Pure Cycles |	3  | 2016|	 10050      |
|............|.....|.....|............. |
|............|.....|.....|............. |
|------------|-----|-----|--------------|


/*  A) Uso de la función LEAD() de SQL Server sobre un ejemplo de conjunto de resultados    
    ------------------------------------------------------------------------------------

    La siguiente sentencia utiliza la función LEAD() para devolver las ventas netas del mes actual y 
    del mes siguiente del año 2017:  */

    WITH cte_ventas_netas_2017 AS(
        SELECT 
            mes, 
            SUM(ventas_netas) ventas_netas
        FROM 
            Ventas.marcas_ventas_netas
        WHERE 
            ano = 2017
        GROUP BY 
            mes
    )
    SELECT 
        mes,
        ventas_netas,
        LEAD(ventas_netas,1) OVER (ORDER BY mes) ventas_mes_proximo
    FROM 
        cte_ventas_netas_2017
/*
|-----|--------------|--------------------|
| mes | ventas_netas | ventas_mes_proximo |
|-----|--------------|--------------------|
|  1  |     285617   |   	312924        |  
|  2  |	    312924	 |      308912        |  
|  3  |     308912	 |      227290        |  
|  4  |     227290	 |      268233        |  
|  5  |     268233	 |      378865        |  
|  6  |     378865	 |      229996        |  
|  7  |     229996	 |      290553        |  
|  8  |     290553	 |      293406        |  
|  9  |     293406	 |      310328        |  
| 10  |     310328	 |      281578        |  
| 11  |     281578	 |      259507        |  
| 12  |     259507	 |      NULL          |    
|-----|--------------|--------------------|

     En este ejemplo:

    - Primero, el CTE devuelve las ventas netas agregadas por mes.

    - A continuación, la consulta externa utiliza la función LEAD() para devolver las ventas del mes 
      siguiente para cada mes.

    De este modo, se pueden comparar fácilmente las ventas del mes actual con las del mes siguiente.


    B) Ejemplo de uso de la función LEAD() de SQL Server sobre particiones
    ----------------------------------------------------------------------

    La siguiente sentencia utiliza la función LEAD() para comparar las ventas del mes actual con el mes 
    siguiente de cada marca en el año 2018:  */

    SELECT 
        mes,
        marca_nombre,
        ventas_netas,
        LEAD(ventas_netas,1) OVER (PARTITION BY marca_nombre ORDER BY mes) ventas_mes_próximo
    FROM 
        Ventas.marcas_ventas_netas
    WHERE
        ano = 2018
/*
|-----|--------------|--------------|------------------|
| mes |	marca_nombre | ventas_netas |ventas_mes_próximo|
|-----|--------------|--------------|------------------|
|  1  |  Electra     |	    54771   |	    29772      | 
|  2  |  Electra     |	    29772   |	    83876      | 
|  3  |  Electra     |	    83876   |	   153396      | 
|  4  |  Electra     |	   153396   |	     2411      | 
|  7  |  Electra     |	     2411   |	     2056      | 
|  8  |  Electra     |	     2056   |	     3204      | 
|  9  |  Electra     |	     3204   |	     2377      | 
| 10  |  Electra     |	     2377   |	     1040      | 
| 11  |  Electra     |	     1040   |	      837      | 
| 12  |  Electra     |	      837   |	     NULL      | 
|  1  |  Haro	     |        735   |	     3960      | 
|  2  |  Haro	     |       3960   |	     2951      | 
|  3  |  Haro	     |       2951   |	    20776      | 
|  4  |  Haro	     |      20776   |	     NULL      | 
|  1  |  Heller	     |       4158   |	     5387      | 
|  2  |  Heller	     |       5387   |	     2339      | 
|  3  |  Heller	     |       2339   |	     9642      | 
|  4  |  Heller	     |       9642   |	     NULL      |
|.....|..............|..............|..................|
|.....|..............|..............|..................|
|-----|--------------|--------------|------------------|

/*  En este ejemplo:

    - La cláusula PARTITION BY dividió las filas en particiones por nombre de marca.

    - Para cada partición (o marca), la cláusula ORDER BY ordena las filas por mes.

    - Para cada fila de cada partición, la función LEAD() devuelve las ventas netas de la fila siguiente.


    =======================================================================================================

    Ejemplo 1 */

    USE EJERCICIOS

    SELECT * FROM tblAttendance

    SELECT 
        *,
        LAG(NumberAttendance) OVER(PARTITION BY EmployeeNumber ORDER BY AttendanceMonth) AS lag,
        LEAD(NumberAttendance) OVER(PARTITION BY EmployeeNumber ORDER BY AttendanceMonth) AS lead
    FROM tblAttendance
/*
|----------------|-----------------|--------------------|-------------|------------|
| EmployeeNumber | AttendanceMonth |  NumberAttendance  |     lag     |	   lead    |
|----------------|-----------------|--------------------|-------------|------------|
|       123	     |   2014-01-01	   |         14	        |     NULL    |  	12     | 
|       123	     |   2014-02-01	   |         12	        |     14      |  	23     | 
|       123	     |   2014-03-01	   |         23	        |     12      |  	21     | 
|       123	     |   2014-04-01	   |         21	        |     23      |  	23     | 
|       123	     |   2014-05-01	   |         23         |     21      |  	14     | 
|       123	     |   2014-06-01	   |         14	        |     23      |  	11     | 
|       123	     |   2014-07-01	   |         11	        |     14      |  	15     | 
|       123	     |   2014-08-01	   |         15	        |     11      |  	14     | 
|       123	     |   2014-09-01	   |         14	        |     15      |  	20     | 
|       123	     |   2014-10-01	   |         20	        |     14      |  	24     | 
|  ............  |  ............   |   ..............   |  .........  |  ......... |
|  ............  |  ............   |   ..............   |  .........  |  ......... |
|----------------|-----------------|--------------------|-------------|------------|

    =======================================================================================================

    Ejemplo 2 */

    USE EJERCICIOS

    SELECT * FROM tblAttendance

    SELECT 
        *,
        LAG(NumberAttendance, 3) OVER(PARTITION BY EmployeeNumber ORDER BY AttendanceMonth) AS lag,
        LEAD(NumberAttendance, 3) OVER(PARTITION BY EmployeeNumber ORDER BY AttendanceMonth) AS lead
    FROM tblAttendance
/*
|----------------|-----------------|--------------------|-------------|------------|
| EmployeeNumber | AttendanceMonth |  NumberAttendance  |     lag     |	   lead    |
|----------------|-----------------|--------------------|-------------|------------|
|       123	     |   2014-01-01	   |         14	        |     NULL    |  	21     | 
|       123	     |   2014-02-01	   |         12	        |     NULL    |  	23     | 
|       123	     |   2014-03-01	   |         23	        |     NULL    |  	14     | 
|       123	     |   2014-04-01	   |         21	        |     14      |  	11     | 
|       123	     |   2014-05-01	   |         23         |     12      |  	15     | 
|       123	     |   2014-06-01	   |         14	        |     23      |  	14     | 
|       123	     |   2014-07-01	   |         11	        |     21      |  	20     | 
|       123	     |   2014-08-01	   |         15	        |     23      |  	24     | 
|       123	     |   2014-09-01	   |         14	        |     14      |  	14     | 
|       123	     |   2014-10-01	   |         20	        |     11      |  	21     | 
|  ............  |  ............   |   ..............   |  .........  |  ......... |
|  ............  |  ............   |   ..............   |  .........  |  ......... |
|----------------|-----------------|--------------------|-------------|------------|

    =======================================================================================================

    Ejemplo 3 */

--  El tercer argumento nos sirve para poder modificar el valor del NULL

    USE EJERCICIOS

    SELECT * FROM tblAttendance

    SELECT 
        *,
        LAG(NumberAttendance, 3, 999) OVER(PARTITION BY EmployeeNumber ORDER BY AttendanceMonth) AS lag,
        LEAD(NumberAttendance, 3, 999) OVER(PARTITION BY EmployeeNumber ORDER BY AttendanceMonth) AS lead
    FROM tblAttendance
/*
|----------------|-----------------|--------------------|-------------|------------|
| EmployeeNumber | AttendanceMonth |  NumberAttendance  |     lag     |	   lead    |
|----------------|-----------------|--------------------|-------------|------------|
|       123	     |   2014-01-01	   |         14	        |     999     |  	21     | 
|       123	     |   2014-02-01	   |         12	        |     999     |  	23     | 
|       123	     |   2014-03-01	   |         23	        |     999     |  	14     | 
|       123	     |   2014-04-01	   |         21	        |     14      |  	11     | 
|       123	     |   2014-05-01	   |         23         |     12      |  	15     | 
|       123	     |   2014-06-01	   |         14	        |     23      |  	14     | 
|       123	     |   2014-07-01	   |         11	        |     21      |  	20     | 
|       123	     |   2014-08-01	   |         15	        |     23      |  	24     | 
|       123	     |   2014-09-01	   |         14	        |     14      |  	14     | 
|       123	     |   2014-10-01	   |         20	        |     11      |  	21     | 
|  ............  |  ............   |   ..............   |  .........  |  ......... |
|  ............  |  ............   |   ..............   |  .........  |  ......... |
|----------------|-----------------|--------------------|-------------|------------| */

--  También podemos colocar una columna

    SELECT 
        *,
        LAG(NumberAttendance, 3, NumberAttendance) OVER(PARTITION BY EmployeeNumber ORDER BY AttendanceMonth) AS lag,
        LEAD(NumberAttendance, 3, NumberAttendance) OVER(PARTITION BY EmployeeNumber ORDER BY AttendanceMonth) AS lead
    FROM tblAttendance
/*
|----------------|-----------------|--------------------|-------------|------------|
| EmployeeNumber | AttendanceMonth |  NumberAttendance  |     lag     |	   lead    |
|----------------|-----------------|--------------------|-------------|------------|
|       123	     |   2014-01-01	   |         14	        |     14      |  	21     | 
|       123	     |   2014-02-01	   |         12	        |     12      |  	23     | 
|       123	     |   2014-03-01	   |         23	        |     23      |  	14     | 
|       123	     |   2014-04-01	   |         21	        |     14      |  	11     | 
|       123	     |   2014-05-01	   |         23         |     12      |  	15     | 
|       123	     |   2014-06-01	   |         14	        |     23      |  	14     | 
|       123	     |   2014-07-01	   |         11	        |     21      |  	20     | 
|       123	     |   2014-08-01	   |         15	        |     23      |  	24     | 
|       123	     |   2014-09-01	   |         14	        |     14      |  	14     | 
|       123	     |   2014-10-01	   |         20	        |     11      |  	21     | 
|  ............  |  ............   |   ..............   |  .........  |  ......... |
|  ............  |  ............   |   ..............   |  .........  |  ......... |
|----------------|-----------------|--------------------|-------------|------------| */