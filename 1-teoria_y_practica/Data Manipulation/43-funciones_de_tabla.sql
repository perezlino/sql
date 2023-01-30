-- ======================================================
-- ================== FUNCIÓN DE TABLA ==================
-- ======================================================

    /* ¿Qué es una función con valor de tabla en SQL Server?

    Una función con valor de tabla es una función definida por el usuario que devuelve datos de 
    tipo tabla. El tipo de retorno de una función con valor de tabla es una tabla, por lo tanto, 
    puede usar la función con valor de tabla igual que usaría una tabla.


    Creación de una función con valor de tabla
    ==========================================

    El siguiente ejemplo de sentencia crea una función table-valued que devuelve una lista de 
    productos incluyendo el nombre del producto, el año del modelo y el precio catalogo para un año modelo 
    específico:     */

    CREATE FUNCTION udfProductInYear (
        @ano_modelo INT
    )
    RETURNS TABLE
    AS
    RETURN
        SELECT 
            producto_nombre,
            ano_modelo,
            precio_catalogo
        FROM
            Produccion.productos
        WHERE
            ano_modelo = @ano_modelo

/* La sintaxis es similar a la que crea una función definida por el usuario.

   El RETURNS TABLE especifica que la función devolverá una tabla. Como puede ver, no hay sentencia 
   BEGIN...END. La sentencia simplemente consulta los datos de la tabla Produccion.productos.

   La función udfProductInYear acepta un parámetro llamado @ano_modelo de tipo INT. Devuelve los 
   productos cuyo model year es igual al parámetro @ano_modelo.

   La función anterior devuelve el conjunto de resultados de una única sentencia SELECT, por lo que 
   también se conoce como función con valores de tabla en línea (inline table-valued function).


    Ejecución de una función con valor de tabla
    ===========================================

    Para ejecutar una función con valor de tabla, utilícela en la cláusula FROM de la sentencia SELECT: */

    SELECT * 
    FROM udfProductInYear(2017)

/*  En este ejemplo, seleccionamos los productos cuyo ano_modelo es 2017.

    También puede especificar qué columnas se devolverán de la función de valores de tabla de la siguiente 
    manera:  */

    SELECT 
        producto_nombre,
        precio_catalogo
    FROM 
        udfProductInYear(2018)
/*

    Modificación de una función con valor de tabla
    ==============================================

    Para modificar una función con valores de tabla, utilice la palabra clave ALTER en lugar de CREATE. 
    El resto del script es el mismo.

    Por ejemplo, la siguiente sentencia modifica udfProductInYear cambiando el parámetro existente y 
    añadiendo un parámetro más:  */

    ALTER FUNCTION udfProductInYear (
        @start_year INT,
        @end_year INT
    )
    RETURNS TABLE
    AS
    RETURN
        SELECT 
            producto_nombre,
            ano_modelo,
            precio_catalogo
        FROM
            Produccion.productos
        WHERE
            ano_modelo BETWEEN @start_year AND @end_year

/*  La función udfProductInYear devuelve ahora los productos cuyo ano_modelo se encuentra entre un año 
    inicial y un año final.

    La siguiente sentencia llama a la función udfProductInYear para obtener los productos cuyos ano_modelo 
    están entre 2017 y 2018:  */

    SELECT 
        producto_nombre,
        ano_modelo,
        precio_catalogo
    FROM 
        udfProductInYear(2017,2018)
    ORDER BY
        producto_nombre


/*  Funciones multienunciado con valor de tabla (MSTVF)
    ===================================================

    Una función con valores de tabla de varias sentencias o MSTVF es una función con valores de tabla que 
    devuelve el resultado de varias sentencias.

    Esta función es muy útil porque permite ejecutar varias consultas dentro de la función y agregar los 
    resultados en la tabla devuelta.

    Para definir una función con valores de tabla de varias sentencias, se utiliza una variable de tabla 
    como return value. Dentro de la función, ejecute una o más consultas e inserte datos en esta variable 
    de tabla.

    La siguiente función udfContactos() combina empleados y clientes en una única lista de contactos:   */

    CREATE FUNCTION udfContactos()
    RETURNS @contactos TABLE (
        nombre VARCHAR(50),
        apellido VARCHAR(50),
        email VARCHAR(255),
        telefono VARCHAR(25),
        tipo_contacto VARCHAR(20)
    )
    AS
    BEGIN
        INSERT INTO @contactos
        SELECT 
            nombre, 
            apellido, 
            email, 
            telefono,
            'personal'
        FROM
            Ventas.personal

        INSERT INTO @contactos
        SELECT 
            nombre, 
            apellido, 
            email, 
            telefono,
            'cliente'
        FROM
            Ventas.clientes
        RETURN
    END
/*

    La siguiente sentencia ilustra cómo ejecutar una función multi-sentencia con valores de tabla udfContactos: */

    SELECT * 
    FROM udfContactos()

/* 
   |----------|---------|--------------------------|-------------|--------------|
   |  nombre  |apellido |           email          |   telefono  | tipo_contacto|
   |----------|---------|--------------------------|-------------|--------------|   
   |Fabiola   |Jackson  |fabiola.jackson@bikes.shop|(831)555-5554|   personal   |
   |Mireya    |Copeland |mireya.copeland@bikes.shop|(831)555-5555|   personal   |
   |   ...    |  ...    |                          |             |              |
   |          |         |                          |             |              |
   |Debra     |Bruks    |debra.bruks@yahoo.com     |NULL         |   cliente    |
   |   ...    |  ...    |                          |             |              |
   |----------|---------|--------------------------|-------------|--------------|

    ============================================================================================
    ============================================================================================

    Ejemplo 1

    Implementar una función de tabla en línea (inline table-valued function) que muestre los 
    registros de la tabla "Sales.SalesTerritory" dependiendo del CountryRegionCode al que pertenezca.  */

    CREATE FUNCTION udfTerritoryCode(
        @countrycode AS VARCHAR(30)
    )
    RETURNS TABLE
    AS
    RETURN 
            SELECT *
            FROM Sales.SalesTerritory
            WHERE CountryRegionCode = @countrycode

    SELECT * FROM dbo.udfTerritoryCode('US')