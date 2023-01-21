-- ======================================================
-- ================== SELECT DISTINCT ===================
-- ======================================================

/* NOTA: Tenga en cuenta que la opción DISTINCT sólo puede utilizarse una vez en una lista SELECT, 
         y debe preceder a todos los nombres de columna de esa lista. Por lo tanto, lo siguiente
		 es incorrecto:

                                SELECT emp_fname, DISTINCT emp_no
                                FROM employee
                                WHERE emp_lname = 'Moser'
    
   NOTA: Cuando hay más de una columna en la lista SELECT, la cláusula DISTINCT muestra todas 
         las filas en las que la combinación de columnas es distinta.


   A veces, puede que desee obtener sólo valores distintos en una columna específica de una tabla. 
   Para ello, utilice la cláusula SELECT DISTINCT como se indica a continuación:

                                    SELECT DISTINCT
                                        column_name
                                    FROM
                                        table_name;

   La consulta sólo devuelve valores distintos en la columna especificada. En otras palabras, 
   elimina los valores duplicados de la columna del conjunto de resultados.

   Si utiliza varias columnas como se indica a continuación:

                                    SELECT DISTINCT
                                        column_name1,
                                        column_name2 ,
                                        ...
                                    FROM
                                        table_name;

   La consulta utiliza la combinación de valores de todas las columnas especificadas en la lista 
   SELECT para evaluar la unicidad.

   Si aplica la cláusula DISTINCT a una columna que tiene NULL, la cláusula DISTINCT mantendrá sólo 
   un NULL y eliminará el otro. En otras palabras, la cláusula DISTINCT trata todos los "valores" 
   NULL como el mismo valor.   
   
   
   DISTINCT vs. GROUP BY
   =====================

   La siguiente sentencia utiliza la cláusula GROUP BY para devolver ciudades distintas junto con el 
   estado y el código postal de la tabla sales.customers:  */

SELECT 
    StoreID, 
    TerritoryID
FROM 
	Sales.Customer
GROUP BY 
	StoreID, TerritoryID
ORDER BY
	StoreID, TerritoryID

-- Es equivalente a la siguiente consulta que utiliza el operador DISTINCT :

SELECT DISTINCT
    StoreID, 
    TerritoryID
FROM 
	Sales.Customer

-- Tanto la cláusula DISTINCT como GROUP BY reducen el número de filas devueltas en el conjunto de 
-- resultados al eliminar los duplicados. Sin embargo, debe utilizar la cláusula GROUP BY cuando desee 
-- aplicar una función agregada a una o varias columnas.