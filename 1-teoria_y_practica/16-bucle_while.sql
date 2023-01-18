-- ======================================================
-- ===================== BUCLE WHILE ====================
-- ======================================================

/* La sentencia WHILE es una sentencia de flujo de control que permite ejecutar un bloque 
   de sentencias repetidamente mientras una condición especificada sea TRUE.

A continuación se ilustra la sintaxis de la sentencia WHILE:

								WHILE Boolean_expression   
									{ sql_statement | statement_block}  

En esta sintaxis:

Primero, la <Boolean_expression> es una expresión que se evalúa como TRUE o FALSE. Segundo, 
<sql_statement | statement_block> es cualquier sentencia Transact-SQL o un conjunto de sentencias 
Transact-SQL. Un bloque de sentencias se define utilizando la sentencia BEGIN...END. Si la 
expresión <Boolean_expression> se evalúa como FALSE al entrar en el bucle, no se ejecutará ninguna 
sentencia dentro del bucle WHILE.

Dentro del bucle WHILE, debe cambiar algunas variables para hacer que la <Boolean_expression> 
devuelva FALSE en algunos puntos. De lo contrario, tendrá un bucle indefinido.

Tenga en cuenta que si la <Boolean_expression> contiene una sentencia SELECT, debe ir entre 
paréntesis.

Para salir inmediatamente de la iteración actual del bucle, se utiliza la sentencia BREAK. Para saltar 
la iteración actual del bucle e iniciar una nueva, se utiliza la sentencia CONTINUE.

*/

-- Ejemplo de WHILE en SQL Server

-- El siguiente ejemplo ilustra cómo utilizar la sentencia WHILE para imprimir números del 1 al 5:

DECLARE @counter INT = 1

WHILE @counter <= 5
BEGIN
    PRINT @counter
    SET @counter = @counter + 1
END
-- Output:
-- 1
-- 2
-- 3
-- 4
-- 5

-- ============================================================================================
-- ============================================================================================

-- =============
-- === BREAK ===
-- =============

-- Para salir de la iteración actual de un bucle, se utiliza la sentencia BREAK.

/* A continuación se ilustra la sintaxis típica de la sentencia BREAK:

										WHILE Boolean_expression
										BEGIN
											-- statements
										IF condition
												BREAK;
											-- other statements    
										END

En esta sintaxis, la sentencia BREAK sale inmediatamente del bucle WHILE una vez que se cumple la 
condición especificada en la sentencia IF. Todas las sentencias entre las palabras clave BREAK y 
END se omiten.

Supongamos que tenemos un bucle WHILE anidado dentro de otro bucle WHILE:

										WHILE Boolean_expression1
										BEGIN
											-- statement
											WHILE Boolean_expression2
											BEGIN
												IF condition
													BREAK;
											END
										END

En este caso, la sentencia BREAK sólo sale del bucle más interno de la sentencia WHILE.

Tenga en cuenta que la sentencia BREAK sólo puede utilizarse dentro del bucle WHILE. La sentencia IF 
se usa a menudo con la sentencia BREAK pero no es necesaria.

*/

-- Ejemplo de sentencia BREAK de SQL Server

-- El siguiente ejemplo ilustra como usar la sentencia BREAK:

DECLARE @counter INT = 0

WHILE @counter <= 5
BEGIN
    SET @counter = @counter + 1
    IF @counter = 4
        BREAK
    PRINT @counter
END
-- Output:
-- 1
-- 2
-- 3

-- ============================================================================================
-- ============================================================================================

-- ================
-- === CONTINUE ===
-- ================

/* La sentencia CONTINUE detiene la iteración actual del bucle e inicia la nueva. A continuación 
   se ilustra la sintaxis de la sentencia CONTINUE:

								WHILE Boolean_expression
								BEGIN
									-- code to be executed
									IF condition
										CONTINUE;
									-- code will be skipped if the condition is met
								END

En esta sintaxis, la iteración actual del bucle se detiene una vez que la condición se evalúa 
como TRUE. La siguiente iteración del bucle continuará hasta que la <Boolean_expression> se 
evalúe como FALSE.

Similar a la sentencia BREAK, la sentencia CONTINUE se utiliza a menudo junto con una sentencia IF. 
Tenga en cuenta que esto no es obligatorio.

*/

