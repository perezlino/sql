-- ======================================================
-- ============== FUNCIONES DE AGREGACIÓN ===============
-- ======================================================

/* NOTA: Las funciones de agregación poseen de manera implicita la funcion de agrupación 

   NOTA: Las funciones de agregación aparecen en la lista SELECT, que puede incluir una cláusula 
         GROUP BY. Si no hay cláusula GROUP BY en la sentencia SELECT, y la lista SELECT incluye al 
         menos una función de agregación, no se pueden incluir columnas simples en la lista SELECT 
         (salvo como argumentos de una función de agregación) Por lo tanto, el ejemplo siguiente 
         es erróneo.  */

-- Forma errónea
USE sample
SELECT emp_lname, MIN(emp_no)
FROM employee

-- Forma correcta
USE sample
SELECT emp_lname, MIN(emp_no)
FROM employee
GROUP BY emp_lname


-- ============
-- === SUM ===
-- ============

/* La función SUM() de SQL Server es una función de agregación que calcula la suma de todos los valores 
   de una expresión.

   La sintaxis de la función SUM() es la siguiente:

                                   SUM([ALL | DISTINCT ] expression)

   En esta sintaxis:

   - ALL: indica a la función SUM() que devuelva la suma de todos los valores, incluidos los duplicados. 
          ALL se utiliza por defecto.

   - DISTINCT: indica a la función SUM() que calcule la suma de los únicos valores distintos.

   - expression: es cualquier expresión válida que devuelva un valor numérico exacto o aproximado. Tenga en cuenta que en la expresión no se aceptan funciones agregadas ni subconsultas.

   La función SUM() ignora los valores NULL.


   ALL vs. DISTINCT
   ================

   Vamos a crear una nueva tabla para demostrar la diferencia entre ALL y DISTINCT:  */

CREATE TABLE t(
    val INT
)

INSERT INTO t(val)
VALUES(1),(2),(3),(3),(4),(NULL),(5)

SELECT
    val
FROM
    t

--   |-----|             
--   | val |            
--   |-----|            
--   |  1  |          
--   |  2  |    
--   |  3  |
--   |  3  | 
--   |  4  |
--   |NULL |
--   |  5  |  
--   |-----|  

-- La siguiente sentencia devuelve la suma de todos los valores de la columna val:

SELECT
    SUM(val) total
FROM
    t

-- La salida es:

total
-----------
18
Warning: Null value is eliminated by an aggregate or other SET operation.

(1 row affected)


-- Sin embargo, cuando utilizamos el modificador DISTINCT, la función SUM() devuelve la suma sólo de 
-- los valores únicos de la columna val:

SELECT
    SUM(DISTINCT val) total
FROM
    t

-- La salida es:

total
-----------
15
Warning: Null value is eliminated by an aggregate or other SET operation.

(1 row affected)


/* Ejemplos de la función SUM() de SQL Server
   ==========================================

Veamos algunos ejemplos prácticos de uso de la función SUM().


        A) Ejemplo sencillo de la función SUM() de SQL Server
        =====================================================

        La siguiente sentencia devuelve las existencias totales de todos los productos en todos los 
        almacenes:  */

        SELECT 
            SUM(quantity) total_stocks
        FROM 
            Production.Stocks

    --  A continuación se muestra el resultado:

        total_stocks
        ------------
        13511

        (1 row affected)


    --  B) Función SUM() de SQL Server con ejemplo GROUP BY
    --  ===================================================

    --  La siguiente sentencia encuentra el total de existencias por id de tienda:

        SELECT
            store_id,
            SUM(quantity) store_stocks
        FROM
            Production.Stocks
        GROUP BY
            store_id

    --  Este es el resultado:

    --   |----------|--------------|             
    --   | store_id | store_stocks |           
    --   |----------|--------------|            
    --   |     1    |     4532     |       
    --   |     2    |     4359     |       
    --   |     3    |     4620     |     
    --   |----------|--------------| 

    /*  En este ejemplo:

        - En primer lugar, la cláusula GROUP BY divide las existencias por id de tienda en grupos.

        - En segundo lugar, se aplica la función SUM() a cada grupo para calcular las existencias 
          totales de cada uno.

        Si desea mostrar el nombre de la tienda en lugar del id de tienda, puede utilizar la siguiente 
        sentencia:  */

        SELECT
            store_name,
            SUM(quantity) store_stocks
        FROM
            Production.Stocks w
            INNER JOIN Sales.Stores s
                ON s.store_id = w.store_id
        GROUP BY
            store_name

    --  Este es el resultado:

    --   |--------------|--------------|             
    --   |  store_name  | store_stocks |           
    --   |--------------|--------------|            
    --   |Baldwin Bikes |     4532     |       
    --   |Rowlett Bikes |     4359     |       
    --   |Santos Bikes  |     4620     |     
    --   |--------------|--------------| 


    -- C) Ejemplo de función SUM() de SQL Server con cláusula HAVING
    -- =============================================================

    -- La siguiente sentencia busca las existencias de cada producto y devuelve sólo los productos cuyas 
    -- existencias sean superiores a 100:

        SELECT
            product_name,
            SUM(quantity) total_stocks
        FROM
            Production.Stocks s
            INNER JOIN Production.Products p
                ON p.product_id = s.product_id
        GROUP BY
            product_name
        HAVING
            SUM(quantity) > 100
        ORDER BY
            total_stocks DESC
        
    
    --  D) Ejemplo de función SUM() de SQL Server con expresión
    --  =======================================================

    --  El siguiente ejemplo utiliza una expresión en la función SUM() para calcular el valor neto de cada 
    -- pedido de cliente:

        SELECT
            order_id,
            SUM(
                quantity * list_price * (1 - discount)
            ) net_value
        FROM
            Sales.Order_items
        GROUP BY
            order_id
        ORDER BY
            net_value DESC

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 1: Sumar las cantidades pedidas de los distintos pedidos y ordenarlos de mayor a menor

