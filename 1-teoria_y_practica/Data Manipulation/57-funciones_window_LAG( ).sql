-- ======================================================
-- ======================= LAG() ========================
-- ======================================================

/*  SQL Server LAG() es una función de ventana que proporciona acceso a una fila en un 
    desplazamiento físico especificado que es anterior a la fila actual.

    En otras palabras, utilizando la función LAG(), desde la fila actual se puede acceder 
    a los datos de la fila anterior, o de la fila anterior a la anterior, y así sucesivamente.

    La función LAG() puede ser muy útil para comparar el valor de la fila actual con el valor 
    de la fila anterior.

    A continuación se muestra la sintaxis de la función LAG():

                            LAG(return_value ,offset [,default]) 
                            OVER (
                                [PARTITION BY partition_expression, ... ]
                                ORDER BY sort_expression [ASC | DESC], ...
                            )

    En esta sintaxis

    return_value
    ============

    El valor de retorno (return value) de la fila anterior basado en un desplazamiento especificado 
    (specified offset). El valor de retorno debe evaluarse a un único valor y no puede ser otra función 
    de ventana.

    offset
    ======

    El número de filas hacia atrás desde la fila actual desde la que acceder a los datos. "offset" puede 
    ser una expresión, subconsulta o columna que se evalúe a un número entero positivo.

    El valor por defecto de offset es 1 si no se especifica explícitamente.

    default
    =======

    "default" es el valor a devolver si offset va más allá del ámbito de la partición. Su valor por defecto 
    es NULL si no se especifica.

    Cláusula PARTITION BY
    =====================

    La cláusula PARTITION BY distribuye las filas del conjunto de resultados en particiones a las que se 
    aplica la función LAG().

    Si omite la cláusula PARTITION BY, la función tratará todo el conjunto de resultados como una única 
    partición.

    Cláusula ORDER BY
    =================

    La cláusula ORDER BY especifica el orden lógico de las filas en cada partición a la que se aplica la 
    función LAG().


    =========================================================================================================

    Ejemplos de la función LAG()
    ============================

    Reutilizaremos la vista Ventas.marcas_ventas_netas creada en el tutorial de la función LEAD() para la 
    demostración.

    La siguiente consulta muestra los datos de la vista Ventas.marcas_ventas_netas:  */

    SELECT 
        *
    FROM 
        Ventas.marcas_ventas_netas
    ORDER BY 
        ano, 
        mes, 
        marca_nombre, 
        ventas_netas
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


    A) Uso de la función LAG() sobre un ejemplo de conjunto de resultados
    ---------------------------------------------------------------------

    Este ejemplo utiliza la función LAG() para devolver las ventas netas del mes actual y del mes anterior 
    en el año 2018:  */

    WITH cte_ventas_netas_2018 AS(
        SELECT 
            mes, 
            SUM(ventas_netas) ventas_netas
        FROM 
            Ventas.marcas_ventas_netas
        WHERE 
            ano = 2018
        GROUP BY 
            mes
    )
    SELECT 
        mes,
        ventas_netas,
        LAG(ventas_netas,1) OVER (ORDER BY mes) ventas_mes_anterior
    FROM 
        cte_ventas_netas_2018
/*
|-----|--------------|--------------------|
| mes | ventas_netas | ventas_mes_proximo |
|-----|--------------|--------------------|
|  1  |     381430   |   	  NULL        |  
|  2  |	    200657	 |      381430        |  
|  3  |     363990	 |      200657        |  
|  4  |     817920	 |      363990        |  
|  6  |        189	 |      817920        |  
|  7  |      11338	 |         189        |  
|  8  |       8378	 |       11338        |  
|  9  |       8964	 |        8378        |  
| 10  |       3781	 |        8964        |  
| 11  |      11362	 |        3781        |  
| 12  |       6517	 |       11362        |    
|-----|--------------|--------------------|

    En este ejemplo:

    - Primero, el CTE devuelve las ventas netas agregadas por mes.

    - A continuación, la consulta externa utiliza la función LAG() para devolver las ventas del mes anterior.


    B) Ejemplo de uso de la función LAG() en particiones
    ----------------------------------------------------

    La siguiente sentencia utiliza la función LAG() para comparar las ventas del mes actual con el mes 
    anterior de cada marca en el año 2018:  */

    SELECT 
        mes,
        marca_nombre,
        ventas_netas,
        LAG(ventas_netas,1) OVER (PARTITION BY marca_nombre ORDER BY mes) ventas_mes_anterior
    FROM 
        Ventas.marcas_ventas_netas
    WHERE
        ano = 2018
