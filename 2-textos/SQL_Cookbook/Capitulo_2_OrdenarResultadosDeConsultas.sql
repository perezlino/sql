-- ======================================================
-- =========== ORDENAR RESULTADOS DE CONSULTAS ==========
-- ======================================================

--------------------------------------------------------------------------------
--- 2.1.Cómo devolver los resultados de la consulta en un orden especificado ---
--------------------------------------------------------------------------------

/* Desea mostrar los nombres, puestos de trabajo y salarios de los empleados del 
   departamento 10 en orden según su salario (de menor a mayor). Quiere devolver el 
   siguiente conjunto de resultados: */

SELECT ENAME,JOB,SAL
FROM emp
WHERE DEPTNO = 10
ORDER BY SAL ASC

-------------------------------------
--- 2.2.Ordenar por varios campos ---
-------------------------------------

/* Quiere ordenar las filas de EMP primero por DEPTNO de forma ascendente y luego por SAL de 
   forma descendente. Quiere devolver el siguiente conjunto de resultados: */

SELECT EMPNO,DEPTNO,SAL,ENAME,JOB
FROM emp
ORDER BY DEPTNO ASC,SAL DESC

-------------------------------------
--- 2.3.Ordenación por subcadenas ---
-------------------------------------

/* Quiere ordenar los resultados de una consulta por partes específicas de una cadena. Por 
   ejemplo, quiere devolver los nombres de los empleados y los puestos de trabajo de la tabla 
   EMP y ordenarlos por los dos últimos caracteres del campo JOB. El conjunto de resultados 
   debería tener el siguiente aspecto: */

SELECT ENAME,JOB
FROM emp
ORDER BY SUBSTRING(JOB,LEN(JOB)-1,2)

-------------------------------------------------------
--- 2.4.Clasificación de datos alfanuméricos mixtos ---
-------------------------------------------------------

/* Tiene datos alfanuméricos mixtos y quiere ordenar por la parte numérica o por la parte de 
   caracteres de los datos. Considere esta vista, creada a partir de la tabla EMP: */

CREATE VIEW V
AS
SELECT CONCAT(ENAME,' ',DEPTNO) AS Data
FROM emp

SELECT * FROM V

/* ORDER BY DEPTNO */

--Forma 1--
SELECT Data
FROM V
ORDER BY REPLACE(Data,
            REPLACE(
              TRANSLATE(Data,'0123456789','##########'),'#',''),'')

--Disección del código paso a paso--
SELECT TRANSLATE(Data,'0123456789','##########')  --Paso 1
FROM V

SELECT REPLACE(TRANSLATE(Data,'0123456789','##########'),'#','') -- Paso 2
FROM V

--Aqui finalmente captura los dos últimos digitos los que utilizará para dar el orden--
SELECT REPLACE(Data,REPLACE(TRANSLATE(Data,'0123456789','##########'),'#',''),'') -- Paso 3
FROM V

--Forma 2--
SELECT Data
FROM V
ORDER BY SUBSTRING(Data,LEN(Data)-2,LEN(Data))

         
/* ORDER BY ENAME */

--Forma 1--
SELECT Data
FROM V
ORDER BY REPLACE(TRANSLATE(Data,'0123456789','##########'),'#','')   

--Forma 2--
SELECT Data
FROM V
ORDER BY SUBSTRING(Data,1,CHARINDEX(' ',Data))

------------------------------------------------
--- 2.5.Como tratar con los nulos al ordenar ---
------------------------------------------------

/* Quiere ordenar los resultados de EMP por COMM, pero el campo es anulable. Necesita una forma 
   de especificar si los nulos se ordenan en último lugar: */

SELECT ENAME,SAL,COMM --De esta manera toma los nulos en primer lugar
FROM emp
ORDER BY COMM

/* LOS COMM NO NULOS ORDENADOS DE FORMA ASCENDENTE, TODOS LOS NULOS EN ÚLTIMO LUGAR */

SELECT ENAME,SAL,COMM                   ---De esta manera deja a los valores nulos al último
FROM (
   SELECT ENAME,SAL,COMM,
          CASE
            WHEN COMM is null THEN 0 
			ELSE 1 
		  END is_null
    FROM emp
     ) x
ORDER BY is_null DESC, COMM

/* LOS COMM NO NULOS ORDENADOS DE FORMA DESCENDENTE, TODOS LOS NULOS EN ÚLTIMO LUGAR */

SELECT ENAME,SAL,COMM                   ---De esta manera deja a los valores nulos al último
FROM (
   SELECT ENAME,SAL,COMM,
          CASE
            WHEN COMM is null THEN 0 
			ELSE 1 
		  END is_null
    FROM emp
     ) x
ORDER BY is_null DESC, COMM DESC

--O simplemente

SELECT ENAME,SAL,COMM 
FROM emp
ORDER BY COMM DESC

/* LOS COMM NO NULOS ORDENADOS DE FORMA ASCENDENTE, TODOS LOS NULOS PRIMERO */

SELECT ENAME,SAL,COMM                  
FROM (
   SELECT ENAME,SAL,COMM,
          CASE
            WHEN COMM is null THEN 1 
			ELSE 0 
		  END is_null
    FROM emp
     ) x
ORDER BY is_null DESC,COMM

--O simplemente

SELECT ENAME,SAL,COMM 
FROM emp
ORDER BY COMM

/* LOS COMM NO NULOS ORDENADOS DE FORMA DESCENDENTE, TODOS LOS NULOS PRIMERO */

SELECT ENAME,SAL,COMM                   
FROM (
   SELECT ENAME,SAL,COMM,
          CASE
            WHEN COMM is null THEN 1 
			ELSE 0 
		  END is_null
    FROM emp
     ) x
ORDER BY is_null DESC,COMM DESC

-----------------------------------------------------------------------
--- 2.6.Ordenación en función de una clave dependiente de los datos ---
-----------------------------------------------------------------------

/* Se desea ordenar en base a una lógica condicional. Por ejemplo, si JOB es SALESMAN, quiere 
   ordenar por COMM; de lo contrario, quiere ordenar por SAL */

SELECT ENAME,SAL,COMM,JOB
FROM emp
ORDER BY 
	CASE 
		WHEN JOB = 'SALESMAN' THEN COMM
		ELSE SAL
	END

/* Puede utilizar la expresión CASE para cambiar dinámicamente la ordenación de los resultados. 
   Los valores pasados al ORDER BY tienen el siguiente aspecto: */

SELECT ENAME,SAL,JOB,COMM,
		CASE
			WHEN JOB = 'SALESMAN' THEN COMM 
			ELSE SAL
		END AS Ordered
FROM emp
ORDER BY 5