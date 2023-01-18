-- ============================================================
-- ============== SUBCONSULTAS - TABLAS DERIVADAS =============
-- ============================================================

-------------------------------------------
-- IMPORTANTE RECORDAR !!!!!!!!!!!!!!!!!!!:
-------------------------------------------

-- GROUP BY ----> Se procesa antes que SELECT

-- FROM ----> Se procesa antes que SELECT y que GROUP BY

-- NO podemos usar un ALIAS en la cláusula WHERE. Solo puede usar alias en una cláusula ORDER BY.

-- Las tablas derivadas tampoco pueden tener una cláusula ORDER BY. La consulta externa puede, pero la 
-- consulta interna no.

-- La cláusula ORDER BY no es válida en vistas, funciones inline, tablas derivadas, subconsultas y 
-- expresiones de tabla comunes, a menos que también se especifique TOP, OFFSET o FOR XML.

/*|-----------------------------------------------------------------------------------------| 
  | Hay dos tipos de Expresiones de tabla:                                                  |
  |                                                                                         |
  | Las expresiones de tabla son subconsultas que se utilizan cuando se espera una tabla.   |
  | Hay dos tipos de expresiones de tabla:                                                  |
  |                                                                                         |
  |   - Tablas derivadas                                                                    |
  |   - Expresiones de tabla comunes                                                        |
  |-----------------------------------------------------------------------------------------| */

/*|-----------------------------------------------------------------------------------------|
  | TABLA DERIVADA: Una tabla derivada es una expresión de tabla que aparece en la cláusula |
  |                 FROM de una consulta. Puede aplicar tablas derivadas cuando el uso de   |
  |                 alias de columna no es posible porque el traductor SQL procesa otra     |
  |                 cláusula antes de conocer el nombre del alias.                          | 
  |-----------------------------------------------------------------------------------------|*/

USE AdventureWorks2019

-- Obtener todos los grupos de meses existentes de la columna HireDate de la tabla [HumanResources].[Employee]

--Forma incorrecta--
/* El motivo del mensaje de error es que la cláusula GROUP BY se procesa antes que la lista 
   SELECT correspondiente, y el nombre del alias 'Hire_month' no se conoce en el momento en que 
   se procesa la agrupación. */

SELECT MONTH(HireDate) AS 'Hire_month' FROM HumanResources.Employee
GROUP BY Hire_month

--Forma correcta--
/* Utilizando una tabla derivada que contenga la consulta anterior (sin la cláusula GROUP BY), 
   se puede resolver este problema, ya que la cláusula FROM se ejecuta antes que la cláusula 
   GROUP BY */

SELECT Hire_month
FROM (SELECT MONTH(HireDate) AS 'Hire_month' FROM HumanResources.Employee) AS m
GROUP BY Hire_month

-- ============================================================================================
-- ============================================================================================

-- Son 504 productos en total los que estan registrados en Production.Product
-- Y son 266 los productos que estan registrados como vendidos en Sales.SalesOrderDetail

-- Se desea obtener las unidades de cantidad vendida (OrderQty) por cada producto. (Devuelve 
-- 266 Filas)
SELECT p.Name, SUM(od.OrderQty) AS Cantidad
FROM Production.Product p
INNER JOIN Sales.SalesOrderDetail od
ON od.ProductID = p.ProductID
GROUP BY p.Name

--Similar a lo anterior pero utilizando TABLA DERIVADA (Devuelve 504 filas)
SELECT p.ProductID, p.Name, (SELECT SUM(OrderQty) FROM Sales.SalesOrderDetail od  
                              WHERE od.ProductID = p.ProductID) AS Cantidad
FROM Production.Product p

-- ============================================================================================
-- ============================================================================================

-- Recuperar información sobre los pedidos realizados por los clientes por distintos año.

SELECT Order_year, COUNT(DISTINCT CustomerID) AS Conteo_clientes
FROM (SELECT YEAR(OrderDate) AS Order_year, CustomerID FROM Sales.SalesOrderHeader) AS derived_year
GROUP BY Order_year
ORDER BY Order_year

-- ============================================================================================
-- ============================================================================================

-- Deseamos saber la cantidad de órdenes que despachan según la posición de los empleados y que 
-- cantidad y porcentaje vende cada empleado de manera individual.

--Cantidad de ventas por posición (cargo)
SELECT e.JobTitle AS Posicion, COUNT(so.SalesOrderID) AS Cantidad_por_posicion
FROM HumanResources.Employee AS e
INNER JOIN Sales.SalesOrderHeader AS so
ON e.BusinessEntityID = so.SalesPersonID
GROUP BY e.JobTitle

--Cantidad de ventas por empleado
SELECT pp.FirstName + ' ' + pp.LastName AS Nombre, e.JobTitle AS Posicion,
       COUNT(so.SalesOrderID) AS Cantidad_por_empleado
FROM HumanResources.Employee AS e
INNER JOIN Sales.SalesOrderHeader AS so
ON e.BusinessEntityID = so.SalesPersonID
INNER JOIN Person.Person AS pp
ON so.SalesPersonID = pp.BusinessEntityID
GROUP BY pp.FirstName, pp.LastName, e.JobTitle

