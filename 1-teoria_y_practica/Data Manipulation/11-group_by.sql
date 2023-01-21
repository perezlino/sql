-- ======================================================
-- ===================== GROUP BY =======================
-- ======================================================

 /* NOTA: Existe una restricción en cuanto al uso de columnas en la cláusula GROUP BY. Cada 
    columna que aparece en la lista SELECT de la consulta debe aparecer también en la cláusula 
	GROUP BY. Esta restricción no se aplica a las constantes ni a las columnas que forman parte 
	de una función agregada.

    NOTA: Las funciones de agregación aparecen en la lista SELECT, que puede incluir una cláusula 
    GROUP BY. Si no hay cláusula GROUP BY en la sentencia SELECT, y la lista SELECT incluye al 
    menos una función de agregación, no se pueden incluir columnas simples en la lista SELECT 
    (salvo como argumentos de una función de agregación). Por lo tanto, el ejemplo siguiente 
    es erróneo:

                                    SELECT emp_lname, MIN(emp_no)
                                    FROM employee
    
    Forma correcta:

                                    SELECT emp_lname, MIN(emp_no)
                                    FROM employee
                                    GROUP BY emp_lname
    
    ===============================================================================================

    La cláusula GROUP BY permite ordenar las filas de una consulta en grupos. Los grupos están 
    determinados por las columnas que se especifican en la cláusula GROUP BY.

    A continuación se ilustra la sintaxis de la cláusula GROUP BY:

                                        SELECT
                                            select_list
                                        FROM
                                            table_name
                                        GROUP BY
                                            column_name1,
                                            column_name2 ,...;

    En esta consulta, la cláusula GROUP BY produjo un grupo para cada combinación de los valores de 
    las columnas enumeradas en la cláusula GROUP BY.

    Considere el siguiente ejemplo:   */

SELECT
    CustomerID,
    YEAR(OrderDate) order_date
FROM
    Sales.SalesOrderHeader
WHERE
    CustomerID IN (29825,29672)
ORDER BY
    CustomerID

 /* En este ejemplo, recuperamos el id de cliente y el año de pedido de los clientes con id de cliente 
    29825 y 29672.

    Como se puede ver claramente en la salida, el cliente con el id 29672 realizó un pedido en 2011, un
    pedido en 2012, tres pedidos en 2013 y un pedido en 2014. El cliente con id 29825 realizó tres pedidos 
    en 2011, cuatro pedidos en 2012, cuatro pedidos en 2013 y un pedido en 2014.

    Añadamos una cláusula GROUP BY a la consulta para ver el efecto:   */

SELECT
    CustomerID,
    YEAR(OrderDate) order_date
FROM
    Sales.SalesOrderHeader
WHERE
    CustomerID IN (29825,29672)
GROUP BY 
    CustomerID, YEAR(OrderDate)
ORDER BY
    CustomerID

 /* La cláusula GROUP BY ordenó las tres primeras filas en dos grupos y las tres filas siguientes en los 
    otros dos grupos con las combinaciones únicas del id de cliente y el año del pedido.

    Desde el punto de vista funcional, la cláusula GROUP BY de la consulta anterior produjo el mismo resultado 
    que la siguiente consulta que utiliza la cláusula DISTINCT:  */

SELECT DISTINCT
    CustomerID,
    YEAR(OrderDate) order_date
FROM
    Sales.SalesOrderHeader
WHERE
    CustomerID IN (29825,29672)
ORDER BY
    CustomerID

  /* ==========================================================================================================

    Cláusula GROUP BY de SQL Server y funciones de agregación
    =========================================================

    En la práctica, la cláusula GROUP BY se utiliza a menudo con funciones de agregación para generar informes 
    resumidos.

    Una función agregada realiza un cálculo en un grupo y devuelve un valor único por grupo. Por ejemplo, COUNT() 
    devuelve el número de filas de cada grupo. Otras funciones agregadas de uso común son SUM(), AVG() (media), 
    MIN() (mínimo), MAX() (máximo).

    La cláusula GROUP BY ordena las filas en grupos y una función agregada devuelve el resumen (recuento, mínimo, 
    máximo, media, suma, etc.) de cada grupo.
   
    Por ejemplo, la siguiente consulta devuelve el número de pedidos realizados por el cliente por año:   */  

SELECT
    CustomerID,
    YEAR(OrderDate) order_date,
    COUNT(CustomerID) order_count
FROM
    Sales.SalesOrderHeader
WHERE
    CustomerID IN (29825,29672)
GROUP BY 
    CustomerID, YEAR(OrderDate)
ORDER BY
    CustomerID

--  La siguiente sentencia devuelve los list prices mínimo y máximo de todos los productos con el modelo 2018 por 
--  marca:

SELECT
    MIN(ListPrice) Min_price,
    MAX(ListPrice) Max_price,
    YEAR(SellStartDate) SellStartYear
FROM
    Production.Product
GROUP BY 
    YEAR(SellStartDate)
ORDER BY
    SellStartYear

-- La siguiente consulta utiliza la función SUM() para obtener el valor neto de cada pedido:

SELECT
    SalesOrderID,
    SUM (
        OrderQty * UnitPrice * (1 - UnitPriceDiscount)
    ) net_value
FROM
    Sales.SalesOrderDetail
GROUP BY
    SalesOrderID