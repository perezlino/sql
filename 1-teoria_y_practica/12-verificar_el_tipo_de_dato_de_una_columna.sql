-- ======================================================
-- ====== VERIFICAR EL TIPO DE DATOS DE UNA COLUMNA =====
-- ======================================================

USE AdventureWorks2019

-- Verifico el tipo de dato de la columna 'OrderDate' de la tabla SalesOrderHeader
SELECT DATA_TYPE  
FROM information_schema.columns 
WHERE TABLE_NAME='SalesOrderHeader' 
AND COLUMN_NAME='OrderDate'