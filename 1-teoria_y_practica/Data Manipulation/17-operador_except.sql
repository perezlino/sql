-- ======================================================
-- ====================== EXCEPT ========================
-- ======================================================

/* NOTA: Los tres operadores de conjunto discutidos en esta sección tienen diferentes prioridades 
         de evaluación: el operador INTERSECT tiene la prioridad más alta, EXCEPT es evaluado después, 
         y el operador UNION tiene la prioridad más baja. Si no presta atención a estas diferentes 
         prioridades, obtendrá resultados inesperados cuando utilice varios operadores de conjunto 
         juntos.


   El método EXCEPT de SQL Server compara los resultados de dos consultas y devuelve las filas distintas 
   de la primera consulta que no se obtienen con la segunda. En otras palabras, EXCEPT resta el resultado 
   de una consulta de otra.

   A continuación se muestra la sintaxis de SQL Server EXCEPT:

                                                query_1
                                                EXCEPT
                                                query_2

   A continuación se indican las reglas para combinar los conjuntos de resultados de dos consultas en la 
   sintaxis anterior:

   - El número y el orden de las columnas deben ser los mismos en ambas consultas.
   - Los tipos de datos de las columnas correspondientes deben ser iguales o compatibles.

   La siguiente imagen muestra la operación EXCEPT de los dos conjuntos de resultados T1 y T2:

      1        2
      2        3    --->     1
      3        4

      T1       T2       T1 EXCEPT T2

    
   En esta ilustración:

   - El conjunto de resultados T1 incluye 1, 2 y 3.
   - El conjunto de resultados T2 incluye 2, 3 y 4.

   El resultado de except de T1 y T2 es 1, que es la fila distinta del conjunto de resultados de T1 que no 
   aparece en el conjunto de resultados de T2.

   ==========================================================================================================

   EXCEPT y ORDER BY
   ================

   Para ordenar el conjunto de resultados creado por el operador EXCEPT, añada la cláusula ORDER BY en la 
   última consulta:

                                            SELECT
                                                select_list
                                            FROM
                                                table_1
                                            EXCEPT
                                            SELECT
                                                select_list
                                            FROM
                                                table_2
                                            ORDER BY
                                                order_list