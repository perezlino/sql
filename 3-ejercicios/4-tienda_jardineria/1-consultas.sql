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

/* 1.	Devuelve un listado con el código de oficina y la ciudad donde hay oficinas. */

SELECT codigo_oficina, ciudad 
FROM oficina

/* 2.	Devuelve un listado con la ciudad y el teléfono de las oficinas de España. */

SELECT ciudad, telefono
FROM oficina
WHERE pais = 'España'

/* 3.	Devuelve un listado con el nombre, apellidos y email de los empleados cuyo jefe tiene un código 
        de jefe igual a 7. */

SELECT nombre, apellido_paterno, apellido_materno, email
FROM emp_jardineria
WHERE codigo_jefe = 7

/* 4.	Devuelve el nombre del puesto, nombre, apellidos y email del jefe de la empresa. */

SELECT nombre, apellido_paterno, apellido_materno, puesto, email
FROM emp_jardineria
WHERE codigo_jefe IS NULL

/* 5.	Devuelve un listado con el nombre, apellidos y puesto de aquellos empleados que no sean representantes 
        de ventas. */

SELECT nombre, apellido_paterno, apellido_materno, puesto, email
FROM emp_jardineria
WHERE puesto <> 'Representante de ventas'

/* 6.	Devuelve un listado con el nombre de los todos los clientes españoles. */

SELECT nombre_cliente
FROM cliente
WHERE pais = 'Spain'

/* 7.	Devuelve un listado con los distintos estados por los que puede pasar un pedido. */

SELECT DISTINCT estado FROM pedido

/* 8.	Devuelve un listado con el código de cliente de aquellos clientes que realizaron algún pago en 2008. 
        Tenga en cuenta que deberá eliminar aquellos códigos de cliente que aparezcan repetidos. Resuelva la 
        consulta: */

SELECT DISTINCT codigo_cliente
FROM pago
WHERE YEAR(fecha_pago) = '2008'

/* 9.	Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de 
        los pedidos que no han sido entregados a tiempo. */

SELECT codigo_pedido, codigo_cliente, 
       fecha_esperada, fecha_entrega,
       DATEDIFF(DAY, fecha_esperada, fecha_entrega) dias_atraso
FROM pedido
WHERE DATEDIFF(DAY, fecha_esperada, fecha_entrega) > 0
ORDER BY dias_atraso

/* 10.	Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los 
        pedidos cuya fecha de entrega ha sido al menos dos días antes de la fecha esperada. */

SELECT codigo_pedido, codigo_cliente, 
       fecha_esperada, fecha_entrega,
       DATEDIFF(DAY, fecha_entrega, fecha_esperada) dias_antelacion
FROM pedido
WHERE DATEDIFF(DAY, fecha_entrega, fecha_esperada) >= 2
ORDER BY dias_antelacion

/* 11.	Devuelve un listado de todos los pedidos que fueron rechazados en 2009 . */

SELECT codigo_pedido, codigo_cliente, 
       fecha_esperada, fecha_entrega
FROM pedido
WHERE YEAR(fecha_pedido) = '2009'
AND estado = 'Rechazado'

/* 12.	Devuelve un listado de todos los pedidos que han sido entregados en el mes de enero de cualquier año. */

SELECT codigo_pedido, codigo_cliente, 
       fecha_esperada, fecha_entrega,
       estado
FROM pedido
WHERE MONTH(fecha_pedido) = '01'
AND estado = 'Entregado'

/* 13.	Devuelve un listado con todos los pagos que se realizaron en el año 2008 mediante Paypal. Ordene el 
        resultado de mayor a menor. */

SELECT * FROM pago
WHERE YEAR(fecha_pago) = '2008'
AND forma_pago = 'Paypal'

/* 14.	Devuelve un listado con todas las formas de pago que aparecen en la tabla pago . Tenga en cuenta que no 
        deben aparecer formas de pago repetidas. */

SELECT DISTINCT forma_pago 
FROM pago

/* 15.	Devuelve un listado con todos los productos que pertenecen a la gama Ornamentales y que tienen más de 
        100 unidades en stock. El listado deberá estar ordenado por su precio de venta, mostrando en primer lugar 
        los de mayor precio. */

SELECT * FROM prod_jardineria
WHERE cantidad_en_stock > 100
AND gama = 'Ornamentales'

/* 16.	Devuelve un listado con todos los clientes que sean de la ciudad de Madrid y cuyo representante de ventas 
        tenga el código de empleado 11 o 30 */

SELECT * FROM cliente
WHERE ciudad = 'Madrid'
AND codigo_empleado_rep_ventas IN (11,30)