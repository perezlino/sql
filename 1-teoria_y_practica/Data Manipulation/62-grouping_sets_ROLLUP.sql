-- ======================================================
-- ====================== ROLLUP ========================
-- ======================================================

/*  ROLLUP es una subcláusula de la cláusula GROUP BY que proporciona una forma abreviada de definir 
    múltiples grouping sets. A diferencia de la subcláusula CUBE, ROLLUP no crea todos los posibles 
    grouping sets basados en las columnas de dimensión; CUBE hace un subconjunto de ellos.

    Al generar los grouping sets, ROLLUP asume una jerarquía entre las columnas de dimensión y sólo 
    genera grouping sets basados en esta jerarquía.

    El ROLLUP se usa a menudo para generar subtotales y totales para propósitos de reportes.

    Consideremos un ejemplo. El siguiente CUBE (d1,d2,d3) define ocho posibles grouping sets:  */

                                            (d1, d2, d3)
                                            (d1, d2)
                                            (d2, d3)
                                            (d1, d3)
                                            (d1)
                                            (d2)
                                            (d3)
                                            ()

/*  Y el ROLLUP(d1,d2,d3) crea sólo cuatro grouping sets, asumiendo la jerarquía d1 > d2 > d3, como sigue: */

                                            (d1, d2, d3)
                                            (d1, d2)
                                            (d1)
                                            ()

/*  El ROLLUP se utiliza comúnmente para calcular los agregados de datos jerárquicos como las ventas por 
    año > trimestre > mes.


    Sintaxis del ROLLUP
    ===================

    La sintaxis general del ROLLUP de SQL Server es la siguiente:  */

                                        SELECT
                                            d1,
                                            d2,
                                            d3,
                                            aggregate_function(c4)
                                        FROM
                                            table_name
                                        GROUP BY
                                            ROLLUP (d1, d2, d3);
/*

    En esta sintaxis, d1, d2 y d3 son las columnas de dimensión. La sentencia calculará la agregación de 
    valores en la columna c4 basándose en la jerarquía d1 > d2 > d3.

    También puede hacer un roll up parcial para reducir los subtotales generados utilizando la siguiente 
    sintaxis:  */

                                        SELECT
                                            d1,
                                            d2,
                                            d3,
                                            aggregate_function(c4)
                                        FROM
                                            table_name
                                        GROUP BY
                                            d1, 
                                            ROLLUP (d2, d3);
                                    /*

    ========================================================================================================

    Ejemplos de ROLLUP
    ==================

    Reutilizaremos la tabla Ventas.resumen_ventas creada en el tutorial GROUPING SETS para la demostración. 
    Si no has creado la tabla Ventas.resumen_ventas, puedes usar la siguiente sentencia para crearla.  */

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
/*

    La siguiente consulta utiliza el ROLLUP para calcular el importe de las ventas por marca (subtotal) y 
    tanto por marca como por categoría (total).   */

    SELECT
        marca,
        categoria,
        SUM (ventas) ventas
    FROM
        Ventas.resumen_ventas
    GROUP BY
        ROLLUP(marca, categoria);
/*
|-------------|----------------------|----------------|
|    marca    |	      categoria	     |     ventas     | 
|-------------|----------------------|----------------|
|Electra	  |  Children Bicycles	 |   207606.0000  |  
|Electra	  |  Comfort Bicycles	 |   271542.0000  |
|Electra	  |  Cruisers Bicycles	 |   694909.0000  |
|Electra	  |  Electric Bikes	     |    31264.0000  |
|-------------|----------------------|----------------|
|Electra	  | NULL	             |  1205321.0000  |
|-------------|----------------------|----------------|
|Haro	      |  Children Bicycles	 |    29240.0000  |
|Haro	      |  Mountain Bikes	     |   156145.0000  |
|-------------|----------------------|----------------|
|Haro	      | NULL	             |   185385.0000  |
|-------------|----------------------|----------------|
|Heller	      |  Mountain Bikes	     |   171459.0000  |
|-------------|----------------------|----------------|
|Heller	      | NULL                 |   171459.0000  |
|-------------|----------------------|----------------|
|Pure Cycles  |	 Cruisers Bicycles	 |   149476.0000  |
|-------------|----------------------|----------------|
|Pure Cycles  |	NULL                 |   149476.0000  |
|-------------|----------------------|----------------|
|Ritchey	  |  Mountain Bikes	     |    78899.0000  |
|-------------|----------------------|----------------|
|Ritchey	  | NULL	             |    78899.0000  |
|-------------|----------------------|----------------|
|Strider	  |  Children Bicycles	 |     4320.0000  |
|-------------|----------------------|----------------|
|Strider	  | NULL                 |     4320.0000  |
|-------------|----------------------|----------------|
|Sun Bicycles |	 Children Bicycles	 |     2328.0000  |
|Sun Bicycles |	 Comfort Bicycles	 |   122478.0000  |
|Sun Bicycles |	 Cruisers Bicycles	 |   150647.0000  |
|Sun Bicycles |	 Electric Bikes	     |    47049.0000  |
|Sun Bicycles |	 Mountain Bikes	     |    19492.0000  |
|-------------|----------------------|----------------|
|Sun Bicycles |	NULL                 |   341994.0000  |
|-------------|----------------------|----------------|
|Surly	      |  Cyclocross Bicycles | 	 439644.0000  |
|Surly	      |  Mountain Bikes	     |   441383.0000  |
|Surly	      |  Road Bikes	         |    68478.0000  |
|-------------|----------------------|----------------|
|Surly	      | NULL                 |	 949505.0000  |
|-------------|----------------------|----------------|
|Trek	      |  Children Bicycles	 |    48695.0000  |
|Trek	      |  Cyclocross Bicycles |	 271367.0000  |
|Trek	      |  Electric Bikes	     |   838372.0000  |
|Trek	      |  Mountain Bikes	     |  1847700.0000  |
|Trek	      |  Road Bikes	         |  1596620.0000  |
|-------------|----------------------|----------------|
|Trek	      | NULL	             |  4602754.0000  |
|-------------|----------------------|----------------|
|NULL	      | NULL                 |	7689113.0000  |
|-------------|----------------------|----------------|


    En este ejemplo, la consulta asume que existe una jerarquía entre marca y categoría, que es 
    marca > categoría.

    Tenga en cuenta que si cambia el orden de marca y categoría, el resultado será diferente, como se 
    muestra en la siguiente consulta:  */

    SELECT
        categoria,
        marca,
        SUM (ventas) ventas
    FROM
        Ventas.resumen_ventas
    GROUP BY
        ROLLUP (categoria, marca);
