-- ============================================================
-- ======================= SUBCONSULTAS =======================
-- ============================================================

/*|-----------------------------------------------------------------------------------------|
  | La consulta interna se evaluará primero, y la consulta externa recibe los valores de la |
  | consulta interna.                                                                       |  
  |-----------------------------------------------------------------------------------------| */

/*|-----------------------------------------------------------------------------------------|
  | NOTA: Una consulta interna también puede estar anidada en una sentencia INSERT, UPDATE o| 
  | DELETE.                                      
  |-----------------------------------------------------------------------------------------| */

/*|-----------------------------------------------------------------------------------------| 
  | Hay dos tipos de subconsultas:                                                          |
  |                                                                                         |
  |                                                                                         |
  | - Autocontenidas: la consulta interna se evalúa lógicamente una sola vez.               |
  |                                                                                         |
  |   Una subconsulta autocontenida puede utilizarse con los siguientes operadores:         |
  |                                                                                         |
  |	 - Operadores de comparación                                                            |
  |                                                                                         |
  |		- Operador IN                                                                       |
  |     - Operador ANY o ALL                                                                |
  |                                                                                         |
  | - Correlación: su valor depende de una variable de la consulta externa. Por lo tanto, la| 
  |                consulta interna de una subconsulta correlacionada se evalúa lógicamente |
  |				   cada vez que el sistema recupera una nueva fila de la consulta externa   |
  |-----------------------------------------------------------------------------------------| */

-- ==============================
-- === CONSULTA AUTOCONTENIDA ===
-- ==============================

-- La subconsulta autocontenida que se utiliza con el operador =. Se puede utilizar cualquier 
-- operador de comparación, siempre que la consulta interna devuelva exactamente una fila.

--Obtener los productos donde su categoria sea igual a 'Bikes' --
SELECT ProductID, Name, ProductNumber
FROM Production.Product
WHERE ProductSubcategoryID IN 
	(SELECT ProductSubcategoryID FROM [Production].[ProductSubcategory] WHERE ProductCategoryID =
        (SELECT ProductCategoryID FROM [Production].[ProductCategory] WHERE Name = 'Bikes'))

/* Obtenga los números de los empleados y las fechas de ingreso de todos los empleados con fechas 
   de ingreso iguales a la fecha más antigua */
USE sample
SELECT emp_no,enter_date
FROM [HumanResources].[Employee]
WHERE enter_date =
	(SELECT MIN(enter_date) FROM works_on)


-- ===============================
-- === CONSULTA CORRELACIONADA ===
-- ===============================

-- Una subconsulta correlacionada es una consulta que depende de la consulta externa para obtener 
-- sus valores. Se ejecuta varias veces, una vez por cada fila que la consulta externa pueda 
-- seleccionar.