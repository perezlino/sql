-- ======================================================
-- ======================= CASE =========================
-- ======================================================

/* NOTA: CASE no representa una sentencia (como en la mayoría de los lenguajes de programación) 
         sino una expresión. Por lo tanto, la expresión CASE puede utilizarse (casi) en todos los 
	     casos en los que el lenguaje Transact-SQL permite el uso de una expresión.


   La expresión CASE de SQL Server evalúa una lista de condiciones y devuelve uno de los múltiples 
   resultados especificados. La expresión CASE tiene dos formatos expresión CASE simple (simple 
   CASE expression) y expresión CASE buscada (searched CASE expression). Ambos formatos de expresión 
   CASE admiten una sentencia ELSE opcional.

   Dado que CASE es una expresión, se puede utilizar en cualquier cláusula que acepte una expresión, 
   como SELECT, WHERE, GROUP BY y HAVING.

   
   Expresión CASE simple de SQL Server
   ===================================

   A continuación se muestra la sintaxis de la expresión CASE simple:

                                    CASE input   
                                        WHEN e1 THEN r1
                                        WHEN e2 THEN r2
                                        ...
                                        WHEN en THEN rn
                                        [ ELSE re ]   
                                    END
   
   La expresión CASE simple compara la expresión de entrada (input) con una expresión (ei) en cada cláusula 
   WHEN para comprobar la igualdad. Si la expresión de entrada (input expression) es igual a una expresión (ei) 
   en la cláusula WHEN, se devuelve el resultado (ri) en la cláusula THEN correspondiente.

   Si la expresión de entrada no es igual a ninguna expresión y la cláusula ELSE está disponible, la expresión 
   CASE devolverá el resultado en la cláusula ELSE (re).

   Si se omite la cláusula ELSE y la expresión de entrada no es igual a ninguna expresión de la cláusula WHEN, 
   la expresión CASE devolverá NULL.

   ===========================================================================================================

   A) Utilización de una expresión CASE simple en el ejemplo de cláusula SELECT    */

SELECT    
    CASE Status
        WHEN 1 THEN 'En espera'
        WHEN 2 THEN 'Solicitud enviada'
        WHEN 3 THEN 'En proceso'
        WHEN 4 THEN 'Rechazado'
        WHEN 5 THEN 'Completado'
    END AS order_status, 
    COUNT(SalesOrderID) order_count
FROM    
    Sales.SalesOrderHeader
WHERE 
    YEAR(OrderDate) = 2014
GROUP BY 
    Status

-- ===========================================================================================================

-- B) Creamos una nueva columna "Category" donde sus valores van a depender de los valores de 
--    la columna "ProductLine".

SELECT 
    ProductNumber, 
    Category =
            CASE ProductLine
                WHEN 'R' THEN 'Road'
                WHEN 'M' THEN 'Mountain'
                WHEN 'T' THEN 'Touring'
                WHEN 'S' THEN 'Other sale items'
                ELSE 'Not for sale'
            END,
        Name
FROM Production.Product

-- ===========================================================================================================

-- C) Lo mismo que el anterior, pero se coloco el nombre de la nueva columna junto a END

SELECT   
    ProductNumber,
    CASE ProductLine
         WHEN 'R' THEN 'Road'
         WHEN 'M' THEN 'Mountain'
         WHEN 'T' THEN 'Touring'
         WHEN 'S' THEN 'Other sale items'
         ELSE 'Not for sale'
      END Category,
	Name
FROM Production.Product

-- ===========================================================================================================

-- D) 

SELECT 
    ProductLine,
    Categoria =
            CASE
                WHEN ProductLine = 'M' THEN 'Montaña'
                WHEN ProductLine = 'R' THEN 'Carretera'
                WHEN ProductLine = 'T' THEN 'Turismo'
                WHEN ProductLine = 'S' THEN 'Otros'
                ELSE 'Sin Linea'
            END
FROM Production.Product

-- ===========================================================================================================

-- E)  Uso de CASE anidados:

SELECT 
    ProductLine,
    Class,
    Color,
    Categoria =
            CASE
                WHEN ProductLine = 'M' THEN 
                CASE 
                    WHEN Class = 'H' THEN 'Carretera'
                    WHEN Class = 'L' THEN 'Turismo'
                    WHEN Class = 'M' THEN 'Otros'
                    ELSE 'Sin Montaña'
                END
                WHEN ProductLine = 'R' THEN
                CASE	
                    WHEN Color = 'Black'  THEN 'Modelo Oscuridad'
                    WHEN Color = 'Silver' THEN 'Modelo Plateado'
                    WHEN Color = 'Yellow' THEN 'Modelo Radiante'
                    WHEN Color = 'Blue'   THEN 'Modelo Oceano'
                    ELSE 'Sin Modelo'
                END 
            ELSE 'Sin Linea'
            END
FROM Production.Product

-- ===========================================================================================================

-- F)  Contar los ProductID, categorizarlos y agruparlos:

