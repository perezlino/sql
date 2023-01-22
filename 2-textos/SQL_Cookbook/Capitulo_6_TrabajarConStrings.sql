-- ======================================================
-- =============== TRABAJAR CON STRINGS =================
-- ======================================================

-------------------
--- Ejemplo 6.1 ---
-------------------

USE SQLCookbook
GO

SELECT * FROM t10
SELECT * FROM emp

SELECT SUBSTRING(e.ename,iter.pos,1) as C
FROM (SELECT ename FROM emp WHERE ename = 'KING') e,
(SELECT id AS pos FROM t10) iter
WHERE iter.pos <= LEN(e.ename)

--Utilizando DATALENGHT envez de LEN
SELECT SUBSTRING(e.ename,iter.pos,1) as C
FROM (SELECT ename FROM emp WHERE ename = 'KING') e,
(SELECT id AS pos FROM t10) iter
WHERE iter.pos <= DATALENGTH(e.ename)

-------------------
--- Ejemplo 6.2 ---
-------------------
/* Ejemplos de como insertar una ' en cadenas de texto */

SELECT * FROM t1

--De acuerdo a la cantidad de filas que tenga la tabla utilizada, será el n° de repeticiones del
--texto que precede al SELECT 
SELECT 'g''day mate' qmarks FROM emp UNION ALL
SELECT 'beavers'' teeth' FROM t1 UNION ALL
SELECT '''' FROM t1

--Otro ejemplo 
select 'apples core', 'apple''s core',
        case when '' is null then 0 else 1 end
  from t1

-------------------
--- Ejemplo 6.3 ---
-------------------

--Se quiere determinar cuántas comas hay en la cadena--
select (LEN('10,CLARK,MANAGER') - LEN(REPLACE('10,CLARK,MANAGER',',','')))/LEN(',')
        as cnt
   from t1

-------------------
--- Ejemplo 6.4 ---
-------------------

--Eliminar los caracteres no deseados de una cadena
--Desea eliminar todos los ceros y vocales, como se muestra en los siguientes valores en las 
--columnas STRIPPED1 y STRIPPED2:
select ename,
        replace(translate(ename,'AEIOU','aaaaa'),'a','') as stripped1,
        sal,
        replace(cast(sal as char(4)),'0','') as stripped2
   from emp

-------------------
--- Ejemplo 6.5 ---
-------------------

--Separación de datos numéricos y de caracteres

SELECT 
REPLACE(TRANSLATE(data,'0123456789','0000000000'),'0','') as ENAME,
CAST(REPLACE(TRANSLATE(LOWER(data),'abcdefghijklmnopqrstuvwxyz',REPLICATE('z',26)),'z','') as integer) as SAL
FROM (
  SELECT CONCAT(ename,sal) as data
   from emp
     ) x

-------------------
--- Ejemplo 6.6 ---
-------------------

--Determinar si una cadena es alfanumérica
/* Se desea devolver filas de una tabla sólo cuando una columna de interés no contenga más caracteres 
   que números y letras.  */

--Considere la siguiente vista V 
CREATE VIEW V2 AS
select ename as data
  from emp
 where deptno=10
 union all
select ename + ', $' + cast(sal as char(4)) + '.00' as data
  from emp
 where deptno=20
 union all
select ename + cast(deptno as char(4)) as data
  from emp
 where deptno=30

--Vamos a resolverlo: Solo obtenemos aquellas filas donde no se tengan caracteres especiales como $.
--Originalmente eran 14 filas y con esta sentencia se devuelven 9
SELECT data
FROM V2
WHERE TRANSLATE(LOWER(data),'0123456789abcdefghijklmnopqrstuvwxyz',REPLICATE('a',36)) = REPLICATE('a',LEN(data))

-------------------
--- Ejemplo 6.7 ---  (PREGUNTAR NO RESULTA)
-------------------

--Extraer las iniciales de un nombre.Se busca convertir solo las minusculas a #. 
SELECT 
REPLACE(REPLACE(TRANSLATE(REPLACE('Stewie Griffin', '.', ''),'abcdefghijklmnopqrstuvwxyz',REPLICATE('#',26) ), '#','' ),' ','.' ) + '.'
FROM t1

-------------------
--- Ejemplo 6.8 ---
-------------------

--Ordenar los valores del campo por los dos últimos caracteres
SELECT ENAME
FROM emp
ORDER BY SUBSTRING(ename,LEN(ename)-1,2)

-------------------
--- Ejemplo 6.9 ---
-------------------

--Ordenar por un número en una cadena

CREATE VIEW V3 AS
select e.ename +' '+
        cast(e.empno as char(4))+' '+
        d.dname as data
  from emp e, dept d
 where e.deptno=d.deptno

 SELECT * FROM V3

 SELECT data
 FROM V3
 ORDER BY REPLACE(TRANSLATE(data,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',REPLICATE('#',26)),'#','')

--------------------
--- Ejemplo 6.10 ---
--------------------

--Creación de una lista delimitada a partir de las filas de la tabla

SELECT deptno,STRING_AGG(ename, ',') WITHIN GROUP (ORDER BY empno) as emps
FROM emp
GROUP BY deptno

--------------------
--- Ejemplo 6.13 --- (PREGUNTAR, NO APARECE SOLUCION SQL SERVER)
--------------------

--Identificacion de cadenas que pueden ser tratadas como numeros--


--------------------
--- Ejemplo 6.13 --- 
--------------------

--Extracción de la enésima subcadena delimitada--

create view P as
select 'mo,larry,curly' as name
  from t1
 union all
select 'tina,gina,jaunita,regina,leena' as name
  from t1

select * from P

--Solucion
with agg_tab(name)
     as
     (select STRING_AGG(name,',') from P)
 select value from
     STRING_SPLIT(
     (select name from agg_tab),',')