-- ======================================================
-- ====================== CONSULTAS  ====================
-- ======================================================

USE EJERCICIOS 

SELECT * FROM departamento
SELECT * FROM empleado

-- 1.	Lista el primer apellido de todos los empleados

SELECT apellido_paterno FROM empleado
ORDER BY apellido_paterno

-- 2.	Lista el primer apellido de los empleados eliminando los apellidos que estén repetidos

SELECT DISTINCT apellido_paterno FROM empleado
ORDER BY apellido_paterno

-- 3.	Lista todas las columnas de la tabla empleado

SELECT * FROM empleado

-- 4.	Lista el nombre y los apellidos de todos los empleados

SELECT nombre, apellido_paterno, apellido_materno FROM empleado

-- 5.	Lista el código de los departamentos de los empleados que aparecen en la tabla Empleado

SELECT codigo_departamento FROM empleado

-- 6.	Lista el código de los departamentos de los empleados que aparecen en la tabla Empleado, 
--      eliminando los códigos que aparecen repetidos

SELECT DISTINCT codigo_departamento FROM empleado
WHERE codigo_departamento IS NOT NULL

-- 7.	Lista el nombre y apellidos de los empleados en una única columna

SELECT CONCAT_WS(' ', nombre, apellido_paterno, apellido_materno) nombre_completo
FROM empleado

-- 8.	Lista el nombre y apellidos de los empleados en una única columna, convirtiendo todos los 
--      caracteres en mayúscula

SELECT UPPER(CONCAT_WS(' ', nombre, apellido_paterno, apellido_materno)) nombre_completo
FROM empleado

-- 9.	Lista el nombre y apellidos de los empleados en una única columna, convirtiendo todos los 
--      caracteres en minúscula.

SELECT LOWER(CONCAT_WS(' ', nombre, apellido_paterno, apellido_materno)) nombre_completo
FROM empleado

-- 10.	Lista el código de los empleados junto al nif, pero el nif deberá aparecer en dos columnas, 
--      una mostrará únicamente los dígitos del nif y la otra la letra.

SELECT codigo, LEFT(nif, LEN(nif)-1), RIGHT(nif,1)
FROM empleado

/* 11.	Lista el nombre de cada departamento y el valor del presupuesto actual del que dispone. Para 
        calcular este dato tendrá que restar al valor del presupuesto inicial (columna presupuesto ) 
        los gastos que se han generado (columna gastos ). Tenga en cuenta que en algunos casos pueden 
        existir valores negativos. Utilice un alias apropiado para la nueva columna que está calculando.  */

SELECT nombre AS Departamento,
       (presupuesto - gastos) AS Presupuesto_actual
FROM departamento

-- 12.	Lista el nombre de los departamentos y el valor del presupuesto actual ordenado de forma ascendente.

SELECT nombre AS Departamento,
       (presupuesto - gastos) AS Presupuesto_actual
FROM departamento
ORDER BY Presupuesto_actual

-- 13.	Lista el nombre de todos los departamentos ordenados de forma ascendente.

SELECT nombre FROM departamento
ORDER BY nombre

-- 14.	Lista el nombre de todos los departamentos ordenados de forma ascendente.

SELECT nombre FROM departamento
ORDER BY nombre DESC

-- 15.	Lista los apellidos y el nombre de todos los empleados, ordenados de forma alfabética teniendo en 
--      cuenta en primer lugar sus apellidos y luego su nombre.

SELECT apellido_paterno, nombre FROM empleado
ORDER BY apellido_paterno

-- 16.	Devuelve una lista con el nombre y el presupuesto, de los 3 departamentos que tienen mayor presupuesto

SELECT TOP 3 nombre, presupuesto FROM departamento
ORDER BY presupuesto DESC

-- 17.	Devuelve una lista con el nombre y el presupuesto, de los 3 departamentos que tienen menor presupuesto.

SELECT TOP 3 nombre, presupuesto FROM departamento
ORDER BY presupuesto

-- 18.	Devuelve una lista con el nombre y el gasto, de los 2 departamentos que tienen mayor gasto.

SELECT TOP 2 nombre, gastos FROM departamento
ORDER BY gastos DESC

SELECT nombre, gastos FROM departamento
ORDER BY gastos DESC
OFFSET 0 ROWS
FETCH NEXT 2 ROWS ONLY

-- 19.	Devuelve una lista con el nombre y el gasto, de los 2 departamentos que tienen menor gasto.

SELECT TOP 2 nombre, gastos FROM departamento
ORDER BY gastos