--
SELECT Nombre, VentasPosicion.Posicion, VentasEmpleados.Cantidad_por_empleado, VentasPosicion.Cantidad_por_posicion,
CAST(100.00 * VentasEmpleados.Cantidad_por_empleado / VentasPosicion.Cantidad_por_posicion AS decimal(18,2)) AS PorcientoVentaEmpleado
FROM
      --Cantidad de ventas por posición (cargo)
      (SELECT e.JobTitle AS Posicion, COUNT(so.SalesOrderID) AS Cantidad_por_posicion
       FROM HumanResources.Employee AS e
       INNER JOIN Sales.SalesOrderHeader AS so
       ON e.BusinessEntityID = so.SalesPersonID
       GROUP BY e.JobTitle) AS VentasPosicion

       INNER JOIN

      --Cantidad de ventas por empleado
      (SELECT pp.FirstName + ' ' + pp.LastName AS Nombre, e.JobTitle AS Posicion,
       COUNT(so.SalesOrderID) AS Cantidad_por_empleado
       FROM HumanResources.Employee AS e
       INNER JOIN Sales.SalesOrderHeader AS so
       ON e.BusinessEntityID = so.SalesPersonID
       INNER JOIN Person.Person AS pp
       ON so.SalesPersonID = pp.BusinessEntityID
       GROUP BY pp.FirstName, pp.LastName, e.JobTitle) AS VentasEmpleados

       ON VentasEmpleados.Posicion = VentasPosicion.Posicion

ORDER BY VentasPosicion.Posicion

-- Para probar este INNER JOIN cree dos Vistas:
/* SELECT * FROM VentasPosicion vp
   INNER JOIN VentasEmpleados ve
   ON vp.Posicion = ve.Posicion */

-- ============================================================================================
-- ============================================================================================

-- Pensemos en la siguiente instrucción SELECT (que aún no usa una tabla derivada):
/* Básicamente, cada fila nos dice la siguiente información:

- El OrderID del pedido
- CustomerID del Cliente que compró el producto
- El producto que compraron
- El precio de venta del pedido, que es el precio del producto multiplicado por cuántos compraron.
- La fecha en que se realizó el pedido */

SELECT so.SalesOrderID, sh.CustomerID, pr.Name, so.OrderQty*so.UnitPrice AS Precio_venta,
       sh.OrderDate
FROM Production.Product AS p
INNER JOIN Sales.SalesOrderDetail AS so
ON p.ProductID = so.ProductID
INNER JOIN Production.Product pr
ON so.ProductID = pr.ProductID
INNER JOIN Sales.SalesOrderHeader sh
ON sh.SalesOrderID = so.SalesOrderID

-- Un ejemplo de una "Tabla derivada"

-- Digamos que solo nos interesaba la información de pedidos donde el Precio de Venta era superior 
-- a 20000. Sería bueno si pudiéramos agregar una cláusula WHERE a la consulta anterior. 
-- Podríamos escribir la siguiente cláusula WHERE:

SELECT so.SalesOrderID, sh.CustomerID, pr.Name, so.OrderQty*so.UnitPrice AS Precio_venta,
       sh.OrderDate
FROM Production.Product AS p
INNER JOIN Sales.SalesOrderDetail AS so
ON p.ProductID = so.ProductID
INNER JOIN Production.Product pr
ON so.ProductID = pr.ProductID
INNER JOIN Sales.SalesOrderHeader sh
ON sh.SalesOrderID = so.SalesOrderID
WHERE so.OrderQty*so.UnitPrice > 20000

-- Pero si lo piensas bien, esto crea una situación en la que estamos repitiendo el trabajo. Para filtrar 
-- por pedidos superiores a $20000, necesitamos multiplicar el precio por la cantidad, que es algo que ya hicimos.

-- Nunca es bueno repetir código. Y no, no podemos usar el alias 'SalePrice' en la cláusula WHERE. Solo puede 
-- usar alias en una cláusula ORDER BY. Este es un ejemplo perfecto de cuándo podríamos usar una tabla derivada. 

SELECT Order_id, Customer_id, Nombre_producto, Precio_venta, Order_date
FROM 
    (SELECT so.SalesOrderID AS Order_id, sh.CustomerID AS Customer_id, pr.Name AS Nombre_producto, 
            so.OrderQty*so.UnitPrice AS Precio_venta, sh.OrderDate AS Order_date
     FROM Production.Product AS p
     INNER JOIN Sales.SalesOrderDetail AS so
     ON p.ProductID = so.ProductID
     INNER JOIN Production.Product pr
     ON so.ProductID = pr.ProductID
     INNER JOIN Sales.SalesOrderHeader sh
     ON sh.SalesOrderID = so.SalesOrderID) AS tabla_derivada
WHERE Precio_venta > 20000

