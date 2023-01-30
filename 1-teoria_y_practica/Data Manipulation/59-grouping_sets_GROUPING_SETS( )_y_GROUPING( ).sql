-- ======================================================
-- ================= GROUPING_SETS() ====================
-- ======================================================

    USE TiendaBicicletas

/*  Crear una tabla de resumen de ventas

    Vamos a crear una nueva tabla llamada Ventas.resumen_ventas para la demostración.  */

    SELECT
        b.marca_nombre AS marca,
        c.categoria_nombre AS categoria,
        p.ano_modelo,
        ROUND(
            SUM (
                cantidad * i.precio_catalogo * (1 - descuento)
            ),
            0
        ) ventas INTO Ventas.resumen_ventas
    FROM
        Ventas.items_pedidos i
    INNER JOIN Produccion.productos p ON p.producto_id = i.producto_id
    INNER JOIN Produccion.marcas b ON b.marca_id = p.marca_id
    INNER JOIN Produccion.categorias c ON c.categoria_id = p.categoria_id
    GROUP BY
        b.marca_nombre,
        c.categoria_nombre,
        p.ano_modelo
    ORDER BY
        b.marca_nombre,
        c.categoria_nombre,
        p.ano_modelo;

/*  En esta consulta, recuperamos los datos del importe de las ventas por marca y categoría y los 
    introducimos en la tabla Ventas.resumen_ventas.

    La siguiente consulta devuelve los datos de la tabla Ventas.resumen_ventas:  */

    SELECT
        *
    FROM
        Ventas.resumen_ventas
    ORDER BY
        marca,
        categoria,
        ano_modelo;
/*
|-------|-------------------|------------|---------------|
| marca |	  categoria	    | ano_modelo |	   ventas    |
|-------|-------------------|------------|---------------|
|Electra| Children Bicycles	|   2016     |	109819.0000  |
|Electra| Children Bicycles	|   2017	 |   79664.0000  |
|Electra| Children Bicycles	|   2018	 |   18123.0000  |
|Electra| Comfort Bicycles	|   2016	 |  206615.0000  |
|Electra| Comfort Bicycles	|   2017	 |   17502.0000  |
|Electra| Comfort Bicycles	|   2018	 |   47425.0000  |
|Electra| Cruisers Bicycles	|   2016	 |  357865.0000  |
|Electra| Cruisers Bicycles	|   2017 	 |  148436.0000  |
|Electra| Cruisers Bicycles	|   2018	 |  188608.0000  |
|Electra| Electric Bikes	|   2018	 |   31264.0000  |
|Haro	| Children Bicycles	|   2017	 |   29240.0000  |
|Haro	| Mountain Bikes	|   2017	 |  156145.0000  |
|Heller	| Mountain Bikes	|   2016	 |  151161.0000  |
|Heller	| Mountain Bikes	|   2018	 |   20298.0000  |
|.......|  ...............  | .........  |  ............ |
|.......|  ...............  | .........  |  ............ |
|-------|-------------------|------------|---------------|


    Introducción a los GROUPING SETS
    ================================

    Por definición, un grouping set es un grupo de columnas por las que se agrupa. Normalmente, una única 
    consulta con un agregado define un único grouping set.

    Por ejemplo, la siguiente consulta define un grouping set que incluye la marca y la categoría, que se 
    indica como (marca, categoría). La consulta devuelve el importe de las ventas agrupado por marca y 
    categoría:   */

    SELECT
        marca,
        categoria,
        SUM (ventas) ventas
    FROM
        Ventas.resumen_ventas
    GROUP BY
        marca,
        categoria
    ORDER BY
        marca,
        categoria;
