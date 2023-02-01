-- ======================================================
-- ================== PERCENT_RANK() ====================
-- ======================================================

/*  La función PERCENT_RANK() es similar a la función CUME_DIST(). La función PERCENT_RANK() 
    evalúa la posición relativa de un valor dentro de una partición de un conjunto de resultados.

    A continuación se ilustra la sintaxis de la función PERCENT_RANK() de SQL Server:

                            PERCENT_RANK() OVER (
                                [PARTITION BY partition_expression, ... ]
                                ORDER BY sort_expression [ASC | DESC], ...
                            )

    En esta sintaxis:

    PARTITION BY
    ============

    La cláusula PARTITION BY distribuye las filas en múltiples particiones a las que se aplica la 
    función PERCENT_RANK(). La cláusula PARTITION BY es opcional. Si la omite, la función tratará 
    todo el conjunto de resultados como una única partición.

    ORDER BY
    ========

    La cláusula ORDER BY especifica el orden lógico de las filas de cada partición. Dado que PERCENT_RANK() 
    es sensible al orden, se requiere la cláusula ORDER_ BY.

    Return value
    ============

    El resultado de PERCENT_RANK() es mayor que 0 y menor o igual que 1.

                                     0 < PERCENT_RANK() <= 1

    La primera fila tiene un valor de rango cero. Los valores empatados se evalúan con el mismo valor de 
    distribución acumulativa.

    La función PERCENT_RANK() incluye valores NULL por defecto y los trata como los valores más bajos 
    posibles.


    ========================================================================================================

    Ejemplos de PERCENT_RANK()
    ==========================

    Veamos algunos ejemplos de uso de la función PERCENT_RANK().

    La siguiente sentencia crea una nueva vista llamada Ventas.v_ventas_personal para la demostración.  */

    CREATE VIEW Ventas.v_ventas_personal(
        personal_id, 
        ano, 
        ventas_netas
    ) AS
    SELECT 
        personal_id, 
        YEAR(fecha_pedido), 
        ROUND(SUM(cantidad * precio_catalogo * (1-descuento)), 0)
    FROM 
        Ventas.pedidos o
    INNER JOIN Ventas.items_pedidos i on i.pedido_id = o.pedido_id
    WHERE 
        personal_id IS NOT NULL
    GROUP BY 
        personal_id, 
        YEAR(fecha_pedido);
/*

    Uso de la función PERCENT_RANK() sobre un ejemplo de conjunto de resultados
    ---------------------------------------------------------------------------

    Este ejemplo utiliza la función PERCENT_RANK() para calcular el percentil de ventas de cada personal de 
    ventas en 2016:  */

    SELECT 
        CONCAT_WS(' ',nombre,apellido) nombre_completo,
        ventas_netas, 
        PERCENT_RANK() OVER (ORDER BY ventas_netas DESC) percent_rank
    FROM 
        Ventas.v_ventas_personal t
    INNER JOIN Ventas.personal m on m.personal_id = t.personal_id
    WHERE 
        ano = 2016
/*
|-------------------|------------------|--------------|
|  nombre_completo  |	ventas_netas   | percent_rank |
|-------------------|------------------|--------------|
|  Venita Daniel    |	856904.0000	   |       0      |  
|  Marcelene Boyer  |	733695.0000	   |     0,2      |  
|  Genna Serrano    |	320342.0000	   |     0,4      |  
|  Mireya Copeland  |	245152.0000	   |     0,6      |  
|  Kali Vargas      |	146934.0000    | 	 0,8      |  
|  Layla Terrell    |	124353.0000	   |       1      |
|-------------------|------------------|--------------|

    Para que la salida sea más legible, puede utilizar la función FORMAT() para formatear el ranking 
    porcentual en porcentaje (%):  */

    SELECT 
        CONCAT_WS(' ',nombre,apellido) nombre_completo,
        ventas_netas, 
        FORMAT(PERCENT_RANK() OVER (ORDER BY ventas_netas DESC) ,'P') percent_rank
    FROM 
        Ventas.v_ventas_personal t
    INNER JOIN Ventas.personal m on m.personal_id = t.personal_id
    WHERE 
        ano = 2016
/*
|-------------------|------------------|--------------|
|  nombre_completo  |	ventas_netas   | percent_rank |
|-------------------|------------------|--------------|
|  Venita Daniel    |	856904.0000	   |     0.00%    |  
|  Marcelene Boyer  |	733695.0000	   |    20.00%    |  
|  Genna Serrano    |	320342.0000	   |    40.00%    |  
|  Mireya Copeland  |	245152.0000	   |    60.00%    |  
|  Kali Vargas      |	146934.0000    | 	80.00%    |  
|  Layla Terrell    |	124353.0000	   |   100.00%    |
|-------------------|------------------|--------------|


    Uso de la función PERCENT_RANK() sobre particiones ejemplo
    ----------------------------------------------------------

    El siguiente ejemplo utiliza la función PERCENT_RANK() para calcular el percentil de ventas de cada 
    personal en 2016 y 2017.  */

    SELECT 
        ano,
        CONCAT_WS(' ',nombre,apellido) nombre_completo,
        ventas_netas, 
        FORMAT(PERCENT_RANK() OVER (PARTITION BY ano ORDER BY ventas_netas DESC) ,'P') percent_rank
    FROM 
        Ventas.v_ventas_personal t
    INNER JOIN Ventas.personal m on m.personal_id = t.personal_id
    WHERE 
        ano IN (2016,2017)
/*
|-------|-------------------|------------------|--------------|
|  ano  |  nombre_completo  |	ventas_netas   | percent_rank |
|-------|-------------------|------------------|--------------|
| 2016  |  Venita Daniel    |	 856904.0000   |     0.00%    |  
| 2016  |  Marcelene Boyer  |	 733695.0000   |    20.00%    |  
| 2016  |  Genna Serrano    |	 320342.0000   |    40.00%    |  
| 2016  |  Mireya Copeland  |	 245152.0000   |    60.00%    |  
| 2016  |  Kali Vargas      |	 146934.0000   | 	80.00%    |  
| 2016  |  Layla Terrell    |	 124353.0000   |   100.00%    |
| 2017  |  Marcelene Boyer  |	1370320.0000   |     0.00%    |  
| 2017  |  Venita Daniel    |	1109368.0000   |    20.00%    |  
| 2017  |  Genna Serrano    |	 285771.0000   |    40.00%    |  
| 2017  |  Mireya Copeland  |	 277137.0000   |    60.00%    |  
| 2017  |  Layla Terrell    |	 222740.0000   | 	80.00%    |  
| 2017  |  Kali Vargas      |	 181872.0000   |   100.00%    |
|-------|-------------------|------------------|--------------|

    En este ejemplo:

    - La cláusula PARTITION BY distribuyó las filas por año en dos particiones, una para 2016 y otra para 2017.

    - La cláusula ORDER BY ordenó las filas de cada partición por ventas netas de mayor a menor.

    La función PERCENT_RANK() se aplica a cada partición por separado y vuelve a calcular el ranking al cruzar 
    el límite de la partición.