SELECT 
	SalesOrderID, 
	SUM(OrderQty) AS OrderQty FROM Sales.SalesOrderDetail
GROUP BY 
	SalesOrderID
ORDER BY 
	OrderQty DESC

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 2:

SELECT 
	SalesOrderID,
	SUM((UnitPrice-UnitPriceDiscount)*OrderQty)'Ganancia'
FROM 
	Sales.SalesOrderDetail
GROUP BY 
	SalesOrderID


-- ============================================================================================
-- ============================================================================================

/* =============
   === COUNT ===
   =============

   SQL Server COUNT() es una función agregada que devuelve el número de elementos encontrados en 
   un conjunto.

   A continuación se muestra la sintaxis de la función COUNT():

                                COUNT([ALL | DISTINCT  ] expression)

   En esta sintaxis:

   - ALL: indica a la función COUNT() que se aplique a todos los valores. ALL es el valor por 
          defecto.

   - DISTINCT: indica a la función COUNT() que devuelva el número de valores únicos no nulos.

   - expression: es una expresión de cualquier tipo excepto image, text o ntext. Tenga en cuenta 
                 que no puede utilizar una subconsulta o una función agregada en la expresión.

   La función COUNT() tiene otra forma, como se indica a continuación:

                                               COUNT(*)


   En esta forma, COUNT(*) devuelve el número de filas de una tabla especificada. COUNT(*) no admite 
   DISTINCT y no toma parámetros. Cuenta cada fila por separado e incluye las filas que contienen 
   valores NULL.

   En resumen:

   - COUNT(*): cuenta el número de elementos de un conjunto. Incluye valores NULL y duplicados

   - COUNT(ALL expression): evalúa la expresión para cada fila de un conjunto y devuelve el número de 
                            valores no nulos.

   - COUNT(DISTINCT expression): evalúa la expresión para cada fila de un conjunto y devuelve el número 
                                 de valores únicos no nulos.


   Función COUNT() de SQL Server: ejemplos sencillos
   =================================================

   La siguiente sentencia crea una nueva tabla llamada t, inserta algunos datos en la tabla y consulta 
   datos contra ella:  */

CREATE TABLE t(
    val INT
)

INSERT INTO t(val)
VALUES(1),(2),(2),(3),(null),(null),(4),(5)

SELECT val FROM t

--   |-----|             
--   | val |            
--   |-----|            
--   |  1  |          
--   |  2  |    
--   |  2  |
--   |  3  | 
--   |NULL |
--   |NULL |
--   |  4  |
--   |  5  |  
--   |-----|  


-- Ejemplo de COUNT(*) de SQL Server
-- =================================

-- COUNT(*) devuelve todas las filas de una tabla especificada como se ilustra en la siguiente sentencia:

SELECT COUNT(*) val_count
FROM t

-- La salida es:

val_count
-----------
8

(1 row affected)


-- Ejemplo de expresión COUNT(DISTINCT) de SQL Server
-- ==================================================

-- El siguiente ejemplo utiliza la expresión COUNT(DISTINCT) para devolver el número de valores únicos no 
-- nulos de la tabla t:

SELECT
    COUNT(DISTINCT val) val_count
FROM
    t

-- A continuación se muestra el resultado:

