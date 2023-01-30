-- ======================================================
-- ================= PIVOT y UNPIVOT ====================
-- ======================================================

    USE TiendaBicicletas

/*  Para la demostración, utilizaremos las tablas Produccion.productos y Produccion.categorias 
    de la base de datos 'TiendaBicicletas'

    La siguiente consulta busca el número de productos de cada categoría de productos:  */

    SELECT 
        categoria_nombre, 
        COUNT(producto_id) producto_count
    FROM 
        Produccion.productos p
        INNER JOIN Produccion.categorias c 
            ON c.categoria_id = p.categoria_id
    GROUP BY 
        categoria_nombre;
    /*
    |-------------------|----------------|
    | categoria_nombre  | producto_count |
    |-------------------|----------------|
    |Children Bicycles	|       59       |  
    |Comfort Bicycles	|       30       |
    |Cruisers Bicycles	|       78       |
    |Cyclocross Bicycles|	    10       |
    |Electric Bikes     |	    24       |
    |Mountain Bikes	    |       60       |
    |Road Bikes	        |       60       |
    |-------------------|----------------|

    Nuestro objetivo es convertir los nombres de las categorías de la primera columna de la salida 
    en varias columnas y contar el número de productos de cada nombre de categoría como en la siguiente 
    imagen:

|-----------------|----------------|-----------------|-------------------|--------------|--------------|----------|
|Children Bicycles|Comfort Bicycles|Cruisers Bicycles|Cyclocross Bicycles|Electric Bikes|Mountain Bikes|Road Bikes|
|-----------------|----------------|-----------------|-------------------|--------------|--------------|----------|
|       59	      |       30       | 	    78       |   	   10        |   	24      |	   60      | 	60    |  
|-----------------|----------------|-----------------|-------------------|--------------|--------------|----------|

    Además, podemos añadir el año del modelo para agrupar la categoría por año del modelo, como se muestra 
    en el siguiente resultado:

|----------|-----------------|----------------|-----------------|-------------------|--------------|--------------|----------|
|ano_modelo|Children Bicycles|Comfort Bicycles|Cruisers Bicycles|Cyclocross Bicycles|Electric Bikes|Mountain Bikes|Road Bikes|
|----------|-----------------|----------------|-----------------|-------------------|--------------|--------------|----------|
|   2016   | 	    3	     |       3	      |         9	    |          2        |	    1      | 	  8	      |     0    |   
|   2017   | 	   19	     |      10	      |        19	    |          2	    |       2	   |     21	      |    12    |   
|   2018   | 	   37	     |      17	      |        50	    |          6	    |      21	   |     31	      |    42    |   
|   2019   | 	    0	     |       0	      |         0	    |          0	    |       0      | 	  0	      |     6    |   
|----------|-----------------|----------------|-----------------|-------------------|--------------|--------------|----------|
 

    ======================================================================================================

    Introducción al operador PIVOT de SQL Server
    ============================================

    El operador PIVOT de SQL Server gira una expresión con valores de tabla. Convierte los valores únicos 
    e una columna en varias columnas en la salida y realiza agregaciones en cualquier valor de columna 
    restante.

    Siga estos pasos para convertir una consulta en una tabla pivote:

    - En primer lugar, seleccione un conjunto de datos base para pivotar.
    - En segundo lugar, cree un resultado temporal utilizando una tabla derivada o una expresión de tabla 
      común (CTE).
    - En tercer lugar, aplique el operador PIVOT.

    Apliquemos estos pasos en el siguiente ejemplo.

    En primer lugar, seleccione el nombre de la categoría y el producto id de las tablas Produccion.productos 
    y Produccion.categorias como los datos base para pivotar:  */

    SELECT 
        categoria_nombre, 
        producto_id
    FROM 
        Produccion.productos p
        INNER JOIN Produccion.categorias c 
            ON c.categoria_id = p.categoria_id
/*

    En segundo lugar, cree un conjunto de resultados temporal utilizando una tabla derivada:  */

    SELECT * FROM (
        SELECT 
            categoria_nombre, 
            producto_id
        FROM 
            Produccion.productos p
            INNER JOIN Produccion.categorias c 
                ON c.categoria_id = p.categoria_id
    ) t
/*

    En tercer lugar, aplica el operador PIVOT:  */

    SELECT * FROM   
    (
        SELECT 
            categoria_nombre, 
            producto_id
        FROM 
            Produccion.productos p
            INNER JOIN Produccion.categorias c 
                ON c.categoria_id = p.categoria_id
    ) t 
    PIVOT(
        COUNT(producto_id) 
        FOR categoria_nombre IN (
            [Children Bicycles], 
            [Comfort Bicycles], 
            [Cruisers Bicycles], 
            [Cyclocross Bicycles], 
            [Electric Bikes], 
            [Mountain Bikes], 
            [Road Bikes])
    ) AS pivot_table;
