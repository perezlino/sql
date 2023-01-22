-- ======================================================
-- ====== INSERCIÓN - ACTUALIZACIÓN - ELIMINACIÓN =======
-- ======================================================

---------------------------------------------
--- 4.2. Inserción de valores por defecto ---
---------------------------------------------

--Supongamos que creamos la siguiente tabla--
CREATE TABLE D (id INT DEFAULT 0)

--Primera forma para insertar un valor por default--
INSERT INTO D VALUES (DEFAULT)

--Segunda forma--
INSERT INTO D (id) VALUES (DEFAULT)

-------------------------------------------------------
--- 4.3. Anulación de un valor por defecto con NULL ---
-------------------------------------------------------

--Supongamos que creamos la siguiente tabla--
CREATE TABLE X (
	id INT DEFAULT 0,
	foo VARCHAR(10))

--Puede especificar explícitamente NULL en su lista de valores:
INSERT INTO X (id,foo) VALUES (null, 'Brighten')

--Aquí no se especifica ningún valor para el ID. Muchos esperarían que la columna tomara el valor 
--nulo, pero, por desgracia, se especificó un valor por defecto en el momento de la creación de la 
--tabla
INSERT INTO X (foo) VALUES ('Brighten')

-------------------------------------------------------------
--- 4.9. Actualizar cuando existen filas correspondientes ---
-------------------------------------------------------------

--Se desea actualizar filas en una tabla cuando existen filas correspondientes en otra. Por ejemplo, 
--si un empleado aparece en la tabla EMP_BONUS, quiere aumentar el salario de ese empleado (en la 
--tabla EMP) en un 20%

UPDATE emp
	SET SAL = SAL * 1.20
	WHERE EMPNO IN (SELECT EMPNO from emp_bonus)

--Otra forma--
UPDATE emp
   SET SAL = SAL*1.20
 WHERE EXISTS ( SELECT null
                  FROM emp_bonus
                 WHERE emp.empno=emp_bonus.empno )

-----------------------------------------------------
--- 4.10. Actualización con valores de otra tabla ---
-----------------------------------------------------

/* Se desea actualizar las filas de una tabla utilizando los valores de otra. Por ejemplo, tiene 
   una tabla llamada NEW_SAL, que contiene los nuevos salarios de ciertos empleados. El contenido 
   de la tabla NEW_SAL es el siguiente: */

   SELECT * FROM new_sal

/* La columna DEPTNO es la clave primaria de la tabla NEW_SAL. Quiere actualizar los sueldos y 
   comisiones de ciertos empleados en la tabla EMP utilizando los valores de la tabla NEW_SAL si 
   hay una coincidencia entre EMP.DEPTNO y NEW_SAL.DEPTNO, actualizar EMP.SAL a NEW_SAL.SAL, y 
   actualizar EMP.COMM al 50% de NEW_SAL.SAL. */

UPDATE E
    SET E.SAL  = NS.SAL,
        E.COMM = NS.SAL/2
   FROM emp E,
        new_sal NS
  WHERE NS.DEPTNO = E.DEPTNO

--------------------------------
--- 4.11. Combinar registros --- (REVISAR NO ME FUNCIONA)
--------------------------------

/* Desea insertar, actualizar o eliminar condicionalmente registros en una tabla dependiendo de si 
   existen los registros correspondientes. (Si un registro existe, se actualiza; si no, se inserta; 
   si después de actualizar una fila no cumple una determinada condición, se elimina). Por ejemplo, 
   se desea modificar la tabla EMP_COMMISSION de forma que:

?	Si cualquier empleado en EMP_COMMISSION también existe en la tabla EMP, entonces actualice su 
    comisión (COMM) a 1000.

?	Para todos los empleados que potencialmente tendrán su COMM actualizada a 1000, si su SAL es 
    inferior a 2000, elimínelos (no deben existir en EMP.COMMISSION).

?	En caso contrario, inserte los valores EMPNO, ENAME y DEPTNO de la tabla EMP en la tabla 
    EMP_COMMISSION.   */

SELECT * FROM emp_comission

merge into emp_comission ec
using (select * from emp) emp
on (ec.empno=emp.empno)
when matched then
update set ec.comm = 1000
delete where (sal < 2000)
when not matched then
insert (ec.empno,ec.ename,ec.deptno,ec.comm)
values (emp.empno,emp.ename,emp.deptno,emp.comm)

-----------------------------------------
--- 4.16. Borrar registros duplicados ---
-----------------------------------------

SELECT * FROM dupes

DELETE FROM dupes
WHERE id NOT IN (SELECT MIN(id)
					FROM dupes
					GROUP BY name)

-------------------------------------------------------------
--- 4.17. Borrar registros referenciados desde otra tabla ---
-------------------------------------------------------------

/* Se desea eliminar del EMP los registros de aquellos empleados que trabajan en un departamento que 
   tiene tres o más accidentes. */

SELECT * FROM dept_accidents

DELETE FROM emp
WHERE DEPTNO IN (SELECT DEPTNO
                   FROM dept_accidents 
				   GROUP BY DEPTNO 
				   HAVING COUNT(*) >= 3)