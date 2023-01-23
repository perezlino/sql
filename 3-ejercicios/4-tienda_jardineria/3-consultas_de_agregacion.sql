-- ======================================================
-- ====================== CONSULTAS  ====================
-- ======================================================

USE EJERCICIOS 

SELECT * FROM pago
SELECT * FROM cliente
SELECT * FROM pedido
SELECT * FROM oficina
SELECT * FROM emp_jardineria
SELECT * FROM gama_producto
SELECT * FROM prod_jardineria
SELECT * FROM detalle_pedido

/* 1.	¿Cuántos empleados hay en la compañía? */

SELECT COUNT(1) FROM emp_jardineria

/* 2.	¿Cuántos clientes tiene cada país? */

SELECT pais,
       COUNT(codigo_cliente) cant_cliente
FROM cliente
GROUP BY pais

/* 3.	¿Cuál fue el pago medio en 2009? */

SELECT DISTINCT forma_pago AS medio_pago
FROM pago
WHERE YEAR(fecha_pago) = '2009'

/* 4.	¿Cuántos pedidos hay en cada estado? Ordena el resultado de forma descendente por el número de pedidos. */

SELECT estado,
       COUNT(codigo_pedido) cant_pedidos
FROM pedido
GROUP BY estado

/* 5.	Calcula el precio de venta del producto más caro y más barato en una misma consulta. */

SELECT MIN(precio_venta) min_precio,
       MAX(precio_venta) max_precio
FROM prod_jardineria

/* 6.	Calcula el número de clientes que tiene la empresa. */

SELECT COUNT(1) FROM cliente

/* 7.	¿Cuántos clientes tiene la ciudad de Madrid? */

SELECT ciudad,
       COUNT(codigo_cliente) cant_cliente
FROM cliente
GROUP BY ciudad
HAVING ciudad = 'Madrid'

/* 8.	¿Calcula cuántos clientes tiene cada una de las ciudades que empiezan por M ? */

SELECT ciudad,
       COUNT(codigo_cliente) cant_cliente
FROM cliente
GROUP BY ciudad
HAVING ciudad LIKE 'M%'

/* 9.	Devuelve el nombre de los representantes de ventas y el número de clientes al que atiende cada uno. */

SELECT E.*, C.codigo_cliente
FROM emp_jardineria E
INNER JOIN cliente C
ON C.codigo_empleado_rep_ventas = E.codigo_empleado
WHERE E.puesto = 'Representante Ventas'