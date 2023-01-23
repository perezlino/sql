-- ======================================================
-- ====================== CONSULTAS  ====================
-- ======================================================

USE EJERCICIOS 

SELECT * FROM departamento
SELECT * FROM empleado

/* 1.	Calcula la suma del presupuesto de todos los departamentos. */

SELECT SUM(presupuesto) FROM departamento

/* 2.	Calcula el promedio del presupuesto de todos los departamentos. */

SELECT AVG(presupuesto) FROM departamento

/* 3.	Calcula el valor mínimo del presupuesto de todos los departamentos. */

SELECT MIN(presupuesto) FROM departamento

/* 4.	Calcula el nombre del departamento y el presupuesto que tiene asignado, del departamento 
        con menor presupuesto. */

SELECT nombre, presupuesto FROM departamento
WHERE presupuesto IN (SELECT MIN(presupuesto) FROM departamento)

/* 5.	Calcula el valor máximo del presupuesto de todos los departamentos. */

SELECT MAX(presupuesto) FROM departamento

/* 6.	Calcula el nombre del departamento y el presupuesto que tiene asignado, del departamento con 
        mayor presupuesto. */

SELECT nombre, presupuesto FROM departamento
WHERE presupuesto IN (SELECT MAX(presupuesto) FROM departamento)

/* 7.	Calcula el número total de empleados que hay en la tabla empleado . */

SELECT COUNT(*) FROM empleado

SELECT COUNT(1) FROM empleado

/* 8.	Calcula el número de empleados que no tienen NULL en su segundo apellido. */

SELECT COUNT(1) FROM empleado
WHERE apellido_materno IS NOT NULL

/* 9.	Calcula el número de empleados que hay en cada departamento. Tienes que devolver dos columnas, 
        una con el nombre del departamento y otra con el número de empleados que tiene asignados.  */

SELECT D.nombre, COUNT(E.codigo)
FROM departamento D
INNER JOIN empleado E
ON E.codigo_departamento = D.codigo
GROUP BY D.nombre
ORDER BY D.nombre

/* 10.	Calcula el nombre de los departamentos que tienen más de 2 empleados. El resultado debe tener dos 
        columnas, una con el nombre del departamento y otra con el número de empleados que tiene asignados. */

SELECT D.nombre, COUNT(E.codigo)
FROM departamento D
FULL JOIN empleado E
ON E.codigo_departamento = D.codigo
GROUP BY D.nombre
HAVING COUNT(E.codigo) > 2
ORDER BY D.nombre

/* 11.	Calcula el número de empleados que trabajan en cada uno de los departamentos. El resultado de esta 
        consulta también tiene que incluir aquellos departamentos que no tienen ningún empleado asociado. */

SELECT D.nombre, COUNT(E.codigo)
FROM departamento D
FULL JOIN empleado E
ON E.codigo_departamento = D.codigo
GROUP BY D.nombre
ORDER BY D.nombre

/* 12.	Calcula el número de empleados que trabajan en cada uno de los departamentos que tienen un presupuesto 
        mayor a 200000 euros. */

SELECT D.nombre, COUNT(E.codigo)
FROM departamento D
INNER JOIN empleado E
ON E.codigo_departamento = D.codigo
GROUP BY D.nombre
HAVING D.nombre IN (SELECT nombre FROM departamento 
                        WHERE presupuesto > 200000)
ORDER BY D.nombre