-- ======================================================
-- ================== STORED PROCEDURES =================
-- ======================================================

USE TiendaBicicletas

/*
    ================================================
    === CREACION DE UN STORED PROCEDURE SENCILLO ===
    ================================================

    La siguiente sentencia SELECT devuelve una lista de productos de la tabla products de la base 
    de datos de ejemplo BikeStores:  */

    SELECT 
        producto_nombre, 
        precio_catalogo
    FROM 
        Produccion.productos
    ORDER BY 
        producto_nombre

/*
    Para crear un stored procedure que envuelva esta consulta, se utiliza la sentencia CREATE PROCEDURE 
    de la siguiente manera:  */

    CREATE PROCEDURE uspProductList
    AS
    BEGIN
        SELECT 
            producto_nombre, 
            precio_catalogo
        FROM 
            Produccion.productos
        ORDER BY 
            producto_nombre
    END

    /* En esta sintaxis:

    - uspProductList es el nombre del stored procedure.

    - La palabra clave AS separa el encabezado y el cuerpo del stored procedure.

    - Si el stored procedure tiene una sentencia, las palabras clave BEGIN y END que rodean la sentencia son 
    opcionales. Sin embargo, es una buena práctica incluirlas para que el código sea claro.

    Ten en cuenta que, además de las palabras clave CREATE PROCEDURE, puedes utilizar las palabras 
    clave CREATE PROC para que la sentencia sea más corta.

/*
   ============================================================================================
   ============================================================================================

    ========================================
    === EJECUCION DE UN STORED PROCEDURE ===
    ========================================

    Para ejecutar un stored procedure, se utiliza la sentencia EXECUTE o EXEC seguida del nombre del 
    stored procedure:   

										EXECUTE sp_name

o

										EXEC sp_name

    donde "sp_name" es el nombre del stored procedure que desea ejecutar.

    Por ejemplo, para ejecutar el stored procedure uspProductList, utilice la siguiente sentencia:   */

    EXEC uspProductList

/*
   ============================================================================================
   ============================================================================================

   ===========================================
   === MODIFICACION DE UN STORED PROCEDURE ===
   ===========================================


    Para modificar un stored procedure existente, utilice la sentencia ALTER PROCEDURE.

    En primer lugar, abra el stored procedure para ver su contenido haciendo clic con el botón derecho del 
    ratón en el nombre del stored procedure y seleccionando el elemento de menú Modify.

    En segundo lugar, cambie el cuerpo del stored procedure ordenando los productos por precio_catalogo en lugar 
    de por product names:   */

    ALTER PROCEDURE uspProductList
        AS
        BEGIN
            SELECT 
                producto_nombre, 
                precio_catalogo
            FROM 
                Produccion.productos
            ORDER BY 
                precio_catalogo
        END

/*  Ahora, si ejecuta de nuevo el stored procedure, verá que los cambios surten efecto:   */

    EXEC uspProductList

/*
   ============================================================================================
   ============================================================================================

   ==========================================
   === ELIMINACION DE UN STORED PROCEDURE ===
   ==========================================


    Para eliminar un stored procedure, se utiliza la sentencia DROP PROCEDURE o DROP PROC:

                                        DROP PROCEDURE sp_name

    o

                                        DROP PROC sp_name
        
    o

                            DROP PROCEDURE IF EXISTS schema_name.sp_name

    donde sp_name es el nombre del stored procedure que desea eliminar.

    Por ejemplo, para eliminar el stored procedure uspProductList, ejecute la siguiente sentencia:  */


    DROP PROCEDURE IF EXISTS uspProductList 


/*  Otra forma de eliminarlo es la siguiente similar a la anterior es la siguiente:  */

    IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'uspProductList')
    DROP PROCEDURE uspProductList

    -- Segunda forma
    SELECT OBJECT_ID('uspProductList', 'P') IS NOT NULL
    DROP PROCEDURE uspProductList
/*       

    ============================================================================================
    ============================================================================================

    ==================
    === PARÁMETROS ===
    ==================

    Creación de un stored procedure con un parámetro
    ================================================

    La siguiente consulta devuelve una lista de productos de la tabla Products:  */

    SELECT 
        producto_nombre, 
        precio_catalogo
    FROM 
        Produccion.productos
    ORDER BY 
        precio_catalogo

-- Puede crear un stored procedure que envuelva esta consulta utilizando la sentencia CREATE PROCEDURE:

    CREATE PROCEDURE uspFindProducts
    AS
    BEGIN
        SELECT 
            producto_nombre, 
            precio_catalogo
        FROM 
            Produccion.productos
        ORDER BY 
            precio_catalogo
    END