/*
|-------------|----------------------|----------------|
|    marca    |	      categoria	     |     ventas     | 
|-------------|----------------------|----------------|
|Electra	  |  Children Bicycles	 |   207606.0000  |  
|Electra	  |  Comfort Bicycles	 |   271542.0000  |
|Electra	  |  Cruisers Bicycles	 |   694909.0000  |
|Electra	  |  Electric Bikes	     |    31264.0000  |
|Haro	      |  Children Bicycles	 |    29240.0000  |
|Haro	      |  Mountain Bikes	     |   156145.0000  |
|Heller	      |  Mountain Bikes	     |   171459.0000  |
|Pure Cycles  |	 Cruisers Bicycles	 |   149476.0000  |
|Ritchey	  |  Mountain Bikes	     |    78899.0000  |
|Strider	  |  Children Bicycles	 |     4320.0000  |
|Sun Bicycles |	 Children Bicycles	 |     2328.0000  |
|Sun Bicycles |	 Comfort Bicycles	 |   122478.0000  |
|Sun Bicycles |	 Cruisers Bicycles	 |   150647.0000  |
|Sun Bicycles |	 Electric Bikes	     |    47049.0000  |
|Sun Bicycles |	 Mountain Bikes	     |    19492.0000  |
|Surly	      |  Cyclocross Bicycles | 	 439644.0000  |
|Surly	      |  Mountain Bikes	     |   441383.0000  |
|Surly	      |  Road Bikes	         |    68478.0000  |
|Trek	      |  Children Bicycles	 |    48695.0000  |
|Trek	      |  Cyclocross Bicycles |	 271367.0000  |
|Trek	      |  Electric Bikes	     |   838372.0000  |
|Trek	      |  Mountain Bikes	     |  1847700.0000  |
|Trek	      |  Road Bikes	         |  1596620.0000  |
|-------------|----------------------|----------------|

    La siguiente consulta devuelve el importe de las ventas por marca. Define un grouping set (marca):   */

    SELECT
        marca,
        SUM (ventas) ventas
    FROM
        Ventas.resumen_ventas
    GROUP BY
        marca
    ORDER BY
        marca;
/*
|------------|------------------|
|    marca   | 	    ventas      |
|------------|------------------|
|Electra	 |   1205321.0000   |
|Haro	     |    185385.0000   |
|Heller	     |    171459.0000   |
|Pure Cycles |	  149476.0000   |
|Ritchey	 |     78899.0000   |
|Strider	 |      4320.0000   |
|Sun Bicycles|	  341994.0000   |
|Surly	     |    949505.0000   |
|Trek	     |   4602754.0000   |
|------------|------------------|

    La siguiente consulta devuelve el importe de las ventas por categoría. Define un grouping set (categoría):  */

    SELECT
        categoria,
        SUM (ventas) ventas
    FROM
        Ventas.resumen_ventas
    GROUP BY
        categoria
    ORDER BY
        categoria;
/*
|---------------------|-----------------|
|      categoria	  |     ventas      | 
|---------------------|-----------------|
|Children Bicycles	  |   292189.0000   |
|Comfort Bicycles	  |   394020.0000   |
|Cruisers Bicycles	  |   995032.0000   |
|Cyclocross Bicycles  |	  711011.0000   |
|Electric Bikes	      |   916685.0000   |
|Mountain Bikes	      |  2715078.0000   |
|Road Bikes	          |  1665098.0000   |
|---------------------|-----------------|

    La siguiente consulta define un grouping set vacío (). Devuelve el importe de las ventas de todas las marcas 
    y categorías.  */

    SELECT
        SUM (ventas) ventas
    FROM
        Ventas.resumen_ventas;
/*
|--------------|
|     ventas   |
|--------------|
| 7689113.0000 |
|--------------|


    Las cuatro consultas anteriores devuelven cuatro conjuntos de resultados con cuatro grouping set:  */

    (marca, categoria)
    (marca)
    (categoria)
    ()

/*  Para obtener un conjunto de resultados unificado con los datos agregados de todos los grouping sets, puede 
    utilizar el operador UNION ALL.

    Dado que el operador UNION ALL requiere que todos los conjuntos de resultados tengan el mismo número de 
    columnas, es necesario añadir NULL a la lista de selección de las consultas de esta forma:   */

    SELECT
        marca,
        categoria,
        SUM (ventas) ventas
    FROM
        Ventas.resumen_ventas
    GROUP BY
        marca,
        categoria
    UNION ALL
    SELECT
        marca,
        NULL,
        SUM (ventas) ventas
    FROM
        Ventas.resumen_ventas
    GROUP BY
        marca
    UNION ALL
    SELECT
        NULL,
        categoria,
        SUM (ventas) ventas
    FROM
        Ventas.resumen_ventas
    GROUP BY
        categoria
    UNION ALL
    SELECT
        NULL,
        NULL,
        SUM (ventas)
    FROM
        Ventas.resumen_ventas
    ORDER BY marca, categoria;
