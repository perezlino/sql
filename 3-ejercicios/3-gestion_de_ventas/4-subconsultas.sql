-- ======================================================
-- ====================== CONSULTAS  ====================
-- ======================================================

USE EJERCICIOS 

SELECT * FROM consumidor
SELECT * FROM orden
SELECT * FROM comercial

/* 1.	Devuelve un listado con todos los pedidos que ha realizado Adela Salas Díaz . (Sin utilizar INNER JOIN ). */

SELECT * FROM consumidor C, orden O
WHERE C.consumidor_id = O.consumidor_id
AND C.nombre = 'Adela'
AND C.apellido_paterno = 'Salas'
AND apellido_materno = 'Diaz'

/* 2.	Devuelve el número de pedidos en los que ha participado el comercial Alfonso Perez Lino . (Sin utilizar 
        INNER JOIN )  */

SELECT * FROM comercial C, orden O
WHERE C.comercial_id = O.comercial_id
AND C.nombre = 'Alfonso'
AND C.apellido_paterno = 'Perez'
AND apellido_materno = 'Lino'

/* 3.	Devuelve los datos del cliente que realizó el pedido más caro en el año 2019 . (Sin utilizar INNER JOIN ). */

SELECT C.nombre, O.total
FROM consumidor C, orden O
WHERE C.consumidor_id = O.consumidor_id
AND YEAR(O.fecha_orden) = '2019'
ORDER BY total DESC
OFFSET 0 ROWS
FETCH NEXT 1 ROW ONLY

SELECT TOP 1 C.nombre, O.total
FROM consumidor C, orden O
WHERE C.consumidor_id = O.consumidor_id
AND YEAR(O.fecha_orden) = '2019'
ORDER BY total DESC

/* 4.	Devuelve la fecha y la cantidad del pedido de menor valor realizado por el cliente Pepe Ruiz Santana . */

SELECT fecha_orden, total
FROM orden
WHERE total IN (SELECT MIN(total) FROM orden WHERE consumidor_id =
                    (SELECT consumidor_id FROM consumidor WHERE nombre = 'Pepe'
                        AND apellido_paterno = 'Ruiz'
                            AND apellido_materno = 'Santana'))

/* 5.	Devuelve un listado con los datos de los clientes y los pedidos, de todos los clientes que han realizado 
        un pedido durante el año 2017 con un valor mayor o igual al valor medio de los pedidos realizados durante 
        ese mismo año.  */


/* 6.	Devuelve el pedido más caro que existe en la tabla orden. */

SELECT orden_id, total FROM orden
WHERE total >= ANY (SELECT MAX(total) FROM orden)

/* 7.	Devuelve un listado de los clientes que no han realizado ningún pedido. */

SELECT * FROM consumidor
WHERE consumidor_id <> ALL (SELECT consumidor_id FROM orden)

SELECT * FROM consumidor
WHERE consumidor_id NOT IN (SELECT consumidor_id FROM orden)

SELECT * FROM consumidor
WHERE NOT EXISTS (SELECT DISTINCT consumidor_id FROM orden
                    WHERE orden.consumidor_id = consumidor.consumidor_id)

/* 8.	Devuelve un listado de los comerciales que no han realizado ningún pedido.  */

SELECT * FROM comercial
WHERE comercial_id <> ALL (SELECT comercial_id FROM orden)

SELECT * FROM comercial
WHERE comercial_id NOT IN (SELECT comercial_id FROM orden)

SELECT * FROM comercial
WHERE NOT EXISTS (SELECT DISTINCT comercial_id FROM orden
                    WHERE orden.comercial_id = comercial.comercial_id)