--  Sin embargo, esta vez podemos añadir un parámetro al stored procedure para encontrar los productos 
--  cuyos precio_catalogo son mayores que un input price:

    ALTER PROCEDURE uspFindProducts(@min_list_price AS DECIMAL)
    AS
    BEGIN
        SELECT 
            producto_nombre, 
            precio_catalogo
        FROM 
            Produccion.productos
        WHERE
            precio_catalogo >= @min_list_price
        ORDER BY 
            precio_catalogo
    END

/*  En este ejemplo:

    - En primer lugar, añadimos un parámetro denominado @min_list_price al stored procedure uspFindProducts. 
      Cada parámetro debe comenzar con el signo @. Las palabras clave AS DECIMAL especifican el tipo de datos 
      del parámetro @min_list_price. El parámetro debe estar rodeado por los corchetes de apertura y cierre.

    - En segundo lugar, utilizamos el parámetro @min_list_price en la cláusula WHERE de la sentencia SELECT 
      para filtrar sólo los productos cuyos precio_catalogo son mayores o iguales que @min_list_price.

    ============================================================================================

    Sin embargo, esta vez podemos añadir un IF EXISTS, para comprobar primeramente si existen valores
    que satisfagan esta comparación. En el caso de que si ocurra, se ejecuta la consulta SELECT y en el
    caso contrario, no ocurrirá nada.   */

    ALTER PROCEDURE uspFindProducts(@min_list_price AS DECIMAL)
    AS
    BEGIN
        IF EXISTS (SELECT * FROM Produccion.productos 
                    WHERE precio_catalogo >= @min_list_price)
        BEGIN
            SELECT 
                producto_nombre, 
                precio_catalogo
            FROM 
                Produccion.productos
            WHERE
                precio_catalogo >= @min_list_price
            ORDER BY 
                precio_catalogo
        END
    END
/*

    ============================================================================================

    Podemos expandir a nuestra necesidad la lógica del stored procedure, como por ejemplo, ir agregando
    más IF (es solo un ejemplo de como ir agregando más IF, dado que la lógica no tiene sentido):  */

    ALTER PROCEDURE uspFindProducts(@min_list_price AS DECIMAL)
    AS
    BEGIN
        IF EXISTS (SELECT * FROM Produccion.productos 
                    WHERE precio_catalogo >= @min_list_price)
        BEGIN
            IF @min_list_price < 50
            BEGIN
                SELECT 
                    producto_nombre, 
                    precio_catalogo
                FROM 
                    Produccion.productos
                WHERE
                    precio_catalogo >= @min_list_price
                ORDER BY 
                    precio_catalogo
            END
            ELSE
            BEGIN
                SELECT 
                    producto_nombre, 
                    precio_catalogo
                FROM 
                    Produccion.productos
                WHERE
                    precio_catalogo >= @min_list_price
                ORDER BY 
                    precio_catalogo  
            END
        END
    END
/*

    Ejecución de un stored procedure con un parámetro
    =================================================

    Para ejecutar el stored procedure uspFindProducts, se le pasa un argumento de la siguiente forma:   */

    EXEC uspFindProducts 100

    -- El stored procedure devuelve todos los productos cuyos precio_catalogo son mayores o iguales que 100.

    -- Si cambia el argumento a 200, obtendrá un conjunto de resultados diferente:

    EXEC uspFindProducts 200


/*  Creación de un stored procedure con múltiples parámetros
    ========================================================

    Los stored procedures pueden tomar uno o más parámetros. Los parámetros están separados por comas.

    La siguiente sentencia modifica el stored procedure uspFindProducts añadiéndole un parámetro más 
    llamado @max_list_price:    */

    ALTER PROCEDURE uspFindProducts(
        @min_list_price AS DECIMAL
        ,@max_list_price AS DECIMAL
    )
    AS
    BEGIN
        SELECT 
            producto_nombre, 
            precio_catalogo
        FROM 
            Produccion.productos
        WHERE
            precio_catalogo >= @min_list_price AND
            precio_catalogo <= @max_list_price
        ORDER BY
            precio_catalogo
    END

--  Una vez que el stored procedure se ha modificado correctamente, puede ejecutarlo pasando dos 
--  argumentos, uno para @min_list_price y otro para @max_list_price:

    EXECUTE uspFindProducts 900, 1000
