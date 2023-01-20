-- ======================================================
-- ==================== CONDICIONAL IIF =================
-- ======================================================

/* La función IIF() acepta tres argumentos. Evalúa el primer argumento y devuelve el 
   segundo si el primero es verdadero; en caso contrario, devuelve el tercero.

A continuación se muestra la sintaxis de la función IIF():

                        IIF(boolean_expression, true_value, false_value)

En esta sintaxis:

- 'boolean_expression' : es una expresión a evaluar. Debe ser una expresión booleana válida, 
                       o la función producirá un error.

- 'true_value' : es el valor que se devuelve si la expresión booleana es verdadera.

- 'false_value' : es el valor que se devuelve si la expresión booleana es falsa.

De hecho, la función IIF() es la abreviatura de una expresión CASE:

                                CASE 
                                    WHEN boolean_expression 
                                        THEN true_value
                                    ELSE
                                        false_value
                                END

*/

-- Este ejemplo utiliza la función IIF() para comprobar si 10 < 20 y devuelve la cadena True:

SELECT 
    IIF(10 < 20, 'True', 'False') Resultado

-- ============================================================================================
-- ============================================================================================

-- Ejemplo de uso de la función IIF() de SQL Server con una columna de tabla

SELECT order_status, COUNT(SalesOrderID) order_count
FROM (SELECT    
    IIF(Status<= 2,'En espera', 
        IIF(Status=3, 'En proceso',
            IIF(Status=4, 'Rechazada',
                IIF(Status=5,'Completada','N/A')
            )
        )
    ) AS order_status, OrderDate, SalesOrderID
    FROM    
    Sales.SalesOrderHeader) AS m
WHERE 
    YEAR(OrderDate) = 2014
GROUP BY 
    order_status
    
-- ============================================================================================
-- ============================================================================================

-- Uso de la función IIF() de SQL Server con funciones de suma

-- Este ejemplo utiliza la función IIF() con la función SUM() para obtener el número de pedidos 
-- por 'status' de pedido en 2014.

SELECT    
    SUM(IIF(Status <= 2, 1, 0)) AS 'En espera', 
    SUM(IIF(Status = 3, 1, 0)) AS 'En proceso', 
    SUM(IIF(Status = 4, 1, 0)) AS 'Rechazada', 
    SUM(IIF(Status = 5, 1, 0)) AS 'Completada', 
    COUNT(*) AS Total
FROM    
    Sales.SalesOrderHeader
WHERE 
    YEAR(OrderDate) = 2014
