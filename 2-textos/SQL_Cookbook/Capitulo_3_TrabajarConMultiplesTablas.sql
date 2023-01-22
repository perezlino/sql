-- ======================================================
-- ============ TRABAJAR CON MÚLTIPLES TABLAS ===========
-- ======================================================

---------------------------------------
--- 3.1.Apilar un Rowset sobre otro ---
---------------------------------------

/* Quiere mostrar el nombre y el número de departamento de los empleados del departamento 10 
   en la tabla EMP, junto con el nombre y el número de departamento de cada departamento en la 
   tabla DEPT */

SELECT ENAME AS ENAME_AND_DNAME,DEPTNO
FROM emp
WHERE DEPTNO = 10
UNION ALL
SELECT '-----',NULL
FROM t1
UNION ALL
SELECT DNAME,DEPTNO
FROM dept

---------------------------------------
--- 3.2.Combinar filas relacionadas ---
---------------------------------------

/* Desea mostrar los nombres de todos los empleados del departamento 10 junto con la ubicación 
   del departamento de cada empleado */

select E.ENAME,D.LOC
FROM emp E
INNER JOIN
dept D 
ON D.DEPTNO = E.DEPTNO
WHERE E.DEPTNO = 10

-----------------------------------------------------
--- 3.3.Encontrar filas en común entre dos tablas ---
-----------------------------------------------------

CREATE VIEW A
AS
SELECT ENAME,JOB,SAL
FROM emp
WHERE JOB = 'CLERK'

SELECT * FROM A

/* Sólo se devuelven los empleados de la vista V. Sin embargo, la vista no muestra todas las 
   columnas posibles de EMP. Quiere devolver el EMPNO, ENAME, JOB, SAL y DEPTNO de todos los 
   empleados en EMP que coincidan con las filas de la vista V */

/* Haga un Join con las tablas en todas las columnas necesarias para devolver el resultado 
   correcto. Alternativamente, utilice la operación de conjunto INTERSECT para evitar realizar 
   un join y en su lugar devolver la intersección (filas comunes) de las dos tablas. */

--Forma 1--
SELECT E.EMPNO,E.ENAME,E.JOB,E.SAL,E.DEPTNO
FROM emp E,A
WHERE E.ENAME = A.ENAME
  AND E.JOB   = A.JOB
  AND E.SAL   = A.SAL

--Forma 2--
SELECT E.EMPNO,E.ENAME,E.JOB,E.SAL,E.DEPTNO
FROM emp E INNER JOIN A 
ON
E.ENAME = A.ENAME
AND E.JOB   = A.JOB
AND E.SAL   = A.SAL

-----------------------------------------------------------------------
--- 3.4.Recuperación de valores de una tabla que no existen en otra ---
-----------------------------------------------------------------------

/* Quiere encontrar qué departamentos (si los hay) de la tabla DEPT no existen en la tabla EMP */

SELECT DEPTNO --Va primero la tabla dept
FROM dept
EXCEPT
SELECT DEPTNO
FROM emp

SELECT * FROM emp
SELECT * FROM dept

----------------------------------------------------------------------------------
--- 3.5.Recuperación de filas de una tabla que no corresponden a filas de otra ---
----------------------------------------------------------------------------------

/* Se desea encontrar filas que se encuentran en una tabla y que no tienen una coincidencia en 
   otra tabla, para dos tablas que tienen claves comunes. Por ejemplo, quiere encontrar qué 
   departamentos no tienen empleados*/

--1era Forma--
SELECT D.DEPTNO,D.DNAME,D.LOC
FROM dept D
WHERE NOT EXISTS (
	SELECT DEPTNO FROM emp E WHERE E.DEPTNO = D.DEPTNO)

--2da Forma--
SELECT D.*
FROM dept D LEFT JOIN emp E
ON (D.DEPTNO = E.DEPTNO)
WHERE E.DEPTNO IS NULL

----------------------------------------------------------------------
--- 3.6.Añadir Joins a una consulta sin interferir con otros Joins ---
----------------------------------------------------------------------

/* Tiene una consulta que devuelve los resultados que desea. Necesita información adicional, 
   pero al intentar obtenerla, pierde datos del conjunto de resultados original. Por ejemplo, 
   quiere devolver todos los empleados, la ubicación del departamento en el que trabajan y la 
   fecha en la que recibieron una bonificación. Para este problema, la tabla EMP_BONUS contiene 
   los siguientes datos: */

