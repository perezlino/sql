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

/* 1.	Obtén un listado con el nombre de cada cliente y el nombre y apellido de su representante de ventas. */

SELECT C.nombre_cliente, 
       C.codigo_empleado_rep_ventas AS cod_rep_ventas,
       CONCAT_WS(' ', E.nombre, E.apellido_paterno, E.apellido_materno) rep_ventas
FROM cliente C
INNER JOIN emp_jardineria E
ON E.codigo_empleado = C.codigo_empleado_rep_ventas
ORDER BY C.nombre_cliente

/* 2.	Muestra el nombre de los clientes que hayan realizado pagos junto con el nombre de sus representantes 
        de ventas. */

SELECT C.nombre_cliente, 
       C.codigo_empleado_rep_ventas AS cod_rep_ventas,
       CONCAT_WS(' ', E.nombre, E.apellido_paterno, E.apellido_materno) rep_ventas
FROM cliente C
INNER JOIN emp_jardineria E
ON E.codigo_empleado = C.codigo_empleado_rep_ventas
INNER JOIN pago P
ON P.codigo_cliente = C.codigo_cliente
ORDER BY C.nombre_cliente

/* 3.	Muestra el nombre de los clientes que no hayan realizado pagos junto con el nombre de sus representantes 
        de ventas. */

SELECT C.nombre_cliente, 
       C.codigo_empleado_rep_ventas AS cod_rep_ventas,
       CONCAT_WS(' ', E.nombre, E.apellido_paterno, E.apellido_materno) rep_ventas
FROM cliente C
INNER JOIN emp_jardineria E
ON E.codigo_empleado = C.codigo_empleado_rep_ventas
LEFT JOIN pago P
ON P.codigo_cliente = C.codigo_cliente
WHERE P.codigo_cliente IS NULL

/* 4.	Devuelve el nombre de los clientes que han hecho pagos y el nombre de sus representantes junto con la 
        ciudad de la oficina a la que pertenece el representante. */

SELECT DISTINCT 
       C.nombre_cliente, 
       C.codigo_empleado_rep_ventas AS cod_rep_ventas,
       CONCAT_WS(' ', E.nombre, E.apellido_paterno, E.apellido_materno) rep_ventas,
       O.ciudad AS rep_ventas_ciudad
FROM cliente C
INNER JOIN emp_jardineria E
ON E.codigo_empleado = C.codigo_empleado_rep_ventas
INNER JOIN pago P
ON P.codigo_cliente = C.codigo_cliente
INNER JOIN oficina O
ON O.codigo_oficina = E.codigo_oficina
ORDER BY C.nombre_cliente

/* 5.	Devuelve el nombre de los clientes que no hayan hecho pagos y el nombre de sus representantes junto 
        con la ciudad de la oficina a la que pertenece el representante. */

SELECT DISTINCT 
       C.nombre_cliente, 
       C.codigo_empleado_rep_ventas AS cod_rep_ventas,
       CONCAT_WS(' ', E.nombre, E.apellido_paterno, E.apellido_materno) rep_ventas,
       O.ciudad AS rep_ventas_ciudad
FROM cliente C
INNER JOIN emp_jardineria E
ON E.codigo_empleado = C.codigo_empleado_rep_ventas
LEFT JOIN pago P
ON P.codigo_cliente = C.codigo_cliente
INNER JOIN oficina O
ON O.codigo_oficina = E.codigo_oficina
WHERE P.codigo_cliente IS NULL
ORDER BY C.nombre_cliente

/* 6.	Lista la dirección de las oficinas que tengan clientes en Fuenlabrada . */

SELECT O.linea_direccion1, O.linea_direccion2
FROM oficina O
INNER JOIN emp_jardineria E
ON E.codigo_oficina = O.codigo_oficina
INNER JOIN cliente C
ON C.codigo_empleado_rep_ventas = E.codigo_empleado
WHERE C.ciudad = 'Fuenlabrada'

/* 7.	Devuelve el nombre de los clientes y el nombre de sus representantes junto con la ciudad de la oficina 
        a la que pertenece el representante. */

SELECT DISTINCT 
       C.nombre_cliente, 
       C.codigo_empleado_rep_ventas AS cod_rep_ventas,
       CONCAT_WS(' ', E.nombre, E.apellido_paterno, E.apellido_materno) rep_ventas,
       O.ciudad AS rep_ventas_ciudad
FROM cliente C
INNER JOIN emp_jardineria E
ON E.codigo_empleado = C.codigo_empleado_rep_ventas
INNER JOIN oficina O
ON O.codigo_oficina = E.codigo_oficina
ORDER BY C.nombre_cliente

/* 8.	Devuelve un listado con el nombre de los empleados junto con el nombre de sus jefes. */

SELECT CONCAT_WS(' ', EMPLEADO.nombre, EMPLEADO.apellido_paterno, EMPLEADO.apellido_materno) empleado,
       CONCAT_WS(' ', JEFE.nombre, JEFE.apellido_paterno, JEFE.apellido_materno) jefe
FROM emp_jardineria EMPLEADO
LEFT JOIN emp_jardineria JEFE
ON JEFE.codigo_empleado = EMPLEADO.codigo_jefe

/* 9.	Devuelve un listado que muestre el nombre de cada empleados, el nombre de su jefe y el nombre del 
        jefe de sus jefe. */

