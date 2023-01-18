-- ======================================================
-- ================= CONDICIONAL IF - ELSE ==============
-- ======================================================

USE AdventureWorks2019

-- Ejemplo 1
-- Duplicamos una tabla para realizarle modificaciones
SELECT *
INTO Person.Person2
FROM Person.Person

SELECT * FROM Person.Person2

DECLARE @Cant INT
SET @Cant = (SELECT SUM(CASE WHEN Title IS NULL THEN 1 ELSE 0 END) AS null_values
             FROM Person.Person)

IF @Cant >= 1000
	UPDATE Person.Person2
	SET Title = 'NULO'
	WHERE Title IS NULL

-- ============================================================================================
-- ============================================================================================
 
IF (SELECT COUNT(*) FROM Production.Product WHERE Name LIKE 'Touring-3000%' ) > 5  
    PRINT 'Hay más de 5 bicicletas Touring-3000.'  
ELSE 
    PRINT 'Hay 5 o menos bicicletas Touring-3000.'

-- ============================================================================================
-- ============================================================================================

/*
|------------------------------------------------------------------------------------------|
| BEGIN y END: los utilizamos cuando tenemos 2 o más sentencias dentro de un mismo bloque  |
|------------------------------------------------------------------------------------------| */

/* A continuación se muestra la sintaxis de la instrucción IF :

                                    IF boolean_expression   
                                    BEGIN
                                        { statement_block }
                                    END

En esta sintaxis, si la expresión booleana (<boolean_expression>) se evalúa como TRUE, se ejecuta 
el bloque de sentencia del bloque BEGIN...END. En caso contrario, el bloque <statement_block> se 
omite y el control del programa se pasa a la sentencia situada después de la palabra clave END.

Tenga en cuenta que, si la expresión booleana contiene una sentencia SELECT, debe encerrar la sentencia 
SELECT entre paréntesis.

*/

-- El siguiente ejemplo obtiene primero el importe de las ventas de la tabla sales.order_items de la 
-- base de datos de ejemplo y luego imprime un mensaje si el importe de las ventas es superior a 1 millón.

BEGIN
    -- Declaramos la variable
    DECLARE @sales INT

    -- Con esta consulta, le estamos asignando un valor a la variable @sales
    SELECT @sales = SUM(UnitPrice * OrderQty)
    FROM Sales.SalesOrderDetail s
    INNER JOIN Sales.SalesOrderHeader o 
    ON o.SalesOrderID = s.SalesOrderID
    WHERE YEAR(o.OrderDate) = 2014

    -- Ejecutamos la variable y visualizamos el valor captado en la consulta anterior
    SELECT @sales -- 20094830

    -- Ejecutamos el condicional IF. Si es TRUE se ejecuta el comando PRINT
    -- El print se muestra en 'Mensajes'
    IF @sales > 1000000
    BEGIN
        PRINT '¡Genial! El importe de las ventas en 2014 es superior a 1.000.000'
    END
END

-- ============================================================================================
-- ============================================================================================

/* La sentencia IF - ELSE

Cuando la condición de la cláusula IF se evalúa como FALSE y desea ejecutar otro bloque de sentencia, 
puede utilizar la cláusula ELSE.

A continuación se ilustra la sentencia IF ELSE:

                        IF Boolean_expression
                        BEGIN
                            -- Statement block executes when the Boolean expression is TRUE
                        END
                        ELSE
                        BEGIN
                            -- Statement block executes when the Boolean expression is FALSE
                        END

Cada sentencia IF tiene una condición. Si el resultado de la condición es TRUE, se ejecuta el bloque de 
instrucciones de la cláusula IF. Si la condición es FALSE, se ejecuta el bloque de código de la cláusula ELSE.

*/

BEGIN
    -- Declaramos la variable
    DECLARE @sales INT

    -- Con esta consulta, le estamos asignando un valor a la variable @sales
    SELECT @sales = SUM(UnitPrice * OrderQty)
    FROM Sales.SalesOrderDetail s
    INNER JOIN Sales.SalesOrderHeader o 
    ON o.SalesOrderID = s.SalesOrderID
    WHERE YEAR(o.OrderDate) = 2014

    -- Ejecutamos la variable y visualizamos el valor captado en la consulta anterior
    SELECT @sales -- 20094830

    -- Ejecutamos el condicional IF. Si es TRUE se ejecuta el comando PRINT
    -- El print se muestra en 'Mensajes'
    IF @sales > 25000000
    BEGIN
        PRINT '¡Genial! El importe de las ventas en 2014 es superior a 25.000.000'
    END
    ELSE
    BEGIN
        PRINT 'El importe de las ventas en 2014 no alcanzó los 25.000.000'
    END
END

-- ============================================================================================
-- ============================================================================================

DECLARE @AvgWeight DECIMAL(8,2), 
        @BikeCount INT  

IF (SELECT COUNT(*) FROM Production.Product WHERE Name LIKE 'Touring-3000%') > 5  
BEGIN  
   SET @BikeCount =   
        (SELECT COUNT(*)   
         FROM Production.Product   
         WHERE Name LIKE 'Touring-3000%')  
   SET @AvgWeight =   
        (SELECT AVG(Weight)   
         FROM Production.Product   
         WHERE Name LIKE 'Touring-3000%')  
   PRINT 'Hay ' + CAST(@BikeCount AS VARCHAR(3)) + ' bicicletas Touring-3000.'  
   PRINT 'El peso medio de las bicicletas Touring-3000 es de ' + CAST(@AvgWeight AS VARCHAR(8)) + '.' 
END  
ELSE   
BEGIN  
SET @AvgWeight =   
        (SELECT AVG(Weight)  
         FROM Production.Product   
         WHERE Name LIKE 'Touring-3000%' );  
   PRINT 'El peso medio de las bicicletas Touring-3000 es de ' + CAST(@AvgWeight AS VARCHAR(8)) + '.'   
END

-- ============================================================================================
-- ============================================================================================

-- Sentencias IF...ELSE anidadas

-- SQL Server le permite anidar una sentencia IF...ELSE dentro de otra sentencia IF...ELSE, vea 
-- el siguiente ejemplo:

BEGIN
    DECLARE @x INT = 10,
            @y INT = 20

    IF (@x > 0)
    BEGIN
        IF (@x < @y)
            PRINT 'x > 0 y x < y';
        ELSE
            PRINT 'x > 0 y x >= y';
    END			
END

-- ============================================================================================
-- ============================================================================================

-- Ejemplo

DECLARE @Number INT 
SET @Number = 50
IF @Number > 100  
   PRINT 'El número es grande.' 
ELSE   
   BEGIN  
      IF @Number < 10  
      PRINT 'El número es pequeño.'
   ELSE  
      PRINT 'El número es mediano.'
   END

-- ============================================================================================
-- ============================================================================================

-- Ejemplo

IF (SELECT COUNT(*) FROM Person.Person WHERE PersonType = 'EM') > 300
BEGIN
    PRINT 'El número de empleados de la empresa es mayor a 300 y son los siguientes:'

    SELECT BusinessEntityID, CONCAT_WS(' ',FirstName,LastName) AS Nombre_empleado
    FROM Person.Person
    WHERE PersonType = 'EM'
END   
ELSE 
BEGIN

    PRINT 'El número de empleados de la empresa es menor a 300 y son los siguientes:'
    
    SELECT BusinessEntityID, CONCAT_WS(' ',FirstName,LastName) AS Nombre_empleado
    FROM Person.Person
    WHERE PersonType = 'EM'
END