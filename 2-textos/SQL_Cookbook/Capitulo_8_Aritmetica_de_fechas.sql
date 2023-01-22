-- ======================================================
-- =============== ARITMETICA DE FECHAS =================
-- ======================================================

-------------------
--- Ejemplo 8.1 ---
-------------------

--Sumar y restar días, meses y años

--CLARK fue contratado el 09-JUN-2006:

USE SQLCookbook
GO

 select dateadd(day,-5,hiredate)   as hd_minus_5D,
        dateadd(day,5,hiredate)    as hd_plus_5D,
        dateadd(month,-5,hiredate) as hd_minus_5M,
        dateadd(month,5,hiredate)  as hd_plus_5M,
        dateadd(year,-5,hiredate)  as hd_minus_5Y,
        dateadd(year,5,hiredate)   as hd_plus_5Y
   from emp
  where deptno = 10

-------------------
--- Ejemplo 8.2 ---
-------------------

--Determinar el número de días entre dos fechas

  select datediff(day,allen_hd,ward_hd)
    from (
  select hiredate as ward_hd
    from emp
   where ename = 'WARD'
         ) x,
         (
  select hiredate as allen_hd
    from emp
  where ename = 'ALLEN'
        ) y

-------------------
--- Ejemplo 8.3 ---
-------------------

--Determinar el número de días hábiles entre dos fechas

  select sum(case when datename(dw,jones_hd+t500.id-1)
                    in ( 'SATURDAY','SUNDAY' )
                   then 0 else 1
             end) as days
    from (
  selectmax(case when ename = 'BLAKE'
                  then hiredate
             end) as blake_hd,
         max(case when ename = 'JONES'
                 then hiredate
            end) as jones_hd
   from emp
  where ename in ( 'BLAKE','JONES' )
        ) x,
        t500
  where t500.id <= datediff(day,jones_hd-blake_hd)+1

-------------------
--- Ejemplo 8.4 ---
-------------------

--Determinar el número de meses o años entre dos fechas

	 select datediff(month,min_hd,max_hd),
	        datediff(year,min_hd,max_hd)
	   from (
	 select min(hiredate) min_hd, max(hiredate) max_hd
	   from emp
	        ) x

-------------------
--- Ejemplo 8.5 ---
-------------------

--Determinar el número de segundos, minutos u horas entre dos fechas

  select datediff(day,allen_hd,ward_hd,hour) as hr,
         datediff(day,allen_hd,ward_hd,minute) as min,
         datediff(day,allen_hd,ward_hd,second) as sec
    from (
  select max(case when ename = 'WARD'
                   then hiredate
             end) as ward_hd,
         max(case when ename = 'ALLEN'
                  then hiredate
            end) as allen_hd
   from emp
        ) x