/*

    ============================================================================================

    A modo de ejemplo podemos añadir la sentencia WHILE a la lógica del stored procedure:  */

    ALTER PROCEDURE uspFindProducts(
        @min_list_price AS DECIMAL
        ,@max_list_price AS DECIMAL
    )
    AS
    BEGIN
        IF EXISTS (SELECT * FROM Produccion.productos 
                    WHERE precio_catalogo BETWEEN @min_list_price AND @max_list_price)
        BEGIN
            WHILE @min_list_price <= @max_list_price
            BEGIN
                SELECT 
                    producto_nombre, 
                    precio_catalogo
                FROM 
                    Produccion.productos
                WHERE
                    precio_catalogo = @min_list_price
                ORDER BY
                    precio_catalogo
                SET @min_list_price = @min_list_price + 1
            END
        END
    END

/* Lo que hará este stored procedure es deolvernos una consulta SELECT por cada precio, comenzando
   por el precio capturado en la variable @min_list_price. Luego el precio se irá incrementando en 1 
   hasta igualar el precio capturado en la variable @max_list_price.


   Uso de parámetros con nombre
   ============================

    En caso de que los stored procedures tengan múltiples parámetros, es mejor y más claro ejecutar los 
    stored procedures usando parámetros con nombre.

    Por ejemplo, la siguiente sentencia ejecuta el stored procedure uspFindProducts utilizando los 
    parámetros con nombre @min_list_price y @max_list_price:   */

    EXECUTE uspFindProducts 
        @min_list_price = 900, 
        @max_list_price = 1000

/*  El resultado del stored procedure es el mismo sin embargo la sentencia es más obvia.


    Creación de parámetros de texto
    ===============================

    La siguiente sentencia añade el parámetro @name como un parámetro de cadena de caracteres al stored 
    procedure:   */

    ALTER PROCEDURE uspFindProducts(
        @min_list_price AS DECIMAL,
        @max_list_price AS DECIMAL,
        @name AS VARCHAR(max)
    )
    AS
    BEGIN
        SELECT 
            producto_nombre, 
            precio_catalogo
        FROM 
            Produccion.productos
        WHERE
            precio_catalogo >= @min_list_price AND
            precio_catalogo <= @max_list_price AND
            producto_nombre LIKE '%' + @name + '%'
        ORDER BY
            precio_catalogo
    END

--  Una vez que el stored procedure ha sido modificado con éxito, puede ejecutarlo de la siguiente manera:

EXECUTE uspFindProducts 
    @min_list_price = 900, 
    @max_list_price = 1000,
    @name = 'Trek'
/*

    Creación de parámetros opcionales
    =================================

    Cuando ejecute el stored procedure uspFindProducts, debe pasar los tres argumentos correspondientes 
    a los tres parámetros.

    SQL Server le permite especificar valores predeterminados para los parámetros, de modo que cuando 
    llame a stored procedures, pueda omitir los parámetros con valores predeterminados.

    Consulte el siguiente stored procedure:   */

    ALTER PROCEDURE uspFindProducts(
        @min_list_price AS DECIMAL = 0,
        @max_list_price AS DECIMAL = 999999,
        @name AS VARCHAR(max)
    )
    AS
    BEGIN
        SELECT 
            producto_nombre, 
            precio_catalogo
        FROM 
            Produccion.productos
        WHERE
            precio_catalogo >= @min_list_price AND
            precio_catalogo <= @max_list_price AND
            producto_nombre LIKE '%' + @name + '%'
        ORDER BY
            precio_catalogo
    END
/*

    En este stored procedure, asignamos 0 como valor por defecto para el parámetro @min_list_price 
    y 999,999 como valor por defecto para el parámetro @max_list_price.

    Una vez compilado el stored procedure, puede ejecutarlo sin pasar los argumentos a los parámetros 
    @min_list_price y @max_list_price:  */

    EXECUTE uspFindProducts 
        @name = 'Trek'

/*  En este caso, el stored procedure utilizó 0 para el parámetro @min_list_price y 999,999 para el 
    parámetro @max_list_price cuando ejecutó la consulta.

    Los parámetros @min_list_price y @max_list_price se denominan parámetros opcionales.

    Por supuesto, también puede pasar los argumentos a los parámetros opcionales. Por ejemplo, la siguiente 
    sentencia devuelve todos los productos cuyos precio_catalogo sean mayores o iguales a 6.000 y los nombres 
    contengan la palabra Trek:   */

    EXECUTE uspFindProducts 
        @min_list_price = 6000,
        @name = 'Trek'