val_count
-----------
5
Warning: Null value is eliminated by an aggregate or other SET operation.

(1 row affected)


-- Ejemplo de COUNT( expression ) de SQL Server
-- ============================================

-- El siguiente ejemplo utiliza COUNT(expression) para devolver el número de valores no nulos en la 
-- tabla t:

SELECT
    COUNT(val)
FROM
    t

-- A continuación se muestra el resultado:

val_count
-----------
6
Warning: Null value is eliminated by an aggregate or other SET operation.

(1 row affected)


-- Función COUNT() de SQL Server: ejemplos prácticos
-- =================================================

-- La siguiente sentencia devuelve el número de productos de la tabla Products:

SELECT 
    COUNT(*) product_count
FROM
    Production.Products

-- A continuación se muestra el resultado:

product_count
-------------
321

(1 row affected)


-- El siguiente ejemplo utiliza la función COUNT(*) para encontrar el número de productos cuyo año 
-- de modelo es 2016 y el list price es superior a 999,99:

SELECT 
   COUNT(*)
FROM 
    Production.Products
WHERE 
    model_year = 2016
    AND list_price > 999.99

-- A continuación se muestra el resultado:

Result
-----------
7

(1 row affected)


-- Ejemplo de SQL Server COUNT() con cláusula GROUP BY
-- ===================================================

-- La siguiente sentencia utiliza la función COUNT(*) para encontrar el número de productos en cada 
-- categoría de producto:

SELECT 
    category_name,
    COUNT(*) product_count
FROM
    Production.Products p
    INNER JOIN Production.Categories c 
    ON c.category_id = p.category_id
GROUP BY 
    category_name
ORDER BY
    product_count DESC

-- A continuación se muestra el resultado:

category_name        product_count
-------------------- -------------
Cruisers Bicycles    78
Mountain Bikes       60
Road Bikes           60
Children Bicycles    59
Comfort Bicycles     30
Electric Bikes       24
Cyclocross Bicycles  10

(7 rows affected)


-- En este ejemplo, en primer lugar, la cláusula GROUP BY divide los productos en grupos utilizando el nombre 
-- de la categoría y, a continuación, se aplica la función COUNT() a cada grupo.


-- Ejemplo de SQL Server COUNT() con clausula HAVING
-- =================================================

-- La siguiente sentencia devuelve la marca y el número de productos de cada una. Además, devuelve sólo las 
-- marcas que tienen un número de productos superior a 20:

SELECT 
    brand_name,
    COUNT(*) product_count
FROM
    Production.Products p
    INNER JOIN Production.Brands c 
    ON c.brand_id = p.brand_id
GROUP BY 
    brand_name
HAVING
    COUNT(*) > 20
ORDER BY
    product_count DESC

-- A continuación se muestra el resultado:

brand_name           product_count
-------------------- -------------
Trek                 135
Electra              118
Surly                25
Sun Bicycles         23

(4 rows affected)


-- ============================================================================================
-- ============================================================================================

-- Ejemplo 1: Contar todos los registros de la tabla

SELECT 
	COUNT(*) 
FROM 
	Sales.SalesOrderDetail


SELECT 
	COUNT(SalesOrderID) 
FROM 
	Sales.SalesOrderDetail

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 2: Contar todos los pedidos distintos

SELECT 
    COUNT(DISTINCT SalesOrderID) 
FROM 
    Sales.SalesOrderDetail

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 3: Contar el número de pedidos donde su pedido se ordeno una cantidad mayor a 10

SELECT 
	SalesOrderID, 
	COUNT(*) AS Cantidad_Pedidos 
FROM 
	Sales.SalesOrderDetail 
WHERE 
	OrderQty > 10
GROUP BY 
	SalesOrderID
ORDER BY 
	Cantidad_Pedidos DESC


-- ============================================================================================
-- ============================================================================================

/* ===========
   === AVG ===
   ===========

   La función AVG() de SQL Server es una función de agregación que devuelve el valor medio de un 
   grupo.

   A continuación se ilustra la sintaxis de la función AVG():

                                   AVG([ALL | DISTINCT] expression)


   En esta sintaxis:

   - ALL: indica a la función AVG() que tome todos los valores para el cálculo. ALL se utiliza por 
          defecto. 

   - DISTINCT: ordena a la función AVG() que opere sólo con valores únicos.

   - expression: es una expresión válida que devuelve un valor numérico. La función AVG() ignora 
                 los valores NULL.


   Función AVG() de SQL Server: ALL vs. DISTINCT
   =============================================

   Las siguientes sentencias crean una nueva tabla, insertan algunos valores en la tabla y consultan 
   datos en ella:   */

