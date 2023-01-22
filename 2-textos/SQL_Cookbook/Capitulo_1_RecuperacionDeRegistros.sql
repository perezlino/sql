-- ======================================================
-- ============== RECUPERACION DE REGISTROS =============
-- ======================================================

-------------------------------------------------------------
--- 1.1.Recuperar todas las filas y columnas de una tabla ---
-------------------------------------------------------------

SELECT * FROM emp

----------------------------------------------------------------
--- 1.2.Recuperación de un subconjunto de filas de una tabla ---
----------------------------------------------------------------

/* Utilice la cláusula WHERE para especificar las filas que debe conservar. Por ejemplo, para 
   ver todos los empleados asignados al departamento número 10: */

SELECT * FROM emp
WHERE DEPTNO = 10

----------------------------------------------------------------
--- 1.3.Encontrar filas que satisfagan múltiples condiciones ---
----------------------------------------------------------------

/* Utilice la cláusula WHERE junto con las cláusulas OR y AND. Por ejemplo, si desea encontrar 
   todos los empleados del departamento 10, junto con los empleados que ganan una comisión, 
   junto con los empleados del departamento 20 que ganan como máximo $2,000 */

SELECT * FROM emp
WHERE DEPTNO = 10
OR COMM IS NOT NULL
OR DEPTNO = 20 AND SAL <= 2000

-------------------------------------------------------------
--- 1.4.Recuperar un subconjunto de columnas de una tabla ---
-------------------------------------------------------------

/* Especifique las columnas que le interesan. Por ejemplo, para ver sólo el nombre, el 
   departamento y el salario de los empleados: */

SELECT ENAME,DEPTNO,SAL 
FROM emp

-----------------------------------------------------
--- 1.5.Dar nombres significativos a las columnas ---
-----------------------------------------------------

/* Desea cambiar los nombres de las columnas devueltas por su consulta para que sean más 
   legibles y comprensibles. Considere esta consulta que devuelve los salarios y comisiones 
   de cada empleado: */

SELECT SAL AS Salario, COMM AS Comisión
FROM emp

-------------------------------------------------------------------
--- 1.6.Referencia a una Columna con alias en la Cláusula WHERE ---
-------------------------------------------------------------------

--Forma incorrecta--
SELECT SAL AS Salario, COMM AS Comisión
FROM emp
WHERE Salario < 5000

--Forma correcta--
SELECT *
FROM (SELECT SAL AS Salario, COMM AS Comisión FROM emp) AS M
WHERE Salario < 5000

-----------------------------------------
--- 1.7.Concatenar valores de columna ---
-----------------------------------------

/* Desea devolver los valores de varias columnas como una sola columna. Por ejemplo, le 
   gustaría producir este conjunto de resultados a partir de una consulta contra la tabla EMP 

									CLARK WORKS AS A MANAGER 
									KING WORKS AS A PRESIDENT 
									MILLER WORKS AS A CLERK
*/
SELECT CONCAT(ENAME,' WORKS AS A ',JOB) 
FROM emp
WHERE DEPTNO = 10

SELECT ENAME + ' WORKS AS A ' + JOB
FROM emp
WHERE DEPTNO = 10

SELECT CONCAT_WS(' WORKS AS A ',ENAME,JOB)
FROM emp
WHERE DEPTNO = 10

----------------------------------------------------------------
--- 1.8.Uso de la lógica condicional en una sentencia SELECT ---
----------------------------------------------------------------

/* Desea realizar operaciones IF-ELSE en los valores de su sentencia SELECT. Por ejemplo, le 
   gustaría producir un conjunto de resultados tal que si un empleado cobra 2.000 dólares o 
   menos, se devuelva un mensaje de "UNDERPAID"; si un empleado cobra 4.000 dólares o más, 
   se devuelva un mensaje de "OVERPAID"; y si hacen algo intermedio, se devuelva "OK". El 
   conjunto de resultados debería tener el siguiente aspecto: */

SELECT ENAME,SAL,
	CASE
		WHEN SAL <= 2000 THEN 'UNDERPAID'
		WHEN SAL >= 4000 THEN 'OVERPAID'
		ELSE 'OK'
	END 'STATUS'
FROM emp

------------------------------------------------
--- 1.9.Limitar el número de filas devueltas ---
------------------------------------------------

--Utilice la palabra clave TOP para restringir el número de filas devueltas:
SELECT TOP 5 * 
FROM emp

-- Segunda forma
SET ROWCOUNT 5
SELECT * FROM emp

-- Tercera forma
SELECT * 
FROM emp
ORDER BY EMPNO  --> Se debe utilizar ORDER BY para usar OFFSET-FETCH
OFFSET 0 ROWS
FETCH NEXT 5 ROWS ONLY

--POSTGRESQL
SELECT * FROM emp
WHERE DEPTNO BETWEEN 20 AND 30
ORDER BY DEPTNO ASC
LIMIT 5;

--------------------------------------------------------------
--- 1.10.Devolución de n registros aleatorios de una tabla ---
--------------------------------------------------------------

/* Utilice la función incorporada NEWID junto con TOP y ORDER BY para devolver un conjunto 
   de resultados aleatorios: */

SELECT TOP 5 ENAME, JOB
FROM emp
ORDER BY NEWID()

SELECT * FROM emp

--------------------------------------
--- 1.11.Búsqueda de valores nulos ---
--------------------------------------

/* Desea encontrar todas las filas que son nulas para una columna en particular. */

SELECT * FROM emp
WHERE COMM IS NULL

------------------------------------------------------
--- 1.12.Transformación de nulos en valores reales ---
------------------------------------------------------

/* Tiene filas que contienen nulos y desea devolver valores no nulos en lugar de esos nulos.
   Utilice la función COALESCE para sustituir los nulos por valores reales. */

   --Forma 1--
SELECT COALESCE(COMM,0)
FROM emp

--Forma 2--
SELECT ENAME, 
	CASE
		WHEN COMM IS NOT NULL THEN COMM
		ELSE 0
	END
FROM emp

---------------------------------
--- 1.13.Búsqueda de patrones ---
---------------------------------

/* De los empleados de los departamentos 10 y 20, quiere devolver sólo aquellos que tengan 
   una "I" en algún lugar de su nombre o un cargo que termine en "ER": */

 SELECT ENAME,JOB
 FROM emp
 WHERE DEPTNO IN (10,20)
 AND
 (ENAME LIKE '%I%' OR JOB LIKE '%ER')