/*  Uso de NULL como valor predeterminado
    =====================================

    En el stored procedure 'uspFindProducts', utilizamos 999,999 como maximum list price por defecto. Esto no 
    es robusto porque en el futuro puede tener productos con precio_catalogo superiores a ese valor.

    Una técnica típica para evitar esto es utilizar NULL como valor por defecto para los parámetros:  */

    ALTER PROCEDURE uspFindProducts(
        @min_list_price AS DECIMAL = 0
        ,@max_list_price AS DECIMAL = NULL
        ,@name AS VARCHAR(max)
    )
    AS
    BEGIN
        SELECT 
            producto_nombre, 
            precio_catalogo
        FROM 
            Produccion.productos
        WHERE
            precio_catalogo >= @min_list_price AND
            (@max_list_price IS NULL OR precio_catalogo <= @max_list_price) AND
            producto_nombre LIKE '%' + @name + '%'
        ORDER BY
            precio_catalogo
    END

--  La siguiente sentencia ejecuta el stored procedure uspFindProducts para encontrar el producto cuyos 
--  precio_catalogo son mayores o iguales a 500 y los nombres contienen la palabra "Haro".

    EXECUTE uspFindProducts 
        @min_list_price = 500,
        @name = 'Haro'
/*

   ============================================================================================
   ============================================================================================

   =========================
   === PARÁMETROS OUTPUT ===
   =========================

   Creación de parámetros output
   =============================

   Para crear un parámetro output para un stored procedure, utilice la siguiente sintaxis:

                              parameter_name data_type OUTPUT


    Un stored procedure puede tener muchos parámetros output. Además, los parámetros output pueden ser 
    de cualquier tipo de datos válido, por ejemplo, integer, date y varying character (VARCHAR).

    Por ejemplo, el siguiente stored procedure encuentra productos por modelo_year y devuelve el número 
    de productos a través del parámetro output @product_count:   */

    CREATE PROCEDURE uspFindProductByModelYear (
        @modelo_year SMALLINT,
        @product_count INT OUTPUT
    ) AS
    BEGIN
        SELECT 
            producto_nombre, 
            precio_catalogo
        FROM 
            Produccion.productos
        WHERE
            ano_modelo = @modelo_year

        SELECT @product_count = @@ROWCOUNT
    END


/*  Llamada a stored procedures con parámetros output
    =================================================

    Para llamar a un stored procedure con parámetros output, sigue estos pasos:

    - Primero, declara variables para contener los valores devueltos por los parámetros output.

    - En segundo lugar, utilice estas variables en la llamada al stored procedure.

    Por ejemplo, la siguiente sentencia ejecuta el stored procedure uspFindProductByModel:  */

    DECLARE @count INT

    EXEC uspFindProductByModelYear
        @modelo_year = 2016,
        @product_count = @count OUTPUT

    SELECT @count AS 'Número de productos encontrados'


--  También puedes llamar al stored procedure uspFindProductByModelYear de la siguiente manera:

    DECLARE @count INT

    EXEC uspFindProductByModelYear 2016, @count OUTPUT

--  Tenga en cuenta que si olvida la palabra clave OUTPUT después de la variable @count, la variable 
--  @count será NULL. Por último, muestre el valor de la variable @count:

    SELECT @count AS 'Número de productos encontrados'


--  ============================================================================================
--  ============================================================================================

--  Ejemplo 1: Declaración de Variables - Parámetros

/*  1.- Se crea el Stored Procedure y se ejecuta
    2.- Se genera el EXEC para ejecutar el SP y luego se ejecuta
    3.- Realizamos una consulta para revisar si se cargaron o no los datos por medio del SP */

    CREATE PROCEDURE pr_insertarpersona(
        @idPersona VARCHAR(5),
        @nombre VARCHAR(20),
        @apellido VARCHAR(20),
        @edad TINYINT)
    AS
    BEGIN
        INSERT INTO Personas (IdPersona,Nombre,Apellido,Edad)
            VALUES (@idPersona,@nombre,@apellido,@edad)
    END


    EXEC pr_insertarpersona 'A06','Alfonso','Pérez',35

    SELECT * FROM Personas

--  ============================================================================================
--  ============================================================================================

--  Ejemplo 2A

    CREATE PROCEDURE pr_buscarpersona (@nombre VARCHAR(20))                                    
    AS
    BEGIN
            SELECT IdPersona,
                Nombre,
                Apellido,
                Edad 
            FROM Personas 
            WHERE Nombre LIKE '%' + @nombre + '%'
    END


    EXEC pr_buscarpersona 'Alfonso'

