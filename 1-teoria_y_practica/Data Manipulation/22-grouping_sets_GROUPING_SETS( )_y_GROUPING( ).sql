-- ======================================================
-- ================= GROUPING_SETS() ====================
-- ======================================================

    USE TiendaBicicletas

/*  Crear una tabla de resumen de ventas

    Vamos a crear una nueva tabla llamada Ventas.resumen_ventas para la demostración.  */

    SELECT
        b.brand_name AS brand,
        c.category_name AS category,
        p.model_year,
        round(
            SUM (
                quantity * i.list_price * (1 - discount)
            ),
            0
        ) sales INTO sales.sales_summary
    FROM
        sales.order_items i
    INNER JOIN production.products p ON p.product_id = i.product_id
    INNER JOIN production.brands b ON b.brand_id = p.brand_id
    INNER JOIN production.categories c ON c.category_id = p.category_id
    GROUP BY
        b.brand_name,
        c.category_name,
        p.model_year
    ORDER BY
        b.brand_name,
        c.category_name,
        p.model_year;

/*  En esta consulta, recuperamos los datos del importe de las ventas por marca y categoría y los 
    introducimos en la tabla sales.sales_summary.

    La siguiente consulta devuelve los datos de la tabla sales.sales_summary:  */

    SELECT
        *
    FROM
        sales.sales_summary
    ORDER BY
        brand,
        category,
        model_year;
/*


    Introducción a los GROUPING SETS
    ================================

    Por definición, un grouping set es un grupo de columnas por las que se agrupa. Normalmente, una única 
    consulta con un agregado define un único grouping set.

    Por ejemplo, la siguiente consulta define un grouping set que incluye la marca y la categoría, que se 
    indica como (marca, categoría). La consulta devuelve el importe de las ventas agrupado por marca y 
    categoría:   */

    SELECT
        brand,
        category,
        SUM (sales) sales
    FROM
        sales.sales_summary
    GROUP BY
        brand,
        category
    ORDER BY
        brand,
        category;
/*


    La siguiente consulta devuelve el importe de las ventas por marca. Define un grouping set (marca):   */

    SELECT
        brand,
        SUM (sales) sales
    FROM
        sales.sales_summary
    GROUP BY
        brand
    ORDER BY
        brand;
/*


    La siguiente consulta devuelve el importe de las ventas por categoría. Define un grouping set (categoría):  */

    SELECT
        category,
        SUM (sales) sales
    FROM
        sales.sales_summary
    GROUP BY
        category
    ORDER BY
        category;
/*


    La siguiente consulta define un grouping set vacío (). Devuelve el importe de las ventas de todas las marcas 
    y categorías.  */

    SELECT
        SUM (sales) sales
    FROM
        sales.sales_summary;
/*


    Las cuatro consultas anteriores devuelven cuatro conjuntos de resultados con cuatro grouping set:  */

    (brand, category)
    (brand)
    (category)
    ()

/*  Para obtener un conjunto de resultados unificado con los datos agregados de todos los grouping sets, puede 
    utilizar el operador UNION ALL.

    Dado que el operador UNION ALL requiere que todos los conjuntos de resultados tengan el mismo número de 
    columnas, es necesario añadir NULL a la lista de selección de las consultas de esta forma:   */

    SELECT
        brand,
        category,
        SUM (sales) sales
    FROM
        sales.sales_summary
    GROUP BY
        brand,
        category
    UNION ALL
    SELECT
        brand,
        NULL,
        SUM (sales) sales
    FROM
        sales.sales_summary
    GROUP BY
        brand
    UNION ALL
    SELECT
        NULL,
        category,
        SUM (sales) sales
    FROM
        sales.sales_summary
    GROUP BY
        category
    UNION ALL
    SELECT
        NULL,
        NULL,
        SUM (sales)
    FROM
        sales.sales_summary
    ORDER BY brand, category;
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
    );
/*


    Esta consulta crea cuatro grouping set:  */

    (column1,column2)
    (column1)
    (column2)
    ()

/*  Puede utilizar este GROUPING SETS para reescribir la consulta que obtiene los datos de ventas de la 
    siguiente manera:   */

    SELECT
        brand,
        category,
        SUM (sales) sales
    FROM
        sales.sales_summary
    GROUP BY
        GROUPING SETS (
            (brand, category),
            (brand),
            (category),
            ()
        )
    ORDER BY
        brand,
        category;
/*


    Como puede ver, la consulta produce el mismo resultado que la que utiliza el operador UNION ALL. Sin 
    embargo, esta consulta es mucho más legible y, por supuesto, más eficaz.


    =====================================================================================================
    =====================================================================================================

    ================
    Función GROUPING
    ================

    La función GROUPING indica si una columna especificada en una cláusula GROUP BY está agregada o no. 
    Devuelve 1 si está agregada o 0 si no lo está en el conjunto de resultados.

    Véase el siguiente ejemplo de consulta:  */

    SELECT
        GROUPING(brand) grouping_brand,
        GROUPING(category) grouping_category,
        brand,
        category,
        SUM (sales) sales
    FROM
        sales.sales_summary
    GROUP BY
        GROUPING SETS (
            (brand, category),
            (brand),
            (category),
            ()
        )
    ORDER BY
        brand,
        category;
/*


    El valor de la columna grouping_brand indica que la fila está agregada o no, 1 significa que el importe de 
    las ventas está agregado por marca, 0 significa que el importe de las ventas no está agregado por marca. El 
    mismo concepto se aplica a la columna grouping_category.