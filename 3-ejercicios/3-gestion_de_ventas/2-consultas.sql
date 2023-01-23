-- ======================================================
-- ====================== CONSULTAS  ====================
-- ======================================================

USE EJERCICIOS 

SELECT * FROM consumidor
SELECT * FROM orden
SELECT * FROM comercial

/* 1.	Devuelve un listado con el identificador, nombre y los apellidos de todos los clientes que 
        han realizado algún pedido. El listado debe estar ordenado alfabéticamente y se deben eliminar 
        los elementos repetidos. */

SELECT consumidor_id, nombre, apellido_paterno, apellido_materno 
FROM consumidor
WHERE consumidor_id IN (SELECT DISTINCT consumidor_id FROM orden)

/* 2.	Devuelve un listado que muestre todos los pedidos que ha realizado cada cliente. El resultado debe 
        mostrar todos los datos de los pedidos y del cliente. El listado debe mostrar los datos de los 
        clientes ordenados alfabéticamente. */

SELECT * FROM consumidor C
INNER JOIN orden O
ON O.consumidor_id = C.consumidor_id
ORDER BY C.nombre

/* 3.	Devuelve un listado que muestre todos los pedidos en los que ha participado un comercial. El resultado 
        debe mostrar todos los datos de los pedidos y de los comerciales. El listado debe mostrar los datos de 
        los comerciales ordenados alfabéticamente. */

SELECT * FROM comercial C
INNER JOIN orden O
ON O.comercial_id = C.comercial_id
ORDER BY C.nombre

/* 4.	Devuelve un listado que muestre todos los clientes, con todos los pedidos que han realizado y con los 
        datos de los comerciales asociados a cada pedido. */

SELECT * FROM consumidor C
INNER JOIN orden O
ON O.consumidor_id = C.consumidor_id
INNER JOIN comercial CO
ON CO.comercial_id = O.comercial_id
ORDER BY C.nombre

/* 5.	Devuelve un listado de todos los clientes que realizaron un pedido durante el año 2017 , cuya cantidad 
        esté entre 300 y 1000. */

SELECT * FROM consumidor
WHERE consumidor_id IN (SELECT consumidor_id FROM orden
                            WHERE YEAR(fecha_orden) = '2017'
                                AND total BETWEEN 300 AND 1000)

/* 6.	Devuelve el nombre y los apellidos de todos los comerciales que ha participado en algún pedido realizado 
        por María Santana Moreno. */

SELECT * FROM comercial
WHERE comercial_id IN (SELECT DISTINCT comercial_id FROM orden O
                        INNER JOIN consumidor C
                        ON C.consumidor_id = O.consumidor_id
                            WHERE nombre = 'Maria' 
                                AND apellido_paterno = 'Santana'
                                    AND apellido_materno = 'Moreno')

/* 7.	Devuelve el nombre de todos los clientes que han realizado algún pedido con el comercial Marta Herrera Gil . */

SELECT * FROM consumidor
WHERE consumidor_id IN (SELECT DISTINCT consumidor_id FROM orden O
                        INNER JOIN comercial C
                        ON C.comercial_id = O.comercial_id
                            WHERE nombre = 'Marta' 
                                AND apellido_paterno = 'Herrera'
                                    AND apellido_materno = 'Gil')

/* 8.	Devuelve un listado con todos los clientes junto con los datos de los pedidos que han realizado. Este 
        listado también debe incluir los clientes que no han realizado ningún pedido. El listado debe estar ordenado 
        alfabéticamente por el primer apellido, segundo apellido y nombre de los clientes. */

SELECT C.*, O.*
FROM consumidor C
LEFT JOIN orden O
ON O.consumidor_id = C.consumidor_id
ORDER BY C.apellido_paterno, C.apellido_materno, C.nombre

/* 9.	Devuelve un listado con todos los comerciales junto con los datos de los pedidos que han realizado. 
        Este listado también debe incluir los comerciales que no han realizado ningún pedido. El listado debe 
        estar ordenado alfabéticamente por el primer apellido, segundo apellido y nombre de los comerciales. */

SELECT C.*, O.*
FROM comercial C
LEFT JOIN orden O
ON O.comercial_id = C.comercial_id
ORDER BY C.apellido_paterno, C.apellido_materno, C.nombre

/* 10.	Devuelve un listado que solamente muestre los clientes que no han realizado ningún pedido. */

SELECT C.*, O.*
FROM consumidor C
LEFT JOIN orden O
ON O.consumidor_id = C.consumidor_id
WHERE O.consumidor_id IS NULL

/* 11.	Devuelve un listado que solamente muestre los comerciales que no han realizado ningún pedido. */

SELECT C.*, O.*
FROM comercial C
LEFT JOIN orden O
ON O.comercial_id = C.comercial_id
WHERE O.comercial_id IS NULL

/* 12.	Devuelve un listado con los clientes que no han realizado ningún pedido y de los comerciales que 
        no han participado en ningún pedido. Ordene el listado alfabéticamente por los apellidos y el nombre. 
        En el listado deberá diferenciar de algún modo los clientes y los comerciales. */

(SELECT C.consumidor_id AS id,
        C.nombre,
        C.apellido_paterno,
        C.apellido_materno,
        descripcion = 'consumidor'
FROM consumidor C
LEFT JOIN orden O
ON O.consumidor_id = C.consumidor_id
WHERE O.consumidor_id IS NULL)
UNION
(SELECT C.comercial_id AS id,
        C.nombre,
        C.apellido_paterno,
        C.apellido_materno,
        descripcion = 'comercial'       
FROM comercial C
LEFT JOIN orden O
ON O.comercial_id = C.comercial_id
WHERE O.comercial_id IS NULL)
ORDER BY C.apellido_paterno, C.nombre