SELECT
    COUNT(ProductID) product_count,
    CASE 
        WHEN Class = 'H' THEN 'Futbol'
        WHEN Class = 'L' THEN 'Basquetbol'
        WHEN Class = 'M' THEN 'Volleybol'
        ELSE 'Sin ningun deporte'
    END type_class
    FROM Production.Product
    GROUP BY
            CASE 
                WHEN Class = 'H' THEN 'Futbol'
                WHEN Class = 'L' THEN 'Basquetbol'
                WHEN Class = 'M' THEN 'Volleybol'
                ELSE 'Sin ningun deporte'
            END

-- ===========================================================================================================

-- G) Uso de una expresión CASE simple en un ejemplo de función agregada

-- Vea la siguiente consulta:  

SELECT    
    SUM(CASE
            WHEN Status = 1
            THEN 1
            ELSE 0
        END) AS 'En espera', 
    SUM(CASE
            WHEN Status = 2
            THEN 1
            ELSE 0
        END) AS 'Solicitud enviada', 
    SUM(CASE
            WHEN Status = 3
            THEN 1
            ELSE 0
        END) AS 'En proceso', 
    SUM(CASE
            WHEN Status = 4
            THEN 1
            ELSE 0
        END) AS 'Rechazado',
    SUM(CASE
            WHEN Status = 5
            THEN 1
            ELSE 0
        END) AS 'Completado', 
    COUNT(*) AS Total
FROM    
    Sales.SalesOrderHeader
WHERE 
    YEAR(OrderDate) = 2011

-- ===========================================================================================================

-- H) 

SELECT 
    SalesOrderID,
    YEAR(OrderDate),
    TotalDue,
    CASE
      WHEN TotalDue > 0 AND TotalDue < 1000  THEN 'Bajo'
      WHEN TotalDue >= 1000 AND TotalDue < 5000  THEN 'Regular'
      WHEN TotalDue >= 5000 AND TotalDue <= 10000  THEN 'Bueno'
      WHEN TotalDue > 10000 THEN 'Excelente'
      ELSE 'Nulo'
    END Peso_Venta
  FROM Sales.SalesOrderHeader

  -- ===========================================================================================================

-- I) 

SELECT
    SalesOrderID,
    YEAR(OrderDate) OrderYear,
    TotalDue,
	CASE
	  WHEN so.TotalDue < (SELECT AVG(sh.TotalDue) FROM Sales.SalesOrderHeader sh)
		THEN 'Bajo el promedio'
      WHEN so.TotalDue = (SELECT AVG(sh.TotalDue) FROM Sales.SalesOrderHeader sh)
		THEN 'Promedio'
	  WHEN so.TotalDue > (SELECT AVG(sh.TotalDue) FROM Sales.SalesOrderHeader sh)
		THEN 'Sobre el promedio'
    END categoria_promedio
FROM 
    Sales.SalesOrderHeader so
ORDER BY
    TotalDue DESC


/* ===========================================================================================================
   ===========================================================================================================

   Expresión CASE buscada en SQL Server (searched CASE expression)
   ===============================================================

   A continuación se muestra la sintaxis de la expresión CASE buscada:

                                    CASE  
                                        WHEN e1 THEN r1
                                        WHEN e2 THEN r2
                                        ...
                                        WHEN en THEN rn
                                        [ ELSE re ]   
                                    END 

   En esta sintaxis:

   e1, e2, ...ei, ... en son expresiones booleanas.
   r1, r2, ...ri,..., o rn es uno de los posibles resultados.

   La expresión CASE buscada evalúa la expresión booleana en cada cláusula WHEN en el orden especificado 
   y devuelve el resultado (ri) si la expresión booleana (ei) se evalúa como TRUE.

   Si ninguna expresión booleana se evalúa como TRUE, la expresión CASE buscada devuelve el resultado (re) 
   en la cláusula ELSE o NULL si no se especifica la cláusula ELSE.          */

SELECT    
    SalesOrderID, 
    SUM(OrderQty * UnitPrice) order_value,
    CASE
        WHEN SUM(OrderQty * UnitPrice) <= 500 
            THEN 'Very Low'
        WHEN SUM(OrderQty * UnitPrice) > 500 AND 
            SUM(OrderQty * UnitPrice) <= 1000 
            THEN 'Low'
        WHEN SUM(OrderQty * UnitPrice) > 1000 AND 
            SUM(OrderQty * UnitPrice) <= 5000 
            THEN 'Medium'
        WHEN SUM(OrderQty * UnitPrice) > 5000 AND 
            SUM(OrderQty * UnitPrice) <= 10000 
            THEN 'High'
        WHEN SUM(OrderQty * UnitPrice) > 10000 
            THEN 'Very High'
    END order_priority
FROM    
    Sales.SalesOrderDetail
GROUP BY 
    SalesOrderID

/* ===========================================================================================================
   ===========================================================================================================

   Utilizando CASE para actualizar datos
   =====================================

   Ejemplo con UPDATE

   Si es 0: Bajo, si es 1: Medio, si es 2: Alto */

UPDATE Person.Person
SET AdditionalContactInfo =
	CASE
		WHEN EmailPromotion = 1 THEN 'Medio'
		WHEN EmailPromotion = 2 THEN 'Alto'
		ELSE 'Bajo'
	END  