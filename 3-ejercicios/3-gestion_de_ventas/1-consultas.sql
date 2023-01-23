-- ======================================================
-- ====================== CONSULTAS  ====================
-- ======================================================

USE EJERCICIOS 

SELECT * FROM consumidor
SELECT * FROM orden
SELECT * FROM comercial

/* 1.	Devuelve un listado con todos los pedidos que se han realizado. Los pedidos deben estar 
        ordenados por la fecha de realización, mostrando en primer lugar los pedidos más recientes. */

SELECT * FROM orden
ORDER BY fecha_orden DESC

/* 2.	Devuelve todos los datos de los dos pedidos de mayor valor. */

SELECT TOP 2 * FROM orden
ORDER BY total DESC

SELECT * FROM orden
ORDER BY total DESC
OFFSET 0 ROWS
FETCH NEXT 2 ROWS ONLY

/* 3.	Devuelve un listado con los identificadores de los clientes que han realizado algún pedido. 
        Tenga en cuenta que no debe mostrar identificadores que estén repetidos. */

SELECT DISTINCT C.consumidor_id 
FROM consumidor C
INNER JOIN orden O
ON O.consumidor_id = C.consumidor_id

SELECT consumidor_id FROM consumidor
WHERE consumidor_id IN (SELECT DISTINCT consumidor_id FROM orden)

/* 4.	Devuelve un listado de todos los pedidos que se realizaron durante el año 2017, cuya cantidad 
        total sea superior a 500. */

SELECT * FROM orden
WHERE fecha_orden BETWEEN '2017-01-01' AND '2017-12-31'
AND total > 500

SELECT * FROM orden
WHERE DATEPART(YEAR, fecha_orden) = '2017'
AND total > 500

SELECT * FROM orden
WHERE YEAR(fecha_orden) = '2017'
AND total > 500

/* 5.	Devuelve un listado con el nombre y los apellidos de los comerciales que tienen una comisión 
        entre 0.05 y 0.11. */

SELECT CONCAT_WS(' ', nombre, apellido_paterno, apellido_materno) nombre_completo
FROM comercial
WHERE comision BETWEEN 0.05 AND 0.11

/* 6.	Devuelve el valor de la comisión de mayor valor que existe en la tabla comercial */

SELECT MAX(comision) FROM comercial

/* 7.	Devuelve el identificador, nombre y primer apellido de aquellos clientes cuyo segundo apellido 
        no es NULL . El listado deberá estar ordenado alfabéticamente por apellidos y nombre. */

SELECT consumidor_id, nombre, apellido_paterno
FROM consumidor
WHERE apellido_materno IS NOT NULL
ORDER BY apellido_paterno, nombre

/* 8.	Devuelve un listado de los nombres de los clientes que empiezan por A y terminan por n y también 
        los nombres que empiezan por P . El listado deberá estar ordenado alfabéticamente */

SELECT * FROM consumidor
WHERE nombre LIKE 'A%'
AND nombre LIKE '%n'
OR nombre LIKE 'P%'
ORDER BY nombre

/* 9.	Devuelve un listado de los nombres de los clientes que no empiezan por A . El listado deberá estar 
        ordenado alfabéticamente. */

SELECT * FROM consumidor
WHERE nombre NOT LIKE 'A%'
ORDER BY nombre

/* 10.	Devuelve un listado con los nombres de los comerciales que terminan en 'el' o 'o' . Tenga en cuenta 
        que se deberán eliminar los nombres repetidos */

SELECT * FROM comercial
WHERE nombre LIKE '%el'
OR nombre LIKE '%o'
ORDER BY nombre