--  ============================================================================================
--  ============================================================================================

--  Ejemplo 2B

    USE AdventureWorks2019

    CREATE PROCEDURE HumanResources.uspFindEmployee (@BusinessEntityID VARCHAR(20))                                    
    AS
    BEGIN
        SET NOCOUNT ON
        SELECT 
            BusinessEntityID,
            NationalIDNumber,
            LoginID,
            JobTitle,
            HireDate 
        FROM HumanResources.Employee
            WHERE BusinessEntityID = @BusinessEntityID
    END


    EXEC HumanResources.uspFindEmployee 7

--  ============================================================================================
--  ============================================================================================

--  Ejemplo 3

    CREATE PROCEDURE calcularPromedio(
        @n1 DECIMAL(4,2),
        @n2 DECIMAL(4,2),
        @resu DECIMAL(4,2) OUTPUT)
    AS
    BEGIN
            SELECT @resu = (@n1 + @n2)/2
    END


    DECLARE @variableResultado DECIMAL(4,2)

    EXEC calcularPromedio 5, 6, @variableResultado OUTPUT

    SELECT @variableResultado AS Promedio

--  ============================================================================================
--  ============================================================================================

--  Ejemplo 4

/*  1.- Se crea el Stored Procedure y se ejecuta
    2.- Se genera el EXEC para ejecutar el SP y luego se ejecuta
    3.- Realizamos una consulta para revisar si se cargaron o no los datos por medio del SP */

    CREATE PROC restarEdad(
        @idPersona VARCHAR(5),
        @edad TINYINT)
    AS
    BEGIN
        UPDATE Personas 
        SET Edad = Edad - @edad
        WHERE IdPersona = @idPersona
    END


    EXEC restarEdad 'A06', 2

    SELECT * FROM Personas

--  ============================================================================================
--  ============================================================================================

/*  PARA TRAER EL CODIGO DE EL SP utilizamos SP_HELPTEXT */

    SP_HELPTEXT restarEdad


/*  Utilizamos el SP del "Segundo Ejemplo" para llamar a WITH RESULTS SETS con el cual podemos
    modificar el titulo de la columna y el tipo de datos */

    EXEC pr_buscarpersona 'Alfonso'
    WITH RESULT SETS
    (([PersonId] VARCHAR(5) NOT NULL,
    [Name] VARCHAR(20) NOT NULL,
    [LastName] VARCHAR(20) NOT NULL,
    [Age] TINYINT NOT NULL))

--  ============================================================================================
--  ============================================================================================

--  Ejemplo 5

    CREATE PROCEDURE test (
        @a DATETIME OUT, 
        @b DATETIME OUT)
    AS
    BEGIN
        SELECT @a = GETDATE() -- utilizar SELECT para asignar un valor
        SET @b = GETDATE()    -- utilizar SET para asignar un valor
    END


    DECLARE @x DATETIME,
            @y DATETIME

    EXEC test @x OUT, @y OUT

    SELECT @x AS 'Using SELECT', 
        @y AS 'Using SET'

--  ============================================================================================
--  ============================================================================================

--  Ejemplo 6

    CREATE PROCEDURE FindEmpCounts (
    @zero_count INT = 0 OUTPUT) 
    AS
    BEGIN
        DECLARE @v INT -- variable para almacenar el recuento de filas devueltas
        SELECT FirstName FROM Person.Person
        WHERE FirstName LIKE 'z%'
        SELECT @v = @@ROWCOUNT -- guardar el recuento de filas en una varible

        IF @v >= 1
        BEGIN
            SELECT @v AS 'Número de empleados'
        END
        ELSE
        BEGIN
            SELECT @zero_count AS 'Número de empleados'
        END
    END

    EXEC FindEmpCounts

--  ============================================================================================
--  ============================================================================================

--  Ejemplo 7

    CREATE PROCEDURE EmployeeGender
        @id INT,
        @gender VARCHAR(50) OUTPUT
    AS
    BEGIN
        SELECT @gender = [Gender] 
        FROM HumanResources.Employee 
        WHERE BusinessEntityID = @id
    END

    DECLARE	@emp_gender VARCHAR(50)

    EXEC  EmployeeGender 1, @emp_gender OUTPUT

    PRINT 'El género del empleado es ' + @emp_gender -- Se imprime un mensaje