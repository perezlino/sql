-- ======================================================
-- ================ FUNCIONES DE REDONDEO ===============
-- ======================================================

 /* =============
    === FLOOR ===
    =============

    En SQL Server (Transact-SQL), la función FLOOR devuelve el mayor valor entero que es igual o menor que 
    un número.

    Sintaxis:

    La sintaxis de la función FLOOR en SQL Server (Transact-SQL) es:

                                                FLOOR( número )


    Ejemplos:  */

    SELECT FLOOR(5.9);
    -- Resultado: 5

    SELECT FLOOR(34.29);
    -- Resultado: 34

    SELECT FLOOR(-5.9);
    -- Resultado: -6

-- ============================================================================================
-- ============================================================================================

 /* ===============
    === CEILING ===
    ===============

    En SQL Server (Transact-SQL), la función CEILING devuelve el valor entero más pequeño que es mayor o 
    igual que un número.

    Sintaxis:

    La sintaxis de la función CEILING en SQL Server (Transact-SQL) es:

                                                CEILING( número )


    Ejemplos:  */

    SELECT CEILING(32.65);
    -- Resultado: 33

    SELECT CEILING(32.1);
    -- Resultado: 33

    SELECT CEILING(32);
    -- Resultado: 32

    SELECT CEILING(-32.65);
    -- Resultado: -32

    SELECT CEILING(-32);
    -- Resultado: -32

-- ============================================================================================
-- ============================================================================================

 /* =============
    === ROUND ===
    =============

    En SQL Server (Transact-SQL), la función ROUND devuelve un número redondeado a un determinado número 
    de decimales.

    Sintaxis:

    La sintaxis de la función ROUND en SQL Server (Transact-SQL) es:

                            ROUND( número, lugares_decimales [, operación ] )


    Parámetros o argumentos:
    ========================

    "numero": El número a redondear.

    "lugares_decimales": El número de decimales al que se redondea. Este valor debe ser un entero positivo 
                         o negativo. Si se omite este parámetro, la función ROUND redondeará el número a 0 
                         decimales.

    "operación": Opcional. La operación puede ser 0 o cualquier otro valor numérico. Cuando es 0 (o se omite
                 este parámetro), la función ROUND redondeará el resultado al número de "lugares_decimales". 
                 Si "operación" es cualquier valor distinto de 0, la función ROUND truncará el resultado al 
                 número de "lugares_decimales".

    Nota
    ====

    Si el parámetro "operación" es 0 (o no se proporciona), la función ROUND redondeará el resultado al número 
    de "lugares_decimales".

    Si el parámetro "operación" es distinto de cero, la función ROUND truncará el resultado al número de 
    "lugares_decimales".


    Ejemplos:  */

    SELECT ROUND(125.315, 2);
    -- Resultado: 125.320    (el resultado se redondea porque se omite el tercer parámetro)

    SELECT ROUND(125.315, 2, 0);
    -- Resultado: 125.320    (el resultado se redondea porque el 3er parámetro es 0)

    SELECT ROUND(125.315, 2, 1);
    -- Resultado: 125.310    (el resultado se trunca porque el tercer parámetro es distinto de cero)

    SELECT ROUND(125.315, 1);
    -- Resultado: 125.300    (el resultado se redondea porque se omite el tercer parámetro)

    SELECT ROUND(125.315, 0);
    -- Resultado: 125.000    (el resultado se redondea porque se omite el tercer parámetro)

    SELECT ROUND(125.315, -1);
    -- Resultado: 130.000    (el resultado se redondea porque se omite el tercer parámetro)

    SELECT ROUND(125.315, -2);
    -- Resultado: 100.000    (el resultado se redondea porque se omite el tercer parámetro)