SELECT E.ENAME,D.LOC,EB.RECEIVED
FROM emp E INNER JOIN dept D 
ON D.DEPTNO = E.DEPTNO	
LEFT JOIN emp_bonus EB
ON EB.EMPNO = E.EMPNO
ORDER BY D.LOC

------------------------------------------------------------
--- 3.7.Determinar si dos tablas tienen los mismos datos ---
------------------------------------------------------------

/* Se quiere determinar si esta vista tiene exactamente los mismos datos que la tabla EMP. La 
   fila del empleado WARD está duplicada para mostrar que la solución no sólo revelará datos 
   diferentes sino también duplicados. Basándose en las filas de la tabla EMP, la diferencia 
   serán las tres filas de los empleados del departamento 10 y las dos filas del empleado WARD */

CREATE VIEW B
AS
SELECT * FROM emp WHERE DEPTNO != 10
 UNION ALL
SELECT * FROM emp WHERE ENAME = 'WARD'

SELECT * FROM B

/* */
SELECT * FROM (
	SELECT E.EMPNO,E.ENAME,E.JOB,E.MGR,E.HIREDATE,E.SAL,E.COMM,E.DEPTNO, COUNT(*) AS CNT
	FROM emp E
	GROUP BY EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) E
	WHERE NOT EXISTS (
		SELECT NULL FROM (
			SELECT B.EMPNO,B.ENAME,B.JOB,B.MGR,B.HIREDATE,B.SAL,B.COMM,B.DEPTNO, COUNT(*) AS CNT
			FROM B
			GROUP BY EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) B
			WHERE   B.EMPNO     = E.EMPNO
				AND B.ENAME    = E.ENAME
				AND B.JOB      = E.JOB
				AND COALESCE(B.MGR,0) = COALESCE(E.MGR,0)
				AND B.HIREDATE = E.HIREDATE
				AND B.SAL      = E.SAL
				AND B.DEPTNO   = E.DEPTNO
				AND B.CNT      = E.CNT
				AND COALESCE(B.COMM,0) = COALESCE(E.COMM,0)
				)
    UNION ALL
    SELECT * FROM (
	    SELECT B.EMPNO,B.ENAME,B.JOB,B.MGR,B.HIREDATE,B.SAL,B.COMM,B.DEPTNO, COUNT(*) AS CNT
        FROM B
        GROUP BY EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) V
        WHERE NOT EXISTS (
			   SELECT NULL FROM (
				   SELECT E.EMPNO,E.ENAME,E.JOB,E.MGR,E.HIREDATE,E.SAL,E.COMM,E.DEPTNO, COUNT(*) AS CNT
				   FROM EMP E
                   GROUP BY EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) E
			       WHERE V.EMPNO      = E.EMPNO
					  AND V.ENAME     = E.ENAME
					  AND V.JOB       = E.JOB
					  AND COALESCE(V.MGR,0) = COALESCE(E.MGR,0)
					  AND V.HIREDATE  = E.HIREDATE
					  AND V.SAL       = E.SAL
					  AND V.DEPTNO    = E.DEPTNO
					  AND V.CNT       = E.CNT
					  AND COALESCE(V.COMM,0) = COALESCE(E.COMM,0)
				  )

----------------------------------------------------------
--- 3.8.Identificar y evitar los productos cartesianos ---
----------------------------------------------------------

/* Se desea devolver el nombre de cada empleado del departamento 10 junto con la ubicación del 
   departamento. */

--Forma 1--
SELECT E.ENAME, D.LOC
FROM emp E INNER JOIN dept D
ON D.DEPTNO = E.DEPTNO
WHERE E.DEPTNO = 10

--Forma 2--
SELECT E.ENAME, D.LOC
FROM emp E, dept D
WHERE E.DEPTNO = 10
	AND E.DEPTNO = D.DEPTNO

-------------------------------------------------------------
--- 3.9.Realización de Joins cuando se utilizan agregados ---
-------------------------------------------------------------

/* Desea encontrar la suma de los salarios de los empleados del departamento 10 junto con la suma 
   de sus bonificaciones. */

