-- ======================================================
-- ==================== SELECT TOP ======================
-- ======================================================

/* La cláusula SELECT TOP permite limitar el número de filas o el porcentaje de filas devueltas 
   en el conjunto de resultados de una consulta.

   Dado que el orden de las filas almacenadas en una tabla no está especificado, la sentencia 
   SELECT TOP se utiliza siempre junto con la cláusula ORDER BY. Por lo tanto, el conjunto de 
   resultados se limita al primer número N de filas ordenadas.

   A continuación, se muestra la sintaxis de la cláusula TOP con la sentencia SELECT:

                                SELECT TOP (expression) [PERCENT]
                                    [WITH TIES]
                                FROM 
                                    table_name
                                ORDER BY 
                                    column_name
  
   En esta sintaxis, la sentencia SELECT puede tener otras cláusulas como WHERE, JOIN, HAVING y GROUP BY.

   expression
   ==========

   Después de la palabra clave TOP hay una expresión que especifica el número de filas que se devolverán. 
   La expresión se evalúa como un valor flotante si se utiliza PERCENT; de lo contrario, se convierte en 
   un valor BIGINT.

   PERCENT
   =======

   La palabra clave PERCENT indica que la consulta devuelve el primer porcentaje N de filas, donde N es el 
   resultado de la expresión.

   WITH TIES
   =========

   La opción WITH TIES permite devolver más filas con valores que coinciden con la última fila del conjunto 
   de resultados limitado. Tenga en cuenta que WITH TIES puede hacer que se devuelvan más filas de las que 
   especifique en la expresión.

   Por ejemplo, si desea devolver los productos más caros, puede utilizar TOP 1. Sin embargo, si dos o más 
   productos tienen los mismos precios que el producto más caro, se perderán los demás productos más caros 
   del conjunto de resultados.

   Para evitarlo, puede utilizar TOP 1 WITH TIES. Incluirá no sólo el primer producto caro, sino también el 
   segundo, y así sucesivamente.

   ========================================================================================================

   1) Utilizar TOP con un valor constante

   El siguiente ejemplo utiliza un valor constante para devolver los 10 productos más caros.   */

SELECT TOP 10
    Name,
    ListPrice
FROM
    Production.Product
ORDER BY
    ListPrice DESC

/* ========================================================================================================

   2) Utilizar TOP para devolver un porcentaje de filas

   El siguiente ejemplo utiliza PERCENT para especificar el número de productos devueltos en el conjunto de 
   resultados. La tabla Production.Products tiene 504 filas, por lo tanto, el uno por ciento de 504 es un 
   valor fraccionario (5.04), SQL Server lo redondea al siguiente número entero que es cuatro (6) en este caso. */

SELECT TOP 1 PERCENT
    Name,
    ListPrice
FROM
    Production.Product
ORDER BY
    ListPrice DESC

/* ========================================================================================================

   3) Utilizar TOP WITH TIES para incluir las filas que coinciden con los valores de la última fila

   La siguiente sentencia devuelve los tres productos más caros: */

SELECT TOP 3 
    Name,
    ListPrice
FROM
    Production.Product
ORDER BY
    ListPrice DESC

/*
Name	            ListPrice
Road-150 Red, 62	3578,27
Road-150 Red, 44	3578,27
Road-150 Red, 48	3578,27
*/

SELECT TOP 3 WITH TIES
    Name,
    ListPrice
FROM
    Production.Product
ORDER BY
    ListPrice DESC

/*
Name	            ListPrice  _
Road-150 Red, 62	3578,27     | 
Road-150 Red, 44	3578,27     | TOP 3
Road-150 Red, 48	3578,27    _|
Road-150 Red, 52	3578,27     | WITH TIES
Road-150 Red, 56	3578,27    _|
*/

-- En este ejemplo, el tercer producto más caro tiene un precio de lista de 3578,27. Como la sentencia 
-- utilizó TOP WITH TIES, devolvió dos productos más cuyos precios de lista son iguales que el tercero.