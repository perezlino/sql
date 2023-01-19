-- ======================================================
-- ================= FUNCIONES DE FECHA =================
-- ======================================================

--Las fechas se trabajan en el formato americano: MES-DIA-AÑO--

-- ===============
-- === GETDATE ===
-- ===============

-- Devuelve la fecha y hora actual del sistema
SELECT GETDATE() -- 2023-01-16 14:09:06.460

-- La hora de la fecha actual */
SELECT FORMAT(GETDATE(),'HH') -- 14
SELECT FORMAT(GETDATE(),'D') -- Monday, January 16, 2023
SELECT FORMAT(GETDATE(),'d') -- 1/16/2023
SELECT FORMAT(GETDATE(),'dd') -- 16
SELECT FORMAT(GETDATE(),'ddd') -- Mon
SELECT FORMAT(GETDATE(),'dddd') -- Monday
SELECT FORMAT(GETDATE(),'M') -- January 16
SELECT FORMAT(GETDATE(),'MM') -- 01
SELECT FORMAT(GETDATE(),'MMM') -- Jan
SELECT FORMAT(GETDATE(),'MMMM') -- January
SELECT FORMAT(GETDATE(),'y') -- January 2023
SELECT FORMAT(GETDATE(),'yy') -- 23
SELECT FORMAT(GETDATE(),'yyy') -- 2023
SELECT FORMAT(GETDATE(),'yyyy') -- 2023

-- ============================================================================================
-- ============================================================================================

-- ================
-- === DATEPART ===
-- ================

-- Devuelve el elemento parcial especificado de una fecha como un número entero

SELECT DATEPART(DW,'01-01-2022') -- 7
SELECT DATEPART(WEEKDAY,'01-01-2022') -- 7
SELECT DATEPART(MONTH,'01-01-2022') -- 1
SELECT DATEPART(YEAR,'01-01-2022') -- 2022
SELECT DATEPART(DAY,'01-01-2022') -- 1
SELECT DATEPART(DAY,GETDATE()) -- 16

-- ============================================================================================
-- ============================================================================================

-- ================
-- === DATENAME ===
-- ================

-- Devuelve el elemento parcial especificado de una fecha como una cadena de caracteres

SELECT DATENAME(DW,'01-01-2022') -- Saturday
SELECT DATENAME(WEEKDAY,'01-02-2022') -- Sunday
SELECT DATENAME(MONTH,'01-01-2022') -- January
SELECT DATENAME(DAY,'01-01-2022') -- 1

SELECT DATENAME(DW, GETDATE()) -- Monday
SELECT DATENAME(WEEKDAY, GETDATE()) -- Monday
SELECT DATENAME(MONTH, GETDATE()) -- January
SELECT DATENAME(DAY, GETDATE()) -- 16

-- Se devuelve una nueva columna con el nombre del mes de la fecha de la orden de venta
SELECT OrderDate, DATENAME(MONTH,OrderDate) AS NombresMes
FROM Sales.SalesOrderHeader

-- ============================================================================================
-- ============================================================================================

-- ===============
-- === DATEADD ===
-- ===============

/* Nos permite agregarle a una fecha intervalos, es decir, agregarle días, años, meses, 
   horas o segundos, todos esos intervalos de una fecha los podemos modificar.
*/

SELECT DATEADD (YEAR,1,GETDATE()) -- 2024-01-16 14:22:23.600
SELECT DATEADD (MONTH,1,GETDATE()) -- 2023-02-16 14:22:41.267
SELECT DATEADD (WEEKDAY,1,GETDATE()) -- 2023-01-17 14:22:49.600
SELECT DATEADD (DAY,1,GETDATE()) -- 2023-01-17 14:23:01.590

-- ============================================================================================
-- ============================================================================================

-- ================
-- === DATEDIFF ===
-- ================


-- Devuelve la diferencia entre dos fechas como número entero

SELECT DATEDIFF (YEAR,'01-01-2020',GETDATE()) -- 3
SELECT DATEDIFF (MONTH,'01-01-2020',GETDATE()) -- 36
SELECT DATEDIFF (WEEKDAY,'01-01-2020',GETDATE()) -- 1111
SELECT DATEDIFF (DAY,'01-01-2020',GETDATE()) -- 1111

-- ============================================================================================
-- ============================================================================================

-- ==========================
-- === YEAR, MONTH y DAY ===
-- ==========================

-- YEAR: Devuelve el año. Devuelve un entero.
-- MONTH: Devuelve el número de mes. Devuelve un entero.
SELECT customer_id, year, month
FROM (SELECT CustomerID AS customer_id, YEAR(OrderDate) AS year,
             MONTH(OrderDate) AS month, DAY(OrderDate) AS day
      FROM Sales.SalesOrderHeader) AS m
GROUP BY customer_id, year, month
ORDER BY customer_id

-- DAY: Devuelve el número del día. Devuelve un entero.
SELECT DAY(OrderDate) 
FROM Sales.SalesOrderHeader

-- ============================================================================================
-- ============================================================================================

/* Traer las ordenes donde el año sea mayor a 2015 y el mes sea mayor a Septiembre. 
   Agrupar por AñoMes las cantidades de ordenes
*/

SELECT año_mes, COUNT(DISTINCT SalesOrderID) AS recuento_ordenes
FROM (SELECT FORMAT(OrderDate,'MM/yyyy') año_mes, 
             SalesOrderID 
      FROM Sales.SalesOrderHeader) AS m
GROUP BY año_mes
HAVING CAST(SUBSTRING(año_mes, 4, 7) AS INT)  > 2011
AND CAST(SUBSTRING(año_mes, 1, 2) AS INT)  > 9