-- ======================================================
-- ====================== HAVING ========================
-- ======================================================

/*  NOTA: La cláusula HAVING define la condición que luego se aplica a los grupos de filas. Por lo 
          tanto, esta cláusula tiene el mismo significado para los grupos de filas que la cláusula 
	      WHERE para el contenido de la tabla correspondiente.

    NOTA: Se recomienda utilizarlo solo con las funciones de agregación. El HAVING actúa como un
          WHERE , pero solamente en las funciones de agregación.


La cláusula HAVING se utiliza a menudo con la cláusula GROUP BY para filtrar grupos basándose en una 
lista especificada de condiciones. A continuación se ilustra la sintaxis de la cláusula HAVING:

                                            SELECT
                                                select_list
                                            FROM
                                                table_name
                                            GROUP BY
                                                group_list
                                            HAVING
                                                conditions

En esta sintaxis, la cláusula GROUP BY resume las filas en grupos y la cláusula HAVING aplica una o más 
condiciones a estos grupos. Sólo se incluyen en el resultado los grupos para los que las condiciones se 
evalúan como TRUE. En otras palabras, los grupos para los que la condición se evalúa como FALSE o UNKNOWN 
se filtran.

Dado que SQL Server procesa la cláusula HAVING después de la cláusula GROUP BY, no se puede hacer referencia 
a la función agregada especificada en la lista de selección mediante el alias de columna. La siguiente 
consulta fallará:

                                    SELECT
                                        column_name1,
                                        column_name2,
                                        aggregate_function (column_name3) column_alias
                                    FROM
                                        table_name
                                    GROUP BY
                                        column_name1,
                                        column_name2
                                    HAVING
                                        column_alias > value

En su lugar, debe utilizar la expresión de la función agregada en la cláusula HAVING de forma explícita 
como se indica a continuación:

                                    SELECT
                                        column_name1,
                                        column_name2,
                                        aggregate_function (column_name3) alias
                                    FROM
                                        table_name
                                    GROUP BY
                                        column_name1,
                                        column_name2
                                    HAVING
                                        aggregate_function (column_name3) > value

========================================================================================================

Cláusula HAVING de SQL Server con la función COUNT
==================================================

La siguiente sentencia utiliza la cláusula HAVING para encontrar los clientes que han realizado al menos 
dos pedidos al año:   */

SELECT
    CustomerID,
    YEAR(OrderDate),
    COUNT(SalesOrderID) order_count
FROM
    Sales.SalesOrderHeader
GROUP BY
    CustomerID,
    YEAR(OrderDate)
HAVING
    COUNT(SalesOrderID) >= 11
ORDER BY
    CustomerID

/* =====================================================================================================

Cláusula HAVING de SQL Server con la función SUM()
==================================================

La siguiente sentencia busca los pedidos de cliente cuyos valores netos son superiores a 40.000:  */

SELECT
    SalesOrderID,
    SUM (
        OrderQty * UnitPrice * (1 - UnitPriceDiscount)
    ) valor_neto
FROM
    Sales.SalesOrderDetail
GROUP BY
    SalesOrderID
HAVING
    SUM (
        OrderQty * UnitPrice * (1 - UnitPriceDiscount)
    ) > 40000
ORDER BY
    valor_neto

/* =====================================================================================================

Cláusula HAVING de SQL Server con funciones MAX y MIN
=====================================================

La siguiente sentencia busca primero los list prices máximo y mínimo de cada categoría de producto. A 
continuación, filtra la subcategoria que tiene un list price máximo superior a 4.000 o un list price mínimo 
inferior a 500:  */

SELECT
    ProductSubcategoryID,
    MIN(ListPrice) Min_price,
    MAX(ListPrice) Max_price
FROM
    Production.Product
GROUP BY 
    ProductSubcategoryID
HAVING
    MAX(ListPrice) > 4000 OR MIN(ListPrice) < 500

/* =====================================================================================================

Cláusula HAVING de SQL Server con la función AVG()
==================================================

El siguiente enunciado encuentra subcategorías de productos cuyos list prices medios se sitúan entre 
500 y 1.000:  */

SELECT
    ProductSubcategoryID,
    AVG(ListPrice) avg_list_price
FROM
    Production.Product
GROUP BY
    ProductSubcategoryID
HAVING
    AVG(ListPrice) BETWEEN 500 AND 1000

-- =====================================================================================================

-- Ejemplo 1    

SELECT 
    TerritoryID,
    MIN(OrderDate) min_order_date,
    MAX(OrderDate) max_order_date
FROM 
    Sales.SalesOrderHeader
GROUP BY 
    TerritoryID
HAVING 
    MIN(OrderDate) >= '2011-06-01'

-- =====================================================================================================

-- Ejemplo 2

-- Selecciona aquellas ordenes que tengan una cantidad > 10 y que su promedio de precio unitario
-- sea mayor a 100.

SELECT 
    SalesOrderID,
    AVG(UnitPrice) Promedio_precio_unitario
FROM 
    Sales.SalesOrderDetail
WHERE 
    OrderQty > 10
GROUP BY 
    SalesOrderID
HAVING 
    AVG(UnitPrice) > 100