/* Ahora, considere la siguiente consulta que devuelve salary y bonus de todos los empleados del 
   departamento 10. La tabla emp_bonus2.TYPE determina el importe de la bonificación. Una bonificación de 
   tipo 1 es el 10% del salario de un empleado, la de tipo 2 es el 20% y la de tipo 3 es el 30%. */

SELECT * FROM emp
SELECT * FROM emp_bonus2

--Primer paso: Se duplica el EMPNO = 7934 dado, que tiene 2 bonificaciones. Eso es generará un valor
--erróneo al momento de sumar la totalidad de los salarios, dado que aparece dos veces el salario de
--este registro.

SELECT E.EMPNO,E.ENAME,E.SAL,E.DEPTNO,
       E.SAL * CASE
			     WHEN EB.TYPE = 1 THEN .1
				 WHEN EB.TYPE = 2 THEN .2
				 ELSE .3
			   END BONUS
FROM emp E,emp_bonus2 EB
WHERE E.EMPNO = EB.EMPNO
AND E.DEPTNO = 10
 
--Segundo paso: Al realizar la agregacion vemos que el valor total de salario para el EMPNO = 7934 es
--igual a 2600, siendo que solo debiera aparecer 1300.

SELECT EMPNO,ENAME,DEPTNO, SUM(SAL) AS TOTAL_SAL, SUM(BONUS) AS TOTAL_BONUS
FROM (
		SELECT E.EMPNO,E.ENAME,E.SAL,E.DEPTNO,
			   E.SAL * CASE
						 WHEN EB.TYPE = 1 THEN .1
						 WHEN EB.TYPE = 2 THEN .2
						 ELSE .3
					   END BONUS
		FROM emp E,emp_bonus2 EB
		WHERE E.EMPNO = EB.EMPNO
		AND E.DEPTNO = 10
	 ) A
GROUP BY EMPNO,ENAME,DEPTNO

--La solución a esto es utilizando un DISTINCT en la suma:

SELECT EMPNO,ENAME,DEPTNO, SUM(DISTINCT SAL) AS TOTAL_SAL, SUM(BONUS) AS TOTAL_BONUS
FROM (
		SELECT E.EMPNO,E.ENAME,E.SAL,E.DEPTNO,
			   E.SAL * CASE
						 WHEN EB.TYPE = 1 THEN .1
						 WHEN EB.TYPE = 2 THEN .2
						 ELSE .3
					   END BONUS
		FROM emp E,emp_bonus2 EB
		WHERE E.EMPNO = EB.EMPNO
		AND E.DEPTNO = 10
	 ) A
GROUP BY EMPNO,ENAME,DEPTNO

-------------------------------------------------------------
--- 3.11.Devolución de datos perdidos de múltiples tablas ---
-------------------------------------------------------------

/* Desea devolver los datos que faltan de varias tablas simultáneamente. La devolución de filas de 
   la tabla DEPT que no existen en la tabla EMP (cualquier departamento que no tenga empleados) 
   requiere un outer join. Considere la siguiente consulta, que devuelve todos los DEPTNOs y DNAMEs 
   de DEPT junto con los nombres de todos los empleados en cada departamento (si hay un empleado en 
   un departamento particular) */


select d.deptno,d.dname,e.ename
  from dept d left outer join emp e
    on (d.deptno=e.deptno)

select d.deptno,d.dname,e.ename
  from dept d right outer join emp e
    on (d.deptno=e.deptno)

--Por lo tanto, utilizamos FULL JOIN--
SELECT D.DEPTNO,D.DNAME,E.ENAME
FROM dept D FULL JOIN emp E
ON E.DEPTNO = D.DEPTNO

--------------------------------------------------------
--- 3.12.Uso de NULLs en operaciones y comparaciones ---
--------------------------------------------------------

/* NULL nunca es igual o no igual a ningún valor, ni siquiera a sí mismo, pero usted quiere evaluar 
   los valores devueltos por una columna nulable como evaluaría los valores reales. Por ejemplo, 
   quiere encontrar todos los empleados en EMP cuya comisión (COMM) es menor que la comisión del 
   empleado WARD. Los empleados con una comisión NULL deben ser incluidos también. */

SELECT EMPNO,ENAME,COMM,COALESCE(COMM,0)
FROM emp
WHERE COALESCE(COMM,0) < (SELECT COMM FROM emp WHERE ENAME = 'WARD')