-- Ejemplo de CONTINUE en SQL Server

-- El siguiente ejemplo ilustra el funcionamiento de la sentencia CONTINUE.

DECLARE @counter INT = 0

WHILE @counter < 5
BEGIN
    SET @counter = @counter + 1
    IF @counter = 3
        CONTINUE	
    PRINT @counter
END
-- Output:
-- 1
-- 2
-- 4
-- 5

-- ============================================================================================
-- ============================================================================================
/*
|------------------------------------------------------------------------------------------|
|  Un bloque dentro de la sentencia WHILE puede contener opcionalmente una de las dos      |
|  sentencias utilizadas para controlar la ejecución de las sentencias dentro del bloque:  |
|  BREAK o CONTINUE. La sentencia BREAK detiene la ejecución de las sentencias dentro del  |
|  bloque e inicia la ejecución de la sentencia inmediatamente posterior a este bloque.    |
|  La sentencia CONTINUE detiene la ejecución actual de las sentencias del bloque e inicia |
|  la ejecución del bloque desde su inicio.                                                |
|------------------------------------------------------------------------------------------|

/* El presupuesto de todos los proyectos se incrementará en un 10 por ciento hasta que la 
   suma de los presupuestos sea superior a 500.000 dólares (Mientras la suma total de budget
   sea menor a 500.000, se seguira ejecutando el batch). Sin embargo, la ejecución 
   repetida se detendrá si el presupuesto de uno de los proyectos es superior a 240.000 
   dólares */

WHILE (SELECT SUM(budget)
       FROM project) < 500000
BEGIN
    UPDATE project SET budget = budget*1.1
    IF (SELECT MAX(budget)
        FROM project) > 240000
        BREAK
    ELSE CONTINUE
END

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 2

DECLARE @i INT = 1

WHILE @i <= 5
BEGIN 
	PRINT 'Iteracion N°' + CAST(@i AS VARCHAR)
	SET @i = @i + 1
END
-- Iteracion N°1 
-- Iteracion N°2 
-- Iteracion N°3 
-- Iteracion N°4 
-- Iteracion N°5

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 3

DECLARE @i INT = 1

WHILE @i <= 10
BEGIN
	IF @i%2 = 0
		PRINT 'Iteracion N°' + CAST(@i AS VARCHAR)
		SET @i = @i + 1
END
-- Iteracion N°2 
-- Iteracion N°4 
-- Iteracion N°6 
-- Iteracion N°8 
-- Iteracion N°10

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 4

DECLARE @i INT = 1

WHILE @i <= 10
BEGIN
	IF @i = 5
		BEGIN
			PRINT 'Iteracion N°' + CAST(@i AS VARCHAR)	
			BREAK
		END
	ELSE
	SET @i = @i + 1
END
-- Iteracion N°5

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 5

DECLARE @i INT = 0

WHILE @i <= 10
BEGIN
	SET @i = @i + 1
	IF @i = 5
		CONTINUE
	PRINT 'Iteracion N°' + CAST(@i AS VARCHAR)	
END
-- Iteracion N°1 
-- Iteracion N°2 
-- Iteracion N°3 
-- Iteracion N°4 
-- Iteracion N°6 
-- Iteracion N°7 
-- Iteracion N°8 
-- Iteracion N°9 
-- Iteracion N°10 
-- Iteracion N°11

-- ============================================================================================
-- ============================================================================================

-- Ejemplo 6

DECLARE @i INT = 0

WHILE @i <= 10
BEGIN
	SET @i = @i + 1
	IF @i = 5
		BREAK
	PRINT 'Iteracion N°' + CAST(@i AS VARCHAR)		
END
-- Iteracion N°1 
-- Iteracion N°2 
-- Iteracion N°3 
-- Iteracion N°4