SELECT CONCAT_WS(' ', EMPLEADO.nombre, EMPLEADO.apellido_paterno, EMPLEADO.apellido_materno) empleado,
       CONCAT_WS(' ', JEFE.nombre, JEFE.apellido_paterno, JEFE.apellido_materno) jefe,
       CONCAT_WS(' ', SUPERIOR.nombre, SUPERIOR.apellido_paterno, SUPERIOR.apellido_materno) jefe_superior
FROM emp_jardineria EMPLEADO
LEFT JOIN emp_jardineria JEFE
ON JEFE.codigo_empleado = EMPLEADO.codigo_jefe
LEFT JOIN emp_jardineria SUPERIOR
ON JEFE.codigo_jefe = SUPERIOR.codigo_empleado

/* 10.	Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo un pedido. */

SELECT C.nombre_cliente
FROM cliente C
INNER JOIN pedido P
ON P.codigo_cliente = C.codigo_cliente
WHERE DATEDIFF(DAY, fecha_esperada, fecha_entrega) > 0
ORDER BY C.nombre_cliente

/* 11.	Devuelve un listado de las diferentes gamas de producto que ha comprado cada cliente. */

SELECT PP.codigo_cliente, GP.gama
FROM gama_producto GP
INNER JOIN prod_jardineria P
ON P.gama = GP.gama
INNER JOIN detalle_pedido DP
ON DP.codigo_producto = P.codigo_producto
INNER JOIN pedido PP
ON PP.codigo_pedido = DP.codigo_pedido
GROUP BY GP.gama, PP.codigo_cliente
ORDER BY PP.codigo_cliente

/* 12.	Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago. */

SELECT DISTINCT C.nombre_cliente
FROM cliente C
LEFT JOIN pago P
ON P.codigo_cliente = C.codigo_cliente
WHERE P.codigo_cliente IS NULL

/* 13.	Devuelve un listado que muestre solamente los clientes que no han realizado ningún pedido. */

SELECT DISTINCT C.nombre_cliente
FROM cliente C
LEFT JOIN pedido P
ON P.codigo_cliente = C.codigo_cliente
WHERE P.codigo_cliente IS NULL

/* 14.	Devuelve un listado que muestre los clientes que no han realizado ningún pago y que no han 
        realizado ningún pedido. */

SELECT *
FROM cliente C
LEFT JOIN pago P
ON P.codigo_cliente = C.codigo_cliente
LEFT JOIN pedido PP
ON PP.codigo_cliente = C.codigo_cliente
WHERE P.codigo_cliente IS NULL
AND PP.codigo_cliente IS NULL

/* 15.	Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado. */

SELECT E.codigo_empleado,
       E.nombre,
       E.apellido_paterno,
       E.apellido_materno,
       C.codigo_cliente
FROM emp_jardineria E
LEFT JOIN cliente C
ON C.codigo_empleado_rep_ventas = E.codigo_empleado
WHERE C.codigo_cliente IS NULL

/* 16.	Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado junto 
        con los datos de la oficina donde trabajan. */

SELECT E.codigo_empleado,
       E.nombre,
       E.apellido_paterno,
       E.apellido_materno,
       C.codigo_cliente,
       O.codigo_oficina,
       O.pais,
       O.ciudad
FROM emp_jardineria E
LEFT JOIN cliente C
ON C.codigo_empleado_rep_ventas = E.codigo_empleado
INNER JOIN oficina O
ON O.codigo_oficina = E.codigo_oficina
WHERE C.codigo_cliente IS NULL

/* 18.	Devuelve un listado de los productos que nunca han aparecido en un pedido. */

SELECT P.codigo_producto,
       P.nombre,
       DP.codigo_pedido
FROM prod_jardineria P
LEFT JOIN detalle_pedido DP
ON DP.codigo_producto = P.codigo_producto
WHERE DP.codigo_pedido IS NULL

/* 19.	Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los representantes 
        de ventas de algún cliente que haya realizado la compra de algún producto de la gama Frutales . */

(SELECT codigo_oficina
FROM emp_jardineria)
EXCEPT
(SELECT E.codigo_oficina
FROM emp_jardineria E
LEFT JOIN cliente C
ON C.codigo_empleado_rep_ventas = E.codigo_empleado
LEFT JOIN pedido P
ON P.codigo_cliente = C.codigo_cliente
LEFT JOIN detalle_pedido DP
ON DP.codigo_pedido = P.codigo_pedido
LEFT JOIN prod_jardineria PJ
ON PJ.codigo_producto = DP.codigo_producto
WHERE E.puesto = 'Representante Ventas'
AND PJ.gama = 'Frutales')

/* 20.	Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún 
        pago (Es decir, han realizado un pedido y no han realizado ningún pago) */

SELECT C.codigo_cliente, C.nombre_cliente
FROM cliente C
INNER JOIN pedido P
ON P.codigo_cliente = C.codigo_cliente
LEFT JOIN pago PP
ON PP.codigo_cliente = C.codigo_cliente
WHERE PP.codigo_cliente IS NULL
GROUP BY C.codigo_cliente, C.nombre_cliente

/* 21.	Devuelve un listado con los datos de los empleados que no tienen clientes asociados y el nombre de 
        su jefe asociado. */
    
SELECT E.codigo_empleado,
       E.nombre,
       E.apellido_paterno,
       E.apellido_materno,
       E.codigo_jefe
FROM emp_jardineria E
LEFT JOIN cliente C
ON C.codigo_empleado_rep_ventas = E.codigo_empleado
WHERE C.codigo_cliente IS NULL