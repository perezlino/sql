-- ======================================================
-- ====================== NTILE() =======================
-- ======================================================

    USE TiendaBicicletas

/*  NTILE() de SQL Server es una función de ventana que distribuye filas de una partición 
    ordenada en un número especificado de grupos aproximadamente iguales, o buckets. Asigna 
    a cada grupo un número de bucket empezando por uno. Para cada fila de un grupo, la función 
    NTILE() asigna un número de bucket que representa el grupo al que pertenece la fila.

    La sintaxis de la función NTILE() es la siguiente:

                        NTILE(buckets) OVER (
                            [PARTITION BY partition_expression, ... ]
                            ORDER BY sort_expression [ASC | DESC], ...
                        )
    
    Examinemos la sintaxis en detalle:

    buckets
    =======

    Número de buckets en los que se dividen las filas. Los buckets pueden ser una expresión o una 
    subconsulta que se evalúe como un número entero positivo. No puede ser una función ventana.

    Cláusula PARTITION BY
    =====================

    La cláusula PARTITION BY distribuye las filas de un conjunto de resultados en particiones a las que 
    se aplica la función NTILE().

    Cláusula ORDER BY
    =================

    La cláusula ORDER BY especifica el orden lógico de las filas en cada partición a la que se aplica la 
    función NTILE().

    Si el número de filas no es divisible por los buckets, la función NTILE() devuelve grupos de dos 
    tamaños con la diferencia en uno. Los grupos mayores siempre van antes que los menores en el orden 
    especificado por ORDER BY en la cláusula OVER().

    Por otra parte, si el total de filas es divisible por los buckets, la función divide equitativamente 
    las filas entre los buckets.


    Ilustración de la función NTILE()
    =================================

    La siguiente sentencia crea una nueva tabla llamada ntile_demo que almacena 10 enteros:  */

    CREATE TABLE Ventas.ntile_demo (
        v INT NOT NULL
    );
        
    INSERT INTO Ventas.ntile_demo(v) 
    VALUES(1),(2),(3),(4),(5),(6),(7),(8),(9),(10);

    SELECT * FROM Ventas.ntile_demo;
/*
|---|
| v | 
|---|
| 1 |
| 2 |
| 3 |
| 4 |
| 5 |
| 6 |
| 7 |
| 8 |
| 9 |
|10 |
|---|

    Esta sentencia utiliza la función NTILE() para dividir diez filas en tres grupos:  */

    SELECT 
        v, 
        NTILE(3) OVER (ORDER BY v) buckets
    FROM 
        Ventas.ntile_demo;
/*
|---|---------|
| v | buckets |
|---|---------|
| 1 |    1    |  
| 2 |    1    |  
| 3 |    1    |  
| 4 |    1    |  
| 5 |    2    |  
| 6 |    2    |  
| 7 |    2    |  
| 8 |    3    |  
| 9 |    3    |  
|10 |    3    |  
|---|---------|

    Como se muestra claramente en la salida, el primer grupo tiene cuatro filas y los otros dos grupos 
    tienen tres filas.

    La siguiente sentencia utiliza la función NTILE() para distribuir las filas en cinco buckets:  */

    SELECT 
        v, 
        NTILE (5) OVER (ORDER BY v) buckets
    FROM 
        Ventas.ntile_demo;
/*
|---|---------|
| v | buckets |
|---|---------|
| 1 |    1    |  
| 2 |    1    |  
| 3 |    2    |  
| 4 |    2    |  
| 5 |    3    |  
| 6 |    3    |  
| 7 |    4    |  
| 8 |    4    |  
| 9 |    5    |  
|10 |    5    |  
|---|---------|

    Como puede ver, la salida tiene cinco grupos con el mismo número de filas en cada uno.

    ==========================================================================================================

    Ejemplos de la función NTILE()
    ==============================

    Vamos a crear una vista para demostrar la función NTILE().

    La siguiente sentencia crea una vista que devuelve las ventas netas en 2017 por meses. */

    CREATE VIEW Ventas.v_ventas_netas_2017 AS
    SELECT 
        c.categoria_nombre,
        DATENAME(month, o.fecha_envio) mes, 
        CONVERT(DEC(10, 0), SUM(i.precio_catalogo * cantidad * (1 - descuento))) ventas_netas
    FROM 
        Ventas.pedidos o
    INNER JOIN Ventas.items_pedidos i ON i.pedido_id = o.pedido_id
    INNER JOIN Produccion.productos p on p.producto_id = i.producto_id
    INNER JOIN Produccion.categorias c on c.categoria_id = p.categoria_id
    WHERE 
        YEAR(fecha_envio) = 2017
    GROUP BY
        c.categoria_nombre,
        DATENAME(month, o.fecha_envio);