-- Lo último que me gustaría señalar es que podemos tratar una tabla derivada de la misma manera que tratarías una 
-- tabla regular. Esto significa, por ejemplo, que podríamos usar esta tabla derivada junto a un INNER JOIN.
-- Digamos que queríamos ver el nombre y apellido de los clientes que gastaron más de $ 20000. Podemos configurar 
-- fácilmente un INNER JOIN con la tabla Customer en nuestra declaración SELECT externa:

SELECT Order_id, Customer_id, pe.FirstName, pe.LastName, Nombre_producto, Precio_venta, Order_date
FROM 
    (SELECT so.SalesOrderID AS Order_id, c.PersonID AS Customer_id, pr.Name AS Nombre_producto, 
            so.OrderQty*so.UnitPrice AS Precio_venta, sh.OrderDate AS Order_date
     FROM Production.Product AS p
     INNER JOIN Sales.SalesOrderDetail AS so
     ON p.ProductID = so.ProductID
     INNER JOIN Production.Product pr
     ON so.ProductID = pr.ProductID
     INNER JOIN Sales.SalesOrderHeader sh
     ON sh.SalesOrderID = so.SalesOrderID
     INNER JOIN Sales.Customer c
     ON c.CustomerID = sh.CustomerID) AS tabla_derivada

     INNER JOIN Person.Person pe
     ON pe.BusinessEntityID = tabla_derivada.Customer_id

WHERE Precio_venta > 20000

-- Si desea que Customer_id ordene sus resultados, deberá especificar su cláusula ORDER BY en la consulta externa,
-- y no en la consulta interna, dado que de esta manera, nos devolverá un error:

SELECT Order_id, Customer_id, pe.FirstName, pe.LastName, Nombre_producto, Precio_venta, Order_date
FROM 
    (SELECT so.SalesOrderID AS Order_id, c.PersonID AS Customer_id, pr.Name AS Nombre_producto, 
            so.OrderQty*so.UnitPrice AS Precio_venta, sh.OrderDate AS Order_date
     FROM Production.Product AS p
     INNER JOIN Sales.SalesOrderDetail AS so
     ON p.ProductID = so.ProductID
     INNER JOIN Production.Product pr
     ON so.ProductID = pr.ProductID
     INNER JOIN Sales.SalesOrderHeader sh
     ON sh.SalesOrderID = so.SalesOrderID
     INNER JOIN Sales.Customer c
     ON c.CustomerID = sh.CustomerID) AS tabla_derivada
  -- ORDER BY Customer_id) AS tabla_derivada

     INNER JOIN Person.Person pe
     ON pe.BusinessEntityID = tabla_derivada.Customer_id

WHERE Precio_venta > 20000
ORDER BY Customer_id --> De esta manera es correcto ordenar

-- ============================================================================================
-- ============================================================================================

-- Es posible que las tablas derivadas no siempre sean la mejor solución:

-- Lo último que quiero señalar es cómo una tabla derivada no siempre puede ser la solución más limpia. 
-- Por ejemplo, veamos la siguiente consulta (que aún no usa una tabla derivada):

SELECT c.CustomerID, pe.FirstName, pe.LastName, COUNT(*) AS Num_ventas_por_cliente
FROM Sales.SalesOrderHeader sh
INNER JOIN Sales.Customer c
ON c.CustomerID = sh.CustomerID
INNER JOIN Person.Person pe
ON pe.BusinessEntityID = c.PersonID
GROUP BY c.CustomerID, pe.FirstName, pe.LastName
ORDER BY Num_ventas_por_cliente DESC

-- Esta consulta utiliza la cláusula GROUP BY para decirnos cuántas veces nos ha comprado un cliente.

-- Entonces, ¿qué pasaría si quisiéramos ver solo a los clientes que nos han comprado más de una vez 
-- (también conocidos como los clientes habituales)?

SELECT CustomerID, FirstName, LastName, Num_ventas_por_cliente
FROM (SELECT c.CustomerID, pe.FirstName, pe.LastName, COUNT(*) AS Num_ventas_por_cliente
      FROM Sales.SalesOrderHeader sh
      INNER JOIN Sales.Customer c
      ON c.CustomerID = sh.CustomerID
      INNER JOIN Person.Person pe
      ON pe.BusinessEntityID = c.PersonID
      GROUP BY c.CustomerID, pe.FirstName, pe.LastName) AS tabla_derivada
WHERE Num_ventas_por_cliente > 1
ORDER BY Num_ventas_por_cliente DESC

-- Esto funciona bien, pero entienda que podríamos haber logrado el mismo resultado establecido utilizando 
-- la cláusula HAVING. No se puede negar que la siguiente consulta es más corta:

SELECT c.CustomerID, pe.FirstName, pe.LastName, COUNT(*) AS Num_ventas_por_cliente
FROM Sales.SalesOrderHeader sh
INNER JOIN Sales.Customer c
ON c.CustomerID = sh.CustomerID
INNER JOIN Person.Person pe
ON pe.BusinessEntityID = c.PersonID
GROUP BY c.CustomerID, pe.FirstName, pe.LastName
HAVING COUNT(*) > 1
ORDER BY Num_ventas_por_cliente DESC