CREATE TABLE t(
    val dec(10,2)
)

INSERT INTO t(val) 
VALUES(1),(2),(3),(4),(4),(5),(5),(6);

SELECT
    val
FROM
    t

-- La siguiente sentencia utiliza la función AVG() para calcular la media de todos los valores de la 
-- tabla t:

SELECT
    AVG(ALL val)
FROM
    t

-- A continuación se muestra el resultado:

-- |---------|
-- | avg_all |
-- |---------|
-- |3.7500000|
-- |---------|

-- En este ejemplo, hemos utilizado el modificador ALL, por lo tanto, la función promedio considera los 
-- ocho valores de la columna val en el cálculo:

(1 + 2 + 3 + 4 + 4 + 5 + 5 + 6) /  8 = 3.75

-- La siguiente sentencia utiliza la función AVG() con el modificador DISTINCT:

SELECT
    AVG(DISTINCT val)
FROM
    t

-- A continuación se muestra el resultado:

-- |---------|
-- | avg_all |
-- |---------|
-- |3.5000000|
-- |---------|

-- Debido al modificador DISTINCT, la función AVG() realiza el cálculo sobre valores distintos:

(1 + 2 + 3 + 4 + 5 + 6) / 6 = 3.5


-- Ejemplos de la función AVG() de SQL Server
-- ==========================================

-- Tomemos algunos ejemplos para ver cómo funciona la función AVG().


-- A) Ejemplo sencillo de SQL Server AVG()
-- =======================================

-- El siguiente ejemplo devuelve el precio medio de lista de todos los productos:

SELECT
    AVG(list_price)
FROM
    Production.Products

-- En este ejemplo, la función AVG() devuelve un único valor para toda la tabla.

-- Este es el resultado:

-- |----------------|
-- | avg_list_price |
-- |----------------|
-- |   1520.591401  |
-- |----------------|


-- B) Ejemplo de SQL Server AVG() con GROUP BY
-- ===========================================

-- Si utiliza la función AVG() con una cláusula GROUP BY, la función AVG() devuelve un valor único 
-- para cada grupo en lugar de un valor único para toda la tabla.

-- El siguiente ejemplo devuelve el average list price para cada categoría de producto:

SELECT
    category_name,
    CAST(ROUND(AVG(list_price),2) AS DEC(10,2)) avg_product_price
FROM
    Production.Products p
    INNER JOIN Production.Categories c 
        ON c.category_id = p.category_id
GROUP BY
    category_name
ORDER BY
    category_name


-- C) Ejemplo de SQL Server AVG() en la cláusula HAVING
-- ====================================================

-- Véase el siguiente ejemplo:

SELECT
    brand_name,
    CAST(ROUND(AVG(list_price),2) AS DEC(10,2)) avg_product_price
FROM
    Production.Products p
    INNER JOIN Production.Brands c ON c.brand_id = p.brand_id
GROUP BY
    brand_name
HAVING
    AVG(list_price) > 500
ORDER BY
    avg_product_price

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 1: Promedio del precio unitario de los distintos pedido

SELECT 
	SalesOrderID, 
	AVG(UnitPrice) Promedio 
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
ORDER BY Promedio

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 2: Promedio del 10% del precio unitario de los distintos pedidos

SELECT 
	SalesOrderID, 
	AVG(UnitPrice * 0.10) Promedio 
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
ORDER BY Promedio


-- ============================================================================================
-- ============================================================================================

/* ===========
   === MAX ===
   ===========

   La función MAX() de SQL Server es una función agregada que devuelve el valor máximo de un 
   conjunto.

   A continuación se muestra la sintaxis de la función MAX():

                                        MAX(expression)

   La función MAX() acepta una expresión que puede ser una columna o una expresión válida.

   De forma similar a la función MIN(), la función MAX() ignora los valores NULL y considera todos 
   los valores en el cálculo.


   SQL Server MAX() - búsqueda del precio de lista más alto
   ========================================================

   La siguiente sentencia utiliza la función MAX() para encontrar el list price más alto de todos 
   los productos de la tabla Products:   */

SELECT
    MAX(list_price) max_list_price
FROM
    Production.Products

-- Este es el resultado:

-- |----------------|
-- | max_list_price |
-- |----------------|
-- |   11999.99     |
-- |----------------|

-- Para encontrar el producto con el list price más alto, se utiliza la siguiente sentencia:

SELECT 
    product_id,
    product_name,
    list_price
FROM 
    Production.Products
WHERE 
    list_price = (
        SELECT 
            MAX(list_price)
        FROM
            Production.Products)