--  Luego:

    SELECT 
        categoria_nombre, 
        mes,
        ventas_netas 
    FROM 
    Ventas.v_ventas_netas_2017 
    ORDER BY 
    categoria_nombre, 
    ventas_netas;
/*
|------------------|-----------|----------------|
| categoria_nombre |    mes    |  ventas_netas  |
|------------------|-----------|----------------|
|Children Bicycles | December  |	  8983      |
|Children Bicycles | May	   |      9720      |
|Children Bicycles | June	   |     10659      |
|Children Bicycles | January   |   	 10779      |
|Children Bicycles | October   |	 11055      |
|Children Bicycles | September |	 11826      |
|Children Bicycles | August	   |     12286      |
|Children Bicycles | July	   |     12364      |
|Children Bicycles | February  |	 12458      |      
|Children Bicycles | November  |	 12614      |
|Children Bicycles | March	   |     15591      |
|Children Bicycles | April	   |     16022      |
|Comfort Bicycles  | November  |	  8384      |
|Comfort Bicycles  | July	   |      8592      |
|Comfort Bicycles  | March	   |     11837      |
| ................ | ......... | .............. |
| ................ | ......... | .............. |
|------------------|-----------|----------------|


    Ejemplo de uso de la función NTILE() en un conjunto de resultados de consulta
    -----------------------------------------------------------------------------

    El siguiente ejemplo utiliza la función NTILE() para distribuir los meses en 4 buckets en función de 
    las ventas netas:  */

    WITH cte_por_mes AS(
        SELECT
            mes, 
            SUM(ventas_netas) ventas_netas
        FROM 
            Ventas.v_ventas_netas_2017
        GROUP BY 
            mes
    )
    SELECT
        mes, 
        FORMAT(ventas_netas,'C','en-US') ventas_netas,
        NTILE(4) OVER(ORDER BY ventas_netas DESC) ventas_netas_group
    FROM 
        cte_por_mes;
/*
|----------|--------------|--------------------|
|    mes   | ventas_netas |	ventas_netas_group |
|----------|--------------|--------------------|
|June	   | $379,842.00  |	        1          | 
|March	   | $329,165.00  |	        1          | 
|November  | $295,301.00  |	        1          | 
|August	   | $293,045.00  |	        2          | 
|September | $281,670.00  |	        2          | 
|October   | $281,471.00  |	        2          | 
|February  | $264,884.00  |	        3          | 
|January   | $261,778.00  |	        3          | 
|December  | $260,593.00  |	        3          | 
|May	   | $254,515.00  |	        4          | 
|April	   | $236,917.00  |	        4          | 
|July	   | $199,067.00  |	        4          |
| ........ | ...........  | .................. |
| ........ | ...........  | .................. |
|----------|--------------|--------------------|


    Ejemplo de uso de la función NTILE() sobre particiones
    ------------------------------------------------------

    Este ejemplo utiliza la función NTILE() para dividir las ventas netas por mes en 4 grupos para cada 
    categoría de producto:  */

    SELECT
        categoria_nombre,
        mes, 
        FORMAT(ventas_netas,'C','en-US') ventas_netas,
        NTILE(4) OVER(PARTITION BY categoria_nombre ORDER BY ventas_netas DESC) ventas_netas_group
    FROM 
        Ventas.v_ventas_netas_2017
/*
|------------------|-----------|----------------|--------------------|
| categoria_nombre |    mes    |  ventas_netas  | ventas_netas_group |
|------------------|-----------|----------------|--------------------|
|Children Bicycles | April     |   $16,022.00   |         1          |    
|Children Bicycles | March	   |   $15,591.00   |         1          |   
|Children Bicycles | November  |   $12,614.00   |         1          |   
|Children Bicycles | February  |   $12,458.00   |         2          |   
|Children Bicycles | July      |   $12,364.00   |         2          |   
|Children Bicycles | August    |   $12,286.00   |         2          |   
|Children Bicycles | September |   $11,826.00   |         3          |   
|Children Bicycles | October   |   $11,055.00   |         3          |   
|Children Bicycles | January   |   $10,779.00   |         3          |   
|Children Bicycles | June      |   $10,659.00   |         4          |   
|Children Bicycles | May	   |   $9,720.00    |         4          |   
|Children Bicycles | December  |   $8,983.00    |         4          |   
|Comfort Bicycles  | October   |   $20,676.00   |         1          |   
|Comfort Bicycles  | August	   |   $15,920.00   |         1          |   
|Comfort Bicycles  | May	   |   $14,945.00   |         1          |   
| ................ | ......... | .............. | .................  |   
| ................ | ......... | .............. | .................  |   
|------------------|-----------|----------------|--------------------|