/*

    La consulta generó un único resultado con los agregados de todos los grouping set, tal y como esperábamos.

    Sin embargo, tiene dos problemas importantes:

        1 - La consulta es bastante larga.

        2 - La consulta es lenta porque SQL Server necesita ejecutar cuatro subconsultas y combina los conjuntos 
            de resultados en uno solo.

    Para solucionar estos problemas, SQL Server proporciona una subcláusula de la cláusula GROUP BY denominada 
    GROUPING SETS.

    La cláusula GROUPING SETS define varios grouping set en la misma consulta. A continuación se muestra la 
    sintaxis general de GROUPING SETS:   */

                                            SELECT
                                                column1,
                                                column2,
                                                aggregate_function (column3)
                                            FROM
                                                table_name
                                            GROUP BY
                                                GROUPING SETS (
                                                    (column1, column2),
                                                    (column1),
                                                    (column2),
                                                    ()
                                            )
/*


    Esta consulta crea cuatro grouping set:  */

                                            (column1,column2)
                                            (column1)
                                            (column2)
                                            ()

/*  Puede utilizar este GROUPING SETS para reescribir la consulta que obtiene los datos de ventas de la 
    siguiente manera:   */

    SELECT
        marca,
        categoria,
        SUM (ventas) ventas
    FROM
        Ventas.resumen_ventas
    GROUP BY
        GROUPING SETS (
            (marca, categoria),
            (marca),
            (categoria),
            ()
        )
    ORDER BY
        marca,
        categoria;
/*

    Como puede ver, la consulta produce el mismo resultado que la que utiliza el operador UNION ALL. Sin 
    embargo, esta consulta es mucho más legible y, por supuesto, más eficaz.  

    Ahora si queremos enviar los TOTALES al final haremos lo siguiente:  */

    SELECT
        marca,
        categoria,
        SUM (ventas) ventas
    FROM
        Ventas.resumen_ventas
    GROUP BY
        GROUPING SETS (
            (marca, categoria),
            (marca),
            (categoria),
            ()
        )
    ORDER BY
        COALESCE(marca,'zzzz'),
        COALESCE(categoria, 'zzzz')
/* 

    Otra forma mejor, dado que no debemos preocuparnos del tipo de dato:  */

    SELECT
        marca,
        categoria,
        SUM (ventas) ventas
    FROM
        Ventas.resumen_ventas
    GROUP BY
        GROUPING SETS (
            (marca, categoria),
            (marca),
            (categoria),
            ()
        )
    ORDER BY
        CASE WHEN marca IS NULL THEN 1 ELSE 0 END, marca,
        CASE WHEN categoria IS NULL THEN 1 ELSE 0 END, categoria
/*


    =====================================================================================================
    =====================================================================================================

    ================
    Función GROUPING
    ================

    La función GROUPING indica si una columna especificada en una cláusula GROUP BY está agregada o no. 
    Devuelve 1 si está agregada o 0 si no lo está en el conjunto de resultados.

    Véase el siguiente ejemplo de consulta:  */

    SELECT
        GROUPING(marca) grouping_marca,
        GROUPING(categoria) grouping_categoria,
        marca,
        categoria,
        SUM (ventas) ventas
    FROM
        Ventas.resumen_ventas
    GROUP BY
        GROUPING SETS (
            (marca, categoria),
            (marca),
            (categoria),
            ()
        )
    ORDER BY
        marca,
        categoria;
/*

    El valor de la columna grouping_marca indica que la fila está agregada o no, 1 significa que el importe de 
    las ventas está agregado por marca, 0 significa que el importe de las ventas no está agregado por marca. El 
    mismo concepto se aplica a la columna grouping_categoria.


    =====================================================================================================
    =====================================================================================================

    ===================
    Función GROUPING_ID
    ===================

    En la función GROUPING_ID podemos agregar más de un campo.

    Revisar la siguiente consulta y ver el resultado:  */

    SELECT
        GROUPING_ID(marca,categoria) grouping_all,
        GROUPING(marca) grouping_marca,
        GROUPING(categoria) grouping_categoria,
        marca,
        categoria,
        SUM (ventas) ventas
    FROM
        Ventas.resumen_ventas
    GROUP BY
        GROUPING SETS (
            (marca, categoria),
            (marca),
            (categoria),
            ()
        )
    ORDER BY
        marca,
        categoria;