-- ======================================================
-- ===================== INTERSECT ======================
-- ======================================================

/* El INTERSECT de SQL Server combina conjuntos de resultados de dos o más consultas y 
   devuelve filas distintas (distinct rows) que son producidas por ambas consultas.

   A continuación se ilustra la sintaxis del INTERSECT de SQL Server:

                                    query_1
                                    INTERSECT
                                    query_2

   De forma similar al operador UNION, las consultas de la sintaxis anterior deben cumplir 
   las siguientes reglas:

   - Ambas consultas deben tener el mismo número y orden de columnas.
   - El tipo de datos de las columnas correspondientes debe ser el mismo o compatible.

   La siguiente imagen ilustra la operación INTERSECT:

      1        2
      2        3    --->     2
      3        4             3

      T1       T2       T1 INTERSECT T2

   En esta ilustración, tenemos dos conjuntos de resultados T1 y T2:

   - El conjunto de resultados T1 incluye 1, 2 y 3.
   - El conjunto de resultados T2 incluye 2, 3 y 4.

   La intersección de los conjuntos de resultados T1 y T2 devuelve las filas distintas que son 2 y 3.

   ==========================================================================================================

   INTERSECT y ORDER BY
   ====================

   Para ordenar el conjunto de resultados creado por el operador INTERSECT, añada la cláusula ORDER BY en la 
   última consulta:

                                            SELECT
                                                select_list
                                            FROM
                                                table_1
                                            INTERSECT
                                            SELECT
                                                select_list
                                            FROM
                                                table_2
                                            ORDER BY
                                                order_list
