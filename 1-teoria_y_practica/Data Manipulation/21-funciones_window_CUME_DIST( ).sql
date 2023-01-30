-- ======================================================
-- ==================== CUME_DIST() =====================
-- ======================================================

/*  A veces, se desea elaborar un informe que contenga los valores x% superiores o inferiores de un 
    conjunto de datos, por ejemplo, el 5% de los vendedores más importantes por ventas netas. Una 
    forma de conseguirlo con SQL Server es utilizar la función CUME_DIST().

    La función CUME_DIST() calcula la distribución acumulativa de un valor dentro de un grupo de valores. 
    En pocas palabras, calcula la posición relativa de un valor en un grupo de valores.

    A continuación se muestra la sintaxis de la función CUME_DIST():

                                CUME_DIST() OVER (
                                    [PARTITION BY partition_expression, ... ]
                                    ORDER BY sort_expression [ASC | DESC], ...
                                )

    Examinemos esta sintaxis en detalle.

    Cláusula PARTITION BY
    =====================

    La cláusula PARTITION BY distribuye las filas en múltiples particiones a las que se aplica la 
    función CUME_DIST().

    La cláusula PARTITION BY es opcional. La función CUME_DIST() tratará todo el conjunto de resultados 
    como una única partición si omite la cláusula PARTITION BY.

    Cláusula ORDER BY
    =================

    La cláusula ORDER BY especifica el orden lógico de las filas en cada partición a la que se aplica la 
    función CUME_DIST(). La cláusula ORDER BY considera los valores NULL como los valores más bajos posibles.

    Return value
    ============

    El resultado de CUME_DIST() es mayor que 0 y menor o igual que 1.

                                                0 < CUME_DIST() <= 1

    La función devuelve los mismos valores de distribución acumulativa para los mismos valores de empate.



    =======================================================================================================

    Ejemplos de CUME_DIST()
    =======================

    Veamos algunos ejemplos de uso de la función CUME_DIST().


    Uso de la función CUME_DIST() sobre un ejemplo de conjunto de resultados
    ------------------------------------------------------------------------

    La siguiente sentencia calcula el percentil de ventas de cada personal de ventas en 2017:   */

    SELECT 
        ano,
        CONCAT_WS(' ',nombre,apellido) nombre_completo,
        ventas_netas, 
        CUME_DIST() OVER (ORDER BY ventas_netas DESC) cume_dist
    FROM 
        Ventas.v_ventas_personal t
    INNER JOIN Ventas.personal m on m.personal_id = t.personal_id
    WHERE 
        ano = 2017
/*
|-------|-------------------|------------------|--------------------------|
|  ano  |  nombre_completo  |	ventas_netas   |        cume_dist         |
|-------|-------------------|------------------|--------------------------|
| 2017  |  Marcelene Boyer  |	1370320.0000   |    0,16666666666666666   |  
| 2017  |  Venita Daniel    |	1109368.0000   |    0,3333333333333333    |  
| 2017  |  Genna Serrano    |	 285771.0000   |    0,5                   |  
| 2017  |  Mireya Copeland  |	 277137.0000   |    0,6666666666666666    |  
| 2017  |  Layla Terrell    |	 222740.0000   | 	0,8333333333333334    |  
| 2017  |  Kali Vargas      |	 181872.0000   |    1                     |
|-------|-------------------|------------------|--------------------------|

    Como se muestra en la salida, el 50% de los vendedores tienen ventas netas superiores a 285K.


    Uso de la función CUME_DIST() en un ejemplo de partición
    --------------------------------------------------------

    Este ejemplo utiliza la función CUME_DIST() para calcular el percentil de ventas de cada personal 
    de ventas en 2016 y 2017.  */

    SELECT 
        ano,
        CONCAT_WS(' ',nombre,apellido) nombre_completo,
        ventas_netas, 
        FORMAT(CUME_DIST() OVER (PARTITION BY ano ORDER BY ventas_netas DESC) ,'P') cume_dist
    FROM 
        Ventas.v_ventas_personal t
    INNER JOIN Ventas.personal m on m.personal_id = t.personal_id
    WHERE 
        ano IN (2016,2017)
/*
|-------|-------------------|------------------|--------------|
|  ano  |  nombre_completo  |	ventas_netas   | percent_rank |
|-------|-------------------|------------------|--------------|
| 2016  |  Venita Daniel    |	 856904.0000   |    16.67%    |  
| 2016  |  Marcelene Boyer  |	 733695.0000   |    33.33%    |  
| 2016  |  Genna Serrano    |	 320342.0000   |    50.00%    |  
| 2016  |  Mireya Copeland  |	 245152.0000   |    66.67%    |  
| 2016  |  Kali Vargas      |	 146934.0000   | 	83.33%    |  
| 2016  |  Layla Terrell    |	 124353.0000   |   100.00%    |
| 2017  |  Marcelene Boyer  |	1370320.0000   |    16.67%    |  
| 2017  |  Venita Daniel    |	1109368.0000   |    33.33%    |  
| 2017  |  Genna Serrano    |	 285771.0000   |    50.00%    |  
| 2017  |  Mireya Copeland  |	 277137.0000   |    66.67%    |  
| 2017  |  Layla Terrell    |	 222740.0000   | 	83.33%    |  
| 2017  |  Kali Vargas      |	 181872.0000   |   100.00%    |
|-------|-------------------|------------------|--------------|


    En este ejemplo:

    - La cláusula PARTITION BY distribuyó las filas en dos particiones por año, 2016 y 2017.

    - La cláusula ORDER BY ordenó las filas de cada partición por ventas netas de mayor a menor a las que 
    se aplica la función CUME_DIST().

    Para obtener el 20% de los mejores del personal de ventas por ventas netas en 2016 y 2017, se utiliza 
    la siguiente consulta:  */

    WITH cte_ventas AS (
        SELECT 
            CONCAT_WS(' ',nombre,apellido) nombre_completo,
            ventas_netas, 
            ano,
            CUME_DIST() OVER (PARTITION BY ano ORDER BY ventas_netas DESC) cume_dist
        FROM 
            Ventas.v_ventas_personal t
            INNER JOIN Ventas.personal m  
                ON m.personal_id = t.personal_id
        WHERE 
            ano IN (2016,2017)
    )
    SELECT 
        * 
    FROM 
        cte_ventas
    WHERE 
        cume_dist <= 0.20;
/*
|-----------------|--------------|-------|---------------------|
| nombre_completo |	ventas_netas |	ano  |     cume_dist       |
|-----------------|--------------|-------|---------------------|
|  Venita Daniel  |	 856904.0000 | 2016  | 0,16666666666666666 |
|  Marcelene Boyer|	1370320.0000 | 2017  | 0,16666666666666666 |
|-----------------|--------------|-------|---------------------|