/*
|-----------------|----------------|-----------------|-------------------|--------------|--------------|----------|
|Children Bicycles|Comfort Bicycles|Cruisers Bicycles|Cyclocross Bicycles|Electric Bikes|Mountain Bikes|Road Bikes|
|-----------------|----------------|-----------------|-------------------|--------------|--------------|----------|
|       59	      |       30       | 	    78       |   	   10        |   	24      |	   60      | 	60    |  
|-----------------|----------------|-----------------|-------------------|--------------|--------------|----------|

    Ahora, cualquier columna adicional que añada a la lista de selección de la consulta que devuelve los 
    datos base formará automáticamente grupos de filas en la tabla pivote. Por ejemplo, puede añadir la 
    columna del año del modelo a la consulta anterior:  */

    SELECT * FROM   
    (
        SELECT 
            categoria_nombre, 
            producto_id,
            ano_modelo
        FROM 
            Produccion.productos p
            INNER JOIN Produccion.categorias c 
                ON c.categoria_id = p.categoria_id
    ) t 
    PIVOT(
        COUNT(producto_id) 
        FOR categoria_nombre IN (
            [Children Bicycles], 
            [Comfort Bicycles], 
            [Cruisers Bicycles], 
            [Cyclocross Bicycles], 
            [Electric Bikes], 
            [Mountain Bikes], 
            [Road Bikes])
    ) AS pivot_table;
/*
|----------|-----------------|----------------|-----------------|-------------------|--------------|--------------|----------|
|ano_modelo|Children Bicycles|Comfort Bicycles|Cruisers Bicycles|Cyclocross Bicycles|Electric Bikes|Mountain Bikes|Road Bikes|
|----------|-----------------|----------------|-----------------|-------------------|--------------|--------------|----------|
|   2016   | 	    3	     |       3	      |         9	    |          2        |	    1      | 	  8	      |     0    |   
|   2017   | 	   19	     |      10	      |        19	    |          2	    |       2	   |     21	      |    12    |   
|   2018   | 	   37	     |      17	      |        50	    |          6	    |      21	   |     31	      |    42    |   
|   2019   | 	    0	     |       0	      |         0	    |          0	    |       0      | 	  0	      |     6    |   
|----------|-----------------|----------------|-----------------|-------------------|--------------|--------------|----------|
    ======================================================================================================

    Generación de valores de columna
    ================================

    En la consulta anterior, ha tenido que escribir manualmente cada nombre de categoría entre 
    paréntesis después del operador IN. Para evitarlo, puede utilizar la función QUOTENAME() para 
    generar la lista de nombres de categoría y copiarlos en la consulta.

    En primer lugar, genere la lista de nombres de categorías:  */

    DECLARE 
        @columns NVARCHAR(MAX) = '';

    SELECT 
        @columns += QUOTENAME(categoria_nombre) + ','
    FROM 
        Produccion.categorias
    ORDER BY 
        categoria_nombre;

    SET @columns = LEFT(@columns, LEN(@columns) - 1);

    PRINT @columns;
/*

    El resultado será el siguiente:  */

    [Children Bicycles],[Comfort Bicycles],[Cruisers Bicycles],[Cyclocross Bicycles],[Electric Bikes],
    [Mountain Bikes],[Road Bikes]

/*  En este fragmento:

    - La función QUOTENAME() envuelve el nombre de la categoría entre corchetes, por ejemplo, [Children Bicycles].
    - La función LEFT() elimina la última coma de la cadena @columns.
    - En segundo lugar, copie la lista de nombres de categoría de la salida y péguela en la consulta.


    ======================================================================================================

    Tablas pivot dinámicas
    ======================

    Si añade un nuevo nombre de categoría a la tabla Produccion.categorias, tendrá que reescribir la consulta, 
    lo que no es lo ideal. Para evitarlo, puede utilizar SQL dinámico para que la tabla pivote sea dinámica.

    En esta consulta, en lugar de pasar una lista fija de nombres de categoría al operador PIVOT, construimos 
    la lista de nombres de categoría y la pasamos a una sentencia SQL, y luego ejecutamos esta sentencia 
    dinámicamente utilizando el stored procedure sp_executesql.  */

    DECLARE 
        @columns NVARCHAR(MAX) = '', 
        @sql     NVARCHAR(MAX) = '';

    -- seleccionar los nombres de las categorías
    SELECT 
        @columns+=QUOTENAME(categoria_nombre) + ','
    FROM 
        Produccion.categorias
    ORDER BY 
        categoria_nombre;

    -- quitar la última coma
    SET @columns = LEFT(@columns, LEN(@columns) - 1);

    -- construir SQL dinámico
    SET @sql ='
    SELECT * FROM   
    (
        SELECT 
            categoria_nombre, 
            ano_modelo,
            producto_id 
        FROM 
            Produccion.productos p
            INNER JOIN Produccion.categorias c 
                ON c.categoria_id = p.categoria_id
    ) t 
    PIVOT(
        COUNT(producto_id) 
        FOR categoria_nombre IN ('+ @columns +')
    ) AS pivot_table;';

    -- execute the dynamic SQL
    EXECUTE sp_executesql @sql;