-- Ejemplo de SQL Server MAX() con cláusula GROUP BY
-- ==================================================

-- La siguiente sentencia obtiene la marca y el list price más alto de los productos de cada marca:

SELECT
    brand_name,
    MAX(list_price) max_list_price
FROM
    Production.Products p
    INNER JOIN Production.Brands b
        ON b.brand_id = p.brand_id 
GROUP BY
    brand_name
ORDER BY
    brand_name


-- Ejemplo de SQL Server MAX() con cláusula HAVING
-- ===============================================

-- El siguiente ejemplo busca las marcas y el list price más alto de cada una. Además, utiliza la 
-- cláusula HAVING para filtrar todas las marcas cuyo list price más alto sea inferior o igual a 1.000:

SELECT
    brand_name,
    MAX(list_price) max_list_price
FROM
    Production.Products p
    INNER JOIN Production.Brands b
        ON b.brand_id = p.brand_id 
GROUP BY
    brand_name
HAVING 
    MAX(list_price) > 1000
ORDER BY
    max_list_price DESC

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 1: Obtener la mayor cantidad de productos pedidos por Orden de venta

SELECT 
	SalesOrderID, 
	MAX(OrderQty) Maxima_Cantidad 
FROM 
	Sales.SalesOrderDetail 
GROUP BY 
	SalesOrderID
ORDER BY 
	Maxima_Cantidad DESC

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 2: Obtener el nombre del empleado y el ID empleado que tenga el número ID mayor

SELECT 
    emp_no,
    emp_fname,
    emp_lname
FROM 
    employee
WHERE 
    emp_no = 
	        (SELECT MAX(emp_no) FROM employee)
GROUP BY 
    emp_no,
    emp_fname,
    emp_lname

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 3: Obtener el número de empleado que ingresó en la fecha más reciente

SELECT 
	emp_no,
	project_no,
	job,
	enter_date
FROM 
	works_on
WHERE 
	enter_date =
			(SELECT MAX(enter_date) FROM works_on)    

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 4: De la tabla Sales.CreditCard, se necesita mostrar la última fecha de modificación 
--            (Modified Date) por cada CardType, además del mes mínimo y año de expiración 
--            (ExpMonth,ExpYear)
   
SELECT 
    CardType,
    CONVERT(VARCHAR(10),MAX(ModifiedDate),105),
    MIN(ExpMonth),
    MIN(ExpYear)
FROM 
    Sales.CreditCard
GROUP BY 
    CardType


-- ============================================================================================
-- ============================================================================================

/* ===========
   === MIN ===
   ===========

   La función MIN() de SQL Server es una función agregada que permite hallar el valor mínimo de un 
   conjunto. A continuación se ilustra la sintaxis de la función MIN():

                                        MIN(expression)

   La función MIN() acepta una expresión que puede ser una columna o una expresión válida. La función 
   MIN() se aplica a todos los valores de un conjunto. Esto significa que el modificador DISTINCT no 
   tiene efecto para la función MIN().

   Tenga en cuenta que la función MIN() ignora los valores NULL.


   Ejemplo sencillo de la función MIN() de SQL Server
   ==================================================

   El siguiente ejemplo busca el list price más bajo de todos los productos:   */

SELECT
    MIN(list_price) min_list_price
FROM
    Production.Products

-- Este es el resultado:

-- |----------------|
-- | min_list_price |
-- |----------------|
-- |      89.99     |
-- |----------------|

-- Para encontrar el producto con el precio más bajo, utilice la siguiente consulta:

SELECT 
    product_id,
    product_name,
    list_price
FROM 
    Production.Products
WHERE 
    list_price = (
        SELECT 
            MIN(list_price)
        FROM
            Production.Products)


-- Ejemplo de función MIN() de SQL Server con cláusula GROUP BY
-- =============================================================

-- La siguiente sentencia busca el list price más bajo para cada categoría de producto:

SELECT
    category_name,
    MIN(list_price) min_list_price
FROM
    Production.Products p
    INNER JOIN Production.Categories c 
        ON c.category_id = p.category_id 
GROUP BY
    category_name
ORDER BY
    category_name


-- Ejemplo de SQL Server MIN() con clausula HAVING
-- ===============================================

-- El siguiente ejemplo utiliza la función MIN() en la cláusula HAVING para obtener la categoría 
-- de producto con el list price mínimo superior a 500.

SELECT
    category_name,
    MIN(list_price) min_list_price
FROM
    Production.Products p
    INNER JOIN Production.Categories c 
        ON c.category_id = p.category_id 
GROUP BY
    category_name
HAVING
    MIN(list_price) > 500
ORDER BY
    category_name