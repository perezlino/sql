-- ======================================================
-- ================ TRABAJAR CON NUMEROS ================
-- ======================================================

-------------------
--- Ejemplo 7.1 ---
-------------------

--Calcular un promedio

USE SQLCookbook
GO

 select avg(sal) as avg_sal
   from emp

 select deptno, avg(sal) as avg_sal
   from emp
  group by deptno


-------------------
--- Ejemplo 7.2 ---
-------------------

--Encontrar el valor mínimo/máximo de una columna

 select min(sal) as min_sal, max(sal) as max_sal
     from emp

 select deptno, min(sal) as min_sal, max(sal) as max_sal
   from emp
   group by deptno

   SELECT * FROM emp

-------------------
--- Ejemplo 7.3 ---
-------------------

--Suma de los valores de una columna

 select sum(sal)
  from emp

 select deptno, sum(sal) as total_for_dept
   from emp
  group by deptno

-------------------
--- Ejemplo 7.4 ---
-------------------

--Contar filas en una tabla

 select count(*)
  from emp

 select deptno, count(*)
   from emp
  group by deptno


-------------------
--- Ejemplo 7.5 ---
-------------------

--Contar valores en una columna

select count(comm)
  from emp

-------------------
--- Ejemplo 7.6 ---
-------------------

--Generación de un total acumulado

 select ename, sal,
       sum(sal) over (order by sal,empno) as running_total
   from emp
   order by 2

-------------------
--- Ejemplo 7.7 ---
-------------------

--Generar un producto acumulado

 select empno,ename,sal,
        exp(sum(log(sal))over(order by sal,empno)) as running_prod
   from emp
  where deptno = 10

-------------------
--- Ejemplo 7.8 ---
-------------------

--Calcular una media móvil sumando el valor actual y los n-1 valores anteriores 

select date1, sales,lag(sales,1) over(order by date1) as salesLagOne,
lag(sales,2) over(order by date1) as salesLagTwo,
(sales
+ (lag(sales,1) over(order by date1))
+ lag(sales,2) over(order by date1))/3 as MovingAverage
from sales

-------------------
--- Ejemplo 7.9 ---
-------------------

--Calcular la moda

select sal
  from emp
 where deptno = 20
 order by sal


  select sal
    from (
  select sal,
         dense_rank()over( order by cnt desc) as rnk
    from (
  select sal, count(*) as cnt
    from emp
   where deptno = 20
  group by sal
        ) x
        ) y
  where rnk = 1

--------------------
--- Ejemplo 7.10 ---
--------------------

--Cálculo de la mediana

 select percentile_cont(0.5)
             within group(order by sal)
             over()
       from emp
      where deptno=20

--------------------
--- Ejemplo 7.11 ---
--------------------

--Determinar el porcentaje de un total

 select distinct (d10/total)*100 as pct
   from (
 select deptno,
        sum(sal)over() total,
        sum(sal)over(partition by deptno) d10
   from emp
        ) x

		--Segunda forma
select distinct
       cast(d10 as decimal)/total*100 as pct
  from (
select deptno,
       sum(sal)over() total,
       sum(sal)over(partition by deptno) d10
  from emp
       ) x
 where deptno=10

--------------------
--- Ejemplo 7.12 ---
--------------------

--Realizar una agregación en una columna, pero la columna es nullable. Quiere mantener la exactitud 
--de la agregación, pero le preocupa que las funciones de agregación ignoren los NULL

 select avg(coalesce(comm,0)) as avg_comm
   from emp
  where deptno=30

--------------------
--- Ejemplo 7.13 ---
--------------------

--Cálculo de medias sin valores altos y bajos

select sal, min(sal)over() min_sal, max(sal)over() max_sal
  from emp

 select avg(sal)
   from (
 select sal, min(sal)over() min_sal, max(sal)over() max_sal
   from emp
        ) x
  where sal not in (min_sal,max_sal)

--------------------
--- Ejemplo 7.14 ---
--------------------

--Convertir cadenas alfanuméricas en números

 select cast(
        replace(
      translate('paul123f321',
                 'abcdefghijklmnopqrstuvwxyz',
                 RPAD('#',26,'#')),'#','')
        as integer ) as num
   from t1