/*
|-----|--------------|--------------|-------------------|
| mes |	marca_nombre | ventas_netas |ventas_mes_anterior|
|-----|--------------|--------------|-------------------|
|  1  |  Electra     |	    54771   |	     NULL       | 
|  2  |  Electra     |	    29772   |	    54771       | 
|  3  |  Electra     |	    83876   |	    29772       | 
|  4  |  Electra     |	   153396   |	    83876       | 
|  7  |  Electra     |	     2411   |	   153396       | 
|  8  |  Electra     |	     2056   |	     2411       | 
|  9  |  Electra     |	     3204   |	     2056       | 
| 10  |  Electra     |	     2377   |	     3204       | 
| 11  |  Electra     |	     1040   |	     2377       | 
| 12  |  Electra     |	      837   |	     1040       | 
|  1  |  Haro	     |        735   |	     NULL       | 
|  2  |  Haro	     |       3960   |	      735       | 
|  3  |  Haro	     |       2951   |	     3960       | 
|  4  |  Haro	     |      20776   |	     2951       | 
|  1  |  Heller	     |       4158   |	     NULL       | 
|  2  |  Heller	     |       5387   |	     4158       | 
|  3  |  Heller	     |       2339   |	     5387       | 
|  4  |  Heller	     |       9642   |	     2339       |
|.....|..............|..............|...................|
|.....|..............|..............|...................|
|-----|--------------|--------------|-------------------|

    En este ejemplo:

    - La cláusula PARTITION BY dividió las filas en particiones por nombre de marca.

    - Para cada partición (o marca), la cláusula ORDER BY ordena las filas por mes.

    - Para cada fila de cada partición, la función LAG() devuelve las ventas netas de la fila anterior.


    Para comparar las ventas del mes actual con el mes anterior de ventas netas por marca en 2018, utiliza 
    la siguiente consulta:  */

    WITH cte_ventas AS (
        SELECT 
            mes,
            marca_nombre,
            ventas_netas,
            LAG(ventas_netas,1) OVER (PARTITION BY marca_nombre ORDER BY mes) ventas_anteriores
        FROM 
            Ventas.marcas_ventas_netas
        WHERE
            ano = 2018
    )
    SELECT 
        mes, 
        marca_nombre,
        ventas_netas, 
        ventas_anteriores,
        FORMAT((ventas_netas - ventas_anteriores)  / ventas_anteriores, 'P') vs_mes_anterior
    FROM
        cte_ventas
/*
|-----|--------------|--------------|-------------------|-----------------|
| mes |	marca_nombre | ventas_netas |ventas_mes_anterior| vs_mes_anterior |
|-----|--------------|--------------|-------------------|-----------------|
|  1  |  Electra     |	    54771   |	     NULL       |         NULL    |  
|  2  |  Electra     |	    29772   |	    54771       |      -45.64%    | 
|  3  |  Electra     |	    83876   |	    29772       |      181.73%    |  
|  4  |  Electra     |	   153396   |	    83876       |       82.88%    |  
|  7  |  Electra     |	     2411   |	   153396       |      -98.43%    |  
|  8  |  Electra     |	     2056   |	     2411       |      -14.72%    |  
|  9  |  Electra     |	     3204   |	     2056       |       55.84%    |  
| 10  |  Electra     |	     2377   |	     3204       |      -25.81%    |  
| 11  |  Electra     |	     1040   |	     2377       |      -56.25%    |  
| 12  |  Electra     |	      837   |	     1040       |      -19.52%    |  
|  1  |  Haro	     |        735   |	     NULL       |         NULL    |  
|  2  |  Haro	     |       3960   |	      735       |      438.78%    |  
|  3  |  Haro	     |       2951   |	     3960       |      -25.48%    |  
|  4  |  Haro	     |      20776   |	     2951       |      604.03%    |  
|  1  |  Heller	     |       4158   |	     NULL       |         NULL    |  
|  2  |  Heller	     |       5387   |	     4158       |       29.56%    |  
|  3  |  Heller	     |       2339   |	     5387       |      -56.58%    |  
|  4  |  Heller	     |       9642   |	     2339       |      312.23%    |  
|.....|..............|..............|...................|.................|
|.....|..............|..............|...................|.................|
|-----|--------------|--------------|-------------------|-----------------|


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