/*

    La siguiente sentencia muestra cómo realizar un roll-up parcial:  */

    SELECT
        marca,
        categoria,
        SUM (ventas) ventas
    FROM
        Ventas.resumen_ventas
    GROUP BY
        marca,
        ROLLUP (categoria);
/*
|-------------|----------------------|----------------|
|    marca    |	      categoria	     |     ventas     | 
|-------------|----------------------|----------------|
|Electra	  |  Children Bicycles	 |   207606.0000  |  
|Electra	  |  Comfort Bicycles	 |   271542.0000  |
|Electra	  |  Cruisers Bicycles	 |   694909.0000  |
|Electra	  |  Electric Bikes	     |    31264.0000  |
|-------------|----------------------|----------------|
|Electra	  | NULL	             |  1205321.0000  |
|-------------|----------------------|----------------|
|Haro	      |  Children Bicycles	 |    29240.0000  |
|Haro	      |  Mountain Bikes	     |   156145.0000  |
|-------------|----------------------|----------------|
|Haro	      | NULL	             |   185385.0000  |
|-------------|----------------------|----------------|
|Heller	      |  Mountain Bikes	     |   171459.0000  |
|-------------|----------------------|----------------|
|Heller	      | NULL                 |   171459.0000  |
|-------------|----------------------|----------------|
|Pure Cycles  |	 Cruisers Bicycles	 |   149476.0000  |
|-------------|----------------------|----------------|
|Pure Cycles  |	NULL                 |   149476.0000  |
|-------------|----------------------|----------------|
|Ritchey	  |  Mountain Bikes	     |    78899.0000  |
|-------------|----------------------|----------------|
|Ritchey	  | NULL	             |    78899.0000  |
|-------------|----------------------|----------------|
|Strider	  |  Children Bicycles	 |     4320.0000  |
|-------------|----------------------|----------------|
|Strider	  | NULL                 |     4320.0000  |
|-------------|----------------------|----------------|
|Sun Bicycles |	 Children Bicycles	 |     2328.0000  |
|Sun Bicycles |	 Comfort Bicycles	 |   122478.0000  |
|Sun Bicycles |	 Cruisers Bicycles	 |   150647.0000  |
|Sun Bicycles |	 Electric Bikes	     |    47049.0000  |
|Sun Bicycles |	 Mountain Bikes	     |    19492.0000  |
|-------------|----------------------|----------------|
|Sun Bicycles |	NULL                 |   341994.0000  |
|-------------|----------------------|----------------|
|Surly	      |  Cyclocross Bicycles | 	 439644.0000  |
|Surly	      |  Mountain Bikes	     |   441383.0000  |
|Surly	      |  Road Bikes	         |    68478.0000  |
|-------------|----------------------|----------------|
|Surly	      | NULL                 |	 949505.0000  |
|-------------|----------------------|----------------|
|Trek	      |  Children Bicycles	 |    48695.0000  |
|Trek	      |  Cyclocross Bicycles |	 271367.0000  |
|Trek	      |  Electric Bikes	     |   838372.0000  |
|Trek	      |  Mountain Bikes	     |  1847700.0000  |
|Trek	      |  Road Bikes	         |  1596620.0000  |
|-------------|----------------------|----------------|
|Trek	      | NULL	             |  4602754.0000  |
|-------------|----------------------|----------------|