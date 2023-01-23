-- ======================================================
-- ====================== CONSULTAS  ====================
-- ======================================================

USE EJERCICIOS 

SELECT * FROM departamento
SELECT * FROM empleado

-- 1.	Devuelve un listado con los empleados y los datos de los departamentos donde trabaja cada uno.

SELECT E.*, D.nombre, D.presupuesto, D.gastos   
FROM empleado E
INNER JOIN departamento D
ON D.codigo = E.codigo_departamento

/* 2.	Devuelve un listado con los empleados y los datos de los departamentos donde trabaja cada uno. 
        Ordena el resultado, en primer lugar por el nombre del departamento (en orden alfabético) y en 
        segundo lugar por los apellidos y el nombre de los empleados. */

SELECT E.*, D.nombre, D.presupuesto, D.gastos   
FROM empleado E
INNER JOIN departamento D
ON D.codigo = E.codigo_departamento
ORDER BY D.nombre, E.apellido_paterno, E.apellido_materno, E.nombre

/* 3.	Devuelve un listado con el código y el nombre del departamento, solamente de aquellos departamentos 
        que tienen empleados. */

SELECT DISTINCT D.codigo, D.nombre
FROM empleado E
INNER JOIN departamento D
ON D.codigo = E.codigo_departamento
ORDER BY D.codigo

SELECT D.codigo, D.nombre
FROM empleado E
INNER JOIN departamento D
ON D.codigo = E.codigo_departamento
GROUP BY D.codigo, D.nombre

/* 4.	Devuelve un listado con el código, el nombre del departamento y el valor del presupuesto actual del 
        que dispone, solamente de aquellos departamentos que tienen empleados. El valor del presupuesto actual 
        lo puede calcular restando al valor del presupuesto inicial (columna presupuesto ) el valor de los 
        gastos que ha generado (columna gastos). */

SELECT D.codigo, D.nombre, (D.presupuesto - D.gastos) presupuesto_actual
FROM empleado E
INNER JOIN departamento D
ON D.codigo = E.codigo_departamento
GROUP BY D.codigo, D.nombre, (D.presupuesto - D.gastos)

-- 5.	Devuelve el nombre del departamento donde trabaja el empleado que tiene el nif 38382980M .

SELECT nombre FROM departamento
WHERE codigo = (SELECT codigo_departamento FROM empleado 
                    WHERE nif = '38382980M')

SELECT nombre FROM departamento
WHERE codigo IN (SELECT codigo_departamento FROM empleado 
                    WHERE nif = '38382980M')

-- 6.	Devuelve el nombre del departamento donde trabaja el empleado Pepe Ruiz Santana .

SELECT nombre FROM departamento
WHERE codigo = (SELECT codigo_departamento FROM empleado 
                    WHERE nombre = 'Pepe' AND apellido_paterno = 'Ruiz'
                        AND apellido_materno = 'Santana')

SELECT nombre FROM departamento
WHERE codigo IN (SELECT codigo_departamento FROM empleado 
                    WHERE nombre = 'Pepe' AND apellido_paterno = 'Ruiz'
                        AND apellido_materno = 'Santana')

/* 7.	Devuelve un listado con los datos de los empleados que trabajan en el departamento de I+D . Ordena el 
        resultado alfabéticamente. */

SELECT nombre, apellido_paterno, apellido_materno
FROM empleado
WHERE codigo_departamento = (SELECT codigo FROM departamento
                                WHERE nombre = 'I+D')

/* 8.	Devuelve un listado con los datos de los empleados que trabajan en el departamento de Sistemas, 
        Contabilidad o I+D . Ordena el resultado alfabéticamente. */

SELECT nombre, apellido_paterno, apellido_materno
FROM empleado
WHERE codigo_departamento IN (SELECT codigo FROM departamento
                                WHERE nombre IN ('I+D','Sistemas','Contabilidad'))
ORDER BY nombre

/* 9.	Devuelve una lista con el nombre de los empleados que tienen los departamentos que no tienen un 
        presupuesto entre 100000 y 200000 euros. */

SELECT CONCAT_WS(' ', nombre, apellido_paterno, apellido_materno)
FROM empleado
WHERE codigo_departamento IN (SELECT codigo FROM departamento
                                WHERE presupuesto NOT BETWEEN 100000 AND 200000)
ORDER BY nombre

/* 10.	Devuelve un listado con el nombre de los departamentos donde existe algún empleado cuyo segundo 
        apellido sea NULL . Tenga en cuenta que no debe mostrar nombres de departamentos que estén repetidos. */

SELECT nombre
FROM departamento
WHERE codigo IN (SELECT codigo_departamento FROM empleado
                    WHERE apellido_materno IS NULL)

/* 11.  Devuelve un listado con todos los empleados junto con los datos de los departamentos donde trabajan. 
        Este listado también debe incluir los empleados que no tienen ningún departamento asociado. */

SELECT E.*, D.nombre, D.presupuesto, D.gastos   
FROM empleado E
LEFT JOIN departamento D
ON D.codigo = E.codigo_departamento

/* 12.	Devuelve un listado donde sólo aparezcan aquellos empleados que no tienen ningún departamento asociado. */

SELECT E.*, D.nombre, D.presupuesto, D.gastos   
FROM empleado E
LEFT JOIN departamento D
ON D.codigo = E.codigo_departamento
WHERE E.codigo_departamento IS NULL

/* 13.	Devuelve un listado donde sólo aparezcan aquellos departamentos que no tienen ningún empleado asociado. */

SELECT D.*, E.nombre, E.apellido_paterno, E.apellido_materno
FROM departamento D
LEFT JOIN empleado E
ON D.codigo = E.codigo_departamento
WHERE E.codigo IS NULL

/* 14.	Devuelve un listado con todos los empleados junto con los datos de los departamentos donde trabajan. 
        El listado debe incluir los empleados que no tienen ningún departamento asociado y los departamentos 
        que no tienen ningún empleado asociado. Ordene el listado alfabéticamente por el nombre del departamento. */

SELECT E.*, D.nombre, D.presupuesto, D.gastos   
FROM empleado E
FULL JOIN departamento D
ON D.codigo = E.codigo_departamento

/* 15.	Devuelve un listado con los empleados que no tienen ningún departamento asociado y los departamentos 
        que no tienen ningún empleado asociado. Ordene el listado alfabéticamente por el nombre del departamento. */

SELECT E.*, D.nombre, D.presupuesto, D.gastos   
FROM empleado E
FULL JOIN departamento D
ON D.codigo = E.codigo_departamento
WHERE E.codigo_departamento IS NULL
ORDER BY D.nombre