-- ======================================================
-- =================== OPERADOR ANY =====================
-- ======================================================

/* El operador ANY es un operador lógico que compara un valor escalar con un conjunto de valores 
   de una sola columna devueltos por una subconsulta.

   A continuación se muestra la sintaxis del operador ANY:

                   scalar_expression comparison_operator ANY (subquery)

   En esta sintaxis:

   - scalar_expression es cualquier expresión válida.

   - comparison_operator es cualquier operador de comparación.

   - subquery es una sentencia SELECT que devuelve un conjunto de resultados de una sola columna cuyos 
     datos son del mismo tipo que los de la expresión escalar.

   Supongamos que la subconsulta devuelve una lista de valores v1, v2, ..., vn. El operador ANY devuelve 
   TRUE si cualquier comparación (expresión_escalar, vi) devuelve TRUE. En caso contrario, devuelve FALSE.

   Tenga en cuenta que el operador SOME es equivalente al operador ANY.

   El siguiente ejemplo busca los productos que se vendieron con más de dos unidades en una orden de venta: */

SELECT
    product_name,
    list_price
FROM
    Production.Products
WHERE
    product_id = ANY (
        SELECT
            product_id
        FROM
           Sales.order_Items
        WHERE
            quantity >= 2
    )
ORDER BY
    product_name

-- Lo que sucede es lo siguiente:

-- Tenemos la columna product_id que se comparará con la subconsulta retornada por ANY: 

--                                 Conjunto de valores retornados por ANY                      
-- |------------|        de aquellos productos que se vendieron con más de dos unidades 
-- | product_id |                            en una orden de venta
-- |------------|
---|     1      |                                  product_id
---|     2      |
---|     3      |                                      2
---|     4      |                                      4
---|     5      |                                      5
---|     6      |                                      8
---|     7      |
---|     8      |
---|     9      |
---|     10     |
-- |------------|


/* Lo que prosigue es la comparación de la columna con valores escalares 'product_id' con los valores
   retornados por ANY:

1 = 2   2 = 2 (TRUE)  3 = 2   4 = 2
1 = 4   2 = 4         3 = 4   4 = 4 (TRUE)
1 = 5   2 = 5         3 = 5   4 = 5
1 = 8   2 = 8         3 = 8   4 = 8

Y asi sucesivamente con todos los id de productos ...