SELECT nombre, gastos FROM departamento
ORDER BY gastos
OFFSET 0 ROWS
FETCH NEXT 2 ROWS ONLY

/* 20.	Devuelve una lista con 5 filas a partir de la tercera fila de la tabla empleado . La tercera fila se 
        debe incluir en la respuesta. La respuesta debe incluir todas las columnas de la tabla empleado . */

SELECT * FROM empleado
ORDER BY codigo
OFFSET 2 ROWS
FETCH NEXT 5 ROWS ONLY

-- 21.	Devuelve una lista con el nombre de los departamentos y el presupuesto, de aquellos que tienen un
--      presupuesto mayor o igual a 150000 euros.

SELECT nombre, presupuesto FROM departamento 
WHERE presupuesto >= 150000

-- 22.	Devuelve una lista con el nombre de los departamentos y el gasto, de aquellos que tienen menos de 
--      5000 euros de gastos.

SELECT nombre, gastos FROM departamento 
WHERE gastos < 5000

/* 23.	Devuelve una lista con el nombre de los departamentos y el presupuesto, de aquellos que tienen un 
        presupuesto entre 100000 y 200000 euros. Sin utilizar el operador BETWEEN  */
 
SELECT nombre, presupuesto FROM departamento
WHERE presupuesto >= 100000
and presupuesto <= 200000

/* 24.	Devuelve una lista con el nombre de los departamentos que no tienen un presupuesto entre 100000 y 
        200000 euros. Sin utilizar el operador BETWEEN .  */

SELECT nombre, presupuesto FROM departamento
WHERE presupuesto < 100000
AND presupuesto > 200000

/* 25.	Devuelve una lista con el nombre de los departamentos que tienen un presupuesto entre 100000 y 
        200000 euros. Utilizando el operador BETWEEN .  */

SELECT nombre, presupuesto FROM departamento
WHERE presupuesto BETWEEN 100000 AND 200000

/* 26.	Devuelve una lista con el nombre de los departamentos que no tienen un presupuesto entre 100000 
        y 200000 euros. Utilizando el operador BETWEEN .  */

SELECT nombre, presupuesto FROM departamento
WHERE presupuesto NOT BETWEEN 100000 AND 200000

/* 27.	Devuelve una lista con el nombre de los departamentos, gastos y presupuesto, de aquellos departamentos 
        donde los gastos sean mayores que el presupuesto del que disponen.  */

SELECT nombre, presupuesto, gastos FROM departamento
WHERE gastos > presupuesto

/* 28.	Devuelve una lista con el nombre de los departamentos, gastos y presupuesto, de aquellos departamentos 
        donde los gastos sean menores que el presupuesto del que disponen.  */

SELECT nombre, presupuesto, gastos FROM departamento
WHERE gastos < presupuesto

/* 29.	Devuelve una lista con el nombre de los departamentos, gastos y presupuesto, de aquellos departamentos 
        donde los gastos sean iguales al presupuesto del que disponen.  */

SELECT nombre, presupuesto, gastos FROM departamento
WHERE gastos = presupuesto

-- 30.	Lista todos los datos de los empleados cuyo segundo apellido sea NULL .

SELECT * FROM empleado
WHERE apellido_materno IS NULL

-- 31.	Lista todos los datos de los empleados cuyo segundo apellido no sea NULL .

SELECT * FROM empleado
WHERE apellido_materno IS NOT NULL

-- 32.	Lista todos los datos de los empleados cuyo segundo apellido sea López

SELECT * FROM empleado
WHERE apellido_materno = 'Lopez'

/* 33.	Lista todos los datos de los empleados cuyo segundo apellido sea Díaz o Moreno . Sin utilizar el 
        operador IN .  */

SELECT * FROM empleado
WHERE apellido_materno = 'Lopez' 
OR apellido_materno = 'Moreno' 

/* 34.	Lista todos los datos de los empleados cuyo segundo apellido sea Díaz o Moreno . Utilizando el 
        operador IN .  */

SELECT * FROM empleado
WHERE apellido_materno IN ('Lopez', 'Moreno' )

-- 35.	Lista los nombres, apellidos y nif de los empleados que trabajan en el departamento 3 .

SELECT nombre, apellido_paterno, apellido_materno, nif
FROM empleado
WHERE codigo_departamento = 3

-- 36.	Lista los nombres, apellidos y nif de los empleados que trabajan en los departamentos 2 , 4 o 5

SELECT nombre, apellido_paterno, apellido_materno, nif
FROM empleado
WHERE codigo_departamento IN (2,4,5)