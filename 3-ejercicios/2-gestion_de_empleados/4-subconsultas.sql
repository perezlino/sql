-- ======================================================
-- ====================== CONSULTAS  ====================
-- ======================================================

USE EJERCICIOS 

SELECT * FROM departamento
SELECT * FROM empleado

/* 1.	Devuelve un listado con todos los empleados que tiene el departamento de Sistemas . 
        (Sin utilizar INNER JOIN ). */

SELECT CONCAT_WS(' ', E.nombre, apellido_paterno, apellido_materno) nombre_completo
FROM empleado E, departamento D
WHERE D.codigo = E.codigo_departamento
AND E.codigo_departamento IN (SELECT codigo FROM departamento
                                WHERE nombre = 'Sistemas')

/* 2.	Devuelve el nombre del departamento con mayor presupuesto y la cantidad que tiene asignada. */

SELECT nombre, presupuesto FROM departamento
WHERE presupuesto IN (SELECT MAX(presupuesto) FROM departamento)

/* 3.	Devuelve el nombre del departamento con menor presupuesto y la cantidad que tiene asignada. */

SELECT nombre, presupuesto FROM departamento
WHERE presupuesto IN (SELECT MIN(presupuesto) FROM departamento)

/* 4.	Devuelve el nombre del departamento con mayor presupuesto y la cantidad que tiene asignada. 
        Sin hacer uso de MAX, ORDER BY ni LIMIT. */

SELECT nombre, presupuesto FROM departamento
WHERE presupuesto >= ANY (SELECT MAX(presupuesto) FROM departamento)

/* 2.	Devuelve el nombre del departamento con menor presupuesto y la cantidad que tiene asignada. 
        Sin hacer uso de MIN, ORDER BY ni LIMIT . */

SELECT nombre, presupuesto FROM departamento
WHERE presupuesto <= ANY (SELECT MIN(presupuesto) FROM departamento)

/* 3.	Devuelve los nombres de los departamentos que tienen empleados asociados. (Utilizando ALL o ANY). */

SELECT nombre FROM departamento
WHERE codigo = ANY (SELECT DISTINCT codigo_departamento FROM empleado
                        WHERE codigo_departamento IS NOT NULL)

SELECT nombre 
FROM departamento
WHERE codigo IN (SELECT DISTINCT codigo_departamento FROM empleado
                        WHERE codigo_departamento IS NOT NULL)

SELECT nombre 
FROM departamento D
WHERE EXISTS (SELECT DISTINCT codigo_departamento FROM empleado E
                        WHERE E.codigo_departamento = D.codigo)

/* 4.	Devuelve los nombres de los departamentos que no tienen empleados asociados. (Utilizando ALL o ANY). */

SELECT nombre 
FROM departamento
WHERE codigo NOT IN (SELECT DISTINCT codigo_departamento FROM empleado
                        WHERE codigo_departamento IS NOT NULL)

SELECT nombre FROM departamento
WHERE codigo <> ALL (SELECT DISTINCT codigo_departamento FROM empleado
                        WHERE codigo_departamento IS NOT NULL)

SELECT nombre 
FROM departamento D
WHERE NOT EXISTS (SELECT DISTINCT codigo_departamento FROM empleado E
                        WHERE E.codigo_departamento = D.codigo)