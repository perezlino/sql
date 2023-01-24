-- ======================================================
-- =============== TIPOS DATOS NUMERICOS ================
-- ======================================================

-- ===============
-- === DECIMAL ===
-- ===============
   
-- Ejemplo 1:

DECLARE @num AS DEC(5,2)
DECLARE @num1 AS DEC(5,2)
DECLARE @num2 AS DEC(5,2)
DECLARE @num3 AS DEC(5,2)
DECLARE @num4 AS DEC(5,2)
DECLARE @num5 AS DEC(5,2)


SET @num = 123
SET @num1 = 123.1
SET @num2 = 123.12
SET @num3 = 123.123
SET @num4 = 123.126
SET @num5 = 1234

SELECT @num   -- 123.00
SELECT @num1  -- 123.10
SELECT @num2  -- 123.12
SELECT @num3  -- 123.12
SELECT @num4  -- 123.13
SELECT @num5  -- Error --> Arithmetic overflow error converting int to data type numeric.

-- Ejemplo 2:

DECLARE @num AS DEC(3,0)
DECLARE @num1 AS DEC(3,0)
DECLARE @num2 AS DEC(3,0)
DECLARE @num3 AS DEC(3,0)
DECLARE @num4 AS DEC(3,0)
DECLARE @num5 AS DEC(3,0)

SET @num = 123
SET @num1 = 123.1
SET @num2 = 123.12
SET @num3 = 123.123
SET @num4 = 123.75
SET @num5 = 1234

SELECT @num   -- 123
SELECT @num1  -- 123
SELECT @num2  -- 123
SELECT @num3  -- 123
SELECT @num4  -- 124
SELECT @num5  -- Error --> Arithmetic overflow error converting int to data type numeric.

-- ============================================================================================
-- ============================================================================================

/* ===============
   === NUMERIC ===
   ===============

   numeric es funcionalmente idéntico a decimal.  */

-- Ejemplo 1:

DECLARE @num AS NUMERIC(5,2)
DECLARE @num1 AS NUMERIC(5,2)
DECLARE @num2 AS NUMERIC(5,2)
DECLARE @num3 AS NUMERIC(5,2)
DECLARE @num4 AS NUMERIC(5,2)
DECLARE @num5 AS NUMERIC(5,2)


SET @num = 123
SET @num1 = 123.1
SET @num2 = 123.12
SET @num3 = 123.123
SET @num4 = 123.126
SET @num5 = 1234

SELECT @num   -- 123.00
SELECT @num1  -- 123.10
SELECT @num2  -- 123.12
SELECT @num3  -- 123.12
SELECT @num4  -- 123.13
SELECT @num5  -- Error --> Arithmetic overflow error converting int to data type numeric.

-- ============================================================================================
-- ============================================================================================

/* =============
   === FLOAT ===
   =============

   Sintáxis:

                                                float[ (n) ]

-- Ejemplo 1:  */

DECLARE @num AS FLOAT(5)
DECLARE @num1 AS FLOAT(5)
DECLARE @num2 AS FLOAT(5)
DECLARE @num3 AS FLOAT(5)
DECLARE @num4 AS FLOAT(5)
DECLARE @num5 AS FLOAT(5)


SET @num = 123
SET @num1 = 123.1
SET @num2 = 123.12
SET @num3 = 123.123
SET @num4 = 123.126
SET @num5 = 1234567

SELECT @num   -- 123
SELECT @num1  -- 123.1
SELECT @num2  -- 123.12
SELECT @num3  -- 123.123
SELECT @num4  -- 123.126
SELECT @num5  -- 1234567