/*

    ==========================================================================================================
    ==========================================================================================================

    Ejemplo 1  */

    USE EJERCICIOS

    WITH tabla_pivot AS
    (SELECT YEAR(DateOfTransaction) AS ano, MONTH(DateOfTransaction) AS mes, Amount
        FROM tblTransaction) 
    
    SELECT * FROM tabla_pivot
    PIVOT(
        SUM(Amount)
        FOR mes IN ( [1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
        ) AS tp
    ORDER BY ano
/*
|----|--------|-------|--------|--------|--------|--------|--------|--------|-------|-------|-------|--------|
|ano | 	  1   |   2	  |    3   | 	4	|    5	 |    6	  |    7   |    8	|   9	|  10	|  11	|   12   |
|----|--------|-------|--------|--------|--------|--------|--------|--------|-------|-------|-------|--------|
|2014|12809,72|2377,15| 6176,11| 6523,08| 3212,77|-1238,11|-4618,53| 9881,73| 130,63|-501,88| 543,80|-4066,83|
|2015| 5419,74|4440,98|12856,58|13288,68|-4618,75|-1450,94|-6983,60|-1073,96|4190,33|2078,13|-388,07|-2506,48|
|2016|-1238,60|	NULL  |  NULL  | NULL	| NULL	 | NULL	  | NULL   |  NULL	| NULL	| NULL	| NULL	| NULL   | 
|----|--------|-------|--------|--------|--------|--------|--------|--------|-------|-------|-------|--------|  


    Podemos cambiar el valor de los NULL de la siguiente forma:  */

    WITH tabla_pivot AS
    (SELECT YEAR(DateOfTransaction) AS ano, MONTH(DateOfTransaction) AS mes, Amount
        FROM tblTransaction) 
    
    SELECT ano, ISNULL([1],0) AS 'Enero',
                ISNULL([2],0) AS 'Febrero',
                ISNULL([3],0) AS 'Marzo',
                ISNULL([4],0) AS 'Abril',
                ISNULL([5],0) AS 'Mayo',
                ISNULL([6],0) AS 'Junio',
                ISNULL([7],0) AS 'Julio',
                ISNULL([8],0) AS 'Agosto',
                ISNULL([9],0) AS 'Septiembre',
                ISNULL([10],0) AS 'Octubre',
                ISNULL([11],0) AS 'Noviembre',
                ISNULL([12],0) AS 'Diciembre'
    FROM tabla_pivot
    PIVOT(
        SUM(Amount)
        FOR mes IN ( [1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
        ) AS tp
    ORDER BY ano
/*
|----|--------|-------|--------|--------|--------|--------|--------|--------|-------|-------|-------|--------|
|ano |Enero   |Febrero|Marzo   |Abril	|Mayo	 |Junio	  |Julio   |Agosto	|Septiem|Octubre|Noviemb|Diciembr|
|----|--------|-------|--------|--------|--------|--------|--------|--------|-------|-------|-------|--------|
|2014|12809,72|2377,15| 6176,11| 6523,08| 3212,77|-1238,11|-4618,53| 9881,73| 130,63|-501,88| 543,80|-4066,83|
|2015| 5419,74|4440,98|12856,58|13288,68|-4618,75|-1450,94|-6983,60|-1073,96|4190,33|2078,13|-388,07|-2506,48|
|2016|-1238,60|	0.00  |  0.00  | 0.00	| 0.00	 | 0.00	  | 0.00   |  0.00	| 0.00	| 0.00	| 0.00	| 0.00   | 
|----|--------|-------|--------|--------|--------|--------|--------|--------|-------|-------|-------|--------| 

    ==========================================================================================================
    ==========================================================================================================

    Ejemplo 2  */

    USE AdventureWorks2019

    SELECT 
        YEAR(OrderDate) AS YearRef, 
        SUM(TotalDue) as Total 
    FROM 
        Sales.SalesOrderHeader
    GROUP BY 
        YEAR(OrderDate);

-- ---------------------------------------

    WITH tabla_pivot AS
    (SELECT 
            YEAR(OrderDate) AS SalesYear,
            TotalDue AS TotalSales
    FROM 
        Sales.SalesOrderHeader)


    ---- PIVOT
    SELECT * FROM tabla_pivot AS Sales
    PIVOT (SUM(TotalSales)
    FOR SalesYear IN ([2011],[2012],[2013],[2014])) AS pvt


    ---- UNPIVOT
    SELECT SalesYear, 
        TotalSales
    FROM
    (SELECT 
        *
    FROM
        (SELECT YEAR(soh.OrderDate) AS SalesYear
                    ,soh.SubTotal AS TotalSales
            FROM sales.SalesOrderHeader AS soh) AS Sales 
    PIVOT(SUM(TotalSales) FOR SalesYear IN([2011],[2012],[2013],[2014])) AS PVT
    ) AS T UNPIVOT(TotalSales FOR SalesYear IN([2011],[2012],[2013],[2014])) AS upvt;
/*

    ==========================================================================================================
    ==========================================================================================================

    Ejemplo 3  */

    USE AdventureWorks2019

    SELECT * FROM (SELECT DAY([soh].[OrderDate]) AS [SalesDaily],
                          [soh].[TotalDue] AS [TotalSales]
                    FROM  [sales].[SalesOrderHeader] AS [soh]
                    WHERE [soh].[OrderDate] >= '2011-06-01' 
                    AND   [soh].[OrderDate]<='2011-06-30'
                ) AS [Sales]
    PIVOT (SUM([TotalSales]) FOR [SalesDaily] IN ([01],[02])) AS [pvt]
/*

    ==========================================================================================================
    ==========================================================================================================

    Ejemplo 4  */

    USE AdventureWorks2019

    --Primer paso--

    --DECLARE @columns AS VARCHAR(MAX)
    --DECLARE @startDate AS VARCHAR(10) = '2011-06-01'
    --DECLARE @endDate AS VARCHAR(10) = '2011-06-30' 

    SELECT DISTINCT [OrderDate]
    FROM [Sales].[SalesOrderHeader] AS [soh]
    WHERE [soh].[OrderDate] >= @startDate AND [soh].[OrderDate] <= @endDate


    --Segundo paso--

    --DECLARE @columns AS VARCHAR(MAX)
    --DECLARE @startDate AS VARCHAR(10) = '2011-06-01'
    --DECLARE @endDate AS VARCHAR(10) = '2011-06-30'

    SELECT @columns = STUFF(
    (SELECT ',' + QUOTENAME(LTRIM(DAY([OrderDate])))
    FROM (SELECT DISTINCT [OrderDate]
        FROM [Sales].[SalesOrderHeader] AS [soh]
        WHERE [soh].[OrderDate] >= @startDate 
            AND [soh].[OrderDate] <= @endDate) AS [T]
    ORDER BY [OrderDate]
    FOR XML PATH('')
    ), 1, 1, ''); 

    SELECT @columns


    --Tercer paso--

    DECLARE @columns AS VARCHAR(MAX)
    DECLARE @startDate AS VARCHAR(10) = '2011-06-01'
    DECLARE @endDate AS VARCHAR(10) = '2011-06-30'

    SELECT @columns = STUFF(
    (SELECT ',' + QUOTENAME(LTRIM(DAY([OrderDate])))
    FROM (SELECT DISTINCT [OrderDate]
        FROM [Sales].[SalesOrderHeader] AS [soh]
        WHERE [soh].[OrderDate] >= @startDate 
            AND [soh].[OrderDate] <= @endDate) AS [T]
    ORDER BY [OrderDate]
    FOR XML PATH('')
    ), 1, 1, ''); 

    SELECT @columns


    DECLARE @sql nvarchar(MAX)

    SET @sql = 
        'SELECT * FROM 
        (
        SELECT 
                DAY([soh].[OrderDate]) AS [SalesDaily]
                ,[soh].[TotalDue] AS [TotalSales]
        FROM [sales].[SalesOrderHeader] AS [soh]
        WHERE [soh].[OrderDate] >= '+  CHAR(39) + @startDate + CHAR(39) +' 
        AND [soh].[OrderDate]<= '  + CHAR(39) + @endDate + CHAR(39) + '
        ) AS [Sales]
            PIVOT (SUM([TotalSales])
            FOR [SalesDaily] IN (' + @columns + ')
        )
        AS [pvt]
    ';

    EXEC sp_executesql @sql