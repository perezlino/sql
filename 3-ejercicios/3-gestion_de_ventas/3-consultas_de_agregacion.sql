-- ======================================================
-- ====================== CONSULTAS  ====================
-- ======================================================

USE EJERCICIOS 

SELECT * FROM consumidor
SELECT * FROM orden
SELECT * FROM comercial

/* 1.	Calcula la cantidad total que suman todos los pedidos que aparecen en la tabla orden . */

SELECT COUNT(1) FROM orden

/* 2.	Calcula la cantidad media de todos los pedidos que aparecen en la tabla orden . */

SELECT AVG(orden_id) FROM orden

/* 3.	Calcula el número total de comerciales distintos que aparecen en la tabla orden . */

SELECT COUNT(DISTINCT comercial_id) FROM orden

/* 4.	Calcula el número total de clientes que aparecen en la tabla consumidor . */

SELECT COUNT(DISTINCT consumidor_id) FROM consumidor

/* 5.	Calcula cuál es la mayor cantidad que aparece en la tabla orden . */

SELECT MAX(total) FROM orden

/* 6.	Calcula cuál es la menor cantidad que aparece en la tabla pedido . */

SELECT MIN(total) FROM orden

/* 7.	Calcula cuál es el valor máximo de categoría para cada una de las ciudades que aparece en la tabla 
        cliente . */

SELECT ciudad, MAX(categoria) max_categoria
FROM consumidor
GROUP BY ciudad
ORDER BY max_categoria DESC

/* 8.	Calcula cuál es el máximo valor de los pedidos realizados durante el mismo día para cada uno de los 
        clientes. Es decir, el mismo cliente puede haber realizado varios pedidos de diferentes cantidades 
        el mismo día. Se pide que se calcule cuál es el pedido de máximo valor para cada uno de los días en 
        los que un cliente ha realizado un pedido. Muestra el identificador del cliente, nombre, apellidos, 
        la fecha y el valor de la cantidad.


/* 9.	Calcula cuál es el máximo valor de los pedidos realizados durante el mismo día para cada uno de los 
        clientes, teniendo en cuenta que sólo queremos mostrar aquellos pedidos que superen la cantidad de 2000. */


/* 10.	Calcula el máximo valor de los pedidos realizados para cada uno de los comerciales durante la fecha 
        2016-08-17 . Muestra el identificador del comercial, nombre, apellidos y total. */

SELECT C.comercial_id, 
       C.nombre, 
       C.apellido_paterno,
       C.apellido_materno,
       MAX(O.total) max_total
FROM comercial C
INNER JOIN orden O
ON O.comercial_id = C.comercial_id
WHERE fecha_orden = '2016-08-17'
GROUP BY c.comercial_id, C.nombre, C.apellido_paterno, C.apellido_materno

/* 11.	Devuelve un listado con el identificador de cliente, nombre y apellidos y el número total de pedidos que 
        ha realizado cada uno de clientes. Tenga en cuenta que pueden existir clientes que no han realizado ningún 
        pedido. Estos clientes también deben aparecer en el listado indicando que el número de pedidos realizados 
        es 0 . */

SELECT C.consumidor_id,
       C.nombre, 
       C.apellido_paterno,
       C.apellido_materno,
       COUNT(C.consumidor_id) cuenta_orden
FROM consumidor C
INNER JOIN orden O
ON O.consumidor_id = C.consumidor_id
GROUP BY C.consumidor_id, C.nombre, C.apellido_paterno, C.apellido_materno
ORDER BY cuenta_orden DESC

/* 12.	Devuelve un listado con el identificador de cliente, nombre y apellidos y el número total de pedidos que 
        ha realizado cada uno de clientes durante el año 2017. */

SELECT C.consumidor_id,
       C.nombre, 
       C.apellido_paterno,
       C.apellido_materno,
       COUNT(C.consumidor_id) cuenta_orden
FROM consumidor C
INNER JOIN orden O
ON O.consumidor_id = C.consumidor_id
WHERE YEAR(fecha_orden) = '2017'
GROUP BY C.consumidor_id, C.nombre, C.apellido_paterno, C.apellido_materno
ORDER BY cuenta_orden DESC

/* 13.	Devuelve un listado que muestre el identificador de cliente, nombre, primer apellido y el valor de la 
        máxima cantidad del pedido realizado por cada uno de los clientes. El resultado debe mostrar aquellos 
        clientes que no han realizado ningún pedido indicando que la máxima cantidad de sus pedidos realizados 
        es 0 . Puede hacer uso de la función ISNULL . */

SELECT C.consumidor_id,
       C.nombre, 
       C.apellido_paterno,
       C.apellido_materno,
       MAX(ISNULL(O.total,0)) max_total
FROM consumidor C
LEFT JOIN orden O
ON O.consumidor_id = C.consumidor_id
GROUP BY C.consumidor_id, C.nombre, C.apellido_paterno, C.apellido_materno
ORDER BY max_total DESC

/* 14.	Devuelve cuál ha sido el pedido de máximo valor que se ha realizado cada año. */

SELECT YEAR(fecha_orden) año,
       MAX(total) max_total
FROM orden
GROUP BY YEAR(fecha_orden)

/* 15.	Devuelve el número total de pedidos que se han realizado cada año. */

SELECT YEAR(fecha_orden) año,
       COUNT(orden_id) cuenta_orden
FROM orden
GROUP BY YEAR(fecha_orden)