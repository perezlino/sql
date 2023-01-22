-- ======================================================
-- ============== MANIPULACION DE FECHAS ================
-- ======================================================

-------------------
--- Ejemplo 9.1 ---
-------------------

--Cómo determinar si un año es bisiesto

 select coalesce
	        (day
			(cast(concat
			(year(getdate()),'-02-29')
			 as date))
			 ,28);

-------------------
--- Ejemplo 9.2 ---
-------------------

--Determinar el número de días de un año

 select datediff(d,curr_year,dateadd(yy,1,curr_year))
   from (
 select dateadd(d,-datepart(dy,getdate())+1,getdate()) curr_year
   from t1
        ) x

-------------------
--- Ejemplo 9.3 ---
-------------------

--Extraer unidades de tiempo de una fecha

 select datepart( hour, getdate()) hr,
        datepart( minute,getdate()) min,
        datepart( second,getdate()) sec,
        datepart( day, getdate()) dy,
        datepart( month, getdate()) mon,
        datepart( year, getdate()) yr
   from t1

-------------------
--- Ejemplo 9.4 ---
-------------------

--Determinar el primer y el último día de un mes

 select dateadd(day,-day(getdate())+1,getdate()) firstday,
        dateadd(day,
                -day(dateadd(month,1,getdate())),
                dateadd(month,1,getdate())) lastday
   from t1

-------------------
--- Ejemplo 9.5 ---
-------------------

--Determinación de todas las fechas de un determinado día de la semana a lo largo del año. En este 
--ejemplo se devuelven todos los viernes del año.

    with x (dy,yr)
      as (
  select dy, year(dy) yr
    from (
  select getdate()-datepart(dy,getdate())+1 dy
    from t1
         ) tmp1
   union all
  select dateadd(dd,1,dy), yr
   from x
  where year(dateadd(dd,1,dy)) = yr
 )
 select x.dy
   from x
  where datename(dw,x.dy) = 'Friday'
 option (maxrecursion 400)

-------------------
--- Ejemplo 9.6 ---
-------------------

--Determinación de la fecha de la primera y última aparición de un día de la semana en un mes
--Quiere encontrar, por ejemplo, el primer y el último lunes del mes actual.

    with x (dy,mth,is_monday)
      as (
  select dy,mth,
         case when datepart(dw,dy) = 2
              then 1 else 0
         end
    from (
  select dateadd(day,1,dateadd(day,-day(getdate()),getdate())) dy,
         month(getdate()) mth
   from t1
        ) tmp1
  union all
 select dateadd(day,1,dy),
        mth,
        case when datepart(dw,dateadd(day,1,dy)) = 2
             then 1 else 0
        end
   from x
  where month(dateadd(day,1,dy)) = mth
 )
 select min(dy) first_monday,
        max(dy) last_monday
   from x
  where is_monday = 1

-------------------
--- Ejemplo 9.7 ---
-------------------

--Crear un calendario

   with x(dy,dm,mth,dw,wk)
      as (
  select dy,
         day(dy) dm,
         datepart(m,dy) mth,
         datepart(dw,dy) dw,
         case when datepart(dw,dy) = 1
              then datepart(ww,dy)-1
              else datepart(ww,dy)
        end wk
   from (
 select dateadd(day,-day(getdate())+1,getdate()) dy
   from t1
        ) x
  union all
  select dateadd(d,1,dy), day(dateadd(d,1,dy)), mth,
         datepart(dw,dateadd(d,1,dy)),
         case when datepart(dw,dateadd(d,1,dy)) = 1
              then datepart(wk,dateadd(d,1,dy))  -1
              else datepart(wk,dateadd(d,1,dy))
         end
    from x
   where datepart(m,dateadd(d,1,dy)) = mth
 )
 select max(case dw when 2 then dm end) as Mo,
        max(case dw when 3 then dm end) as Tu,
        max(case dw when 4 then dm end) as We,
        max(case dw when 5 then dm end) as Th,
        max(case dw when 6 then dm end) as Fr,
        max(case dw when 7 then dm end) as Sa,
        max(case dw when 1 then dm end) as Su
   from x
  group by wk
  order by wk