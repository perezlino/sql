-- ======================================================
-- ======================= CUBE =========================
-- ======================================================

    USE TiendaBicicletas

/*  Los Grouping sets especifican agrupaciones de datos en una única consulta. Por ejemplo, 
    la siguiente consulta define un único grouping set representado como (marca):  */

    SELECT 
        marca, 
        SUM(ventas) ventas
    FROM 
        Ventas.resumen_ventas
    GROUP BY 
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

    Si no ha seguido el tutorial de GROUPING SETS, puede crear la tabla Ventas.resumen_ventas utilizando 
    la siguiente consulta:  */

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

    Aunque la siguiente consulta no utiliza la cláusula GROUP BY, genera un grouping set vacío que se 
    denota como ().  */

    SELECT 
        SUM(ventas) ventas
    FROM 
        Ventas.resumen_ventas;
/*
|--------------|
|     ventas   |
|--------------|
| 7689113.0000 |
|--------------|

    CUBE es una subcláusula de la cláusula GROUP BY que permite generar múltiples grouping sets. A 
    continuación, se ilustra la sintaxis general del CUBE:  */

                                        SELECT
                                            d1,
                                            d2,
                                            d3,
                                            aggregate_function (c4)
                                        FROM
                                            table_name
                                        GROUP BY
                                            CUBE (d1, d2, d3);         
/*

    En esta sintaxis, el CUBE genera todos los posibles conjuntos de agrupación (grouping sets) basados en 
    las columnas de dimensión d1, d2 y d3 que se especifican en la cláusula CUBE.

    La consulta anterior devuelve el mismo conjunto de resultados que la consulta siguiente, que utiliza los 
    GROUPING SETS:  */

                                        SELECT
                                            d1,
                                            d2,
                                            d3,
                                            aggregate_function (c4)
                                        FROM
                                            table_name
                                        GROUP BY
                                            GROUPING SETS (
                                                (d1,d2,d3), 
                                                (d1,d2),
                                                (d1,d3),
                                                (d2,d3),
                                                (d1),
                                                (d2),
                                                (d3), 
                                                ()
                                            );
/*

    Si tiene N columnas de dimensión especificadas en el CUBE, tendrá 2N grouping sets.

    Es posible reducir el número de grouping sets. utilizando el CUBE parcialmente, como se muestra en la 
    siguiente consulta:  */

                                            SELECT
                                                d1,
                                                d2,
                                                d3,
                                                aggregate_function (c4)
                                            FROM
                                                table_name
                                            GROUP BY
                                                d1,
                                                CUBE (d2, d3);
/*

    En este caso, la consulta genera cuatro grouping sets porque sólo hay dos columnas de dimensión 
    especificadas en el CUBE.


    ==========================================================================================================

    Ejemplos de CUBE
    ================

    La siguiente sentencia utiliza el CUBE para generar cuatro grouping sets:

    1.- (marca, categoría)
    2.- (marca)
    3.- (categoría)
    4.- () 
*/

    SELECT
        marca,
        categoria,
        SUM (ventas) ventas
    FROM
        Ventas.resumen_ventas
    GROUP BY
        CUBE(marca, categoria);
/*
|--------------|-------------------|-------------|
|     marca	   |     categoria	   |    ventas   |
|--------------|-------------------|-------------|
|Electra	   | Children Bicycles | 207606.0000 |
|Haro	       | Children Bicycles |  29240.0000 |
|Strider	   | Children Bicycles |   4320.0000 |
|Sun Bicycles  | Children Bicycles |   2328.0000 |
|Trek	       | Children Bicycles |  48695.0000 |
|--------------|-------------------|-------------|
|NULL	       | Children Bicycles | 292189.0000 |
|--------------|-------------------|-------------|
|Electra	   | Comfort Bicycles  | 271542.0000 |   
|Sun Bicycles  | Comfort Bicycles  | 122478.0000 |
|--------------|-------------------|-------------|
|NULL	       | Comfort Bicycles  | 394020.0000 |
|--------------|-------------------|-------------|
|Electra	   | Cruisers Bicycles | 694909.0000 |
|Pure Cycles   | Cruisers Bicycles | 149476.0000 |
|Sun Bicycles  | Cruisers Bicycles | 150647.0000 |
|--------------|-------------------|-------------|
|NULL	       | Cruisers Bicycles | 995032.0000 |
|--------------|-------------------|-------------|
|Surly	       |Cyclocross Bicycles| 439644.0000 |
|Trek	       |Cyclocross Bicycles| 271367.0000 |
|--------------|-------------------|-------------|
|NULL	       |Cyclocross Bicycles| 711011.0000 |
|--------------|-------------------|-------------|
|Electra	   | Electric Bikes	   |  31264.0000 |
|Sun Bicycles  | Electric Bikes    |  47049.0000 |
|Trek	       | Electric Bikes	   | 838372.0000 |
|--------------|-------------------|-------------|
|NULL	       | Electric Bikes	   | 916685.0000 |
|--------------|-------------------|-------------|
|Haro	       | Mountain Bikes	   | 156145.0000 |
|Heller	       | Mountain Bikes	   | 171459.0000 |
|Ritchey	   | Mountain Bikes	   |  78899.0000 |
|Sun Bicycles  | Mountain Bikes	   |  19492.0000 |
|Surly	       | Mountain Bikes	   | 441383.0000 |
|Trek	       | Mountain Bikes	   |1847700.0000 |
|--------------|-------------------|-------------|
|NULL	       | Mountain Bikes	   |2715078.0000 |
|--------------|-------------------|-------------|
|Surly	       | Road Bikes	       |  68478.0000 |
|Trek	       | Road Bikes	       |1596620.0000 |
|--------------|-------------------|-------------|
|NULL	       | Road Bikes	       |1665098.0000 |
|--------------|-------------------|-------------|
|NULL	       | NULL	           |7689113.0000 |
|--------------|-------------------|-------------|
|Electra	   | NULL	           |1205321.0000 |
|Haro	       | NULL	           | 185385.0000 |
|Heller	       | NULL	           | 171459.0000 |
|Pure Cycles   | NULL	           | 149476.0000 |
|Ritchey	   | NULL	           |  78899.0000 |
|Strider	   | NULL	           |   4320.0000 |
|Sun Bicycles  | NULL	           | 341994.0000 |
|Surly	       | NULL	           | 949505.0000 |
|Trek	       | NULL	           |4602754.0000 |
|--------------|-------------------|-------------|

    En este ejemplo, tenemos dos columnas de dimensión especificadas en la cláusula CUBE, por lo tanto, 
    tenemos un total de cuatro grouping sets.

    El siguiente ejemplo ilustra cómo realizar un CUBE parcial para reducir el número de grouping sets 
    generados por la consulta:  */

    SELECT
        marca,
        categoria,
        SUM (ventas) ventas
    FROM
        Ventas.resumen_ventas
    GROUP BY
        marca,
        CUBE(categoria);
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