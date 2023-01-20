-- ======================================================
-- ====================== UNION =========================
-- ======================================================

/* NOTA: Dos tablas pueden conectarse con el operador UNION si son compatibles entre sí. Esto significa 
         que ambas listas SELECT deben tener el mismo número de columnas, y las columnas correspondientes
         deben tener tipos de datos compatibles. (Por ejemplo, INT y SMALLINT son tipos de datos 
         compatibles).
    
   NOTA: UNION nos devuelve la union de valores ÚNICOS (sin duplicados)

   NOTA: Los tres operadores de conjunto discutidos en esta sección tienen diferentes prioridades 
         de evaluación: el operador INTERSECT tiene la prioridad más alta, EXCEPT es evaluado después, 
         y el operador UNION tiene la prioridad más baja. Si no presta atención a estas diferentes 
         prioridades, obtendrá resultados inesperados cuando utilice varios operadores de conjunto 
         juntos.


   SQL Server UNION es una de las operaciones de conjunto que permiten combinar los resultados 
   de dos sentencias SELECT en un único conjunto de resultados que incluye todas las filas que 
   pertenecen a las sentencias SELECT de la unión.

   A continuación se ilustra la sintaxis de SQL Server UNION:

                                            query_1
                                            UNION
                                            query_2
    
   Los siguientes son requisitos para las consultas de la sintaxis anterior:

   - El número y el orden de las columnas deben ser los mismos en ambas consultas.
   - Los tipos de datos de las columnas correspondientes deben ser iguales o compatibles.

   ==========================================================================================================

   UNION vs UNION ALL
   ==================

   Por defecto, el operador UNION elimina todas las filas duplicadas de los conjuntos de resultados. 
   Sin embargo, si desea conservar las filas duplicadas, debe especificar la palabra clave ALL 
   explícitamente, como se muestra a continuación:

                                            query_1
                                            UNION ALL
                                            query_2

   En otras palabras, el operador UNION elimina las filas duplicadas, mientras que el operador UNION ALL 
   incluye las filas duplicadas en el conjunto de resultados final.

   ==========================================================================================================

   UNION vs. JOIN
   ==============

   Los join como INNER JOIN o LEFT JOIN combinan columnas de dos tablas mientras que UNION combina filas 
   de dos consultas.

   En otras palabras, join añade los conjuntos de resultados horizontalmente mientras que union añade el 
   conjunto de resultados verticalmente.

   La siguiente imagen ilustra la principal diferencia entre UNION y JOIN:

   |----|             |----|             |----|
   | ID |             | ID |             | ID |
   |----|             |----|             |----|
   | 1  |             | 2  |             | 1  |
   | 2  |    UNION    | 3  |    --->     | 2  |
   | 3  |             | 4  |             | 3  |
   |----|             |----|             | 4  |
-                                        |----|

   |----|             |----|             |----|----|
   | ID |             | ID |             | ID | ID |
   |----|             |----|             |----|----|
   | 1  |             | 2  |             | 2  | 2  |
   | 2  |    INNER    | 3  |    --->     | 3  | 3  |
   | 3  |    JOIN     | 4  |             |----|----|
   |----|             |----|             
-                                        
   ==========================================================================================================

   UNION y ORDER BY
   ================

   Para ordenar el conjunto de resultados devuelto por el operador UNION, coloque la cláusula ORDER BY en la 
   última consulta de la siguiente manera:

                                            SELECT
                                                select_list
                                            FROM
                                                table_1
                                            UNION
                                            SELECT
                                                select_list
                                            FROM
                                                table_2
                                            ORDER BY
                                                order_list

   ==========================================================================================================

   UNION , GROUP BY y HAVING
   =========================

   Las cláusulas GROUP BY y HAVING pueden utilizarse con las sentencias SELECT particulares, pero no con la 
   unión en sí. 

                                            SELECT 
                                                select_list
                                            FROM 
                                                table_1
                                            GROUP BY 
                                                column_name1,      <---
                                                column_name2 ,...; <---
                                            UNION ALL
                                            SELECT 
                                                select_list
                                            FROM 
                                                table_2
                                            GROUP BY 
                                                column_name1,      <---
                                                column_name2 ,...; <---
                                            ORDER BY 1