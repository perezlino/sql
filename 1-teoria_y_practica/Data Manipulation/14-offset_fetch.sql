-- ======================================================
-- ================== OFFSET - FETCH ====================
-- ======================================================

/* Las cláusulas OFFSET y FETCH son las opciones de la cláusula ORDER BY. Permiten limitar el 
   número de filas que devuelve una consulta.

   A continuación se ilustra la sintaxis de las cláusulas OFFSET y FETCH:

                        ORDER BY column_list [ASC |DESC]
                        OFFSET offset_row_count {ROW | ROWS}
                        FETCH {FIRST | NEXT} fetch_row_count {ROW | ROWS} ONLY

   En esta sintaxis:

   La cláusula OFFSET especifica el número de filas a omitir antes de comenzar a devolver filas de la 
   consulta. El offset_row_count puede ser una constante, variable o parámetro que sea mayor o igual a cero.

   La cláusula FETCH especifica el número de filas a devolver una vez procesada la cláusula OFFSET. El 
   offset_row_count puede ser una constante, variable o escalar que sea mayor o igual a uno.

   La cláusula OFFSET es obligatoria, mientras que la cláusula FETCH es opcional. Además, FIRST y NEXT son 
   sinónimos respectivamente, por lo que puede utilizarlos indistintamente. Del mismo modo, puede utilizar 
   FIRST y NEXT indistintamente.

   A continuación se ilustran las cláusulas OFFSET y FETCH:

   |------|--------|
   |  ID  |  Name  |
   |------|--------|
   |  1   |Item #1 |  |
   |  2   |Item #2 |  | 
   |  3   |Item #3 |  |  OFFSET 5 ROWS
   |  4   |Item #4 |  |
   |  5   |Item #5 |  V
-----------------------
   |  6   |Item #6 |  ^
   |  7   |Item #7 |  |
   |  8   |Item #8 |  |
   |  9   |Item #9 |  |
   |  10  |Item #10|  |  FETCH NEXT 10 ROWS ONLY
   |  11  |Item #11|  | 
   |  12  |Item #12|  |
   |  13  |Item #13|  |
   |  14  |Item #14|  |
   |  15  |Item #15|  V
----------------------- 
   |  16  |Item #16| 
   |  17  |Item #17| 
   |  18  |Item #18| 
   |  19  |Item #19| 
   |  20  |Item #20|
   |------|--------| 

   Tenga en cuenta que debe utilizar las cláusulas OFFSET y FETCH con la cláusula ORDER BY. De lo contrario, 
   se producirá un error.

   Las cláusulas OFFSET y FETCH son preferibles para implementar la solución de paginación de consultas que 
   la cláusula TOP.

   Las cláusulas OFFSET y FETCH han estado disponibles desde SQL Server 2012 (11.x) y posteriores y Azure 
   SQL Database.

   =========================================================================================================

   Ejemplo 1

   Para omitir los 10 primeros productos y devolver el resto, se utiliza la cláusula OFFSET como se muestra 
   en la siguiente sentencia:   */

SELECT
    Name,
    ListPrice
FROM
    Production.Product
ORDER BY
    ListPrice,
    Name 
OFFSET 10 ROWS

-- =========================================================================================================

-- Ejemplo 2

-- Para omitir los 10 primeros productos y seleccionar los 10 siguientes, se utilizan las cláusulas OFFSET y 
-- FETCH de la siguiente manera:

SELECT
    Name,
    ListPrice
FROM
    Production.Product
ORDER BY
    ListPrice,
    Name 
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY

-- =========================================================================================================

-- Ejemplo 3

-- Para obtener los 10 productos más caros se utilizan las cláusulas OFFSET y FETCH:

SELECT
    Name,
    ListPrice
FROM
    Production.Product
ORDER BY
    ListPrice DESC,
    Name 
OFFSET 0 ROWS
FETCH NEXT 10 ROWS ONLY